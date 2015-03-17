/***************
 * Class Name: PartnerCollabUserUtil
 * Author: Accenture
 * Date: 19-JULY-2012 
 * Description: Contains support action methods to add user to a partner account related queue for trigger on user object
 ***************/

public class PartnerCollabUserUtil {
    /**
     * @description - Creates a set of partner user IDs
     * @param - Map containing new users
     */
    public static void addPartnerToQueue(map<id, user> newUserMap){
        set<id> partnerUserIdSet = new set<id>(); 
        for(Id partUserId: newUserMap.keySet()){
            if(string.valueOf(newUserMap.get(partUserId).UserType).toLowercase().contains('partner')){
                partnerUserIdSet.add(partUserId);
            }
        }
        if(partnerUserIdSet.size()>0){
            insertPartnerInGrpMember(partnerUserIdSet); 
        }
    }
    /**
     * @description - Future method to create a list of group members
     * @param - Set of partner user IDs
     */
    @future
    public static void insertPartnerInGrpMember(set<Id> partnerUserIds){
        Database.SaveResult[] grpMemberList;
        list<GroupMember> gmListToBeInserted = new list<GroupMember>(); 
        list<Group> grpList = new list<Group>([SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName LIKE 'Partner_Queue_%' AND Type = 'Queue']);
        for(user partUser: [SELECT Id, AccountId FROM user WHERE Id IN :partnerUserIds]){
            for(Group grp: grpList){
                if(string.valueOf(grp.DeveloperName).contains(partUser.AccountId)){
                    GroupMember gm = new GroupMember();
                    gm.GroupId = grp.Id;
                    gm.UserOrGroupId = partUser.Id;
                    gmListToBeInserted.add(gm);
                }
            }
        }
        try{
            grpMemberList = database.insert(gmListToBeInserted, true);
        }
        catch(exception e){
            CreateApexErrorLog.insertHandledExceptions(e, grpMemberList, 'GroupMember', 'LPartnerCollabUserUtil', 'Class');
        }   
    }
    /**
     *Author : PRM Team HP
     *@description -  To call method to insertPermissions, create  maps of accORlocUserMap and accPermissionMap that needs permissionSetassignment for 
     * new Partner users, who has Permission Set association and Parnter is also associated to a program(Campaign)
     *@param - Map of new Users
     *@Requirement #: 4086
     *@Modified : Commented the functionality as part of R6
     */
     /*
    public static void addPermissionSetToPartnerUsers(Map<Id,User> newUsersMap){
        List<user> partnerUserList = new List<user>();
        List<String> permissionnamesList = new List<String>();
        List<Program_Location_Association__c> programLocationList = new List<Program_Location_Association__c>();
        List<Program_Location_Association__c> allLocationProgramsList = new List<Program_Location_Association__c>();
        List<Id> accountIds = new List<Id>();
        List<String> permissionnameList = null;
        Map<String, Id> permissionMap =  new Map<String, Id>();
        Map<Id,List<Id>> locationProgramMap = new Map<Id,List<Id>>();
        Map<Id,Set<String>> programPermissionSetMap = new Map<Id,Set<String>>();        
        system.debug('newUserMap***'+newUsersMap);
        //Collection of Partner Users Account Ids
        if(newUsersMap.size() > 0){
            for(Id portaluserId : newUsersMap.Keyset()){
                system.debug('newuser.IsPortalEnabled#########'+newUsersMap.get(portaluserId).IsPortalEnabled);
                system.debug('Location_Record_Id__c#########'+newUsersMap.get(portaluserId).Location_Record_Id__c);
                if(newUsersMap.get(portaluserId).Location_Record_Id__c != null && newUsersMap.get(portaluserId).IsActive == True){
                    partnerUserList.add(newUsersMap.get(portaluserId));
                    accountIds.add(newUsersMap.get(portaluserId).Location_Record_Id__c);
                    system.debug('accountIds#########'+accountIds);
                }
            }
            // functionality only for PartnerAccount UserList
            if(accountIds.size() >0){
                Map<Id,Set<Id>> locationPermissionMap = new Map<Id,Set<Id>>();
                Map<Id,Set<Id>> locationUsersMap = new Map<Id,Set<Id>>();
                system.debug('partnerUserList ******'+partnerUserList );
                Set<Id> programSet = new Set<Id>();
                Set<Id> partnerSet = new Set<Id>();
                allLocationProgramsList = [select Location__c,Program__c from Program_Location_Association__c where Location__c IN : accountIds];
                for(Program_Location_Association__c allLocationProgramsListVar: allLocationProgramsList){
                    programSet.add(allLocationProgramsListVar.Program__c);
                    partnerSet.add(allLocationProgramsListVar.Location__c);
                }
                //Creating Maps for Partner as key and User as Values and Map for Partner, key as Permission
                for(User partnerUserListVar: partnerUserList){
                    if(partnerSet.contains(partnerUserListVar.Location_Record_Id__c)) {
                        locationPermissionMap.put(partnerUserListVar.Location_Record_Id__c, new Set<Id>());
                        if(locationUsersMap.containsKey(partnerUserListVar.Location_Record_Id__c))    
                            locationUsersMap.get(partnerUserListVar.Location_Record_Id__c).add(partnerUserListVar.Id);
                        else{
                            locationUsersMap.put(partnerUserListVar.Location_Record_Id__c, new Set<Id>());
                            locationUsersMap.get(partnerUserListVar.Location_Record_Id__c).add(partnerUserListVar.Id);
                        }
                    }
                }
                system.debug('locationUsersMap(((('+locationUsersMap );
                List<Programs_and_permissions__c> programsandPermissionsList = [select Id,Program__c,PermissionSets__c from Programs_and_permissions__c where Program__c IN: programSet]; 
                Set<Id> programIdSet = new Set<Id>();
                for(Programs_and_permissions__c prog : programsandPermissionsList){
                    programIdSet .add(prog.Program__c);
                }
                for(Program_Location_Association__c allLocationProgramsListVar: allLocationProgramsList){
                    if(programIdSet .contains(allLocationProgramsListVar.Program__c)){
                        programLocationList.add(allLocationProgramsListVar);
                        if(locationProgramMap.containsKey(allLocationProgramsListVar.Location__c))
                            locationProgramMap.get(allLocationProgramsListVar.Location__c).add(allLocationProgramsListVar.program__c);
                        else{
                            locationProgramMap.put(allLocationProgramsListVar.Location__c, new List<Id>());
                            locationProgramMap.get(allLocationProgramsListVar.Location__c).add(allLocationProgramsListVar.program__c);
                        }
                    }
                }
                for(Programs_and_permissions__c permissionnames: programsandPermissionsList){
                    permissionnamesList.add(permissionnames.PermissionSets__c);
                    if(programPermissionSetMap.containsKey(permissionnames.Program__c))
                        programPermissionSetMap.get(permissionnames.program__c).add(permissionnames.PermissionSets__c);
                    else{
                        programPermissionSetMap.put(permissionnames.Program__c, new Set<String>());
                        programPermissionSetMap.get(permissionnames.program__c).add(permissionnames.PermissionSets__c);
                    }
                }
                system.debug('permissionnamesList&&&&'+permissionnamesList );
                for(permissionSet ps :[select Id,name from PermissionSet where Name IN : permissionnamesList]){
                    permissionMap.put(ps.name,ps.Id);  
                }
                for(Program_Location_Association__c programLocationListVar: programLocationList){
                    permissionnameList = new List<string>();
                    List<Id> programList = new List<Id>(locationProgramMap.get(programLocationListVar.Location__c));
                    for(Id programId:programList){
                        if(programPermissionSetMap.containsKey(programId)){
                            permissionnameList.addall(programPermissionSetMap.get(programId));
                        }
                    }                   
                    for(String permission : permissionnameList)
                        locationPermissionMap.get(programLocationListVar.Location__c).add(permissionMap.get(permission));  
                }   
                system.debug('locationPermissionMap^^^^'+locationPermissionMap );
                //calling method to insert permissionSetAssignment
                if(locationUsersMap.size()>0 && locationPermissionMap.size()>0)
                    insertPermissions(locationUsersMap,locationPermissionMap);

            } 
        }
    }
    */    
    /* End of addPermissionSetToPartnerUsers*/
    /**
     *Author : PRM Team HP
     * @description - To call method to insertPermissions,creating  maps of accORlocUserMap and accPermissionMap that needs permissionSetassignment for 
     * new Partner users who has association with Permission Program               
     * @param - Map of new Users
     *@Requirement #: 4086
     */
     /* Commented as part of R6
    public static void addPermissionSetToPermissionPartnerUsers(List<User> newUserList){
        List<user> partnerUserList = new List<user>();
        List<String> permissionnamesList = new List<String>();
        List<permission_partner_association__c> permissionProgramsList = new List<permission_partner_association__c>();
        List<Id> accountIdsList = new List<Id>();
        Map<String, Id> permissionMap =  new Map<String, Id>();
        Map<Id,Set<Id>> accountPermissionMap = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> accountUsersMap = new Map<Id,Set<Id>>();
        // collecting the partnerUsers and AccountIds to a list
        for(User newuser: newUserList){
            system.debug('newuser.IsPortalEnabled#########'+newuser.IsPortalEnabled);
            system.debug('Partner_account_ID__c#########'+newuser.Partner_account_ID__c);
            if(newuser.Partner_account_ID__c != null && newuser.IsActive == True ){
                partnerUserList.add(newuser);
                accountIdsList.add(newuser.Partner_account_ID__c);
                system.debug('accountIdsList#########'+accountIdsList);
            }
        }
        // functionality only for PartnerAccount UserList
        if(accountIdsList.size() >0){
            system.debug('partnerUserList ******'+partnerUserList );
            system.debug('accountUsersMap(((('+accountUsersMap );
            Set<Id> eligiblePartnersSet = new Set<Id>();
            permissionProgramsList = [select Programs_and_permissions__c,Partner__c,PermissionSetName__c from permission_partner_association__c where Partner__c IN : accountIdsList];
            // collecting the partners that have Permission Set association 
            for(permission_partner_association__c ppassociation : permissionProgramsList){
                eligiblePartnersSet.add(ppassociation.Partner__c);
            }
            // Creating a Map of PartnerAccountId and its Users
            for(User u: partnerUserList){
                if(eligiblePartnersSet.contains(u.Partner_account_ID__c)){
                    accountPermissionMap.put(u.Partner_account_ID__c, new Set<Id>());
                    accountUsersMap.put(u.Partner_account_ID__c, new Set<Id>());
                    accountUsersMap.get(u.Partner_account_ID__c).add(u.Id);
                }
            }
            // all the permissions associated to Partners 
            for(permission_partner_association__c permissionnames: permissionProgramsList)
                permissionnamesList.add(permissionnames.PermissionSetName__c);
            system.debug('permissionnamesList&&&&'+permissionnamesList );
            //Map for PermissionSet Id and Name 
            for(PermissionSet ps :[select Id,name from PermissionSet where Name IN : permissionnamesList]){
                permissionMap.put(ps.name,ps.Id);  
            }
            // Map for the PartnerAccountId and PermissionSets associated to it
            if(permissionMap.size() >0){        
            for(permission_partner_association__c partnerPermission: permissionProgramsList){
                accountPermissionMap.get(partnerPermission.Partner__c).add(permissionMap.get(partnerPermission.PermissionSetName__c));
            }
            }
            system.debug('accountPermissionMap^^^^'+accountPermissionMap );
            permissionsetassignment newPermissionAssign = null;
            // getting the User List and Permission Id List corresponding to a particaular Partner into two Lists
            if(accountUsersMap.size()>0 && accountPermissionMap.size() >0)
            insertPermissions(accountUsersMap,accountPermissionMap);
        }
    }*/
    /* End of addPermissionSetToPermissionPartnerUsers */

