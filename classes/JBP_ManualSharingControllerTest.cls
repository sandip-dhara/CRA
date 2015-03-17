@isTest(seeAllData = true)
private class JBP_ManualSharingControllerTest{
    
    static User currentUser = [select Id from user where Id =: UserInfo.getUserId()];
    Static Profile userProfile = [select id from profile where name='Sales Rep'];
    Static Profile portalUserProfile = [select id from profile where name='Gold Partner User'];
    Static Account ParentAccRec;  
    Static Account accRec;  
    Static Contact testContactRecOne;
    Static Contact testContactRecTwo;
    Static Contact testPartnerContactRecTwo ;
    Static Contact testPartnerContactRecOne ;
    Static User testingUser;
    Static User testingUserOne;
    Static User testingUserTwo;
    Static User testingPartnerUserTwo;
    Static JBP__c jbpNew;
    Static String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
    static void createTestData(){
    
         /* Create a test Account */
         
         ParentAccRec = new Account();
        ParentAccRec = TestingSetupDataUtil.createAccount('Testing Account','testing@test.com','Partner');
        ParentAccRec.MDCP_Business_Relationship__c='Business';
        insert ParentAccRec;
        ParentAccRec.IsPartner = True;
        update ParentAccRec;
        
        accRec = new Account();
        accRec = TestingSetupDataUtil.createAccount('Testing Account','testing@test.com','Partner');
        accRec.MDCP_Business_Relationship__c='Business';
        accRec.ParentId =ParentAccRec.Id;
        insert accRec;
        accRec.IsPartner = True;
        update accRec;
        
        
        
         /* Create a test Contacts */
    
        List<Contact> contactList = new List<Contact>();
        testContactRecOne = new Contact();
        testContactRecOne = TestingSetupDataUtil.createContact(accRec.id,'testingContactOne');
        contactList.add(testContactRecOne); 
        testContactRecTwo = new Contact();
        testContactRecTwo = TestingSetupDataUtil.createContact(accRec.id,'testingContactTwo');
        contactList.add(testContactRecTwo); 
        testPartnerContactRecOne = new Contact();
        testPartnerContactRecOne = TestingSetupDataUtil.createContact(accRec.id,'testingContactOne');
        contactList.add(testPartnerContactRecOne ); 
        testPartnerContactRecTwo = new Contact();
        testPartnerContactRecTwo = TestingSetupDataUtil.createContact(accRec.id,'testingContactTwo');
        contactList.add(testPartnerContactRecTwo);
        insert contactList;
        
        
        
        /* Creating a User Record */
        testingUser = new User();
        testingUser = TestingSetupDataUtil.createUser('U1_'+randomstr.substring(0,4),'UserTest@hp.com',randomstr+'UserTestOne@hp.com','UTF-8','TestUserOne','en_US','en_US','America/Los_Angeles','userTest@hp.com','55239900',userProfile.id);
        testingUser.Adoption_Role_Type__c = 'Field Sales Rep';
        testingUser.portal_Tab_Access__c = 'JBP';
        insert testingUser;
        
        /*creating a test portal user */
        List<User> usrList = new List<User>();
        testingUserOne = new User();
        testingUserTwo = new User();
        testingUserOne = TestingSetupDataUtil.createUser('U1_'+randomstr.substring(0,4),'portalUserTestOne@hp.com',randomstr+'portalUserTestOne@hp.com','UTF-8','PortalTestUserOne','en_US','en_US','America/Los_Angeles','userTestOne@hp.com','55239990',portalUserProfile .id);
        testingUserOne.contactid = contactList[0].id;
        testingUserOne.Adoption_Role_Type__c = 'Partner User';
        testingUserOne.portal_Tab_Access__c = 'JBP';
        testingUserOne.isActive=True;
        testingUserTwo = TestingSetupDataUtil.createUser('U2_'+randomstr.substring(0,4),'portalUserTestTwo@hp.com',randomstr+'portalUserTestTwo@hp.com','UTF-8','PortalTestUserTwo','en_US','en_US','America/Los_Angeles','userTestTwo@hp.com','55239991',portalUserProfile .id);
        testingUserTwo.contactid = contactList[1].id;
        testingUserTwo.Adoption_Role_Type__c = 'Partner User';
        testingUserTwo.portal_Tab_Access__c = 'JBP';
        testingUserTwo.isActive=True;
        usrList.add(testingUserTwo);
        testingPartnerUserTwo = TestingSetupDataUtil.createUser('U2_'+randomstr.substring(0,4),'portalUserTestthree@hp.com',randomstr+'portalUserTestthree@hp.com','UTF-8','portalUserTestthree','en_US','en_US','America/Los_Angeles','portalUserTestthree@hp.com','55239998',portalUserProfile .id);
        testingPartnerUserTwo .contactid = contactList[2].id;
        testingPartnerUserTwo .Adoption_Role_Type__c = 'Partner User';
        testingPartnerUserTwo .portal_Tab_Access__c = 'JBP';
        testingPartnerUserTwo .isActive=True;
        usrList.add(testingPartnerUserTwo );
        System.runAs(currentUser){
            insert usrList;
        }
        
        /* Create a JBP */
        jbpNew= new JBP__c();
        jbpNew.Name='JBPTestData';
        jbpNew.Partner_Account__c=accRec.id;
        jbpNew.BG__c='EG';
        jbpNew.ownerId = testingUser.id;
        jbpNew.Plan_End_Date__c=system.today()+20;
        jbpNew.PPT_Export_Language__c='English';
        jbpNew.PPT_Export_Currency__c='USD';
        insert jbpNew;
    }

