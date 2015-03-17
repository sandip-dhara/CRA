/***************************************************************************************************
* Class Name: TMPartnerOpportunityShareController 
* Author: HP
* Date: 08-OCT-2013 
* Requirement # Request Id: 7525
* Description: This is a Util class that performs add/remove sharing of Opptys to Partner Territories.
****************************************************************************************************/
public class TMPartnerOpportunityShareController{

    /**
    * @description: Remove oppty share to Partner Territories
    * @param: Map<Id,Opportunity> opptyMap    
    * @return: void
    **/ 
    public static void removeOpptyShareForPartnerTerritories(Map<Id,Opportunity> opptyMap){
    
        final String groupKeyPrefix = Group.sObjectType.getDescribe().getKeyPrefix();
        
        Set<OpportunityShare> optyShareSet= new Set<OpportunityShare>([Select UserOrGroupId From OpportunityShare Where OpportunityId In :opptyMap.keySet()]);
        Set<String> grpIdSet = new Set<String>();
        
        if(optyShareSet != null && optyShareSet.size() > 0){
            for(OpportunityShare optyShare: optyShareSet){
                String grpId = optyShare.UserOrGroupId;
                if(grpId.startsWith(groupKeyPrefix)){
                    grpIdSet.add(grpId);
                }
            }
        }
        if(null == grpIdSet || grpIdSet.size() <= 0){
            return;
        }
        
        List<Sales_Territory__c> salesTerrList = [Select GroupID__c From Sales_Territory__c Where GroupID__c In :grpIdSet And isPartner__c = true];
        Set<Id> prtGrpIdSet = new Set<Id>();
        if(null != salesTerrList && salesTerrList.size() > 0){
            for(Sales_Territory__c sterr: salesTerrList){
                prtGrpIdSet.add(sterr.GroupID__c);
            }
        }
        if(null == prtGrpIdSet || prtGrpIdSet.size() <= 0){
            return;
        }
        
        List<OpportunityShare> optyShareToRemoveList = [Select Id From OpportunityShare Where OpportunityId In :opptyMap.keySet() And UserOrGroupId In :prtGrpIdSet];
        
        try{
            if(null != optyShareToRemoveList && optyShareToRemoveList.size() > 0){
                Database.DeleteResult[] delRes = Database.delete(optyShareToRemoveList,false);
            }
        }catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Opportunity__c', 'TMPartnerOpportunityShareController', 'Class');
        }
        
    }
    
    /**
    * @description: Create oppty share to Partner Territories
    * @param: Map<Id,Opportunity> opptyMap    
    * @return: void
    **/    
public static void addOpptyShareForPartnerTerritories(Map<Id,Opportunity> opptyMap){
    Map<Id,Opportunity> optyConfStatusMap = new Map<Id,Opportunity>([Select Id,Confidential__c,Account.Confidential_Account__c From Opportunity Where Id In :opptyMap.keySet()]);
    Map<Id,Opportunity> nonConfOpptyMap = new Map<Id,Opportunity>();
    for(Opportunity opty:optyConfStatusMap.values()){
        if(opty.Confidential__c != true && opty.Account.Confidential_Account__c != true){
            nonConfOpptyMap.put(opty.id,opty);
        }
    }
    if(null != nonConfOpptyMap && !nonConfOpptyMap.isEmpty()){
        createOpptyShareForNonExternalTerritories(nonConfOpptyMap);
        createOpptyShareForExternalTerritories(nonConfOpptyMap);
    }
}

    /**
    * @description: Create oppty share for External Partner Territories
    * @param: Map<Id,Opportunity> opptyMap    
    * @return: void
    **/ 
