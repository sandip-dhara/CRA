/***********************************************************
* Class Name: PartnerCollabLeadUtilTest
* Author: Accenture
* Date: 26-JULY-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for PartnerCollabLeadUtil class
***********************************************************/

@isTest(SeeAllData=true)
private class PartnerCollabLeadUtilTest{
    private static Account partAcc = new Account();
    private static Account custAcc = new Account();
    private static Contact partContact = new Contact();
    private static User partUser = new User();
    private static User intUser = new User();
    private static Lead testlead = new Lead();
    private static set<id> leadIdSet = new set<id>();
    private static map<id, lead> oldMap = new map<id, lead>();
    private static map<id, lead> newMap = new map<id, lead>();
    private static set<id> ownerIds;
    private static list<Group> partQueue;
    //private static QueueSobject partQueueSObject = new QueueSobject();
    private static list<RecordType> qualifiedRecTypeId = new list<RecordType>();
    private static string partAccQueue;
    
    //setup your test data in this method
    private static void setupData() {
        
        // Create a account with record type - partner
        partAcc = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1211@partnercollab.com','Partner');
        partAcc.Partner_Portal_Eligible__c = true;
        insert partAcc;
        
        //Enable the account as partner
        partAcc.IsPartner = true;
        partAcc.Partner_Portal_Eligible__c = true;
        update partAcc;
        
        // Create a contact under the partner account
        partContact = TestingSetupDataUtil.createContact(partAcc.Id, 'Test Contact');
        insert partContact;
        
        // Create a account with record type - customer
        custAcc = TestingSetupDataUtil.createAccount('Test Account', 'custom@partnercollab.com','Customer');
        insert custAcc;
        
        // fetch the partner profiles
        List<Profile> partnerProfiles = new List<Profile>();
        partnerProfiles = [Select p.UserType, p.UserLicenseId, p.Name, p.Id From Profile p where p.UserType like '%Partner%' ];
        
        // Create a partner user
        partUser = TestingSetupDataUtil.createUser('par1Test','abcw1@hp.com','5_1_PMawbc1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','partnercoll@hp.com','55145615',partnerProfiles[0].Id );
        partUser.ManagerId = userInfo.getUserId(); 
        partUser.ContactId = partContact.Id;
        insert partUser;

        // Create an internal user
        intUser = TestingSetupDataUtil.createUser('int1Test','interna1l@hp.com','int_1231@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','internalpat@hp.com','55248615',userInfo.getProfileId());
        intUser.Partner_Collaboration_Participating_User__c = true;
        intUser.Adoption_Role_Type__c='IT';
        intUser.ManagerId = userInfo.getUserId();
        insert intUser;
        
        // create a lead
        testlead = TestingSetupDataUtil.createLead('partTestlead', 'partCompany', 'Qualified', 'Accepted', '348536856', 'testEmail@test.com');
        testlead.OwnerId = intUser.Id;
        testlead.Status = 'Working';
        testlead.Account_Name__c = custAcc.Id;
        testlead.Budget__c = '121' ;
        testlead.Authorized_Buyer__c = 'No';
        testlead.Timeframe_to_Buy_1__c = '< 1 Week';
        testlead.Estimated_Budget__c = 123.0;
        insert testlead;

     }
     
    //Method for Positive test
    private static testMethod void PositiveTest() {
        setupData();

        Test.startTest();
        
        // Get the record type Id of qualified lead
        qualifiedRecTypeId = [Select Id From RecordType where SobjectType = 'lead' and Name = 'qualified lead' limit 1];
        testlead.RecordTypeId = qualifiedRecTypeId[0].Id;
        
        // initialize set
        leadIdSet.add(testlead.Id);
        
        oldMap.put(testlead.Id, testlead);
        System.runAs(intUser){
            testlead.OwnerId = partUser.Id;
            update testlead;
            
            testlead.OwnerId = intUser.Id;
            update testlead;
        }
        newMap.put(testlead.Id, testlead);
        PartnerCollabLeadUtil.queueAssignmentHandler(leadIdSet, oldMap, newMap);       
        
        Test.stopTest();
    }
}