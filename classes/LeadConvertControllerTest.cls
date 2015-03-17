/**********************************************************
* Class Name: LeadConvertControllerTest
* Author: Accenture
* Date: 10-APR-2012 
* Description: This class does the test coverage for LeadConvertController class.
***********************************************************/

@isTest
private class LeadConvertControllerTest {
    public static String queueId = '';
    public static Account newAccount;
    public static List<Account> newAccounts;
    public static Contact newContact;
    public static List<Contact> newContacts;
    public static Lead newLead;
    public static Opportunity opportunity;
    public static List<Lead> newLeads;
    public static List<Campaign> listCampaign;
    public static Campaign newParentCampaign, newCampaign1, newCampaign2, newCampaign3, newCampaign4;
    public static List<CampaignMember> listCampaignMember;
    public static CampaignMember objCampaignMember1, objCampaignMember2, objCampaignMember3, objCampaignMember4;
    public static Product2 prod;
    private static Product_Interest__c productInterest;
       
    public void fetchQueue() {
        User queue = [Select Id 
                        From User
                        Where UserType  = 'Queue' Limit 1];
        if (queue != null ) {
            queueId = queue.Id;
        }
    }
   
    
    static void setupData() {
        //Insert account 
        newAccount = new Account();
        newAccounts = new List<Account>();
        newAccount = TestingSetupDataUtil.createAccount('HP', 'test@test.com', 'Customer');        
        newAccounts.add(newAccount);
        newAccount = TestingSetupDataUtil.createAccount('HP2', 'test@test.com', 'Customer');
        newAccounts.add(newAccount);
        insert newAccounts;
        System.assertEquals(newAccounts[0].Name=='HP',true);
        System.assertEquals(newAccounts.size(), 2);
        // Insert contact
        newContact = new Contact();
        newContact =  TestingSetupDataUtil.createContact(newAccounts[1].Id, 'TestLead0');
        newContact.Email='aby@hp.com';         
        insert newContact;
        System.assertEquals(newContact.LastName=='TestLead0',true);
        // Insert Lead record
        newLead = new Lead();
        newLeads = new List<Lead>(); 
        newLead = TestingSetupDataUtil.createLead('TestLead0', newAccounts[0].Name, 'Open', 'New', '123', 'test@test.com');
        newLead.Account_Name__c = newAccounts[0].Id;
        newLead.Budget__c = '121' ;
        newLead.Authorized_Buyer__c = 'No';
        newLead.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead.Estimated_Budget__c = 123.0;
        newLeads.add(newLead);
        newLead = TestingSetupDataUtil.createLead('TestLead0', newAccounts[0].Name, 'Open', 'New', '123', 'test@test.com');
        newLead.Account_Name__c = newAccounts[0].Id;
        newLead.Budget__c = '121' ;
        newLead.Authorized_Buyer__c = 'No';
        newLead.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead.Estimated_Budget__c = 123.0;
        newLeads.add(newLead);        
        newLead = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Open', 'New', '123', 'test@test.com');
        newLead.Account_Name__c = newAccounts[0].Id;
        newLead.Budget__c = '121' ;
        newLead.Authorized_Buyer__c = 'No';
        newLead.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead.Estimated_Budget__c = 123.0;
        newLeads.add(newLead);     
        newLead = TestingSetupDataUtil.createLead('TestLead3', '123', 'Open', 'New', '123', '');
        newLead.Account_Name__c = newAccounts[0].Id;
        newLead.Budget__c = '121' ;
        newLead.Authorized_Buyer__c = 'No';
        newLead.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead.Estimated_Budget__c = 123.0;
        if (queueId != '') {
            newLead.OwnerId = queueId;
        }
        newLeads.add(newLead); 
               
        insert newLeads ;
        
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : Start */
        newParentCampaign = new Campaign();
        newParentCampaign = TestingSetupDataUtil.createCampaign(true, 1, 1, 'Campaign1', UserInfo.getUserId(), 'test1', System.today()+1, 1, 1, 1, System.today(), 'InProgress', 'Banner Ads');
        newParentCampaign.Sub_Business_Unit__c = 'test';
        insert newParentCampaign;
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : End */
        
        listCampaign = new List<Campaign>(); 
        newCampaign1 = new Campaign();
        newCampaign2 = new Campaign();
        newCampaign3 = new Campaign();
        newCampaign4 = new Campaign();
 
        newCampaign1 = TestingSetupDataUtil.createCampaign(true ,1 ,1,'campaign1',UserInfo.getUserId(),'test1',System.today()+1,1,1,1,System.today(),'InProgress','Banner Ads');
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : Start */
        newCampaign1.ParentId = newParentCampaign.Id;
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : End */
        listCampaign.add(newCampaign1);
        
        newCampaign2 = TestingSetupDataUtil.createCampaign(true ,1 ,1,'campaign1',UserInfo.getUserId(),'test1',System.today()+1,1,1,1,System.today(),'InProgress','Banner Ads');
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : Start */
        newCampaign2.ParentId = newParentCampaign.Id;
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : End */
        listCampaign.add(newCampaign2);
        
        newCampaign3 = TestingSetupDataUtil.createCampaign(true ,1 ,1,'campaign1',UserInfo.getUserId(),'test1',System.today()+1,1,1,1,System.today(),'InProgress','Banner Ads');
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : Start */
        newCampaign3.ParentId = newParentCampaign.Id;
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : End */
        listCampaign.add(newCampaign3);
        
        newCampaign4 = TestingSetupDataUtil.createCampaign(true ,1 ,1,'campaign1',UserInfo.getUserId(),'test1',System.today()+1,1,1,1,System.today(),'InProgress','Banner Ads');
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : Start */
        newCampaign4.ParentId = newParentCampaign.Id;
        /* R6 : Karthik : Creating Parent-Child relationship between Campaigns : End */
        listCampaign.add(newCampaign4);
        
        insert listCampaign;
        
        listCampaignMember = new List<CampaignMember>();

        objCampaignMember1 = TestingSetupDataUtil.createCampaignMember(newCampaign1.Id,newContact.Id,true,newLeads[0].Id);
        listCampaignMember.add(objCampaignMember1);

        objCampaignMember2 = TestingSetupDataUtil.createCampaignMember(newCampaign2.Id,newContact.Id,true,newLeads[1].Id);
        listCampaignMember.add(objCampaignMember2);

        objCampaignMember3 = TestingSetupDataUtil.createCampaignMember(newCampaign3.Id,newContact.Id,true,newLeads[2].Id);
        listCampaignMember.add(objCampaignMember3);

        objCampaignMember4 = TestingSetupDataUtil.createCampaignMember(newCampaign4.Id,newContact.Id,true,newLeads[3].Id);
        listCampaignMember.add(objCampaignMember4);

        insert listCampaignMember;

        opportunity = new Opportunity();
        Date newDate = Date.today(); 
        opportunity = TestingSetupDataUtil.createOpportunity(newAccounts[0].Id, newAccounts[0].Name, newDate);
        
        try {
            //insert opportunity;
        }
        catch(DMLException e) {
            
        }
        
       
         
        Note leadNotes = new Note( Title = 'LeadNote', ParentId = newLeads[0].Id, 
                                Body = 'Test Lead Notes', OwnerId = Userinfo.getUserId(),
                                IsPrivate = false);
        insert leadNotes;
        Blob body = Blob.valueOf('Test Data');
        Attachment leadAttachment = new Attachment( Name = 'LeadAttachment', ParentId = newLeads[0].Id,
                                            OwnerId = Userinfo.getUserId(),
                                            Body = body, 
                                            Description = 'Test Attachment',
                                            ContentType = 'null',
                                            IsPrivate = false);        
        insert leadAttachment;
    }
    
