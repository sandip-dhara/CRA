/**********************************************************
* Class Name: ExistingRenwaloptyLookupTest
* Author: HP
* Date: 25-July-2012 
* Description: This class does the test coverage for ExistingRenwaloptyLookup class. 
***********************************************************/
@isTest
private class ExistingRenwaloptyLookupTest {

    static testMethod void testExistingRenwaloptyLookup() {
        
        ApexPages.currentPage().getParameters().put('lksrch', 'test');
        System.runAs(TestingSetupDataUtil.testUser) {
            test.startTest();
            ExistingRenwaloptyLookup addRenLkpController = new ExistingRenwaloptyLookup();
            addRenLkpController.getFormTag();
            addRenLkpController.getIsResultEmpty();
            addRenLkpController.getTextBox();
           addRenLkpController.initialize();
            system.assert(addRenLkpController.searchText != null, true);
            test.stopTest();
        }        
    }
}