/**********************************************************
* Class Name: ContactCustomLookupControllerTest
* Author: HP
* Date: 08-Oct-2012 
* Description: This class does the test coverage for ContactCustomLookupControllerTest class. 
***********************************************************/
@isTest(SeeAllData=True)
private class ContactCustomLookupControllerTest {
    Public static Contact testContact;
    Public static Account acc;
    Public static Opportunity opty;
    Public static OpportunityContactRole OCR;
    Public static Opportunity_Plan__c Op;
    Public static string PageParam;
    static testMethod void testContactCustomLookupController() {
        acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
         //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        {
        opty.StageName = '01 - Understand Customer';
        }
        insert opty;
        testContact =  TestingSetupDataUtil.createContact(acc.Id, 'TestLastName');
        testContact.Email='testcontact@testing.com';
        insert testContact;
        OCR = New OpportunityContactRole();
        OCR.Contactid = testcontact.id;
        OCR.OpportunityId = opty.id; 
        //OCR.Name = 'Deepak';
        Insert OCR;
        op = New Opportunity_Plan__c();
        op.Opportunity__c = opty.id;
        insert op;
        pageReference Pr = page.ContactCustomLookup;
        test.SetCurrentPage(pr);
        PageParam = 'test' + ',' + opty.id + ',' + op.id;
        ApexPages.currentPage().getParameters().put('lksrch', PageParam);
        System.runAs(TestingSetupDataUtil.testUser) {
            test.startTest();
            ContactCustomLookupController ConCusLkpController = new ContactCustomLookupController();
            ConCusLkpController.getFormTag();
            ConCusLkpController.getIsResultEmpty();
            ConCusLkpController.getTextBox();
            ConCusLkpController.initialize();
            system.assert(ConCusLkpController.searchText != null, true);
            test.stopTest();
        }        
    }
}