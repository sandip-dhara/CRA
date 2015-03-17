/***********************************************************
* Class Name: ChannelPartnerTriggerControllerTest
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* * Description: This class does the test coverage 
*              for ChannelPartnerTriggerController class.
***********************************************************/
@isTest
private class ChannelPartnerTriggerControllerTest {

    static testMethod void testChannelPartnerTriggerController() {

        //(Map<id,Channel_Partner__c> partnerNewMap

        List<Account> listAccount = new List<Account>();
        
        //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Account11', 'tezt4@test.com','Customer');
        listAccount.add(account1);
        
        
        //Create Alliance Partner Account
        Account alliancePartnerAcc = TestingSetupDataUtil.createAccount('Partner Account2', 'tezt3alt@test.com', 'Partner');
        alliancePartnerAcc.Alliance_Partner_Flag__c = true;
        listAccount.add(alliancePartnerAcc);
        
        //Create Channel Partner Account
         Account channelPartnerAcc = TestingSetupDataUtil.createAccount('Partner Account2', 'tezt3cht@test.com', 'Partner');
        channelPartnerAcc.Channel_Partner_Flag__c = true;
        listAccount.add(channelPartnerAcc);
        
        insert listAccount;
        System.assertEquals(listAccount.size(), 3);
        
         //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account1.Id,'tarunOppty',System.today().addMonths(1));
        insert opty;
        System.assertEquals(opty.Name,'tarunOppty');
        
                
        test.startTest();
        Channel_Partner__c channelPartner3 = TestingSetupDataUtil.createChannelPartner(opty.id,'Channel Partner',channelPartnerAcc.Id);
        insert channelPartner3;
        Channel_Partner__c channelPartner5 = TestingSetupDataUtil.createChannelPartner(opty.id,'Channel Partner',channelPartnerAcc.Id);
        insert channelPartner5;
        List<Channel_Partner__c> lstCp = new List<Channel_Partner__c>();

        Channel_Partner__c channelPartner1 = TestingSetupDataUtil.createChannelPartner(opty.id,'Channel Partner',channelPartnerAcc.Id);
        channelPartner1.Primary__c = true;
        lstCp.add(channelPartner1);
        
        //create another primary channel partner
        Channel_Partner__c channelPartner2 = TestingSetupDataUtil.createChannelPartner(opty.id,'Alliance Partner',alliancePartnerAcc.Id);
        channelPartner2.Primary__c = true;
        lstCp.add(channelPartner2);
        insert lstCp;
        System.assertEquals(lstCp.size(), 2);
        //update channelPartner1 to primary
        channelPartner1.Primary__c = true;
        update channelPartner1;
        System.assertEquals(channelPartner1.Primary__c,true);
        
        //Added by Accenture till line 68
        try{
            Database.DeleteResult[] delResults = Database.delete(lstCp);
        }catch(DMLException e){}
        
        List<Channel_Partner__c> lstCp4 = new List<Channel_Partner__c>();
        Channel_Partner__c channelPartner4 = TestingSetupDataUtil.createChannelPartner(opty.id,'Channel Partner',channelPartnerAcc.Id);
        channelPartner4.Primary__c = false;
        lstCp4.add(channelPartner4);
    
        try{
            Database.SaveResult[] results = Database.insert(lstCp4);
        }catch(DMLException e){}
        channelPartner4.Primary__c = true;
        update channelPartner4 ;
        
        //ChannelPartnerTriggerUtil cpt = new ChannelPartnerTriggerUtil();
        
        test.stopTest();
    }
}