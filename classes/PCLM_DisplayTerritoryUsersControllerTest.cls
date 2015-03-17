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
@isTest(seeAllData = true)
private class PCLM_DisplayTerritoryUsersControllerTest{
  /*  static PCLM_TodisplayTerritoryUsersController toDispTerrUserCtrObj;
    static PageReference pageRef;
    
    static testMethod void dispUnitTest(){
        List<Sales_Territory__c> stList=new List<Sales_Territory__c>();
        List<Sales_Territory_Location_Assignment__c> stlaList =new List<Sales_Territory_Location_Assignment__c>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
        Account acc= new Account(Name='Test', Source_System_Account_ID__c='ASF4DD',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true);
        insert acc;
        Location__c loc = new Location__c(Name='1500',Location_Name__c='Blr',Account__c = acc.id);
        insert loc;
        for (Integer i=0;i<100;i++){
           Sales_Territory__c salesTerr=new Sales_Territory__c(Name='Test',Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit');
           stList.add(salesTerr);
        }
        insert stList;
        for (Integer i=0;i<100;i++){
            Sales_Territory_Location_Assignment__c stlaObj=new Sales_Territory_Location_Assignment__c (Location__c=loc.Id,Sales_Territory__c=stList[i].Id);
          stlaList.add(stlaObj);
        }
        insert stlaList;
        ApexPages.StandardController stdCtlr = new ApexPages.StandardController(loc);
        toDispTerrUserCtrObj = new PCLM_TodisplayTerritoryUsersController(stdCtlr);
        toDispTerrUserCtrObj.locationRecord = loc;
        pageRef=toDispTerrUserCtrObj.locationTerritoryUsers();
    }
    */
}