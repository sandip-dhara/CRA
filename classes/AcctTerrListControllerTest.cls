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
@isTest(SeeAllData=False)
private class AcctTerrListControllerTest{

   
    static Sales_Territory__c salesTerr,salesTerr1;
    static Sales_Territory_Account_Assignment__c salesTerrAccAss,salesTerrAccAss1;
    static Sales_Territory_User_Assignment__c salesTerrUserAssObj,salesTerrUserAssObj1;
   
    
     static testMethod void testSalesTerrReport() {
        
        test.startTest();
        List<Account> accTest =new List<Account>();
        List<Sales_Territory_Account_Assignment__c> staccTest=new List<Sales_Territory_Account_Assignment__c>();
        
        for (Integer i=0;i<401;i++){
            Account acc= new Account(Name='Acctest'+i,AMID_L2__c='AMID',ShippingCity='Pune',ShippingState='MAH',ShippingCountry='INDIA');
            accTest.add(acc);
        }
        //insert Account
        insert accTest;
        
        salesTerr = new Sales_Territory__c (Name='Test',Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit',IsActive__c=True,MyComp_Sales_Territory_Name__c='test');
        //insert Sales Territory
        insert salesTerr;
      
        
        for (Integer i=0;i<401;i++){
            salesTerrAccAss=new Sales_Territory_Account_Assignment__c(Account__c=accTest[i].Id,Sales_Territory__c=salesTerr.Id,Assignment_Type__c='Manual');
            staccTest.add(salesTerrAccAss);
        }
        //insert Sales Territory Account Assignment
        insert staccTest; 
      
        salesTerrUserAssObj=new Sales_Territory_User_Assignment__c(Sales_Territory__c=salesTerr.Id,User__c=UserInfo.getUserId(),IsActive__c=true);
        //insert Sales Territory User Assignment
        insert salesTerrUserAssObj;
        AcctTerrListController accTerrListObj=new AcctTerrListController();
        accTerrListObj.next();
        accTerrListObj.Beginning();
        accTerrListObj.End();
        accTerrListObj.previous();
        accTerrListObj.getDisablePrevious();
        accTerrListObj.getDisableNext();
        accTerrListObj.getTotalPages();
        accTerrListObj.getPageNumber();
        accTerrListObj.getTotal_size();
        test.stopTest();
    }
}