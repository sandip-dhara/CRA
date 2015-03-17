@isTest(SeeAllData=true)
private class CPQSapSelectionPageCtrlTest{
    //Test Method 
        public static testMethod void CPQSapSelectionPageTest() {
        Test.startTest();
        
        // Create Account
        Account objAccount = TestingSetupDataUtil.createAccount('TestAccount', 'shaijan.thomas@hp.com','Customer');
        Insert objAccount;
        
        // Create Opportunity
        Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty1',system.today()+30);
        insert objOpportunity;
        
        //Query to get the Opportunity_ID__c, auto number Field
        Opportunity objOpportunity1 = [select Opportunity_ID__c from Opportunity where id=:objOpportunity.Id];
             
        //for Create Quote
        PageReference pageRef = Page.CPQSAPSelectionPage;  
        pageRef.getParameters().put('pageMode','CreateQuote');
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController CPQSelectionPage = new ApexPages.StandardController(objOpportunity);
        CPQSapSelectionPageCtrl CPQSelection = new CPQSapSelectionPageCtrl( CPQSelectionPage);
        
        //for Edit Quote
        PageReference pageRef1 = Page.CPQSAPSelectionPage;  
        pageRef1.getParameters().put('pageMode','EditQuote');
        Test.setCurrentPage(pageRef1);
        ApexPages.StandardController CPQSelectionPage1 = new ApexPages.StandardController(objOpportunity);
        CPQSapSelectionPageCtrl CPQSelection1 = new CPQSapSelectionPageCtrl( CPQSelectionPage1);
        
        Test.stopTest();
    }
}