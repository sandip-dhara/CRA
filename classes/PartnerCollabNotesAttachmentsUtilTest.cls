/***********************************************************
* Class Name: PartnerCollabNotesAttachmentsUtilTest
* Author: Accenture
* Date: 25-JULY-2012 
* Requirement # Request Id: 
* * Description: This class does the test coverage 
*              for PartnerCollabNotesAttachmentsUtil class.
***********************************************************/

@isTest
private class PartnerCollabNotesAttachmentsUtilTest {
	private static Account account1 = new Account();
	private static Account account2 = new Account();
	private static Contact contact1 = new Contact();
	private static User partUser = new User();
	private static Opportunity opptyTest = new Opportunity();
	private static Lead testlead = new Lead();
	
	private static void setupData(){
	// Create a account with record type - partner
	account1 = TestingSetupDataUtil.createAccount('Test Partner Account', 'partner@partnercollab.com','Partner');
	insert account1;
	account2 = TestingSetupDataUtil.createAccount('Test Account', 'custom@partnercollab.com','Customer');
	insert account2;
	account1.IsPartner = true;
	update account1;
	
	// Create a contact under the partner account
	contact1 = TestingSetupDataUtil.createContact(account1.Id, 'Test Contact');
	insert contact1;
	
	
	List<Profile> partnerProfiles = new List<Profile>();
	partnerProfiles = [Select p.UserType, p.UserLicenseId, p.Name, p.Id From Profile p where p.UserType like '%Partner%' ];
	
	// Create a user and enable it as a partner
	partUser = TestingSetupDataUtil.createUser('partTest','abcw@testab.com','5_1_PMawbc@testab.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saweest@ca.com','55245615',partnerProfiles[0].Id );
	partUser.ContactId = contact1.Id;
	insert partUser;
	
	// Opportunity creation
	opptyTest = TestingSetupDataUtil.createOpportunity(string.valueOf(account2.id),'opptyTest', system.today()+ 30);
	opptyTest.Partner_acknowledged__c = false;
	opptyTest.Converted_by_Partner__c = false;
	opptyTest.OwnerId = partUser.Id;
	opptyTest.Assigned_to_partner_date__c = system.today() - 1;
	insert opptyTest;
	
	// create a lead
	testlead = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Qualified', 'Accepted', '123', 'test@test.com');
	testlead.OwnerId = partUser.Id;
	testlead.Budget__c = '121' ;
	testlead.Authorized_Buyer__c = 'No';
	testlead.Timeframe_to_Buy_1__c = '< 1 Week';
	testlead.Estimated_Budget__c = 123.0;
	insert testlead;
	
	}
	
	private static testMethod void insertNotesTest(){
		setupData();
		system.runAs(partUser){
			Note testNote = new Note(Title = 'Test', ParentId = opptyTest.Id, OwnerId = partUser.Id, Body = 'Test Note Boody');
			insert testNote;
			update testNote;
			Blob testAttachmentBlob = Blob.valueOf('Test Note Boody');
			Attachment testAttachment = new Attachment(Name = 'Test', ParentId = testlead.Id, OwnerId = partUser.Id, Body = testAttachmentBlob);
			insert testAttachment;
			update testAttachment;
		}
	}
}