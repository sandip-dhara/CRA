/**********************************************************
* Class Name: LeadCollabACPUtilTest1
* Author: pravee
* Date:  
* Description:  
***********************************************************/
@isTest(seeAllData=true)

public class LeadCollabACPUtilTest {
    private static Account acc;
    private static List<Pricebook2> price;
    private static Product2 prod;
    private static PricebookEntry priceEntry;
    private static Product_Interest__c productInterest;
    private static Sales_Territory__c salesTerr;
    private static List<Sales_Territory_User_Assignment__c> salesTerrUsers;
    private static Sales_Territory_Account_Assignment__c salesTerrAcc;
    private static Product_Specialty_Definition__c prodSpcltyDef;
    private static List<User> users;
    private static Profile prof;
    private static List<Lead> newLeads;
    private static Account partAcc1 = new Account();
    private static Contact partContact1 = new Contact();
    private static User partUser1 = new User();
    private static Contact partContact2 = new Contact();
    private static User partUser2 = new User();
    private static user user;
    
    private static Location__c loc;
    private static Sales_Territory_Location_Assignment__c salesTerrLoc;
    private static Sales_Territory__c PartnersalesTerr;
    private static List<Sales_Territory_User_Assignment__c> PsalesTerrUsers;
  //  private static Map<id,Location__c> acpNewMap=new Map<id,Location__c>();
  //  private static Map<Id,List<String>> leadWithTerritoryGroups = new Map<id,List<String>>();
  //  private static List<Lead> leadslist =new List<Lead>();
  //  private static List<LeadShare> newLeadSharing = new List<LeadShare>();
    
    /*
     * Method for creating test data.
     */
     
    private static void setUpData(){
        system.debug('Enter setUpData()');
        //Create a test account
        acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@hp.com','Customer');
        insert acc;
                
        RecordType rt=[select id,name from RecordType where name like '%Qualified%' limit 1];
        //Insert Lead
        newLeads = new List<Lead>();       
        Lead newLead = TestingSetupDataUtil.createLead('TestLead1', 'qqq123', 'Qualified', 'New', '123', 'test1@test.com');
        newLead.Account_Name__c = acc.Id;
        newLead.Budget__c = '121' ;
        newLead.Authorized_Buyer__c = 'No';
        newLead.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead.Estimated_Budget__c = 123.0;
        newLead.recordtypeid=rt.id;
        
        insert newLead;
        
        
        newLeads.add(newLead);
        
       
        
        // create a test Product2
        prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'ESSN';
        prod.GBU__c = 'Technology Support';
        prod.Product_Line__c = 'Technology Support PL';
        prod.Sub_Product_Line__c = 'Technology Support Sub-PL';
        insert prod;
        
         // create a test pricebook2
         price=new List<Pricebook2>();
        price = [select id, name, isActive from Pricebook2  where isstandard=true limit 1];
        
        // create a test Product2
        priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price[0].Id,100,'USD');
        insert priceEntry;
        
        // create a test Lead products item
        productInterest = TestingSetupDataUtil.createProductInterest(newLead.Id, prod.Id);
        insert productInterest;
        
               
        //create a test sales territroy record.
        salesTerr = new Sales_Territory__c(Name = 'testSalesTerritory', IsActive__c = true,MyComp_Sales_Territory_Name__c ='ABC');
        insert salesTerr;
        
