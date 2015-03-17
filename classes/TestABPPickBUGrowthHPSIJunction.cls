/**********************************************************
* Class Name: TestABPPickBUGrowthHPSIJunction
* Author: HP/Akash Garg
* Date:18/10/2012 
* Requirement:  
* Description: Test class for PickBUGrowthHPSIJunction
***********************************************************/
@isTest(SeeAllData=true)
public class TestABPPickBUGrowthHPSIJunction
{
    static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account4');
        insert acc;
        //string s= acc.id;
        
        Opportunity op = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today()+ 30);
        insert op;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
        Strategic_Initiative__c si = new Strategic_Initiative__c(Account_Plan__c = acp.id);
        insert si;
        Business_Unit_Plan__c bup = new Business_Unit_Plan__c(Name = 'abc', Account_Plan__c = acp.id);
        insert bup;
        BU_Growth_Strategy__c bugs = new BU_Growth_Strategy__c(BU_Plan__c = bup.id);
        //insert bugs;
        
        List<BU_Growth_Strategy__c> buglist = new List<BU_Growth_Strategy__c>();
        buglist.add(bugs);
        insert buglist; 
        
        ApexPages.currentPage().getParameters().put('id', bugs.id);
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(buglist);
        
        PickBUGrowthHPSIJunction pbcp = new PickBUGrowthHPSIJunction(sc);
        //List<CustomerPriority> cbpList = new List<CustomerPriority>();
        //pbcp.getBusinessPriorities();
        pbcp.processSelected();
        pbcp.search();
        pbcp.getIsPickCbpListEmpty();
        pbcp.cancel();
        pbcp.runSearch('abc');
    }
}