/*
 * Class Name:       DealReg_ProgLocTrgController
 * Author:           HP
 * Date:             04-04-2013 
 * Requirement Id:   
 * Description:      Controller class for all the triggers related to Program_Location_Association object
 */
public class DealReg_ProgLocTrgController {
    /*
     * @Description: Method to check for duplicate program_location_association records and Recordtype of program in program_location_association records - BeforeInsert.  
     */  
    public void progLocBeforeInsert(List<Program_Location_Association__c> progLocAssoList){
        List<Id> programIdList = new List<Id>();
        for(Program_Location_Association__c progLocAssoListVar:progLocAssoList) {
            programIdList.add(progLocAssoListVar.program__c);                              // Get list of programs related to the new ProgramLocationAssociation list
        }
        if(programIdList.size() >0){
            checkProgRecordType(programIdList, progLocAssoList);
            checkDuplicateProgLocRecord(programIdList, progLocAssoList);            
        }
    }
    /* End of progLocBeforeInsert */
    
    /*
     * @Description: Method to check for duplicate program_location_association records and Recordtype of program in program_location_association records - BeforeUpdate   
     */
    public void progLocBeforeUpdate(Map<Id,Program_Location_Association__c> newProgLocList, Map<Id,Program_Location_Association__c> oldProgLocList){
        List<Program_Location_Association__c> progLocList = new List<Program_Location_Association__c>();
        List<Id> progLocIdList = new List<Id>();

        for(Id updatedProgLocId:newProgLocList.keyset()){
            if(oldProgLocList.get(updatedProgLocId).Program__c != newProgLocList.get(updatedProgLocId).Program__c || oldProgLocList.get(updatedProgLocId).Location__c != newProgLocList.get(updatedProgLocId).Location__c){
                progLocIdList.add(newProgLocList.get(updatedProgLocId).Program__c);
                progLocList.add(newProgLocList.get(updatedProgLocId));
            }
        }
        if(progLocIdList.size() > 0  && progLocList.size() > 0){
            checkProgRecordType(progLocIdList, progLocList);
            checkDuplicateProgLocRecord(progLocIdList, progLocList);
        }
    }
    /* End of progLocBeforeUpdate */
    
    /*
     * @Description: To verify RecordType -'Partner Program' of program_location_association record(s)
     */
    public void checkProgRecordType(List<Id> programIdsList, List<Program_Location_Association__c> newProgLocList){
        List<Program_Location_Association__c> recordTypeErrorList = new List<Program_Location_Association__c>();
        Id recordId =RecordTypeIdHelper.getRecordTypeId('Campaign','Partner Program');
        if(programIdsList.size()>0){
            List<Campaign> programsRecordTypeList = [select Id,RecordtypeId from Campaign where Id IN: programIdsList];
            if(programsRecordTypeList.size()>0){
                for(Campaign programsRecordType: programsRecordTypeList){
                    if(programsRecordType.recordTypeId != recordId){
                        for(Program_Location_Association__c newProgLocListVar : newProgLocList){
                            if(newProgLocListVar.program__c == programsRecordType.Id){
                                recordTypeErrorList.add(newProgLocListVar);
                            }
                        }
                    }
                }
            }
        }   
        for(Program_Location_Association__c recordTypeError: recordTypeErrorList){
            recordTypeError.addError(Label.R5_PartnerProgram_Recordtype_Check);                // Throw error if the associated campaign is not of type "Partner Program"
        }
    }   
    /* End of checkProgRecordType */
    
    /*
     * @Description: Method to perform duplicate check of program_location_association record. 
     */
    public void checkDuplicateProgLocRecord(List<Id> programIdList, List<Program_Location_Association__c> newProgLocList){
        List<Program_Location_Association__c> oldProgLocList = new List<Program_Location_Association__c>();
        oldProgLocList = [Select id,program__c, Location__c from Program_Location_Association__c where Program__c IN: programIdList];
        for(Program_Location_Association__c oldProgLocListVar : oldProgLocList){
            for(Program_Location_Association__c newProgLocListVar : newProgLocList){
                if(newProgLocListVar.Location__c == oldProgLocListVar.Location__c && newProgLocListVar.program__c == oldProgLocListVar.Program__c){
                    newProgLocListVar.addError(Label.R5_ProgLocAsso_Duplicate_Check);
                }
            }
        }
    }
    /* End of checkDuplicateProgLocRecord */
    
