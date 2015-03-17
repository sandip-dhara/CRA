@isTest
private class RelatedOpportunityControllerTest {
    static PageReference pageRef;
    static Opportunity newOpp1;
    static Opportunity newOpp2;
    
    
    private static void setupData() {
        List<Account> listAccount = new List<Account>();
        
        //Create Accounts
        account acc1 = TestingSetupDataUtil.createAccount('testAccount1', 'accountE@emaill.com','Customer');
        listAccount.add(acc1);
        account acc2 = TestingSetupDataUtil.createAccount('testAccount2', 'accountE@eaill.com','Customer');
        listAccount.add(acc2);
        insert listAccount;
        
        //Create Opportunities
        List<Opportunity> listOpportunity = new List<Opportunity>();
        newOpp1 = TestingSetupDataUtil.createOpportunity(acc1.Id,'testOppty', system.today()+ 30);
        listOpportunity.add(newOpp1);
        newOpp2 = TestingSetupDataUtil.createOpportunity(acc2.Id,'testOppty', system.today()+ 30);
        listOpportunity.add(newOpp2);
        insert listOpportunity;
    }
    
    private static testMethod void relatedOpportunityControllerPositiveTest() {
        setupData();
        test.startTest();
        pageRef = Page.AddRelatedOpportunities;
        ApexPages.currentPage().getParameters().put('oppName',newOpp1.Name);
        Test.setCurrentPageReference(pageRef);
        
        /*Testing Constructor*/
        ApexPages.StandardController stdController = new ApexPages.StandardController(newOpp1);
        RelatedOpportunityController relatedOpportunityControllerObj = new RelatedOpportunityController(stdController);
        relatedOpportunityControllerObj.RelatedOpportunityList[0].RelatedOpportunity.Related_Opportunity__c = newOpp2.Id;
        
        /*Testing checkOptyEditAccess Method*/
        ApexPages.currentPage().getParameters().put('id',newOpp2.Id);
        relatedOpportunityControllerObj.checkOptyEditAccess();
        System.assertEquals(relatedOpportunityControllerObj.hasEditAccess, true);
        
        /*Testing Save & Cancel Method*/
        relatedOpportunityControllerObj.retUrl = '/'+ newOpp1.Id ;
        pageReference testPage = new pageReference('/'+ newOpp1.Id);
        pageReference savePage = relatedOpportunityControllerObj.save();
        pageReference cancelPage = relatedOpportunityControllerObj.Cancel();
        System.assertEquals(savePage.getURL(), testPage.getURL());
        System.assertEquals(cancelPage.getURL(), testPage.getURL());
        test.stopTest();
    }
    
    private static testMethod void relatedOpportunityControllerNegativeTest() {
        setupData();
        
        pageRef = Page.AddRelatedOpportunities;
        ApexPages.currentPage().getParameters().put('oppName',newOpp1.Name);
        Test.setCurrentPageReference(pageRef);
        
        /*Testing Constructor*/
        ApexPages.StandardController stdController = new ApexPages.StandardController(newOpp1);
        RelatedOpportunityController relatedOpportunityControllerObj = new RelatedOpportunityController(stdController);
        relatedOpportunityControllerObj.RelatedOpportunityList[0].RelatedOpportunity.Related_Opportunity__c = newOpp1.Id;
        
        /*Testing Save & Cancel Method*/
        relatedOpportunityControllerObj.retUrl = '/'+ newOpp1.Id ;
        pageReference testPage = new pageReference('/'+ newOpp1.Id);
        pageReference savePage = relatedOpportunityControllerObj.save();
        pageReference cancelPage = relatedOpportunityControllerObj.Cancel();
        
        /*Verify that Error Page Displays*/
        System.assertEquals(null, savePage);
        
    }
}