          /* Inserting User
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        user = new User();
        user = TestingSetupDataUtil.createUser('st'+randomstr.substring(0,4), randomstr+'standarduser@hp.com', randomstr+'standarduser@hp.com', 
                                                'UTF-8', 'U LastName', 'en_US', 'en_US', 'America/Los_Angeles', randomstr+'standarduser12@hp.com', 
                                                randomstr+'5', Userinfo.getProfileId());                 
        insert user; */
                
        
        //Create test User
        users = new List<User>();
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('stTest1','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
        user1.Lead_Eligibility_Flag__c = true;
        user1.Global_Business_Unit__c = 'test';
        user1.Partner_Collaboration_Participating_User__c=true;
        
        
        
        //Create test User2
        User user2 = new User();
        user2 = TestingSetupDataUtil.createUser('stTest','abc2@hp.com','email12@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest2@hp.com','234567890',Userinfo.getProfileId());
        user2.Lead_Eligibility_Flag__c = true;
        user2.Global_Business_Unit__c = 'test';
        
       
        users.add(user1);
        users.add(user2);   
        
        insert users;
        
        //create user in sales terr
        salesTerrUsers = new List<Sales_Territory_User_Assignment__c>();
        Sales_Territory_User_Assignment__c salesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, User__c = users[0].Id);
        Sales_Territory_User_Assignment__c salesTerrUser1 = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, User__c = users[1].Id);
        salesTerrUsers.add(salesTerrUser);
        salesTerrUsers.add(salesTerrUser1);
        insert salesTerrUsers;
        
        // Create a account with record type - partner
        partAcc1 = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1@partnercollab.com','Partner');
        partAcc1.Partner_Portal_Eligible__c = true;
        insert partAcc1;
        
        system.assertEquals(partAcc1.Partner_Portal_Eligible__c,true);
        //Enable the account as partner
        partAcc1.IsPartner = true;
        partAcc1.Partner_Portal_Eligible__c = true;
        partAcc1.HP_Lead_Status__c='Active';
        update partAcc1;  
        
        // Create a contact under the partner account
        partContact1 = TestingSetupDataUtil.createContact(partAcc1.Id, 'Test Prtnr Contact11');
        partContact1.Email='testcontact11@testing.com';
        insert partContact1;
        
        //Create Location
        loc= new Location__c(Location_Name__c='TestLocation', Name='1234567', Account__c=partAcc1.Id);
        insert loc;
        
        // fetch the partner profiles
        List<Profile> partnerProfiles = new List<Profile>();
        partnerProfiles = [Select p.UserType, p.UserLicenseId, p.Name, p.Id From Profile p where p.UserType like '%Partner%' ];
        // Create a partner user
        partUser1 = TestingSetupDataUtil.createUser('pruser1','partnerUser1@hp.com','5_1_partnerUser1@hp.com','UTF-8','parTneruser1','en_US','en_US','America/Los_Angeles','partnerUser1@hp.com','55145615',partnerProfiles[0].Id );
        partUser1.ManagerId = userInfo.getUserId();
        partUser1.ContactId = partContact1.Id;
        partUser1.Strike_Count__c=2;
        partUser1.Location_Record_Id__c=loc.Id;
        insert partUser1;
        
        /* Create a contact under the partner account
        partContact2 = TestingSetupDataUtil.createContact(partAcc1.Id, 'Test Prtnr Contact12');
        partContact2.Email='testcontact12@testing.com';
        insert partContact2;
        
        partUser2 = TestingSetupDataUtil.createUser('pruser21','partnerUser21@hp.com','5_1_partnerUser21@hp.com','UTF-8','parTneruser21','en_US','en_US','America/Los_Angeles','partnerUser21@hp.com','55145676',partnerProfiles[0].Id );
        partUser2.ManagerId = userInfo.getUserId(); 
        partUser2.ContactId = partContact2.Id;
        partUser2.Strike_Count__c=1;
        
        insert partUser2;  */

        //create a Sales Territory Account record
        salesTerrAcc = new Sales_Territory_Account_Assignment__c(Account__c = partAcc1.Id, Sales_Territory__c = salesTerr.Id);
        insert salesTerrAcc;
        
        //Create Partner Territory
        
        PartnersalesTerr = new Sales_Territory__c(Name = 'testSalesTerritory', IsActive__c = true, IsPartner__c= true,MyComp_Sales_Territory_Name__c ='ABC');
        insert PartnersalesTerr;
        
        
       //Sales territory location assignment
       
       salesTerrLoc = new Sales_Territory_Location_Assignment__c(Location__c=loc.Id, Sales_Territory__c = PartnersalesTerr.Id);
       insert salesTerrLoc;
       
       // Sales territory User assignment
       
       PsalesTerrUsers = new List<Sales_Territory_User_Assignment__c>();
       Sales_Territory_User_Assignment__c PsalesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = PartnersalesTerr.Id, User__c = users[0].Id);
       Sales_Territory_User_Assignment__c PsalesTerrUser1 = new Sales_Territory_User_Assignment__c(Sales_Territory__c = PartnersalesTerr.Id, User__c = users[1].Id);
       PsalesTerrUsers.add(PsalesTerrUser);
       PsalesTerrUsers.add(PsalesTerrUser1);
       insert PsalesTerrUsers;
        
        
        
        
    }
    
    static testMethod void Test() {
        
        
        Test.startTest();
        setUpData();
        
        
     /*   PageReference pageRef = Page.LeadManualAssigment;
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.currentPage().getParameters().put('id',newLeads[0].Id);
        ApexPages.Standardsetcontroller sc1 = new ApexPages.Standardsetcontroller(newLeads);
        LeadAssignmentController leadAssign = new LeadAssignmentController(sc1);
        pageRef = leadAssign.assignLeads();
        pageRef = leadAssign.returnBack();
        
        */
        
        newLeads[0].ownerId=partUser1.id;
        newLeads[0].Partner_Owned__c=true;
        system.runAs(users[0]){
            update newLeads;
        }
       
        Test.stopTest();
        
    }
}