/*********************************************************************************
* Class Name: TMPartnerBROpptyShare
* Author: HP
* Date: 21-AUG-2013 
* Requirement:R6 # Request Id:CR-11429
* Description: This is a class that performs sharing of Opptys to BRs.
***********************************************************************************/
public class TMPartnerBROpptyShare{
    public static void createOpptyShare(List<Channel_Partner__c> acpList){
        Map<Id,List<Id>> accOpptyMap = new Map<Id,List<Id>>();
        Map<Id,List<String>> accGrpMap = new Map<Id,List<String>>();
        List<OpportunityShare> opptyShareList = new List<OpportunityShare>();
        
        for(Channel_Partner__c acp:acpList){
            if(!accOpptyMap.containsKey(acp.Channel_Partner__c)){
                List<Id> opptyIdList = new List<Id>();
                opptyIdList.add(acp.Opportunity__c);
                accOpptyMap.put(acp.Channel_Partner__c,opptyIdList);
            }else{
                accOpptyMap.get(acp.Channel_Partner__c).add(acp.Opportunity__c);
            }
        }
        
        for(Sales_Territory_Account_Assignment__c staa:[Select account__c,Sales_Territory__r.GroupID__c From Sales_Territory_Account_Assignment__c Where account__c In :accOpptyMap.keySet() AND Sales_Territory__r.IsPartner__c = true AND Sales_Territory__r.IsExternal__c = false AND Sales_Territory__r.IsActive__c = true]){
            if(!accGrpMap.containsKey(staa.account__c)){
                List<Id> relGrpIdList = new List<Id>();
                relGrpIdList.add(staa.Sales_Territory__r.GroupID__c);
                accGrpMap.put(staa.account__c,relGrpIdList);
            }else{
                accGrpMap.get(staa.account__c).add(staa.Sales_Territory__r.GroupID__c);
            }
        }
        
         for(Id accId:accGrpMap.keySet()){
            List<String> grpIdList = accGrpMap.get(accId);
            if(grpIdList != null){
                for(String grpId:grpIdList){
                    if(grpId != ''){
                        if(accOpptyMap.containsKey(accId)){
                            List<Id> opptyIdList = accOpptyMap.get(accId);
                            if(opptyIdList != null){
                                for(Id opptyId:opptyIdList){
                                    OpportunityShare opptyShareRecord = new OpportunityShare(OpportunityId = opptyId,UserOrGroupId = grpId,OpportunityAccessLevel = 'Read');
                                    opptyShareList.add(opptyShareRecord);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        Database.SaveResult[] opptyShareResultArray;
        try{
            opptyShareResultArray = Database.insert(opptyShareList,false);
        }catch(DmlException e){
            CreateApexErrorLog.insertHandledExceptions(e, opptyShareResultArray, 'Opportunity__c', 'TMPartnerBROpptyShare', 'Class');
        }
    }
}