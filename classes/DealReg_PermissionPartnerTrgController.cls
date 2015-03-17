/**
 * Class Name: DealReg_PermissionPartnerTrgController
 * Author: HP
 * Date: 18-Dec-2012 
 * Requirement # Request Id: 4086
 * Description: Contains Before Insert support action methods for trigger on user Permission Partner association
 * Modified: Commented the class as part of R6
 */
public class DealReg_PermissionPartnerTrgController{
    public void sampleMethod(){}
    /*
     *@description : Creating collection of User records and Permission Records from new Permission Partner Association
     *@param : list of permission_partner_association__c records inserted 
     */
     /* Commented as part of R6
    public void assignPermissionSet(List<permission_partner_association__c> partnerAssociation){
        List<Id> PartnerList = new List<id>();
        List<PermissionSet> allPermissionList = new List<PermissionSet>();
        List<User> UserIdsList = new List<user>();
        //List<Id> partnerUserIdsList = new List<Id>();
        List<permissionSetAssignment> newPermissionSetrecordsList = new List<permissionSetAssignment>();
        List<Id> permissionSetIdsList = new List<Id>();
        //List<String> PermisionNameList = new List<string>();
        PermissionSetAssignment permissionSetAssign =null;
        Map<id,Set<id>> accessPartnerMap=new Map<id,Set<id>>();
        Map<id,Set<String>> accessPermissionMap=new Map<id,Set<String>>();
        Id accessId=null;
        Set<id> partnerIdsSet=null;
        Set<String> permissionSetNamesSet=null;
        Set<String> allPermissionSetNamesSet = new Set<String>();  
        for(permission_partner_association__c aps: partnerAssociation){               
            accessId=aps.Programs_and_permissions__c;
            //Adding partners to the existing Access object which is available in the map
            if((!accessPartnerMap.isEmpty())&&(accessPartnerMap.containsKey(accessId))) {
                accessPartnerMap.get(accessId).add(aps.Partner__c);        
            }else{//Adding partners to the new access object (not available in the map) and it will be executed only once while creating new access object  
                partnerIdsSet=new Set<id>();
                partnerIdsSet.add(aps.Partner__c);
                accessPartnerMap.put(accessId,partnerIdsSet);
            }
            //Adding permissionset to the existing Access object which is available in the map
            if((!accessPermissionMap.isEmpty())&&(accessPermissionMap.containsKey(accessId))){
                accessPermissionMap.get(accessId).add(aps.PermissionSetName__c);        
            }else{//Adding permissionset to the new access object (not available in the map) and it will be executed only once while creating new access object        
                permissionSetNamesSet=new Set<String>();
                permissionSetNamesSet.add(aps.PermissionSetName__c);
                allPermissionSetNamesSet.add(aps.PermissionSetName__c);
                accessPermissionMap.put(accessId,permissionSetNamesSet);
            }
        }
        system.debug('m1b'+accessPartnerMap);
        system.debug('m1c'+accessPermissionMap);
        system.debug('m1d'+allPermissionSetNamesSet);
        //Getting all partner accounts.
        Set<id> allPartnerAccountIdsSet=new Set<id>();
        for(Id accessObjId:accessPartnerMap.keySet()){
            for(Id partnerAccountId:accessPartnerMap.get(accessObjId)){
                allPartnerAccountIdsSet.add(partnerAccountId);
            }
        }
        List<Id> allPartnerAccountIdsList = new List<Id>();
        allPartnerAccountIdsList.addall(allPartnerAccountIdsSet);
        List<String> allPartnerAccount15digitIdsList = new List<String>();
        allPartnerAccount15digitIdsList = DealReg_ProgPartTrgController.convertTo15DigitList(allPartnerAccountIdsList);
        //Getting all UserIdsList associated with the corresponding accounts.
        List<User> userObjsList = new List<user>();
        userObjsList=[SELECT ID,ACCOUNTID FROM USER WHERE isportalenabled =true AND isActive=true AND ACCOUNTID IN : allPartnerAccount15digitIdsList];
        //Getting all users associated with the parnter accounts
        Map<id,Set<id>> partnerAccountUsersMap= new Map<id,Set<id>>();
        Set<id> userIds1=null;
        for(User userObj:userObjsList){
            //Associating users to the already existing partners
            if((!partnerAccountUsersMap.isEmpty())&&partnerAccountUsersMap.containsKey(userObj.accountid)){
                partnerAccountUsersMap.get(userObj.ACCOUNTID).add(userObj.id);
            }else{
                userIds1=new Set<id>();
                userIds1.add(userObj.id);
                partnerAccountUsersMap.put(userObj.ACCOUNTID,userIds1);
            }
        }
        //Getting all userids associated with the access object according to the partner accounts associated with that access object
        Map<Id,Set<Id>> accessUserMap=new Map<Id,Set<Id>>();
        Set<id> userId2List=null;
        for(Id accessObjId:accessPartnerMap.keySet()){
            for(Id partnerAccountId:accessPartnerMap.get(accessObjId)){
                Set<id> userIds2=new Set<id>();
                userIds2=partnerAccountUsersMap.get(partnerAccountId);
                if(null!=userIds2){
                    for(Id userId:userIds2){
                        if((!accessUserMap.isEmpty())&&(accessUserMap.containsKey(accessObjId))){                       
                            accessUserMap.get(accessObjId).add(userId);
                        }else{
                            userId2List=new Set<id>();
                            userId2List.add(userId);
                            accessUserMap.put(accessObjId,userId2List);
                        }
                    }
                }
            }
        }
        //Getting all permission names associated with all access objects
        allPermissionList = [SELECT Id,Name FROM PermissionSet WHERE Name IN : allPermissionSetNamesSet];
        Map<String,Id> permissionSetNameIdMap=new Map<String,Id>();
        for(PermissionSet permissionSetObj:allPermissionList){        
            permissionSetNameIdMap.put(permissionSetObj.Name,permissionSetObj.Id);        
        }
        List<Id> allUserIdsList=new List<Id>();
        List<Id> tempUserIdsList=null;
        List<Id> allPermissionSetIdsList=new List<id>();
        List<Id> tempPermissionSetIdsList=null;
        //Preparing list of users and list of permissionsets
        for(Id accessId3:accessUserMap.keySet()){  
            tempPermissionSetIdsList=new List<id>();
            for(String permissionName:accessPermissionMap.get(accessId3)){ 
                if(null!=(permissionSetNameIdMap.get(permissionName))){         
                tempPermissionSetIdsList.add(permissionSetNameIdMap.get(permissionName));
                }
            }
            tempUserIdsList=new List<Id>();
            for(Id userId3:accessUserMap.get(accessId3)){
                tempUserIdsList.add(userId3);
            }
            for(Id tempUserId:tempUserIdsList){
                for(Id tempPermSetID:tempPermissionSetIdsList ){
                    allUserIdsList.add(tempUserId);
                    allPermissionSetIdsList.add(tempPermSetID);
                }
            }
        }
        System.debug('*******UserList**************'+allUserIdsList);
        System.debug('*******Permission Set Ids ***'+allPermissionSetIdsList); 
        if(allUserIdsList.size() >0 && allPermissionSetIdsList.size() >0){            
            AssignPermission(allUserIdsList,allPermissionSetIdsList);   
        } 
    }*/
    /*
     *@description : From the collection of User records and Permission Records removing duplicate combination 
     *               which are already there in PermissionSetAssignment object
     *@param : list of UserIds and PermissionSetIdsList 
     *@return :list of UserIds and permissionSetIdsList without duplicates in a list.
     */
    /*public static List<Id> removeDuplicatePermissionSetAssignment(List<Id> UserIdsList, List<Id> PermissionSetIdsList ){
        List<Id> userAndPermssionIdsList = new List<Id>();
        List<Permissionsetassignment> exsistingUserPermissionSets=[select Assigneeid, Permissionsetid from Permissionsetassignment where Assigneeid IN:UserIdsList];
        List<Id> returnUserIdsList = new List<Id>();
        List<Id> returnPermissionSetIdsList = new List<Id>();
        Map<Id, Set<Id>> userPermMap = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> existingUserPermMap = new Map<Id, Set<Id>>();
        List<Id> tempPermList1;
        Set<Id> tempPermSet2;
        for(integer var=0;var< UserIdsList.size();var++){
            if(!userPermMap.containsKey(UserIdsList.get(var))){
                userPermMap.put(UserIdsList.get(var),new Set<Id>());
                userPermMap.get(UserIdsList.get(var)).add(PermissionSetIdsList.get(var));
            }else{
                userPermMap.get(UserIdsList.get(var)).add(PermissionSetIdsList.get(var));
            }
        }
        for(Permissionsetassignment exsistingUserPermissionSetsVar:exsistingUserPermissionSets){
            if(!existingUserPermMap.containsKey(exsistingUserPermissionSetsVar.Assigneeid)){
                existingUserPermMap.put(exsistingUserPermissionSetsVar.Assigneeid,new Set<Id>());
                existingUserPermMap.get(exsistingUserPermissionSetsVar.Assigneeid).add(exsistingUserPermissionSetsVar.Permissionsetid);
            }else{
                existingUserPermMap.get(exsistingUserPermissionSetsVar.Assigneeid).add(exsistingUserPermissionSetsVar.Permissionsetid);
            }
        }
        for(Id userPermMapVar:userPermMap.keyset()){
            for(Id existingUserPermMapVar:existingUserPermMap.keyset()){
                if(userPermMapVar == existingUserPermMapVar){
                    tempPermList1 = new List<Id>();
                    tempPermSet2 = new Set<Id>();
                    tempPermList1.addall(userPermMap.get(userPermMapVar));
                    tempPermSet2.addall(existingUserPermMap.get(existingUserPermMapVar));
                    for(Id tempPermList1Var:tempPermList1){
                        if(!tempPermSet2.contains(tempPermList1Var)){
                            returnUserIdsList.add(userPermMapVar);
                            returnPermissionSetIdsList.add(tempPermList1Var);
                        }
                    }
                }
            }
        }
        userAndPermssionIdsList.addall(returnUserIdsList);
        userAndPermssionIdsList.addall(returnPermissionSetIdsList);
        return userAndPermssionIdsList;
    }
    /*
     *@description : To insert  PermissionSetAssignment object from the List of UserIdsList and PermissionSet Ids
     *@param : list of UserIds and PermissionSetIdsList 
     */  
   /* @future
    public static void assignPermission(List<Id> UserIdsList, List<Id> permissionSetIdsList){
        System.debug('Vas1********'+UserIdsList+'Vas2********'+permissionSetIdsList);
        List<Id> finalUserPermissionsList = new List<Id>();
        List<Id> finalUserIdsList = new List<Id>();
        List<Id> finalPermissionSetIdsList = new List<Id>();
        finalUserPermissionsList = removeDuplicatePermissionSetAssignment(UserIdsList,permissionSetIdsList);
        system.debug('finalUserPermissionsList ******'+finalUserPermissionsList);
        for(integer i=0 ; i < finalUserPermissionsList.size() ; i++){
            if(i < (finalUserPermissionsList.size())/2)
                finalUserIdsList.add(finalUserPermissionsList.get(i));
            else
                finalPermissionSetIdsList.add(finalUserPermissionsList.get(i));
        }
        system.debug('finalUserIdsList******'+finalUserIdsList);
        system.debug('finalPermissionSetIdsList******'+finalPermissionSetIdsList);
        List<permissionSetAssignment> newPermissionSetrecordsList = new List<permissionSetAssignment>();
        PermissionSetAssignment permissionSetAssign = null;
        for(Integer i=0; i<finalUserIdsList.size();i++){
            permissionSetAssign = new PermissionSetAssignment(AssigneeId=finalUserIdsList[i], permissionSetId = finalPermissionSetIdsList[i]);
            newPermissionSetrecordsList.add(permissionSetAssign);
        }
        if(newPermissionSetrecordsList.size() > 0)
            Insert newPermissionSetrecordsList; 
    }
    /**
     *@description : To check if the duplicate Permission Partner record is happening 
     *@Param : List of Permission_Partner_Association__c
     */
     /*Commented as part of R6
    public void checkduplicatePermissionPartner(List<Permission_Partner_Association__c> progPermissionList){
        List<Permission_Partner_Association__c> oldPartnerPermissionList = new List<Permission_Partner_Association__c>();
        List<Permission_Partner_Association__c> newPartnerPermissionList = new List<Permission_Partner_Association__c>();
        List<Id> partnerList = new List<Id>();
        for(Permission_Partner_Association__c pp : progPermissionList){
            partnerList.add(pp.Partner__c);
        }
        // For duplicate check of Partner association to the PermissionSet 
        oldPartnerPermissionList = [Select id,Partner__c, PermissionSetName__c from Permission_Partner_Association__c where Partner__c IN: partnerList];
        for(Permission_Partner_Association__c oldPartnerPermission : oldPartnerPermissionList){
            for(Permission_Partner_Association__c newPartnerPermission : progPermissionList){
                if(newPartnerPermission.PermissionSetName__c == oldPartnerPermission.PermissionSetName__c && newPartnerPermission.Partner__c == oldPartnerPermission.Partner__c){
                newPartnerPermission.addError(Label.R4_PartnerPermissionDuplicate);
                }
            }
        }
        system.debug('a1a'+oldPartnerPermissionList);
    }*/
}