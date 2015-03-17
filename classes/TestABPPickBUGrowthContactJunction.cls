/**********************************************************
* Class Name: TestABPPickBUGrowthContactJunction
* Author: HP/Akash Garg
* Date:18/10/2012 
* Requirement:  
* Description: Test class for PickBUGrowthContactJunction
***********************************************************/
@isTest
public class TestABPPickBUGrowthContactJunction
{
    static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con1 = new Contact(AccountId = acc.id, LastName = 'abc', Email = 'test@test.com', Phone__c = '123456789');
        insert con1;
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
        
        PickBUGrowthContactJunction pbcp = new PickBUGrowthContactJunction(sc);
        //List<CustomerPriority> cbpList = new List<CustomerPriority>();
        pbcp.getBusinessPriorities();
        pbcp.processSelected();
        pbcp.search();
        pbcp.getIsPickCbpListEmpty();
        pbcp.cancel();
        pbcp.runSearch('abc');
    }
}