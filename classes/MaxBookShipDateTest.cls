@isTest(seeAllData=true)
private class MaxBookShipDateTest{

   
     static testMethod void myUnitTest() {
     Test.startTest();
     List<OpportunityLineItem> idList = new List<OpportunityLineItem>();
     

        User testUser= new User();
        testUser= TestingSetupDataUtil.createUser('stTest4','abc@hp.com','email13@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
        testUser.Business_Group__c='ES';
        testuser.Adoption_Role_Type__c='Executiv';
        insert testuser;

        Account newAcc=TestingSetupDataUtil.createAccount('ApprovalFlowTest','test_22@hp.com','Customer');
        insert newAcc;

        opportunity opp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOpptyForApprovalFlow', system.today()+ 30);
        opp.stageName=  '01 - Understand Customer';
        insert opp;
   
      
        Pricebook2 price= [select id, name, isActive from Pricebook2 where isStandard=True];

        Product2  prod=new Product2(Name='abc',isActive = True,Business_Group__c='ES',GBU__c = 'Application Services',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
        prod.CanUseRevenueSchedule=true;
        insert prod;
        
        
        PricebookEntry  priceEntry=TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        priceEntry.UseStandardPrice=true;
        insert priceEntry;
        
        
        
        OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,3,1000,opp.id,priceEntry.id,System.Today()+40);
        insert OppLineItem; 
        
        
        
        OpportunityLineItemSchedule lis = new OpportunityLineItemSchedule();
 
                lis.OpportunityLineItemId =OppLineItem .id;
 
                lis.Type = 'Revenue';
 
                lis.Revenue = OppLineItem.UnitPrice;
 
                lis.ScheduleDate = OppLineItem.ServiceDate;
                insert lis;
                
                OpportunityLineItemSchedule lis2 = new OpportunityLineItemSchedule();
 
                lis2.OpportunityLineItemId =OppLineItem .id;
 
                lis2.Type = 'Revenue';
 
                lis2.Revenue = OppLineItem.UnitPrice;
 
                lis2.ScheduleDate = OppLineItem.ServiceDate;
 
                insert lis2;
                
                
                
                idList.add(OppLineItem);
                
                MaxBookShipDate.updateBookshipDate(idList,idList);
     
       
                Test.stopTest();
     }
}