    Static testMethod void testManualSharingOne(){
        createTestData();
        PageReference pageRef = Page.JBP_ManualSharing;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('parentId', jbpNew.id);
        ApexPages.currentPage().getParameters().put('planName', jbpNew.Name);
        
        JBP_ManualSharingController jbpController = new JBP_ManualSharingController();
        jbpController.searchUser = '';
        jbpController.selectedUser = 'PartnerUser';
        jbpController.getunSelectedValues();
        jbpController.searchUser = '';
        jbpController.selectedUser = 'User';
        jbpController.getunSelectedValues();
        jbpController.leftselected.add('PortalTestUserOne:Business'); 
        //jbpController.leftselected.add(jbpController.leftvalues.get(0));  
        jbpController.selectclick();
        jbpController.getSelectedValues();
    }
    Static testMethod void testManualSharingTwo(){
        createTestData();
        List<User> allUser =[Select Id, Name from User  where isActive=True and isPortalEnabled=false  Limit 100];
        List<User> allPortalUsersList=[Select Id, Name, Portal_Tab_Access__c,Partner_account_ID__c, ContactId from User  where Partner_account_ID__c!=null and isActive=True Limit 100]; 
        PageReference pageRef = Page.JBP_ManualSharing;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('parentId', jbpNew.id);
        ApexPages.currentPage().getParameters().put('planName', jbpNew.Name);
        
        JBP_ManualSharingController jbpController = new JBP_ManualSharingController();
        jbpController.searchUser = 'test';
        jbpController.selectedUser = 'PartnerUser';
        jbpController.findUser();
        jbpController.getunSelectedValues();
        jbpController.leftselected.add('PortalTestUserOne:Business');
        //jbpController.leftselected.add(testingUserTwo.Name+':Business');
        jbpController.leftselected.add(allPortalUsersList[0].Name+':Business');
        jbpController.selectclick();
        jbpController.getSelectedValues();
        jbpController.searchUser = 'Ray';
        jbpController.selectedUser = 'User';
        jbpController.findUser();
        jbpController.leftselected.add('User:'+allUser[0].Name);
        String DuplicateUsr= allUser[0].Name;
        User duplicateUser = new User();
        duplicateUser = TestingSetupDataUtil.createUser('U1_'+randomstr.substring(0,4),'duplicateUser@hp.com',randomstr+'duplicateUser@hp.com','UTF-8','duplicateUser','en_US','en_US','America/Los_Angeles','duplicateUser@hp.com','552399765',userProfile.id);
        duplicateUser.Adoption_Role_Type__c = 'Field Sales Rep';
        duplicateUser.portal_Tab_Access__c = 'JBP';
        insert duplicateUser;
        jbpController.selectclick();
        jbpController.rightselected.add('User:'+allUser[0].Name);
        jbpController.rightselected.add('User:'+duplicateUser.Name);
        jbpController.unselectclick();
        jbpController.getunSelectedValues();
        jbpController.leftselected.add('User:'+allUser[0].Name);
        jbpController.leftselected.add('User:'+duplicateUser.Name);
        jbpController.selectclick();
        jbpController.getSelectedValues();
        jbpController.shareandSendMail();
        jbpController.cancel();
        jbpController.enterSearch();
    }
}