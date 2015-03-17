@isTest
private class UserTriggerControllerTest {
    
    static User internalUser;
    static User currentUser = [select Id from user where Id =: UserInfo.getUserId()];
    
    private static void setupData() {
        List<Profile> listProfile = new List<Profile>();
        /*Get Profile*/
        listProfile = [Select Name, Id From Profile limit 1];
        
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        
         
        /*Inserting User*/
        internalUser = TestingSetupDataUtil.createUser('DA_'+randomstr.substring(0,4),randomstr+'userTest@hp.com',randomstr+'userTest@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','userTest@hp.com','55235615',listProfile[0].Id);
        insert internalUser;  
        /*Insert lead */  
        Lead lead = new Lead();
        lead = TestingSetupDataUtil.createLead('test', 'Accenture', 'Open', 'Assigned', '111', 'test@acc.com');
        System.runAs(TestingSetupDataUtil.testUser) {
        insert lead;
        }
        //lead.OwnerId = TestingSetupDataUtil.testUser.Id;
                
        //update lead;
        Lead lead1 = new Lead();
        lead1 = TestingSetupDataUtil.createLead('test', 'Accenture', 'Open', 'Assigned', '111', 'test@acc.com');
 
        insert lead1; 
        User testUser = new User(ID=TestingSetupDataUtil.testUser.Id);
        testUser.ManagerId = UserInfo.getUserId();
        System.runAs (currentUser){
            update testUser;
        }
    }
    static testMethod void userTriggerControllerTest() {
        Test.startTest();
        setupData();
        internalUser = [Select Id, EmployeeNumber, Email, Email_Address__c, Legacy_Employee_Ref__c 
                        from User 
                        where username = 'userTest@hp.com'];
        /* Check if Legacy_Employee_Ref__c = EmployeeNumber */
        
       // System.assertEquals(internalUser.EmployeeNumber, internalUser.Legacy_Employee_Ref__c );
       System.assertEquals(internalUser.Legacy_Employee_Ref__c, '55235615' );
       //System.assertEquals(internalUser.EmployeeNumber, '.' );
        
        internalUser.Email = 'abc@hp.com';
        System.runAs (currentUser){
            update internalUser;
        }
        internalUser = [Select Id, Email_Address__c, Legacy_Employee_Ref__c, Email 
                        from User 
                        where username = 'userTest@hp.com'];
        /* Test if Email is abc@hp.com */                    
        System.assertEquals('abc@hp.com', internalUser.Email);
        Test.stopTest();
    }
    
    static testMethod void testPortalTabAccessOnInsertOfUser() {
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        
        Profile userProfile = [select id from profile where name='Gold Partner User'];
        
        /* Create a test Account */
        Account accRec = new Account();
        accRec = TestingSetupDataUtil.createAccount('Testing Account','testing@test.com','Partner');
        insert accRec;
        
        /* Create a test Contact */
        Contact testContactRec = new Contact();
        testContactRec = TestingSetupDataUtil.createContact(accRec.id,'testing Contact');
        insert testContactRec;  
        
        /*creating a test portal user */
        User testingUser = new User();
        testingUser = TestingSetupDataUtil.createUser('TE_'+randomstr.substring(0,4),randomstr+'portalUserTest@hp.com',randomstr+'portalUserTest@hp.com','UTF-8','PortalTestUser','en_US','en_US','America/Los_Angeles','userTest@hp.com','55239999',userProfile.id);
        testingUser.contactid = testContactRec.id;
        //testingUser.isPortalEnabled = true;
        testingUser.Adoption_Role_Type__c = 'Field Sales Rep';
        testingUser.portal_Tab_Access__c = 'Deal Reg;JBP;PCLM';
        
        Test.startTest();
        System.runAs (currentUser){
            insert testingUser;
            testingUser.portal_Tab_Access__c = 'JBP;PCLM';
            update testingUser;
            testingUser.portal_Tab_Access__c = 'Deal Reg;PCLM';
            update testingUser;
            testingUser.portal_Tab_Access__c = 'Deal Reg;JBP';
            update testingUser;
            testingUser.portal_Tab_Access__c = 'Deal Reg;JBP;PCLM';
            update testingUser;
            testingUser.portal_Tab_Access__c = '';
            update testingUser;
            testingUser.portal_Tab_Access__c = 'Deal Reg;JBP;PCLM';
            update testingUser;
        }
        Test.stopTest();
    }
}