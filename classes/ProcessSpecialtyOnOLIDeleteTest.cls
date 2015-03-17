/** * This class contains unit tests for validating the behavior of Apex class ProcessOppUpdateSpecialtyBatch * @author: rahul.kunal (Accenture) */
@isTest (SeeAllData = true)private class ProcessSpecialtyOnOLIDeleteTest {   
 /*      * @Desiption: Specialty Batch Process Test On OLI Delete.     */      
 static testMethod void specialtyOLIDeleteBatchTest(){              
 test.startTest();               
 Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');   
 insert acc;        //create a test opportunity      
 Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);    
 opty.Type = 'New Business';      
 opty.Route_To_Market__c = 'Direct';       
 insert opty;              
 // create a test pricebook2       
 Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];    
 system.debug('Pricebook2 inserted');                
 // create a test Product2       
 Product2 prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');      
 prod.Business_Group__c = 'ESSN';        prod.GBU__c = 'Technology Support';      
 prod.Product_Line__c = 'Technology Support PL';      
 prod.Sub_Product_Line__c = 'Technology Support Sub-PL';   
 insert prod;        system.debug('Product2 inserted');             
 // create a test Product2       
 PricebookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');     
 insert priceEntry;       
 system.debug('PricebookEntry inserted');      
 // create a test Opportunity line item       
 OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40); 
 insert OppLineItem;               
 //Create one test Log Object record.       
 Log_Object__c obj = new Log_Object__c(Object_Name__c = 'Opportunity', Record_Id__c = ''+opty.Id,Is_Added__c = true);   
 insert obj;                
 //Insert Batch Invoker Record for Teritory Management    
 Batch_Job_Invoker__c triggerObj = new Batch_Job_Invoker__c(Name='TestSpecialtyBatch',STATUS__C='Submitted',Type__c = 'Specialty On OLI Delete',Account_Record_Type__c='');
        insert triggerObj;               
        test.stopTest();             
        }}