/***********************************************************
* Class Name: NewOpportunityOverrideControllerTest 
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* * Description: This class does the test coverage
*              for NewOpportunityOverrideController class.
***********************************************************/
@isTest
private class NewOpportunityOverrideControllerTest {
    
    static PageReference pageRef;
    static Opportunity newOpp;
    
    private static void setupData() {
        
        String RecordTypeId ='';
        try {
            RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        } catch(Exception e) {
            System.debug('>>> Exception: '+e.getMessage());
        }
        
        //Create Account
        Account acc =TestingSetupDataUtil.createAccount('testAccount','test_22@test.com','Customer'); 
       
        insert acc;
        //Create Opportunity
        newOpp=TestingSetupDataUtil.createOpportunity(acc.Id, 'testOppty', system.today()+ 30); 
      
        insert newOpp;          
    
    }
/*This method is used to test coverage for NewOpportunityOverrideController class*/

    private static testMethod void newOpportunityOverrideControllerTest() {
        
        setupData();
        pageRef = Page.NewOpportunityOverride;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('sfdc.override','1');
        ApexPages.currentPage().getParameters().put('save_new','1');
        ApexPages.StandardController stdController = new ApexPages.StandardController(newOpp);
        NewOpportunityOverrideController newOpportunityOverrideControllerObj = new NewOpportunityOverrideController(stdController);
        pageReference redirectPage = newOpportunityOverrideControllerObj.redirect();
        /*Check if correct URL is set on redirect()*/
        system.assertEquals(redirectPage.getUrl().contains('Understand+Customer'),true);
         
    }
}