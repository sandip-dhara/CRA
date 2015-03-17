@isTest(SeeAllData=true)
public class SalesTeamLookupControllerTest{

    private static Opportunity opty;
    private static Opportunity opty1;
    private static Account partAcc1 = new Account();
    private static Account partAcc2 = new Account();
    private static Contact partContact1 = new Contact();
    private static Contact partContact2 = new Contact();
    private static Contact partContact3 = new Contact();
    private static Contact partContact4 = new Contact();
    private static User partUser1 = new User();
    private static User partUser2 = new User();
    private static User partUser3 = new User();
    private static User partUser4 = new User();
    private static List<User> usersList = new List<User>();
    private static OpportunityTeamMember oppMem = new OpportunityTeamMember();
    private static OpportunityTeamMember oppMem1 = new OpportunityTeamMember();
    private static OpportunityTeamMember oppMem2 = new OpportunityTeamMember();
    private static Account_Plan__c newAP;

    private  static void setupData(){
    
         List<Account> listAccount = new List<Account>();
          //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Customer');
        listAccount.add(account1);
        
        insert listAccount;
        
        //Create Opty
        opty = TestingSetupDataUtil.createOpportunity(account1.Id,'testOppty',System.today().addMonths(1));
        insert opty;
        System.assertEquals(opty.Name,'testOppty');
        
        opty1 = TestingSetupDataUtil.createOpportunity(account1.Id,'testOppty1',System.today().addMonths(1));
        insert opty1;
        
        // Create a account with record type - partner
        partAcc1 = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1@partnercollab.com','Partner');
        partAcc1.Partner_Portal_Eligible__c = true;
        insert partAcc1;
        
        system.assertEquals(partAcc1.Partner_Portal_Eligible__c,true);
        //Enable the account as partner
        partAcc1.IsPartner = true;
        partAcc1.Partner_Portal_Eligible__c = true;
        update partAcc1;  
        
        // Create a contact under the partner account
       List<Contact> conlist1 = new List<Contact>();
        partContact1 = TestingSetupDataUtil.createContact(partAcc1.Id, 'Test Prtnr Contact11');
        partContact1.Email='testcontact11@testing.com';
        //insert partContact1;
        conlist1.add(partContact1);
        
        // Create a contact under the partner account
        partContact2 = TestingSetupDataUtil.createContact(partAcc1.Id, 'Test Prtnr Contact12');
        partContact2.Email='testcontact12@testing.com';
        //insert partContact2;
        conlist1.add(partContact2);
        insert conlist1;
        
        // create a Location Record
        Location__c newLoc = new Location__c(Name = '12212121', Account__c = partAcc1.Id);
        insert newLoc;
        
        
        // fetch the partner profiles
        List<Profile> partnerProfiles = new List<Profile>();
        partnerProfiles = [Select p.UserType, p.UserLicenseId, p.Name, p.Id From Profile p where p.UserType like '%Partner%' ];
        // Create a partner user
        partUser1 = TestingSetupDataUtil.createUser('pruser1','partnerUser1@hp.com','5_1_partnerUser1@hp.com','UTF-8','parTneruser1','en_US','en_US','America/Los_Angeles','partnerUser1@testing.com','55145615',partnerProfiles[0].Id );
        partUser1.ManagerId = userInfo.getUserId(); 
        partUser1.ContactId = partContact1.Id;
        partUser1.Location_Record_Id__c = newLoc.Id;
        //insert partUser1;
        usersList.add(partUser1);
        
        //system.assertEquals(partUser1.Partner_account_ID__c!=null,true);
        
        partUser2 = TestingSetupDataUtil.createUser('pruser2','partnerUser2@testab.com','5_1_partnerUser2@testab.com','UTF-8','parTneruser2','en_US','en_US','America/Los_Angeles','partnerUser2@testing.com','55145616',partnerProfiles[0].Id );
        partUser2.ManagerId = userInfo.getUserId(); 
        partUser2.ContactId = partContact2.Id;
        partUser2.Location_Record_Id__c = newLoc.Id;
        //insert partUser2;
        usersList.add(partUser2);

        //system.assertEquals(partUser2.Partner_account_ID__c!=null,true);
      

        //******************************Creating second partner data*******************
        // Create a account with record type - partner
        partAcc2 = TestingSetupDataUtil.createAccount('Test Partner Account2', 'partner1@partnercollab.com','Partner');
        partAcc2.Partner_Portal_Eligible__c = true;
        insert partAcc2;
        
         system.assertEquals(partAcc2.Partner_Portal_Eligible__c,true);
          
        //Enable the account as partner
        partAcc2.IsPartner = true;
        partAcc2.Partner_Portal_Eligible__c = true;
        update partAcc2;   
        
        // Create a contact under the partner account
        List<Contact> conlist2 = new List<Contact>();
        partContact3 = TestingSetupDataUtil.createContact(partAcc2.Id, 'Test Prtnr Contact21');
        partContact3.Email='testcontact21@testing.com';
        //insert partContact3;
        conlist2.add(partContact3);
        
        // Create a contact under the partner account
        partContact4 = TestingSetupDataUtil.createContact(partAcc2.Id, 'Test Prtnr Contact22');
        partContact4.Email='testcontact22@testing.com';
        //insert partContact4;
        conlist2.add(partContact4);
        insert(conlist2);
        // Create a partner user
        partUser3 = TestingSetupDataUtil.createUser('pruser3','partnerUser3@testab.com','5_1_partnerUser3@testab.com','UTF-8','parTneruser3','en_US','en_US','America/Los_Angeles','partnerUser3@testing.com','55145617',partnerProfiles[0].Id );
        partUser3.ManagerId = userInfo.getUserId(); 
        partUser3.ContactId = partContact3.Id;
        partUser3.Location_Record_Id__c = newLoc.Id;
        //insert partUser3;
        usersList.add(partUser3);
        
        //system.assertEquals(partUser3.Partner_account_ID__c!=null,true);
        
        partUser4 = TestingSetupDataUtil.createUser('pruser4','partnerUser4@testab.com','5_1_partnerUser4@testab.com','UTF-8','parTneruser4','en_US','en_US','America/Los_Angeles','partnerUser4@testing.com','55145618',partnerProfiles[0].Id );
        partUser4.ManagerId = userInfo.getUserId(); 
        partUser4.ContactId = partContact4.Id;
        partUser4.Location_Record_Id__c = newLoc.Id;
        //insert partUser4;
        usersList.add(partUser4);
        
        insert usersList;
        // Insert Opportunity Team Members    
        List<OpportunityTeamMember> listOpportunityTeamMember = new List<OpportunityTeamMember>();
     
        oppMem = TestingSetupDataUtil.createOpportunityTeamMember(usersList[0].Id ,'Sales Rep',opty.Id);
        
        listOpportunityTeamMember.add(oppMem);
        oppMem1 = TestingSetupDataUtil.createOpportunityTeamMember(usersList[1].Id ,'Sales Rep',opty.Id);
        
        listOpportunityTeamMember.add(oppMem1);
        insert listOpportunityTeamMember;
        
        system.assertEquals(oppMem.opportunityid,opty.id);
        
        //system.assertEquals(partUser4.Partner_account_ID__c!=null,true);
        //Create Channel Partner 
        Channel_Partner__c channelPartner1 = TestingSetupDataUtil.createChannelPartner(opty.id,'Channel Partner',partAcc1.Id);
        insert channelPartner1;
        Channel_Partner__c channelPartner2 = TestingSetupDataUtil.createChannelPartner(opty1.id,'Channel Partner',partAcc2.Id);
        insert channelPartner2;
        
        Account acc = new Account(Name='testacc1',Source_System_Account_ID__c='56544565');
        insert acc ;  
        newAP = new Account_Plan__c(Name='Sample Account plan',Primary_AccountAccount__c=acc.id);
        insert newAP;
        
    }
    static testMethod void salesTeamLookupControllerTest() {
      Test.startTest();
      setupData();
      PageReference pref1 = Page.SalesTeamLookup;
      pref1.getParameters().put('optyid',opty.id);
      pref1.getParameters().put('lksrch',Null);
      pref1.getParameters().put('userType','Partner User');
      pref1.getParameters().put('teamid',usersList[0].Id);
      test.setcurrentpage(pref1);
      SalesTeamLookupController stc=new SalesTeamLookupController();
      stc.searchString='patrtner';
      stc.search();
      Test.stopTest();
      pref1.getParameters().put('userType','User');
      test.setcurrentpage(pref1);
      SalesTeamLookupController stc1=new SalesTeamLookupController();
      stc1.getFormTag();
      stc1.getTextBox();
      stc1.getIsResultEmpty();
      
      pref1.getParameters().put('userType','Partner User');
      pref1.getParameters().put('optyid',opty1.id);
      test.setcurrentpage(pref1);
      SalesTeamLookupController stc2=new SalesTeamLookupController();
      stc2.search();  
      
      SalesTeamLookupController stc3=new SalesTeamLookupController();
      pref1.getParameters().put('optyid',newAP.id);
      test.setcurrentpage(pref1);          
      stc3.ABPUsers(); 
      SalesTeamLookupController.convertTo15Digit('testparameterstring');     
      
  }

}