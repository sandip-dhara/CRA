public class UpdateOpportunitySharingTriggerUtil
{
    public static void UpdateOpportunitySharing(Map<id,Opportunity>  NewOne,Map<id,Opportunity> Old) 
    {
        list<Id> listOpportunity = new list<Id>();
        Map<id,Channel_Partner__c> partnerNewMap = new Map<id,Channel_Partner__c>();
        for(Id opptyId: NewOne.keyset()){
            if(NewOne.get(opptyId).ownerid != Old.get(opptyId).ownerid){
                listOpportunity.add(opptyId);
            }
        }
        if(!listOpportunity.isEmpty()){
            //TM:R5:Vinay Req-6201-Start
            //Added field name Location__c
            for(Channel_Partner__c objChannel : [select Opportunity__c,Location__c,Partner_Status__c,Partner_Type__c,Primary__c,Regions__c,Channel_Partner__c from Channel_Partner__c where Opportunity__c In:listOpportunity]){
                partnerNewMap.put(objChannel.id,objChannel);
            }
            //TM:R5:Vinay Req-6201-End
        }
        if(!partnerNewMap.isEmpty()){
            PartnerCollabACPUtil.addOpptyShareToPartners(partnerNewMap);
        }
    }
}