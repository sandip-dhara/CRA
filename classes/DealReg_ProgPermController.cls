/**
* Trigger Name: DealReg_ProgPermController
* Author: HP
* Date: 19-Dec-2012 
* Requirement # Request Id: 4086
* Description: If program is associated to Permission Set add permission Set to all partners of the Program.
* Modified: Commented the class as part of R6
*/
public class DealReg_ProgPermController{
    public void sampleMethod(){}
    /**
    *@description : To check if the duplicate Permission Program record is happening 
    *@Param : List of Programs_and_permissions__c
    */
    /* Commented as part of R6
    public void checkduplicateRecord(List<Programs_and_permissions__c> progPermissionList){
        List<Programs_and_permissions__c> oldProgramPermissionList = new List<Programs_and_permissions__c>();
        List<Id> programList = new List<Id>();
        
        for(Programs_and_permissions__c pp : progPermissionList){
                programList.add(pp.Program__c);
        }
        // For duplicate check of Program association to the PermissionSet 
        oldProgramPermissionList = [Select id,program__c, PermissionSets__c from Programs_and_permissions__c where Program__c IN: programList];

        for(Programs_and_permissions__c oldProgramPermission : oldProgramPermissionList){
            for(Programs_and_permissions__c newProgramPermission:progPermissionList){
                if(newProgramPermission.PermissionSets__c == oldProgramPermission.PermissionSets__c && newProgramPermission.program__c == oldProgramPermission.Program__c){
                    newProgramPermission.addError(Label.R4_ProgramPermissionDuplicate);
                }
            }
        }
    }
    //Commented as part of R6
    */
    
    /**
    *@description : To insert Permssion Set to users with the location associated to the program of program-permission record
    *@Param : List of Programs_and_permissions__c
    */
    /* Commented as part of R6
    public void progPermAfterInsert(List<Programs_and_permissions__c> progPermTriggerVar){
        LIST<String> recordPermissionsetList = new LIST<String>();
        LIST<Id> programList = new LIST<Id>();
        LIST<Program_Location_Association__c> progLocList = new LIST<Program_Location_Association__c>();
        List<User> userIds = new List<User>();
        LIST<PermissionSet> permissionsetList = new LIST<PermissionSet>();
        LIST<Id> progPermList = new LIST<Id>();
        Map<Id,Id> progPermCampMap = new Map<Id,Id>();
        Map<String,Id> proglocProgPermMap = new Map<String,Id>();
        Map<Id,List<Id>> progPermUserMap = new Map<Id,List<Id>>();
        Map<Id,String> progPermPermmissionsetMap = new Map<Id,String>();
        LIST<String> tempLocList = new LIST<String>();
        List<Id> finalUserList = new List<Id>();
        List<Id> finalPermList = new List<Id>();
        List<Id> tempProgPermCamMapKeyList = new List<Id>();
        for(Programs_and_permissions__c triggerVar:progPermTriggerVar){
            progPermCampMap.put(triggerVar.Id,triggerVar.Program__c);                                       
            programList.add(triggerVar.Program__c);
            recordPermissionsetList.add(triggerVar.PermissionSets__c);
            progPermList.add(triggerVar.Id);
        }
        system.debug('a1b'+recordPermissionsetList);
        system.debug('a1c'+progPermCampMap);
        system.debug('a1d'+programList);
        system.debug('a1e'+progPermList);
        
        // Query the list of Permissionset Ids from the permissionset name
        permissionsetList = [select Id from PermissionSet where name IN : recordPermissionsetList];
        for(Id accVar:progPermList){
            for(PermissionSet permVar:permissionsetList){
                progPermPermmissionsetMap.put(accVar,permVar.Id);
            }
        }
        system.debug('a1f'+permissionsetList);
        system.debug('a1g'+progPermPermmissionsetMap);
        // Query the list of program-location records based on the program list(related to the trigger) 
        progLocList = [select Location__c,Program__c from Program_Location_Association__c where Program__c IN : programList];
        system.debug('a1h'+progLocList);
        for(Program_Location_Association__c proglocListVar:progLocList){
            for(Id progPermCampMapVar:progPermCampMap.keyset()){
                if(proglocListVar.Program__c == progPermCampMap.get(progPermCampMapVar)){
                    tempProgPermCamMapKeyList.add(progPermCampMapVar);
                    tempLocList.add(proglocListVar.Location__c);
                }
            }
        }
        system.debug('a1i'+tempProgPermCamMapKeyList);
        system.debug('a1j'+tempLocList);
        for(integer tempLocListVar=0;tempLocListVar<tempLocList.size();tempLocListVar++){
            proglocProgPermMap.put(tempLocList[tempLocListVar],tempProgPermCamMapKeyList[tempLocListVar]);
        }
        system.debug('a1x'+''+proglocProgPermMap);
        system.debug('a1y'+''+progPermCampMap);
        
        // Query the list of the users related to the location 
        userIds = [select Id,Location_Record_Id__c FROM User where Location_Record_Id__c IN : tempLocList];
        
        // Create the prog-perm and user map 
        for(User uVar:userIds){
            for(String proglocProgPermMapVar:proglocProgPermMap.keyset()){
                if(uVar.Location_Record_Id__c == proglocProgPermMapVar){
                    if(!progPermUserMap.containskey(proglocProgPermMap.get(proglocProgPermMapVar))){
                        progPermUserMap.put(proglocProgPermMap.get(proglocProgPermMapVar),new List<Id>());
                        progPermUserMap.get(proglocProgPermMap.get(proglocProgPermMapVar)).add(uVar.Id);
                    }else{
                        progPermUserMap.get(proglocProgPermMap.get(proglocProgPermMapVar)).add(uVar.Id);
                    }
                }
            }
        }
        system.debug('a1c'+progPermUserMap);
        system.debug('a1d'+progPermPermmissionsetMap);
        
        for(Id progPermUserMapVar:progPermUserMap.keyset()){
            for(Id progPermPermmissionsetMapVar:progPermPermmissionsetMap.keyset()){
                if(progPermUserMapVar == progPermPermmissionsetMapVar){
                    finalUserList.addall(progPermUserMap.get(progPermUserMapVar));                                  // Final list of users
                    for(integer sizeVar=0;sizeVar < progPermUserMap.get(progPermUserMapVar).size();sizeVar++){      
                        finalPermList.add(progPermPermmissionsetMap.get(progPermPermmissionsetMapVar));             // Final list of permissions related to users list
                    }
                }
            }
        }
        system.debug('a1b'+finalUserList+''+finalPermList);
        DealReg_ProgLocTrgController.assignPermission(finalUserList,finalPermList);                          //Send list of users and related permissionsets for assignment
    }   */
    // Commented as part of R6
}