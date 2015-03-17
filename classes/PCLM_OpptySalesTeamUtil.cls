/**********************************************************
 * Class Name: PCLM_OpptySalesTeamUtil
 * Author: HP
 * Date: 04-Jan-2013 
 * Requirement # Request Id:
 * Description: To add/remove share for opportunities when the sales team members are added in an opportunity
 ***********************************************************/

public class PCLM_OpptySalesTeamUtil{
    // Variable to hold public group Ids
    public static Set<Id> publicGroupIds = new Set<Id>();
    
        
    //TM:R5:Req-6201-Start
    /**
    *@description: create opportunity shares when user is added to Oppty Sales Team
    *@params: List<OpportunityTeamMember> optyTeamMemberList
    *@return: void
    **/
    public static void shareOpptyWithSalesTerritoryUsersForLocation(List<OpportunityTeamMember> optyTeamMemberList){
        Map<Id,List<String>> optyWithTerritoryGroupMap = new Map<Id,List<String>>();
        List<OpportunityShare> optyShareList = new List<OpportunityShare>();
        
        optyWithTerritoryGroupMap = optySharesForSTMembersViaLocation(optyTeamMemberList);
        
        if(optyWithTerritoryGroupMap == null || optyWithTerritoryGroupMap.isEmpty()){
            return;
        }
        
        //TM:Vinay R6:Req 7525:Start
        Set<Channel_Partner__c> pvtOpptySet = new Set<Channel_Partner__c>();
        for(Channel_Partner__c pvtOppty:[Select Opportunity__c From Channel_Partner__c 
        Where Opportunity__c In:optyWithTerritoryGroupMap.keySet() 
        And (Opportunity__r.Account.Confidential_Account__c = true Or Opportunity__r.Confidential__c = true)]){
            pvtOpptySet.add(pvtOppty);
        }
        
        if(pvtOpptySet != null && pvtOpptySet.size() > 0){
            for(Channel_Partner__c pvtOppty:pvtOpptySet){
                if(optyWithTerritoryGroupMap.containsKey(pvtOppty.Opportunity__c)){
                    optyWithTerritoryGroupMap.remove(pvtOppty.Opportunity__c);
                }
            }
        }
        if(optyWithTerritoryGroupMap == null || optyWithTerritoryGroupMap.isEmpty()){ 
            return;
        }
        //TM:Vinay R6:Req 7525:End
        
        for(Id optyId: optyWithTerritoryGroupMap.keySet()){
            for(String grpId:optyWithTerritoryGroupMap.get(optyId)){
                OpportunityShare optyShareRec = new OpportunityShare(OpportunityAccessLevel = 'Read');
                optyShareRec.OpportunityId = optyId;
                optyShareRec.UserOrGroupId = grpId;
                optyShareList.add(optyShareRec);
            }
        }
        
        if(optyShareList != null || optyShareList.size() > 0){
            Database.Saveresult[] shareResults;
            try{
                shareResults = database.insert(optyShareList,false);
            }catch(Exception e){
                 CreateApexErrorLog.insertHandledExceptions(e, shareResults, 'Opportunity__c', 'OpptySalesTeamUtil', 'Class');
            }
        }
        
    }
    
