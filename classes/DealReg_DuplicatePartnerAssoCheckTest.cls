/**
 * Class Name: DealReg_DuplicatePartnerAssoCheckTest
 * Author: HP
 * Date: 18-Oct-2012 
 * Requirement # Request Id:3396 
 * Description: Test Class which Covers
 * Class-DealReg_DuplicatePartnerAssoCheck
 * Trigger-DealRegProgPartBeforeUpdate
 * Trigger-DealRegProgPartBeforeInsert
 */
@IsTest
private class DealReg_DuplicatePartnerAssoCheckTest{
    static PermissionSet permissionTest1 = new PermissionSet();
    static Programs_and_permissions__c prperm = null;
    static Account newAccountTest = null;

    static testMethod void testDuplicate(){
        Profile internalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%IT Administrator%' Limit 1];
        User testUser = new User(ProfileId = internalProfile.id,
                LastName = 'Test13', 
                FirstName = 'Test13', 
                Username = 'testing13@hp.com', 
                Alias='test13', 
                CommunityNickname='test Approve13', 
                Email='test13@hp.com',
                TimeZoneSidKey='America/Chicago',
                EmailEncodingKey='ISO-8859-1', 
                LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',
                IsActive=True,
                Email_Address__c='test13@hp.com',
                EmployeeNumber='653486625',
                Legacy_Employee_Ref__c='14875465',
                Adoption_Role_Type__c='IT'
                );
        insert testUser;      

        /*Setup Data to inseet User*/
        User approverUser = new User(ProfileId = internalProfile.Id,LastName = 'Test', FirstName = 'Test', Username = 'testing456@hp.com', Alias='test', CommunityNickname='test Approve', Email='test@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test@email.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='487547',Adoption_Role_Type__c='IT');
        insert approverUser ;
        /*Setup Data to select the record for which RecordType are Partner, Partner Program*/
        Id record = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Id recordcamp = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Partner Program').getRecordTypeId();
        /*Setup Data to insert Campaign*/
        System.RunAs(testUser){
            Campaign camp = new Campaign ();
            camp.Name='Partner for Growth Test1';
            camp.Level_1_Approver_1__c=approverUser.Id;
            camp.All_Products_Eligible__c='No';
            camp.RecordTypeId=recordcamp;
            camp.StartDate= system.today();
            insert camp ;
            /*Setup Data to insert Account*/
            Account newAccount=new Account(Name='TestAccountForTestClass',RecordTypeId=record,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
            insert newAccount;
            Account newAccount2=new Account(Name='TestAccountForTestClass1',RecordTypeId=record,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
            insert newAccount2;
            /*Setup Data to insert Program Partner Association*/

            Program_Partner_Association__c recentprogPartAssc = new Program_Partner_Association__c();
            recentprogPartAssc.program__c=camp.Id;
            recentprogPartAssc.Partner__c=newAccount.Id;
            insert recentprogPartAssc;

            /*Setup Data to insert Program Partner Association to check duplicate association*/
            Program_Partner_Association__c progPart = new Program_Partner_Association__c();
            progPart.Program__c=camp.Id;
            progPart.Partner__c=newAccount.Id;
            try{
                insert progPart;
            }catch(Exception e){
                System.debug('Partner Account already associated to program');
            }     

            try{
                /*Setup Data to update Program Partner Association*/
                recentprogPartAssc.Partner__c=newAccount2.Id;
                update recentprogPartAssc;
            }catch(Exception e){
                System.debug('Updating with the new partner');
            }
            /*Setup Data to insert Campaign to check RecordType validation*/
            Campaign campCheckRecordType = new Campaign ();
            campCheckRecordType.Name='Partner for Growth Testva';
            campCheckRecordType.Level_1_Approver_1__c=approverUser.Id;
            campCheckRecordType.All_Products_Eligible__c='No';  
            campCheckRecordType.StartDate= system.today();
            insert campCheckRecordType;
            /*Setup Data to insert Program Partner Association to check RecordType validation*/
            Program_Partner_Association__c progPartcheckRecordType = new Program_Partner_Association__c();
            progPartcheckRecordType.Program__c=campCheckRecordType.Id;
            progPartcheckRecordType.Partner__c=newAccount.Id;
            try{
                insert progPartcheckRecordType;
            }catch(Exception e){
                System.debug('Please associate program from Partnner Program record type only');
            }
            Program_Partner_Association__c progPartMute = new Program_Partner_Association__c();
            progPartMute.Program__c=campCheckRecordType.Id;
            progPartMute.Partner__c=newAccount.Id;
            try{
                insert progPartMute;
            }catch(Exception e){
                System.debug('Please associate program from Partnner Program record type only');
            }
            try{
                update progPartMute ;
            }catch(Exception e){
                System.debug('Duplicate association');
            }
        }
    }
    /**
     *Author : PRM Team HP
     *@description - Setup data for PartnerProgramAssociation trigger and class
     *@Requirement #: 4086
     */ 
    public static testMethod void testPartnerProgramAssociation(){
        Contact contact1 = null;
        //Partner Account Insertion
        /* Recordtype info of Partner Recordtype in Account */
        Id recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        /*Set up data for Partner Account */
        newAccountTest=new Account(Name='TestAccountForTestClass',RecordTypeId=recordId,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
        insert newAccountTest;
        newAccountTest.IsPartner=true;
        update newAccountTest;
        //Test Contact Insertion 
        contact1 = new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccountTest.Id,Email = System.now().millisecond() + '1test@hp.com');
        insert contact1;
        UserLicense usrLic =[Select id from UserLicense where name='Gold Partner'];
        List<Profile> prof = [select id,Name from Profile WHERE Name LIKE '%IT Administrator%' OR (Name LIKE '%Gold Partner User%' AND UserLicenseId=:usrLic.Id) ORDER BY UserLicenseId limit 2];
        /* Set up data of portal user */
        Id profileIdITAdmin = null;
        Id profileIdGold = null;
        for(Profile p:prof){
            if(p.Name == 'IT Administrator')
                profileIdITAdmin = p.Id;
            else if(p.Name == 'Gold Partner User')
                profileIdGold = p.Id;
        }
        User portalUser = new User(ProfileId = ProfileIdGold,ContactId=contact1.Id,LastName = 'Test1', FirstName = 'Test1', Username = 'tesprtl7test@hp.com', Alias='test1', CommunityNickname='test Approptr1', Email='testpremail@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testpremail@hp.com',EmployeeNumber='60348661',Legacy_Employee_Ref__c='1487557',Adoption_Role_Type__c='IT');
        insert portalUser;
        User pp = [select Id, UserType, Name from User where Id =: portalUser.Id];
        //System.debug('$$**'+ portalUser.Partner_account_ID__c);
        System.debug('aaa'+ pp.UserType);
        /*Setup Data To select Recordtype of Program Partner*/
        Id record = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Partner Program').getRecordTypeId();
        /*Setup Data to insert User*/   
        User approverUser = new User(ProfileId = ProfileIdITAdmin,LastName = 'Test', FirstName = 'Test', Username = 'testing456test@hp.com', Alias='test', CommunityNickname='test Approve', Email='testemail@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testemail@hp.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='487547',Adoption_Role_Type__c='IT');
        Insert approverUser ;
        system.debug('bbb'+approverUser.UserType);
        /*Setup Data To Insert Campaign*/
        Campaign camp = new Campaign ();
        camp.Name='Partner for Growth Test1vis';
        camp.Level_1_Approver_1__c=approverUser.ID;
        camp.All_Products_Eligible__c='No';
        camp.RecordTypeId=record;
        camp.StartDate=system.today();
        camp.IsActive= true;
        insert camp ;
        System.debug('$$**camp'+camp );
        User adminUser = new User(ProfileId = ProfileIdITAdmin,LastName = 'TestL', FirstName = 'TestF', Username = 'testFLtest@hp.com', Alias='testFL', CommunityNickname='test AdminFL', Email='testemail@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testemailFL@hp.com',EmployeeNumber='6534860',Legacy_Employee_Ref__c='487546',Adoption_Role_Type__c='IT');
        Insert adminUser ;
        
        /* Setup data for Permission Set
        PermissionSet permissionTest=[select name,label from permissionset  where USERLICENSEID in (select id from userLicense where name = 'GOLD PARTNER') and label like '%deal%' limit 1];
        System.RunAs(approverUser){
            Setup Data To insert Programs and Permissions record
            system.debug('permissionTest inserted ***'+permissionTest);
            prperm = [select Id from Programs_and_permissions__c where Program__c =: camp.id and PermissionSets__c =: permissionTest.Name];
            //Insert prperm;
            system.debug('Programs_and_permissions__c setup rec ***'+prperm);
            Setup Data To insert Program Partner Assocoation       
            Program_Partner_Association__c progPart = new Program_Partner_Association__c();
            progPart.Partner__c=newAccountTest.Id;
            progPart.Program__c=camp.Id;
            insert progPart ;
            System.debug('$$**progPart '+progPart );
        }
        System.RunAs(adminUser){
            Test.startTest();
            System.debug('Test class1'+permissionTest.Name+permissionTest.Id);
            Permission_Partner_Association__c PermPartner = new Permission_Partner_Association__c(Partner__c = newAccountTest.Id, Programs_and_permissions__c =prperm.Id);
            Insert PermPartner;
            System.debug('Test class2'+PermPartner);
            Test.stopTest();
        }*/
    }
     
}