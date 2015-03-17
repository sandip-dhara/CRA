global class FileUploadAttachFile {
    public boolean IsOnboardUsersEnabled {get;set;}
    public boolean IsProcessUsersEnabled {get;set;}
    public boolean IsExportToBaordUser {get;set;}
    public boolean IsUploadFile {get;set;}
    public boolean IsLogFileDownLoad {get;set;}
    public string nameFile {get;set;}
    public string TotalPreProcessFiles {get;set;}
    public string TotalPreProcessSuccessFiles {get;set;}
    public string TotalPreProcessFailureFiles {get;set;}
    public Blob contentFile {get;set;}
    public String downloadUrl {get;set;}
    public Id fileId {get;set;}
    public Id successId {get;set;}
    public Id UserId {get;set;}
    public string Environment {get;set;}
    String messegae = '';
    String errorData = '';
    String textStr = '';
    Integer errorCount = 0;
    Integer sucessCount = 0;
    String[] filelines = new String[] {};
    List < SLP_Process_Onboarding_User__c > accstoupload;
    List < Document > docsUpload = new List < Document > ();
    List < SLP_Process_Onboarding_User__c > updateStatusForOnboradingUsers;
    Map < Integer, String > errorDataMap = new Map < Integer, String > ();
    Map < String, String > updateSlpFailuer = new Map < String, String > ();
    public string SLPBulkRegId {get;set;}
    public string uploadFileName {get;set;}

    //------------
    List < string > lstRoles = new List < string > ();
    List < User > lstUserDetails = new List < User > ();
    Map < string, SLP_Process_Onboarding_User__c > mapBoardingUsers = new Map < string, SLP_Process_Onboarding_User__c > ();
    Map < string, SLP_ES_Emp_HRDD_Feed__c > MapFeedItemObject = new Map < string, SLP_ES_Emp_HRDD_Feed__c > ();
    List < string > lstEmailids = new List < string > ();
    List < string > lstEmailids2Process = new List < string > ();

    List < string > lstNewUser = new List < string > ();
    Map < string, String > storeProfileData = new Map < string, String > ();
    Map < Id, String > esuserPermisionMap = new Map < Id, String > ();
    Map < string, string > permmisionEmail = new Map < string, String > ();
    List < string > noHRDDFeeduserEmailIds = new List < string > ();

    Map < String, String > commMap = new Map < String, STring > ();
    List < String > newListCmmNames = new List < String > ();



    // -----------------

    public FileUploadAttachFile() {
        Environment = AthenaUtility.ApplicationSettingValue(AthenaUtility.Environment);

        GetLoggedinUserDtls();
        IsUploadFile = true;
    }

    public string getSfInstance {
        get {
            return ApexPages.currentPage().getHeaders().get('Host');
        }
    }

    public User GetLoggedinUserDtls() {
        User u = [Select Name, FullPhotoUrl, id From User where User.id = : UserInfo.getUserId()];
        return U;
    }


    public Pagereference ReadFile() {
        uploadFileName = nameFile;
        //String s = EncodingUtil.base64Encode(contentFile);
        //Blob b = EncodingUtil.base64Decode(s);
        //nameFile = b.toString();
        nameFile = contentFile.toString();
        filelines = nameFile.split('\n');
        accstoupload = new List < SLP_Process_Onboarding_User__c > ();
        Map < Integer, String > readfileMap = new Map < Integer, String > ();
        String compareData = 'Email Id,Role,Area Of Focus (Expert),Community Contributor,Community Member,Board Contributor,Board Member';
        if (compareData == nameFile.left(106)) {
            SLP_BulkReg__c bulkReg = new SLP_BulkReg__c();
            bulkReg.File_Name__c = uploadFileName;
            bulkReg.User_Id__c = userinfo.getuserid();
            insert bulkReg;
            Attachment attachFile = new Attachment(parentId = bulkReg.id, name = uploadFileName, body = contentFile);
            insert attachFile;
            fileId = attachFile.id;
            SLPBulkRegId = bulkReg.id;
            system.debug('fileId--------' + fileId);
            for (Integer i = 1; i < filelines.size(); i++) {
                String status = '';
                String[] inputvalues = new String[] {};
                inputvalues = filelines[i].split(',');
                SLP_Process_Onboarding_User__c pou = new SLP_Process_Onboarding_User__c();
                if (inputvalues[0].endsWith('@hp.com')) {
                    pou.FormatValid__c = true;

                } else {
                    status = 'Email format is wrong, should have domain @hp.com';
                    pou.FormatValid__c = false;
                    pou.New_User__c = true;
                }
                system.debug('inputvalues----' + inputvalues);
                pou.Failure_Log__c = status;
                pou.SLP_BulkReg_Id__c = bulkReg.id;
                pou.Email__c = inputvalues[0];
                pou.Role__c = inputvalues[1];
                pou.Area_Of_Focus__c = inputvalues[2];
                pou.Community_Contributor__c = inputvalues[3];
                pou.Community_Member__c = inputvalues[4];
                pou.Board_Contributor__c = inputvalues[5];
                pou.Board_Member__c = inputvalues[6];
                readfileMap.put(i, pou.Email__c);
                accstoupload.add(pou);
            }
            try {
                Database.SaveResult[] srList = Database.insert(accstoupload, false);
                for (Integer i = 0; i < srList.size(); i++) {
                    if (srList[i].isSuccess()) {
                        sucessCount++;
                    } else {
                        errorCount++;
                        if (messegae != null && messegae != '') {
                            messegae = messegae + '\n' + readfileMap.get(i + 1) + '=' + srList[i].getErrors()[0].getMessage();
                        } else {
                            messegae = readfileMap.get(i + 1) + ' = ' + srList[i].getErrors()[0].getMessage();
                        }
                    }
                }
                TotalPreProcessFiles = 'Number of users to pre process :- ' + string.valueOf(sucessCount + errorCount);
                TotalPreProcessSuccessFiles = 'Pre process sucess :- ' + string.valueOf(sucessCount);
                TotalPreProcessFailureFiles = 'Pre process Failure :- ' + string.valueOf(errorCount);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, +'Total Files Upload Success:' + sucessCount));
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, +'Total Files Failed To Upload :' + errorCount);
                ApexPages.addMessage(errormsg);
                String txt = '';

                if (messegae != '') {
                    txt += messegae;
                    Blob txtBlob = Blob.valueOf(txt);
                    Attachment attach = new Attachment();
                    attach.Name = uploadFileName.remove('.csv') + '.txt';
                    attach.Body = txtBlob;
                    attach.ContentType = 'txt/txt';
                    attach.ParentID = bulkReg.id;
                    insert attach;
                    successId = attach.id;
                    system.debug('successId-------------' + successId);
                    IsLogFileDownLoad = true;
                }

            } catch (Exception e) {
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured. Please check the template or try again later');
                ApexPages.addMessage(errormsg);
            }
        } else {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured. Please check the Order of Excel Data');
            ApexPages.addMessage(errormsg);
        }
        //ValidateUsers();      
        IsOnboardUsersEnabled = true;
        IsUploadFile = false;
        IsProcessUsersEnabled = false;
        IsExportToBaordUser = false;

        return null;

    }

    public void AddOrUpdateBoardingUsers() {
        ValidateUsers();
        IsProcessUsersEnabled = true;
        IsOnboardUsersEnabled = false;
        IsUploadFile = false;
        IsExportToBaordUser = false;
    }

    public void ValidateUsers() {

        lstRoles.clear();
        lstUserDetails.clear();
        mapBoardingUsers.clear();
        MapFeedItemObject.clear();
        lstEmailids.clear();
        lstEmailids2Process.clear();
        //SLPBulkRegId='a8uZ0000000CnhiIAC';

        List < User > lstExistingUsers = new List < User > ();

        List < string > lstRemainingUsers = new List < string > ();
        List < string > lstMasterProductionUsers = new List < string > ();
        List < User > lstProductionRefreshUsers = new List < User > ();
        List < string > lstNewUsers = new List < string > ();
        List < User > lstExistingUserObject = null;
        List < User > lstUpdateUserObject = null;

        Map < string, string > MapEmail = new Map < string, string > ();
        SLP_ES_Emp_HRDD_Feed__c empFeedItemObject = new SLP_ES_Emp_HRDD_Feed__c();
        List < PermissionSetAssignment > lstpermissionAssignment = new List < PermissionSetAssignment > ();
        List < PermissionSetAssignment > lstUpdatepermissionAssignment = new List < PermissionSetAssignment > ();
        Map < string, boolean > mapExistingUsers = new Map < string, boolean > ();
        Map < string, boolean > mapNewProductionUsers = new Map < string, boolean > ();

        string emailID = '';


        List < SLP_Process_Onboarding_User__c > lstProcessUsers = [SELECT Id, Email__c, Role__c, Area_Of_Focus__c, Community_Contributor__c, Community_Member__c, Board_Contributor__c, Board_Member__c, SLP_BulkReg_Id__c, Status__c, FormatValid__c,
                            Failure_Log__c, Success_Log__c, New_User__c FROM SLP_Process_Onboarding_User__c where FormatValid__c = true and SLP_BulkReg_Id__c = : SLPBulkRegId];

        //Fetching list of email ids from "SLP_Process_Onboarding_User__c" Object
        for (SLP_Process_Onboarding_User__c boardingUsers: lstProcessUsers) {
            MapEmail.put(boardingUsers.Id, boardingUsers.Email__c);
            lstEmailids.add(boardingUsers.Email__c);
            if (boardingUsers.Role__c != '') {
                lstRoles.add(boardingUsers.Role__c);
            }
            mapBoardingUsers.put(boardingUsers.Email__c, boardingUsers);
        }

        //Fetch all Users HRDD Feed
        List < SLP_ES_Emp_HRDD_Feed__c > lstEmpHrddFeedObject = [SELECT Id, First_Name__c, Last_Name__c, Emp_Name__c, Email__c, Emp_Number__c, Region__c, Business_Group__c,
                                                              Region_ID__c, Business_Group_Id__c, User_Id__c FROM SLP_ES_Emp_HRDD_Feed__c where Email__C in : lstEmailids];
        for (SLP_ES_Emp_HRDD_Feed__c feedItem: lstEmpHrddFeedObject) {
            MapFeedItemObject.put(feedItem.Email__c, feedItem);
        }
        system.debug('MapFeedItemObject Initial:' + MapFeedItemObject.size());

        //Fetch existing users or Fetch matching users from FileUploadAttachFile & Users Object
        lstExistingUsers = [Select id, Name, Profileid, email From User where email in : lstEmailids and IsActive = true];
        system.debug('Existing users lstEmailids' + lstEmailids);
        SetUserProfile(lstExistingUsers);
        //SetUserPermission(lstExistingUsers);


        for (User userDetail: lstExistingUsers) {
            mapExistingUsers.put(userDetail.email, true);

            User user = new User();
            user.id = userDetail.id;
            user.email = userDetail.email;
            lstEmailids2Process.add(userDetail.email);
            lstUserDetails.add(user);
        }

        //Making a list for remaining user excluding Existing User (SFDC User or Production refresh user)
        for (string email: lstEmailids) {
            if (!mapExistingUsers.ContainsKey(email)) {
                lstRemainingUsers.add(email);
                //lstMasterProductionUsers.add(email + '.esit');
                lstMasterProductionUsers.add(email + Environment);
            }
        }

        //Fetching production users from User Object [Whose email ended with .esit or .plmesit]
        lstProductionRefreshUsers = [Select id, Name, email From User where email in : lstMasterProductionUsers or email in : lstRemainingUsers or
                                     email_address__c in : lstMasterProductionUsers or email_address__c in : lstRemainingUsers];

        for (User userDetail: lstProductionRefreshUsers) {
            mapNewProductionUsers.put(userDetail.email, true);
        }

        //lstRemainingUsers - lstNewProductionUsers
        string strEnvEmail;
        for (string email: lstRemainingUsers) {
            strEnvEmail = email + Environment;
            if (!mapNewProductionUsers.ContainsKey(email) && !mapNewProductionUsers.ContainsKey(strEnvEmail)) {
                lstNewUsers.add(email);
            }
        }

        Profile profileObject = new Profile();
        profileObject = [SELECT Id, Name FROM Profile where name = 'ES Base Profile'
            Limit 1];

        lstExistingUserObject = new List < User > ();
        for (User prodcutionUser: lstProductionRefreshUsers) {
            User userObject = new User();

            string UserEmail = prodcutionUser.email;

            //if(UserEmail.contains('.esit'))
            //{
            //    emailID = UserEmail.substring(0, UserEmail.length()-5);
            //    System.debug('SubString: emailID###' + emailID);
            //}
            emailID = UserEmail;
            if (UserEmail.contains(Environment)) {
                if (Environment == '.esit') {
                    emailID = UserEmail.substring(0, UserEmail.length() - 5);
                } else if (Environment == '.plmesit') {
                    emailID = UserEmail.substring(0, UserEmail.length() - 8);
                }

                System.debug('SubString: emailID###' + emailID);
            }

            userObject.Id = prodcutionUser.Id;
            userObject.email = emailID;
            userObject.Isactive = true;
            userObject.email_address__c = emailID;
            //userObject.username = emailID + '.esit';
            userObject.username = emailID + Environment;
            System.debug('emailID: ###' + emailID);
            userObject.federationidentifier = emailID;

            userObject.digestfrequency = 'N';
            userObject.userpreferencesdisableallfeedsemail = true;
            if (!mapNewProductionUsers.ContainsKey(emailID)) {
                if (MapFeedItemObject.containsKey(emailID)) {
                    empFeedItemObject = MapFeedItemObject.get(emailID);

                    userObject.FirstName = empFeedItemObject.First_Name__c;
                    userObject.LastName = empFeedItemObject.Last_Name__c;
                    userObject.Alias = empFeedItemObject.First_Name__c.Substring(0, 1) + ' ' + empFeedItemObject.Last_Name__c.Substring(1, 4);
                    userObject.legacy_employee_ref__c = String.ValueOf(empFeedItemObject.Emp_Number__c);
                }
            }

            userObject.ProfileId = profileObject.Id;
            userObject.UserPreferencesDisableAllFeedsEmail = true;

            lstExistingUserObject.add(userObject);
        }
        //Updating user Object
        update lstExistingUserObject;

        for (User userDetail: lstExistingUserObject) {
            User user = new User();
            user.id = userDetail.id;
            user.email = userDetail.email;
            lstEmailids2Process.add(userDetail.email);
            lstUserDetails.add(user);
        }

        //Assgining permission set to the user's.
        // SetUserPermission(lstExistingUserObject);

        lstUpdateUserObject = new List < User > ();
        List < string > newuserEmailIds = new List < string > ();


        //Create and insert new user's with new fields
        for (string userEmail: lstNewUsers) {
            if (!mapNewProductionUsers.ContainsKey(userEmail)) {
                empFeedItemObject = MapFeedItemObject.get(userEmail);

                User userObject = new User();

                if (empFeedItemObject != null) {
                    newuserEmailIds.add(userEmail);
                    userObject.email = userEmail;
                    userObject.Isactive = true;
                    userObject.email_address__c = userEmail;
                    //userObject.username = userEmail + '.esit';
                    userObject.username = userEmail + Environment;
                    userObject.federationidentifier = userEmail;
                    userObject.digestfrequency = 'N';
                    userObject.userpreferencesdisableallfeedsemail = true;
                    userObject.Adoption_Role_Type__c = 'IT';
                    userObject.TimeZoneSidKey = 'America/Los_Angeles';
                    userObject.LocaleSidKey = 'en_US';
                    userObject.EmailEncodingKey = 'UTF-8';
                    userObject.LanguageLocaleKey = 'en_US';

                    userObject.FirstName = empFeedItemObject.First_Name__c;
                    userObject.LastName = empFeedItemObject.Last_Name__c;
                    string strf = '';
                    string strl = '';
                    if (empFeedItemObject.Last_Name__c.length() > 4) {
                        strl = empFeedItemObject.Last_Name__c.Substring(1, 4);
                    } else {
                        strl = empFeedItemObject.Last_Name__c;
                    }
                    userObject.Alias = empFeedItemObject.First_Name__c.Substring(0, 1) + ' ' + strl;
                    // userObject.Alias = empFeedItemObject.First_Name__c.Substring(0, 1) +' '+ empFeedItemObject.Last_Name__c.Substring(1, 4);
                    userObject.legacy_employee_ref__c = String.ValueOf(empFeedItemObject.Emp_Number__c);
                    userObject.ProfileId = profileObject.Id;
                    userObject.UserPreferencesDisableAllFeedsEmail = true;
                    lstUpdateUserObject.add(userObject);

                } else {
                    noHRDDFeeduserEmailIds.add(userEmail);
                }
                lstNewUser.add(userEmail);
            }
        }

        //Imran Modifiy Aug - 7-2014 ----Start--
        Database.SaveResult[] lstUpdateList = Database.insert(lstUpdateUserObject, false);
        for (Integer i = 0; i < lstUpdateList.size(); i++) {
            if (lstUpdateList[i].isSuccess()) {
                System.debug('Successfully created ID:----------' + lstUpdateList[i].getId());
            } else {
                errorDataMap.put(i, lstUpdateList[i].getErrors()[0].getMessage());
                System.debug('Error: could not create sobject-----------' + 'for array element ' + i + '.');
                System.debug('   The error reported was:-----------' + lstUpdateList[i].getErrors()[0].getMessage() + '\n');
            }
        }


        List < User > lstNewUser2AddPerm = [select id, email from user where email in : newuserEmailIds];

        for (User userDetail: lstNewUser2AddPerm) {
            User user = new User();
            user.id = userDetail.id;
            user.email = userDetail.email;
            lstEmailids2Process.add(userDetail.email);
            lstUserDetails.add(user);
        }

        SetUserPermission(lstUserDetails);



        system.debug('errorDataMap--------' + errorDataMap);
        for (Integer i = 0; i <= lstUpdateUserObject.size(); i++) {
            if (errorDataMap.containsKey(i)) {
                system.debug('lstUpdateUserObject-----' + lstUpdateUserObject[i] + '-----' + errorDataMap.get(i));
                updateSlpFailuer.put(lstUpdateUserObject[i].email, errorDataMap.get(i));
            }
        }

        /*updateStatusForOnboradingUsers = [SELECT Id, Email__c,Status__c,Failure_Log__c FROM SLP_Process_Onboarding_User__c where Email__c in :updateSlpFailuer.keySet()];
        for(SLP_Process_Onboarding_User__c slpUsers : updateStatusForOnboradingUsers){
                        slpUsers.Failure_Log__c = updateSlpFailuer.get(slpUsers.Email__c);
        }
        update updateStatusForOnboradingUsers;

        updateStatusForOnboradingUsers = [select Id,Status__c,Failure_Log__c from SLP_Process_Onboarding_User__c where Email__c in :noHRDDFeeduserEmailIds];
        for(SLP_Process_Onboarding_User__c updatStatus : updateStatusForOnboradingUsers){
                        updatStatus.Failure_Log__c = 'User Not created, HRDD Feed Not Found';
        }  
        update updateStatusForOnboradingUsers;  

        List<SLP_Process_Onboarding_User__c> updateStatusForOnboradingUsers = [SELECT Id, Email__c, SLP_BulkReg_Id__c, Status__c, FormatValid__c, Failure_Log__c, Success_Log__c, New_User__c FROM SLP_Process_Onboarding_User__c where SLP_BulkReg_Id__c=:SLPBulkRegId and email__C in :lstNewUser];
        for (SLP_Process_Onboarding_User__c onBoardUser:updateStatusForOnboradingUsers)
        {
            onBoardUser.New_User__c=true;
        }
        update updateStatusForOnboradingUsers;*/

    }



    public void ProcessUsers() {

            exceutiveDML();

            UpdateESUserRoles(lstRoles, lstUserDetails, mapBoardingUsers, MapFeedItemObject);
            system.debug('lstEmailids ProcessUsers' + lstEmailids);
            system.debug('mapBoardingUsers ProcessUsers' + mapBoardingUsers);
            if (lstEmailids2Process != null && lstEmailids2Process.size() > 0) {
                UpdateRegionAndBusinessGroup(lstEmailids, lstUserDetails, MapFeedItemObject);
                // AddContributorsToCommunity(lstEmailids, mapBoardingUsers);
                AddContributorsToCommunity(lstEmailids2Process, mapBoardingUsers);
                AddMembersToCommunity(lstEmailids2Process, mapBoardingUsers);
                AddContributorsToBoards(lstEmailids2Process, mapBoardingUsers);
                AddMembersToBoards(lstEmailids2Process, mapBoardingUsers);
                //AddExpertiseToUsers(lstEmailids2Process, mapBoardingUsers);
            }
            IsExportToBaordUser = true;
            IsProcessUsersEnabled = false;
            IsOnboardUsersEnabled = false;
            IsUploadFile = false;


        }
        //Updating the users profile with "Base Profile"
        //If the users doesn't contain "ES BASE PROFILE/ IT ADMIN"
        //Then the users will be updated with ES BASE PROFILE.
    public void SetUserProfile(List < User > Users) {
        List < string > lstEmailIds = new List < string > ();
        List < User > lstUser = new List < User > ();
        List < string > lstUserProfileIds = new List < string > ();

        Profile baseProfileId = [SELECT Id, Name FROM Profile where name like 'ES Base Profile'];
        List < Profile > lstProfileIds = [SELECT Id, Name FROM Profile where name like 'ES Base Profile'
            or name like 'IT Administrator'];

        for (Profile profileId: lstProfileIds) {
            lstUserProfileIds.add(profileId.Id);
        }
        Map < Id, String > mapUserEmail = new Map < Id, String > ();
        for (User userItem: Users) {
            lstEmailIds.add(userItem.email);
            mapUserEmail.put(userItem.id, userItem.Email);
        }


        List < User > getEmptyProfileUsers = [Select id, Name, Profileid, email From User where email in : lstEmailIds and Profileid not in : lstUserProfileIds];

        for (User userItem: getEmptyProfileUsers) {
            User userObject = new User();

            userObject.ProfileId = baseProfileId.Id;
            userObject.Id = userItem.Id;
            lstUser.add(userObject);

            lstNewUser.add(userItem.email);
        }

        //update lstUser;
        Database.SaveResult[] lstUpdateProfile = Database.Update(lstUser, false);
        for (Integer i = 0; i < lstUpdateProfile.size(); i++) {
            if (lstUpdateProfile[i].isSuccess()) {
                System.debug('Successfully created ID:-----inside-----' + lstUpdateProfile[i].getId());
            } else {
                System.debug('Inside Failure----------');
                system.debug('mapUserEmaill-----------' + lstUpdateProfile[i].getErrors()[0].getMessage());
                system.debug('lstUpdateProfile-----1------' + lstUpdateProfile[i].getId());
                storeProfileData.put(mapUserEmail.get(lstUpdateProfile[i].getId()), lstUpdateProfile[i].getErrors()[0].getMessage());
            }
        }

    }

    //Updating the users with permissionset with "producer"
    //If the users doesn't contain "Producer/Moderator"
    //Then the users will be updated with Producer.
    public void SetUserPermission(List < User > Users) {
        List < string > lstUserIds = new List < string > ();
        List < User > lstUser = new List < User > ();
        Map < string, Map < string, Boolean >> MapPermissionSet = new Map < string, Map < string, Boolean >> ();
        List < PermissionSetAssignment > lstUpdatePermissionSet = new List < PermissionSetAssignment > ();
        List < PermissionSetAssignment > lstInsertPermissionSet = new List < PermissionSetAssignment > ();

        PermissionSet producerSetID = [SELECT Id, Name FROM PermissionSet where name = 'ES_Social_Learning_Producer'];
        PermissionSet moderatorSetID = [SELECT Id, Name FROM PermissionSet where name = 'ES_Social_Learning_Moderator'];

        for (User userItem: Users) {
            lstUserIds.add(userItem.id);
        }

        List < PermissionSetAssignment > lstPermissionSet = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment where AssigneeId in : lstUserIds];

        for (PermissionSetAssignment perSet: lstPermissionSet) {
            if (MapPermissionSet.ContainsKey(perSet.AssigneeId)) {
                Map < string, boolean > MapPermission = MapPermissionSet.get(perSet.AssigneeId);
                MapPermission.put(perSet.PermissionSetId, true);

                MapPermissionSet.put(perSet.AssigneeId, MapPermission);
            } else {
                Map < string, boolean > MapPermission = new Map < string, boolean > ();
                MapPermission.put(perSet.PermissionSetId, true);

                MapPermissionSet.put(perSet.AssigneeId, MapPermission);
            }
        }

        for (User userItem: Users) {
            if (MapPermissionSet.ContainsKey(userItem.id)) {
                Map < string, boolean > MapPermission = MapPermissionSet.get(userItem.id);

                if ((!MapPermission.containsKey(producerSetID.Id)) && (!MapPermission.containsKey(moderatorSetID.Id))) {
                    PermissionSetAssignment permissionAssignment = new PermissionSetAssignment();
                    permissionAssignment.AssigneeId = userItem.id;
                    permissionAssignment.PermissionSetId = producerSetID.Id;

                    lstInsertPermissionSet.add(permissionAssignment);
                }
            } else {
                PermissionSetAssignment permissionAssignment = new PermissionSetAssignment();
                permissionAssignment.AssigneeId = userItem.id;
                permissionAssignment.PermissionSetId = producerSetID.Id;

                lstInsertPermissionSet.add(permissionAssignment);
            }
        }
        //insert lstUpdatePermissionSet;
        //insert lstInsertPermissionSet;
        Map < Integer, Id > userPermisionId = new Map < Integer, Id > ();
        integer incerment = 0;
        if (incerment < lstUpdatePermissionSet.size()) {
            userPermisionId.put(incerment, lstInsertPermissionSet[incerment].AssigneeId);
            incerment++;
        }
        Database.SaveResult[] lstEsBaseUser = Database.insert(lstInsertPermissionSet, false);
        for (Integer i = 0; i < lstEsBaseUser.size(); i++) {
            if (lstEsBaseUser[i].isSuccess()) {
                System.debug('Successfully created ID:-----lstEsBaseUser-----' + lstEsBaseUser[i].getId());
            } else {
                if (userPermisionId.containsKey(i)) {
                    system.debug('--------inside faliuer-------');
                    system.debug('error in log---------' + lstEsBaseUser[i].getErrors()[0].getMessage());
                    esuserPermisionMap.put(userPermisionId.get(i), lstEsBaseUser[i].getErrors()[0].getMessage());
                }
            }
        }

        for (user userList: [select id, email from user where id in : esuserPermisionMap.keySet()]) {
            permmisionEmail.put(userList.email, esuserPermisionMap.get(userList.id));
        }


    }

    public PageReference exceutiveDML() {

        List < SLP_Process_Onboarding_User__c > failuerUsers = [SELECT Id, Email__c, Status__c, Failure_Log__c FROM SLP_Process_Onboarding_User__c where Email__c in : updateSlpFailuer.keySet()];
        for (SLP_Process_Onboarding_User__c slpUsers: failuerUsers) {
            if (slpUsers.Failure_Log__c != null && slpUsers.Failure_Log__c != '') {
                slpUsers.Failure_Log__c = slpUsers.Failure_Log__c + ' \n ' + updateSlpFailuer.get(slpUsers.Email__c);
            } else {
                slpUsers.Failure_Log__c = updateSlpFailuer.get(slpUsers.Email__c);
            }
        }
        update failuerUsers;

        updateStatusForOnboradingUsers = [select Id, Status__c, Failure_Log__c from SLP_Process_Onboarding_User__c where Email__c in : noHRDDFeeduserEmailIds];
        for (SLP_Process_Onboarding_User__c updatStatus: updateStatusForOnboradingUsers) {
            updatStatus.Failure_Log__c = 'User Not created, HRDD Feed Not Found';

        }
        update updateStatusForOnboradingUsers;


        List < SLP_Process_Onboarding_User__c > updateStatusForOnboradingUsers = [SELECT Id, Email__c, SLP_BulkReg_Id__c, Status__c, FormatValid__c, Failure_Log__c, Success_Log__c, New_User__c FROM SLP_Process_Onboarding_User__c where SLP_BulkReg_Id__c = : SLPBulkRegId and email__C in : lstNewUser];
        for (SLP_Process_Onboarding_User__c onBoardUser: updateStatusForOnboradingUsers) {
            onBoardUser.New_User__c = true;
        }
        update updateStatusForOnboradingUsers;

        List < SLP_Process_Onboarding_User__c > failuerUserPerm = [SELECT Id, Email__c, Status__c, Failure_Log__c FROM SLP_Process_Onboarding_User__c where Email__c in : permmisionEmail.keySet()];

        for (SLP_Process_Onboarding_User__c slpProcess: failuerUserPerm) {
            if (slpProcess.Failure_Log__c != null && slpProcess.Failure_Log__c != '') {
                slpProcess.Failure_Log__c = slpProcess.Failure_Log__c + ' \n ' + permmisionEmail.get(slpProcess.Email__c);
            } else {
                slpProcess.Failure_Log__c = permmisionEmail.get(slpProcess.Email__c);
            }
        }
        update failuerUserPerm;



        List < SLP_Process_Onboarding_User__c > failuerUsersProfiles = [SELECT Id, Email__c, Status__c, Failure_Log__c FROM SLP_Process_Onboarding_User__c where Email__c in : storeProfileData.keySet()];
        for (SLP_Process_Onboarding_User__c slpUsers: failuerUsersProfiles) {
            if (slpUsers.Failure_Log__c != null && slpUsers.Failure_Log__c != '') {
                slpUsers.Failure_Log__c = slpUsers.Failure_Log__c + ' \n ' + storeProfileData.get(slpUsers.Email__c);
            } else {
                slpUsers.Failure_Log__c = storeProfileData.get(slpUsers.Email__c);
            }
        }
        update failuerUsersProfiles;

        return null;
    }



    //Update Roles, 
    public void UpdateESUserRoles(List < string > Roles, List < User > Users, Map < string, SLP_Process_Onboarding_User__c > mapBoardingUsers, Map < string, SLP_ES_Emp_HRDD_Feed__c > MapFeedItemObject) {
        System.debug('Roles:' + Roles.size());
        System.debug('Users:' + Users.size());
        System.debug('mapBoardingUsers:' + mapBoardingUsers.size());
        System.debug('Roles:' + Roles.size());
        System.debug('MapFeedItemObject:' + MapFeedItemObject.size());

        Map < string, ES_User__c > mapESUser = new Map < string, ES_User__c > ();
        Map < string, string > mapRoleList = new Map < string, string > ();
        List < string > lstUsers = new List < string > ();
        List < ES_User__c > lstESInsertUser = new List < ES_User__c > ();
        List < ES_User__c > lstESUpdateUser = new List < ES_User__c > ();
        List < SLP_Role__c > RolesListSlp = new List < SLP_Role__c > ();

        List < ES_User__c > lstUserESObject = [SELECT Id, OwnerId, User_Id__c, Twitter__c, Linked_In__c, Role_ID__c, Region_Id__c, Business_Group_Id__c FROM ES_User__c];
        List < SLP_Role__c > lstSLPRoles = [SELECT Id, Role_Name__c, Is_Active__c, OwnerId FROM SLP_Role__c where Role_Name__c in : Roles];

        for (SLP_Role__c usrRole: lstSLPRoles) {
            if (usrRole.Role_Name__c != null & usrRole.Role_Name__c != '') {
                mapRoleList.Put(usrRole.Role_Name__c.trim().toLowerCase(), usrRole.Id);
            }
        }

        System.debug('UpdateESUserRoles mapRoleList :' + mapRoleList.size() + mapRoleList);
        map < string, boolean > mapRoleExist = new map < string, boolean > ();
        for (string Role: Roles) {
            SLP_Role__c roleSLP = new SLP_Role__c();
            if (Role != null & Role != '') {
                if (!mapRoleList.ContainsKey(Role.trim().toLowerCase()) & !mapRoleExist.ContainsKey(Role.trim().toLowerCase())) {
                    roleSLP.Role_Name__c = Role;
                    roleSLP.Is_Active__c = true;
                    mapRoleExist.put(Role, true);
                    RolesListSlp.add(roleSLP);
                }
            }
        }
        System.debug('UpdateESUserRoles RolesListSlp :' + RolesListSlp.size() + RolesListSlp);
        Map < Integer, String > slpMasterMap = new Map < Integer, String > ();
        integer iMaster = 0;
        if (iMaster < RolesListSlp.size()) {
            slpMasterMap.put(iMaster, RolesListSlp[iMaster].Role_Name__c);
            iMaster++;
        }
        Map < String, String > masterMapToUpdate = new Map < String, String > ();

        if (RolesListSlp.size() > 0) {
            //insert RolesListSlp;
            Database.SaveResult[] lstInsertMasterRole = Database.insert(RolesListSlp, false);
            for (Integer i = 0; i < lstInsertMasterRole.size(); i++) {
                if (lstInsertMasterRole[i].isSuccess()) {

                } else {
                    masterMapToUpdate.put(slpMasterMap.get(i), lstInsertMasterRole[i].getErrors()[0].getMessage());
                }
            }

            List < SLP_Process_Onboarding_User__c > failMasterRole = [SELECT Id, Email__c, Status__c, Failure_Log__c, Role__c FROM SLP_Process_Onboarding_User__c where Role__c in : masterMapToUpdate.keySet()];
            for (SLP_Process_Onboarding_User__c fmr: failMasterRole) {
                if (fmr.Failure_Log__c != null && fmr.Failure_Log__c != '') {
                    fmr.Failure_Log__c = fmr.Failure_Log__c + ' \n ' + masterMapToUpdate.get(fmr.Role__c);
                } else {
                    fmr.Failure_Log__c = masterMapToUpdate.get(fmr.Role__c);
                }

            }
            update failMasterRole;

            for (SLP_Role__c slpRole: RolesListSlp) {
                mapRoleList.put(slpRole.Role_Name__c.trim().toLowerCase(), slpRole.Id);
            }
        }

        System.debug('mapRoleList:' + mapRoleList.size());
        string strule = '';
        for (ES_User__c esuserItem: lstUserESObject) {
            mapESUser.put(esuserItem.User_Id__c, esuserItem);
            strule = esuserItem.User_Id__c;

        }
        system.debug(' AV ES' + strule.length());
        for (User user: Users) {
            ES_User__c esUser = new ES_User__c();
            SLP_ES_Emp_HRDD_Feed__c slpEmpHrdFeed = new SLP_ES_Emp_HRDD_Feed__c();
            SLP_Process_Onboarding_User__c boardingUsers = new SLP_Process_Onboarding_User__c();

            System.debug('userId:' + user.id);
            string uid = user.Id;
            system.debug('AV uid length ' + uid.length());
            //check is user already exists in ESUser Object
            if (mapESUser.containsKey(uid)) {
                System.debug('Contains USERID:');
                System.debug('user email:' + user.email);
                esUser = mapESUser.get(user.Id);

                boardingUsers = mapBoardingUsers.get(user.email);

                System.debug('boardingUsers:' + boardingUsers);

                esUser.SLP_Bussiness_User__c = true;

                if (boardingUsers != null) {
                    if (boardingUsers.Role__c != null & boardingUsers.Role__c != '') {
                        if (mapRoleList.ContainsKey(boardingUsers.Role__c.trim().toLowerCase())) {
                            esUser.Role_ID__c = mapRoleList.get(boardingUsers.Role__c.trim().toLowerCase());
                            System.debug('UpdateESUserRoles RoleId :' + esUser.Role_ID__c + boardingUsers.Role__c.trim().toLowerCase());

                        }
                    }
                }
                lstESUpdateUser.add(esUser);
            } else {
                boardingUsers = mapBoardingUsers.get(user.email);

                esUser.User_Id__c = user.Id;
                esUser.SLP_Bussiness_User__c = true;

                if (boardingUsers != null) {
                    if (boardingUsers.Role__c != null & boardingUsers.Role__c != '') {
                        if (mapRoleList.ContainsKey(boardingUsers.Role__c.trim().toLowerCase())) {
                            esUser.Role_ID__c = mapRoleList.get(boardingUsers.Role__c.trim().toLowerCase());
                            System.debug('UpdateESUserRoles RoleId :' + esUser.Role_ID__c + boardingUsers.Role__c.trim().toLowerCase());
                        }
                    }
                }
                lstESInsertUser.add(esUser);
            }
        }
        System.debug('UpdateESUserRoles lstESUpdateUser :' + lstESUpdateUser);
        System.debug('UpdateESUserRoles lstESInsertUser :' + lstESInsertUser);
        update lstESUpdateUser;
        insert lstESInsertUser;
    }

    public void UpdateRegionAndBusinessGroup(List < string > lstEmailids, List < User > Users, Map < string, SLP_ES_Emp_HRDD_Feed__c > MapFeedItemObject) {
        System.debug('lstEmailids:' + lstEmailids.size());
        System.debug('Users:' + Users.size());
        System.debug('MapFeedItemObject:' + MapFeedItemObject.size());

        Map < string, string > mapRegion = new Map < string, string > ();
        Map < string, string > mapBG = new Map < string, string > ();
        List < SLP_Region__c > lstNewRegions = new List < SLP_Region__c > ();
        List < SLP_Business_Group__c > lstNewGroups = new List < SLP_Business_Group__c > ();
        Map < string, ES_User__c > mapESUser = new Map < string, ES_User__c > ();
        List < ES_User__c > lstESUpdateUser = new List < ES_User__c > ();
        List < ES_User__c > lstESInsertUser = new List < ES_User__c > ();

        List < SLP_Region__c > lstRegion = [SELECT Id, Region_Name__c, Is_Active__c FROM SLP_Region__c];
        List < SLP_Business_Group__c > lstBusGrp = [SELECT Id, Business_Group_Name__c, Is_Active__c FROM SLP_Business_Group__c];
        List < SLP_ES_Emp_HRDD_Feed__c > lstESEmpRegion = [SELECT Region__c FROM SLP_ES_Emp_HRDD_Feed__c where email__C in : lstEmailids];
        List < SLP_ES_Emp_HRDD_Feed__c > lstESEmpBusGroup = [SELECT Business_Group__c FROM SLP_ES_Emp_HRDD_Feed__c where email__C in : lstEmailids];

        for (SLP_Region__c rgn: lstRegion) {
            mapRegion.Put(rgn.Region_Name__c.trim().toLowerCase(), rgn.Id);
        }

        for (SLP_Business_Group__c bg: lstBusGrp) {
            mapBG.Put(bg.Business_Group_Name__c.trim().toLowerCase(), bg.Id);
        }
        Map < string, boolean > mapRegionExist = new Map < string, boolean > ();
        for (SLP_ES_Emp_HRDD_Feed__c feedData: lstESEmpRegion) {
            SLP_Region__c slpRegion = new SLP_Region__c();

            if (!mapRegion.ContainsKey(feedData.Region__c.trim().toLowerCase()) & !mapRegionExist.ContainsKey(feedData.Region__c.trim().toLowerCase())) {
                slpRegion.Region_Name__c = feedData.Region__c;
                slpRegion.Is_Active__c = true;
                mapRegionExist.put(feedData.Region__c, true);
                lstNewRegions.add(slpRegion);
            }
        }

        //insert lstNewRegions;
        Map < Integer, String > regionMap = new Map < Integer, String > ();
        Integer slpRegion = 0;
        if (slpRegion < lstNewRegions.size()) {
            regionMap.put(slpRegion, lstNewRegions[slpRegion].Region_Name__c);
        }

        Map < String, STring > updateNewRegion = new Map < String, String > ();
        Database.SaveResult[] lstInsertNewRegions = Database.insert(lstNewRegions, false);
        for (Integer i = 0; i < lstInsertNewRegions.size(); i++) {
            if (lstInsertNewRegions[i].isSuccess()) {} else {
                updateNewRegion.put(regionMap.get(i), lstInsertNewRegions[i].getErrors()[0].getMessage());
            }
        }
        Map < String, String > hrrdMap = new Map < String, String > ();
        for (SLP_ES_Emp_HRDD_Feed__c regHrr: [SELECT email__C, Region__c FROM SLP_ES_Emp_HRDD_Feed__c where Region__c in : updateNewRegion.keySet()]) {
            hrrdMap.put(regHrr.email__C, updateNewRegion.get(regHrr.Region__c));
        }

        List < SLP_Process_Onboarding_User__c > updateRegionOnboard = [SELECT Id, Email__c, Status__c, Failure_Log__c FROM SLP_Process_Onboarding_User__c where Email__c in : hrrdMap.keySet()];
        for (SLP_Process_Onboarding_User__c slp: updateRegionOnboard) {
            if (slp.Failure_Log__c != null && slp.Failure_Log__c != '') {
                slp.Failure_Log__c = slp.Failure_Log__c + ' \n ' + hrrdMap.get(slp.Email__c);
            } else {
                slp.Failure_Log__c = hrrdMap.get(slp.Email__c);
            }

        }
        update updateRegionOnboard;


        for (SLP_Region__c rgn: lstNewRegions) {
            mapRegion.Put(rgn.Region_Name__c.trim().toLowerCase(), rgn.Id);
        }
        Map < string, boolean > mapBGExist = new Map < string, boolean > ();
        for (SLP_ES_Emp_HRDD_Feed__c feedData: lstESEmpBusGroup) {
            SLP_Business_Group__c slpBusgrp = new SLP_Business_Group__c();

            if (!mapBG.ContainsKey(feedData.Business_Group__c.trim().toLowerCase()) & !mapBGExist.ContainsKey(feedData.Business_Group__c.trim().toLowerCase())) {
                slpBusgrp.Business_Group_Name__c = feedData.Business_Group__c;
                slpBusgrp.Is_Active__c = true;
                mapBGExist.put(feedData.Business_Group__c, true);
                lstNewGroups.add(slpBusgrp);
            }
        }

        //insert lstNewGroups;
        regionMap.clear();
        Integer intGroup = 0;
        if (intGroup < lstNewGroups.size()) {
            regionMap.put(intGroup, lstNewGroups[intGroup].Business_Group_Name__c);
        }
        updateNewRegion.clear();
        Database.SaveResult[] lstInsertNewGroups = Database.insert(lstNewGroups, false);
        for (Integer i = 0; i < lstInsertNewGroups.size(); i++) {
            if (lstInsertNewGroups[i].isSuccess()) {} else {
                updateNewRegion.put(regionMap.get(i), lstInsertNewGroups[i].getErrors()[0].getMessage());
            }
        }
        hrrdMap.clear();
        for (SLP_ES_Emp_HRDD_Feed__c regHrr: [SELECT email__C, Business_Group__c FROM SLP_ES_Emp_HRDD_Feed__c where Business_Group__c in : updateNewRegion.keySet()]) {
            hrrdMap.put(regHrr.email__C, updateNewRegion.get(regHrr.Business_Group__c));
        }

        List < SLP_Process_Onboarding_User__c > updateBUsinessboard = [SELECT Id, Email__c, Status__c, Failure_Log__c FROM SLP_Process_Onboarding_User__c where Email__c in : hrrdMap.keySet()];
        system.debug('updateBUsinessboard-----1-----' + updateBUsinessboard);
        for (SLP_Process_Onboarding_User__c slp: updateBUsinessboard) {
            if (slp.Failure_Log__c != null && slp.Failure_Log__c != '') {
                slp.Failure_Log__c = slp.Failure_Log__c + ' \n ' + hrrdMap.get(slp.Email__c);
            } else {
                slp.Failure_Log__c = hrrdMap.get(slp.Email__c);
            }

        }

        update updateBUsinessboard;



        for (SLP_Business_Group__c rgn: lstNewGroups) {
            mapBG.Put(rgn.Business_Group_Name__c.trim().toLowerCase(), rgn.Id);
        }

        List < ES_User__c > lstUserESObject = [SELECT Id, OwnerId, User_Id__c, Twitter__c, Linked_In__c, Role_ID__c, Region_Id__c, Business_Group_Id__c FROM ES_User__c];

        for (ES_User__c esuserItem: lstUserESObject) {
            mapESUser.put(esuserItem.User_Id__c, esuserItem);
        }

        System.debug('Before For:');
        System.debug('Users:' + Users.size());

        for (User user: Users) {
            System.debug('Inside For:' + user.Id);

            ES_User__c esUser = new ES_User__c();
            SLP_ES_Emp_HRDD_Feed__c slpEmpHrdFeed = new SLP_ES_Emp_HRDD_Feed__c();

            //check is user already exists in ESUser Object
            if (mapESUser.containsKey(user.Id)) {
                System.debug('RegionNGroup:' + user.Id);
                esUser = mapESUser.get(user.Id);

                slpEmpHrdFeed = MapFeedItemObject.get(user.email);

                System.debug('RegionNGroup Email:' + user.email);
                System.debug('RegionNGroup slpEmpHrdFeed:' + slpEmpHrdFeed);

                if (slpEmpHrdFeed != null) {
                    esUser.Region_Id__c = mapRegion.get(slpEmpHrdFeed.Region__c.trim().toLowerCase());
                    esUser.Business_Group_Id__c = mapBG.get(slpEmpHrdFeed.Business_Group__c.trim().toLowerCase());

                    System.debug('slpEmpHrdFeed.Region__c:' + slpEmpHrdFeed.Region__c);
                    System.debug('slpEmpHrdFeed.Business_Group__c:' + slpEmpHrdFeed.Business_Group__c);
                }

                lstESUpdateUser.add(esUser);
            } else {
                esUser = mapESUser.get(user.Id);
                esUser.User_Id__c = user.Id;

                slpEmpHrdFeed = MapFeedItemObject.get(user.email);
                if (slpEmpHrdFeed != null) {
                    esUser.Region_Id__c = mapRegion.get(slpEmpHrdFeed.Region__c);
                    esUser.Business_Group_Id__c = mapBG.get(slpEmpHrdFeed.Business_Group__c);
                }

                lstESInsertUser.add(esUser);
            }
        }

        update lstESUpdateUser;
        insert lstESInsertUser;
    }

    public void AddContributorsToCommunity(List < string > lstEmailIds, Map < string, SLP_Process_Onboarding_User__c > mapBoardingUsers) {
        List < string > lstCommunityNames = new List < string > ();
        Map < string, boolean > mapCtrbtr;
        Map < string, Map < string, boolean >> MapComContrUserDetails = new Map < string, Map < string, boolean >> ();

        List < User > lstUsers = [SELECT Id, Email FROM User where Email in : lstEmailIds and IsActive = : true];

        for (string strEmail: lstEmailIds) {
            mapCtrbtr = new Map < string, boolean > ();
            SLP_Process_Onboarding_User__c boardingUsers = new SLP_Process_Onboarding_User__c();
            boardingUsers = mapBoardingUsers.get(strEmail);
            system.debug('AV Comm boardingUsers' + boardingUsers);
            if (boardingUsers.Community_Contributor__c != null && boardingUsers.Community_Contributor__c != '') {
                string[] strInput = boardingUsers.Community_Contributor__c.split(';');
                for (string strItem: strInput) {
                    mapCtrbtr.put(strItem.trim().toLowerCase(), true);
                    lstCommunityNames.add(strItem.trim().toLowerCase());
                }
                MapComContrUserDetails.put(strEmail, mapCtrbtr);
            }
        }
        system.debug('MapComContrUserDetails' + MapComContrUserDetails);
        system.debug('lstCommunityNames---------' + lstCommunityNames);
        List < Community__c > lstCommunityDetails = [SELECT Id, Name__c, Description__c, Public__c, IsActive__c FROM Community__c where Name__c in : lstCommunityNames];

        //-------AddContributors to community-----------

        for (Community__c cmm: lstCommunityDetails) {
            commMap.put(cmm.Name__c.trim().toLowerCase(), cmm.Id);
        }
        Map < String, String > newMapList = new Map < String, String > ();
        for (String cmName: lstCommunityNames) {
            if (!commMap.containsKey(cmName)) {
                newMapList.put(cmName.trim().toLowerCase(), cmName.trim().toLowerCase());
            }
        }
        List < SLP_Process_Onboarding_User__c > slpToUpadte = new List < SLP_Process_Onboarding_User__c > ();
        List < SLP_Process_Onboarding_User__c > slpProcessBoard = [SELECT Community_Contributor__c, Failure_Log__c, SLP_BulkReg_Id__c, Community_Member__c, Board_Contributor__c, Board_Member__c FROM SLP_Process_Onboarding_User__c where SLP_BulkReg_Id__c = : SLPBulkRegId];
        for (SLP_Process_Onboarding_User__c slp: slpProcessBoard) {
            if (slp.Community_Contributor__c != null && slp.Community_Contributor__c != '') {
                List < string > lstSplit = new List < string > ();
                if (slp.Community_Contributor__c.contains(';')) {
                    lstSplit = slp.Community_Contributor__c.split(';');
                } else {
                    lstSplit.add(slp.Community_Contributor__c);
                }
                if (lstSplit != null && lstSplit.size() > 0) {
                    for (string str: lstSplit) {
                        if (newMapList.containsKey(str.trim().toLowerCase())) {
                            if (slp.Failure_Log__c != null && slp.Failure_Log__c != '') {
                                slp.Failure_Log__c = slp.Failure_Log__c + ' \n ' + '-Community Not Found [' + str + ']';
                            } else {
                                slp.Failure_Log__c = '-Community Not Found [' + str + ']';
                                system.debug('slp.Failure_Log__c-----------else----' + slp.Failure_Log__c);
                            }
                        }
                    }
                    slpToUpadte.add(slp);
                }

            }
        }
        update slpToUpadte;
        // End

        Map < string, string > mapCommunityKeyPair = new Map < string, string > ();
        for (Community__c cData: lstCommunityDetails) {
            mapCommunityKeyPair.put(cData.Name__c.trim().toLowerCase(), cData.Id);
        }

        Map < string, List < string >> mapUsersWithCommunityIds = new Map < string, List < string >> ();
        List < string > lstCommunityIds;
        List < string > lstcomIdForSearch = new List < string > ();

        for (User user: lstUsers) {
            lstCommunityIds = new List < string > ();
            if (MapComContrUserDetails.ContainsKey(user.Email)) {
                Map < string, boolean > getCommunityNamesByEmail = MapComContrUserDetails.get(user.Email);

                for (string Name: getCommunityNamesByEmail.keyset()) {
                    string CommunityId = mapCommunityKeyPair.get(Name.trim().toLowerCase());
                    if (CommunityId != null) {
                        lstCommunityIds.add(CommunityId);
                        lstcomIdForSearch.add(CommunityId);
                    }
                }
                mapUsersWithCommunityIds.put(user.Id, lstCommunityIds);
            }
        }

        Map < string, Map < string, Boolean >> mapContributeUsers = new Map < string, Map < string, Boolean >> ();
        set < ID > contributorIds = new set < ID > ();
        system.debug('Alur1 Contr' + lstCommunityIds);
        List < Community__Share > communityContributorslst = new List < Community__Share > ();
        communityContributorslst = [SELECT Id, ParentId, UserOrGroupId, AccessLevel FROM Community__Share where ParentId in : lstcomIdForSearch];

        system.debug('communityContributorslst' + communityContributorslst);
        for (Community__Share commItem: communityContributorslst) {
            contributorIds.add(commItem.UserOrGroupId);

            if (mapContributeUsers.ContainsKey(commItem.UserOrGroupId)) {
                Map < string, boolean > mapBoardOrCommunity = new Map < string, boolean > ();
                mapBoardOrCommunity = mapContributeUsers.get(commItem.UserOrGroupId);
                mapBoardOrCommunity.put(commItem.ParentId, true);
                mapContributeUsers.put(commItem.UserOrGroupId, mapBoardOrCommunity);
            } else {
                Map < string, boolean > mapBoardCommunity = new Map < string, boolean > ();
                mapBoardCommunity.put(commItem.ParentId, true);
                mapContributeUsers.put(commItem.UserOrGroupId, mapBoardCommunity);
            }
        }

        List < Community_Member__c > lstCommunityMembers = [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where Status__c = 'Approved'
            and Community_Id__c in : lstcomIdForSearch];
        Map < string, Map < string, Community_Member__c >> mapMemberUsers = new Map < string, Map < string, Community_Member__c >> ();
        for (Community_Member__c commItem: lstCommunityMembers) {
            // MemberIds.add(commItem.User_Id__c);

            if (mapMemberUsers.ContainsKey(commItem.User_Id__c)) {
                Map < string, Community_Member__c > mapBoardOrCommunity = mapMemberUsers.get(commItem.User_Id__c);
                mapBoardOrCommunity.put(commItem.Community_Id__c, commItem);

                mapMemberUsers.put(commItem.User_Id__c, mapBoardOrCommunity);
            } else {
                Map < string, Community_Member__c > mapBoardCommunity = new Map < string, Community_Member__c > ();
                mapBoardCommunity.put(commItem.Community_Id__c, commItem);

                mapMemberUsers.put(commItem.User_Id__c, mapBoardCommunity);
            }
        }

        List < Community__Share > queuedUsersToBeContributors = new List < Community__Share > ();
        Map < string, Community_Member__c > mapBoardCommunityMemb;
        List < Community_Member__c > lstDeleteCommunityMembers = new List < Community_Member__c > ();
        for (User user: lstUsers) {
            List < string > getCommunityIdsByUserId = mapUsersWithCommunityIds.get(user.Id);

            if (getCommunityIdsByUserId != null) {
                if (getCommunityIdsByUserId.size() > 0) {
                    for (string communityId: getCommunityIdsByUserId) {
                        //delete comm member if already and making them as contributor
                        if (mapMemberUsers != null && mapMemberUsers.size() > 0) {
                            if (mapMemberUsers.containsKey(user.Id)) {
                                mapBoardCommunityMemb = new Map < string, Community_Member__c > ();
                                mapBoardCommunityMemb = mapMemberUsers.get(user.Id);
                                if (mapBoardCommunityMemb.containsKey(communityId)) {
                                    lstDeleteCommunityMembers.add(mapBoardCommunityMemb.get(communityId));

                                }
                            }
                        }

                        //Check if the contributor already exists for the community. If not add to list
                        if (mapContributeUsers.size() > 0) {
                            if (!mapContributeUsers.containsKey(user.Id)) {
                                Community__Share comShare = new Community__Share();

                                comShare.UserOrGroupId = user.Id;
                                comShare.ParentId = communityId;
                                comShare.AccessLevel = 'Edit';

                                queuedUsersToBeContributors.add(comShare);
                            } else if (mapContributeUsers.containsKey(user.Id)) {
                                Map < string, boolean > mapIsContributor = mapContributeUsers.get(user.Id);

                                if (!mapIsContributor.containsKey(communityId)) {
                                    Community__Share comShare = new Community__Share();

                                    comShare.UserOrGroupId = user.Id;
                                    comShare.ParentId = communityId;
                                    comShare.AccessLevel = 'Edit';

                                    queuedUsersToBeContributors.add(comShare);
                                }
                            }
                        } else if (mapContributeUsers.size() == 0) {
                            Community__Share comShare = new Community__Share();

                            comShare.UserOrGroupId = user.Id;
                            comShare.ParentId = communityId;
                            comShare.AccessLevel = 'Edit';

                            queuedUsersToBeContributors.add(comShare);
                        }
                    }
                }
            }
        }
        system.debug('Comm Contr AV' + queuedUsersToBeContributors);
        if (queuedUsersToBeContributors.size() > 0) {
            insert queuedUsersToBeContributors;
        }
        if (lstDeleteCommunityMembers.size() > 0) {
            delete lstDeleteCommunityMembers;
        }
    }

    public void AddMembersToCommunity(List < string > listOfEmailIds, Map < string, SLP_Process_Onboarding_User__c > mapProcessOnBoardUsers) {
        List < string > lstCommunityIds;
        List < string > lstCommunityNames = new List < string > ();
        Map < string, boolean > mapMembers;
        Map < string, string > mapCommunityKeyPair = new Map < string, string > ();
        Map < string, List < string >> mapUsersWithCommunityIds = new Map < string, List < string >> ();
        Map < string, Map < string, boolean >> MapComMemUserDetails = new Map < string, Map < string, boolean >> ();

        List < User > lstUsers = [SELECT Id, Email FROM User where Email in : listOfEmailIds and IsActive = : true];
        system.debug('AddMembersToCommunity - listOfEmailIds' + listOfEmailIds);
        for (string strEmail: listOfEmailIds) {
            SLP_Process_Onboarding_User__c boardingUsers = new SLP_Process_Onboarding_User__c();
            boardingUsers = mapProcessOnBoardUsers.get(strEmail);
            mapMembers = new Map < string, boolean > ();
            if (boardingUsers.Community_Member__c != null && boardingUsers.Community_Member__c != '') {
                string[] strInput = boardingUsers.Community_Member__c.split(';');
                for (string strItem: strInput) {
                    mapMembers.put(strItem.trim().toLowerCase(), true);
                    lstCommunityNames.add(strItem.trim().toLowerCase());
                }
                MapComMemUserDetails.put(strEmail, mapMembers);
            }
        }
        system.debug('AddMembersToCommunity - MapComMemUserDetails' + MapComMemUserDetails);
        system.debug('AddMembersToCommunity - lstCommunityNames' + lstCommunityNames);
        List < Community__c > lstCommunityDetails = [SELECT Id, Name__c, Description__c, Public__c, IsActive__c FROM Community__c where Name__c in : lstCommunityNames];
        //--------------Add members to coumminty--------

        commMap.clear();
        for (Community__c cmm: lstCommunityDetails) {
            commMap.put(cmm.Name__c.trim().toLowerCase(), cmm.Id);
        }
        Map < String, String > newMapLsit = new Map < String, String > ();
        for (String cmName: lstCommunityNames) {
            if (!commMap.containsKey(cmName)) {
                newMapLsit.put(cmName.trim().toLowerCase(), cmName.trim().toLowerCase());
            }
        }
        List < SLP_Process_Onboarding_User__c > slpToUpdate = new List < SLP_Process_Onboarding_User__c > ();
        List < SLP_Process_Onboarding_User__c > slpCommunityOnBoard = [SELECT Community_Contributor__c, Failure_Log__c, SLP_BulkReg_Id__c, Community_Member__c, Board_Contributor__c, Board_Member__c FROM SLP_Process_Onboarding_User__c where SLP_BulkReg_Id__c = : SLPBulkRegId];
        for (SLP_Process_Onboarding_User__c slp: slpCommunityOnBoard) {
            if (slp.Community_Member__c != null && slp.Community_Member__c != '') {
                List < string > lstSplit = new List < string > ();
                if (slp.Community_Member__c.contains(';')) {
                    lstSplit = slp.Community_Member__c.split(';');
                } else {
                    lstSplit.add(slp.Community_Member__c);
                }
                if (lstSplit != null && lstSplit.size() > 0) {
                    for (string str: lstSplit) {
                        if (newMapLsit.containsKey(str.trim().toLowerCase())) {
                            if (slp.Failure_Log__c != null && slp.Failure_Log__c != '') {
                                slp.Failure_Log__c = slp.Failure_Log__c + ' \n ' + '-Community Not Found [' + str + ']';
                            } else {
                                slp.Failure_Log__c = '-Community Not Found [' + str + ']';
                                system.debug('slp.Failure_Log__c-----------else----' + slp.Failure_Log__c);
                            }
                        }

                    }
                    slpToUpdate.add(slp);
                }
            }
        }
        update slpToUpdate;

        //End
        for (Community__c cData: lstCommunityDetails) {
            mapCommunityKeyPair.put(cData.Name__c.trim().toLowerCase(), cData.Id);
        }
        system.debug('AddMembersToCommunity - mapCommunityKeyPair' + mapCommunityKeyPair);
        list < string > lstComIds = new List < string > ();
        for (User user: lstUsers) {
            lstCommunityIds = new List < string > ();
            if (MapComMemUserDetails.ContainsKey(user.Email)) {
                Map < string, boolean > getCommunityNamesByEmail = MapComMemUserDetails.get(user.Email);

                for (string Name: getCommunityNamesByEmail.keyset()) {
                    string CommunityId = mapCommunityKeyPair.get(Name.trim().toLowerCase());
                    if (CommunityId != null) {
                        lstCommunityIds.add(CommunityId);
                        lstComIds.add(CommunityId);
                    }
                }
                mapUsersWithCommunityIds.put(user.Id, lstCommunityIds);
            }
        }
        system.debug('AddMembersToCommunity - mapUsersWithCommunityIds' + mapUsersWithCommunityIds);
        Map < string, Map < string, Boolean >> mapMemberUsers = new Map < string, Map < string, Boolean >> ();
        set < ID > MemberIds = new set < ID > ();

        List < Community_Member__c > lstCommunityMembers = [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where Status__c = 'Approved'
            and Community_Id__c in : lstComIds];

        system.debug('AddMembersToCommunity - lstCommunityIds' + lstCommunityIds);
        system.debug('AddMembersToCommunity - lstComIds' + lstComIds);
        //Start:- To check whether user already contributor or owner for these communities
        List < Community__Share > lstcommunityContributors = [SELECT Id, ParentId, UserOrGroupId, AccessLevel FROM Community__Share where ParentId in : lstComIds];
        Map < string, Map < string, Boolean >> mapContributorCommunityIds = new Map < string, Map < string, Boolean >> ();
        for (Community__Share commItem: lstcommunityContributors) {

            if (mapContributorCommunityIds.ContainsKey(commItem.UserOrGroupId)) {
                Map < string, boolean > mapBoardOrCommunity = mapContributorCommunityIds.get(commItem.UserOrGroupId);
                mapBoardOrCommunity.put(commItem.ParentId, true);

                mapContributorCommunityIds.put(commItem.UserOrGroupId, mapBoardOrCommunity);
            } else {
                Map < string, boolean > mapBoardCommunity = new Map < string, boolean > ();
                mapBoardCommunity.put(commItem.ParentId, true);

                mapContributorCommunityIds.put(commItem.UserOrGroupId, mapBoardCommunity);
            }
        }
        //End
        system.debug('AddMembersToCommunity - mapContributorCommunityIds' + mapContributorCommunityIds);


        for (Community_Member__c commItem: lstCommunityMembers) {
            MemberIds.add(commItem.User_Id__c);

            if (mapMemberUsers.ContainsKey(commItem.User_Id__c)) {
                Map < string, boolean > mapBoardOrCommunity = mapMemberUsers.get(commItem.User_Id__c);
                mapBoardOrCommunity.put(commItem.Community_Id__c, true);

                mapMemberUsers.put(commItem.User_Id__c, mapBoardOrCommunity);
            } else {
                Map < string, boolean > mapBoardCommunity = new Map < string, boolean > ();
                mapBoardCommunity.put(commItem.Community_Id__c, true);

                mapMemberUsers.put(commItem.User_Id__c, mapBoardCommunity);
            }
        }
        system.debug('AddMembersToCommunity - mapMemberUsers' + mapMemberUsers);
        List < Community_Member__c > queuedUsersToBeMembers = new List < Community_Member__c > ();
        Map < string, boolean > mapCommunityContr;
        for (User user: lstUsers) {
            if (mapUsersWithCommunityIds.containsKey(user.Id)) {
                mapCommunityContr = new Map < string, boolean > ();
                if (mapContributorCommunityIds.containsKey(user.Id)) {
                    mapCommunityContr = mapContributorCommunityIds.get(user.Id);
                }
                List < string > getCommunityIdsByUserId = mapUsersWithCommunityIds.get(user.Id);

                if (getCommunityIdsByUserId != null) {
                    if (getCommunityIdsByUserId.size() > 0) {
                        for (string communityId: getCommunityIdsByUserId) {
                            boolean addMember = true;
                            if (mapCommunityContr != null) {
                                if (mapCommunityContr.containsKey(communityId)) {
                                    addMember = false;
                                }
                            }

                            if (addMember) {

                                //Check if the contributor already exists for the community. If not add to list
                                if (mapMemberUsers.size() > 0) {
                                    if (!mapMemberUsers.containsKey(user.Id)) {
                                        Community_Member__c comMember = new Community_Member__c();

                                        comMember.User_Id__c = user.Id;
                                        comMember.Status__c = 'APPROVED';
                                        comMember.Community_Id__c = communityId;

                                        queuedUsersToBeMembers.add(comMember);
                                    } else if (mapMemberUsers.containsKey(user.Id)) {
                                        Map < string, boolean > mapIsMember = mapMemberUsers.get(user.Id);

                                        if (!mapIsMember.containsKey(communityId)) {
                                            Community_Member__c comMember = new Community_Member__c();

                                            comMember.User_Id__c = user.Id;
                                            comMember.Status__c = 'APPROVED';
                                            comMember.Community_Id__c = communityId;

                                            queuedUsersToBeMembers.add(comMember);
                                        }
                                    }
                                } else if (mapMemberUsers.size() == 0) {
                                    Community_Member__c comMember = new Community_Member__c();

                                    comMember.User_Id__c = user.Id;
                                    comMember.Status__c = 'APPROVED';
                                    comMember.Community_Id__c = communityId;

                                    queuedUsersToBeMembers.add(comMember);
                                }
                            }
                        }
                    }
                }
            }
        }
        if (queuedUsersToBeMembers.size() > 0) {
            insert queuedUsersToBeMembers;
        }
    }

    public void AddMembersToBoards(List < string > listOfEmailIds, Map < string, SLP_Process_Onboarding_User__c > mapProcessOnBoardUsers) {
        List < string > lstBoardIds;
        List < string > lstUserIds = new List < string > ();
        List < string > lstBoardNames = new List < string > ();
        Map < string, boolean > mapMember;
        Map < string, string > mapBoardKeyPair = new Map < string, string > ();
        List < Learning_Board_Member__c > queuedUsersToBeMembers = new List < Learning_Board_Member__c > ();
        Map < string, Map < string, boolean >> MapBrdMemberUserDetails = new Map < string, Map < string, boolean >> ();
        Map < string, List < string >> mapUsersWithBrdIds = new Map < string, List < string >> ();

        List < User > lstUsers = [SELECT Id, Email FROM User where Email in : listOfEmailIds];
        system.debug('lstUsers' + lstUsers);
        for (string strEmail: listOfEmailIds) {
            SLP_Process_Onboarding_User__c boardingUsers = new SLP_Process_Onboarding_User__c();
            boardingUsers = mapProcessOnBoardUsers.get(strEmail);
            mapMember = new Map < string, boolean > ();

            if (boardingUsers.Board_Member__c != null && boardingUsers.Board_Member__c != '') {
                string[] strInput = boardingUsers.Board_Member__c.split(';');
                for (string strItem: strInput) {
                    mapMember.put(strItem.trim().toLowerCase(), true);
                    lstBoardNames.add(strItem.trim().toLowerCase());
                }
                MapBrdMemberUserDetails.put(strEmail, mapMember);
            }
        }
        system.debug('MapBrdMemberUserDetails ' + MapBrdMemberUserDetails);
        List < Learning_Board__c > lstBoardDetails = [SELECT Id, Name__c, Public__c, Is_Active__c FROM Learning_Board__c where Name__c in : lstBoardNames];
        //------------Add members to board---------

        Map < String, String > boardMap = new Map < String, String > ();
        for (Learning_Board__c cmm: lstBoardDetails) {
            system.debug('Name__c------------' + cmm.Name__c);
            boardMap.put(cmm.Name__c.trim().toLowerCase(), cmm.Id);
        }
        Map < string, string > mapNotExist = new Map < string, string > ();
        for (String cmName: lstBoardNames) {
            if (!boardMap.containsKey(cmName)) {
                mapNotExist.put(cmName.trim().toLowerCase(), cmName.trim().toLowerCase());
            }
        }
        List < SLP_Process_Onboarding_User__c > slpToUpdate = new List < SLP_Process_Onboarding_User__c > ();
        List < SLP_Process_Onboarding_User__c > slpBoardMember = [SELECT Community_Contributor__c, Failure_Log__c, SLP_BulkReg_Id__c, Community_Member__c, Board_Contributor__c, Board_Member__c FROM SLP_Process_Onboarding_User__c where SLP_BulkReg_Id__c = : SLPBulkRegId];
        for (SLP_Process_Onboarding_User__c slp: slpBoardMember) {
            if (slp.Board_Member__c != null && slp.Board_Member__c != '') {
                List < string > lstSplit = new List < string > ();
                if (slp.Board_Member__c.contains(';')) {
                    lstSplit = slp.Board_Member__c.split(';');
                } else {
                    lstSplit.add(slp.Board_Member__c);
                }
                if (lstSplit != null && lstSplit.size() > 0) {
                    for (string str: lstSplit) {
                        if (mapNotExist.containsKey(str.trim().toLowerCase())) {
                            if (slp.Failure_Log__c != null && slp.Failure_Log__c != '') {
                                slp.Failure_Log__c = slp.Failure_Log__c + ' \n ' + '-Boards Not Found [' + str + ']';
                            } else {
                                slp.Failure_Log__c = '-Boards Not Found [' + str + ']';
                                system.debug('slp.Failure_Log__c-----------else----' + slp.Failure_Log__c);
                            }
                        }

                    }
                    slpToUpdate.add(slp);
                }
            }
        }
        update slpToUpdate;

        //End
        system.debug('Board Names' + lstBoardNames);
        system.debug('Board Name Details' + lstBoardDetails);
        for (Learning_Board__c brdData: lstBoardDetails) {
            mapBoardKeyPair.put(brdData.Name__c.trim().toLowerCase(), brdData.Id);
        }
        system.debug('Board Name AV' + mapBoardKeyPair);
        list < string > lstBIds = new List < string > ();
        for (User user: lstUsers) {
            lstUserIds.add(user.Id);
            lstBoardIds = new List < string > ();
            if (MapBrdMemberUserDetails.ContainsKey(user.Email)) {
                Map < string, boolean > getBrdNamesByEmail = MapBrdMemberUserDetails.get(user.Email);
                system.debug('user.Email' + user.Email);
                system.debug('MapBrdMemberUserDetails.get(user.Email)' + MapBrdMemberUserDetails.get(user.Email));
                for (string Name: getBrdNamesByEmail.keyset()) {
                    system.debug('Name' + Name);
                    string BoardId = mapBoardKeyPair.get(Name.trim().toLowerCase());
                    system.debug('BoardId' + BoardId);
                    if (BoardId != null) {
                        lstBoardIds.add(BoardId);
                        lstBIds.add(BoardId);
                    }
                }
                mapUsersWithBrdIds.put(user.Id, lstBoardIds);
                system.debug('mapUsersWithBrdIds in Loop' + mapUsersWithBrdIds);
            }
        }
        system.debug('AV Board Member' + mapUsersWithBrdIds);
        Map < string, Map < string, Boolean >> mapBrdMemberUsers = new Map < string, Map < string, Boolean >> ();
        set < ID > MemberIds = new set < ID > ();

        List < Learning_Board_Member__c > lstBoardMembers = [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where Status__c = 'Approved'
            and
                                                          Learning_Board_ID__c in : lstBIds and User_Id__c in : lstUserIds];

        for (Learning_Board_Member__c boardItem: lstBoardMembers) {
            if (mapBrdMemberUsers.ContainsKey(boardItem.User_Id__c)) {
                Map < string, boolean > mapBoardMembers = mapBrdMemberUsers.get(boardItem.User_Id__c);
                mapBoardMembers.put(boardItem.Learning_Board_ID__c, true);

                mapBrdMemberUsers.put(boardItem.User_Id__c, mapBoardMembers);
            } else {
                Map < string, boolean > mapBoardMembers = new Map < string, boolean > ();
                mapBoardMembers.put(boardItem.Learning_Board_ID__c, true);

                mapBrdMemberUsers.put(boardItem.User_Id__c, mapBoardMembers);
            }
        }
        system.debug('mapBrdMemberUsers -----' + mapBrdMemberUsers);

        //Start:- To check whether user already contributor or owner for these communities
        List < Learning_Board__Share > lstBoardContributors = [SELECT Id, ParentId, UserOrGroupId, AccessLevel FROM Learning_Board__Share where ParentId in : lstBIds];
        Map < string, Map < string, Boolean >> mapContributorBoardIds = new Map < string, Map < string, Boolean >> ();
        for (Learning_Board__Share BoardItem: lstBoardContributors) {

            if (mapContributorBoardIds.ContainsKey(BoardItem.UserOrGroupId)) {
                Map < string, boolean > mapBoardOrCommunity = mapContributorBoardIds.get(BoardItem.UserOrGroupId);
                mapBoardOrCommunity.put(BoardItem.ParentId, true);

                mapContributorBoardIds.put(BoardItem.UserOrGroupId, mapBoardOrCommunity);
            } else {
                Map < string, boolean > mapBoardCommunity = new Map < string, boolean > ();
                mapBoardCommunity.put(BoardItem.ParentId, true);

                mapContributorBoardIds.put(BoardItem.UserOrGroupId, mapBoardCommunity);
            }
        }
        //End

        Map < string, boolean > mapBoardContr;
        for (User user: lstUsers) {
            if (mapUsersWithBrdIds.containsKey(user.Id)) {
                mapBoardContr = new Map < string, boolean > ();
                if (mapContributorBoardIds.containsKey(user.Id)) {
                    mapBoardContr = mapContributorBoardIds.get(user.Id);
                }
                List < string > getBoardByUserId = mapUsersWithBrdIds.get(user.Id);

                if (getBoardByUserId != null) {
                    if (getBoardByUserId.size() > 0) {
                        for (string boardId: getBoardByUserId) {
                            boolean addMember = true;
                            if (mapBoardContr != null) {
                                if (mapBoardContr.containsKey(boardId)) {
                                    addMember = false;
                                }
                            }
                            if (addMember) {
                                Learning_Board_Member__c boardMember = new Learning_Board_Member__c();

                                if (mapBrdMemberUsers.size() > 0) {
                                    if (!mapBrdMemberUsers.containsKey(user.Id)) {
                                        boardMember.User_Id__c = user.Id;
                                        boardMember.Status__c = 'APPROVED';
                                        boardMember.Learning_Board_ID__c = boardId;

                                        queuedUsersToBeMembers.add(boardMember);

                                    } else if (mapBrdMemberUsers.containsKey(user.Id)) {
                                        Map < string, boolean > mapIsMember = mapBrdMemberUsers.get(user.Id);

                                        if (!mapIsMember.containsKey(boardId)) {
                                            boardMember.User_Id__c = user.Id;
                                            boardMember.Status__c = 'APPROVED';
                                            boardMember.Learning_Board_ID__c = boardId;

                                            queuedUsersToBeMembers.add(boardMember);
                                        }
                                    }
                                } else if (mapBrdMemberUsers.size() == 0) {
                                    boardMember.User_Id__c = user.Id;
                                    boardMember.Status__c = 'APPROVED';
                                    boardMember.Learning_Board_ID__c = boardId;

                                    queuedUsersToBeMembers.add(boardMember);
                                }
                            }
                        }
                    }
                }
            }
        }

        if (queuedUsersToBeMembers.size() > 0) {
            insert queuedUsersToBeMembers;
        }
    }

    public void AddContributorsToBoards(List < string > listOfEmailIds, Map < string, SLP_Process_Onboarding_User__c > mapProcessOnBoardUsers) {
        List < string > lstBoardIds;
        List < string > lstUserIds = new List < string > ();
        List < string > lstBoardNames = new List < string > ();
        Map < string, boolean > mapContributor;
        Map < string, string > mapBoardKeyPair = new Map < string, string > ();
        List < Learning_Board__Share > queuedUsersToBeCtbtr = new List < Learning_Board__Share > ();
        Map < string, Map < string, boolean >> MapBrdCtrbtrUserDetails = new Map < string, Map < string, boolean >> ();
        Map < string, List < string >> mapUsersWithBrdIds = new Map < string, List < string >> ();

        List < User > lstUsers = [SELECT Id, Email FROM User where Email in : listOfEmailIds and IsActive = : true];

        for (string strEmail: listOfEmailIds) {
            SLP_Process_Onboarding_User__c boardingUsers = new SLP_Process_Onboarding_User__c();
            boardingUsers = mapProcessOnBoardUsers.get(strEmail);
            mapContributor = new Map < string, boolean > ();
            if (boardingUsers.Board_Contributor__c != null && boardingUsers.Board_Contributor__c != '') {
                string[] strInput = boardingUsers.Board_Contributor__c.split(';');
                for (string strItem: strInput) {
                    mapContributor.put(strItem.trim().toLowerCase(), true);
                    lstBoardNames.add(strItem);
                }
                MapBrdCtrbtrUserDetails.put(strEmail, mapContributor);
            }
        }

        List < Learning_Board__c > lstBoardDetails = [SELECT Id, Name__c, Public__c, Is_Active__c FROM Learning_Board__c where Name__c in : lstBoardNames];
        //----------Add Contributors to board------------------
        system.debug('lstBoardDetails----------'+lstBoardDetails);
        commMap.clear();
        for (Learning_Board__c cmm: lstBoardDetails) {
            commMap.put(cmm.Name__c, cmm.Id);
        }
        Map < String, String > newMapList = new Map < String, String > ();
        for (String cmName: lstBoardNames) {
            if (!commMap.containsKey(cmName)) {
                newMapList.put(cmName.trim().toLowerCase(), cmName.trim().toLowerCase());
            }
        }
        system.debug('newMapList---boardContri--------' + newMapList);
        List < SLP_Process_Onboarding_User__c > slpToUpdate = new List < SLP_Process_Onboarding_User__c > ();
        List < SLP_Process_Onboarding_User__c > slpBoardContributor = [SELECT Failure_Log__c, SLP_BulkReg_Id__c, Board_Contributor__c FROM SLP_Process_Onboarding_User__c where SLP_BulkReg_Id__c = : SLPBulkRegId];
        system.debug('slpBoardContributor---boardContri--------' + slpBoardContributor);
        for (SLP_Process_Onboarding_User__c slp: slpBoardContributor) {
            if (slp.Board_Contributor__c != null && slp.Board_Contributor__c != '') {
                List < string > lstSplit = new List < string > ();
                if (slp.Board_Contributor__c.contains(';')) {
                    lstSplit = slp.Board_Contributor__c.split(';');
                    system.debug('lstSplit--oar--if-----' + lstSplit);
                } else {
                    lstSplit.add(slp.Board_Contributor__c);
                    system.debug('lstSplit--oar--else-----' + lstSplit);
                }
                if (lstSplit != null && lstSplit.size() > 0) {
                    for (string str: lstSplit) {
                        system.debug('str-------------str-------' + str);
                        if (newMapList.containsKey(str.trim().toLowerCase())) {
                            if (slp.Failure_Log__c != null && slp.Failure_Log__c != '') {
                                slp.Failure_Log__c = slp.Failure_Log__c + ' \n ' + '-Boards Not Found [' + str + ']';
                                system.debug('slp.Failure_Log__c-----------if----' + slp.Failure_Log__c);
                            } else {
                                slp.Failure_Log__c = '-Boards Not Found [' + str + ']';
                                system.debug('slp.Failure_Log__c-----------else----' + slp.Failure_Log__c);
                            }
                        }

                    }
                    slpToUpdate.add(slp);
                }
            }
        }
        system.debug('slpToUpdate---boardContri--------' + slpToUpdate);
        update slpToUpdate;
        //End

        for (Learning_Board__c brdData: lstBoardDetails) {
            mapBoardKeyPair.put(brdData.Name__c.trim().toLowerCase(), brdData.Id);
        }
        list < string > lstBIds = new List < string > ();
        for (User user: lstUsers) {
            lstBoardIds = new List < string > ();

            lstUserIds.add(user.Id);

            if (MapBrdCtrbtrUserDetails.ContainsKey(user.Email)) {
                Map < string, boolean > getBrdNamesByEmail = MapBrdCtrbtrUserDetails.get(user.Email);

                system.debug('getBrdNamesByEmail' + getBrdNamesByEmail.size());

                for (string Name: getBrdNamesByEmail.keyset()) {
                    string BoardId = mapBoardKeyPair.get(Name.trim().toLowerCase());
                    if (BoardId != null) {
                        lstBoardIds.add(BoardId);
                        lstBIds.add(BoardId);
                    }
                }
                mapUsersWithBrdIds.put(user.Id, lstBoardIds);
            }
        }

        system.debug('lstBoardIds:' + lstBoardIds.size());

        Map < string, Map < string, Boolean >> mapBrdCtrbtrUsers = new Map < string, Map < string, Boolean >> ();
        set < ID > CtrbtrIds = new set < ID > ();

        List < Learning_Board__Share > entityMembers = [SELECT Id, ParentId, UserOrGroupId FROM Learning_Board__Share where ParentId in : lstBIds and UserOrGroupId in : lstUserIds];

        system.debug('entityMembers:' + entityMembers.size());

        for (Learning_Board__Share entityItem: entityMembers) {
            if (mapBrdCtrbtrUsers.ContainsKey(entityItem.UserOrGroupId)) {
                Map < string, boolean > mapEntityMembers = mapBrdCtrbtrUsers.get(entityItem.UserOrGroupId);
                mapEntityMembers.put(entityItem.ParentId, true);

                mapBrdCtrbtrUsers.put(entityItem.UserOrGroupId, mapEntityMembers);
            } else {
                Map < string, boolean > mapEntityMembers = new Map < string, boolean > ();
                mapEntityMembers.put(entityItem.ParentId, true);

                mapBrdCtrbtrUsers.put(entityItem.UserOrGroupId, mapEntityMembers);
            }
        }

        Map < string, boolean > mapEntitySubUserIds = new Map < string, boolean > ();
        //Check whether they are already member 
        List < Learning_Board_Member__c > lstBoardMembers = [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where Status__c = 'Approved'
            and
                                                          Learning_Board_ID__c in : lstBIds and User_Id__c in : lstUserIds];

        Map < string, Map < string, Learning_Board_Member__c >> mapBrdMemberUsers = new Map < string, Map < string, Learning_Board_Member__c >> ();
        for (Learning_Board_Member__c boardItem: lstBoardMembers) {
            if (mapBrdMemberUsers.ContainsKey(boardItem.User_Id__c)) {
                Map < string, Learning_Board_Member__c > mapBoardMembers = mapBrdMemberUsers.get(boardItem.User_Id__c);
                mapBoardMembers.put(boardItem.Learning_Board_ID__c, boardItem);

                mapBrdMemberUsers.put(boardItem.User_Id__c, mapBoardMembers);
            } else {
                Map < string, Learning_Board_Member__c > mapBoardMembers = new Map < string, Learning_Board_Member__c > ();
                mapBoardMembers.put(boardItem.Learning_Board_ID__c, boardItem);

                mapBrdMemberUsers.put(boardItem.User_Id__c, mapBoardMembers);
            }
        }
        Map < string, Learning_Board_Member__c > mapBoardCommunityMemb;
        List < Learning_Board_Member__c > lstDeleteBoardMembers = new List < Learning_Board_Member__c > ();




        for (User user: lstUsers) {
            System.debug('inside for user id:' + user.id);
            if (mapUsersWithBrdIds.containsKey(user.Id)) {
                List < string > getBoardByUserId = mapUsersWithBrdIds.get(user.Id);

                System.debug('mapUsersWithBrdIds:' + mapUsersWithBrdIds.size());
                System.debug('getBoardByUserId:' + getBoardByUserId.size());

                if (getBoardByUserId != null) {
                    if (getBoardByUserId.size() > 0) {
                        for (string boardId: getBoardByUserId) {
                            //delete Board member if already and making them as contributor
                            if (mapBrdMemberUsers != null && mapBrdMemberUsers.size() > 0) {
                                if (mapBrdMemberUsers.containsKey(user.Id)) {
                                    mapBoardCommunityMemb = new Map < string, Learning_Board_Member__c > ();
                                    mapBoardCommunityMemb = mapBrdMemberUsers.get(user.Id);
                                    if (mapBoardCommunityMemb.containsKey(boardId)) {
                                        lstDeleteBoardMembers.add(mapBoardCommunityMemb.get(boardId));

                                    }
                                }
                            }

                            Learning_Board__Share brdCtrbtr = new Learning_Board__Share();

                            if (mapBrdCtrbtrUsers.size() > 0) {
                                if (!mapBrdCtrbtrUsers.containsKey(user.Id)) {
                                    brdCtrbtr.UserOrGroupId = user.Id;
                                    brdCtrbtr.ParentId = boardId;
                                    brdCtrbtr.AccessLevel = 'Edit';
                                    queuedUsersToBeCtbtr.add(brdCtrbtr);

                                } else if (mapBrdCtrbtrUsers.containsKey(user.Id)) {
                                    Map < string, boolean > mapIsMember = mapBrdCtrbtrUsers.get(user.Id);

                                    if (!mapIsMember.containsKey(boardId)) {
                                        brdCtrbtr.UserOrGroupId = user.Id;
                                        brdCtrbtr.ParentId = boardId;
                                        brdCtrbtr.AccessLevel = 'Edit';
                                        queuedUsersToBeCtbtr.add(brdCtrbtr);
                                    }
                                }
                            } else if (mapBrdCtrbtrUsers.size() == 0) {
                                brdCtrbtr.UserOrGroupId = user.Id;
                                brdCtrbtr.ParentId = boardId;
                                brdCtrbtr.AccessLevel = 'Edit';
                                queuedUsersToBeCtbtr.add(brdCtrbtr);
                            }
                        }
                    }
                }
            }
        }

        if (queuedUsersToBeCtbtr.size() > 0) {
            insert queuedUsersToBeCtbtr;
        }
        if (lstDeleteBoardMembers.size() > 0) {
            delete lstDeleteBoardMembers;
        }
    }


    public void AddExpertiseToUsers(List < string > listOfEmailIds, Map < string, SLP_Process_Onboarding_User__c > mapProcessOnBoardUsers) {
        List < string > listUserIds = new List < string > ();
        List < string > lstAreaOfFocus;
        Map < string, boolean > mapAreaOfFocus;
        List < SLP_Secondary_Industry__c > lstQueuedtobeSecondaryNames = new List < SLP_Secondary_Industry__c > ();
        List < SLP_Secondary_Industry__c > lstSecondIndustryDetails = new List < SLP_Secondary_Industry__c > ();
        Map < string, List < string >> mapUsersWithSecIndustryIds = new Map < string, List < string >> ();
        Map < string, Map < string, boolean >> MapAreaOfFocusUserDetails = new Map < string, Map < string, boolean >> ();

        List < User > lstUsers = [SELECT Id, Email FROM User where Email in : listOfEmailIds and IsActive = : true];


        lstAreaOfFocus = new List < string > ();
        //START
        //Get all AreaOfFocus names from "SLP_Process_Onboarding_User__c" Object 
        //Prepare a list.
        //Associate each list to the respective Users
        //Create a map with keypair
        //MailId as the key & List of Area of Focus as a map.
        system.debug('listOfEmailIds:' + listOfEmailIds);
        for (string strEmail: listOfEmailIds) {
            mapAreaOfFocus = new Map < string, boolean > ();
            SLP_Process_Onboarding_User__c boardingUsers = new SLP_Process_Onboarding_User__c();
            boardingUsers = mapProcessOnBoardUsers.get(strEmail);
            system.debug('strEmail:' + strEmail);
            system.debug('boardingUsers:' + boardingUsers);

            //lstAreaOfFocus = new List<string>();
            if (boardingUsers.Area_Of_Focus__c != null) {
                string[] strInput = boardingUsers.Area_Of_Focus__c.split(';');
                system.debug('strInput:' + strInput);
                for (string strItem: strInput) {
                    system.debug('strItem:' + strItem);
                    if (strItem != '' && strItem != null) {
                        mapAreaOfFocus.put(strItem.trim().toLowerCase(), true);

                        lstAreaOfFocus.add(strItem.trim());

                    }
                }
                system.debug('mapAreaOfFocus:' + mapAreaOfFocus);
                MapAreaOfFocusUserDetails.put(strEmail, mapAreaOfFocus);
            }
        }
        System.debug('mapAreaOfFocus size:' + mapAreaOfFocus.size());
        System.debug('lstAreaOfFocus size:' + lstAreaOfFocus.size());
        system.debug('lstAreaOfFocus:' + lstAreaOfFocus);
        //END

        //START
        //Filter not matching items from SLP_Secondary_Industry__c object 
        //Make a new list of new Names as an SLP_Secondary_Industry__c object 
        //Insert to SLP_Secondary_Industry__c object 
        List < SLP_Secondary_Industry__c > lstSecondaryIndustry = [SELECT Id, Is_Active__c, Secondary_Industry_Name__c FROM SLP_Secondary_Industry__c where Is_Active__c = : true];
        Map < string, boolean > mapSecondIndustry = new Map < string, boolean > ();
        for (SLP_Secondary_Industry__c secItem: lstSecondaryIndustry) {
            mapSecondIndustry.put(secItem.Secondary_Industry_Name__c.trim().toLowerCase(), true);
        }
        map < string, boolean > aofExist = new map < string, boolean > ();
        for (string AOF: lstAreaOfFocus) {
            SLP_Secondary_Industry__c slpSecIndustry = new SLP_Secondary_Industry__c();

            if (!mapSecondIndustry.ContainsKey(AOF.trim().toLowerCase()) && !aofExist.containsKey(AOF.trim().toLowerCase())) {
                if (AOF != null && AOF != '') {
                    slpSecIndustry.Secondary_Industry_Name__c = AOF.trim();
                    slpSecIndustry.Is_Active__c = true;
                    aofExist.put(AOF.trim().toLowerCase(), true);
                    lstQueuedtobeSecondaryNames.add(slpSecIndustry);
                }
            }
        }
        //insert lstQueuedtobeSecondaryNames;
        Integer afc = 0;
        System.debug('lstQueuedtobeSecondaryNames:' + lstQueuedtobeSecondaryNames);
        Map<Integer,String> scInduSortMap = new Map<Integer,String>();
            if(afc<lstQueuedtobeSecondaryNames.size()){
                scInduSortMap.put(afc,lstQueuedtobeSecondaryNames[afc].Secondary_Industry_Name__c);
            }
        system.debug('scInduSortMap---------------d------------'+scInduSortMap);
        Map<String,String> errorAreaFocus = new Map<String,String>();
        Database.SaveResult[] lstSecondaryNames = Database.insert(lstQueuedtobeSecondaryNames, false);
            for(Integer i=0;i<lstSecondaryNames.size();i++){
                if (lstSecondaryNames[i].isSuccess()) {
                    System.debug('Successfully created ID:----------'+ lstSecondaryNames[i].getId());
                } else {
                    errorAreaFocus.put(scInduSortMap.get(i),lstSecondaryNames[i].getErrors()[0].getMessage());
                    System.debug('The error reported was:-----------'+ lstSecondaryNames[i].getErrors()[0].getMessage() + '\n');
                }
            }
        system.debug('errorAreaFocus-----------------'+errorAreaFocus);
        List < SLP_Process_Onboarding_User__c > slpToUpdate = new List < SLP_Process_Onboarding_User__c > ();
        List<SLP_Process_Onboarding_User__c> processSecIndus = [SELECT Community_Contributor__c, Community_Member__c, Board_Contributor__c, Board_Member__c, Failure_Log__c,Area_Of_Focus__c FROM SLP_Process_Onboarding_User__c where SLP_BulkReg_Id__c = : SLPBulkRegId];
        system.debug('processSecIndus---------------------'+processSecIndus);
        for(SLP_Process_Onboarding_User__c slp : processSecIndus){
            if(slp.Area_Of_Focus__c != null && slp.Area_Of_Focus__c != ''){
                List < string > lstSplit = new List < string > ();
                if (slp.Area_Of_Focus__c.contains(';')) {
                    lstSplit = slp.Area_Of_Focus__c.split(';');
                } else {
                    lstSplit.add(slp.Area_Of_Focus__c);
                }
                if (lstSplit != null && lstSplit.size() > 0) {
                    for (string str: lstSplit) {
                        system.debug('str--------areaof------------'+str);
                        if (errorAreaFocus.containsKey(str.trim())) {
                            system.debug('str.trim().toLowerCase()---------------'+str.trim().toLowerCase());
                            if (slp.Failure_Log__c != null && slp.Failure_Log__c != '') {
                                slp.Failure_Log__c = slp.Failure_Log__c + ' \n ' + '-AreaOfFocus Not Cretaed [' + errorAreaFocus.get(str.trim()) + ']';
                            } else {
                                slp.Failure_Log__c = '-AreaOfFocus Not Created [' + errorAreaFocus.get(str.trim()) + ']';
                            }
                        }

                    }
                    slpToUpdate.add(slp);
                }
            }
        }
        update slpToUpdate;
        //END

        //START
        //Get all the records matching the Filter Criteria
        //Create a Map with a key pair 
        //Key as SecondIndustryName & ID as Value
        lstSecondIndustryDetails = [SELECT Id, Is_Active__c, Secondary_Industry_Name__c FROM SLP_Secondary_Industry__c where Is_Active__c = : true and Secondary_Industry_Name__c in : lstAreaOfFocus];
        system.debug('lstAreaOfFocus:' + lstAreaOfFocus);
        system.debug('lstSecondIndustryDetails:' + lstSecondIndustryDetails);
        Map < string, string > MapIndustryDetailsKeyPair = new Map < string, string > ();

        for (SLP_Secondary_Industry__c secItem: lstSecondIndustryDetails) {
            MapIndustryDetailsKeyPair.put(secItem.Secondary_Industry_Name__c.trim().toLowerCase(), secItem.Id);
        }

        system.debug('MapIndustryDetailsKeyPair1:' + MapIndustryDetailsKeyPair);
        //END

        //START
        //Get all the SecondaryIndustry ID's for the associated User Ids
        //Create a map with a key pair
        //Key as UserID & Value as list of SecondaryIndustryIds
        List < string > lstSecInsdustryIds;
        for (User user: lstUsers) {
            listUserIds.add(user.id);

            if (MapAreaOfFocusUserDetails.ContainsKey(user.Email)) {
                lstSecInsdustryIds = new List < string > ();
                Map < string, boolean > getAOFNamesByEmail = MapAreaOfFocusUserDetails.get(user.Email);
                system.debug('getAOFNamesByEmail:' + getAOFNamesByEmail);
                for (string Name: getAOFNamesByEmail.keyset()) {
                    string SecIndustryId = MapIndustryDetailsKeyPair.get(Name.trim().toLowerCase());
                    if (SecIndustryId != null) {
                        lstSecInsdustryIds.add(SecIndustryId);
                    }
                    system.debug('lstSecInsdustryIds:' + lstSecInsdustryIds);
                }
                mapUsersWithSecIndustryIds.put(user.Id, lstSecInsdustryIds);
            }
        }
        system.debug('mapUsersWithSecIndustryIds:' + mapUsersWithSecIndustryIds);

        //END

        //START
        //Get all ESUser IDs for the associated User Ids
        //Create a map with a key pair
        //Key as UserID & ESUserID as Value
        List < ES_User__c > lstESUserObject = new List < ES_User__c > ();
        Map < string, string > mapESUserDetails = new Map < string, string > ();

        lstESUserObject = [SELECT Id, User_Id__c, SLP_Bussiness_User__c FROM ES_User__c where User_Id__c in : listUserIds];

        for (ES_User__c esUser: lstESUserObject) {
            mapESUserDetails.put(esUser.User_Id__c, esUser.Id);
        }
        //END

        //START
        //Get all the SecondaryName Ids for the associated ESUser Ids
        //Create a map with ESUserId as key & List of Secondary Ids as Value
        Map < string, List < string >> mapESUsersWithSecIndustryIds = new Map < string, List < string >> ();
        List < string > lstESUser = new List < string > ();

        for (string userID: listUserIds) {
            if (mapUsersWithSecIndustryIds.ContainsKey(userID) && mapESUserDetails.ContainsKey(userID)) {
                List < string > lstSecondaryNameIds = mapUsersWithSecIndustryIds.get(userID);
                string ESUserID = mapESUserDetails.get(userID);

                lstESUser.add(ESUserID);
                mapESUsersWithSecIndustryIds.put(ESUserID, lstSecondaryNameIds);
            }
        }
        system.debug('--- mapESUsersWithSecIndustryIds:' + mapESUsersWithSecIndustryIds);
        system.debug('lstESUser:' + lstESUser);
        //END

        //START
        //Assign all the ESUser Ids & SecondaryIds SLP_Expert__c Object
        //Prepare a list
        List < SLP_Expert__c > lstExpert = new List < SLP_Expert__c > ();
        List < SLP_Expert__c > ExistingExperts = [SELECT Id, ES_User_ID__c, SLP_Secondary_Industry_ID__c, Is_Expert__c FROM SLP_Expert__c];
        system.debug('ExistingExperts:' + ExistingExperts);
        Map < string, Map < string, string >> mapSLpExp = new Map < string, Map < string, string >> ();
        Map < string, string > mapSec;
        for (SLP_Expert__c Exist: ExistingExperts) {
            if (mapSLpExp.containsKey(Exist.ES_User_ID__c)) {
                system.debug('Exist.ES_User_ID__c:' + Exist.ES_User_ID__c);
                mapSec = mapSLpExp.get(Exist.ES_User_ID__c);
                system.debug('mapSec:' + mapSec);
                if (!mapSec.containsKey(Exist.SLP_Secondary_Industry_ID__c)) {
                    if (Exist.SLP_Secondary_Industry_ID__c != null) {
                        mapSec.put(Exist.SLP_Secondary_Industry_ID__c, Exist.SLP_Secondary_Industry_ID__c);
                        mapSLpExp.put(Exist.ES_User_ID__c, mapSec);
                    }
                }

            } else {
                system.debug('Exist.ES_User_ID__c else:' + Exist.ES_User_ID__c);
                mapSec = new Map < string, string > ();
                if (Exist.SLP_Secondary_Industry_ID__c != null) {
                    mapSec.put(Exist.SLP_Secondary_Industry_ID__c, Exist.SLP_Secondary_Industry_ID__c);
                    mapSLpExp.put(Exist.ES_User_ID__c, mapSec);
                }
            }
        }

        system.debug('mapSLpExp:' + mapSLpExp);


        system.debug('mapESUsersWithSecIndustryIds:' + mapESUsersWithSecIndustryIds);


        if (lstESUser != null) {
            if (lstESUser.size() > 0) {
                for (string esUserId: lstESUser) {
                    if (mapESUsersWithSecIndustryIds.ContainsKey(esUserId)) {
                        List < string > lstSecondaryIndIds = mapESUsersWithSecIndustryIds.get(esUserId);
                        system.debug('lstSecondaryIndIds:' + lstSecondaryIndIds);

                        if (lstSecondaryIndIds != null) {
                            if (lstSecondaryIndIds.size() > 0) {
                                map < string, string > mapArea = new map < string, string > ();
                                if (mapSLpExp.size() > 0) {
                                    mapArea = mapSLpExp.get(esUserId);
                                    system.debug('mapArea:' + mapArea);
                                }
                                for (string IndustryId: lstSecondaryIndIds) {

                                    system.debug('IndustryId:' + IndustryId);
                                    if (IndustryId != null) {
                                        if (mapArea != null) {
                                            if (!mapArea.containsKey(IndustryId)) {
                                                system.debug('IndustryId if:' + IndustryId);
                                                SLP_Expert__c expert = new SLP_Expert__c();
                                                expert.SLP_Secondary_Industry_ID__c = IndustryId;
                                                expert.ES_User_ID__c = esUserId;
                                                expert.Is_Expert__c = true;
                                                lstExpert.add(expert);
                                                system.debug('lstExpert:' + lstExpert);
                                            }
                                        } else {
                                            SLP_Expert__c expert = new SLP_Expert__c();
                                            expert.SLP_Secondary_Industry_ID__c = IndustryId;
                                            expert.ES_User_ID__c = esUserId;
                                            expert.Is_Expert__c = true;
                                            lstExpert.add(expert);
                                        }
                                    }



                                }
                            }
                        }
                    }
                }
            }
        } //END

        //Insert list of expertise for the respective users
        if (lstExpert.size() > 0) {
            insert lstExpert;
        }
    }

    @
    RemoteAction
    global static List < SLP_Process_Onboarding_User__c > GetCommunityMemberDetailsExcel(string SLPBulkRegisterId) {
        List < SLP_Process_Onboarding_User__c > lstOnBoardingUsrs = new List < SLP_Process_Onboarding_User__c > ();
        lstOnBoardingUsrs = [SELECT Email__c, Role__c, Area_Of_Focus__c, Community_Contributor__c, Community_Member__c, Board_Contributor__c, Board_Member__c, FormatValid__c, Failure_Log__c, New_User__c, Status__c FROM SLP_Process_Onboarding_User__c where SLP_BulkReg_Id__c = : SLPBulkRegisterId];
        return lstOnBoardingUsrs;

    }

}