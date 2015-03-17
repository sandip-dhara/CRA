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

// TM: Nasir:Test method for "TMProcessProdLineItemSOMBatchCall": Start

@isTest(SeeAllData=true)
private class TMProcessProdLineItemSOMBatchCallTest {

    static testMethod void TMProcessProdLineItemSOMBatchCall() {
        test.startTest();
        Account acc  = new Account(Name = 'test',RecordTypeId='012G0000000qHPx', Account_E_mail__c = 'accountEmail@email.com',
                        CurrencyIsoCode='USD', EvaluateTerritory__c = true, ShippingPostalCode = '99999-9999', ShippingCountry = 'United States',
                        MDCP_Organization_ID__c = '1234STR', Source_System_Account_ID__c = '543211STR', AMID_L2__c = 'A-12345');
        insert acc; 
        Account acc1  = new Account(Name = 'test',RecordTypeId='012G0000000qHPy', Account_E_mail__c = 'accountEmail@email.com',
                        CurrencyIsoCode='USD', EvaluateTerritory__c = true, ShippingPostalCode = '99999-9999', ShippingCountry = 'United States',
                        MDCP_Organization_ID__c = '12345STR', Source_System_Account_ID__c = '54321STR', AMID_L2__c = 'A-12345');
        insert acc1;
                                  
        Sales_Territory__c st= new Sales_Territory__c(Name='test',IsPartner__c=False,Account_Access__c='Read',Case_Access__c='Read',Opportunity_Access__c='Read',MyComp_Sales_Territory_Name__c='test');
        insert st;
        Sales_Territory__c st1= new Sales_Territory__c(Name='test',IsPartner__c=True,Account_Access__c='Read',Case_Access__c='Read',Opportunity_Access__c='Read',MyComp_Sales_Territory_Name__c='test');
        insert st1;
        
        Sales_Territory_Account_Assignment__c staa= new Sales_Territory_Account_Assignment__c(Account__c=acc.id,Sales_Territory__c=st.id);
        insert staa;
        Sales_Territory_Account_Assignment__c staa1= new Sales_Territory_Account_Assignment__c(Account__c=acc1.id,Sales_Territory__c=st1.id);
        insert staa1;
        Location__c loc  = new Location__c(Account__c=acc1.id, Name = 'testLocation', Location_Name__c = '12345');
        insert loc;
        Sales_Territory_Location_Assignment__c stla= new Sales_Territory_Location_Assignment__c (Location__c=loc.id,Sales_Territory__c=st1.id);
        insert stla;
        Opportunity opp = new Opportunity(Name = 'test',CloseDate = System.today(),AccountId = acc.id,StageName = '01 - Understand Customer',CurrencyIsoCode= 'USD');
        insert opp; 
        Channel_Partner__c cp= new Channel_Partner__c(Opportunity__c=opp.id,Channel_Partner__c=acc1.id,Partner_Type__c='Alliance Partner');
        insert cp; 
        
        List<Sales_Territory_Account_Assignment__c> lstaa= new List<Sales_Territory_Account_Assignment__c>();
        lstaa.add(staa1);
        lstaa.add(staa); 
        
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProductLineItemSOMBatchCall').Batch_Size__c);        
        Id batchId = Database.executeBatch(new TMProcessProdLineItemSOMBatchCall(), batchSize);
        
        Database.BatchableContext ctx;
        TMProcessProdLineItemSOMBatchCall batchCall= new TMProcessProdLineItemSOMBatchCall();        
        batchCall.execute(ctx,lstaa);
        
        test.stopTest();    
    }
    
     static testMethod void TMProcessProdLineItemSOMBatch() {
        test.startTest(); 
        string stDatetime;
        Product2 objProduct;
        PricebookEntry priceEntry;
        Opportunity opptyTest;
        
        Account acc  = new Account(Name = 'test',RecordTypeId='012G0000000qHPx', Account_E_mail__c = 'accountEmail@email.com',
                        CurrencyIsoCode='USD', EvaluateTerritory__c = true, ShippingPostalCode = '99999-9999', ShippingCountry = 'United States',
                        MDCP_Organization_ID__c = '1234STR', Source_System_Account_ID__c = '543211STR', AMID_L2__c = 'A-12345');
        insert acc; 
        Account acc1  = new Account(Name = 'test',RecordTypeId='012G0000000qHPy', Account_E_mail__c = 'accountEmail@email.com',
                        CurrencyIsoCode='USD', EvaluateTerritory__c = true, ShippingPostalCode = '99999-9999', ShippingCountry = 'United States',
                        MDCP_Organization_ID__c = '12345STR', Source_System_Account_ID__c = '54321STR', AMID_L2__c = 'A-12345');
        insert acc1;  
        
        opptyTest = TestingSetupDataUtil.createOpportunity(string.valueOf(acc.id),'opptyTest', system.today()+ 30);
        insert opptyTest; 
        Set<ID> oppSet= new Set<ID>(); 
        oppSet.add(opptyTest.id); 
        Pricebook2 pb2 = [select id from Pricebook2 where IsStandard = true];
        
        //Pricebook2 pb2=TestingSetupDataUtil.createPriceBook('Test Pricebook',true);
        //insert pb2;
        Product2 newPro1=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
        newPro1.Product_Line__c='Storage Essentials';
        newPro1.Sub_Product_Line__c='Storage Essentials';
        newPro1.Product_Level__c=2 ;
        newPro1.Business_Group__c='ES';
        newPro1.GBU__c='Application Services';
        newPro1.IsActive= true;
        newPro1.name='Test';
        insert newPro1;
        //objProduct = [select Name,Product_Line__c,Sub_Product_Line__c,id from Product2 limit 1];
       // priceEntry= [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id =:objProduct.id and Pricebook2.Name=: pb2.Name and CurrencyIsoCode ='USD'  limit 1];
                
        //priceEntry=TestingSetupDataUtil.createPricebookEntry(objProduct.id,true,pb2.id,1000,'USD'); 
        priceEntry=TestingSetupDataUtil.createPricebookEntry(newPro1.Id,true,pb2.Id,100,'USD');                
               
       // priceEntry= new PricebookEntry(product2Id=newPro1.id,UnitPrice=1000,Pricebook2Id=pb2.id,IsActive=True);
        insert priceEntry;
        if(!priceEntry.IsActive){
            priceEntry.IsActive = true;
            update priceEntry;
        } 
         
        
        OpportunityLineItem  oli= new OpportunityLineItem(Discount=10.00,Quantity =1,UnitPrice =1000,opportunityid=opptyTest.id,pricebookentryid=priceEntry.id,ServiceDate =System.Today()+40);
        insert oli;
        OpportunityLineItem  oli1= new OpportunityLineItem(Discount=10.00,Quantity =1,UnitPrice =1000,opportunityid=opptyTest.id,pricebookentryid=priceEntry.id,ServiceDate =System.Today()+40);
        insert oli1;
        
        List<OpportunityLineItem> lOli= new List<OpportunityLineItem>();
        lOli.add(oli);
        lOli.add(oli1);
        
        Database.BatchableContext ctx;
        TMProcessProdLineItemSOMBatch batchCall= new TMProcessProdLineItemSOMBatch(oppSet,stDatetime);        
        batchCall.execute(ctx,lOli);
        test.stopTest(); 
     }
}
// TM: Nasir:Test method for "TMProcessProdLineItemSOMBatchCall": End