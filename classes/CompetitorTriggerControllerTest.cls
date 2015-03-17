/***********************************************************
* Class Name: CompetitorTriggerControllerTest
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* * Description: This class does the test coverage
*              for CompetitorTriggerController class.
***********************************************************/
@isTest(SeeAllData = true)
private class CompetitorTriggerControllerTest {

    static testMethod void testCompetitorTriggerController() {
    
        List<Account> listAccount = new List<Account>();
        //Create Account for opty
        Account account1 = TestingSetupDataUtil.createAccount('Test Account','tezt4@test.com','Customer');
        listAccount.add(account1);
        
        //Create competitor1 Account
        Account compAcc1 = TestingSetupDataUtil.createAccount('competitor Account1','ztezt1@test.com','Competitor');
        listAccount.add(compAcc1);
        
        Account compAcc2 = TestingSetupDataUtil.createAccount('competitor Account2','ztezt2@test.com','Competitor');
        listAccount.add(compAcc2);
        
        insert listAccount;
        
        //Create Opty
        Opportunity opty =TestingSetupDataUtil.createOpportunity(account1.Id,'Default Opty098',System.today().addMonths(1));
        opty.managed_by__c='HP';
        insert opty;
        
        System.runAs(TestingSetupDataUtil.testUser) {
        test.startTest();
        
        competitors__c competitor1 =  new Competitors__c();
        competitor1.Opportunity__c = opty.Id;
        competitor1.competitor_Account__c = compAcc1.Id;
        insert competitor1;
        
        competitors__c competitor2 =  new Competitors__c();
        competitor2.Opportunity__c = opty.Id;
        competitor2.competitor_Account__c = compAcc2.Id;
        competitor2.Primary__c = true;
        insert competitor2;
        
        system.debug('competitor1-'+competitor1.Primary__c);
        
        system.assert(competitor1.Primary__c == false,true);
        
        Map<Id, Competitors__c> CompetitorOldMap = new Map<Id, Competitors__c>();
        CompetitorOldMap.put(competitor1.Id, competitor1);
        competitor1.Primary__c = true;
        update competitor1;
        //system.assert(competitor2.Primary__c == true,true);
                    
        
        Map<Id, Competitors__c> CompetitorNewMap = new Map<Id, Competitors__c>();
        CompetitorNewMap.put(competitor1.Id, competitor1);
        CompetitorTriggerUtil.isTest = true;
        //new Map<id,Competitors__c> {}
        CompetitorTriggerUtil.checkIsPrimaryFlagOnInsert(CompetitorNewMap);
        CompetitorTriggerController.afterUpdate(CompetitorOldMap, CompetitorNewMap);
        Delete competitor1;
        
        test.stopTest();
        }
    }
}