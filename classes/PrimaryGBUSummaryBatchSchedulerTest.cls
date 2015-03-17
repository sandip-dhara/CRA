@isTest (seeAllData = true)
private class PrimaryGBUSummaryBatchSchedulerTest {
    private static Account acc;
    private static Opportunity opty;
    private static Pricebook2 price;
    private static Product2 objProduct;
    private static PricebookEntry priceEntry;
    private static OpportunityLineItem OppLineItem;
    private static Profile SRProfile = [select Name, Id from Profile where Name ='Sales Rep'];
    public static User SRuseroptyowner;
    
    public static void usercreation(){
      SRuseroptyowner = new User(Lastname = 'TestUseroptyowner', Firstname= 'BG', Username = 'testingoptyowner0128@hp.com', Alias='TesBG', CommunityNickname='TestUseroptyownerBG', Email='test0128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyowner0128@hp.com',EmployeeNumber='65348261',Legacy_Employee_Ref__c='65348261', ProfileId = SRProfile.id,Business_Group__c = 'ES', Region__c = 'AMS', Adoption_Role_Type__c = 'Account Executive');
        Insert SRuseroptyowner; 

   } 
    
    
    private static void setUpData(){
        system.debug('Enter setUpData()');
         //Create a test account
        acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
        //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        opty.Type = 'New Business';
        opty.Owner = SRuseroptyowner;
        opty.Route_To_Market__c = 'Direct';
        insert opty;
        
        // create a test pricebook2
       /* price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        
        // create a test Product2
        prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'ESSN';
        prod.GBU__c = 'Technology Support';
        prod.Product_Line__c = 'Technology Support PL';
        prod.Sub_Product_Line__c = 'Technology Support Sub-PL';
        insert prod;
        
        // create a test Product2
        priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        insert priceEntry; */
        //objProduct = [select Name,id from Product2 limit 1];
        Pricebook2 prb = [select id from Pricebook2 where IsStandard = true];
        objProduct=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
        insert objProduct;
        /*priceEntry= [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id =:objProduct.id and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='USD'  limit 1];
        if(!priceEntry.IsActive){
          priceEntry.IsActive = true;
          update priceEntry;
        }*/
         priceEntry=TestingSetupDataUtil.createPricebookEntry(objProduct.Id,true,prb.Id,100,'USD');   
         insert  priceEntry;
        // create a test Opportunity line item
        OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        insert OppLineItem;
        
        PrimaryGBUBatchConfig__c primarygbu=new PrimaryGBUBatchConfig__c(Name='PrimaryGBUtest',Batch_Size__c=200,Notification_Email_To__c='Test@abc.com');
        insert primarygbu;
    }
    
    static testMethod void myUnitTest() {
        
        test.startTest();
        usercreation();
         setUpData();
       System.runAs(SRuseroptyowner){
       
        //PrimaryGBUSummaryBatchScheduler Test
        PrimaryGBUSummaryBatchScheduler tm = new PrimaryGBUSummaryBatchScheduler();
        PrimaryGBUSummaryBatchScheduler.isTestrunscheduler=true;
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        
        String schExp = '0 '+min+' * * * ? ';
        Id schedulerid=system.schedule('TM Industry Test :', schExp, tm);
        //System.abortJob(schedulerid);                  
        test.stopTest();
      }
        
    }
}