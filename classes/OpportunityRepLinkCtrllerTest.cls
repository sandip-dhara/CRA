@isTest
public class OpportunityRepLinkCtrllerTest{

static testMethod void testReportNames() 
    {
        
        
        Account acc = new Account(Name = 'Test Account');
        insert(acc);
        PageReference pageRef = new PageReference('/apex/OpportunityReportLinks?AMIDL2=CA201342458&AccountID='+acc.id);
        Test.setCurrentPageReference(pageRef);
        OpportunityRepLinkCtrller ctrller = new OpportunityRepLinkCtrller(new ApexPages.StandardController(acc));
        List<SelectOption> options = ctrller.getReportNames();
        System.AssertEquals(2, options.size());
    }

}