    /*
     * @description - Retrieving the collection of users associated to the location and program
     * @param - Collection of Program_Location_Association__c
     */
     /* Commented as part of R6
    public static void assignPermissiontoUsers(List<Program_Location_Association__c> progLocList){
        List<Id> programIdsList = new List<Id>();
        List<Id> locationIdsList = new List<id>();
        List<Program_Location_Association__c> eligibleProgLocList = new List<Program_Location_Association__c>();
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
        List<Id> insertUserList = new List<Id>();
        List<Id> insertPermissionIdList = new List<Id>();
        Map<id,Set<id>> locationUsersMap= new Map<id,Set<id>>();
        Set<id> userIds1Set=null;
        List<User> userObjsList = new List<user>();
        
        // all the programs of program_location_association records 
        for(Program_Location_Association__c progLocListVar : progLocList){
            programIdsList.add(progLocListVar.Program__c);
        }
        // query for programs which have permission set 
        programPermissionList = [select PermissionSets__c, Program__c from Programs_and_permissions__c where Program__c IN: programIdsList];
        for(Programs_and_permissions__c programPermissionListVar: programPermissionList){
            permissionProgramSet.add(programPermissionListVar.Program__c); 
            if(programPermissionMap.containsKey(programPermissionListVar.Program__c) == False)
                programPermissionMap.put(programPermissionListVar.Program__c, new Set<String>());  
            programPermissionMap.get(programPermissionListVar.Program__c).add(programPermissionListVar.PermissionSets__c);
            permissionNamesSet.add(programPermissionListVar.PermissionSets__c);
        }
        system.debug('programPermissionMap ******'+programPermissionMap);
        for(Program_Location_Association__c plaVar: progLocList){
            if(permissionProgramSet.contains(plaVar.Program__c)){
                eligibleProgLocList.add(plaVar);
                locationIdsList.add(plaVar.Location__c);    
            }
        }
        system.debug('eligibleProgLocList *****'+eligibleProgLocList);
        system.debug('locationIdsList*****'+locationIdsList);
        // Retreive permssion set
        for(Program_Location_Association__c eligibleProgLocListVar : eligibleProgLocList){
            if(partnerPermissionMap.containsKey(eligibleProgLocListVar.Program__c) == False)
                partnerPermissionMap.put(eligibleProgLocListVar.Location__c, new Set<String>());
                partnerPermissionMap.get(eligibleProgLocListVar.Location__c).addall(programPermissionMap.get(eligibleProgLocListVar.Program__c));

        }
        // Getting all userids associated with the corresponding locations. 
        userObjsList=[SELECT ID,Location_Record_Id__c FROM USER WHERE isportalenabled =true AND isActive=true AND Location_Record_Id__c IN : locationIdsList AND Portal_Tab_Access__c includes ('Deal Reg')];
        for(User userObj:userObjsList){
            // Associating users to the already existing locations 
            if((!locationUsersMap.isEmpty())&&locationUsersMap.containsKey(userObj.Location_Record_Id__c)){
                locationUsersMap.get(userObj.Location_Record_Id__c).add(userObj.id);
            }else{
                userIds1Set=new Set<id>();
                userIds1Set.add(userObj.id);
                locationUsersMap.put(userObj.Location_Record_Id__c,userIds1Set);
            }
        }
        for(PermissionSet ps :[select Id,name from PermissionSet where Name IN : PermissionNamesSet]){
            permissionMap.put(ps.name,ps.Id);  
        }
        System.debug('**permissionMap1*********'+permissionMap);
        System.debug('**locationUsersMap'+locationUsersMap);
        System.debug('**partnerPermissionMap'+partnerPermissionMap);
        System.debug('**permissionNamesSet1*********'+permissionNamesSet);
        for(Id i:locationUsersMap.keyset()){
            for(Id j: partnerPermissionMap.keyset()){
                if(i == j){
                    usersList.addall(locationUsersMap.get(i));
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
    }*/
    /* End of assignPermissiontoUsers*/ 
    
