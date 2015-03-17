/**********************************************************
* Class Name: ChangeEloquaEmailAddressClsTest
* Author: Accenture
* Date: 25-AUG-2012  
* Requirement # Request Id: 
* Description: Test class for ChangeEloquaEmailAddressCls
*************************************************************/
@isTest
private class ChangeEloquaEmailAddressClsTest {

    private static List<Lead> newLeads;
    private static List<Contact> newContacts;
    /**
	* Method for creating test data.
	*/
	private static void setUpData(){
		//Create a test account
        Account acc = TestingSetupDataUtil.createAccount('elqaAccount_952PM', 'elqaAccount_9@mail.com','Customer');
        insert acc;
        
        //Insert Lead
        newLeads = new List<Lead>();       
        Lead newLead = TestingSetupDataUtil.createLead('elqaLead1', 'elq123', 'Open', 'Accepted', '123', '');
        newLead.Account_Name__c = acc.Id;
        newLead.Budget__c = '121' ;
        newLead.Authorized_Buyer__c = 'No';
        newLead.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead.Estimated_Budget__c = 123.0;
        
        Lead newLead1 = TestingSetupDataUtil.createLead('elqaLead2', 'elq123', 'Open', 'Accepted', '123', 'test@unknown.elq');
        newLead1.Account_Name__c = acc.Id;
        newLead1.Budget__c = '121' ;
        newLead1.Authorized_Buyer__c = 'No';
        newLead1.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead1.Estimated_Budget__c = 123.0;
        
        newLeads.add(newLead);
        newLeads.add(newLead1);
        
        insert newleads;
        
        // Insert contact
        newContacts = new List<Contact>();
        Contact contact1 = new Contact();
        contact1 =  TestingSetupDataUtil.createContact(acc.Id, 'TestElqua0');
        contact1.Email = 'elqa@unknoen.elq';
        Contact contact2 = new Contact();
        contact2 =  TestingSetupDataUtil.createContact(acc.Id, 'TestElqua1');         
        
        newContacts.add(contact1);
        newContacts.add(contact2);
        insert newContacts;
        
	}
	
	/**
	* @description: Test Method to test change eloqua email for lead and contact
	*/
	static testMethod void ChangeElquaEmailTest() {
	
		Test.startTest();
		setUpData();
		
		newleads[1].Email = 'test@unknown.com';
		newContacts[0].Email = 'testElqaC@unknown.com';
		try {
			update newleads;
			update newContacts;
		}catch(Exception ex){
		}
		Test.stopTest();
 	}	
}