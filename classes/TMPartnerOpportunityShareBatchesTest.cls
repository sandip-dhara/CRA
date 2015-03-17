/***********************************************************************************
* Class Name: TMPartnerOpportunityShareBatchesTest 
* Author: HP
* Date: 08-OCT-2013
* Description: This class does the test coverage
*              for Partner Add/Remove share scenarios for Confidential Opportunities. 
************************************************************************************/

@isTest(seeAllData = true)
public class TMPartnerOpportunityShareBatchesTest{
    public static testMethod void PartnerShareRemoveTest(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        
        Account prtnrAccount = new Account(Name = 'TestPrtAcc1',RecordTypeId = recordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true,Regions__c = 'APJ');
        insert prtnrAccount;
        
        Location__c loc1 = new Location__c(Name = '12345',Account__c = prtnrAccount.Id,Location_Name__c = 'SomeTestLoc1');
        Location__c loc2 = new Location__c(Name = '12346',Account__c = prtnrAccount.Id,Location_Name__c = 'SomeTestLoc2');
        List<Location__c> locList = new List<Location__c>{loc1,loc2};
        insert locList;
        
        Contact con1 = new Contact(FirstName = 'Test1',LastName = 'Con1',AccountId = prtnrAccount.Id,Email = System.now().millisecond()+'test1@testing.com');
        Contact con2 = new Contact(FirstName = 'Test2',LastName = 'Con2',AccountId = prtnrAccount.Id,Email = System.now().millisecond()+'test2@testing.com');
        Contact con3 = new Contact(FirstName = 'Test3',LastName = 'Con3',AccountId = prtnrAccount.Id,Email = System.now().millisecond()+'test3@testing.com');
        Contact con4 = new Contact(FirstName = 'Test4',LastName = 'Con4',AccountId = prtnrAccount.Id,Email = System.now().millisecond()+'test4@testing.com');
        List<Contact> conList = new List<Contact>{con1,con2,con3,con4};
        insert conList;
        
        UserLicense usrLicns = [Select Id From UserLicense Where Name = 'Gold Partner'];
        Profile prtnrProfile = [Select Id From Profile Where Name like '%Partner Sales Rep%' and UserLicenseId = :usrLicns.Id];
        
        User partnerUser1 = new User(ProfileId = prtnrProfile.Id,ContactId = con1.Id,LastName = 'TestUsrLname1',FirstName = 'TestUsrFname1',userName = 'TestUsrFname1@test.com',Alias = 'T1',Email = 'TestUsrFname1@test.com',CommunityNickname = 't1',TimeZoneSidKey='America/Chicago',
        EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1234y1@hp.com',
        Partner_Collaboration_Participating_User__c=true,EmployeeNumber='6534548661',Legacy_Employee_Ref__c='142587547',Adoption_Role_Type__c='Partner User',Location_Record_Id__c = loc1.Id);
        User partnerUser2 = new User(ProfileId = prtnrProfile.Id,ContactId = con2.Id,LastName = 'TestUsrLname2',FirstName = 'TestUsrFname2',userName = 'TestUsrFname2@test.com',Alias = 'T2',Email = 'TestUsrFname2@test.com',CommunityNickname = 't2',TimeZoneSidKey='America/Chicago',
        EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1234y2@hp.com',
        Partner_Collaboration_Participating_User__c=true,EmployeeNumber='6534548662',Legacy_Employee_Ref__c='142587548',Adoption_Role_Type__c='Partner User',Location_Record_Id__c = loc2.Id);
        User partnerUser3 = new User(ProfileId = prtnrProfile.Id,ContactId = con3.Id,LastName = 'TestUsrLname3',FirstName = 'TestUsrFname3',userName = 'TestUsrFname3@test.com',Alias = 'T3',Email = 'TestUsrFname3@test.com',CommunityNickname = 't3',TimeZoneSidKey='America/Chicago',
        EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1234y3@hp.com',
        Partner_Collaboration_Participating_User__c=true,EmployeeNumber='6534548663',Legacy_Employee_Ref__c='142587549',Adoption_Role_Type__c='Partner User',Location_Record_Id__c = loc2.Id);
        User partnerUser4 = new User(ProfileId = prtnrProfile.Id,ContactId = con4.Id,LastName = 'TestUsrLname4',FirstName = 'TestUsrFname4',userName = 'TestUsrFname4@test.com',Alias = 'T4',Email = 'TestUsrFname4@test.com',CommunityNickname = 't4',TimeZoneSidKey='America/Chicago',
        EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1234y4@hp.com',
        Partner_Collaboration_Participating_User__c=true,EmployeeNumber='6534548664',Legacy_Employee_Ref__c='142587550',Adoption_Role_Type__c='Partner User',Location_Record_Id__c = loc2.Id);
        List<User> usrList = new List<User>{partnerUser1,partnerUser2,partnerUser3,partnerUser4};
        insert usrList;
        
        Location_Partner_Users__c lpu1 = new Location_Partner_Users__c(Contact__c = con1.id,Location__c = loc1.id,Userkey__c =  'a2bc1');
        Location_Partner_Users__c lpu2 = new Location_Partner_Users__c(Contact__c = con2.id,Location__c = loc2.id,Userkey__c =  'a2bc2');
        Location_Partner_Users__c lpu3 = new Location_Partner_Users__c(Contact__c = con3.id,Location__c = loc2.id,Userkey__c =  'a2bc3');
        Location_Partner_Users__c lpu4 = new Location_Partner_Users__c(Contact__c = con4.id,Location__c = loc2.id,Userkey__c =  'a2bc4',Territory_Partner_Admin_Role__c = 'Deal Administrator');
        List<Location_Partner_Users__c> lpuList = new List<Location_Partner_Users__c>{lpu1,lpu2,lpu3,lpu4};
        insert lpuList;
        
        Sales_Territory__c ne_salesTerritory1 = new Sales_Territory__c(name = 'St-testname1',isPartner__c = true,isActive__c = true,MyComp_Sales_Territory_Name__c ='St-Test1');
        Sales_Territory__c ne_salesTerritory2 = new Sales_Territory__c(name = 'St-testname2',isPartner__c = true,isActive__c = true,MyComp_Sales_Territory_Name__c ='St-Test2');
        Sales_Territory__c ne_salesTerritory3 = new Sales_Territory__c(name = 'St-testname3',isPartner__c = true,isActive__c = true,MyComp_Sales_Territory_Name__c ='St-Test3');
        List<Sales_Territory__c> salesTerrList = new List<Sales_Territory__c>{ne_salesTerritory1,ne_salesTerritory2,ne_salesTerritory3};
        insert salesTerrList;
        
        Sales_Territory_Location_Assignment__c salesLocationAssign1 = new Sales_Territory_Location_Assignment__c();
        salesLocationAssign1.Sales_Territory__c = ne_salesTerritory1.id;
        salesLocationAssign1.Location__c = loc1.id;
        Sales_Territory_Location_Assignment__c salesLocationAssign2 = new Sales_Territory_Location_Assignment__c();
        salesLocationAssign2.Sales_Territory__c = ne_salesTerritory2.id;
        salesLocationAssign2.Location__c = loc2.id;
        List<Sales_Territory_Location_Assignment__c> stlaList = new List<Sales_Territory_Location_Assignment__c>{salesLocationAssign1,salesLocationAssign2};
        insert stlaList;
        
        Sales_Territory_Account_Assignment__c salesAccAssign = new Sales_Territory_Account_Assignment__c();
        salesAccAssign.Sales_Territory__c = ne_salesTerritory3.id;
        salesAccAssign.Account__c = prtnrAccount.id;
        insert salesAccAssign;
        
        Account cusAcc = TestingSetupDataUtil.createAccount('testCustAccount','accountEmail1@test.com','Customer');
        insert cusAcc;
        
        Opportunity oppty = new Opportunity(Name = 'testOppty',Confidential__c = false,CloseDate = System.today()+30,AccountId = cusAcc.Id,StageName = '01 - Understand Customer',CurrencyIsoCode = 'USD');
        insert oppty;
        
        Channel_Partner__c acp1 = new Channel_Partner__c(Channel_Partner__c = prtnrAccount.Id,Opportunity__c = oppty.Id,Location__c = loc1.Id);
        Channel_Partner__c acp2 = new Channel_Partner__c(Channel_Partner__c = prtnrAccount.Id,Opportunity__c = oppty.Id,Location__c = loc2.Id);
        List<Channel_Partner__c> acpList = new List<Channel_Partner__c>{acp1,acp2};
        insert acpList;
        
        OpportunityTeamMember salesTeam = new OpportunityTeamMember(OpportunityId = oppty.Id,TeamMemberRole = 'Account Executive',UserId = partnerUser4.Id);
        insert salesTeam;
        
        cusAcc.Confidential_Account__c = true;
        update cusAcc;
        
        test.startTest();
        
            TMRemovePtrSharePvtAccScheduler remPtrShare = new TMRemovePtrSharePvtAccScheduler();
            Datetime currentDateTime = Datetime.now();
            String min = String.valueOf(math.mod(currentDateTime.minute() + 1, 60));
            String schExp = '0 '+min+' * * * ?' ;
            system.schedule('TM - Remove Partner Share for Non Private Customer Accounts'+datetime.now(), schExp, remPtrShare);
            
        test.stopTest();
        
    }
    
