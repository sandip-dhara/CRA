/**********************************************************
* Class Name: AddCompetitorsControllerTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage 
*              for AddCompetitorsController class. 
***********************************************************/
@isTest
private class AddCompetitorsControllerTest {

    static testMethod void testAddCompetitorsController() {
        //Create Account for opty     
        Account account = TestingSetupDataUtil.createAccount('Test Account', 'tezt1@test.com','Customer');
        
        //Create competitor1 Account
        Account compAcc1 = TestingSetupDataUtil.createAccount('competitor Account1', 'tezt1@test.com','Competitor');
        Account compAcc2 = TestingSetupDataUtil.createAccount('competitor Account2', 'tezt1@test.com','Competitor');
        
        //creating list of accounts
        List<Account> listAccount = new List<Account>();      
        listAccount.add(account);
        listAccount.add(compAcc1);
        listAccount.add(compAcc2);
        insert listAccount;
        
        //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account.Id, 'Default Opty',System.today().addMonths(1));
        insert opty;
        
        //Create competitor1
        Competitors__c competitor1 =  new Competitors__c();
        Competitors__c competitor2 =  new Competitors__c();
        competitor1.competitor_Account__c = compAcc1.Id;
        competitor1.Primary__c = true;
        
        System.runAs(TestingSetupDataUtil.testUser) {
            Test.startTest();
            system.assert(competitor1.Primary__c, true);
            PageReference pageRef = Page.AddCompetitors;
            Test.setCurrentPageReference(pageRef);
/*//Update
            ApexPages.currentPage().getParameters().put('CF00NK0000000VKke_lkid', null);
            ApexPages.currentPage().getParameters().put('retURL', '/' + null);
            ApexPages.StandardController stdCont = new ApexPages.StandardController(competitor2);
            AddcompetitorsController addCompCont = new AddcompetitorsController(stdCont);
            addCompCont.checkOptyEditAccess();

//End   */      
            ApexPages.currentPage().getParameters().put('CF00NK0000000VKke_lkid', opty.Id);
            ApexPages.currentPage().getParameters().put('retURL', '/' + opty.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(competitor1);
            AddcompetitorsController addCompController = new AddcompetitorsController(stdController);
            
            addCompController.checkOptyEditAccess();
            addCompController.oppID = opty.Id;
            addCompController.checkOptyEditAccess();
            //system.assert()
            //set competitor id in competitor list bound in page
            if (addCompController.competitorList != null && 
                 addCompController.competitorList.size() > 0) {
                
                //add already added competitor account
                addCompController.competitorList[0].competitor.competitor_Account__c = compAcc1.Id;
                addCompController.competitorList[0].competitor.Primary__c = true;
                addCompController.save();
                
                //add valid data
                addCompController.competitorList[0].competitor.competitor_Account__c = compAcc2.Id;
                addCompController.competitorList[0].competitor.Primary__c = true;
                addCompController.save();
                
                //add same account twice
                if(addCompController.competitorList.size() > 1) { 
                    addCompController.competitorList[0].competitor.competitor_Account__c = compAcc2.Id;
                    addCompController.competitorList[1].competitor.competitor_Account__c = compAcc2.Id;
                    addCompController.save();
                }
            }
            addCompController.oppID = null;
            ApexPages.currentPage().getParameters().put('oppId', opty.Id);
            ApexPages.StandardController stdCont = new ApexPages.StandardController(competitor1);
            AddcompetitorsController addCompCont = new AddcompetitorsController(stdCont);
            addCompCont.checkOptyEditAccess();
            
            Test.stopTest();
        }
            
    }
}