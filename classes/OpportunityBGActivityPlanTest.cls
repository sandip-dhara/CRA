@isTest(SeeAllData=True)
Public class OpportunityBGActivityPlanTest{

    private static List<Opportunity> opty = new List<Opportunity>();
    private static Pricebook2 price;
    private static Pricebook2 price2;
    private static Pricebook2 price02;
    private static Pricebook2 price03;
    private static Product2 prod;
    private static Product2 prod02;
    private static Product2 prod03;
    private static PricebookEntry priceEntry;
    private static PricebookEntry priceEntry02;
    private static PricebookEntry priceEntry03;
    private static OpportunityLineItem OppLineItem;
    private static OpportunityLineItem OppLineItem02;
    private static OpportunityLineItem OppLineItem03;
    private static Profile SRProfile = [select Name, Id from Profile where Name ='IT Administrator'];  
    public static User SRuseroptyowner;
    private static Opportunity opty01; 
       
    public static void usercreation(){
      SRuseroptyowner = new User(Lastname = 'TestUseroptyowner', Firstname= 'BG', Username = 'testingoptyowner0128@hp.com', Alias='TesBG', CommunityNickname='TestUseroptyownerBG', Email='test0128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyowner0128@hp.com',EmployeeNumber='.',Legacy_Employee_Ref__c='65348261', ProfileId = SRProfile.id,Business_Group__c = 'ES', Region__c = 'AMS');
      SRuseroptyowner.Adoption_Role_Type__c='Account Executive';
      Insert SRuseroptyowner; 

   }     
   public static Opportunity setupData() {
        //SRProfile = [select Name, Id from Profile where Name ='Sales Rep'];  
        
        Account acc = TestingSetupDataUtil.createAccount('testPrivateAccount', 'testAccount_9@hp.com','Customer');
        acc.ShippingCountry = 'United States';
        insert acc;
        //create a test opportunity
        opty01 = TestingSetupDataUtil.createOpportunity(acc.Id,'BGWFOpty',System.Today()+30);
        opty01.OwnerId= SRuseroptyowner.Id;  
        opty01.Deal_Action_Plan_Type__c = 'Converged Cloud';
        insert opty01;
        
        // create a test pricebook2
       
        price = [select id, name, isActive from Pricebook2 where isStandard=True];
        
        // create a test Product2
        prod=new Product2(Name='abc',isActive = True,Business_Group__c='ES',GBU__c = 'Application Services',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
        insert prod;
        
        Activity_Plan__c activityTemplate = new Activity_Plan__c();
        activityTemplate.Name = 'ES - AMS - IS/BPO - <$10M';
        activityTemplate.Business_Group__c = 'ES';
        activityTemplate.GBU__c = 'BPO';
        activityTemplate.Automated__c = True;
        activityTemplate.Region__c = 'Americas';
        activityTemplate.TOV_Range_From__c = 0;
        activityTemplate.TOV_Range_To__c = 1000000;
        insert activityTemplate;
        
        Activity_Plan_Item__c templateItems11 = new Activity_Plan_Item__c();
        templateItems11.Activity_Subject__c = '01.03 Identify Opportunity';
        templateItems11.Activity_Plan__c = activityTemplate.Id;
        templateItems11.Activity_Type__c = 'Activity';
        templateItems11.Sales_Stage__c = '01 - Understand Customer';
        templateItems11.Type__c = 'Activity';
        insert templateItems11;
        
        Activity_Plan_Item__c templateItems12 = new Activity_Plan_Item__c();
        templateItems12.Activity_Subject__c = '01.04 Identify Opportunity';
        templateItems12.Activity_Plan__c = activityTemplate.Id;
        templateItems12.Activity_Type__c = 'Activity';
        templateItems12.Sales_Stage__c = '03 - Qualify the Opportunity';
        templateItems12.Type__c = 'Activity';
        insert templateItems12;
        
        Activity_Plan__c activityTemplate2 = new Activity_Plan__c();
        activityTemplate2.Name = 'ES - AMS - APPS - <$10M';
        activityTemplate2.Business_Group__c = 'ES';
        activityTemplate2.GBU__c = 'Application Services';
        activityTemplate2.Automated__c = True;
        activityTemplate2.Region__c = 'Americas';
        activityTemplate2.TOV_Range_From__c = 0;
        activityTemplate2.TOV_Range_To__c = 1000000;
        insert activityTemplate2;
        
         Activity_Plan_Item__c templateItems21 = new Activity_Plan_Item__c();
        templateItems21.Activity_Subject__c = '01.03 Identify Opportunity';
        templateItems21.Activity_Plan__c = activityTemplate2.Id;
        templateItems21.Activity_Type__c = 'Activity';
        templateItems21.Sales_Stage__c = '01 - Understand Customer';
        templateItems21.Type__c = 'Activity';
        insert templateItems21;
        
        Activity_Plan_Item__c templateItems22 = new Activity_Plan_Item__c();
        templateItems22.Activity_Subject__c = '01.04 Identify Opportunity';
        templateItems22.Activity_Plan__c = activityTemplate2.Id;
        templateItems22.Activity_Type__c = 'Activity';
        templateItems22.Sales_Stage__c = '03 - Qualify the Opportunity';
        templateItems22.Type__c = 'Activity';
        insert templateItems22;
        
        Activity_Plan__c activityTemplate3 = new Activity_Plan__c();
        activityTemplate3.Name = 'ES - AMS - ITO - <$10M';
        activityTemplate3.Business_Group__c = 'ES';
        activityTemplate3.GBU__c = 'ITO';
        activityTemplate3.Automated__c = True;
        activityTemplate3.Region__c = 'Americas';
        activityTemplate3.TOV_Range_From__c = 0;
        activityTemplate3.TOV_Range_To__c = 1000000;
        insert activityTemplate3;
        
        Activity_Plan_Item__c templateItems31 = new Activity_Plan_Item__c();
        templateItems31.Activity_Subject__c = '01.03 Identify Opportunity';
        templateItems31.Activity_Plan__c = activityTemplate3.Id;
        templateItems31.Activity_Type__c = 'Activity';
        templateItems31.Sales_Stage__c = '01 - Understand Customer';
        templateItems31.Type__c = 'Activity';
        insert templateItems31;
        
        Activity_Plan_Item__c templateItems32 = new Activity_Plan_Item__c();
        templateItems32.Activity_Subject__c = '01.04 Identify Opportunity';
        templateItems32.Activity_Plan__c = activityTemplate3.Id;
        templateItems32.Activity_Type__c = 'Activity';
        templateItems32.Sales_Stage__c = '03 - Qualify the Opportunity';
        templateItems32.Type__c = 'Activity';
        insert templateItems32;
        
        // create a test Product2
        
        priceEntry=TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        priceEntry.UseStandardPrice=true;
        insert priceEntry;
        
        
        
        // create a test Opportunity line item
        OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty01.id,priceEntry.id,System.Today()+40);
        insert OppLineItem;   
        
         
        opty.add(opty01);
        return opty01;
        
}
      public static Opportunity setupData1() {
      
      // create a second test pricebook2
        price2 = [select id, name, isActive from Pricebook2 where isStandard=True];
        
        // create a test Product2
        //prod02 = TestingSetupDataUtil.createProduct(true ,'abcd','USD','1234');
        prod02=new Product2(Name='abc1',isActive = True,Business_Group__c='ES',GBU__c = 'ITO',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
        insert prod02;
        
        
        // create a test Product2
        priceEntry02 = TestingSetupDataUtil.createPricebookEntry(prod02.Id,true,price2.Id,100,'USD');
        priceEntry02.UseStandardPrice=false;
        insert priceEntry02;
        
        // create a test Opportunity line item
        OppLineItem02 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty01.id,priceEntry02.id,System.Today()+40);
        
        insert OppLineItem02;  

        return opty01;
      
      
      }
      
      public static Opportunity setupDataTS() {
      
      SRuseroptyowner.Business_Group__c = 'TS';
        update SRuseroptyowner;
      
      Activity_Plan__c activityTemplateTS = new Activity_Plan__c();
        activityTemplateTS.Name = 'TS Templates';
        activityTemplateTS.Business_Group__c = 'TS';
        activityTemplateTS.Param01__c = 'Converged Cloud';
        activityTemplateTS.Automated__c = True;
        insert activityTemplateTS;
        
        Activity_Plan_Item__c templateItemsTS = new Activity_Plan_Item__c();
        templateItemsTS.Activity_Subject__c = 'If the account owner is CSE - engage CP or the country cloud lead';
        templateItemsTS.Activity_Plan__c = activityTemplateTS.Id;
        templateItemsTS.Activity_Type__c = 'Activity';
        templateItemsTS.Sales_Stage__c = '01 - Understand Customer';
        templateItemsTS.Type__c = 'Activity';
        insert templateItemsTS;
        
        Activity_Plan_Item__c templateItems32 = new Activity_Plan_Item__c();
        templateItems32.Activity_Subject__c = 'Identify key stakeholders & understand customer requirements - where are they in cloud maturity';
        templateItems32.Activity_Plan__c = activityTemplateTS.Id;
        templateItems32.Activity_Type__c = 'Activity';
        templateItems32.Sales_Stage__c = '03 - Qualify the Opportunity';
        templateItems32.Type__c = 'Activity';
        insert templateItems32;
        
        
        price03 = [select id, name, isActive from Pricebook2 where isStandard=True];
        prod03=new Product2(Name='abc1',isActive = True,Business_Group__c='TS',GBU__c = 'Technology Services',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
        insert prod03;
          
       // create a test Product2
        priceEntry03 = TestingSetupDataUtil.createPricebookEntry(prod03.Id,true,price03.Id,100,'USD');
        insert priceEntry03;
        
        // create a test Opportunity line item
        OppLineItem03 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty01.id,priceEntry03.id,System.Today()+40);
        
        insert OppLineItem03;  

        return opty01;
      
      }
      
      
      public static testMethod void positiveTest()
      {
       Test.startTest();
         //Profile SRProfile = [select Name, Id from Profile where Name ='Sales Rep'];  
        User SRuser1 = new User(Lastname = 'TestUser', Firstname= 'BG', Username = 'testing0128@test.com', Alias='TestBG', CommunityNickname='TestBG', Email='test0128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0128@hp.com',EmployeeNumber='6534826',Legacy_Employee_Ref__c='6534826', ProfileId = SRProfile.id,Business_Group__c = 'TS', Region__c = 'AMS');
        //insert SRuser1;
         // User SRuser2 = new User(Lastname = 'TestUser2', Firstname= 'BG', Username = 'testing020128@test.com', Alias='TestBG', CommunityNickname='TestBG', Email='test020128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test020128@hp.com',EmployeeNumber='65348216',Legacy_Employee_Ref__c='65348216', ProfileId = SRProfile.id,Business_Group__c = 'TS', Region__c = 'AMS');
       usercreation();
       System.runAs(SRuseroptyowner){
       setupData();
       OpportunityBGActivityPlan.CreateActivityForOptyUpdation(opty,0);
       setupData1();
       OpportunityBGActivityPlan.CreateActivityForOptyUpdation(opty,0);
       setupDataTS();
       OpportunityBGActivityPlan.CreateActivityForOptyUpdation(opty,0);
      }
       
      Test.stopTest();
      
      }
      
      public static testMethod void positiveTest2()
      {
        Account acc = TestingSetupDataUtil.createAccount('testPrivateAccount', 'testAccount_10@hp.com','Customer');
        acc.ShippingCountry = 'United States';
        insert acc;
        //create a test opportunity
        Opportunity opp = TestingSetupDataUtil.createOpportunity(acc.Id,'BGWFOpty',System.Today()+30);
        opp.No_Competitor__c = true;
        insert opp;         
        price02 = [select id, name, isActive from Pricebook2 where IsStandard = true];
        
        // create a test Product2
        Product2 prod04 = TestingSetupDataUtil.createProduct(true ,'abcd','USD','1234');
        prod04.Business_Group__c = 'ES';
        prod04.GBU__c = 'ITO';
        prod04.Product_Line__c = 'Technology Support PL';
        prod04.Sub_Product_Line__c = 'Technology Support Sub-PL';
        insert prod04;
        
        // create a test Product2
        PriceBookEntry priceEntry04 = TestingSetupDataUtil.createPricebookEntry(prod04.Id,true,price02.Id,100,'USD');
        insert priceEntry04;
        
        // create a test Opportunity line item
        OpportunityLineItem OppLineItem04 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opp.id,priceEntry04.id,System.Today()+40);
        
        insert OppLineItem04;  
        
        List<Activity_Plan__c> activityPlanList = new List<Activity_Plan__c>();
        Activity_Plan__c activityTemplate1 = new Activity_Plan__c();
        activityTemplate1.Name = 'ELA Activity Template';
        activityTemplate1.Record_Type__c = 'Renewal';
        activityTemplate1.Renewal_Type__c = 'SW Renewal';
        activityTemplate1.Renewal_Sub_Type__c = 'ELA';
        activityPlanList.add(activityTemplate1);
        
        Activity_Plan__c activityTemplate2 = new Activity_Plan__c();
        activityTemplate2.Name = 'Push To Activity Template';
        activityTemplate2.Record_Type__c = 'Renewal';
        activityTemplate2.Renewal_Type__c = 'SW Renewal';
        activityTemplate2.Renewal_Sub_Type__c = 'Push To';
        activityPlanList.add(activityTemplate2);
        
        Activity_Plan__c activityTemplate3 = new Activity_Plan__c();
        activityTemplate3.Name = 'Multinational Activity Template';
        activityTemplate3.Record_Type__c = 'Renewal';
        activityTemplate3.Renewal_Type__c = 'TS Renewal';
        activityTemplate3.Renewal_Sub_Type__c = 'Multinational';
        activityPlanList.add(activityTemplate3);
        
        Activity_Plan__c activityTemplate4 = new Activity_Plan__c();
        activityTemplate4.Name = 'PROP Activity Template';
        activityTemplate4.Record_Type__c = 'Renewal';
        activityTemplate4.Renewal_Type__c = 'TS Renewal';
        activityTemplate4.Renewal_Sub_Type__c = 'PROP';
        activityPlanList.add(activityTemplate4);
        
        Activity_Plan__c activityTemplate5 = new Activity_Plan__c();
        activityTemplate5.Name = 'Multi BG Activity Template';
        activityTemplate5.Record_Type__c = 'Renewal';
        activityTemplate5.Renewal_Type__c = 'TS Renewal';
        activityTemplate5.Renewal_Sub_Type__c = 'Multi BG';
        activityPlanList.add(activityTemplate5);
        
        insert activityPlanList;
        
        List<Activity_Plan_Item__c> activityPlanItemList = new List<Activity_Plan_Item__c>();
        Activity_Plan_Item__c templateItems1 = new Activity_Plan_Item__c();
        templateItems1.Activity_Subject__c = 'ELA: Review Stated pricing';
        templateItems1.Activity_Plan__c = activityPlanList[0].Id;
        templateItems1.Sales_Stage__c = '04A - Develop Solution';
        templateItems1.Type__c = 'Activity';
        activityPlanItemList.add(templateItems1);
        
        Activity_Plan_Item__c templateItems2 = new Activity_Plan_Item__c();
        templateItems2.Activity_Subject__c = 'Push To: Submit "Push To approval" form';
        templateItems2.Activity_Plan__c = activityPlanList[1].Id;
        templateItems2.Sales_Stage__c = '04A - Develop Solution';
        templateItems2.Type__c = 'Activity';
        activityPlanItemList.add(templateItems2);
        
        Activity_Plan_Item__c templateItems3 = new Activity_Plan_Item__c();
        templateItems3.Activity_Subject__c = 'Multinational: Global invoicing & Centrally Negotiated: Submit LCPA form';
        templateItems3.Activity_Plan__c = activityPlanList[2].Id;
        templateItems3.Sales_Stage__c = '04B - Propose Solution';
        templateItems3.Type__c = 'Activity';
        activityPlanItemList.add(templateItems3);
        
        Activity_Plan_Item__c templateItems4 = new Activity_Plan_Item__c();
        templateItems4.Activity_Subject__c = 'PROP: Hold Account Renewal Planning Meeting';
        templateItems4.Activity_Plan__c = activityPlanList[3].Id;
        templateItems4.Sales_Stage__c = '04B - Propose Solution';
        templateItems4.Type__c = 'Activity';
        activityPlanItemList.add(templateItems4);
        
        Activity_Plan_Item__c templateItems5 = new Activity_Plan_Item__c();
        templateItems5.Activity_Subject__c = 'Multi BG: Obtain the VSOE approval';
        templateItems5.Activity_Plan__c = activityPlanList[4].Id;
        templateItems5.Sales_Stage__c = '04B - Propose Solution';
        templateItems5.Type__c = 'Activity';
        activityPlanItemList.add(templateItems5);
        
        insert activityPlanItemList;
        
       Test.startTest();
        opp.Type = 'Renewal';
        opp.customer_engagement__c = 'End User Sales';
        opp.Renewal_Type__c = 'SW Renewal';
        opp.SW_ELA__c = True;
        opp.SW_Push_To__c = True;
        opp.StageName = '04A - Develop Solution';
        opp.Route_To_Market__c = 'Direct';
        opp.Fulfillment__c = 'HP Fulfilled';
        update opp;
        
        opp.Renewal_Type__c = 'TS Renewal';
        opp.TS_PROP__c=True;
        opp.TS_Multi_BG__c=True;
        opp.Renewal_Sub_Type__c='Complex';
        opp.TS_Multinational__c=True;
        opp.StageName='04B - Propose Solution';
        update opp;
       
      Test.stopTest();
      } 
}