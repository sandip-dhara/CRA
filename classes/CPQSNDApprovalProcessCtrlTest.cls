@isTest(SeeAllData=true)
private class CPQSNDApprovalProcessCtrlTest{
    //Test Method 
        public static testMethod void CPQSNDApprovalProcessTest() {
        Test.startTest();

        Approval__c objApproval = new Approval__c(status__c='Submitted');
        insert objApproval;
        
        ApexPages.StandardController CPQSNDCtrl = new ApexPages.StandardController(objApproval);
        CPQSNDApprovalProcessCtrl CPQSND = new CPQSNDApprovalProcessCtrl(CPQSNDCtrl);
        CPQSND.SaveRecord();
        CPQSND.CancelRecord();
        
        Test.stopTest();
    }
}