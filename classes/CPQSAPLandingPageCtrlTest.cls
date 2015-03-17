@isTest(SeeAllData=true)
private class CPQSAPLandingPageCtrlTest{
    //Test Method 
        public static testMethod void CPQSAPLandingPageTest() {
        Test.startTest();
        
        list<account> Accountlist = new list<Account>();
        // Create Account
        Account objAccount = TestingSetupDataUtil.createAccount('TestAccount', 'shaijan.thomas@hp.com','Customer');
        Accountlist.add(objAccount);
        
        // Create Competitor
        Account objAccount1 = TestingSetupDataUtil.createAccount('TestAccount', 'shaijan.thomas@hp.com','Competitor');
        Accountlist.add(objAccount1);
        
        insert  Accountlist;
        
        // Create Opportunity
        Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty1',system.today()+30);
        insert objOpportunity;
        
        //Query to get the Opportunity_ID__c, auto number Field
        Opportunity objOpportunity1 = [select Opportunity_ID__c from Opportunity where id=:objOpportunity.Id];
        
        // Create Opportunity
        Competitors__c objCompetitors = new Competitors__c(Opportunity__c=objOpportunity.Id,Competitor_Account__c=objAccount1.Id);
        insert objCompetitors;
        
        
        PageReference pageRef1 = Page.CPQSAPLandingPage;  
       
        //Optional        
        pageRef1.getParameters().put('OpportunityID','null');
        pageRef1.getParameters().put('RequestType','ZQ');
        Test.setCurrentPage(pageRef1);
        CPQSAPLandingPageCtrl LandingCtrl2 = new CPQSAPLandingPageCtrl();
        LandingCtrl2.OnLoadCreateCaseorApproval();
        
        pageRef1.getParameters().put('OrderVal','12345');
        pageRef1.getParameters().put('RequestType','ZQRN');
        pageRef1.getParameters().put('CAemail','nagaraju.yelluri@hp.com');
        pageRef1.getParameters().put('OpportunityID',objOpportunity1.Opportunity_ID__c);
        Test.setCurrentPage(pageRef1);
        CPQSAPLandingPageCtrl LandingCtrl1 = new CPQSAPLandingPageCtrl();
        LandingCtrl1.OnLoadCreateCaseorApproval();
        
       //Optional
        PageReference pageRef = Page.CPQSAPLandingPage; 
        pageRef.getParameters().put('QuoteStartDate','2030-05-30');
        pageRef.getParameters().put('QuoteEndDate','2031-05-30');
        pageRef.getParameters().put('ContractGrossValue','45.05-');
        pageRef.getParameters().put('RequestType','ZQRN');
        pageRef.getParameters().put('OrderVal','56.08');
        pageRef.getParameters().put('ContractNetValue','56.08');
        pageRef.getParameters().put('CAemail','nagaraju.yelluri@hp.com');
        pageRef.getParameters().put('OpportunityID',objOpportunity1.Opportunity_ID__c);
        pageRef.getParameters().put('SpecialPricing','Y');
        Test.setCurrentPage(pageRef);
        CPQSAPLandingPageCtrl LandingCtrl = new CPQSAPLandingPageCtrl();
        LandingCtrl.OnLoadCreateCaseorApproval();
                
        LandingCtrl.OnLoadCreateCaseorApproval();
        LandingCtrl.insertCase();
        LandingCtrl.oCase.Reason ='Other';
        LandingCtrl.insertCase();
        LandingCtrl.insertAndCloseCase();
        LandingCtrl.OnLoadCreateCaseorApproval();
        
        pageRef.getParameters().put('CaseId','003456234');
        Test.setCurrentPage(pageRef);
        LandingCtrl.OnLoadCreateCaseorApproval();       
        Test.stopTest();
    }
}