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
private class TerritoryDisplayExtensionControllerTest {
    
    static TerritoryDisplayExtensionController terrDisExtContrObj;
    static PageReference pageRef;
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        List<Sales_Territory__c> stList=new List<Sales_Territory__c>();
        List<Sales_Territory_Account_Assignment__c> staaList =new List<Sales_Territory_Account_Assignment__c>();
        Account acc= new Account(Name='Test', Source_System_Account_ID__c='ASF4DD');
        insert acc;
        for (Integer i=0;i<100;i++){
             Sales_Territory__c salesTerr=new Sales_Territory__c(Name='Test',Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit',MyComp_Sales_Territory_Name__c='test');
             stList.add(salesTerr);
        }
        insert stList;
        for (Integer i=0;i<100;i++){
              Sales_Territory_Account_Assignment__c staaObj=new Sales_Territory_Account_Assignment__c (Account__c=acc.Id,Sales_Territory__c=stList[i].Id);
            staaList.add(staaObj);
        }
        insert staaList;
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        terrDisExtContrObj = new TerritoryDisplayExtensionController(stdController);
        system.debug('*******terrDisExtContrObj.theAcct****************'+terrDisExtContrObj.theAcct);
        terrDisExtContrObj.theAcct=acc;
        pageRef=terrDisExtContrObj.accountTerritoryUser();
        system.debug('*******pageRef****************' +pageRef);
        
         //System.assertNotEquals(null, pageRef);
    }
}