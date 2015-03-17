@isTest(SeeAllData=true) 
private class WonLostBeforeInsertUpdateTest {

    static testMethod void testTriggerPrimaryComp_Part() {
        
        List<Account> listAccount = new List<Account>();
        
        //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Customer');
        listAccount.add(account1);

        //Create Channel Partner Account
         Account channelPartnerAcc = TestingSetupDataUtil.createAccount('Partner Account2', 'tezt3cht@test.com', 'Partner');
        channelPartnerAcc.Channel_Partner_Flag__c = true;
        listAccount.add(channelPartnerAcc);
        
        //Create competitor1 Account
        Account compAcc1 = TestingSetupDataUtil.createAccount('competitor Account1','ztezt1@test.com','Competitor');
        listAccount.add(compAcc1);
        
        //Create competitor2 Account
        Account compAcc2 = TestingSetupDataUtil.createAccount('competitor Account2','ztezt2@test.com','Competitor');
        listAccount.add(compAcc2);

        
        insert listAccount;
        //System.assertEquals(listAccount.size(), 3);
        
        //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account1.Id,'tarunOppty1',System.today().addMonths(1));
        insert opty;
        System.assertEquals(opty.Name,'tarunOppty1');
        
        //Associate channel partner and make it primary
        //Channel_Partner__c channelPartner3 = new Channel_Partner__c();
        Channel_Partner__c channelPartner3 = TestingSetupDataUtil.createChannelPartner(opty.Id,'Channel Partner',channelPartnerAcc.Id);
        system.debug('Channel partner opptyId'+opty.Id);

        channelPartner3.Primary__c = true;
        insert channelPartner3;
        //System.assertEquals(channelPartner3.Name,'Channel Partner');
        
        //Create primary competitor
            Competitors__c competitor1 =  new Competitors__c();
            competitor1.Opportunity__c = opty.Id;
            system.debug('opptyId'+opty.Id);
            competitor1.competitor_Account__c = compAcc1.Id;
            competitor1.Primary__c = true;
            insert competitor1;
            
        //Create Incumbent competitor
            Competitors__c competitor2 =  new Competitors__c();
            competitor2.Opportunity__c = opty.Id;
            competitor2.competitor_Account__c = compAcc2.Id;
            competitor2.Incumbent__c = true;
            insert competitor2; 
            
            
         Won_Lost_Analysis__c WonLost = new Won_Lost_Analysis__c(Opportunity__c=opty.id,Select__c='Teaming / Partnering');
         Won_Lost_Analysis__c WonLost1 = new Won_Lost_Analysis__c(Opportunity__c=opty.id,Select__c='Teaming / Partnering'); 
         test.startTest();
         insert WonLost;
         //insert WonLost1;
         update WonLost;

         test.stopTest();

        
        }
}