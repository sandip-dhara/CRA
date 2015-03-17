/**********************************************************
* Class Name: DealReg_SuccessRedirectionControllerTest
* Author: HP
* Date: 15-OCT-2012 
* Description:This class contains the test code coverage for the class "DealRegSuccessRedirectionController"
***********************************************************/
@isTest(seeAllData = true)
Private class DealReg_SuccessRedirectionControllerTest{ 
static testMethod void testDealReg_SuccessRedirectionController(){

    //Test Account Insertion 
    Account newAcc=DealTestDataUtil.createAccount('Test Account11');
    Insert newAcc;

    //Test opportunity Insertion              
    Opportunity newOppty=DealTestDataUtil.createOpportunity(newAcc.Id,'Test Opty11',Date.today());
    Insert newOppty;
       
    test.startTest();
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.DealReg_Success_SubmissionPage;       
        // set the page to the success page
        Test.setCurrentPage(pageRef);
        // Set Opportunity id
        ApexPages.currentPage().getParameters().put('id', newOppty.Id);  
        ApexPages.StandardController newController = new ApexPages.Standardcontroller(newOppty);
        // new controller
        DealReg_SuccessRedirectionController SuccessRedirection= new DealReg_SuccessRedirectionController(newController);
        SuccessRedirection.getsuccess();
        SuccessRedirection.sucessMessage();
    test.stopTest();
}
}