/**********************************************************
* Class Name: SupReqPSdeliveryResourceControllerTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage for SupportReqProductDetailController class.
***********************************************************/
@isTest(SeeAllData=true)
private class SupReqPSdeliveryResourceControllerTest{
    static PageReference pref;
    static Support_Request__c sRequest;
    public static Profile SRProfile = [select Name, Id from Profile where Name ='IT Administrator'];  
    public static User SRuseroptyowner;
    
    public static void usercreation(){
          SRuseroptyowner = new User(Lastname = 'TestUseroptyowner', Firstname= 'BG', Username = 'testingoptyowner0128@hp.com', Alias='TesBG1', CommunityNickname='TestUseroptyownerBG123', Adoption_Role_Type__c = 'Account Executive', Email='test0128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyowner0128@hp.com',EmployeeNumber='.',Legacy_Employee_Ref__c='65348261', ProfileId = SRProfile.id,Business_Group__c = 'SW', Region__c = 'AMS');
          Insert SRuseroptyowner; 
          }
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
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('SW-FunctionalSupport-PSDelResource');
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
    private static testMethod void ViewSupReqPSDeliveryPositiveTest() {
        Test.startTest();
        usercreation();
        system.RunAs(SRuseroptyowner){
        setupData();
               
        ApexPages.StandardController stdController= new ApexPages.StandardController(sRequest);
        SupReqPSdeliveryResourceController controller = new SupReqPSdeliveryResourceController();
       controller.SupportReqId = sRequest.Id;
       controller.getEmployee();
        Test.stopTest();
         }   
    }
    
    
}