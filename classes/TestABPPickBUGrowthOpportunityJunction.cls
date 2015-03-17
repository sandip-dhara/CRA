/**********************************************************
* Class Name: TestABPPickBUGrowthOpportunityJunction
* Author: HP/Akash Garg
* Date:18/10/2012 
* Requirement:  
* Description: Test class for PickBUGrowthOpportunityJunction        
***********************************************************/
@isTest(SeeAllData=true)
public class TestABPPickBUGrowthOpportunityJunction
{
    static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Account account1 = TestingSetupDataUtil.createAccount('testAccount1 child 1', 'accountEmail@email.com','Customer');
        account1.ParentId = acc.id;
        insert account1 ;
        Account account2 = TestingSetupDataUtil.createAccount('testAccount1 child 2', 'accountEmail@email.com','Customer');
        account2.ParentId = account1.id;
        insert account2 ;
        Account account3 = TestingSetupDataUtil.createAccount('testAccount1 child 3', 'accountEmail@email.com','Customer');
        account3.ParentId = account2.id;
        insert account3 ;
        Account account4 = TestingSetupDataUtil.createAccount('testAccount1 child 4', 'accountEmail@email.com','Customer');
        account4.ParentId = account3.id;
        insert account4 ;
        Account account5 = TestingSetupDataUtil.createAccount('testAccount1 child 5', 'accountEmail@email.com','Customer');
        account5.ParentId = account4.id;
        insert account5 ;
        Contact con1 = new Contact(AccountId = acc.id, LastName = 'abc', Email = 'test@test.com', Phone__c = '123456789');
        insert con1;
        Opportunity op = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today()+ 30);
        insert op;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;

        Business_Unit_Plan__c bup = new Business_Unit_Plan__c(Name = 'abc', Account_Plan__c = acp.id);
        insert bup;
        BU_Growth_Strategy__c bugs = new BU_Growth_Strategy__c(BU_Plan__c = bup.id);
        //insert bugs;
        
        List<BU_Growth_Strategy__c> buglist = new List<BU_Growth_Strategy__c>();
        buglist.add(bugs);
        insert buglist; 
        
        ApexPages.currentPage().getParameters().put('id', bugs.id);
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(buglist);
        
        PickBUGrowthOpportunityJunction pbcp = new PickBUGrowthOpportunityJunction(sc);
        //List<CustomerPriority> cbpList = new List<CustomerPriority>();
        //pbcp.getBusinessPriorities();
        pbcp.processSelected();
        pbcp.search();
        pbcp.getIsPickOptyListEmpty();
        pbcp.cancel();
        pbcp.runSearch('abc');
    }
}