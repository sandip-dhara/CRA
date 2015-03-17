/**********************************************************
* Class Name: PArtnerProbationNotificationTOPBMsTest
* Author: pravee
* Date:  
* Description:(seeAllData=true)
***********************************************************/
@isTest(seeAllData=true)
public class PArtnerProbationNotificationTOPBMsTest {
    private static Account acc;
    private static Location__c partLoc;
    private static Location__c partLocnew;
    private static Opportunity opty;
    private static List<Pricebook2> price;
    private static Product2 prod;
    private static PricebookEntry priceEntry;
    private static Product_Interest__c productInterest;
    private static Sales_Territory__c salesTerr;
    private static Sales_Territory__c salesTerr1;
    private static List<Sales_Territory_User_Assignment__c> salesTerrUsers;
    private static Sales_Territory_Account_Assignment__c salesTerrAcc;
    private static Sales_Territory_Account_Assignment__c salesTerrAcc1;
    private static Sales_Territory_Location_Assignment__c salesTerrLoc;
    private static Sales_Territory_Location_Assignment__c salesTerrLoc1;
    private static Sales_Territory_Location_Assignment__c salesTerrLoc2;
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
    private static User usertest;
    private static Sales_Territory_User_Assignment__c salesTerrUser;
    private static map<id, location__c> locationMap = new map<id, location__c>();
    Map<Id,List<Sales_Territory_User_Assignment__c>> accWithTerritoryGroupsUsers = new Map<id,List<Sales_Territory_User_Assignment__c>>();
    List<Messaging.SingleEmailMessage> mailList =new List<Messaging.SingleEmailMessage>();
    
    
    /*
     * Method for creating test data.
     */
    private static void setUpData(){
    
        system.debug('Enter setUpData()');
        //Create a test account
        acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
            
        Id rt=schema.sObjectType.lead.getRecordTypeInfosByName().get('Qualified Lead').getRecordTypeId();
        //Insert Lead
        newLeads = new List<Lead>();       
        Lead newLead = TestingSetupDataUtil.createLead('testClassLead', 'qqq123', 'Qualified', 'Accepted', '123', 'test1@test.com');
        newLead.Account_Name__c = acc.Id;
        newLead.Budget__c = '121' ;
        newLead.Authorized_Buyer__c = 'No';
        newLead.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead.Estimated_Budget__c = 123.0;
        newLead.recordtypeid=rt;
        
        insert newLead;
               
        newLeads.add(newLead);        
               
        //create a test sales territroy record.
        salesTerr = new Sales_Territory__c(Name = 'testSalesTerritory', MyComp_Sales_Territory_Name__c='salesTerr',IsActive__c = true,isExternal__c=true);
        salesTerr.IsPartner__c= true;
        insert salesTerr;
        
        
        salesTerr1 = new Sales_Territory__c(Name = 'testSalesTerritory1', MyComp_Sales_Territory_Name__c='salesTerr1',IsActive__c = true,isExternal__c=false);
        salesTerr1.IsPartner__c= true;
        insert salesTerr1;
        
         /* Inserting User */
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        user = new User();
        user = TestingSetupDataUtil.createUser('st'+randomstr.substring(0,4), randomstr+'standarduser@hp.com', randomstr+'standarduser@hp.com', 
                                                'UTF-8', 'U LastName', 'en_US', 'en_US', 'America/Los_Angeles', randomstr+'standarduser12@hp.com', 
                                                randomstr+'5', Userinfo.getProfileId());  
        user.Adoption_Role_Type__c='IT';
        insert user;
        //Create test User
        users = new List<User>();
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('stTest1','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
        user1.Lead_Eligibility_Flag__c = true;
        user1.Global_Business_Unit__c = 'test';
        user1.Adoption_Role_Type__c='Partner Business Manager (IC)';
        insert user1;
        
        //Create test User2
        User user2 = new User();
        user2 = TestingSetupDataUtil.createUser('stTest','abc2@hp.com','email12@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest2@hp.com','2345672',Userinfo.getProfileId());
        user2.Lead_Eligibility_Flag__c = true;
        user2.Global_Business_Unit__c = 'test';
        user2.Adoption_Role_Type__c='Partner Business Manager (IC)';
        insert user2;
        
        User user3 = new User();
        user3 = TestingSetupDataUtil.createUser('stTest1','abc3@hp.com','email67@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest122@hp.com','234586787',Userinfo.getProfileId());
        user2.Lead_Eligibility_Flag__c = true;
        user2.Global_Business_Unit__c = 'test';
        
        insert user3;
        users.add(user1);
        users.add(user2);
        users.add(user3);
        
        //create user in sales terr
        salesTerrUsers = new List<Sales_Territory_User_Assignment__c>();
        salesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, Account_Team_Role__c='Leads Administrator',User__c = users[0].Id);
        Sales_Territory_User_Assignment__c salesTerrUser1 = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, Add_to_Account_Team__c = false, User__c = users[1].Id);
        Sales_Territory_User_Assignment__c salesTerrUser2 = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr1.Id, Add_to_Account_Team__c = false, User__c = users[2].Id);
        
        salesTerrUsers.add(salesTerrUser);
        salesTerrUsers.add(salesTerrUser1);
        salesTerrUsers.add(salesTerrUser2);
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
        
        partLoc=new Location__c(Name='335865745',Account__c=partAcc1.Id, HP_Lead_Status__c='Active');
        Insert partLoc;
        
        partLocnew=new Location__c(Name='335865745123',Account__c=partAcc1.Id,HP_Lead_Status__c='Active');
        Insert partLocnew;
        
        // fetch the partner profiles
        List<Profile> partnerProfiles = new List<Profile>();
        partnerProfiles = [Select p.UserType, p.UserLicenseId, p.Name, p.Id From Profile p where p.UserType like '%Partner%' ];
        // Create a partner user
        partUser1 = TestingSetupDataUtil.createUser('pruser1','partnerUser1@hp.com','5_1_partnerUser1@hp.com','UTF-8','parTneruser1','en_US','en_US','America/Los_Angeles','partnerUser1@hp.com','55145615',partnerProfiles[0].Id );
        partUser1.ManagerId = userInfo.getUserId(); 
        partUser1.ContactId = partContact1.Id;
        partUser1.Strike_Count__c=4;
        partUser1.location_record_Id__c = partLoc.Id;
        insert partUser1;
               
        //create a Sales Territory Account record
        salesTerrAcc = new Sales_Territory_Account_Assignment__c(Account__c = partAcc1.Id, Sales_Territory__c = salesTerr.Id);
        insert salesTerrAcc;
        salesTerrAcc1 = new Sales_Territory_Account_Assignment__c(Account__c = partAcc1.Id, Sales_Territory__c = salesTerr1.Id);
        insert salesTerrAcc1;
        salesTerrLoc = new Sales_Territory_Location_Assignment__c(Location__c = partLoc.Id, Sales_Territory__c = salesTerr.Id);
        insert salesTerrLoc;
        salesTerrLoc1 = new Sales_Territory_Location_Assignment__c(Location__c = partLoc.Id, Sales_Territory__c = salesTerr1.Id);
        insert salesTerrLoc1;
        
        salesTerrLoc2 = new Sales_Territory_Location_Assignment__c(Sales_Territory__c = salesTerr1.Id, location__c =partLocnew.id);
        insert salesTerrLoc2;
        
        Sales_Territory_User_Assignment__c salesTerrUser4 = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, Add_to_Account_Team__c = false, User__c = partUser1.Id);
        insert salesTerrUser4;
        
        Sales_Territory_User_Assignment__c salesTerrUser6 = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr1.Id, Add_to_Account_Team__c = false, Account_Team_Role__c='Leads Administrator', User__c = partUser1.Id);
        insert salesTerrUser6;
        /*Sales_Territory_User_Assignment__c salesTerrUser7 = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr1.Id, Add_to_Account_Team__c = false, Account_Team_Role__c='Leads Administrator', User__c = partUser1.Id);
        insert salesTerrUser7;
        Sales_Territory_User_Assignment__c salesTerrUser8 = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr1.Id, Add_to_Account_Team__c = false, Account_Team_Role__c='Leads Administrator', User__c = partUser1.Id);
        insert salesTerrUser8;*/
        
        usertest = new User();
        usertest = TestingSetupDataUtil.createUser('stt','abctest@hp.com','email1test@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeesttest@hp.com','876543278',Userinfo.getProfileId());
        usertest.Lead_Eligibility_Flag__c = true;
        usertest.Global_Business_Unit__c = 'test';
        usertest.Partner_Collaboration_Participating_User__c=true;
        usertest.Adoption_Role_Type__c='IT';
        insert usertest;
        
        
    }
    
    static testMethod void Test() {
        //Test.startTest();
        setUpData();
        system.runAs(usertest){
        Test.startTest();
        PageReference pageRef = Page.LeadManualAssigment;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id',newLeads[0].Id);
        ApexPages.Standardsetcontroller sc1 = new ApexPages.Standardsetcontroller(newLeads);
        LeadAssignmentController leadAssign = new LeadAssignmentController(sc1);
        pageRef = leadAssign.assignLeads();
        pageRef = leadAssign.returnBack();       
        newLeads[0].ownerId=partUser1.id;
        newLeads[0].Partner_Owned__c=true;
        update newLeads;
        system.assertEquals(newLeads[0].Partner_Owned__c==true,true);
        system.assertEquals(newLeads[0].ConvertedOpportunityId__c==Null,true);
       // Test.startTest();
        PartnerProbationNotificationSchedule ppn=new PartnerProbationNotificationSchedule();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 0),60));
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('PartnerProbationNotification :'+datetime.now(), schExp, ppn); 
        Test.stopTest();
       }
        
    }
}