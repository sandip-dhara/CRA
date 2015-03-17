@isTest
private class JBP_PortalUserNotificationTest{
    
    static User currentUser = [select Id from user where Id =: UserInfo.getUserId()];
    Static testMethod void testPortalUserNotification(){
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        Profile userProfile = [select id from profile where name='Gold Partner User'];
        EmailTemplate eTemp = [Select Id, DeveloperName FROM EmailTemplate where DeveloperName ='JBP_Partner_Plan_Share_Notification'];
        
        /* Create a test Account */
        Account accRec = new Account();
        accRec = TestingSetupDataUtil.createAccount('Testing Account','testing@test.com','Partner');
        insert accRec;
        
        /* Create a test Contacts */
        List<Contact> contactList = new List<Contact>();
        Contact testContactRecOne = new Contact();
        testContactRecOne = TestingSetupDataUtil.createContact(accRec.id,'testingContactOne');
        contactList.add(testContactRecOne); 
        Contact testContactRecTwo = new Contact();
        testContactRecTwo = TestingSetupDataUtil.createContact(accRec.id,'testingContactTwo');
        contactList.add(testContactRecTwo); 
        insert contactList;
        
        Test.startTest();
        /*creating a test portal user */
        List<User> usrList = new List<User>();
        User testingUserOne = new User();
        User testingUserTwo = new User();
        testingUserOne = TestingSetupDataUtil.createUser('U1_'+randomstr.substring(0,4),randomstr+'portalUserTestOne@hp.com',randomstr+'portalUserTestOne@hp.com','UTF-8','PortalTestUserOne','en_US','en_US','America/Los_Angeles','userTestOne@hp.com','55239990',userProfile.id);
        testingUserOne.contactid = contactList[0].id;
        testingUserOne.Adoption_Role_Type__c = 'Field Sales Rep';
        testingUserOne.portal_Tab_Access__c = 'JBP';
        testingUserTwo = TestingSetupDataUtil.createUser('U2_'+randomstr.substring(0,4),randomstr+'portalUserTestTwo@hp.com',randomstr+'portalUserTestTwo@hp.com','UTF-8','PortalTestUserTwo','en_US','en_US','America/Los_Angeles','userTestTwo@hp.com','55239991',userProfile.id);
        testingUserTwo.contactid = contactList[1].id;
        testingUserTwo.Adoption_Role_Type__c = 'Field Sales Rep';
        testingUserTwo.portal_Tab_Access__c = 'JBP';
        usrList.add(testingUserOne);
        usrList.add(testingUserTwo);
        System.runAs(currentUser){
            insert usrList;
        }
        
        /*Create a JBP */
        JBP__c jbp = new JBP__c();
        jbp.Name = 'Test_JBP_PortalUserNotification';
        jbp.BG__c = 'PPS';
        jbp.Partner_Account__c = accRec.id;
        jbp.Plan_End_Date__c = date.valueof('2014-08-14');
        jbp.Partner_Approver__c = contactList[0].id;
        jbp.Partner_Approver_2__c = contactList[1].id;
        insert jbp;
        System.runAs(currentUser){
            JBP_PortalUserNotification.SendEmail(jbp,eTemp.id);
        }
        Test.stopTest();
    }
}