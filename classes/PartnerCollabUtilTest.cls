/***********************************************************
* Class Name: PartnerCollabUtilTest
* Author: Accenture
* Date: 26-JULY-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for PartnerCollabUtil class
***********************************************************/

@isTest
private class PartnerCollabUtilTest {
    private static Account partAcc = new Account();
    private static Account custAcc = new Account();
    private static Contact partContact = new Contact();
    private static Lead testlead = new Lead();
    private static Opportunity opptyTest = new Opportunity();
    private static User partUser111 = new User();
    private static Strike_Count_Track__c strikeCntTest;
    private static Strike_Count_Track__c strikeCntOpptyTest;
    private static Strike_Count_Track__c strikeCntQueueTest;
    private static list<strike_count_track__c> strikeCntTestList = new list<strike_count_track__c>(); 
    //private static List<RecordType> allrecTypes = new List<RecordType>();
    
    
    //setup your test data in this method
    private static void setupData() {
        
        // Create a account with record type - partner
        //partAcc = TestingSetupDataUtil.createAccount('Test Partner Account', 'partner@partnercollab.com','Partner');
        partAcc = TestingSetupDataUtil.createAccount('Test Partner Account', 'partner@apttus.com','Partner');
        insert partAcc;
        
        //Test Location Insertion
        Location__c partLoc=new Location__c(Name='33586574',Account__c=partAcc.Id);
        Insert partLoc;  
           
        // Create a account with record type - customer
        custAcc = TestingSetupDataUtil.createAccount('Test Account', 'custom@partnercollab.com','Customer');
        insert custAcc;
        
        //Enable the account as partner
        partAcc.IsPartner = true;
        partAcc.Partner_Portal_Eligible__c = true;
        partAcc.ShippingCountry = 'China';
        update partAcc;
        
        // Create a contact under the partner account
        partContact = TestingSetupDataUtil.createContact(partAcc.Id, 'Test Contact');
        insert partContact;
        
        // fetch the partner profiles
        List<Profile> partnerProfiles = new List<Profile>();
        partnerProfiles = [Select p.UserType, p.UserLicenseId, p.Name, p.Id From Profile p where p.UserType like '%Partner%' ];
        
        // Create a partner user
        partUser111 = TestingSetupDataUtil.createUser('par1Test','abcw1@hp.com','5_1_PMawbc1@testab.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','partnercoll@partnertest.com',String.valueOf(Math.random()).substring(0,15),partnerProfiles[0].Id );
        partUser111.ContactId = partContact.Id;
        insert partUser111;
        
        // create a lead
        testlead = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Qualified', 'Accepted', '123', 'abcw1@hp.com');
        testlead.Account_Name__c = custAcc.Id;
        testlead.Budget__c = '121' ;
        testlead.Authorized_Buyer__c = 'No';
        testlead.Timeframe_to_Buy_1__c = '< 1 Week';
        testlead.Estimated_Budget__c = 123.0;
        insert testlead;
        
        // Opportunity creation
        opptyTest = TestingSetupDataUtil.createOpportunity(string.valueOf(custAcc.id),'opptyTest', system.today()+ 30);
        opptyTest.Partner_acknowledged__c = false;
        opptyTest.Converted_by_Partner__c = false;
        opptyTest.OwnerId = partUser111.Id;
        opptyTest.Assigned_to_partner_date__c = system.today() - 1;
        insert opptyTest;
        
        strikeCntTest = new Strike_Count_Track__c();
        strikeCntTest.Two_Day_SLA_Date__c = system.today();
        strikeCntTest.User_Assignment_Date__c = system.today() - 2;
        strikeCntTest.Previous_Lead_Owner_Id__c = partUser111.Id;
        strikeCntTest.Partner_Contact__c = partContact.Id;
        strikeCntTest.Partner_Account__c = partAcc.Id;
        strikeCntTest.Partner_Location__c = partLoc.Id;
        strikeCntTest.Owner_Partner_User__c = partUser111.Id;
        strikeCntTest.Lead__c = testlead.Id;
        insert strikeCntTest;
        
        strikeCntOpptyTest = new Strike_Count_Track__c();
        strikeCntOpptyTest.User_Assignment_Date__c = system.today() - 2;
        strikeCntOpptyTest.Partner_Contact__c = partContact.Id;
        strikeCntOpptyTest.Partner_Account__c = partAcc.Id;
        strikeCntOpptyTest.Owner_Partner_User__c = partUser111.Id;
        strikeCntOpptyTest.Opportunity__c = opptyTest.Id;
        insert strikeCntOpptyTest;
        
        strikeCntQueueTest = new Strike_Count_Track__c();
        strikeCntQueueTest.Two_Day_SLA_Date__c = system.today();
        strikeCntQueueTest.Queue_Assignment_Date__c = system.today() - 2;
        strikeCntQueueTest.Previous_Lead_Owner_Id__c = UserInfo.getUserId();
        strikeCntQueueTest.Lead__c = testlead.Id;
        insert strikeCntQueueTest;
        
        strikeCntTestList.add(strikeCntTest);
        strikeCntTestList.add(strikeCntOpptyTest);
        strikeCntTestList.add(strikeCntQueueTest);      
        
        //allrecTypes = [Select SobjectType, Name, Id From RecordType limit 1]; 
                    
     }
     
    //Method for Positive test
    private static testMethod void StrikeTest() {
        Test.startTest();
        setupData();
        
       /* PartnerCollabUtil.emailTemplateNames = new List<String>{'Two_day_lead_update_failure_notification', 'Stale_Lead_notification', 'Opportunity_update_reminder'};
        //PartnerCollabUtil.getRecordTypeName(allrecTypes[0].Id);
        PartnerCollabUtil.isLoggedInPartnerUser();
        PartnerCollabUtil.participatingInPartnerHandling();
        
        PartnerCollabUtil.handleTwoDaySLAs(strikeCntTestList);
        PartnerCollabUtil.handleProactiveNotifications(strikeCntTestList);
        PartnerCollabUtil.handleThirtyDaySLAs(strikeCntTestList);
        PartnerCollabUtil.handleQueueOwnedLeadTracks(new List<Strike_Count_Track__c>{strikeCntQueueTest});
        PartnerCollabUtil.handlUserOwnedLeadTracks(strikeCntTestList);
        
        try{
        PartnerCollabUtil.sendNotifications();
        }catch(exception e){}
        PartnerCollabUtil.getStringFromDate(system.today());
        PartnerCollabUtil.incrementPartnerLocationStrike();
        PartnerCollabUtil.incrementPartnerUserStrike();
        PartnerCollabUtil.updateStrikeDate = strikeCntTestList;
        PartnerCollabUtil.updateStrikeIncrementDate();        
        PartnerCollabUtil.strCntsToDelete = strikeCntTestList;
        PartnerCollabUtil.deleteStrkRecords();*/
        
        PartnerCollabUtil.participatingInPartnerHandling();
        PartnerCollabUtil.handleTwoDaySLAs(strikeCntTestList);
        PartnerCollabUtil.handleQueueOwnedLeadTracks(new List<Strike_Count_Track__c>{strikeCntQueueTest});
        //PartnerCollabUtil.deleteStrkRecords();
        
        
        system.runAs(partUser111){
            PartnerCollabUtil.isLoggedInPartnerUser();
        }
        
        Test.stopTest();
    }
    
}