/*********************************************************************************
* Class Name: TMLocationOpptyShare 
* Author: HP
* Date: 29-JUL-2013 
* Requirement # Request Id: 10319
* Description: This is a class that performs sharing of Opptys to Locations.
***********************************************************************************/
public class TMLocationOpptyShare{

    public static void createOpptyShare(List<Channel_Partner__c>acpList){
        
        Map<Id,List<Id>> locOpptyMap = new Map<Id,List<Id>>();
        Map<Id,List<String>> locGrpMap = new Map<Id,List<String>>();
        List<OpportunityShare> opptyShareList = new List<OpportunityShare>();
        
        //Find related opportunities for every location
        for(Channel_Partner__c acp:acpList){
            if(!locOpptyMap.containsKey(acp.Location__c)){
                List<Id> relOpptyIdList = new List<Id>();
                relOpptyIdList.add(acp.Opportunity__c);
                locOpptyMap.put(acp.Location__c,relOpptyIdList);
            }else{
                locOpptyMap.get(acp.Location__c).add(acp.Opportunity__c);
            }
        }
        //Find corresponding Territory groups for every location
        for(Sales_Territory_Location_Assignment__c stla:[Select location__c,Sales_Territory__r.GroupID__c From Sales_Territory_Location_Assignment__c Where location__c In :locOpptyMap.keySet() AND Sales_Territory__r.IsPartner__c = true AND Sales_Territory__r.IsExternal__c = false AND Sales_Territory__r.IsActive__c = true]){
            if(!locGrpMap.containsKey(stla.location__c)){
                List<Id> relGrpIdList = new List<Id>();
                relGrpIdList.add(stla.Sales_Territory__r.GroupID__c);
                locGrpMap.put(stla.location__c,relGrpIdList);
            }else{
                locGrpMap.get(stla.location__c).add(stla.Sales_Territory__r.GroupID__c);
            }
        }
        
        for(Id locId:locGrpMap.keySet()){
            List<String> grpIdList = locGrpMap.get(locId);
            if(grpIdList != null){
                for(String grpId:grpIdList){
                    if(grpId != ''){
                        if(locOpptyMap.containsKey(locId)){
                            List<Id> opptyIdList = locOpptyMap.get(locId);
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
            CreateApexErrorLog.insertHandledExceptions(e, opptyShareResultArray, 'Opportunity__c', 'TMLocationOpptyShare', 'Class');
        }
    }
}