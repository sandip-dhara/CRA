/**********************************************************
* Class Name: AddSalesLinkageControllerTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage
*              for AddSalesLinkageController class. 
***********************************************************/
@isTest
private class AddSalesLinkageControllerTest {
    static Account account;
    static Opportunity opty;
    
    static void setupData() {
        //Create Account for opty
        account = new Account();
        account = TestingSetupDataUtil.createAccount('Test Account', 'tezt@test.com', 'Customer');
        insert account;
        System.assertEquals(account.Id != null,true);
        
        //Create Opty
        opty = new Opportunity();
        opty = TestingSetupDataUtil.createOpportunity( account.Id, 'Default Opty', System.today().addMonths(1));
        insert opty;
        System.assertEquals(opty.Name == 'Default Opty',true);
    }
    
    static testMethod void testAddSalesLinkageController() {
        Test.startTest();
        setupData();
        Sales_Process_Linkage__c salesProcLink1 = new Sales_Process_Linkage__c();
        //salesProcLink1.Opportunity__c = opty.Id;
        salesProcLink1.ID_Type__c = 'Eclipse';
        salesProcLink1.ID__c = '909123xyz';
        
        System.runAs(TestingSetupDataUtil.testUser) {
            PageReference pageRef = Page.AddCompetitors;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('CF00NK0000000VUau_lkid', opty.Id);
            ApexPages.currentPage().getParameters().put('retURL', '/' + opty.Id);
            
            
            system.assert(salesProcLink1.ID_Type__c != null, true);
            ApexPages.StandardController stdController = new ApexPages.StandardController(salesProcLink1);
            AddSalesLinkageController addSalesLinkController = new AddSalesLinkageController(stdController);
            addSalesLinkController.oppID = opty.Id;
            
            //ApexPages.currentPage().getParameters().put('oppId', '/' + opty.Id);
            if(addSalesLinkController.externalIDsList != null &&
                addSalesLinkController.externalIDsList.size() > 0) {
                
                addSalesLinkController.externalIDsList[0].externalID.ID__c = '919123xyz';
                addSalesLinkController.save();
                addSalesLinkController.externalIDsList[0].externalID.ID_Type__c = 'Eclipse';
                addSalesLinkController.externalIDsList[0].externalID.ID__c = '919123xyz';
                addSalesLinkController.save();
                addSalesLinkController.externalIDsList[0].externalID.ID_Type__c = 'Eclipse';
                addSalesLinkController.externalIDsList[0].externalID.ID__c = '919123xyz';
                addSalesLinkController.save();
            } 
            addSalesLinkController.AddNewRow();
            addSalesLinkController.Cancel();
            addSalesLinkController.checkOptyEditAccess();
            Test.stopTest();
        }
        
    }
}