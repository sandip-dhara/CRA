/**
* Class Name: PCLM_OppOwnerChngTerrUpdateController
* Author: HP
* Date: 08-JAN-2013 
* Requirement # Request Id: 4043 
* Description: Contains support action methods for trigger on Opportunity object for sharing opportunity to sales
               territory.
*/

public class PCLM_OppOwnerChngTerrUpdateController{
    
    /**
    * @description: Static list of Public group Ids 
    */
    public static List<Id> groupIdList = new List<Id>();
    
    
    /**
    * @description: Adds records in OpportunityShare for every opportunity and associated list of public groups.
    * @params: trigger.newMap;
    * @returns: void
    */
    /*public static void addOpptyShareToPartners(Map<Id,Opportunity> newOpptyMap, list<user> userOpptyOwner){
    
        Map<Id,List<String>> opptyWithTerritoryGroupMap = new Map<Id,List<String>>();
        List<OpportunityShare> opptySharingList = new List<OpportunityShare>();
        
        opptyWithTerritoryGroupMap = OpptyShareForPartners(newOpptyMap, userOpptyOwner);
        
        if(opptyWithTerritoryGroupMap == null){
            return;
        }
        
        for(Id opptyId : opptyWithTerritoryGroupMap.keySet()){
            for(Id groupId : opptyWithTerritoryGroupMap.get(opptyId)){
                OpportunityShare newShareRec = new OpportunityShare(OpportunityAccessLevel = 'Read');
                newShareRec.OpportunityId = opptyId;
                newShareRec.UserOrGroupId = groupId;
                opptySharingList.add(newShareRec);
            }
        }       
        
        if(opptySharingList != null && opptySharingList.size() > 0 ){
            Database.SaveResult[] newShareResults;
            try{
                newShareResults = database.insert(opptySharingList,false);  
            }catch (Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, newShareResults, 'Opportunity__c', 'PCLM_OppOwnerChngTerrUpdateController', 'Class');
            }
        }
    }*/
    