public static void createOpptyShareForExternalTerritories(Map<Id,Opportunity> opptyMap){
    Map<Id,Id> optyIdLocIdMap = new Map<Id,Id>();
    Map<Id,List<String>> locIdGroupMap = new Map<Id,List<String>>();
    Map<Id,List<String>> opIdGroupMap = new Map<Id,List<String>>();
    List<OpportunityShare> opptyShareList = new List<OpportunityShare>();
    
    for(OpportunityTeamMember optyTeamMem:[Select User.Location_Record_Id__c,OpportunityId from OpportunityTeamMember Where OpportunityId In :opptyMap.keySet() And user.User_Type_Text__c  = 'PowerPartner']){
        if(!optyIdLocIdMap.containsKey(optyTeamMem.OpportunityId)){
            optyIdLocIdMap.put(optyTeamMem.OpportunityId,optyTeamMem.User.Location_Record_Id__c);
        }
    }
    
    for(Opportunity opty:[Select Id,Owner.Location_Record_Id__c from Opportunity Where Id In :opptyMap.keySet() And Owner.User_Type_Text__c = 'PowerPartner']){
        if(!optyIdLocIdMap.containsKey(opty.Id)){
            optyIdLocIdMap.put(opty.Id,opty.Owner.Location_Record_Id__c);
        }
    }
    
    for(Sales_Territory_Location_Assignment__c stla: [Select Location__c,Sales_Territory__r.GroupID__c From Sales_Territory_Location_Assignment__c Where Location__c In :optyIdLocIdMap.values() And Sales_Territory__r.IsActive__c = true And Sales_Territory__r.IsPartner__c = true And Sales_Territory__r.isExternal__c = true]){
        List<String> groupList = new List<String>();
        if(!locIdGroupMap.containsKey(stla.Location__c)){ 
            if(!String.isBlank(String.valueOf(stla.Sales_Territory__r.GroupID__c))){
                groupList.add(stla.Sales_Territory__r.GroupID__c);
                locIdGroupMap.put(stla.Location__c,groupList);
            }
        }else{
            if(!String.isBlank(String.valueOf(stla.Sales_Territory__r.GroupID__c))){
                locIdGroupMap.get(stla.Location__c).add(stla.Sales_Territory__r.GroupID__c);
            }
        }
    }
    
    if(null != locIdGroupMap && !locIdGroupMap.isEmpty()){
        for(Id opId: optyIdLocIdMap.keySet()){
            if(locIdGroupMap.containsKey(optyIdLocIdMap.get(opId))){
                opIdGroupMap.put(opId,locIdGroupMap.get(optyIdLocIdMap.get(opId)));
            }
        }
    }
    
    if(null != opIdGroupMap && !opIdGroupMap.isEmpty()){
        for(Id opId: opIdGroupMap.keySet()){
            if(opIdGroupMap.containsKey(opId)){
                for(String grp: opIdGroupMap.get(opId)){
                    OpportunityShare optyShareRec = new OpportunityShare(UserOrGroupId = grp,OpportunityId = opId,OpportunityAccessLevel = 'Read');
                    opptyShareList.add(optyShareRec);
                }
            }
        }
    }
    
    Database.SaveResult[] saveResults;
    try{  
        if(null != opptyShareList && !opptyShareList.isEmpty()){
            saveResults = Database.insert(opptyShareList,false);
        }
    }catch(Exception e){
        CreateApexErrorLog.insertHandledExceptions(e, saveResults, 'Opportunity__c', 'TMPartnerOpportunityShareController', 'Class');
    }
}

    /**
    * @description: Create oppty share for Non-External Partner Territories
    * @param: Map<Id,Opportunity> opptyMap    
    * @return: void
    **/
