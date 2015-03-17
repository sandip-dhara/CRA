@isTest(SeeAllData=true)
private class CPQRetrieveObjectURLTest{
    //Test Method 
        public static testMethod void RetrieveObjectURLTest() {
        Test.startTest();
        Account objAccount = TestingSetupDataUtil.createAccount('TestAccount', 'shaijan.thomas@hp.com','Customer');
        insert objAccount;
        
        // Create Opportunity
        Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty1',system.today()+30);
        insert objOpportunity;
        
        RetrieveObjectURL ROUCtrl = new RetrieveObjectURL();
        ROUCtrl.RedirectURL();
        
        objOpportunity = [select id, Opportunity_ID__c from Opportunity where id=:objOpportunity.Id];
        RetrieveObjectURL ROUCtrl3 = new RetrieveObjectURL();
        ROUCtrl3.RedirectURL(); 
        
        PageReference prefSubmit = new PageReference('/apex/ObjectRoutingPage');
        prefSubmit.getParameters().put('object','Opportunity');
        prefSubmit.getParameters().put('Id',objOpportunity.Opportunity_ID__c);
        Test.setCurrentPage(prefSubmit);
        RetrieveObjectURL ROUCtrl1 = new RetrieveObjectURL();
        ROUCtrl1.RedirectURL();
        
        PageReference prefSubmit2 = new PageReference('/apex/ObjectRoutingPage');
        prefSubmit2.getParameters().put('object','Account');
        prefSubmit2.getParameters().put('Id',objAccount.Id);
        Test.setCurrentPage(prefSubmit2);
        
        RetrieveObjectURL ROUCtrl2 = new RetrieveObjectURL();
        ROUCtrl2.RedirectURL();
        Test.stopTest();
    }
}