/**********************************************************
* Class Name: OpportunityTriggerUtilTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage for OpportunityTriggerUtil class.
***********************************************************/
@isTest(SeeAllData=true)
private class OpportunityTriggerUtilTest{
    static Opportunity opty;
    private static Opportunity oppty;
    static List<PricebookEntry> listPrbEntry;
    static List<OpportunityLineItem> listOpptyProduct;
    static String errorMessage;
    static Account partAcc1 = new Account();
    static Contact partContact1 = new Contact();
    static User partUser1 = new User();
    static Product2 newPro2=new Product2();
    static Product2 newPro1=new Product2();
    static User user1;
    private static Pricebook2 prb;
    private static void setupData() {
        
        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('OpportunityTriggerUtilAccount','accountEmail22@hp.com','Customer');
        insert acc;
        
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
               Schema.SObjectType s = m.get('Opportunity') ;
               Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
               Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
               Id rcdType= RecordTypeInfo.get('Standard').getRecordTypeId();
               
        //RecordType rcdType= [Select Id from RecordType where name='Standard'];
        //create a test opportunity
        opty=TestingSetupDataUtil.createOpportunity(acc.Id,'OpportunityTriggerUtilTest1', system.today()+ 30);  
        opty.CurrencyIsoCode = 'USD';
        opty.StageName = Label.Understand_Customer ;
        opty.Win_Loss_Reason__c = 'HP Reputation';
        opty.Route_To_Market__c = 'Direct';
        insert opty;
        opty.StageName ='Error';
        opty.Managed_By__c='Hp';
        opty.Win_Loss_Reason__c = 'Duplicate';
        opty.RecordTypeId=rcdType;
        try{
        update opty;
        }Catch(Exception ex){}
        
        listPrbEntry = new List<PricebookEntry>();
        //listOpptyProduct = new List<OpportunityLineItem>(); 
        
        /*To fetch the Id of standard pricebook*/
        prb = [select id from Pricebook2 where IsStandard = true limit 1];
       
        /*Inserting Products*/
        List<Product2> listProduct2 = new List<Product2>();
        newPro1 = TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null );
        newPro1.Business_Group__c= 'ESSN';
        
        listProduct2.add(newPro1);
         newPro2 =TestingSetupDataUtil.createProduct(true ,'testProduct22','USD',null );
        newPro2.Business_Group__c= 'IPG';
        listProduct2.add(newPro2);
        insert listProduct2;
        
        /*Inserting Pricebook*/
       /* Pricebook2 newBook = TestingSetupDataUtil.createPriceBook('Test Pricebook',true);
        insert newBook;*/
        
        /*Inserting Pricebook Entries*/
        
