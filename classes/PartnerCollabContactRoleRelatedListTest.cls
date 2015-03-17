/**
* Class Name: PartnerCollabContactRoleRelatedListTest
* Author: Accenture
* Date: 13-JULY-2012 
* Description: Test class PartnerCollabContactRoleRelatedList
*/
@isTest
private class PartnerCollabContactRoleRelatedListTest {
	private static Account account1 = new Account();
	private static Account account2 = new Account();
	private static Contact contact1 = new Contact();
	private static User partUser = new User();
	private static Opportunity opptyTest = new Opportunity();
	
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
	
	// Opportunity creation
	opptyTest = TestingSetupDataUtil.createOpportunity(string.valueOf(account2.id),'opptyTest', system.today()+ 30);
	opptyTest.Partner_acknowledged__c = false;
	opptyTest.Converted_by_Partner__c = false;
	opptyTest.OwnerId = UserInfo.getUserId();
	opptyTest.Assigned_to_partner_date__c = system.today() - 1;
	insert opptyTest;
	
	}
	
	private static testMethod void ContactRoleRelatedList(){        
        Test.StartTest();
        //System.currentPageReference().getParameters().put('opptyId',opp.Id);
        ApexPages.StandardController controller01 = new ApexPages.StandardController(opptyTest);
        ContactRoleRelatedListController obj = new ContactRoleRelatedListController(controller01);
        Test.StopTest(); 	
	}
}