public static void createOpptyShareForNonExternalTerritories(Map<Id,Opportunity> opptyMap){
    Map<Id,List<Channel_Partner__c>> opptyAcpMap = new Map<Id,List<Channel_Partner__c>>();
    Map<Id,List<Id>> opptyBRMap = new Map<Id,List<Id>>();
    Map<Id,List<Id>> opptyLocMap = new Map<Id,List<Id>>();
    Map<Id,Set<String>> optyGroupMap = new Map<Id,Set<String>>();
    Map<Id,List<String>> locGroupMap = new Map<Id,List<String>>();
    Map<Id,List<String>> brGroupMap = new Map<Id,List<String>>();
    Set<Id> locIdSet = new Set<Id>();
    Set<Id> brIdSet = new Set<Id>();
    List<OpportunityShare> optyShareList = new List<OpportunityShare>();
    
    for(Channel_Partner__c acp:[Select Channel_partner__c,Location__c,Opportunity__c From Channel_Partner__c Where Opportunity__c In :opptyMap.keySet()]){
        if(!opptyAcpMap.containsKey(acp.Opportunity__c)){
            List<Channel_Partner__c> acpList = new List<Channel_Partner__c>();
            acpList.add(acp);
            opptyAcpMap.put(acp.Opportunity__c,acpList);
        }else{
            opptyAcpMap.get(acp.Opportunity__c).add(acp);
        }
    }
    if(opptyAcpMap != null && !opptyAcpMap.isEmpty()){
        for(Id optyId:opptyACPMap.keySet()){
            List<Id> brIdList = new List<Id>();
            List<Id> locIdList = new List<Id>();
            for(Channel_Partner__c acp:opptyAcpMap.get(optyId)){
                brIdList.add(acp.Channel_partner__c);
                locIdList.add(acp.Location__c);
                brIdSet.add(acp.Channel_partner__c);
                locIdSet.add(acp.Location__c);
            }
            opptyBRMap.put(optyId,brIdList);
            opptyLocMap.put(optyId,locIdList);
        }
    }
    
    for(Sales_Territory_Location_Assignment__c stla:[Select Location__c,Sales_Territory__r.GroupID__c From Sales_Territory_Location_Assignment__c Where Location__c In :locIdSet And Sales_Territory__r.IsActive__c = true And Sales_Territory__r.IsPartner__c = true And Sales_Territory__r.isExternal__c = false]){
        if(!locGroupMap.containsKey(stla.Location__c)){
            List<String> groupIdList = new List<String>();
            if(null != stla.Sales_Territory__r.GroupID__c && !String.isBlank(stla.Sales_Territory__r.GroupID__c)){
                groupIdList.add(stla.Sales_Territory__r.GroupID__c);
                locGroupMap.put(stla.Location__c,groupIdList);
            }
        }else{
            if(null != stla.Sales_Territory__r.GroupID__c && !String.isBlank(stla.Sales_Territory__r.GroupID__c)){
                locGroupMap.get(stla.Location__c).add(stla.Sales_Territory__r.GroupID__c);
            }
        }
    }
    
    for(Sales_Territory_Account_Assignment__c staa:[Select Account__c,Sales_Territory__r.GroupID__c From Sales_Territory_Account_Assignment__c Where Account__c In :brIdSet And Sales_Territory__r.IsActive__c = true And Sales_Territory__r.IsPartner__c = true And Sales_Territory__r.isExternal__c = false]){
        if(!brGroupMap.containsKey(staa.Account__c)){
            List<String> groupIdList = new List<String>();
            if(null != staa.Sales_Territory__r.GroupID__c && !String.isBlank(staa.Sales_Territory__r.GroupID__c)){
                groupIdList.add(staa.Sales_Territory__r.GroupID__c);
                brGroupMap.put(staa.Account__c,groupIdList);
            }
        }else{
            if(null != staa.Sales_Territory__r.GroupID__c && !String.isBlank(staa.Sales_Territory__r.GroupID__c)){
                brGroupMap.get(staa.Account__c).add(staa.Sales_Territory__r.GroupID__c);
            }
        }
    }
    
    for(Id optyId:opptyMap.keySet()){
        Set<String> groupIdSet = new Set<String>();
        if(opptyLocMap.containsKey(optyId)){
            for(Id locId:opptyLocMap.get(optyId)){
                if(locGroupMap.containsKey(locId)){
                    groupIdSet.addAll(locGroupMap.get(locId));
                }
            }
            optyGroupMap.put(optyId,groupIdSet);
        }
    }
    
    for(Id optyId:opptyMap.keySet()){
        Set<String> groupIdSet = new Set<String>();
        if(opptyBRMap.containsKey(optyId)){
            for(Id brId:opptyBRMap.get(optyId)){
                if(brGroupMap.containsKey(brId)){
                    groupIdSet.addAll(brGroupMap.get(brId));
                }
            }
            if(optyGroupMap.containsKey(optyId)){
                optyGroupMap.get(optyId).addAll(groupIdSet);
            }
        }
    }
    
    for(Id opId:optyGroupMap.keySet()){
        for(String grpId:optyGroupMap.get(opId)){
            OpportunityShare optyShareRec = new OpportunityShare(OpportunityId = opId,UserOrGroupId = grpId,OpportunityAccessLevel = 'Read');
            optyShareList.add(optyShareRec);
        }
    }
    Database.SaveResult[] saveResultAr;
    try{
        if(null != optyShareList && !optyShareList.isEmpty()){
            saveResultAr = Database.insert(optyShareList,false);
        }
    }catch(Exception e){
        CreateApexErrorLog.insertHandledExceptions(e, saveResultAr, 'Opportunity__c', 'TMPartnerOpportunityShareController', 'Class');
    }
}

}