        PricebookEntry newEntry1 = TestingSetupDataUtil.createPricebookEntry(newPro1.Id,true,prb.Id,100,'USD');
        insert newEntry1;
        //listPrbEntry.add(newEntry1);  
        PricebookEntry newEntry2 = TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,prb.Id,101,'USD');
        insert newEntry2;
        //listPrbEntry.add(newEntry2);  
        /*PricebookEntry newEntry3 = TestingSetupDataUtil.createPricebookEntry(newPro1.Id,true,newBook .Id,1010,'USD');
        listPrbEntry.add(newEntry3);
        PricebookEntry newEntry4 = TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,newBook .Id,1000,'USD');
        listPrbEntry.add(newEntry4);  */
        //insert listPrbEntry;
        
       // opty.pricebook2id= newBook .Id;
        try{
        update opty;}Catch(Exception ex){}
        

        /*Insert two Opportunity Line Items with Different Business Groups*/
        List<OpportunityLineItem> listOpportunityLineItem = new List<OpportunityLineItem>();
        OpportunityLineItem newOppLineItem1 = TestingSetupDataUtil.createOpportunityLineItem(null,11,10,opty.Id,newEntry1.Id,system.today()+ 25);
        listOpportunityLineItem.add(newOppLineItem1);
        
        OpportunityLineItem newOppLineItem2 =  TestingSetupDataUtil.createOpportunityLineItem(null,11,10,opty.Id,newEntry2.Id,system.today()+ 25);   
        listOpportunityLineItem.add(newOppLineItem2);
        insert listOpportunityLineItem;
        
        update listOpportunityLineItem;
        
       // Create a account with record type - partner
        partAcc1 = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1@hp.com','Partner');
        partAcc1.Partner_Portal_Eligible__c = true;
        insert partAcc1;
        
        system.assertEquals(partAcc1.Partner_Portal_Eligible__c,true);
        //Enable the account as partner
        partAcc1.IsPartner = true;
        partAcc1.Partner_Portal_Eligible__c = true;
        update partAcc1;  
        
        // Create a contact under the partner account
        partContact1 = TestingSetupDataUtil.createContact(partAcc1.Id, 'Test Prtnr Contact11');
        partContact1.Email='testcontact11@hp.com';
        insert partContact1;
        
        // fetch the partner profiles
        
         //UserRole testRole=[SELECT id from UserRole where portalrole =null  limit 1];
        List<Profile> partnerProfiles = new List<Profile>();
        partnerProfiles = [Select p.UserType, p.UserLicenseId, p.Name, p.Id From Profile p where p.UserType like '%Partner%' ];
        // Create a partner user
        partUser1 = TestingSetupDataUtil.createUser('pruser1','partnerUser1@hp.com','5_1_partnerUser1@hp.com','UTF-8','parTneruser1','en_US','en_US','America/Los_Angeles','partnerUser1@hp.com','55145615',partnerProfiles[0].Id );
        partUser1.ManagerId = userInfo.getUserId(); 
        partUser1.ContactId = partContact1.Id;
        insert partUser1;
        //partUser1.UserRoleId =testRole.id;
        //Update partUser1;
        
        
          List<Account> listAccount = new List<Account>();
          //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@hp.com','Customer');
        listAccount.add(account1);
        
        insert listAccount;
        
        //Create Opty
        oppty= TestingSetupDataUtil.createOpportunity(account1.Id,'testOppty1',System.today().addMonths(1));
        insert oppty;
        //oppty.pricebook2id= newBook.Id;
        try{
        update oppty;
        }catch(Exception e){}
        oppty.RecordTypeId=rcdType;
        System.assertEquals(oppty.Name,'testOppty1');
        
        /*Insert two Opportunity Line Items with Different Business Groups*/
        
        OpportunityLineItem newOppLineItem3 = TestingSetupDataUtil.createOpportunityLineItem(null,11,10,oppty.Id,newEntry2.Id,system.today()+ 25);
        insert newOppLineItem3;
        system.assertEquals(newOppLineItem3.OpportunityID,oppty.id);
        
        user1 = new User();
        user1 = TestingSetupDataUtil.createUser('stTest1','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
        user1.Lead_Eligibility_Flag__c = true;
        user1.Global_Business_Unit__c = 'test';
        user1.Partner_Collaboration_Participating_User__c=true;
        insert user1;
    }
    
   private static testMethod void opportunityTriggerInsertPositiveTest() {
   // Profile sysAdmin = [select id, name from profile where name = 'System Administrator'];
    //  User  usr = [Select id from User where ProfileID = : sysAdmin.Id limit 1];
    //     System.RunAs(usr){
       Test.startTest(); 
       
        setupData();
        OpportunityLineItemTriggerController.isProductInsert = false;
        //String OpptyID = OpportunityTriggerUtil.convertTo15Digit(opty.Id);
       // System.assertEquals(OpptyID.substring(0,15),opty.Id);
         try {
            opty.StageName = Label.Understand_Customer ;
            opty.CloseDate = System.Today()+45;
            update opty;
           
         } catch(Exception ex) {
         errorMessage = ex.getMessage();
         }            
         /* If errorMessage is not null, then test method will PASS */
         System.assertNotEquals('', errorMessage);
         
          try {
            opty.StageName = Label.Understand_Customer ;
           //opty.CloseDate = System.Today()+45;
           update opty;
           
         } catch(Exception ex) {
         errorMessage = ex.getMessage();
         }            
         /* If errorMessage is not null, then test method will PASS */
         System.assertNotEquals('', errorMessage);
         
          try {
            opty.StageName = Label.Develop_Solution ;       
           update opty;
           
           
         } catch(Exception ex) {
         errorMessage = ex.getMessage();
         }            
         /* If errorMessage is not null, then test method will PASS */
         System.assertNotEquals('', errorMessage);
         
          try {
           opty.StageName = Label.Qualify_Opportunity ;
           update opty;
           
         } catch(Exception ex) {
         errorMessage = ex.getMessage();
         }            
         /* If errorMessage is not null, then test method will PASS */
         System.assertNotEquals('', errorMessage);
         
         
          try {
           opty.StageName = Label.Propose_Solution;
           
           update opty;
           
         } catch(Exception ex) {
         errorMessage = ex.getMessage();
         }            
         /* If errorMessage is not null, then test method will PASS */
         System.assertNotEquals('', errorMessage);
         
         
          try {
           opty.StageName = Label.Negotiate_And_Close;
           update opty;
           
         } catch(Exception ex) {
         errorMessage = ex.getMessage();
         }            
         /* If errorMessage is not null, then test method will PASS */
         System.assertNotEquals('', errorMessage);
             system.runAs(user1){
             oppty.ownerid=partUser1.id;
             try{
             update oppty; 
             }catch(Exception e){}
              
             newPro2.product_line__c= 'Business Desktop';
             update newPro2;
             newPro1.product_line__c= 'Business Desktop';
             update newPro1;
             oppty.StageName = Label.Develop_Solution ;   
             oppty.amount=1000;  
             system.debug('productline is there? '+oppty.HasOpportunityLineItem);
             // update oppty;
        }
           
           
              
        Test.stopTest(); 
       // }  
    }    
}