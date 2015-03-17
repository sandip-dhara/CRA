/***********************************************************
* Class Name: PartnerOpptyHomePageListControllerTest
* Author: Accenture
* Date: 25-JULY-2012 
* Requirement # Request Id: 
* * Description: This class does the test coverage 
*              for ChannelPartnerTriggerController class.
***********************************************************/

@isTest
private class PartnerOpptyHomePageListControllerTest{
    static Account accountTest;
    static Opportunity opptyTest;
    static Opportunity opptyTest1;
    static Opportunity opptyTest2;
    static Opportunity opptyTest3;
    static Opportunity opptyTest4;
    static Opportunity opptyTest5;
    static Opportunity opptyTesttrue;
    static list<opportunity> opptyTestList = new list<opportunity>(); 

    private static void setupData(){
    
        // Account creation
        accountTest = TestingSetupDataUtil.createAccount('accountTest', 'EmailAccount@email.com','Customer');
        insert accountTest;
        
        // Opportunity creation
        opptyTest = TestingSetupDataUtil.createOpportunity(string.valueOf(accountTest.id),'opptyTest', system.today()+ 30);
        opptyTest.Partner_acknowledged__c = false;
        opptyTest.Converted_by_Partner__c = false;
        opptyTest.OwnerId = userInfo.getUserId();
        opptyTest.Assigned_to_partner_date__c = system.today() - 8;
        
        opptyTesttrue = TestingSetupDataUtil.createOpportunity(string.valueOf(accountTest.id),'opptyTest', system.today()+ 30);
        opptyTesttrue.Partner_acknowledged__c = true;
        opptyTesttrue.Converted_by_Partner__c = false;
        opptyTesttrue.OwnerId = userInfo.getUserId();
        opptyTesttrue.Assigned_to_partner_date__c = system.today() - 8;
             
        opptyTest1 = TestingSetupDataUtil.createOpportunity(string.valueOf(accountTest.id),'opptyTest', system.today()+ 30);
        opptyTest1.Partner_acknowledged__c = false;
        opptyTest1.Converted_by_Partner__c = false;
        opptyTest1.OwnerId = userInfo.getUserId();
        opptyTest1.Assigned_to_partner_date__c = system.today() - 8;
               
        opptyTest2 = TestingSetupDataUtil.createOpportunity(string.valueOf(accountTest.id),'opptyTest', system.today()+ 30);
        opptyTest2.Partner_acknowledged__c = false;
        opptyTest2.Converted_by_Partner__c = false;
        opptyTest2.OwnerId = userInfo.getUserId();
        opptyTest2.Assigned_to_partner_date__c = system.today() - 8;
        
        opptyTest3 = TestingSetupDataUtil.createOpportunity(string.valueOf(accountTest.id),'opptyTest', system.today()+ 30);
        opptyTest3.Partner_acknowledged__c = false;
        opptyTest3.Converted_by_Partner__c = false;
        opptyTest3.OwnerId = userInfo.getUserId();
        opptyTest3.Assigned_to_partner_date__c = system.today() - 8;
        
        opptyTest4 = TestingSetupDataUtil.createOpportunity(string.valueOf(accountTest.id),'opptyTest', system.today()+ 30);
        opptyTest4.Partner_acknowledged__c = false;
        opptyTest4.Converted_by_Partner__c = false;
        opptyTest4.OwnerId = userInfo.getUserId();
        opptyTest4.Assigned_to_partner_date__c = system.today() - 8;

        opptyTest5 = TestingSetupDataUtil.createOpportunity(string.valueOf(accountTest.id),'opptyTest', system.today()+ 30);
        opptyTest5.Partner_acknowledged__c = false;
        opptyTest5.Converted_by_Partner__c = false;
        opptyTest5.OwnerId = userInfo.getUserId();
        opptyTest5.Assigned_to_partner_date__c = system.today() - 1;

        
        opptyTestList.add(opptyTest);
        opptyTestList.add(opptyTest1);
        opptyTestList.add(opptyTest2);
        opptyTestList.add(opptyTest3);
        opptyTestList.add(opptyTest4);
        opptyTestList.add(opptyTest5);
         opptyTestList.add(opptyTesttrue);
        insert opptyTestList;
    }
    
     private static testMethod void constructorTest(){
        Test.startTest();
        setupData();
        apexPages.StandardSetController stdSetController = new apexPages.StandardSetController(opptyTestList);
        PartnerOpptyHomePageListController partCntrl = new PartnerOpptyHomePageListController();
        partCntrl.selectedOppty=opptyTesttrue.Id;
        partCntrl.getOpportunities();
        partCntrl.ackOppty();
        partCntrl.first();
        partCntrl.previous();
        partCntrl.next();
        partCntrl.last();
        stdSetController.getHasNext();
        stdSetController.getHasPrevious();
        stdSetController.getPageNumber(); 
     }
}