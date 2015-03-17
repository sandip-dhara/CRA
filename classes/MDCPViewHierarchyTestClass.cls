/**********************************************************
* Class Name: MDCPViewHierarchyTestClass 
* Author: Vijay Ranjan
* Date: 30-APR-2013
* Description: This class does the test coverage for MDCPViewHierarchyTestClass  class. 
***********************************************************/
@isTest(SeeAllData=true) 
private class MDCPViewHierarchyTestClass {
static testMethod void validateMDCPViewHierarchyTestClass() {
ID testAccountID1=[Select Id from Account where MDCP_Organization_ID__c=:Label.MDCPViewHieratchyTestRecord limit 1].id;
Test.setCurrentPageReference(new PageReference('Page.MDCPViewAccountHierarchy')); 
System.currentPageReference().getParameters().put('id',testAccountID1);
MDCPViewHierarchyController ssc = new MDCPViewHierarchyController();
ssc.getAccountId();
       
}
}