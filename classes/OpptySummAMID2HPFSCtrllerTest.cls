@isTest
public class OpptySummAMID2HPFSCtrllerTest {

static testMethod void testAMIDReports() {
     Account acc = new Account(Name = 'Test Account');
     insert(acc);
     List<TibcoSecurity__c> lstTibcoSec = new List<TibcoSecurity__c>();
     TibcoSecurity__c tibcoSec = new TibcoSecurity__c(Name='tibadmin', TargetSystemName__c='SALESOPPTYREPORTS', TibcoPassword__c='tibadmin');
     lstTibcoSec.add(tibcoSec);
     insert lstTibcoSec;
     PageReference pageRef = new PageReference('/apex/OpportunityReportLinks?AMIDL2=CA201342458&AccountID='+acc.id);
     Test.setCurrentPageReference(pageRef);     
     OpptySummAMID2HPFSCtrller ctrller = new OpptySummAMID2HPFSCtrller(new ApexPages.StandardController(acc));
     //ctrller.getAMID2HPFSReport();
}

static testMethod void testExportOperation() {
     Account acc = new Account(Name = 'Test Account');
     insert(acc);
     PageReference pageRef = new PageReference('/apex/OpportunityReportLinks?AMIDL2=CA201342458&AccountID='+acc.id);
     
     OpptySummAMID2HPFSCtrller ctrller = new OpptySummAMID2HPFSCtrller(new ApexPages.StandardController(acc));
     //ctrller.exportReportToExcelHPFS();
     PageReference pageRef1 = Page.OppurtunitySummaryAMID2HPFSReportSheet;
     Test.setCurrentPageReference(pageRef1);
}

}