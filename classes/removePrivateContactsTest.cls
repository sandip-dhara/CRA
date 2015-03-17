/**********************************************************
* Class Name: removePrivateContactsTest 
* Author: Vijay Ranjan
* Date: 28-MAY-2013
* Description: This class does the test coverage for removePrivateContacts class. 
***********************************************************/
@isTest
private class removePrivateContactsTest {
static testMethod void ValidateremovePrivateContactsTest() {
List<Contact>contactlist=new  List<Contact>();
Contact testContact = new Contact(LastName='Test name',email='abc@test.com');
insert testContact; 
contactlist.add(testContact);
ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(contactlist);
removePrivateContacts remconobj = new removePrivateContacts (ssc);
remconobj.deleteContacts(); 
Account testAccount2 = new Account(Name='TestAccount2',ShippingCountry='india');
insert testAccount2; 
testContact.AccountID=testAccount2.id;
contactlist.clear();
contactlist.add(testContact);
remconobj.arryContact=contactlist;
remconobj.deleteContacts(); 
remconobj.returnPage();
}
}