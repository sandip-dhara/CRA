@isTest
public class OpptySummAMID2CtrllerTest {

static testMethod void testAMIDReports() {
     Account acc = new Account(Name = 'Test Account');
     insert(acc);
     List<TibcoSecurity__c> lstTibcoSec = new List<TibcoSecurity__c>();
     TibcoSecurity__c tibcoSec = new TibcoSecurity__c(Name='tibadmin', TargetSystemName__c='SALESOPPTYREPORTS', TibcoPassword__c='tibadmin');
     lstTibcoSec.add(tibcoSec);
     insert lstTibcoSec;
     PageReference pageRef = new PageReference('/apex/OpportunityReportLinks?AMIDL2=CA201342458&AccountID='+acc.id);
     Test.setCurrentPageReference(pageRef);     
     OpptySummAMID2Ctrller ctrller = new OpptySummAMID2Ctrller(new ApexPages.StandardController(acc));
}

static testMethod void testNextOperation() {
     Account acc = new Account(Name = 'Test Account');
     insert(acc);
     PageReference pageRef = new PageReference('/apex/OpportunityReportLinks?AMIDL2=CA201342458&AccountID='+acc.id);
     
     OpptySummAMID2Ctrller ctrller = new OpptySummAMID2Ctrller(new ApexPages.StandardController(acc));
     //ctrller.nextOperation();
}

static testMethod void testExportOperation() {
     Account acc = new Account(Name = 'Test Account');
     insert(acc);
     PageReference pageRef = new PageReference('/apex/OpportunityReportLinks?AMIDL2=CA201342458&AccountID='+acc.id);
     
     OpptySummAMID2Ctrller ctrller = new OpptySummAMID2Ctrller(new ApexPages.StandardController(acc));
     //ctrller.exportReportToExcel();
     PageReference pageRef1 = Page.OppurtunitySummaryAMID2ReportSheet;
     Test.setCurrentPageReference(pageRef1);
}

}