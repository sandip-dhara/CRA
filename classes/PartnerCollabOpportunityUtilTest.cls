/***********************************************************
* Class Name: PartnerCollabOpportunityUtilTest
* Author: Accenture
* Date: 26-JULY-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for PartnerCollabOpportunityUtil class.
***********************************************************/

@isTest
private class PartnerCollabOpportunityUtilTest {
    /*private static Account partAcc = new Account();
    private static Account partAcc1 = new Account();
    private static Account custAcc = new Account();
    private static Contact partContact1 = new Contact();
    private static Contact partContact2 = new Contact();
    private static Contact partContact3 = new Contact();
    private static User partUser111 = new User();
    private static User partUser222 = new User();
    private static User partUser333 = new User();
    private static User intUser111 = new User();
    private static Opportunity opptyTest = new Opportunity();
    private static list<Opportunity> convFrmLead = new list<Opportunity>();
    //private static Lead leadTest = new Lead();
    private static Campaign camp;*/
    private static Location__c partLoc;
    private static Location__c partNewLoc;
    private static User portalUser ;
    private static Account newCustAccount;
    private static Opportunity opptyTest;
    private static Contact contact1=null;
    private static Account newAccount=null;
    private static Campaign camp=null;

    //setup your test data in this method
    private static testMethod void PositiveTest() { 
    
    Test.startTest();
    
        Profile internalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%IT Administrator%' Limit 1];   
        UserRole testRole=[SELECT id from UserRole where portalrole =null  limit 1];
        User testUser = new User(ProfileId = internalProfile.id,
                LastName = 'Test13', 
                FirstName = 'Test13', 
                Username = '0testing134@hp.com', 
                Alias='test136', 
                CommunityNickname='test Approve134', 
                Email='test13@Hp.com',
                TimeZoneSidKey='America/Chicago',
                EmailEncodingKey='ISO-8859-1', 
                LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',
                IsActive=True,
                Email_Address__c='test13@hp.com',
                EmployeeNumber='6534866',
                Legacy_Employee_Ref__c='148754',
                Adoption_Role_Type__c='IT',
                UserRoleId =testRole.id
        );
        insert testUser; 

        
        System.runAs(testUser){
            //Recordtype recordId=[Select Id,Name from recordtype where Name='Partner'];
            Id recordId=RecordTypeIdHelper.getRecordTypeId('Account','Partner');
            newAccount=new Account(Name='TestAccountForTestClass',RecordTypeId=recordId,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
            insert newAccount;
            newAccount.IsPartner=true;
            update newAccount;
            
            contact1 = new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccount.Id,Email = System.now().millisecond() + 'test@hp.com');
            insert contact1;
            //Test Location Insertion
            partLoc=new Location__c(Name='33586574',Account__c=newAccount.Id);
            Insert partLoc; 
            partNewLoc = new Location__c(Name='33500574',Account__c=newAccount.Id);
            Insert partNewLoc;
            Profile portalProfile = [Select UserType, UserLicenseId, Name, Id From Profile  where UserType like '%partner%' limit 1 ];
            system.debug('user t'+portalProfile.UserType);
            //Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' and UserType LIKE '%partner%' Limit 1];
            portalUser = new User(Location_Record_Id__c = partLoc.Id,ProfileId = portalProfile.id,ContactId=contact1.Id,LastName = 'Test1', FirstName = 'Test1', Username = '0testing45@hp.com', Alias='test14', CommunityNickname='0test Approve143', Email='test1@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1@hp.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='10487547');
            Insert portalUser;
            portalUser.isportalEnabled=true;
            Update portalUser;
            system.debug('user type'+portalUser.UserType+'###'+portalUser.isportalEnabled);
        }
        
        Profile prof = [select id from Profile where name='IT Administrator' limit 1];   
        User managerUser = new User(ProfileId = prof.id,LastName = 'TestManager',Manager__c='MGR',FirstName = 'TestManager', Username = '0testing456manage@hp.com', Alias='testm', CommunityNickname='test Approve manager1', Email='testmanager@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=false,Email_Address__c='testmanager@hp.com',EmployeeNumber='653486614',Legacy_Employee_Ref__c='48754718',Adoption_Role_Type__c='IT');
        Insert managerUser ;
        User approverUser = new User(ProfileId = prof.id,LastName = 'Test',Manager__c='MGR',ManagerId=managerUser.id, FirstName = 'Test', Username = '0testing4560@hp.com', Alias='test', CommunityNickname='test Approve8', Email='test@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=false,Email_Address__c='test@hp.com',EmployeeNumber='65348665',Legacy_Employee_Ref__c='4875475',Adoption_Role_Type__c='IT');
        Insert approverUser ;
        Id record=RecordTypeIdHelper.getRecordTypeId('Campaign','Partner Program');
        System.runAs(testUser){
        camp = new Campaign (Name='Partner for Growth Testing1',StartDate=system.today(),RecordTypeId=record,Level_1_Approver_1__c=approverUser.ID,Level_1_Approver_2__c=approverUser.ID,Level_1_Approver_3__c=approverUser.ID,Level_1_Approver_4__c=approverUser.ID,IsActive=True,All_Products_Eligible__c='No');
        insert camp ;
        Program_Location_Association__c  newProgramLoc = new Program_Location_Association__c(Location__c=partLoc.id,Program__c=camp.id);
        insert newProgramLoc;
        newProgramLoc.Location__c = partNewLoc.Id;
        update newProgramLoc;
        }
               
    system.runas(portalUser){
    Id record1=RecordTypeIdHelper.getRecordTypeId('Account','Customer');
    newCustAccount=new Account(Name='test acc',ShippingCountry='India',RecordTypeId=record1);
     Insert newCustAccount;
    
    // Opportunity creation
    opptyTest = new Opportunity(AccountId=newCustAccount.Id,Name='opptyTest', closedate=system.today()+ 30,StageName='01 - Understand Customer');
    opptyTest.Partner_acknowledged__c = false;
    opptyTest.Converted_by_Partner__c = false;
    opptyTest.OwnerId = portalUser.Id;
    //opptyTest.Assigned_to_partner_date__c = system.today() - 1;
    opptyTest.Assigned_to_partner_date__c = system.now();
    opptyTest.Managed_By__c ='Partner';
    opptyTest.Partner_acknowledged__c =true;
    opptyTest.Converted_by_Partner__c=true; 
    insert opptyTest;
    }
/*    Account custAcc = new Account();
    custAcc = TestingSetupDataUtil.createAccount('TestAcc','accEmail@testmail.com','Customer');
    insert custAcc;
    // create a lead
    Lead leadTest = new Lead();
    leadTest = TestingSetupDataUtil.createLead('partleadTest', 'partCompany', 'Qualified', 'Accepted', '348536856', 'testEmail@test.com');
    //leadTest.OwnerId = intUser111.Id;
    leadTest.OwnerId = testUser.Id;
    leadTest.Status = 'Open';
    leadTest.Account_Name__c = custAcc.Id;
    leadTest.Budget__c = '121' ;
    leadTest.Authorized_Buyer__c = 'No';
    leadTest.Timeframe_to_Buy_1__c = '< 1 Week';
    leadTest.Estimated_Budget__c = 123.0;
    //leadTest.Assigning_by_ISR__c=intUser111.Id;
    leadTest.Assigning_by_ISR__c=testUser.Id;
    leadTest.ConvertedOpportunityId__c=opptyTest.Id;
    insert leadTest;
*/  
    
    
     
    //Method for Positive test

        
        
        
        
       /*Channel_Partner__c channelpartner=new Channel_Partner__c(Opportunity__c =opptyTest.Id,Channel_Partner__c =newAccount.Id,Partner_Type__c ='Channel Partner');
      Insert channelpartner;
        
        OpportunityTeamMember opptyteam=new OpportunityTeamMember (OpportunityId =opptyTest.Id,UserId =testUser.Id,TeamMemberRole ='Inside Sales');
        Insert opptyteam;
        
        strike_count_track__c strikecount=new strike_count_track__c(Opportunity__c =opptyTest.Id,Owner_Partner_User__c =opptyTest.OwnerId,Partner_Account__c =newAccount.id,Partner_Location__c=partLoc.Id,Partner_Contact__c =contact1.Id,User_Assignment_Date__c =system.now());
        Insert strikecount;*/
        
        PartnerCollabOpportunityUtil.leadConversionInProgress = false;
        system.debug('a1b'+userinfo.getuserid());
        system.runas(portalUser){
            PartnerCollabOpportunityUtil.PartnerleadConversion(opptyTest);
        }
        //PartnerCollabOpportunityUtil.insertPreviousOwnerOfLeadIntoSalesTeam(opptyTest);
        
        Test.stopTest();
    }
    
}