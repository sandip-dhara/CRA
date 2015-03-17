@isTest(seeAllData = true)
Public Class DgPreRoutingLogicTest{



//
static Opportunity newOpp;
    static User portalUser;
    static List<PricebookEntry> listPrbEntry;                                                                                                    
    static List<OpportunityLineItem> listOpptyProduct;
    static List<OpportunityLineItem> listOpptyProduct1=new List<OpportunityLineItem>();
    static List<Product2> listProduct2;
    static set<Id> setOpptyProduct1= new set<Id>();
    static OpportunityLineItem newOppLineItem11;
    static List<PricebookEntry> listPrbEntry1;
    static Pricebook2 prb;
    
  
 public Static testMethod  void setupData1(){
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
        /*Insert Account and Opportunity*/
    
        User user2 = new User();
        user2 = TestingSetupDataUtil.createUser('Apprt11','Approvalfu1@hp.com','Appro2@hp.com','UTF-8','Tertln','en_US','en_US','America/Los_Angeles','Approvalf3@hp.com','876321',Userinfo.getProfileId());
        user2.Business_Group__c='SW';
        insert user2;
       system.runas(user2){ 
        
        Account newAcc1=TestingSetupDataUtil.createAccount('ApprovalTestAccount','ApprovalfuncTest1@hp.com','Customer');
        newAcc1.World_Region1__c=wr.id;
        insert newAcc1;
        
      Pricebook2 prb1 = [select id from Pricebook2 where IsStandard = true];
         
         // Software   
            Product2 Sofware1=TestingSetupDataUtil.createProduct(true ,'testProduct3','USD',null);
            insert Sofware1;
            Sofware1.Product_Line__c='2Z - Premier Support';
            Sofware1.Sub_Product_Line__c='2E - BSM Consulting';
            Sofware1.Product_Level__c=2 ;
            Sofware1.Business_Group__c='HP Software';
            Sofware1.GBU__c='ops';
            Sofware1.IsActive=true;
            update Sofware1;
            Product2 Sofware2=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
            insert Sofware2;
            Sofware2.Product_Line__c='2E - Ops Services';
            Sofware2.Sub_Product_Line__c='2E - BSM Consulting';
            Sofware2.Product_Level__c=2 ;
            Sofware2.Business_Group__c='HP Software';
            Sofware2.GBU__c='ops';
            Sofware2.IsActive=true;
            update Sofware2;
     
            //SW
           List<PricebookEntry>  PricebookEntrySofware1 = new List<PricebookEntry>();
            PricebookEntry newEntrySofware1=TestingSetupDataUtil.createPricebookEntry(Sofware1.Id,true,prb1.Id,1000,'USD');
            PricebookEntry newEntrySofware2=TestingSetupDataUtil.createPricebookEntry(Sofware2.Id,true,prb1.Id,1000,'USD');        
            PricebookEntrySofware1.add(newEntrySofware1);
            PricebookEntrySofware1.add(newEntrySofware2);            
            insert PricebookEntrySofware1 ;
            
          
           
            Opportunity newOpp1=TestingSetupDataUtil.createOpportunity(newAcc1.Id, 'testOppty57', system.today()+ 30);
            insert newOpp1; 

            /*Insert two Opportunity Line Items*/
      
        
         list<OpportunityLineItem> listOpptyProductSoftware1 = new list<OpportunityLineItem>();
       OpportunityLineItem   newOppLineItemSoftware11 = new OpportunityLineItem(OpportunityId = newOpp1.Id, PricebookEntryId = PricebookEntrySofware1[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);            
            
       OpportunityLineItem     newOppLineItemSoftware12 = new OpportunityLineItem(OpportunityId = newOpp1.Id, PricebookEntryId = PricebookEntrySofware1[1].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
           listOpptyProductSoftware1.add(newOppLineItemSoftware11);
            listOpptyProductSoftware1.add(newOppLineItemSoftware12);
            insert listOpptyProductSoftware1;
        
         Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Approval__c') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
     
        
        
        List<OpportunityLineItem > SoftwareProdList = new List<OpportunityLineItem >();
         OpportunityLineItem   newOppLineItemSoftware1 = new OpportunityLineItem(OpportunityId = newOpp1.Id, PricebookEntryId = PricebookEntrySofware1[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);            
            
       OpportunityLineItem     newOppLineItemSoftware2 = new OpportunityLineItem(OpportunityId = newOpp1.Id, PricebookEntryId = PricebookEntrySofware1[1].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
           SoftwareProdList.add(newOppLineItemSoftware1);
            SoftwareProdList.add(newOppLineItemSoftware2);
            insert SoftwareProdList;
            
             Id rcdType2= RecordTypeInfo.get('Opportunity Business Review').getRecordTypeId();
      Approval__c  approval2=new Approval__c();
        approval2.opportunity__c=newOpp1.id;
        approval2.RecordTypeID=rcdType2;
        insert approval2;
        
                    
       DGPreRoutingLogic d = new DGPreRoutingLogic();
        
        d.ProductPriorityRouting(newOpp1.id,approval2.id);
     }
       
    }    
    
    
    public Static testMethod  void setupData(){
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
        /*Insert Account and Opportunity*/
       
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('Approut1','ApprovalfuncTest1@hp.com','ApprovalfuncTest2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','ApprovalfuncTest3@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='ES';
        insert user1;
        system.runas(user1){
        
          Account newAcc=TestingSetupDataUtil.createAccount('ApprovalTestAccount','ApprovalfuncTest1@hp.com','Customer');
             newAcc.World_Region1__c=wr.id;
             insert newAcc;
        
      Pricebook2 prb1 = [select id from Pricebook2 where IsStandard = true];
            Product2 newPro3=TestingSetupDataUtil.createProduct(true ,'testProduct3','USD',null);
            insert newPro3;
            newPro3.Product_Line__c='ProductLine';
            newPro3.Sub_Product_Line__c='SubProductLine';
            newPro3.Product_Level__c=2 ;
            newPro3.Business_Group__c='ES';
            newPro3.GBU__c='Application Services';
            newPro3.IsActive=true;
            update newPro3;
            Product2 newPro2=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
            insert newPro2;
            newPro2.Product_Line__c='ProductLine';
            newPro2.Sub_Product_Line__c='SubProductLine';
            newPro2.Product_Level__c=2 ;
            newPro2.Business_Group__c='ES';
            newPro2.GBU__c='Application Services';
            newPro2.IsActive=true;
            update newPro2;
            Pricebook2 newprb2 = TestingSetupDataUtil.createPriceBook('Test Pricebook2',true);
            insert newprb2;
       
           
            
             listPrbEntry1 = new List<PricebookEntry>();
            PricebookEntry newEntry1=TestingSetupDataUtil.createPricebookEntry(newPro3.Id,true,prb1.Id,1000,'USD');
            PricebookEntry newEntry2=TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,prb1.Id,1000,'USD');        
            listPrbEntry1.add(newEntry1);
            listPrbEntry1.add(newEntry2);            
            insert listPrbEntry1;

           
            
            newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOppty567', system.today()+ 30);
            insert newOpp;  
       

            /*Insert two Opportunity Line Items*/
            newOppLineItem11 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry1[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);            
            
       OpportunityLineItem     newOppLineItem12 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry1[1].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
           listOpptyProduct1.add(newOppLineItem11);
            listOpptyProduct1.add(newOppLineItem12);
            insert listOpptyProduct1; 
        
        
         Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Approval__c') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Id rcdType1= RecordTypeInfo.get('Opportunity Review').getRecordTypeId();
        Approval__c approval1=new Approval__c();
        approval1.opportunity__c=newOpp.id;
        approval1.RecordTypeID=rcdType1;
        insert approval1;
        
        DGPreRoutingLogic d = new DGPreRoutingLogic();
        string Opptyid = newOpp.id;
        d.ProductPriorityRouting(newOpp.id,Approval1.id);
        }
        
    }
    
    public Static testMethod  void setupDataTS(){
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
        /*Insert Account and Opportunity*/
       
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('Aut1','Approvalfunst1@hp.com','ApprovalfTest2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','ApprovalfuncTest3@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='TS';
        insert user1;
        system.runas(user1){
        
          Account newAcc=TestingSetupDataUtil.createAccount('ApprovalTestAccount','ApprovalfuncTest1@hp.com','Customer');
             newAcc.World_Region1__c=wr.id;
             insert newAcc;
        
      Pricebook2 prb1 = [select id from Pricebook2 where IsStandard = true];
            Product2 newPro3=TestingSetupDataUtil.createProduct(true ,'testProduct3','USD',null);
            insert newPro3;
            newPro3.Product_Line__c='4J - Education Services';
            newPro3.Sub_Product_Line__c='1Z - Strategic IT Advisory Services';
            newPro3.Product_Level__c=2 ;
            newPro3.Business_Group__c='EG';
            newPro3.GBU__c='Technology Consulting';
            newPro3.IsActive=true;
            update newPro3;
            Product2 newPro2=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
            insert newPro2;
            newPro2.Product_Line__c='4J - Education Services';
            newPro2.Sub_Product_Line__c='1Z - Strategic IT Advisory Services';
            newPro2.Product_Level__c=2 ;
            newPro2.Business_Group__c='EG';
            newPro2.GBU__c='Technology Consulting';
            newPro2.IsActive=true;
            update newPro2;
            Pricebook2 newprb2 = TestingSetupDataUtil.createPriceBook('Test Pricebook2',true);
            insert newprb2;
             listPrbEntry1 = new List<PricebookEntry>();
            PricebookEntry newEntry1=TestingSetupDataUtil.createPricebookEntry(newPro3.Id,true,prb1.Id,1000,'USD');
            PricebookEntry newEntry2=TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,prb1.Id,1000,'USD');        
            listPrbEntry1.add(newEntry1);
            listPrbEntry1.add(newEntry2);            
            insert listPrbEntry1;
            newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOppty567', system.today()+ 30);
            insert newOpp; 
            /*Insert two Opportunity Line Items*/
            newOppLineItem11 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry1[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);            
            
       OpportunityLineItem     newOppLineItem12 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry1[1].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
           listOpptyProduct1.add(newOppLineItem11);
            listOpptyProduct1.add(newOppLineItem12);
            insert listOpptyProduct1; 
        
        
         Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Approval__c') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Id rcdType1= RecordTypeInfo.get('Opportunity Review').getRecordTypeId();
        Approval__c approval1=new Approval__c();
        approval1.opportunity__c=newOpp.id;
        approval1.RecordTypeID=rcdType1;
        insert approval1;
        
        DGPreRoutingLogic d = new DGPreRoutingLogic();
        string Opptyid = newOpp.id;
        d.ProductPriorityRouting(newOpp.id,Approval1.id);
        }
        
    }
     
     

}