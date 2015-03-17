/**********************************************************
* Class Name: AccountSearchControllerTest 
* Author: Vijay Ranjan
* Date: 28-MAY-2013
* Description: This class does the test coverage for MDCPSyncController class. 
***********************************************************/
@isTest
private class AccountSearchControllerTest {
static testMethod void ValidateAccountSearchController() {

Account testAccount = new Account(Name='Test',ShippingCountry='india',MDCP_Organization_ID__c='1234');
insert testAccount; 
Account testAccount2 = new Account(Name='TestAccount2',ShippingCountry='india');
insert testAccount2; 
 ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
AccountSearchController  MDCPobj = new AccountSearchController(sc);
 AccountSearchController.AccountWrapper  testwrapper =new  AccountSearchController.AccountWrapper();
 testwrapper.checked=true; 
 list<AccountSearchController.AccountWrapper> val=new list<AccountSearchController.AccountWrapper>();
 val.add(testwrapper);
MDCPobj.selectedAccounts=val;
list<id> idlist=new list<id>(); 
idlist.add(testAccount.id);
idlist.add(testAccount2.id);
MDCPobj.AcntId =testAccount.id;
//system.debug('idlist====='+idlist);
MDCPobj.MergeIds.add(testAccount2.id);
MDCPobj.searchText='test';
MDCPobj.search();
MDCPobj.searchResults=val; 
MDCPobj.AccountMerge();
MDCPobj.next();
MDCPobj.back();
AccountSearchController.AccountWrapper  wrapperobj2=new  AccountSearchController.AccountWrapper(testAccount); 
wrapperobj2.checked=true; 
list<AccountSearchController.AccountWrapper> wrapperlst=new list<AccountSearchController.AccountWrapper>();
AccountSearchController abc=new AccountSearchController();
MDCPobj.searchText='test';
MDCPobj.search();
MDCPobj.searchResults=val; 
MDCPobj.mdcpId='1234';
MDCPobj.search();
}
}