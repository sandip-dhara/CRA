/**********************************************************
* Class Name: TMProcessLocationSOMBatchTest
* Author: Raghvendra jha
* Date: 01-Aug-2013 
* Description: This class does the test coverage
*              for TMProcessLocationSOMBatch class. 
***********************************************************/
@isTest(SeeAllData=true)
private class TMProcessLocationSOMBatchTest {
    
     static testMethod void TMProcessLocationSOMBatch() {
        test.startTest();
        Datetime currentTime = system.Now();
        String formatedDt = currentTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
        Account acc1 = new Account(Name='PrevLocTestAcc1',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true);
        insert acc1;
        Account acc2 = new Account(Name='PrevLocTestAcc2',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='112',MDCP_Organization_ID__c='112',Channel_Partner_Flag__c=true);
        insert acc2;
        Location__c loc1 = new Location__c(Name='1500',Location_Name__c='Blr',Account__c = acc1.id);
        insert loc1;
        Location__c loc2 = new Location__c(Name='1600',Location_Name__c='Mys',Account__c = acc2.id,Country__c='India');
        insert loc2;
        Sales_Territory__c salesTerr1 = new Sales_Territory__c (Name='TestPreview1',MyComp_Sales_Territory_Name__c='TestPreview1', Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit',IsConfidential__c=False,IsPartner__c=true, New_User_Alert__c= true);
        insert salesTerr1;
        Sales_Territory_Location_Assignment__c stla= new Sales_Territory_Location_Assignment__c(Location__c=loc1.id,Sales_Territory__c=salesTerr1.id);
        insert stla;
        Sales_Territory_Location_Assignment__c stla1= new Sales_Territory_Location_Assignment__c(Location__c=loc2.id,Sales_Territory__c=salesTerr1.id);
        insert stla1; 
        
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
         
        Channel_Partner__c chhPart = new Channel_Partner__c();
        chhPart.Channel_Partner__c = acc1.Id;
        chhPart.Opportunity__c = opty.Id;
        chhPart.Location__c=loc1.Id;
        insert chhPart;   
        //create user in sales terr
        Sales_Territory_User_Assignment__c salesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr1.Id, User__c = testUser.Id,IsActive__c=true);
        insert salesTerrUser;

        //TM location SOM Test
        TMProcessLocationSOMBatchScheduler tm = new TMProcessLocationSOMBatchScheduler(formatedDt);
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Location Test :'+datetime.now(), schExp, tm);
        
        test.stopTest(); 
     }
}