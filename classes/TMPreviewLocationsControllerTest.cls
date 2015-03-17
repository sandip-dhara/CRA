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
 private class TMPreviewLocationsControllerTest{
    static TMPreviewLocationsController previewlocObj;
    static Sales_Territory__c salesTerr1,salesTerr2;
    static PageReference pageRef;
    
    static testMethod void testSalesTerritoryPreview(){
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
        
        Account acc1 = new Account(Name='PrevLocTestAcc1',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true);
        insert acc1;
        Account acc2 = new Account(Name='PrevLocTestAcc2',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='112',MDCP_Organization_ID__c='112',Channel_Partner_Flag__c=true);
        insert acc2;
        
        World_Region__c parentWldRgn = new World_Region__c(Name = 'AP without Japan',ParentName__c = 'Asia Pacific');
        insert parentWldRgn;
        World_Region__c wldRgn = new World_Region__c(Name = 'IN',ParentName__c = 'AP without Japan',ParentId__c = parentWldRgn.id,Country_Name__c = 'India');
        insert wldRgn;
        
        Location__c loc1 = new Location__c(Name='1500',Location_Name__c='Blr',Account__c = acc1.id);
        insert loc1;
        Location__c loc2 = new Location__c(Name='1600',Location_Name__c='Mys',Account__c = acc2.id,Country__c='India');
        insert loc2;
        Location__c loc3 = new Location__c(Name = '787',Location_Name__c='Mlr',Account__c = acc1.id,Country__c='India',State__c = 'Karnataka',Postal_Code__c = '544',World_Region1__c = wldRgn.id);
        insert loc3;
        
        salesTerr1 = new Sales_Territory__c (Name='TestPreview1',Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit',IsConfidential__c=False,IsPartner__c=true,MyComp_Sales_Territory_Name__c = 'ST-TestTerrPview1');
        salesTerr2 = new Sales_Territory__c (Name='TestPreview2',Account_Access__c='Edit',Case_Access__c='None',Opportunity_Access__c='None',IsConfidential__c=False,IsPartner__c=true,MyComp_Sales_Territory_Name__c = 'ST-TestTerrPview2');
        insert salesTerr1;
        insert salesTerr2;
        
        Sales_Territory_Definition__c salesTerrDefn1=new Sales_Territory_Definition__c(Sales_Territory__c=salesTerr1.Id,Partner_Locator_Id__c = loc1.Name);
        Sales_Territory_Definition__c salesTerrDefn2=new Sales_Territory_Definition__c(Sales_Territory__c=salesTerr1.Id,MDCP_ID__c='111',Business_Relationship__c='1234',Country__c='India');
        Sales_Territory_Definition__c salesTerrDefn3=new Sales_Territory_Definition__c(Sales_Territory__c=salesTerr1.Id,MDCP_ID__c='111',Business_Relationship__c='1234',Country__c='India',State_Province__c = 'Karnataka');
        Sales_Territory_Definition__c salesTerrDefn4=new Sales_Territory_Definition__c(Sales_Territory__c=salesTerr1.Id,MDCP_ID__c='111',Business_Relationship__c='1234',Country__c='India',Postal_Code_Start__c = '540',Postal_Code_End__c = '546');
        Sales_Territory_Definition__c salesTerrDefn5=new Sales_Territory_Definition__c(Sales_Territory__c=salesTerr1.Id,MDCP_ID__c='111',Business_Relationship__c='1234',Geographic_Hierarchy__c = 'AP without Japan');
        insert salesTerrDefn1;
        insert salesTerrDefn2;
        insert salesTerrDefn3;
        insert salesTerrDefn4;
        insert salesTerrDefn5;
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(salesTerr1);
        previewlocObj = new TMPreviewLocationsController(stdController);
        previewlocObj.next();
        previewlocObj.beginning();
        previewlocObj.endp();
        previewlocObj.previous();
        previewlocObj.getDisablePrevious();
        previewlocObj.getDisableNext();
        previewlocObj.getTotalPages();
        previewlocObj.getTotalSize();
    }
 }