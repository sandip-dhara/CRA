/**
 * Class Name:       DealReg_ProgPartTrgController 
 * Author:           HP
 * Date:             13-Dec-2012 
 * Requirement Id:   4086
 * Description:      Controller class for all the triggers related to program-partner object
 * Modified: As part of R6 Commented the class
 */
public class DealReg_ProgPartTrgController {
    public void sampleMethod(){}
    /**
     * @description - Retrieving the collection of users who's Partners are associated to Program
     * @param - Collection of Program_Partner_Association__c
     */
     /*
    public static void AddtoPartnerProgramUser(List<Program_Partner_Association__c> progPartnerList){
        List<Id> programIdsList = new List<Id>();
        List<Id> partnerIdsList = new List<id>();
        List<Program_Partner_Association__c> eligibleprogPartnerList = new List<Program_Partner_Association__c>();
        Set<Id> permissionProgramSet = new Set<id>();
        Set<String> permissionNamesSet = new Set<String>();
        Map<Id, Set<String>> programPermissionMap = new  Map<Id, Set<String>>();
        Map<Id, Set<String>> partnerPermissionMap = new  Map<Id, Set<String>>();
        Map<Id, Set<Id>> partnerPermissionIdMap = new  Map<Id, Set<Id>>();       
        List<Id> usersList = new List<Id>();
        List<Id> permissionIdsList = new List<Id>();
        Set<Id> permissionNamesList = new Set<Id>();
        List<Programs_and_permissions__c> programPermissionList = new List<Programs_and_permissions__c>();
        Map<String, Id> permissionMap = new Map<String, Id>();
        // all the Programs of program partner records 
        for(Program_Partner_Association__c ppa : progPartnerList){
            programIdsList.add(ppa.Program__c);
        }
        // query for programs which has permission Set 
        programPermissionList = [select PermissionSets__c, Program__c from Programs_and_permissions__c where Program__c IN: programIdsList];
        for(Programs_and_permissions__c pnp: programPermissionList){
            permissionProgramSet.add(pnp.Program__c); 
            if(programPermissionMap.containsKey(pnp.Program__c) == False)
                programPermissionMap.put(pnp.Program__c, new Set<String>());  
            programPermissionMap.get(pnp.Program__c).add(pnp.PermissionSets__c);
            permissionNamesSet.add(pnp.PermissionSets__c);
        }
        system.debug('programPermissionMap ******'+programPermissionMap);
        for(Program_Partner_Association__c ppavar: progPartnerList){
            if(permissionProgramSet.contains(ppavar.Program__c)){
                eligibleprogPartnerList.add(ppavar);
                partnerIdsList.add(ppavar.Partner__c);    
            }
        }
        List<Id> convertedAccList = new List<Id>();
        convertedAccList = convertTo15DigitList(partnerIdsList);
        system.debug('eligibleprogPartnerList *****'+eligibleprogPartnerList);
        system.debug('partnerIdsList*****'+partnerIdsList);
        // Retreive permssion set 
        for(Program_Partner_Association__c MapVar : eligibleprogPartnerList){
            if(partnerPermissionMap.containsKey(MapVar.Program__c) == False)
                partnerPermissionMap.put(MapVar.Partner__c, new Set<String>());
            //system.debug('programPermissionMap.get(MapVar.Program__c****)'+programPermissionMap.get(MapVar.Program__c));
            //system.debug('MapVar.Partner__c******'+MapVar.Partner__c);
            partnerPermissionMap.get(MapVar.Partner__c).addall(programPermissionMap.get(MapVar.Program__c));

        }
        // Getting all userids associated with the corresponding accounts. 
        List<User> userObjs = new List<user>();
        userObjs=[SELECT ID,ACCOUNTID FROM USER WHERE isportalenabled =true AND isActive=true AND ACCOUNTID IN : convertedAccList];
        // Getting all users associated with the parnter accounts 
        Map<id,Set<id>> partnerUsersMap= new Map<id,Set<id>>();
        Set<id> userIds1=null;
        for(User userObj:userObjs){
            // Associating users to the already existing partners
            if((!partnerUsersMap.isEmpty())&&partnerUsersMap.containsKey(userObj.accountid)){
                partnerUsersMap.get(userObj.ACCOUNTID).add(userObj.id);
            }else{
                userIds1=new Set<id>();
                userIds1.add(userObj.id);
                partnerUsersMap.put(userObj.ACCOUNTID,userIds1);
            }
        }
        for(PermissionSet ps :[select Id,name from PermissionSet where Name IN : PermissionNamesSet]){
            permissionMap.put(ps.name,ps.Id);  
        }
        System.debug('**permissionMap1*********'+permissionMap);
        List<Id> insertUserList = new List<Id>();
        List<Id> insertPermissionIdList = new List<Id>();
        System.debug('**partnerUsersMap'+partnerUsersMap);
        System.debug('**partnerPermissionMap'+partnerPermissionMap);
        System.debug('**permissionNamesSet1*********'+permissionNamesSet);
        for(Id i:partnerUsersMap.keyset()){
            for(Id j: partnerPermissionMap.keyset()){
                if(i == j){
                    usersList.addall(partnerUsersMap.get(i));
                    permissionNamesSet.addall(partnerPermissionMap.get(j));
                }          
            }
            System.debug('**usersList*********'+usersList);
            System.debug('**permissionNamesSet2*********'+permissionNamesSet);
            System.debug('**permissionMap*********'+permissionMap);
            for(Id userID:usersList){
                for(String name:permissionNamesSet){
                    if(null!=(permissionMap.get(name))){
                    insertUserList.add(userID);                    
                    insertPermissionIdList.add(permissionMap.get(name));
                    }
                }
            }
        }
        // Passing userList and PermissionIdList for insertion of permissionSetAssignment 
        system.debug('insertUserList**'+insertUserList+'insertPermissionIdList**'+insertPermissionIdList);
        if(insertUserList.size() > 0 && insertPermissionIdList.size()>0){
            assignPermission(insertUserList,insertPermissionIdList);
        }
    }
    */
    /* End of AddtoPartnerProgramUser*/
    /**
     * @Description: Method to verify Duplicate records and Recordtype on Before Insert of Partner Program.
     * @param:   List of Program_Partner_Association__c records
     */  
     /*
    public static void progPartnerRecordBeforeInsert(List<Program_Partner_Association__c> progPartAssociationList){
        List<Id> programIdsList = new List<Id>();
        for(Program_Partner_Association__c newProgPartAssociation : progPartAssociationList) {
            programIdsList.add(newProgPartAssociation.program__c);   
        }
        if(programIdsList.size() >0){
            checkDuplicateProgPartnerRecord(programIdsList, progPartAssociationList);
        }
    }
    */
    /* End of progPartnerRecordBeforeInsert*/
    /**
     * @Description: Method to verify Duplicate records and Recordtype on BeforeUpdate of Partner Program. 
     * @param: old Map and new Map of Id and Program_Partner_Association__c records  
     */
     /*
    public void progPartnerRecordBeforeUpdate(Map<Id,Program_Partner_Association__c> newProgPartnerList, Map<Id,Program_Partner_Association__c> oldProgPartnerList){
        List<Program_Partner_Association__c> progPartnerList = new List<Program_Partner_Association__c>();
        List<Id> progPartnerIdList = new List<Id>();
        for(Id updatedProgPartnerId:newProgPartnerList.keyset()){
            if(oldProgPartnerList.get(updatedProgPartnerId).Program__c != newProgPartnerList.get(updatedProgPartnerId).Program__c || oldProgPartnerList.get(updatedProgPartnerId).Partner__c != newProgPartnerList.get(updatedProgPartnerId).Partner__c){
                progPartnerIdList.add(newProgPartnerList.get(updatedProgPartnerId).Program__c);
                progPartnerList.add(newProgPartnerList.get(updatedProgPartnerId));
            }
        }
        if(progPartnerIdList.size() > 0  && progPartnerList.size() > 0){
            checkDuplicateProgPartnerRecord(progPartnerIdList, progPartnerList);
        }
    }
    */
    /* End of progPartnerRecordBeforeUpdate*/
    /**
     * @Description: Method to perform duplicate check on ProgramPartner and to verify the creation of ProgramPartner. 
     * @param: List of programIds and List of Program_Partner_Association__c records
     */
     /*
    public static void checkDuplicateProgPartnerRecord(List<Id> programIdList, List<Program_Partner_Association__c> newProgPartAssociationList){
        //List<Campaign>  campaignList = new List<Campaign>(); 
        List<Program_Partner_Association__c> oldProgPartAssList = new List<Program_Partner_Association__c>();
        List<Program_Partner_Association__c> duplicateProgPartAssList = new List<Program_Partner_Association__c>();
        List<Program_Partner_Association__c> passInsertProgPartAssList = new List<Program_Partner_Association__c>();
        // For duplicate check of Partner association to the Program 
        oldProgPartAssList = [Select id,program__c, Partner__c from Program_Partner_Association__c where Program__c IN: programIdList];
        for(Program_Partner_Association__c oldProgPartAss : oldProgPartAssList){
            for(Program_Partner_Association__c newProgPartAssociation : newProgPartAssociationList){
                if(newProgPartAssociation.Partner__c == oldProgPartAss.Partner__c && newProgPartAssociation.program__c == oldProgPartAss.Program__c){
                    newProgPartAssociation.addError(Label.R3_PartnerProduct_Duplicate);
                }
            }
        }
    }
    */
    /*End of checkDuplicateProgPartnerRecord*/  
    /*
    *@description : From the collection of User records and Permission Records removing duplicate combination 
    *               which are already there in PermissionSetAssignment object
    *@param : list of UserIds and PermissionSetIdsList 
    *@return :list of UserIds and PermissionSetIds without duplicates in a list.
    */
    /*
    public static List<Id> removeDuplicatePermissionSetAssignment(List<Id> UserIdsList, List<Id> PermissionSetIdsList ){
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
        system.debug('userAndPermssionIdsList***'+userAndPermssionIdsList);
        return userAndPermssionIdsList;
    }
    */
    /* End of removeDuplicatePermissionSetAssignment */
    /*
    *@description : To insert  PermissionSetAssignment object from the List of UserIds and PermissionSet Ids
    *@param : list of UserIds and PermissionSetIdsList 
    */  
    /*
    @future
    public static void assignPermission(List<Id> userIds, List<Id> permissionSetIds){
        system.debug('userIds**'+userIds+'permissionSetIds**'+permissionSetIds);
        List<Id> finalUserPermissionsList = new List<Id>();
        List<Id> finalUserIds = new List<Id>();
        List<Id> finalPermissionSetIds = new List<Id>();
        system.debug('before if userIds**'+userIds+'permissionSetIds**'+permissionSetIds);
        if(userIds.size()>0 && permissionSetIds.size()>0){
            system.debug('after if userIds**'+userIds+'permissionSetIds**'+permissionSetIds);
            finalUserPermissionsList = removeDuplicatePermissionSetAssignment(userIds,permissionSetIds);
            system.debug('finalUserPermissionsList ******'+finalUserPermissionsList);
            for(integer i=0 ; i < finalUserPermissionsList.size() ; i++){
                if(i < (finalUserPermissionsList.size())/2)
                    finalUserIds.add(finalUserPermissionsList.get(i));
                else
                    finalPermissionSetIds.add(finalUserPermissionsList.get(i));
            }
            system.debug('finalUserIds******'+finalUserIds);
            system.debug('finalPermissionSetIds******'+finalPermissionSetIds);
            List<permissionSetAssignment> newPermissionSetrecords = new List<permissionSetAssignment>();
            PermissionSetAssignment permissionSetAssign = null;
            for(Integer i=0; i<finalUserIds.size();i++){
                permissionSetAssign = new PermissionSetAssignment(AssigneeId=finaluserIds[i], permissionSetId = finalpermissionSetIds[i]);
                newPermissionSetrecords.add(permissionSetAssign);
            }
            System.debug('newPermissionSetrecords'+newPermissionSetrecords);
            if(newPermissionSetrecords.size() > 0){
                try{
                Insert newPermissionSetrecords; 
                }Catch(Exception e){
                    System.debug('**Exception in DealReg_ProgPartTrgController ****' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
                }
            }
        }
    }
    */
    /* End of assignPermission*/
    
    /**
     * @description -   It converts the 18-digit SFDC ids to 15-digit ids
     * @param       -   List<String> - list of IDs in 18-digit format   
     * @return      -   List<String> - list of IDs in 15-digit format
    **/ 
    /*    
    public Static List<String> convertTo15DigitList(List<String> paramIDList){
        List<String> paramIDfinalList = new List<String>();
        try{
            for(String paramIDListVar:paramIDList){
                if(paramIDListVar.length()>15){
                    paramIDListVar = paramIDListVar.substring(0,15);
                }
                paramIDfinalList.add(paramIDListVar);
            }   
        }catch(Exception e){
        }
        return paramIDfinalList;
    } 
    */              
}