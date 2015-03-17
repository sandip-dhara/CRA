/***********************************************************
 * Class Name: PartnerCollabUserUtilTest
 * Author: Accenture
 * Date: 26-JULY-2012 
 * Requirement # Request Id: 
 * Description: This class does the test coverage for PartnerCollabUserUtil class.
 ***********************************************************/

@isTest(seealldata = true)
private class PartnerCollabUserUtilTest {
    static PermissionSet permission = new PermissionSet();
    static user partTest = new user();
    static Account partAcc = new Account();
    static Contact partCont = new Contact();
    static User partUser = new User();
    static Group partQueue = new Group();
    static map<id,user> partUserMap;

    //setup your test data in this method
    private static void setupData() {

        // Partner account creation
        partAcc = TestingSetupDataUtil.createAccount('Test Partner Account', 'partnerpartnercollab@hp.com','Partner');
        insert partAcc;

        // Create a contact under the partner account
        partCont = TestingSetupDataUtil.createContact(partAcc.Id, 'Test Contact');
        insert partCont;

        // Create a partner queue
        partQueue.Type = 'queue';
        partQueue.Name = 'partTestQueue';
        partQueue.DeveloperName = 'Partner_Queue_' + partAcc.Id;
        insert partQueue;
    }

    //Method for Positive test
    private static testMethod void PositiveTest() {
        Test.startTest();
        setupData();

        // fetch the partner profiles
        List<Profile> partnerProfiles = new List<Profile>();
        partnerProfiles = [Select p.UserType, p.UserLicenseId, p.Name, p.Id From Profile p where p.UserType like '%Partner%' ];

        // Create a user and enable it as a partner
        partUser = TestingSetupDataUtil.createUser('partTest','abcwtestab@hp.com','5_1_PMawbctestab@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saweestca@hp.com','55245615',partnerProfiles[0].Id );
        partUser.ContactId = partCont.Id;
        insert partUser;

        Test.stopTest();
    }

    //Method for Negative test
    private static testMethod void NegativeTest() {
        Test.startTest();
        setupData();        
        Test.stopTest();

    }
    /*************************************************************************
     * Description: To cover functionality when a new partner user is inserted 
     * Author: HP
     * Date: 15-JAN-2013  
     *************************************************************************/
    //Method for addPermissionSetToPartnerUsers
    private static testMethod void addPermissionSetTest(){
        Account newAccount=null;
        Contact contact1 = null;
        //Partner Account Insertion
        Id recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        
        //New location insertion
        Location__c newLocation = new Location__c(Name='Testlocationname',Location_Name__c = 'Testlocationid');
        insert newLocation;

        newAccount=new Account(Name='TestAccountForTestClass',RecordTypeId=recordId,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
        insert newAccount;
        newAccount.IsPartner=true;
        update newAccount;
        
        //Test Contact Insertion 
        contact1 = new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccount.Id,Email = System.now().millisecond() + 'testtest@hp.com');
        insert contact1;

        /*Setup Data To select Recordtype of Program Partner*/
        Id record = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Partner Program').getRecordTypeId(); 

        /*Setup Data to insert User*/   
        Profile prof = [select id from Profile WHERE Name LIKE '%IT Administrator%' limit 1]; 
        User approverUser = new User(ProfileId = prof.id,LastName = 'Test', FirstName = 'Test', Username = 'testing456test@hp.com', Alias='test', CommunityNickname='test Approve', Email='testemail@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=false,Email_Address__c='testemail@hp.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='487547',Adoption_Role_Type__c='IT');
        Insert approverUser ;
        
        /*Setup Data To Insert Campaign*/
        Campaign camp = new Campaign ();
        camp.Name='Partner for Growth Test1';
        camp.Level_1_Approver_1__c=approverUser.ID;
        camp.All_Products_Eligible__c='No';
        camp.RecordTypeId=record;
        camp.StartDate=system.today();
        camp.IsActive= true;
        insert camp ;
        System.debug('$$**camp'+camp );
        /*Setup Data To insert Program Product Association*       
        Program_Partner_Association__c progPart = new Program_Partner_Association__c();
        progPart.Partner__c=newAccount.Id;
        progPart.Program__c=camp.Id;
        insert progPart ;
        System.debug('$$**progPart '+progPart ); */
        /* Setup date to insert Program_Location_Association*/
        Program_Location_Association__c newPLA = new Program_Location_Association__c();
        newPLA.Location__c = newLocation.id;
        newPLA.Program__c = camp.Id;
        insert newPLA;
        
        Profile sysAdmin = [select id, name from profile where name = 'System Administrator'];
        List<User> usr = [Select id from User where ProfileID = : sysAdmin.Id limit 2];
        System.RunAs(usr[0]){
            Test.startTest();
            System.debug('$$**UserInfo'+UserInfo.getUserId());
            insertPermissionSetRecord();
            System.debug('$$**UserInfoAfter'+UserInfo.getUserId());  
            Test.stopTest();
        }
        System.RunAs(usr[1]){           
            
            //Partner User Insertion
            UserLicense usrLic =[Select id from UserLicense where name='Gold Partner'];
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Gold Partner User%' and UserLicenseId=:usrLic.Id ];
            User portalUser = new User(Location_Record_Id__c = newLocation.Id,ProfileId = portalProfile.id,ContactId=contact1.Id,LastName = 'Test1', FirstName = 'Test1', Username = 'tesprtl7test@hp.com', Alias='test1', CommunityNickname='test Approptr1', Email='testpremail@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testpremail@hp.com',EmployeeNumber='60348661',Legacy_Employee_Ref__c='1487557');
            Insert portalUser ;
            system.debug('a1a'+portalUser.Location_Record_Id__c);
            /*Setup Data To insert Programs_and_permissions__c*/
            Programs_and_permissions__c programpermission = new Programs_and_permissions__c();
            programpermission.PermissionSets__c = permission.Name;
            programpermission.Program__c = camp.Id;
            Insert programpermission;
        }
    }

    @future
    private static void insertPermissionSetRecord(){
        /*Setup Data To insert PermissionSet */
        system.debug('insertPermissionSetRecord ***');
        UserLicense uL = [select id, name from userLicense where name = 'GOLD PARTNER'];
        permission.Name = 'TestClassPermissionSet';
        permission.Label = 'TestClassPermissionSet';
        permission.USERLICENSEID = uL.id;
        Insert permission;
        system.debug('permission set inserted ***'+permission);
    }
}