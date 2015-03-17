@isTest
public class SalesManagerRepPosTest {
    static testMethod void testGetReports() 
    {
        
        Opportunity opp= new Opportunity();
        List<TibcoSecurity__c> lstTibcoSec = new List<TibcoSecurity__c>();
        TibcoSecurity__c tibcoSec = new TibcoSecurity__c(Name='tibadmin', TargetSystemName__c='SALESOPPTYREPORTS', TibcoPassword__c='tibadmin');
        lstTibcoSec.add(tibcoSec);
        insert lstTibcoSec;
        PageReference pageRef = new PageReference('/apex/SalesManagerReport');
        Test.setCurrentPageReference(pageRef);
        SalesManagerRepPos ctrller = new SalesManagerRepPos(new ApexPages.StandardController(opp));
    }
    
    static testMethod void testExportOperation() {
     Opportunity opp= new Opportunity();
         PageReference pageRef = new PageReference('/apex/SalesManagerReport');
    Test.setCurrentPageReference(pageRef);
    SalesManagerRepPos ctrller = new SalesManagerRepPos(new ApexPages.StandardController(opp));
    //ctrller.exportReportToExcel(); 
    PageReference pageRef1 = Page.SalesManagerReportssheet;
     Test.setCurrentPageReference(pageRef1);
}
}