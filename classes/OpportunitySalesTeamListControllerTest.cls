/**********************************************************
* Class Name: OpportunitySalesTeamListControllerTest
* Author: Accenture
* Date: 5-May-2012   
* Description: This class does the test coverage for OpportunitySalesTeamListController class. 
***********************************************************/

@isTest(SeeAllData=true)
private class OpportunitySalesTeamListControllerTest{
     static OpportunitySalesTeamListController oppSalesTeamListController;
     static Boolean flagValue;
     static PageReference pageRef;
     
     static testMethod void constructorTest(){
       
    /*String RecordTypeId ='';
        try {
            RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        } catch(Exception e) {
            System.debug('>>> Exception: '+e.getMessage());
        }
        */
        
        //Create a test account
        Account acc =TestingSetupDataUtil.createAccount('testAccount','accountEmail@test.com','Customer');
        insert acc;
        
        //generate Random String 
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        
        // Insert User
        
        /********************************
        * Author: Accenture
        * Modified: 10-AUG-2012
        * Update: Updated the parameter for employee ID to a random string
        * CR#: CR-0123
        *********************************/
        
        User userTest =TestingSetupDataUtil.createUser('DA_'+randomstr.substring(0,4),randomstr+'userTest@hp.com',randomstr+'userTest@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com',randomstr,Userinfo.getProfileId());
        userTest.Business_Group__c = 'PSG';
        userTest.Global_Business_Unit__c = 'BI';
        insert userTest ;
        
        profile pf=[select id,name from Profile where name like '%Admin%' limit 1];
        User userTest1 =TestingSetupDataUtil.createUser('DA_'+randomstr.substring(0,4),randomstr+'userTest1@hp.com',randomstr+'userTest1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest1@hp.com','56545236',Userinfo.getProfileId());
        userTest1.Business_Group__c = 'PSG';
        userTest1.Global_Business_Unit__c = 'BI';
        insert userTest1 ;
        
        Opportunity newOpp1 = TestingSetupDataUtil.createOpportunity(acc.Id, 'opp3', system.today()+ 30);
         newOpp1.OwnerId = usertest1.id;
         newOpp1.Owner__c = usertest1.id;
         newOpp1.stagename='02 - Validate Opportunity';
         insert newOpp1;
        //Insert Opportunity
        Opportunity newOpp = TestingSetupDataUtil.createOpportunity(acc.Id, 'opp2', system.today()+ 30);
         newOpp.OwnerId = UserInfo.getUserId();
         newOpp.Owner__c = UserInfo.getUserId();
         newOpp.stagename='02 - Validate Opportunity';
         insert newOpp;
        
        OpportunityShare opShare =  TestingSetupDataUtil.createOpportunityShare('Edit',userTest.Id ,newOpp.Id);
        insert opShare;

        OpportunityTeamMember oppMem1 = TestingSetupDataUtil.createOpportunityTeamMember(userTest.Id ,'Sales Manager',newOpp.Id);
        insert OppMem1;
        
         ApexPages.Standardcontroller stdcontroller1 = new ApexPages.StandardController(newOpp1);  
        oppSalesTeamListController = new OpportunitySalesTeamListController(stdcontroller1); 
        //Testing Constructor
        ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(newOpp);  
        oppSalesTeamListController = new OpportunitySalesTeamListController(stdcontroller); 
        
        Test.startTest();

        PageReference pg = Page.OpportunitySalesTeamList;       
        pg.getParameters().put('teamMemberID',oppMem1.Id);

        Test.setCurrentPage(pg);

        //Testing  AccountTeamMembersListEmpty flag 
        flagValue = oppSalesTeamListController.getisOpportunityTeamMembersListEmpty();
        System.assertNotEquals(null, flagValue);                


        oppSalesTeamListController.fetchOpportunityTeamMembers();
        oppSalesTeamListController.getBusinessGroups();
        oppSalesTeamListController.viewData();
        oppSalesTeamListController.setSortDirection('ASC');
        oppSalesTeamListController.getSortDirection();

        oppSalesTeamListController.setSortDirection('DESC');
        oppSalesTeamListController.getSortDirection();

        oppSalesTeamListController.addDefaultSalesTeam();
       
        oppSalesTeamListController.deleteTeamMember();

        Test.stopTest();
   }
}