    //TM:Vinay R5:Req:6201:Start
     /**
    * @description: Adds records in OpportunityShare for every opportunity and associated list of public groups.
    * @params: trigger.newMap,list of portal users;
    * @returns: void
    */
    public static void addOpptyShareToPartnersForLocation(Map<Id,Opportunity>  processOptyMap,
                                                                List<User> optyPortalOwnerList){
        Map<Id,List<String>> opptyWithTerritoryGroupMap = new Map<Id,List<String>>();
        List<OpportunityShare> opptyShareList = new List<OpportunityShare>();
        
        opptyWithTerritoryGroupMap = OpptyShareForPartnersViaLocation(processOptyMap,optyPortalOwnerList);
        
        if(opptyWithTerritoryGroupMap == null || opptyWithTerritoryGroupMap.isEmpty()){
            return;
        }
        
        //TM:Vinay R6:Req 7525:Start
        Set<Channel_Partner__c> pvtOpptySet = new Set<Channel_Partner__c>();
        for(Channel_Partner__c pvtOppty:[Select Opportunity__c From Channel_Partner__c Where
         Opportunity__c In:opptyWithTerritoryGroupMap.keySet() And (Opportunity__r.Account.Confidential_Account__c = true
          Or Opportunity__r.Confidential__c = true)]){
            pvtOpptySet.add(pvtOppty);
        }
        
        if(pvtOpptySet != null && pvtOpptySet.size() > 0){
            for(Channel_Partner__c pvtOppty:pvtOpptySet){
                if(opptyWithTerritoryGroupMap.containsKey(pvtOppty.Opportunity__c)){
                    opptyWithTerritoryGroupMap.remove(pvtOppty.Opportunity__c);
                }
            }
        }
        if(opptyWithTerritoryGroupMap == null || opptyWithTerritoryGroupMap.isEmpty()){ 
            return;
        }
        //TM:Vinay R6:Req 7525:End
        
        for(Id optyId: opptyWithTerritoryGroupMap.keySet()){
            for(String grpId: opptyWithTerritoryGroupMap.get(optyId)){
                OpportunityShare newOptyShareRec = new OpportunityShare(OpportunityAccessLevel = 'Read');
                newOptyShareRec.OpportunityId = optyId;
                newOptyShareRec.UserOrGroupId = grpId;
                opptyShareList.add(newOptyShareRec);
            }
        }
        if(opptyShareList != null && opptyShareList.size() > 0){
            Database.SaveResult[] newShareResults;
            try{
                newShareResults = database.insert(opptyShareList,false);
            }catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, newShareResults, 'Opportunity__c', 'OpptyACPUtil', 'Class');
            }
        }
    }
    //TM:Vinay R5:Req:6201:End
    
    /**
    * @description: Deletes records from OpportnityShare when Owner is changed from Partner User to Non-partner User.
    * @params: trigger.newMap,trigger.oldMap;
    * @returns: void
    */
    /*public static void removeOpptyShareToPartners(Map<Id,Opportunity> oldMap, list<user> userOpptyownerlist){
        Map<Id,List<String>> opptyWithTerritoryGroupMap = new Map<Id,List<String>>(); 
        List<OpportunityShare> currentOpptySharingList = new List<OpportunityShare>(); 
        List<OpportunityShare> deleteOpptySharingList = new List<OpportunityShare>(); 
        Set<Id> opptyIdSet = new Set<Id>();
        
        opptyWithTerritoryGroupMap = OpptyShareForPartners(oldMap, userOpptyownerlist);
        
        if(opptyWithTerritoryGroupMap == null){
            return;
        }
        
        opptyIdSet = opptyWithTerritoryGroupMap.keySet();
        
        currentOpptySharingList = [SELECT OpportunityId,UserOrGroupId FROM OpportunityShare WHERE opportunityId IN: opptyIdSet AND UserOrGroupId IN: groupIdList];
        
        for(OpportunityShare opptySharing : currentOpptySharingList){
            if(opptyWithTerritoryGroupMap.containsKey(opptySharing.OpportunityId)){
                for(Id groupId : opptyWithTerritoryGroupMap.get(opptySharing.OpportunityId)){
                    if(groupId == opptySharing.UserOrGroupId){
                        deleteOpptySharingList.add(opptySharing);
                        system.debug('the userGroupId is '+ opptySharing.userOrGroupId);
                    }
                }
            }
        }
        
         try{        
            if(deleteOpptySharingList != null && deleteOpptySharingList.size() > 0 ){
                Database.DeleteResult[] newShareResults = database.delete(deleteOpptySharingList,false);  
            }
        }catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Opportunity__c', 'OpptyACPUtil', 'Class');
        }
        
    }*/
    /**
    * @description: Deletes records from OpportnityShare when Owner is changed from Partner User to Non-partner User.
    * @params: list<Users>,trigger.oldMap;
    * @returns: void
    */
    public static void removeOpptyShareToPartnersForLocation(Map<Id,Opportunity> oldMap,List<User> optyOwnerList){
        Map<Id,List<String>> opptyWithTerritoryGroupMap;
        List<OpportunityShare> currentOptySharingList;
        List<OpportunityShare> deleteOptySharingList = new List<OpportunityShare>();
        Set<Id> opptyIdSet = new Set<Id>();
        
        opptyWithTerritoryGroupMap = OpptyShareForPartnersViaLocation(oldMap, optyOwnerList);
        
        if(opptyWithTerritoryGroupMap == null){
            return;
        }
        
        opptyIdSet = opptyWithTerritoryGroupMap.keySet();
        currentOptySharingList = new List<OpportunityShare>([Select OpportunityId,UserOrGroupId FROM OpportunityShare WHERE opportunityId IN:opptyIdSet]);
        
        for(OpportunityShare optyShare: currentOptySharingList){
            if(opptyWithTerritoryGroupMap.containsKey(optyShare.OpportunityId)){
                for(Id groupId: opptyWithTerritoryGroupMap.get(optyShare.OpportunityId)){
                    if(groupId == optyShare.UserOrGroupId){
                        deleteOptySharingList.add(optyShare);
                    }
                }
            }
        }
         try{        
            if(deleteOptySharingList != null && deleteOptySharingList.size() > 0 ){
                Database.DeleteResult[] newShareResults = database.delete(deleteOptySharingList,false);  
            }
        }catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Opportunity__c', 'PCLM_OppOwnerChngTerrUpdateController', 'Class');
        }
        
    }

    /**
    * @description: Fetches related list of public groups for opportunities.
    * @params: Map<Id,Opportunity>;
    * @returns: map of opportunity with the corresponding list of public groups to which it should be shared.
    */    
    /*private static Map<Id,List<String>> OpptyShareForPartners(Map<Id,Opportunity> newOpptyMap, list<user> userOwnerOpptylist){

        Map<Id,Id>partnerAccWithOpptyMap = new Map<Id,Id>(); 
        Map<Id,Sales_Territory_Account_Assignment__c> accWithTerritoryMap; 
        Set<Id> territoryIdOfPartnerSet = new Set<Id>(); 
        Map<Id,Sales_Territory__c> partnerTerritoryMap; 
        Map<Id,List<Id>> opptyWithTerritoryMap = new Map<Id,List<Id>>(); 
        Map<Id,List<String>> opptyWithTerritoryGroupMap = new Map<id,List<String>>(); 
        Set<id> oppOwnerIdSet = new Set<id>();
        Map<id, id> ownerPartnerAccIdMap = new Map<id,id>();
        
        for(Opportunity oppt:newOpptyMap.values()){
            oppOwnerIdSet.add(oppt.ownerId);
        }
        
        for(user u : userOwnerOpptylist){
            ownerPartnerAccIdMap.put(u.id, u.partner_account_Id__c);
        }
        
        for(Opportunity oppty:newOpptyMap.values()){
            system.debug('check portal enabled' + 'id is '+ oppty.ownerId + '   ' + oppty.Owner.IsPortalEnabled);
            
                partnerAccWithOpptyMap.put(oppty.Id,ownerPartnerAccIdMap.get(oppty.ownerId));
                system.debug('inside this loop' + oppty.Owner.Partner_Account_Id__c + 'oppty ID'+oppty.ID);
            
        }
        
        List<Id> partnerAccIdMap = partnerAccWithOpptyMap.values();
        
        accWithTerritoryMap = new Map<Id,Sales_Territory_Account_Assignment__c>([SELECT Id,Account__c,Sales_Territory__c FROM Sales_Territory_Account_Assignment__c WHERE Account__c IN: partnerAccIdMap AND Sales_Territory__r.isPartner__c= true AND Sales_Territory__r.isExternal__c=true]);
        
        if(accWithTerritoryMap == null || accWithTerritoryMap.isEmpty()){
            return null;
        }
        
        for(Opportunity oppty : newOpptyMap.Values()){
            for(Sales_Territory_Account_Assignment__c accWithTerrRec : accWithTerritoryMap.values()){
                if((ownerPartnerAccIdMap.get(oppty.ownerId) == accWithTerrRec.Account__c) && (accWithTerrRec.Account__c != null) && String.ValueOf(accWithTerrRec.Account__c) != ''){
                    territoryIdOfPartnerSet.add(accWithTerrRec.Sales_Territory__c);
                }
                if(opptyWithTerritoryMap.containsKey(oppty.Id)){
                    List<Id> relatedTerrIds = opptyWithTerritoryMap.get(oppty.id);
                    relatedTerrIds.add(accWithTerrRec.Sales_Territory__c);
                    opptyWithTerritoryMap.put(oppty.Id, relatedTerrIds);
                }else{
                    opptyWithTerritoryMap.put(oppty.Id,new List<Id>{accWithTerrRec.Sales_Territory__c});
                }
            }
        }
        
        partnerTerritoryMap = new Map<Id,Sales_Territory__c>([SELECT Id,GroupId__c FROM Sales_Territory__c WHERE Id IN: territoryIdOfPartnerSet]);
        
        if(partnerTerritoryMap == null || partnerTerritoryMap.isEmpty()){
            return null;
        }
        
        for(Id opptyId: opptyWithTerritoryMap.KeySet()){
            List<String> relatedGrpIds = new List<String>();
            for(Id terrId: opptyWithTerritoryMap.get(opptyId)){
                if(partnerTerritoryMap.get(terrId).GroupID__c !=null && String.ValueOf(partnerTerritoryMap.get(terrId).GroupID__c) !=''){
                    relatedGrpIds.add(partnerTerritoryMap.get(terrId).GroupID__c);
                    groupIdList.add(partnerTerritoryMap.get(terrId).GroupID__c);
                }
            }
            opptyWithTerritoryGroupMap.put(opptyId,relatedGrpIds);
        }
        
        if(opptyWithTerritoryGroupMap == null && opptyWithTerritoryGroupMap.isEmpty()){
            return null;
        }else{
            return opptyWithTerritoryGroupMap;
        }
    }*/
    
    //TM:Vinay R5:Req:6201:Start
    /**
    * @description: Fetches related list of public groups for opportunities based on locations.
    * @params: Map<Id,Opportunity>,List<User>;
    * @returns: map of opportunity with the corresponding list of public groups to which it should be shared.
    */   
    public static Map<Id,List<String>> OpptyShareForPartnersViaLocation(Map<Id,Opportunity>  processOptyMap,
                                                                List<User> optyPortalOwnerList){
        Set<Id> optyOwnerContactIdSet = new Set<Id>();
        Map<Id,Id> userIdLocationMap = new Map<Id,Id>();
        Map<Id,Id> contactLocMap = new Map<Id,Id>();
        Map<Id,Id> optyLocIdMap = new Map<Id,Id>();
        List<Id> locationIdList = new List<Id>();
        Set<Id> territoryIdSet = new Set<Id>();
        Map<Id,List<Id>> opportunityTerritoryMap = new Map<Id,List<Id>>();
        Map<Id,List<String>> opportunityTerritoryPubGrpMap = new Map<Id,List<String>>();
        Map<Id,Sales_Territory__c> locationTerritoryMap;
        
        for(User u:optyPortalOwnerList){
            optyOwnerContactIdSet.add(u.contactId);
        }
        for(Location_Partner_Users__c lpUser: [Select location__c,contact__c from Location_Partner_Users__c where contact__c IN: optyOwnerContactIdSet]){
            contactLocMap.put(lpUser.contact__c,lpUser.Location__c);
        }
        for(User u: optyPortalOwnerList){
            userIdLocationMap.put(u.id,contactLocMap.get(u.contactId));
        }
        for(Opportunity opty: processOptyMap.values()){
            optyLocIdMap.put(opty.id,userIdLocationMap.get(opty.ownerId));
        }
        
        locationIdList = optyLocIdMap.values();
        
        Map<Id,Sales_Territory_Location_Assignment__c> locWithTerritoryMap = new Map<Id,Sales_Territory_Location_Assignment__c>([Select Id,Location__c,Sales_Territory__c From Sales_Territory_Location_Assignment__c Where Location__c IN: locationIdList AND Sales_Territory__r.isPartner__c = true AND Sales_Territory__r.isExternal__c = true AND Sales_Territory__r.isActive__c = true]);
        
        if(locWithTerritoryMap == null || locWithTerritoryMap.isEmpty()){
            return null;
        }
        
        for(Opportunity opty: processOptyMap.values()){
            for(Sales_Territory_Location_Assignment__c stla: locWithTerritoryMap.values()){
                if(userIdLocationMap.get(opty.ownerId) == stla.Location__c && stla.Location__c != null && String.valueOf(stla.Location__c) != ''){
                    territoryIdSet.add(stla.Sales_Territory__c);
                }
                if(opportunityTerritoryMap.containsKey(opty.id)){
                    List<Id> relatedTerrIdList = opportunityTerritoryMap.get(opty.id);
                    relatedTerrIdList.add(stla.Sales_Territory__c);
                    opportunityTerritoryMap.put(opty.id,relatedTerrIdList);
                }else{
                    opportunityTerritoryMap.put(opty.id,new List<Id>{stla.Sales_Territory__c});
                }
            }
        }
        
        locationTerritoryMap =new Map<Id,Sales_Territory__c>([Select Id,GroupId__c From Sales_Territory__c where id IN: territoryIdSet]);
        
        if(locationTerritoryMap == null || locationTerritoryMap.isEmpty()){
            return null;
        }
        
        for(Id optyId: opportunityTerritoryMap.keySet()){
            List<String> relatedGrpIdList = new List<String>();
            for(Id terrId: opportunityTerritoryMap.get(optyId)){
                if(locationTerritoryMap.get(terrId).GroupId__c != null && String.valueOf(locationTerritoryMap.get(terrId).GroupId__c)!=''){
                    relatedGrpIdList.add(locationTerritoryMap.get(terrId).GroupId__c);
                    groupIdList.add(locationTerritoryMap.get(terrId).GroupID__c);
                }
            }
            opportunityTerritoryPubGrpMap.put(optyId,relatedGrpIdList);
        }
        
        if(opportunityTerritoryPubGrpMap == null || opportunityTerritoryPubGrpMap.isEmpty()){
            return null;
        }else{
            return opportunityTerritoryPubGrpMap;
        }
        
    }
    //TM:Vinay R5:Req:6201:End
}