    /**
     *Author : PRM Team HP
     * @description - method to insert permissionSetassignment with accountUserMap and accountPermissionMap,
     * @param - Map of account Id with User Ids and Map of account/location Ids and PermissionSet.
     * @Requirement #: 4086
     */
     /*Commented as part of R6
    public static void insertPermissions(Map<Id,Set<Id>> accORlocUserMap, Map<Id,Set<Id>> accORlocPermMap){
        // For elimination of duplicate user PermissionSet from the Maps creating a single Map for User and PermissionSet
        Map<Id,Set<Id>> tempUserPermissionMap = new Map<Id,Set<Id>>();
        for(Id accORlocUserMapVar:accORlocUserMap.keySet()){
            for(Id accORlocPermMapVar:accORlocPermMap.keySet()){
                if(accORlocUserMapVar == accORlocPermMapVar){
                    List<Id> tempUserSet = new List<Id>();
                    tempUserSet.addall(accORlocUserMap.get(accORlocUserMapVar));
                    for(integer tempUserSetVar=0;tempUserSetVar<tempUserSet.size();tempUserSetVar++){
                        if(!tempUserPermissionMap.containsKey(tempUserSet[tempUserSetVar])){
                            tempUserPermissionMap.put(tempUserSet[tempUserSetVar],new Set<Id>());
                            tempUserPermissionMap.get(tempUserSet[tempUserSetVar]).addall(accORlocPermMap.get(accORlocPermMapVar));
                        }else{
                            tempUserPermissionMap.get(tempUserSet[tempUserSetVar]).addall(accORlocPermMap.get(accORlocPermMapVar));
                        }
                    }
                }
            }
        }
        
        // End of creating temparory Map of User and PermissionSet 
        List<Id> finalUserList = new List<Id>();
        List<Id> finalPermissionList = new List<Id>();
        // Creating 2 Lists one for User who needs Permission Set and Corresponding PermissionSet List 
        for(Id tempUserPermissionMapVar:tempUserPermissionMap.keySet()){
            List<Id> tempPermissionList = new List<Id>();
            tempPermissionList.addall(tempUserPermissionMap.get(tempUserPermissionMapVar));
            for(integer tempPermissionListVar=0;tempPermissionListVar<tempPermissionList.size();tempPermissionListVar++){
                finalUserList.add(tempUserPermissionMapVar);
                finalPermissionList.add(tempPermissionList[tempPermissionListVar]);
            }
        }
        List<Id> finalInsertUserPermList = new List<Id>();
        finalInsertUserPermList = DealReg_ProgPartTrgController.removeDuplicatePermissionSetAssignment(finalUserList,finalPermissionList); 
        List<Id> finalUserIds = new List<Id>();
        List<Id> finalPermissionSetIds = new List<Id>();
        for(integer i=0 ; i < finalInsertUserPermList.size() ; i++){
            if(i < (finalInsertUserPermList.size())/2)
                finalUserIds.add(finalInsertUserPermList.get(i));
            else
                finalPermissionSetIds.add(finalInsertUserPermList.get(i));
        }
        system.debug('finalUserIds******'+finalUserIds);
        system.debug('finalPermissionSetIds******'+finalPermissionSetIds);
        List<permissionSetAssignment> newPermSetrecords = new List<permissionSetAssignment>();
        PermissionSetAssignment permissionSetAssign = null;
        // Creating instances for PermissionSetAssignment for new Users with PermissionSets 
        for(Integer i=0; i<finalUserIds.size();i++){
            permissionSetAssign = new PermissionSetAssignment(AssigneeId=finaluserIds[i], permissionSetId = finalpermissionSetIds[i]);
            newPermSetrecords.add(permissionSetAssign);
        }
        // Insertion of PermissionSetAssignemnt to New Users List
        if(newPermSetrecords.size() > 0)
            Insert newPermSetrecords;               
    }
    */
    /* End of insertPermissions*/
    
