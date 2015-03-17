@isTest(seeAllData=true)
private class OMOpportunityMultyBUFlagUpdateTest{

   
     static testMethod void myUnitTest() {
     Test.startTest();
     List<OpportunityLineItem> idList = new List<OpportunityLineItem>();
     Account newAcc=TestingSetupDataUtil.createAccount('ApprovalFlowTest','test_22@hp.com','Customer');
     insert newAcc;
     opportunity opp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOpptyForApprovalFlow', system.today()+ 30);
     opp.stageName=  '01 - Understand Customer';
     insert opp;
   
      User testUser= new User();
      testUser= TestingSetupDataUtil.createUser('stTest4','abc@hp.com','email13@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
      testUser.Business_Group__c='ES';
      testuser.Adoption_Role_Type__c='Executiv';
      insert testuser;
      
      Pricebook2 price= [select id, name, isActive from Pricebook2 where isStandard=True];
      
     Pricebook2 price2 = [select id, name, isActive from Pricebook2 where isStandard=True];
     
      Pricebook2  price03 = [select id, name, isActive from Pricebook2 where isStandard=True];    
     
     Product2  prod=new Product2(Name='abc',isActive = True,Business_Group__c='ES',GBU__c = 'Application Services',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
        insert prod;
        
     Product2  prod02=new Product2(Name='abc1',isActive = True,Business_Group__c='ES',GBU__c = 'ITO',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
        insert prod02;
        
     Product2 prod03=new Product2(Name='abc1',isActive = True,Business_Group__c='TS',GBU__c = 'Technology Services',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
        insert prod03;
        
        PricebookEntry  priceEntry=TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        priceEntry.UseStandardPrice=true;
        insert priceEntry;
        
        PricebookEntry priceEntry02 = TestingSetupDataUtil.createPricebookEntry(prod02.Id,true,price2.Id,100,'USD');
        priceEntry02.UseStandardPrice=false;
        insert priceEntry02;
        
        PricebookEntry  priceEntry03 = TestingSetupDataUtil.createPricebookEntry(prod03.Id,true,price03.Id,100,'USD');
        insert priceEntry03;
        
        OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opp.id,priceEntry.id,System.Today()+40);
        insert OppLineItem; 
        
        OpportunityLineItem  OppLineItem02 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opp.id,priceEntry02.id,System.Today()+40);
        insert OppLineItem02;
        
        OpportunityLineItem OppLineItem03 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opp.id,priceEntry03.id,System.Today()+40);
        insert OppLineItem03;  

        
         idList.add(OppLineItem);
         idList.add(OppLineItem02);
         idList.add(OppLineItem03);
         
         OMOpportunityMultyBUFlagUpdate.hasBGGlobalUpdate(idList);
     
       
     Test.stopTest();
     }
}