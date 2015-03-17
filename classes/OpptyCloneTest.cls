/**
 *@author: manasa.r (hp)
 * This class contains unit tests for validating the behavior of clone functionality
 *      1) OpptyCloneTest
 *      2) OpportunityAfterInsert
 * ::  Author HP
 */
@isTest (seeAllData = true)
private class OpptyCloneTest {
    
    private static Account acc;
    private static Opportunity opty;
     private static void setUpData(){
        system.debug('Enter setUpData()');
        //Create a test account
        acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        opty.Type = 'New Business';
        opty.Route_To_Market__c = 'Direct';
        insert opty;
     }

    static testMethod void OpptyClonePositive() {
        // TO DO: implement unit test
        PageReference pageRef = Page.OpptyClone;
        Test.setCurrentPage(pageRef);
        
    ApexPages.standardController controller = new ApexPages.standardController(new Opportunity());
    Test.startTest();
    setUpData();
    Test.stopTest();
        ApexPages.currentPage().getParameters().put('id',opty.Id);
        OpptyClone optCloneTest = new OpptyClone(controller);
        optCloneTest.Competitor = true;
        optCloneTest.Partner = true;
        optCloneTest.Product = true;
        
        optCloneTest.Go();
    } 
    static testMethod void OpptyCloneNegative() {
        // TO DO: implement unit test
        PageReference pageRef = Page.OpptyClone;
        Test.setCurrentPage(pageRef);
        
    ApexPages.standardController controller = new ApexPages.standardController(new Opportunity());
    Test.startTest();
    setUpData();
    Test.stopTest();
        ApexPages.currentPage().getParameters().put('id',opty.Id);
        OpptyClone optCloneTest = new OpptyClone(controller);
        optCloneTest.Competitor = true;
       
        optCloneTest.Go();
    } 
}