    static testMethod void testLeadConvertController() {
    
        Test.StartTest();
        setupData();
        Test.StopTest();
        
        try {
            system.assertEquals(newLeads[4].Name=='TestLead3',true);
            system.assertEquals(listCampaign[0].Name=='campaign1',true);
            system.assertEquals(listCampaignMember.size()==4,true);
        } 
        catch (Exception e) {
        
        }
        
        // create an instance of the LeadConvertController controller
        ApexPages.StandardController sc0 = new ApexPages.standardController(newLeads[0]);
        LeadConvertController leadCon0 = new LeadConvertController(sc0);
        // Karthik : Aug 12, 2013 : Printing Convert Lead Owner : Start
        System.Debug('newLeads[0].Conv_Lead_Owner__c = ' + newLeads[0].Conv_Lead_Owner__c);
        System.Debug('leadCon0.leadId = ' + leadCon0.leadId);
        // Karthik : Aug 12, 2013 : Printing Convert Lead Owner : End
        
        // Karthik : Aug 12, 2013 : Creating a Test Product2 : Start
        prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'ESSN';
        prod.GBU__c = 'Technology Support';
        prod.Product_Line__c = 'Technology Support PL';
        prod.Sub_Product_Line__c = 'Technology Support Sub-PL';
        insert prod;
        // Karthik : Aug 12, 2013 : Creating a Test Product2 : End
        
        // Karthik : Aug 12, 2013 : Creating a Lead Products Item : Start
        productInterest = TestingSetupDataUtil.createProductInterest(leadCon0.leadId, prod.Id);
        insert productInterest;
        // Karthik : Aug 12, 2013 : Creating a Lead Products Item : End
        

       // ApexPages.StandardController sc1 = new ApexPages.standardController(newLeads[1]);
       // LeadConvertController leadCon1 = new LeadConvertController(sc1);
         
         
        
        // Convert the lead to Account, Contact, Opportunity(Optionally)
        leadCon0.accountId = newAccounts[0].Id;
        leadCon0.doNotCreateOpty = false;
        leadCon0.sendNotificationEmail = false;
        //leadCon1.sendNotificationEmail = false;
        //PageReference pageRef1 = leadCon1.leadConvert();
        PageReference pageRef0 = leadCon0.leadConvert();
        leadCon0.leadName = null;
        PageReference pageRef2 = leadCon0.leadConvert();
        leadCon0.createCase();
        leadCon0.checkForValidAccount();

    }
}