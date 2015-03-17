/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=false)
private class SalesTerritoryExtensionControllerTest {

    static SalesTerritoryPreview salesTerritoryObj,salesTerritoryObj1;
    static Sales_Territory__c salesTerr,salesTerr1;
    static PageReference pageRef;
    
     static testMethod void testSalesTerrReport() {
        
        //TM:Debmalya:R3: Adding Account data
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        Account acc= new Account(Name='Acctest',AMID_L2__c='AMID1',RecordTypeId = RecordTypeId,ShippingCountry = 'India',ShippingState = 'MAH',
                                MDCP_Organization_ID__c = '1234STR', Source_System_Account_ID__c = '54321STR');
        insert acc;
        Account acc1= new Account(Name='Acctest1',RecordTypeId = RecordTypeId,ShippingCountry = 'India',ShippingPostalCode = '1234', 
                                MDCP_Organization_ID__c = 'MPDP123', Source_System_Account_ID__c = '54321STR1');
        insert acc1;
        salesTerr = new Sales_Territory__c (Name='Test',MyComp_Sales_Territory_Name__c='Test',Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit',IsConfidential__c=False,IsPartner__c=false);
        salesTerr1 = new Sales_Territory__c (Name='Test1',MyComp_Sales_Territory_Name__c='Test1',Account_Access__c='Edit',Case_Access__c='None',Opportunity_Access__c='None');
        insert salesTerr;
        insert salesTerr1;
        Sales_Territory_Definition__c salesTerrDefn=new Sales_Territory_Definition__c(Sales_Territory__c=salesTerr.Id,AMID__c='AMID01',State_Province__c='MAH',Country__c='India');
       // Sales_Territory_Definition__c salesTerrDefn1=new Sales_Territory_Definition__c(Sales_Territory__c=salesTerr1.Id, Source_System_ID__c='ADE34XX',Industry_Vertical__c='Test');
        Sales_Territory_Definition__c salesTerrDefn2=new Sales_Territory_Definition__c(Sales_Territory__c=salesTerr.Id,MDCP_ID__c='MPDP0123',Postal_Code_Start__c='1234',Postal_Code_End__c='12345',Country__c='India');
        insert salesTerrDefn;
        Sales_Territory_Definition__c salesTerrDefn3=new Sales_Territory_Definition__c(Sales_Territory__c=salesTerr.Id,MDCP_ID__c='MPDP00123',Exclude__c = true);
        insert salesTerrDefn3;
        system.debug('*******salesTerrDefn***preview**'+salesTerrDefn+'*****'+salesTerrDefn.AccountPreviewQuery__c);
        system.debug('*******AccountPreviewQuery*****'+salesTerrDefn.AccountPreviewQuery__c);
        //insert salesTerrDefn1;
        insert salesTerrDefn2;
        system.debug('*******AccountPreviewQuery*****'+salesTerrDefn2.AccountPreviewQuery__c);
       
        /* Testing Constructor */
       ApexPages.StandardController stdController = new ApexPages.StandardController(salesTerr);
       salesTerritoryObj = new SalesTerritoryPreview (stdController);
      //ApexPages.StandardController stdController1 = new ApexPages.StandardSetController(salesTerritoryObj.getQuery());
      salesTerritoryObj.next();
      salesTerritoryObj.Beginning();
      salesTerritoryObj.End();
      salesTerritoryObj.previous();
      salesTerritoryObj.getDisablePrevious();
      salesTerritoryObj.getDisableNext();
      salesTerritoryObj.getTotalPages();
      salesTerritoryObj.getPageNumber();
      salesTerritoryObj.getTotal_size();
        
    }
}