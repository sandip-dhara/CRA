@isTest
public class SalesManagerReportCtrllerTest{

static testMethod void testReportNames() 
    {
        
        Opportunity opp= new Opportunity();
        PageReference pageRef = new PageReference('/apex/SalesManagerReport');
        Test.setCurrentPageReference(pageRef);
        SalesManagerReportCtrller ctrller = new SalesManagerReportCtrller(new ApexPages.StandardController(opp));
        List<SelectOption> options = ctrller.getReportNames();
        System.AssertEquals(3, options.size());
    }

}