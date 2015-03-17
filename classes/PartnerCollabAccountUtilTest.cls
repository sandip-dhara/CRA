/***********************************************************
* Class Name: PartnerCollabAccountUtilTest
* Author: Accenture
* Date: 26-JULY-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for PartnerCollabAccountUtil class.
***********************************************************/

@isTest
private class PartnerCollabAccountUtilTest {
    private static testMethod void PositiveTest() {
    
    Test.startTest();
    PartnerCollabAccountUtil accountUtil=new PartnerCollabAccountUtil();
    Test.stopTest();
    
    }

   /* static Account account1 = new Account();

    //setup your test data in this class
    private static void setupData() {
        
     }
     
    //Method for Positive test
    private static testMethod void PositiveTest() {
        Test.startTest();
        //setupData();
        
        account1 = TestingSetupDataUtil.createAccount('Test Partner Account', 'partner@partnercollab.com','Partner');
        insert account1;
        account1.IsPartner = true;
        update account1;
        
        Test.stopTest();
    }
    
    //Method for Negative test
    private static testMethod void NegativeTest() {
        Test.startTest();
        setupData();        
        
        
        Test.stopTest();
        
    }*/

}