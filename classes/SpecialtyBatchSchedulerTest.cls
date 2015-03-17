/**
 * This class contains unit tests for validating the behavior of Apex classes SpecialtyBatchScheduler
 */
@isTest (SeeAllData = true)
private class SpecialtyBatchSchedulerTest {

    static testMethod void specialtyScheduleTest() {
        
        test.startTest(); 
        
        SpecialtyBatchScheduler spcltyBatchSchd = new SpecialtyBatchScheduler();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('Specialty Schedular Test :'+datetime.now(), schExp, spcltyBatchSchd);
        
        test.stopTest();
    }
    
    static testMethod void processScheduledSpecltyBatchTest() {
        
        test.startTest(); 
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        //create a test opportunity
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        opty.Type = 'New Business';
        opty.Route_To_Market__c = 'Direct';
        insert opty;
        
        // create a test pricebook2
        Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        system.debug('Pricebook2 inserted'); 
        
        // create a test Product2
        Product2 prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'ESSN';
        prod.GBU__c = 'Technology Support';
        prod.Product_Line__c = 'Technology Support PL';
        prod.Sub_Product_Line__c = 'Technology Support Sub-PL';
        insert prod;
        system.debug('Product2 inserted');
        
        // create a test Product2
        PricebookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        insert priceEntry;
        system.debug('PricebookEntry inserted');
        // create a test Opportunity line item
        OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        insert OppLineItem;
        
        //create a test sales territroy record.
        Sales_Territory__c salesTerr = new Sales_Territory__c(Name = 'testSalesTerritory', IsActive__c = true,MyComp_Sales_Territory_Name__c='test');
        insert salesTerr;
        
        //create a Sales Territory Account record
        Sales_Territory_Account_Assignment__c salesTerrAcc = new Sales_Territory_Account_Assignment__c(Account__c = acc.Id, Sales_Territory__c = salesTerr.Id);
        insert salesTerrAcc;
        
        Id batchId = Database.executeBatch(new ProcessScheduledSpecltyBatch(),50);
        
        test.stopTest();
    }
    
}