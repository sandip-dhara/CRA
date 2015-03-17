/**********************************************************
* Class Name: CreateSupportRequestControllerTest
* Author: Accenture
* Date: 23-JUL-2012 
* Description: This class does the test coverage for CreateSupportRequestController class.
***********************************************************/
@isTest(SeeAllData=true)
private class CreateSupportRequestControllerTest{
    static PageReference pref;
    static Support_Request__c sRequest;
    
    static Opportunity opty;

    private static void setupData() {
        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
        //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
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
    private static testMethod void CreateSupportRequestPositiveTest() {
        Test.startTest();
        setupData();
        pref = Page.CreateSupportRequest;
        pref.getParameters().put('retURL',sRequest.id);
        pref.getParameters().put('sfdc.override','sfdc.override');
        pref.getParameters().put('save_new','save_new');
        pref.getParameters().put('CF00NG0000008SOJn_lkid',opty.id);
        pref.getParameters().put('com.salesforce.visualforce.ViewStateCSRF','com.salesforce.visualforce.ViewStateCSRF');
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController= new ApexPages.StandardController(sRequest);
        CreateSupportRequestController controller = new CreateSupportRequestController(stdController);        
        controller.getSupportRequestTypes();
        controller.selectedRequestType='Event';
        controller.getSupportRequestSubTypes();
        controller.selectedSubType='Demo';
        pageReference pr = controller.nextPage();

        Test.stopTest();
    }
    
    //Method for Negative test
    private static testMethod void CreateSupportRequestNegativeTest() {
        Test.startTest();
        setupData();
        pref = Page.CreateSupportRequest;
        pref.getParameters().put('retURL',sRequest.id);
        pref.getParameters().put('sfdc.override','sfdc.override');
        pref.getParameters().put('save_new','save_new');
        pref.getParameters().put('CF00NG0000008SOJn_lkid',opty.id);
        pref.getParameters().put('com.salesforce.visualforce.ViewStateCSRF','com.salesforce.visualforce.ViewStateCSRF');
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController= new ApexPages.StandardController(sRequest);
        CreateSupportRequestController controller = new CreateSupportRequestController(stdController);
        
        controller.getSupportRequestTypes();
        controller.selectedRequestType='SalesEngineering-Technical';
        controller.getSupportRequestSubTypes();
        controller.selectedSubType='Technical Design / SME';
        pageReference pr = controller.nextPage();
        
        Test.stopTest();
    }
    
    //Method for RSC create support request test
    private static testMethod void CreateSupportRequestRSCTest() {
        Test.startTest();
        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
        //create a test 
        
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        insert opty;
        
        pref = Page.CreateSupportRequest;
        //pref.getParameters().put('retURL',sRequest.id);
        //pref.getParameters().put('sfdc.override','sfdc.override');
        //pref.getParameters().put('save_new','save_new');
        pref.getParameters().put('CF00NG0000008SOJn_lkid',opty.id);
        //pref.getParameters().put('com.salesforce.visualforce.ViewStateCSRF','com.salesforce.visualforce.ViewStateCSRF');
        Test.setCurrentPage(pref);
        sRequest = new Support_Request__c();
        ApexPages.StandardController stdController= new ApexPages.StandardController(sRequest);
        CreateSupportRequestController controller = new CreateSupportRequestController(stdController);
        
        controller.getSupportRequestTypes();
        controller.selectedRequestType='Functional Support';
        controller.getSupportRequestSubTypes();
        controller.selectedSubType='Reference Success Center';
        pageReference pr = controller.nextPage();
        
        controller.selectedRequestType='Functional Support';
        controller.selectedSubType='Reference Success Center';
        pageReference pr1 = controller.nextPage();
        
        Test.stopTest();
    }
     
  private static testMethod void testAutoPopulate()
    {
        Test.startTest();
          Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
        //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        insert opty;
        
        
        
        
        
   Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
   User u = new User(Alias = 'standt', Email='standarduser@hp.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,Legacy_Employee_Ref__c='********',Email_Address__c ='qwert@hp.com',Business_Group__c ='PPS',
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser01a@testorg.com',Adoption_Role_Type__c= 'IT');
                                           
      System.runAs(u) { 
        //create a test Support Request
        Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('GSB Site Survey Commercial');
        Id recordTypeId = null;
        if(csRecord!=null){
            recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
        }
    
    Support_Request__c    sRequestgsb = TestingSetupDataUtil.createSupportRequest(opty.id,'Request description');
        if(recordTypeId !=null)
            sRequestgsb.recordTypeId = recordTypeId;
        insert sRequestgsb;        
      
        
        pref = Page.CreateSupportRequest;
        pref.getParameters().put('retURL',sRequestgsb.id);
        pref.getParameters().put('sfdc.override','sfdc.override');
        pref.getParameters().put('save_new','save_new');
        pref.getParameters().put('CF00NG0000008SOJn_lkid',opty.id);
        pref.getParameters().put('com.salesforce.visualforce.ViewStateCSRF','com.salesforce.visualforce.ViewStateCSRF');
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController= new ApexPages.StandardController(sRequestgsb);
        CreateSupportRequestController controller = new CreateSupportRequestController(stdController);        
        controller.getSupportRequestTypes();
        controller.selectedRequestType='Opportunity Coordination';
        controller.getSupportRequestSubTypes();
        controller.selectedSubType='GSB Site Survey Commercial';
        pageReference pr = controller.nextPage();
       }
        
        Test.stopTest();
    } 
    
}