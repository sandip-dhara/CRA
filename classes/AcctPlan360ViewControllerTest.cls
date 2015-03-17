/**********************************************************
* Class Name: AcctPlan360ViewController
* Author: HP
* Date: 12-Jul-2012 
* Description: This class does the test coverage for AcctPlan360ViewController class. 
***********************************************************/
@isTest
private class AcctPlan360ViewControllerTest {

 
    static AcctPlan360ViewController abpController;
    static Account account;
    static Account_Plan__c accountPlan;
   static Opportunity newOpp;
    static Task task;
    static Case case2;
    static Event event;
 
   private static void setupData() {
        account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Customer');
        insert account ;
        System.assertEquals(account.Name,'testAccount1');
                accountPlan= ABPTestingUtil.createAbpPlan('testAccount1',account.id,'USD');
        insert accountPlan;
        System.assertEquals(accountPlan.Name,'testAccount1');
        
        
        
       String pAcct1ID = account.Id;
       
        Account account1 = TestingSetupDataUtil.createAccount('testAccount1 child 1', 'accountEmail@email.com','Customer');
        account1.ParentId = pAcct1ID;
        insert account1 ;
        System.assertEquals(account1.Name,'testAccount1 child 1');
        
        Account account2 = TestingSetupDataUtil.createAccount('testAccount1 child2', 'accountEmail@email.com','Customer');
        account2.ParentId = pAcct1ID;
        insert account2 ;
        System.assertEquals(account2.Name,'testAccount1 child2');
        
        Account account3 = TestingSetupDataUtil.createAccount('testAccount1 child 3', 'accountEmail@email.com','Customer');
        account3.ParentId = account2.id;
        insert account3 ;
        Account account4 = TestingSetupDataUtil.createAccount('testAccount1 child 4', 'accountEmail@email.com','Customer');
        account4.ParentId = account3.id;
        insert account4 ;
        Account account5 = TestingSetupDataUtil.createAccount('testAccount1 child 5', 'accountEmail@email.com','Customer');
        account5.ParentId = account4.id;
        insert account5 ;
       
        Account account1sc1 = TestingSetupDataUtil.createAccount('testAccount1 child2 subchild1', 'accountEmail@email.com','Customer');
        account1sc1.ParentId = account1.Id;
        insert account1sc1;
        System.assertEquals(account1sc1.Name,'testAccount1 child2 subchild1');
        
        /* Account */ 
        //newOpp= ABPTestingUtil.createOpportunity(account.id,'testAccount1',system.today()+ 30);
        //insert newOpp;
        //System.assertEquals(newOpp.Name,'testAccount1');
        /* Opportunity */
        
        case2= ABPTestingUtil.createcase('testOrigin','New','testReason','United States');
        insert case2;
        System.assertEquals(case2.Status,'New');
        
        //task = ABPTestingUtil.createTask();
        //insert task;
        //System.assertEquals(task.CurrencyIsoCode,'USD');
        
        //event = ABPTestingUtil.createEvent();
        //insert event;
        //System.assertEquals(event.CurrencyIsoCode,'USD');
}
 static testMethod void abp360viewTest() {
        /* Initializing test data */
        setupData();
        
        test.startTest();
        /* Testing Constructor */
        ApexPages.StandardController stdController = new ApexPages.StandardController(accountPlan);
        abpController= new AcctPlan360ViewController(stdController);
        abpController.getoptyList();
        abpController.getCaseList();
        abpController.getTaskList();
        abpController.getEventList();
        abpController.getContractList();
       test.stopTest();
    }
        
}