/***********************************************************
* Class Name: AccountTriggerControllerTest
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage
*              for AccountTriggerControllerTest class.
***********************************************************/
@isTest
private class AccountTriggerControllerTest {
    static Account account;
    static String errorMessage;
    static User testUser;
    /**
    * @description: Data setup to test methods 
    */
    private static void setupData() {
        /* Create New Test Account */
        account = TestingSetupDataUtil.createAccount('TestST Account', 'testST@test.com','Customer');
        insert account;
        
         /* User */
        testUser = TestingSetupDataUtil.createUser('accTest','abc@hp.com','5PM_abc@hp.com',
        'UTF-8','Tertlan','en_US','en_US',
        'America/Los_Angeles','acc@hp.com','552356199999',Userinfo.getProfileId());
        insert testUser;
    }
    /**
    * @description: to test validation from account trigger
    */
    static testMethod void testAccountTriggerController() {
        test.startTest();
        setupData();
        account.Name = 'TestST Account1';
        //RAD__c field update for TerritoryManagement - AccountTriggerSequenceController test.
        account.RAD__c = 'Test_R1@786';
        /* Trying to update account to test the trigger validation */
        try {
            update account;
        } catch(Exception ex) {
            errorMessage = ex.getMessage();
        }
        /* If errorMessage is not null, then test method will PASS */
        System.assertNotEquals('', errorMessage);
        
        /* RunAs testUser*/
        System.runAs(testUser) {
            account.Name = 'TestST Account2';
            /* Trying to update account to test the trigger validation */
            try {
                update account;
            } catch(Exception ex) {
                errorMessage = ex.getMessage();
            }
            /* If errorMessage is not null, then test method will PASS */
            System.assertNotEquals('', errorMessage);
        }
        test.stopTest();
    }
}