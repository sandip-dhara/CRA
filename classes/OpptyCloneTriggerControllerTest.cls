/**********************************************************
* Class Name: OpptyCloneTriggerControllerTest
* Trigger Name:OpportunityAfterInsert
* Author: HP
* Date: 19-FEB-2013 
* Description: This class contains unit tests for validating the behavior of clone functionality 
***********************************************************/
 
@isTest (seeAllData = true)
private class OpptyCloneTriggerControllerTest{
    
    private static Opportunity opty;
    private static Account partAcc1 = new Account();
    private static Contact partContact1 = new Contact();
    private static Contact partContact2 = new Contact();
    private static User partUser1 = new User();
    private static User partUser2 = new User();
    private static Channel_Partner__c channelPartner1=new Channel_Partner__c();
    private static OpportunityTeamMember oppMem = new OpportunityTeamMember();
    private static OpportunityTeamMember oppMem1 = new OpportunityTeamMember();
    private static OpportunityTeamMember oppMem2 = new OpportunityTeamMember();
    private static Pricebook2 price;
    private static Product2 prod;
    private static PricebookEntry priceEntry;
    private static OpportunityLineItem OppLineItem;
    private  static void setupData(){
    
    List<Account> listAccount = new List<Account>();
     
     //Create competitor1 Account
        Account compAcc1 = TestingSetupDataUtil.createAccount('competitor Account1','ztezt1@test.com','Competitor');
        listAccount.add(compAcc1);
    
         //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Customer');
        listAccount.add(account1);
        //insert listAccount;
        
         //Create Account for Opportunity 
        Account account2 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Partner');
        listAccount.add(account2);
        insert listAccount;
        //Create Opty
        opty = TestingSetupDataUtil.createOpportunity(account1.Id,'testOppty',System.today().addMonths(1));
        insert opty;
        System.assertEquals(opty.Name,'testOppty');
                
        // Create a account with record type - partner
        partAcc1 = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1@partnercollab.com','Partner');
        partAcc1.Partner_Portal_Eligible__c = true;
        insert partAcc1;
        
        system.assertEquals(partAcc1.Partner_Portal_Eligible__c,true);
        //Enable the account as partner
        partAcc1.IsPartner = true;
        partAcc1.Partner_Portal_Eligible__c = true;
        update partAcc1;  
        
        // Create a contact under the partner account
        partContact1 = TestingSetupDataUtil.createContact(partAcc1.Id, 'Test Prtnr Contact11');
        partContact1.Email='testcontact11@testing.com';
        insert partContact1;
        
        // Create a contact under the partner account
        partContact2 = TestingSetupDataUtil.createContact(partAcc1.Id, 'Test Prtnr Contact12');
        partContact2.Email='testcontact12@testing.com';
        insert partContact2;
        
         // fetch the partner profiles
        List<Profile> partnerProfiles = new List<Profile>();
        partnerProfiles = [Select p.UserType, p.UserLicenseId, p.Name, p.Id From Profile p where p.UserType like '%Partner%' ];
        
        // Create a partner user
        partUser1 = TestingSetupDataUtil.createUser('pruser1','partnerUser1@testab.com','5_1_partnerUser1@testab.com','UTF-8','parTneruser1','en_US','en_US','America/Los_Angeles','partnerUser1@testing.com','55145615',partnerProfiles[0].Id );
        partUser1.ManagerId = userInfo.getUserId(); 
        partUser1.ContactId = partContact1.Id;
        insert partUser1;
        
        partUser2 = TestingSetupDataUtil.createUser('pruser2','partnerUser2@testab.com','5_1_partnerUser2@testab.com','UTF-8','parTneruser2','en_US','en_US','America/Los_Angeles','partnerUser2@testing.com','55145616',partnerProfiles[0].Id );
        partUser2.ManagerId = userInfo.getUserId(); 
        partUser2.ContactId = partContact2.Id;
        insert partUser2;         
        
        // Insert Opportunity Team Members    
        List<OpportunityTeamMember> listOpportunityTeamMember = new List<OpportunityTeamMember>();
     
        oppMem = TestingSetupDataUtil.createOpportunityTeamMember(partUser1.Id ,'Sales Rep',opty.Id);
        
        listOpportunityTeamMember.add(oppMem);
        oppMem1 = TestingSetupDataUtil.createOpportunityTeamMember(partUser2.Id ,'Sales Rep',opty.Id);
        
        listOpportunityTeamMember.add(oppMem1);
        insert listOpportunityTeamMember;
        
        system.assertEquals(oppMem.opportunityid,opty.id);
        
        //Create Channel Partner 
        channelPartner1 = TestingSetupDataUtil.createChannelPartner(opty.id,'Channel Partner',partAcc1.Id);
        insert channelPartner1;
        
        // create a test pricebook2
       
        price = [select id, name, isActive from Pricebook2 where isStandard=True];
        
        // create a test Product2
        prod=new Product2(Name='abc',isActive = True,Business_Group__c='ES',GBU__c = 'Application Services',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
        insert prod;
        
        // create a test Product2
        
        priceEntry=TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        priceEntry.UseStandardPrice=true;
        insert priceEntry;
        
        
        
        // create a test Opportunity line item
        OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.Id,priceEntry.id,System.Today()+40);
        insert OppLineItem; 
        
        //Create Competitors     
        Competitors__c competitor =  new Competitors__c();
        competitor.Opportunity__c = opty.Id;
        competitor.competitor_Account__c = compAcc1.Id;
        insert competitor;
        }
        
        
     static testMethod void OpptyCloneTestMethod() {

        PageReference pageRef = Page.OpptyClone;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        ApexPages.currentPage().getParameters().put('id',opty.Id);
        OpptyCloneTriggerController optCloneTest = new OpptyCloneTriggerController(); 
        OpptyCloneTriggerController.opptyCloneTrigCon(opty.Id+'PartnersCompetitorsProduct',opty.Id);
    } 
}