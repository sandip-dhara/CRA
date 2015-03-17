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
@isTest
private class GroupInsertUpdateForTerritoryTest {

    static testMethod void grpInsertUpdateTest() {
        
        test.startTest();
        
        List<Sales_Territory__c> stList = new List<Sales_Territory__c>();
        List<Sales_Territory__c> stUpdateList = new List<Sales_Territory__c>();
        
        for(Integer i=0; i<20; i++){
            Sales_Territory__c st = new Sales_Territory__c (Name='test ST' + i, IsActive__c=true, IsConfidential__c=true,MyComp_Sales_Territory_Name__c='test');       
            stList.add(st);
        }
        insert stList;
        
        system.assertEquals(stList[0].Name, 'test ST0');
        
        Sales_Territory_Definition__c std = new Sales_Territory_Definition__c(Sales_Territory__c = stList[0].Id, AMID__c = 'Test123');
        insert std;
        
        // Sales Territory Update Test
        for(Sales_Territory__c stObj : stList){
            stObj.Name = 'test STerr';
            stObj.IsConfidential__c = false;
            stObj.IsActive__c = false;
            stUpdateList.add(stObj);
        }
        update stUpdateList;
        
        system.assertEquals(stUpdateList[0].IsConfidential__c, false);
        
        test.stopTest();
    }
    }