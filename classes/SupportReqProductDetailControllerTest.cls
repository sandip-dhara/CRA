/**********************************************************
* Class Name: SupportReqProductDetailControllerTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage for SupportReqProductDetailController class.
***********************************************************/
@isTest(SeeAllData=true)
private class SupportReqProductDetailControllerTest{
    static PageReference pref;
    static Support_Request__c sRequest;

    private static void setupData() {

        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
        //create a test opportunity
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        insert opty;
        
        // create a test pricebook2
        Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        // create a test Product2
        Product2 prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        insert prod;
       
        // create a test Product2
        PricebookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        insert priceEntry;
        
        // create a test Opportunity line item
        OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        insert OppLineItem;
        
        //create a test Support Request
        Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('Event-Demo');
        Id recordTypeId = null;
        if(csRecord!=null){
            recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
        }
        sRequest = TestingSetupDataUtil.createSupportRequest(opty.id,'Request description');
        if(recordTypeId !=null)
            sRequest.recordTypeId = recordTypeId;
        insert sRequest;
    }
    
     private static void setupData2() {

        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
        //create a test opportunity
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        insert opty;
        
        //create a test Support Request
        Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('Event-Demo');
        Id recordTypeId = null;
        if(csRecord!=null){
            recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
        }
        sRequest = TestingSetupDataUtil.createSupportRequest(opty.id,'Request description');
        if(recordTypeId !=null)
            sRequest.recordTypeId = recordTypeId;
        insert sRequest;
    }
    
    //Method for Positive test
    private static testMethod void ViewOptyProductsPositiveTest() {
        Test.startTest();
        setupData();
        pref = Page.SupportReqProductDetail;
        pref.getParameters().put('id',sRequest.id);
        Test.setCurrentPage(pref);
        
        ApexPages.StandardController stdController= new ApexPages.StandardController(sRequest);
        SupportReqProductDetailController controller = new SupportReqProductDetailController(stdController);
        Test.stopTest();
    }
    
    //Method for Negative test
    private static testMethod void ViewOptyProductsNegativeTest() {
        Test.startTest();
        setupData2();
        pref = Page.SupportReqProductDetail;
        pref.getParameters().put('id',sRequest.id);
        Test.setCurrentPage(pref);
        
        ApexPages.StandardController stdController= new ApexPages.StandardController(sRequest);
        SupportReqProductDetailController controller = new SupportReqProductDetailController(stdController);
        Test.stopTest();
    }
}