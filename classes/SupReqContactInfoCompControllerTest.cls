/**********************************************************
* Class Name: SupReqContactInfoComponentControllerTest
* 
* Description: This class does the test coverage for SupReqContactInfoCompController class.
***********************************************************/
@isTest (SeeAllData=true)
private class SupReqContactInfoCompControllerTest{
    static PageReference pref;
    static Support_Request__c sRequest;
    
    
    
    
    

    private static void setupData() {
    
    
    // set user BG as pps 
    User updUserBG = [select Business_Group__c from user where id=:UserInfo.getuserid()];
            updUserBG .Business_Group__c = 'PPS';
            update updUserBG ;
    
    
    
    

        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_9', 'testAccount_01@hp.com','Customer');
        insert acc;
        
        //create a test opportunity
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty01_952PM',System.Today()+30);   
        insert opty;
        
        // create a test pricebook2
        Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        // create a test Product2
        Product2 prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','12345');
        insert prod;
       
        // create a test Product2
        PricebookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        insert priceEntry;
        
        // create a test Opportunity line item
        OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        insert OppLineItem;
        
        //create a contact 
                Contact con = TestingSetupDataUtil.createContact(acc.Id, 'Test Contact01');
                insert con; 
                System.debug(con.Id);
               
        
        //create a test Support Request
        Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('GSB Site Survey Label');
        Id recordTypeId = null;
        if(csRecord!=null){
            recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
        }
        sRequest = TestingSetupDataUtil.createSupportRequest(opty.id,'Request description');
        if(recordTypeId !=null)
            sRequest.recordTypeId = recordTypeId;
            
            sRequest.contact__c = con.Id;
        insert sRequest;
    }
    
     private static void setupData2() {
     
        User updUserBG = [select Business_Group__c from user where id=:UserInfo.getuserid()];
            updUserBG .Business_Group__c = 'PPS';
            update updUserBG ;
    

        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_02@hp.com','Customer');
        insert acc;
        
        //create a test opportunity
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty02_952PM',System.Today()+30);   
        insert opty;
        
        //create a contact 
                Contact con = TestingSetupDataUtil.createContact(acc.Id, 'Test Contact02');
                insert con; 
                System.debug(con.Id);
            
        
        
        //create a test Support Request
        Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('GSB Site Survey Label');
        Id recordTypeId = null;
        if(csRecord!=null){
            recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
        }
        sRequest = TestingSetupDataUtil.createSupportRequest(opty.id,'Request description');
        if(recordTypeId !=null)
            sRequest.recordTypeId = recordTypeId;
            sRequest.contact__c = con.Id; 
        insert sRequest;
    }
    
    //Method for Positive test
    private static testMethod void ViewOptyProductsPositiveTest() {
        Test.startTest();
        setupData();
        pref = Page.SupportReqProductDetail;
        pref.getParameters().put('id',sRequest.id);
        Test.setCurrentPage(pref);
        
      
        
        SupReqContactInfoCompController controller1 = new SupReqContactInfoCompController();
        controller1.SupportRequestId = sRequest.Id;
        controller1.getContactEmail();
        
        Test.stopTest();
    }
    
    //Method for Negative test
    private static testMethod void ViewOptyProductsNegativeTest() {
        Test.startTest();
        setupData2();
        pref = Page.SupportReqProductDetail;
        pref.getParameters().put('id',sRequest.id);
        Test.setCurrentPage(pref);
        
        //ApexPages.StandardController stdController= new ApexPages.StandardController(sRequest);
        //SupportReqProductDetailController.SupportRequestId = sRequest.Id;
        SupReqOptyProdComponentController controller = new SupReqOptyProdComponentController();
        controller.SupportRequestId = sRequest.Id;
        controller.getOptyProducts();
        Test.stopTest();
    }
}