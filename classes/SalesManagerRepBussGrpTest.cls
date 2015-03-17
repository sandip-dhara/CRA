@isTest
public class SalesManagerRepBussGrpTest {
    static testMethod void testGetReports() 
    {
        
        Opportunity opp= new Opportunity();
        List<TibcoSecurity__c> lstTibcoSec = new List<TibcoSecurity__c>();
        TibcoSecurity__c tibcoSec = new TibcoSecurity__c(Name='tibadmin', TargetSystemName__c='SALESOPPTYREPORTS', TibcoPassword__c='tibadmin');
        lstTibcoSec.add(tibcoSec);
        insert lstTibcoSec;
        PageReference pageRef = new PageReference('/apex/SalesManagerReport');
        Test.setCurrentPageReference(pageRef);
        SalesManagerRepBussGrp ctrller = new SalesManagerRepBussGrp(new ApexPages.StandardController(opp));
        //ctrller.getSumByBusinessRepReport();
    }
    
    static testMethod void testExportOperation() {
     Opportunity opp= new Opportunity();
         PageReference pageRef = new PageReference('/apex/SalesManagerReport');
    Test.setCurrentPageReference(pageRef);
    SalesManagerRepBussGrp ctrller = new SalesManagerRepBussGrp (new ApexPages.StandardController(opp));
    //ctrller.exportReportToExcel3(); 
    PageReference pageRef1 = Page.SalesManagerReportssheet;
     Test.setCurrentPageReference(pageRef1);
}
}