   /*
    *@description : To insert  PermissionSetAssignment object from the List of UserIds and PermissionSet Ids
    *@param : list of UserIds and PermissionSetIdsList 
    */  
    /* Commented as Part of R6
    @future
    public static void assignPermission(List<Id> userIds, List<Id> permissionSetIds){
        system.debug('userIds**'+userIds+'permissionSetIds**'+permissionSetIds);
        List<Id> finalUserPermissionsList = new List<Id>();
        List<Id> finalUserIdsList = new List<Id>();
        List<Id> finalPermissionSetIdsList = new List<Id>();
        List<permissionSetAssignment> newPermissionSetrecordsList = new List<permissionSetAssignment>();
        system.debug('before if userIds**'+userIds+'permissionSetIds**'+permissionSetIds);
        if(userIds.size()>0 && permissionSetIds.size()>0){
            system.debug('after if userIds**'+userIds+'permissionSetIds**'+permissionSetIds);
            finalUserPermissionsList = removeDuplicatePermissionSetAssignment(userIds,permissionSetIds);
            system.debug('finalUserPermissionsList ******'+finalUserPermissionsList);
            for(integer i=0 ; i < finalUserPermissionsList.size() ; i++){
                if(i < (finalUserPermissionsList.size())/2)
                    finalUserIdsList.add(finalUserPermissionsList.get(i));
                else
                    finalPermissionSetIdsList.add(finalUserPermissionsList.get(i));
            }
            system.debug('finalUserIdsList******'+finalUserIdsList);
            system.debug('finalPermissionSetIdsList******'+finalPermissionSetIdsList);
            PermissionSetAssignment permissionSetAssign = null;
            for(Integer i=0; i<finalUserIdsList.size();i++){
                permissionSetAssign = new PermissionSetAssignment(AssigneeId=finalUserIdsList[i], permissionSetId = finalPermissionSetIdsList[i]);
                newPermissionSetrecordsList.add(permissionSetAssign);
            }
            System.debug('newPermissionSetrecordsList'+newPermissionSetrecordsList);
            if(newPermissionSetrecordsList.size() > 0){
                try{
                Insert newPermissionSetrecordsList; 
                }Catch(Exception e){
                    System.debug('**Exception in Loc_DealReg_ProgPartTrgController ****' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
                }
            }
        }
    }
    */
    /* End of assignPermission*/
    /*
    *@description : From the collection of User records and Permission Records removing duplicate combination 
    *               which are already there in PermissionSetAssignment object
    *@param : list of UserIds and PermissionSetIdsList 
    *@return :list of UserIds and PermissionSetIds without duplicates in a list.
    */
    /* Commented as part of R6
    public static List<Id> removeDuplicatePermissionSetAssignment(List<Id> UserIdsList, List<Id> PermissionSetIdsList ){
        List<Id> userAndPermssionIdsList = new List<Id>();
        List<Permissionsetassignment> exsistingUserPermissionSetsList=[select Assigneeid, Permissionsetid from Permissionsetassignment where Assigneeid IN:UserIdsList];
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
        
        for(Permissionsetassignment exsistingUserPermissionSetsListVar:exsistingUserPermissionSetsList){
            if(!existingUserPermMap.containsKey(exsistingUserPermissionSetsListVar.Assigneeid)){
                existingUserPermMap.put(exsistingUserPermissionSetsListVar.Assigneeid,new Set<Id>());
                existingUserPermMap.get(exsistingUserPermissionSetsListVar.Assigneeid).add(exsistingUserPermissionSetsListVar.Permissionsetid);
            }else{
                existingUserPermMap.get(exsistingUserPermissionSetsListVar.Assigneeid).add(exsistingUserPermissionSetsListVar.Permissionsetid);
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
}