     /**
     * Author : HP
     * @description - method to insert permissionSetassignment to List of UserIds, Added the method as part of R6
     * @param - PermissionSet Name and List of User Ids to which the permission set should be assigned.
     * R6 : @Requirement Id #: 6897
     */
    Public static void addPermissionSetToUsers(String permissionSetName, List<id> userIds){
        List<PermissionSetAssignment> permissionList = new List<PermissionSetAssignment>();
        PermissionSetAssignment permissionSetRecord;
        PermissionSet userPermissions = [select Id,name from PermissionSet where Name =:PermissionSetName];
        Set<id> previousPermissionSet;
        if(userPermissions != Null){
            previousPermissionSet = new Set<id>();
            for(PermissionSetAssignment previousSet : [select assigneeId, permissionSetId from PermissionSetAssignment where assigneeId IN:userIds AND permissionSetId =: userPermissions.id]){
                previousPermissionSet.add(previousSet.assigneeId);
            }
            for(id usrId : userIds){
                if(!previousPermissionSet.contains(usrId)){
                    permissionSetRecord = new PermissionSetAssignment(assigneeId=usrId, permissionSetId = userPermissions.id);
                    permissionList.add(permissionSetRecord);
                }
            }
        }
        if(permissionList.size()>0){
            insert permissionList;
        }
    }
    /* End of addPermissionSetToUsers*/
    
     /**
     * Author : HP
     * @description - method to delete permissionSetassignment for provided List of UserIds, Added the method as part of R6
     * @param - PermissionSet Name and List of User Ids to which the permission set should be revoked.
     * R6 : @Requirement Id #: 6897
     */
    public static void revokePermission(String permissionSetName, List<id> userIds){
        List<PermissionSetAssignment> permissionList = new List<PermissionSetAssignment>();
        PermissionSet userPermissions = [select Id,name from PermissionSet where Name =:PermissionSetName];
        permissionList = [select id from PermissionSetAssignment where permissionSetId=:userPermissions.id AND assigneeId IN: userIds];
        if(permissionList.size()>0){
            delete permissionList;
        }
    }
    /* End of revokePermission : R6 : Request Id : 6897*/
}