/**
 *@author: manasa.r (hp)
 * This class contains unit tests for validating the behavior of Apex class updateOpportunityLineItemBookShipDate
 *      1) updateOpportunityLineItemBookShipDate
 *      2) OpportunityAfterUpdate
 * ::  Author HP
 */
@isTest (seeAllData = true)

public with sharing class updateOpportunityLineItemBookShipDtTest {
    /*
     * Method for creating test data.
     */
         private static Account acc;
         private static Opportunity opty;
         private static Pricebook2 price;
         private static Product2 objProduct;
         private static PricebookEntry priceEntry;
         private static OpportunityLineItem OppLineItem;
         static contract_reference__c conref;
         
         private static void setUpData(){
        system.debug('Enter setUpData()');
        //Create a test account
        acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        system.debug('Account added is :::: '+acc.id);
        //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        opty.Type = 'New Business';
        opty.Route_To_Market__c = 'Direct';
        opty.Managed_By__c = 'HP';
        insert opty;
        system.debug('Opportunity added is :::: '+opty.id);
        //create Contract Reference for ContractValueSumup Method Author HP
        conref = new contract_reference__c();{
        conref.name='Test_contract';
        conref.original_opportunity__c=opty.id;
        conref.accounts__c=acc.id;
        }
        insert conref;
        system.debug('contact ref added is :::: '+conref.id);       
        // create a test pricebook2
        //price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
       /* price = [select id, name, isActive from Pricebook2 where name='Products & Services'];
        
        // create a test Product2
        prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'ESSN';
        prod.GBU__c = 'Technology Support';
        prod.Product_Line__c = 'Technology Support PL';
        prod.Sub_Product_Line__c = 'Technology Support Sub-PL';
        insert prod;
        
        // create a test Product2
        priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.id,100,'USD');
        priceEntry.UseStandardPrice=true;
        insert priceEntry;
        
        ID priceEntryID = [select id from PricebookEntry where priceBook2Id=:opty.Pricebook2Id].id; */
          // Bala added code
        price= [select id, name, isActive from Pricebook2 where isStandard=True];
        
        Product2 prod = new Product2(Name='abc', isActive = True, Business_Group__c='ES', GBU__c = 'Application Services',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
        prod.CanUseRevenueSchedule=true;
        insert prod;
        
        priceEntry=TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        priceEntry.UseStandardPrice=true;
        priceEntry.IsActive = true;
        insert priceEntry;
        // Bala added code end
        
       /* objProduct = [select Name,id from Product2 limit 1];
        priceEntry= [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id =:objProduct.id and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='USD'  limit 1];
        if(!priceEntry.IsActive){
          priceEntry.IsActive = true;
          update priceEntry;
         system.debug('price entry added is :::: '+priceEntry.id);
        }
        
        system.debug('Pricebook status is '+priceEntry.IsActive);*/
        // create a test Opportunity line item
        OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.ID,System.Today()+25);
        //Assigning contract reference id in line item. Author HP
        OppLineItem.contract__c = conref.id;
        //OppLineItem.servicedate=System.today();
        insert OppLineItem;
        system.debug('oppt line item added is :::: '+OppLineItem.id);
    }
    
    static testMethod void updateBookShipDate(){
          Test.startTest();  
            setUpData();        
        //Test.stopTest();       
        //update the close date to update book shipment date        
        system.debug('opt close date before update :::: '+opty.CloseDate);
        HPUtils.updateBookshipDateFlag = false;
        HPUtils.BGSpecificWorkflows = false;
        opty.CloseDate=System.today()+80;
        update opty;  
        //newmap.put(opty.id,opty);
        //updateOpportunityLineItemBookShipDate.updateBookshipDate(newmap,oldmap);      
        system.debug('opt close date after update :::: '+opty.CloseDate);
        Test.stopTest();
        //system.assertEquals(OppLineItem.servicedate, opty.CloseDate);
        
    }
}