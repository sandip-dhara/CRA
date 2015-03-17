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
private class SalesTerritoryDefinitionTest {

    static testMethod void myUnitTest() {
        
        
        test.startTest();
        
        List<Sales_Territory__c> stList = new List<Sales_Territory__c>();
        List<Sales_Territory__c> stUpdateList = new List<Sales_Territory__c>();
        
        for(Integer i=0; i<20; i++){
            Sales_Territory__c st = new Sales_Territory__c (Name='test ST' + i, IsActive__c=true, IsConfidential__c=true,MyComp_Sales_Territory_Name__c='test');       
            stList.add(st);
        }
        insert stList;
        
        system.assertEquals(stList[0].Name, 'test ST0');
        
        List<Sales_Territory_Definition__c> stdList = new List<Sales_Territory_Definition__c>();
        
        //Account Profile Type
        Sales_Territory_Definition__c std1 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[0].Id, AMID__c = 'Test1');
            stdList.add(std1);
        Sales_Territory_Definition__c std2 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[1].Id, MDCP_ID__c = 'Test2');
            stdList.add(std2);
        Sales_Territory_Definition__c std3 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[2].Id, Source_System_Id__c = 'Test3');
            stdList.add(std3);
        //Industry Type
        Sales_Territory_Definition__c std4 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[3].Id, Industry_Vertical__c = 'Test4');
            stdList.add(std4);
        Sales_Territory_Definition__c std5 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[4].Id, BG_Sales_Coverage_Segment__c = 'Test5');
            stdList.add(std5);
        Sales_Territory_Definition__c std6 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[5].Id, Named_Account__c = 'Test6');
            stdList.add(std6);
        Sales_Territory_Definition__c std7 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[6].Id, RAD__c = 'Test7');
            stdList.add(std7);
        Sales_Territory_Definition__c std8 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[7].Id, Geographic_Hierarchy__c = 'SSId 1');
            stdList.add(std8);
        Sales_Territory_Definition__c std9 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[8].Id, Country__c = 'SSId 2',Postal_Code_Start__c ='121212',Postal_Code_End__c='232323');
            stdList.add(std9);
        Sales_Territory_Definition__c std10 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[9].Id, Country__c = 'SSId 2', State_Province__c = 'SSId 3');
            stdList.add(std10);
        Sales_Territory_Definition__c std11 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[10].Id, Country__c = 'SSId 4');
            stdList.add(std11);
            
        try{    
            insert stdList;
        } catch(DmlException e){
            //Assert Error Message
            System.assert( e.getMessage().contains('first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot Save record : Sales Territory Definition already exists.: []'),e.getMessage());
            //Assert Status Code 
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }
        try{         
            Update stdList;
        } catch(DmlException e){
            //Assert Error Message
            System.assert( e.getMessage().contains('first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot Save record : Sales Territory Definition already exists.: []'),e.getMessage());
            //Assert Status Code 
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }
        
        Sales_Territory_Definition__c std13 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[0].Id, AMID__c = 'Test11');
        
        try{
            insert std13;
        } catch(DmlException e){
            //Assert Error Message
            System.assert( e.getMessage().contains('first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot Save record : Sales Territory Definition already exists.: []'),e.getMessage());
            //Assert Status Code 
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }
        //TM:Debmalya: Test data for SaleTerritoryUtil:Start
        Sales_Territory__c stCustomer = new Sales_Territory__c (Name='test ST Customer', IsActive__c=true, IsConfidential__c=true, IsPartner__c=false,MyComp_Sales_Territory_Name__c='test');
        insert stCustomer;
        Sales_Territory__c stPartner = new Sales_Territory__c (Name='test ST Partner', IsActive__c=true, IsConfidential__c=true, IsPartner__c=true,MyComp_Sales_Territory_Name__c='test');
        insert stPartner;
        List<Sales_Territory_Definition__c> stdListSTUtil = new List<Sales_Territory_Definition__c>();
        Sales_Territory_Definition__c stdCust = new Sales_Territory_Definition__c(Sales_Territory__c = stCustomer.Id, AMID__c = 'Test12');
        Sales_Territory_Definition__c stdPart = new Sales_Territory_Definition__c(Sales_Territory__c = stPartner.Id, AMID__c = 'Test13');
        stdListSTUtil.add(stdCust);
        stdListSTUtil.add(stdPart);
        try{    
            insert stdListSTUtil;
        } catch(DmlException e){
            //Assert Error Message
            System.assert( e.getMessage().contains('first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot Save record : Sales Territory Definition already exists.: []'),e.getMessage());
            //Assert Status Code 
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }
        //TM:Debmalya: Test data for SaleTerritoryUtil:End
        std13.AMID__c = 'Test124';
        update std13;
        
        List<Sales_Territory_Definition__c> stdAssert = [Select Id, Index__c, Filter__c from Sales_Territory_Definition__c where (Id =: stdList[0].Id OR Id =: stdList[1].Id)];
        
        system.assertNotEquals(null,stdAssert[0].Filter__c);
        system.assertNotEquals(null,stdAssert[1].Filter__c);
        system.assertNotEquals(null,stdAssert[0].Index__c);
        system.assertNotEquals(null,stdAssert[1].Index__c);
        
        
        std13.AMID__c = 'Test1';
        try{
            update std13;
            
        } catch(DmlException e){
            //Assert Error Message
            System.assert( e.getMessage().contains('first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot Save record : Sales Territory Definition already exists.: []'),e.getMessage());
            //Assert Status Code 
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }
        try{
            delete std13;
            
        } catch(DmlException e){
            //Assert Error Message
            System.assert( e.getMessage().contains('first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot Save record : Sales Territory Definition already exists.: []'),e.getMessage());
            //Assert Status Code 
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }
            
        Sales_Territory_Definition__c std14 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[0].Id, AMID__c = 'Test1');
        
        try{
            insert std14;
            
        } catch(DmlException e){
            system.debug('catched exception : ' + e);
            //Assert Error Message
            System.assert( e.getMessage().contains('first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot Save record : Sales Territory Definition already exists.: []'),e.getMessage());
            //Assert Status Code 
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,e.getDmlType(0));
        }  

        
        test.stopTest();
    }
}