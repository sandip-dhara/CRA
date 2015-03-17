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

@isTest(SeeAllData=true)
private class ProdSpecialtyOpptyDelBatchTest {

    static testMethod void ProdSpecialtyOpptyDelBatch() {
    datetime stdatetime1 = datetime.now();
    string stDatetime = string.valueof(stdatetime1);
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
 insert prod;        system.debug('Product2 inserted');                
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
 TMProcessProdLineItemSOMBatch batchCall= new TMProcessProdLineItemSOMBatch(oppSet,stDatetime);        
 specialtyUserAssign.To_Be_Deleted__c=true;
 Update specialtyUserAssign;
 ProdSpecialtyOpptyDelSchedular Opptydel = new ProdSpecialtyOpptyDelSchedular();
 Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProdSpecialtyOpptyDelBatch Size').Batch_Size__c);
        
        Id batchId = Database.executeBatch(new ProdSpecialtyOpptyDelBatch(), batchSize);
 
  test.stopTest();             
 }
 }