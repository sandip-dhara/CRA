/**********************************************************
* Class Name: MDCPSyncControllerTest
* Author: Sonia Prasala
* Date: 16-APR-2013
* Description: This class does the test coverage for MDCPSyncController class. 
***********************************************************/
@isTest
private class MDCPSyncControllerTest {

    static testMethod void mdcpSyncPositiveTest() {
          MDCPSyncController mdcpSyncController;
          Test.setMock(HttpCalloutMock.class, new MDCPMockHttpResponseGenerator());
          Account testCustomerAccount = TestingSetupDataUtil.createAccount('testAccountCustomer','accountEmail@email.com','Customer');
          testCustomerAccount.MDCP_Last_Synced__c=datetime.newInstance(2008,6,5);
          testCustomerAccount.ShippingCountry='France'; 
              insert testCustomerAccount;
          Account testPartnerAccount = TestingSetupDataUtil.createAccount('testAccountPartner','accountEmail@email.com','Partner');
          testPartnerAccount.MDCP_Business_Relationship_ID__c='653156';
          testPartnerAccount.ShippingCountry='France';  
          testPartnerAccount.MDCP_Last_Synced__c=datetime.newInstance(2008,6,5);
              insert testPartnerAccount;
          Error_Log__c testErrorData=new Error_Log__c(Error_Message__c='test error',name='test name',Record_Id__c='653156',Generated_On_Date__c=datetime.newInstance(2008,6,4));
              insert testErrorData;
          test.startTest();
               ApexPages.StandardController stdController = new ApexPages.StandardController(testCustomerAccount );
               mdcpSyncController= new MDCPSyncController(stdController);
               ApexPages.StandardController stdController2 = new ApexPages.StandardController(testPartnerAccount );
               mdcpSyncController= new MDCPSyncController(stdController2 );
               mdcpSyncController.processLinkClick();
               mdcpSyncController.getRecordTypeOptions();
               mdcpSyncController.getSync();
           test.stopTest(); 
    
    }

}