    public static testMethod void PartnerShareAddTest(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        
        Account prtnrAccount = new Account(Name = 'TestPrtAcc1',RecordTypeId = recordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true,Regions__c = 'APJ');
        insert prtnrAccount;
        
        Location__c loc1 = new Location__c(Name = '12345',Account__c = prtnrAccount.Id,Location_Name__c = 'SomeTestLoc1');
        Location__c loc2 = new Location__c(Name = '12346',Account__c = prtnrAccount.Id,Location_Name__c = 'SomeTestLoc2');
        List<Location__c> locList = new List<Location__c>{loc1,loc2};
        insert locList;
        
        Contact con1 = new Contact(FirstName = 'Test1',LastName = 'Con1',AccountId = prtnrAccount.Id,Email = System.now().millisecond()+'test1@testing.com');
        Contact con2 = new Contact(FirstName = 'Test2',LastName = 'Con2',AccountId = prtnrAccount.Id,Email = System.now().millisecond()+'test2@testing.com');
        Contact con3 = new Contact(FirstName = 'Test3',LastName = 'Con3',AccountId = prtnrAccount.Id,Email = System.now().millisecond()+'test3@testing.com');
        Contact con4 = new Contact(FirstName = 'Test4',LastName = 'Con4',AccountId = prtnrAccount.Id,Email = System.now().millisecond()+'test4@testing.com');
        List<Contact> conList = new List<Contact>{con1,con2,con3,con4};
        insert conList;
        
        UserLicense usrLicns = [Select Id From UserLicense Where Name = 'Gold Partner'];
        Profile prtnrProfile = [Select Id From Profile Where Name like '%Partner Sales Rep%' and UserLicenseId = :usrLicns.Id];
        
        User partnerUser1 = new User(ProfileId = prtnrProfile.Id,ContactId = con1.Id,LastName = 'TestUsrLname1',FirstName = 'TestUsrFname1',userName = 'TestUsrFname1@test.com',Alias = 'T1',Email = 'TestUsrFname1@test.com',CommunityNickname = 't1',TimeZoneSidKey='America/Chicago',
        EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1234y1@hp.com',
        Partner_Collaboration_Participating_User__c=true,EmployeeNumber='6534548661',Legacy_Employee_Ref__c='142587547',Adoption_Role_Type__c='Partner User',Location_Record_Id__c = loc1.Id);
        User partnerUser2 = new User(ProfileId = prtnrProfile.Id,ContactId = con2.Id,LastName = 'TestUsrLname2',FirstName = 'TestUsrFname2',userName = 'TestUsrFname2@test.com',Alias = 'T2',Email = 'TestUsrFname2@test.com',CommunityNickname = 't2',TimeZoneSidKey='America/Chicago',
        EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1234y2@hp.com',
        Partner_Collaboration_Participating_User__c=true,EmployeeNumber='6534548662',Legacy_Employee_Ref__c='142587548',Adoption_Role_Type__c='Partner User',Location_Record_Id__c = loc2.Id);
        User partnerUser3 = new User(ProfileId = prtnrProfile.Id,ContactId = con3.Id,LastName = 'TestUsrLname3',FirstName = 'TestUsrFname3',userName = 'TestUsrFname3@test.com',Alias = 'T3',Email = 'TestUsrFname3@test.com',CommunityNickname = 't3',TimeZoneSidKey='America/Chicago',
        EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1234y3@hp.com',
        Partner_Collaboration_Participating_User__c=true,EmployeeNumber='6534548663',Legacy_Employee_Ref__c='142587549',Adoption_Role_Type__c='Partner User',Location_Record_Id__c = loc2.Id);
        User partnerUser4 = new User(ProfileId = prtnrProfile.Id,ContactId = con4.Id,LastName = 'TestUsrLname4',FirstName = 'TestUsrFname4',userName = 'TestUsrFname4@test.com',Alias = 'T4',Email = 'TestUsrFname4@test.com',CommunityNickname = 't4',TimeZoneSidKey='America/Chicago',
        EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1234y4@hp.com',
        Partner_Collaboration_Participating_User__c=true,EmployeeNumber='6534548664',Legacy_Employee_Ref__c='142587550',Adoption_Role_Type__c='Partner User',Location_Record_Id__c = loc2.Id);
        List<User> usrList = new List<User>{partnerUser1,partnerUser2,partnerUser3,partnerUser4};
        insert usrList;
        
        Location_Partner_Users__c lpu1 = new Location_Partner_Users__c(Contact__c = con1.id,Location__c = loc1.id,Userkey__c =  'a2bc1');
        Location_Partner_Users__c lpu2 = new Location_Partner_Users__c(Contact__c = con2.id,Location__c = loc2.id,Userkey__c =  'a2bc2');
        Location_Partner_Users__c lpu3 = new Location_Partner_Users__c(Contact__c = con3.id,Location__c = loc2.id,Userkey__c =  'a2bc3');
        Location_Partner_Users__c lpu4 = new Location_Partner_Users__c(Contact__c = con4.id,Location__c = loc2.id,Userkey__c =  'a2bc4',Territory_Partner_Admin_Role__c = 'Deal Administrator');
        List<Location_Partner_Users__c> lpuList = new List<Location_Partner_Users__c>{lpu1,lpu2,lpu3,lpu4};
        insert lpuList;
        
        Sales_Territory__c ne_salesTerritory1 = new Sales_Territory__c(name = 'St-testname1',isPartner__c = true,isActive__c = true,MyComp_Sales_Territory_Name__c ='St-Test1');
        Sales_Territory__c ne_salesTerritory2 = new Sales_Territory__c(name = 'St-testname2',isPartner__c = true,isActive__c = true,MyComp_Sales_Territory_Name__c ='St-Test2');
        Sales_Territory__c ne_salesTerritory3 = new Sales_Territory__c(name = 'St-testname3',isPartner__c = true,isActive__c = true,MyComp_Sales_Territory_Name__c ='St-Test3');
        List<Sales_Territory__c> salesTerrList = new List<Sales_Territory__c>{ne_salesTerritory1,ne_salesTerritory2,ne_salesTerritory3};
        insert salesTerrList;
        
        Sales_Territory_Location_Assignment__c salesLocationAssign1 = new Sales_Territory_Location_Assignment__c();
        salesLocationAssign1.Sales_Territory__c = ne_salesTerritory1.id;
        salesLocationAssign1.Location__c = loc1.id;
        Sales_Territory_Location_Assignment__c salesLocationAssign2 = new Sales_Territory_Location_Assignment__c();
        salesLocationAssign2.Sales_Territory__c = ne_salesTerritory2.id;
        salesLocationAssign2.Location__c = loc2.id;
        List<Sales_Territory_Location_Assignment__c> stlaList = new List<Sales_Territory_Location_Assignment__c>{salesLocationAssign1,salesLocationAssign2};
        insert stlaList;
        
        Sales_Territory_Account_Assignment__c salesAccAssign = new Sales_Territory_Account_Assignment__c();
        salesAccAssign.Sales_Territory__c = ne_salesTerritory3.id;
        salesAccAssign.Account__c = prtnrAccount.id;
        insert salesAccAssign;
        
        Account cusAcc = TestingSetupDataUtil.createAccount('testCustAccount','accountEmail1@test.com','Customer');
        insert cusAcc;
        
        Opportunity oppty = new Opportunity(Name = 'testOppty',Confidential__c = false,CloseDate = System.today()+30,AccountId = cusAcc.Id,StageName = '01 - Understand Customer',CurrencyIsoCode = 'USD');
        insert oppty;
        
        Channel_Partner__c acp1 = new Channel_Partner__c(Channel_Partner__c = prtnrAccount.Id,Opportunity__c = oppty.Id,Location__c = loc1.Id);
        Channel_Partner__c acp2 = new Channel_Partner__c(Channel_Partner__c = prtnrAccount.Id,Opportunity__c = oppty.Id,Location__c = loc2.Id);
        List<Channel_Partner__c> acpList = new List<Channel_Partner__c>{acp1,acp2};
        insert acpList;
        
        OpportunityTeamMember salesTeam = new OpportunityTeamMember(OpportunityId = oppty.Id,TeamMemberRole = 'Account Executive',UserId = partnerUser4.Id);
        insert salesTeam;
        
        cusAcc.Confidential_Account__c = true;
        update cusAcc;
        cusAcc.Confidential_Account__c = false;
        update cusAcc;
        
        test.startTest();    
            TMAddPtrShareNonPvtAccScheduler addPtrShare = new TMAddPtrShareNonPvtAccScheduler();
            Datetime currentDateTime1 = Datetime.now();
            String min1 = String.valueOf(math.mod(currentDateTime1.minute() + 2, 60));
            String schExp1 = '0 '+min1+' * * * ?' ;
            system.schedule('TM - Add Partner Share for Non Private Customer Accounts'+datetime.now(), schExp1, addPtrShare);
        test.stopTest();    
    
    }
    
     public static testMethod void PartnerRemoveShare_ElseConTest(){
        test.startTest();
            TMRemovePtrSharePvtAccScheduler remPtrShare = new TMRemovePtrSharePvtAccScheduler();
            Datetime currentDateTime = Datetime.now();
            String min = String.valueOf(math.mod(currentDateTime.minute() + 1, 60));
            String schExp = '0 '+min+' * * * ?' ;
            system.schedule('TM - Add Partner Share for Non Private Customer Accounts'+datetime.now(), schExp, remPtrShare);
        test.stopTest();
     }
     
      public static testMethod void PartnerAddShare_ElseConTest(){
        test.startTest();
            TMAddPtrShareNonPvtAccScheduler addPtrShare = new TMAddPtrShareNonPvtAccScheduler();
            Datetime currentDateTime1 = Datetime.now();
            String min1 = String.valueOf(math.mod(currentDateTime1.minute() + 2, 60));
            String schExp1 = '0 '+min1+' * * * ?' ;
            system.schedule('TM - Add Partner Share for Non Private Customer Accounts'+datetime.now(), schExp1, addPtrShare);
        test.stopTest();
     }
    
}