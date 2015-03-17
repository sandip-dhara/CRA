// NAsir JAwed R5 EF CR-0979: test method for TMWonLostSOMDeleteBatch 19/6/2013: Start

@isTest(seeAllData=true)
private class TMWonLostSOMDeleteBatchTest{
    static Account accCust = new Account();
    static Opportunity opptyTest;
    private static Product2 objProduct;
    static Product_Specialty_User_Assignment__c psua;
    static Sales_Territory__c SalesTerr;
    static Sales_Territory_User_Assignment__c stua;
    

    static testMethod void TMWonLostSOMDeleteBatch() {
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');    
        insert acc; 
              
        //create a test opportunity    
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);        
        opty.Type = 'New Business';       
        opty.Route_To_Market__c = 'Direct';       
        insert opty;   
                
        Set<ID> oppSet= new Set<ID>(); 
        oppSet.add(opty.id); 
         
        // create a test pricebook2        
        Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];    
        system.debug('Pricebook2 inserted');                 
        // create a test Product2       
         
        Product2 prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'ESSN';       
        prod.GBU__c = 'Technology Support';       
        prod.Product_Line__c = 'Technology Support PL';        prod.Sub_Product_Line__c = 'Technology Support Sub-PL';  
        insert prod;        
        system.debug('Product2 inserted');                        
        // create a test Product2       
        
        PricebookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');      
        insert priceEntry;        system.debug('PricebookEntry inserted');  
              
        // create a test Opportunity line item             
        OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);       
        insert OppLineItem;          
            
        //Create one test Log Object record.       
        Log_Object__c obj = new Log_Object__c(Object_Name__c = 'Opportunity', Record_Id__c = ''+opty.Id,Is_Added__c = true);        
        insert obj;   
        
        //Create one test Specialty Object record.
        Product_Specialty__c specialty = new Product_Specialty__c(Name = 'test specialty',Source__c='Quest');
        insert specialty;
        //Create one test  Object record.
        
        Product_Specialty_Definition__c prodSpecialtyDefinition = new Product_Specialty_Definition__c(Product_Specialty__c = specialty.id,Product__c=Prod.id,Opportunity_Type__c='ALL',Route__c='ALL');
        insert prodSpecialtyDefinition;
        
        User testUser = TestingSetupDataUtil.testUser;
        Product_Specialty_User_Assignment__c specialtyUserAssign = new Product_Specialty_User_Assignment__c(Product_Specialty__c = specialty.id,Source__c='Manual',User__c =testUser.id,New_Or_Updated__c=true);
        insert specialtyUserAssign;
        
        Product_Specialty_Oppty_Assignment__c prodSpecOpptyAssign = new Product_Specialty_Oppty_Assignment__c(Product_Specialty_User_Assignment__c = specialtyUserAssign.id);
        insert prodSpecOpptyAssign;
        
        test.startTest();
        Database.BatchableContext ctx;
        List<Product_Specialty_Oppty_Assignment__c> somId= new List<Product_Specialty_Oppty_Assignment__c>();
        
        TMWonLostSOMDeleteBatch Opptydel = new TMWonLostSOMDeleteBatch();
        Opptydel.execute(ctx,somId);
        
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('TMWonLostSOMDeleteBatch').Batch_Size__c);
        
        Id batchId = Database.executeBatch(new TMWonLostSOMDeleteBatch(), batchSize);
        
        test.stopTest();  
    
    
    }
}



// Nasir Jawed R5.EF CR-0979: Test method for TMWonLostSOMDeleteBatch 19/6/2013: End