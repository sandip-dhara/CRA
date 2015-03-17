/**********************************************************
* Class Name: UserAutomationTest
* Author: HP
* Date: 10-Apr-2013
* Description: This class does the test coverage for userAutomation class. 
***********************************************************/
@isTest(seeAllData = True)
private class UserAutomationTest {
    
    static User user1;
    static User user2;
    static User currentUser = [select Id from user where Id =: UserInfo.getUserId()];
    static Contact con;
    static Contact con1;
    static Location_Partner_Users__c locPartuser1, locPartuser2;
    private static void setupData() {    
    Account account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Partner');
        insert account ;
   Account account1 = TestingSetupDataUtil.createAccount('testAccount2', 'accountEmail2@email.com','Partner');
        insert account1 ;
   Account account2 = TestingSetupDataUtil.createAccount('testAccount3', 'accountEmail23@email.com','Partner');
        insert account2 ;
    con = new Contact(AccountId = account.id, LastName = 'abc', Email = 'test@hp.com', Phone__c = '123456789');
        insert con;
    UserLicense usr =[Select id from UserLicense where name='Gold Partner'];
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' and UserLicenseId=:usr.Id ];
    user1 = new User(alias = 'test1', email='test@hp.com', Email_Address__c='test@hp.com', emailencodingkey='UTF-8', lastname='Tertlan1',
                     languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles', username='userTest@SclassTest.com',
                     EmployeeNumber = '55235615', Legacy_Employee_Ref__c = '55235615', ProfileId = portalProfile.Id, ContactId= con.Id, IsActive = true,Adoption_Role_Type__c='Account Executive');
    insert user1;   
    user1.isPortalEnabled = true;
    user1.IsActive = true;
    System.runAs (currentUser){
            update user1;
    }
        List<Location__c> locList = new List<Location__c>();
        for(Integer i=0;i<5;i++){
            Location__c loc  = new Location__c(Account__c=account.id, Name = 'testLocation'+ i, Location_Name__c = '12345'+ i,Sell_Into_Market__c='TestMarkt' +i, EvaluateTerritory__c = false);
            locList.add(loc) ;
        }
        insert locList;
        //Test Opportunity Insertion
         
       Account account11 = TestingSetupDataUtil.createAccount('testAccount2', 'accountEmail2@email.com','Customer');
        insert account11 ;
       Opportunity opp = new Opportunity(AccountId = account11.id, Owner__c=user1.Id, StageName = '01 - Understand Customer', Name = 'Opty1', CloseDate = system.today()+1,CurrencyIsoCode='AUD');
       insert opp;

        //Test Alliance and Channel Partner Insertion
        Channel_Partner__c newalliance=new Channel_Partner__c(Channel_Partner__c=account.Id,Location__c=locList[0].Id,Partner_Type__c='Alliance Partner',Partner_Account_Role__c='Implementer',Opportunity__c=opp.Id);
        Insert newalliance;
        OpportunityTeamMember opportunityTeamMember = TestingSetupDataUtil.createOpportunityTeamMember(user1.Id,'testRole',opp.Id);
        insert opportunityTeamMember ;
        
        //Opportunity opp1 = new Opportunity(AccountId = account11.id, Owner__c=user2.Id, StageName = '01 - Understand Customer', Name = 'Opty2', CloseDate = system.today(),CurrencyIsoCode='AUD');
        //insert opp1;

        //Test Alliance and Channel Partner Insertion
        //Channel_Partner__c newalliance1=new Channel_Partner__c(Channel_Partner__c=account.Id,Location__c=locList[0].Id,Partner_Type__c='Channel Partner',Partner_Account_Role__c='Implementer',Opportunity__c=opp1.Id);
        //Insert newalliance1;
      
        locPartuser1 = new Location_Partner_Users__c(Contact__c= con.Id,Location__c=locList[0].Id, Userkey__c='97896',Territory_Partner_Admin_Role__c='Leads Administrator');
        insert locPartuser1;
        locPartuser1.Territory_Partner_Admin_Role__c='Deal Administrator';
        System.runAs (currentUser){
            update locPartuser1;
        }
        locPartuser1.Territory_Partner_Admin_Role__c='';
        System.runAs (currentUser){
            update locPartuser1;
        }
    }
    static testMethod void UserAutomationTest() { 
        setupData();
        Test.startTest();
        locPartuser1.Territory_Partner_Admin_Role__c='Lead Administrator';
        System.runAs (currentUser){
            update locPartuser1;
        }
        user1.IsActive = true;
         System.runAs (currentUser){
            Update user1;
        }
        user1.IsActive = false;
         System.runAs (currentUser){
            Update user1;
        }
        
        delete locPartuser1;    
        Test.stopTest();
    }
}