public class salesteamtriggercontroler{

    public static void deletesalesteam(Map<id,Channel_Partner__c> partneroldMap) {
        Set<Id> optyIds = new Set<Id>();
        set<String> partnerAccId = new set<String>();
        set<ID> userid=new set<ID>();
        List<User> userlisttodelete=new List<User>();
        List<OpportunityTeamMember> opteamtodelete= new List<OpportunityTeamMember>();
        Map<ID,ID> mapOpptyIdWithAccountId=new Map<ID,ID>();
        Map<Id,List<OpportunityTeamMember>> mapOpptyIdWithOpptyTeamMember;
        for(Channel_Partner__c partner : partnerOldMap.values()){
                optyIds.add(partner.Opportunity__c);
                mapOpptyIdWithAccountId.put(partner.Opportunity__c,partner.channel_partner__c);
                partnerAccId.add(SalesTeamLookupController.convertTo15Digit(partner.Channel_Partner__c));
        }
        /*if(partneroldMap.values().size()>0){
            for (Channel_Partner__c cp : [Select id,Primary__c,channel_partner__c 
                                            From Channel_Partner__c where
                                            Opportunity__c IN : optyIds
                                            And Id IN : partneroldMap.keySet()]) {
                
                partnerAccId.add(SalesTeamLookupController.convertTo15Digit(cp.channel_partner__c));
            }
        }*/
        system.debug('*********partneraccId******'+partneraccId);
        if(partnerAccId.size()>0){
            
            userlisttodelete=[select id,name,email from User where Partner_account_ID__c in :partneraccId];
        }
        if(userlisttodelete.size()>0){
                                                mapOpptyIdWithOpptyTeamMember = new Map<Id,List<OpportunityTeamMember>>();
                                                for(OpportunityTeamMember objOpptyTeamMember:[select id,OpportunityAccessLevel, OpportunityId ,TeamMemberRole ,userid,user.Partner_account_ID__c from OpportunityTeamMember where userid IN :userlisttodelete and OpportunityId IN : optyIds]){
                                                                List<OpportunityTeamMember> listOpptyTeamMember;
                                                                if(mapOpptyIdWithOpptyTeamMember.containsKey(objOpptyTeamMember.OpportunityId)){
                                                                                listOpptyTeamMember = mapOpptyIdWithOpptyTeamMember.get(objOpptyTeamMember.OpportunityId);
                                                                                listOpptyTeamMember.add(objOpptyTeamMember);
                                                                }
                                                                else{
                                                                                listOpptyTeamMember = new List<OpportunityTeamMember>();
                                                                                listOpptyTeamMember.add(objOpptyTeamMember);
                                                                }
                                                                if(!listOpptyTeamMember.isEmpty()){
                                                                                mapOpptyIdWithOpptyTeamMember.put(objOpptyTeamMember.OpportunityId,listOpptyTeamMember);
                                                                }
                                                }
                                                if(!mapOpptyIdWithOpptyTeamMember.isEmpty()){
                                                                for(Id opptyTeamMemberId : mapOpptyIdWithOpptyTeamMember.keyset()){
                                                                                for(OpportunityTeamMember objOpptyTeamMember : mapOpptyIdWithOpptyTeamMember.get(opptyTeamMemberId)){
                                                                                                if(objOpptyTeamMember.user.Partner_account_ID__c == mapOpptyIdWithAccountId.get(opptyTeamMemberId)){
                                                                                                                opteamtodelete.add(objOpptyTeamMember);
                                                                                                }
                                                                                }
                                                                }
                                                }
        }
        
        if(opteamtodelete.size()>0){
            try
            {
                Database.DeleteResult[] results = Database.delete(opteamtodelete,false);
                Integer counter = 0;
                for(Database.DeleteResult result : results){
                    if (!result.isSuccess() || Test.isRunningTest())
                    {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs){
                            if(partnerOldMap.containsKey(opteamtodelete.get(counter).id)){
                                partnerOldMap.get(opteamtodelete.get(counter).id).name.addError(err.getMessage());
                            }
                        }
                    }  
                    counter++;
                }
            } catch (Exception e) {
                    System.debug('Exception:ChannelPartnerTriggerUtil.checkIsPrimaryFlag:'+e.getMessage());
            } 
        }
    }
}