    public static Map<Id,List<String>> optySharesForSTMembersViaLocation(List<OpportunityTeamMember> optyTeamMemberList){
        Set<Id> optyTeamMemberUserIdSet = new Set<Id>();
        Map<Id,Set<Id>> optyLocationMap = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> optyUserMap = new Map<Id,Set<Id>>();
        Set<Id> locationIdSet = new Set<Id>();
        Map<Id,List<Id>> optyTerritoryMap = new Map<Id,List<Id>>();
        Map<Id,List<String>> optyWithTerritoryGroup = new Map<Id,List<String>>();
        Set<Id> terrIdSet = new Set<Id>();
        Map<Id,User> userLocationMap;
        
        for(OpportunityTeamMember optyTM: optyTeamMemberList){
            optyTeamMemberUserIdSet.add(optyTM.UserId);
            if(!optyUserMap.containsKey(optyTM.opportunityId)){
                Set<Id> tmpUserIdSet = new Set<Id>();
                tmpUserIdSet.add(optyTM.userId);
                optyUserMap.put(optyTM.opportunityId,tmpUserIdSet);
            }else{
                optyUserMap.get(optyTM.opportunityId).add(optyTM.userId);
            }
        }
        
        try{
            userLocationMap = new Map<Id,User>([Select Id,Location_Record_Id__c From User Where Id IN:optyTeamMemberUserIdSet]);
        }catch(Exception e){
            System.debug('**Exception in PCLM_ OpptySalesTeamUtil ****' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
        }
        if(userLocationMap == null || userLocationMap.isEmpty()){
            return null;
        }
        
        for(User u: userLocationMap.values()){
            locationIdSet.add(u.Location_Record_Id__c);
        }
        
        for(Id optyId:optyUserMap.keySet()){
            Set<Id> tmpUserIdSet = optyUserMap.get(optyId);
            for(Id uid: tmpUserIdSet){
                if(!optyLocationMap.containsKey(optyId)){
                    Set<Id> tmpLocIdSet = new Set<Id>();
                    tmpLocIdSet.add(userLocationMap.get(uid).Location_Record_Id__c);
                    optyLocationMap.put(optyId,tmpLocIdSet);
                }else{
                    optyLocationMap.get(optyId).add(userLocationMap.get(uid).Location_Record_Id__c);
                }
            }
        }
        
        Map<Id,Sales_Territory_Location_Assignment__c> locationWithTerritoryMap = new Map<Id,Sales_Territory_Location_Assignment__c>([Select Id,Location__c,Sales_territory__c From Sales_Territory_Location_Assignment__c Where Location__c IN: locationIdSet AND Sales_territory__r.isActive__c = true AND Sales_territory__r.isPartner__c = true AND Sales_territory__r.isExternal__c = true]);
        
        if(locationWithTerritoryMap == null || locationWithTerritoryMap.isEmpty()){
            return null;
        }
        
        for(Id optyId: optyLocationMap.keySet()){
            for(Id uId: optyUserMap.get(optyId)){
                for(Sales_Territory_Location_Assignment__c stla: locationWithTerritoryMap.values()){
                    if( userLocationMap != null && stla.Location__c != null && String.valueOf(stla.Location__c) != '' && userLocationMap.get(uId).Location_Record_Id__c == stla.Location__c){
                        terrIdSet.add(stla.Sales_territory__c);
                        if(!optyTerritoryMap.containsKey(optyId)){
                            List<Id> tmpSTIdList = new List<Id>();
                            tmpSTIdList.add(stla.Sales_territory__c);
                            optyTerritoryMap.put(optyId,tmpSTIdList);
                        }else{
                            optyTerritoryMap.get(optyId).add(stla.Sales_territory__c);
                        }
                    }
                }
            }
        }
        
        Map<Id,Sales_Territory__c> locTerritoryMap = new Map<Id,Sales_Territory__c>([Select Id,GroupId__c From Sales_Territory__c Where Id IN: terrIdSet]);
        
        if(locTerritoryMap == null || locTerritoryMap.isEmpty()){
            return null;
        }
        
        for(Id optyId:optyTerritoryMap.keySet()){
            List<String> relGrpIdList = new List<String>();
            for(Id terrId:optyTerritoryMap.get(optyId)){
                if(locTerritoryMap.get(terrId).GroupId__c != null && String.valueOf(locTerritoryMap.get(terrId).GroupId__c) != ''){
                    publicGroupIds.add(locTerritoryMap.get(terrId).GroupId__c);
                    relGrpIdList.add(locTerritoryMap.get(terrId).GroupId__c);
                }
            }
            optyWithTerritoryGroup.put(optyId,relGrpIdList);
        }
        
        if(optyWithTerritoryGroup == null || optyWithTerritoryGroup.isEmpty()){
            return null;
        }
        
        return optyWithTerritoryGroup;
    }
    
    public static void removeOpptyShareFromSalesTerritoryUsersForLocation(List<OpportunityTeamMember> opptyTeamMemberList){
        Map<Id,boolean> opptyIsDeleteShareMap = isAllPartnerUsersRemoved(opptyTeamMemberList);
        Map<Id,List<String>> optyWithPublicGroupMap = optySharesForSTMembersViaLocation(opptyTeamMemberList);
        
        if(optyWithPublicGroupMap == null){
            return;
        }
        Set<Id> optyIdSet = optyWithPublicGroupMap.keySet();
        List<OpportunityShare> curOptyShareList = new List<OpportunityShare>([Select Id,OpportunityId,UserOrGroupId From OpportunityShare Where OpportunityId IN :optyIdSet AND UserOrGroupId IN :publicGroupIds]);
        List<OpportunityShare> deleteOptyShareList = new List<OpportunityShare>();
        
        for(OpportunityShare optyShareRec: curOptyShareList){
            if(optyWithPublicGroupMap.containsKey(optyShareRec.OpportunityId)){
                for(String grpId: optyWithPublicGroupMap.get(optyShareRec.OpportunityId)){
                    if((grpId == optyShareRec.UserOrGroupId) && (opptyIsDeleteShareMap.get(optyShareRec.OpportunityId))){
                        deleteOptyShareList.add(optyShareRec);
                    }
                }
            }
        }
        if(deleteOptyShareList != null && deleteOptyShareList.size() > 0){
            Database.DeleteResult[] deleteResults;
            try{
                deleteResults = Database.delete(deleteOptyShareList, false);
            }catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, null, 'Opportunity__c', 'OpptySalesTeamUtil', 'Class');
            }
        }
        
    }
    
    //TM:R5:Req-6201-End
    
    /**
     * @description: This method is called from the method removeOpptyShareFromSalesTerritoryUsers
     * @param: List of opportunity sales team members to be deleted
     * 
     */
    public static Map<id,boolean> isAllPartnerUsersRemoved(List<OpportunityTeamMember> opptyTeamMembers){
        Map<id,Set<id>> opptyParnterUserMap=new Map<id,Set<id>>();
        Set<id> allUserSet=new Set<id>();
        Set<id> partnerUSet=new Set<id>();
        Set<id> allOpptyIdsSet=new Set<id>();
        Map<id,Set<id>> opptyAllParnterUserMap=new Map<id,Set<id>>();
        Map<id,boolean> opptyIsDeleteShareMap=new Map<id,boolean>();
        for(OpportunityTeamMember opptyTeamMember:opptyTeamMembers){    
            allUserSet.add(opptyTeamMember.userId);  
        }
        List<User> partnerUList=[Select IsPortalEnabled, Id From User  where  id in : allUserSet and IsPortalEnabled=true];
        for(User tUser:partnerUList){
            partnerUSet.add(tUser.id);
        }
        for(OpportunityTeamMember opptyTeamMember:opptyTeamMembers){   
            if(!opptyParnterUserMap.containsKey(opptyTeamMember.OpportunityId)){
                if(partnerUSet.contains(opptyTeamMember.userId)){
                    Set<id> tempUserIds=new Set<id>();
                    tempUserIds.add(opptyTeamMember.userId);
                    opptyParnterUserMap.put(opptyTeamMember.OpportunityId,tempUserIds);
                }
            }else{
                if(partnerUSet.contains(opptyTeamMember.userId)){
                    opptyParnterUserMap.get(opptyTeamMember.OpportunityId).add(opptyTeamMember.userId);
                }
            }
        }        
        //Getting all partner users associated with the salesTeamMembers of each opportunity
        allOpptyIdsSet=opptyParnterUserMap.keySet();
        List<id> allOpptyIds=new List<id>(allOpptyIdsSet);        
        List<OpportunityTeamMember> allSalesTeamMembersList=[Select userid, OpportunityId From OpportunityTeamMember  where OpportunityId in :allOpptyIds and UserId in (select id from user where isPortalEnabled=true)];        
        Set<OpportunityTeamMember> allSalesTeamMembersSet=new Set<OpportunityTeamMember>(allSalesTeamMembersList); 
        for(OpportunityTeamMember salesOpptyTeamMember:allSalesTeamMembersList){              
            if(!opptyAllParnterUserMap.containsKey(salesOpptyTeamMember.OpportunityId)){
                Set<id> tempUserIds=new Set<id>();
                tempUserIds.add(salesOpptyTeamMember.userId);
                opptyAllParnterUserMap.put(salesOpptyTeamMember.OpportunityId,tempUserIds);
            }else{
                opptyAllParnterUserMap.get(salesOpptyTeamMember.OpportunityId).add(salesOpptyTeamMember.userId);
            }
        }        
        //List of opptys to remove sharing
        for(id opptyId:opptyParnterUserMap.keySet()){
            if((opptyParnterUserMap.get(opptyId).size()==opptyAllParnterUserMap.get(opptyId).size())){
                opptyIsDeleteShareMap.put(opptyId,true);
            }else{
                opptyIsDeleteShareMap.put(opptyId,false);
            }
        }
        return opptyIsDeleteShareMap;
    }
}