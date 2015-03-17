/**********************************************************
* Class Name: AddCompetitorLookupControllerTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage for AddCompetitorLookupController class. 
***********************************************************/
@isTest
private class AddCompetitorLookupControllerTest {

     static testMethod void testAddCompetitorLookupController() {
        //Create Account for opty     
        Account account = TestingSetupDataUtil.createAccount('Test Account', 'tezt1@test.com','Customer');
        account.ShippingCountry='United States';
        //Create competitor1 Account
        Account compAcc1 = TestingSetupDataUtil.createAccount('competitor Account1', 'tezt1@test.com','Competitor');
        Account compAcc2 = TestingSetupDataUtil.createAccount('competitor Account2', 'tezt1@test.com','Competitor');
        compAcc1.Regions__c='Americas';
        compAcc1.Valid_Business_Group__c='IPG';
        compAcc2.Regions__c='Americas';
        compAcc2.Valid_Business_Group__c='IPG';
        //creating list of accounts
        List<Account> listAccount = new List<Account>();      
        listAccount.add(account);
        listAccount.add(compAcc1);
        listAccount.add(compAcc2);
        insert listAccount;
        
        //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account.Id, 'Default Opty',System.today().addMonths(1));
        insert opty;
        ApexPages.currentPage().getParameters().put('lksrch', 'test');
         ApexPages.currentPage().getParameters().put('opptyid', opty.id);
        System.runAs(TestingSetupDataUtil.testUser) {
            test.startTest();
            AddCompetitorLookupController addCompLkpController = new AddCompetitorLookupController();
            addCompLkpController.searchText='competitor Account1';
            addCompLkpController.BGsearchText='IPG';
            addCompLkpController.getFormTag();
            addCompLkpController.getIsResultEmpty();
            addCompLkpController.getTextBox();
            addCompLkpController.initialize();
            addCompLkpController.getBGPicklist();
          // addCompLkpController.getsortExpression();
             //String value=addCompLkpController.getsortExpression();
             
            addCompLkpController.sortDirection='DESC';
            addCompLkpController.sortExp='name';
            addCompLkpController.getsortDirection();
           
            // addCompLkpController.setsortDirection(sortDirection);
             
            system.assert(addCompLkpController.searchText != null, true);
            test.stopTest();
            
        }        
    }
}