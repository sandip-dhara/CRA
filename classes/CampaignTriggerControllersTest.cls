/**********************************************************
* Class Name  : CampaignTriggerControllersTest 
* Author      : Accenture
* Date        : 24-APR-2012 
* Description : Test class for the controller class CampaignTriggerControllers
***********************************************************/
@isTest
public class CampaignTriggerControllersTest {
    public static Account account;
    public static Opportunity opty;
    public static Campaign primarycampaignforLead;
    public static Contact testContact1;
    public static Contact testContact2;
    public static Lead lead;
    public static Campaign objCampaign, objCampaign1, objCampaign2, objCampaign3, parentCampaign;
    public static CampaignMember objCampaignMember, objCampaignMember2, objCampaignMember3,objCampaignMember4,objCampaignMember5;
    public static List<CampaignMember> listCampaignMembers;
    
    public static void setupData() {
        ID userID = UserInfo.getUserId();
        account = new Account();
        account = TestingSetupDataUtil.createAccount('Test Account', 'tezt@hp.com', 'Customer');
        insert account;
        System.assertEquals(account.Id != null,true);
        System.assertEquals('Test Account',account.Name);
        opty = new Opportunity();
        opty = TestingSetupDataUtil.createOpportunity(account.Id, 'Default Opty', System.today().addMonths(1));
        insert opty;
        System.assertEquals(opty.Name == 'Default Opty', true);
        primarycampaignforLead = new Campaign(); 
        primarycampaignforLead = TestingSetupDataUtil.createCampaign(true, 1, 1, 'CampaignPrimary', userID, 'test', System.today()+1, 1, 1, 1, System.today(), 
                                    'In Progress', 'Banner Ads');
        insert PrimarycampaignforLead;
        System.assertEquals(primarycampaignforLead.Id != null,true);
        // Create contact
        testContact1 = new Contact();
        testContact2 = new Contact();
        testContact1 = TestingSetupDataUtil.createContact(account.Id, 'Test1LastName');
        testContact2 = TestingSetupDataUtil.createContact(account.Id, 'Test2LastName');
        List<Contact> listContact = new List<Contact>();
        listContact.add(testContact1); 
        listContact.add(testContact2); 
        insert listContact;
        System.assertEquals(listContact.size(),2);
        System.assertEquals(listContact[0].LastName == 'Test1LastName', true);    
            
        //Create Lead
        lead = new Lead();
        lead = TestingSetupDataUtil.createLead('Test123', 'ACC', 'Open', 'Assigned', '1234567890', 'Test@hp.com');
        insert lead;
        System.assertEquals(lead.Id != null, true);
        
        // Karthik : Aug 19, 2013 : Creating a Parent Campaign : Start
        parentCampaign = new Campaign();
        parentCampaign = TestingSetupDataUtil.createCampaign(true, 1, 1, 'TestCampaign', userID, 'test' , System.today()+1, 1, 1, 1, System.today(), 'In Progress' ,
                                                                'Banner Ads');
        insert parentCampaign;
        // Karthik : Aug 19, 2013 : Creating a Parent Campaign : End
        
        List<Campaign> listCampaign = new List<Campaign>();
    
        objCampaign = new Campaign();
        objCampaign1 = new Campaign();
        objCampaign2 = new Campaign();
        objCampaign3 = new Campaign();
        
        objCampaign = TestingSetupDataUtil.createCampaign(true, 1, 1, 'Campaign02', userID, 'test' , System.today()+1, 1, 1, 1, System.today(), 'In Progress' ,
                                                                'Banner Ads');
        objCampaign3 = TestingSetupDataUtil.createCampaign(true, 1, 1, 'Campaign02', userID, 'test' , System.today()+1, 1, 1, 1, System.today(), 'In Progress' ,
                                                                'Banner Ads');
        objCampaign3.ParentId = objCampaign.Id;                                                             
        objCampaign1 = TestingSetupDataUtil.createCampaign(true, 1, 1, 'Campaign02', userID, 'test' , System.today()+1, 1, 1, 1, System.today(), 'In Progress' ,
                                                                'Banner Ads');        
        objCampaign2 = TestingSetupDataUtil.createCampaign(true, 1, 1, 'Campaign02', userID, 'test' , System.today()+1, 1, 1, 1, System.today(), 'In Progress' ,
                                                                'Banner Ads');
        
        // Karthik : Aug 19, 2013 : Relating a Parent Campaign : Start
        objCampaign.ParentId = parentCampaign.Id;
        objCampaign1.ParentId = parentCampaign.Id;
        objCampaign2.ParentId = parentCampaign.Id;
        // Karthik : Aug 19, 2013 : Relating a Parent Campaign : End
  
        
        listCampaign.add(objCampaign);
        listCampaign.add(objCampaign3);
        listCampaign.add(objCampaign1);
        listCampaign.add(objCampaign2);
        
        insert listCampaign; 
        System.assertEquals(listCampaign.size(),4);
        //Create Campaign Members
        listCampaignMembers = new  List<CampaignMember>();
        objCampaignMember = new CampaignMember();
        objCampaignMember2 = new CampaignMember();
        objCampaignMember3 = new CampaignMember();
        objCampaignMember4 = new CampaignMember();
        objCampaignMember5 = new CampaignMember();
        
        objCampaignMember = TestingSetupDataUtil.createCampaignMember(objCampaign.Id, testContact1.Id, true, lead.Id);
        listCampaignMembers.add(objCampaignMember);
     
        objCampaignMember2 = TestingSetupDataUtil.createCampaignMember(objCampaign.Id, testContact2.Id, true, lead.Id);
        listCampaignMembers.add(objCampaignMember2);

        objCampaignMember3 = TestingSetupDataUtil.createCampaignMember(objCampaign2.Id, testContact1.Id, true, lead.Id);
        listCampaignMembers.add(objCampaignMember3);
     
        /*objCampaignMember4 = TestingSetupDataUtil.createCampaignMember(objCampaign2.Id, testContact1.Id, false, lead.Id);     
        listCampaignMembers.add(objCampaignMember4);
        
        objCampaignMember5 = TestingSetupDataUtil.createCampaignMember(objCampaign2.Id, testContact1.Id, false, lead.Id);     
        listCampaignMembers.add(objCampaignMember5);*/
        
        insert listCampaignMembers;      

        System.assertEquals(listCampaignMembers.size(),3);      
    }
    
    static testMethod void testCampaignTriggerControllers1(){
        Test.startTest();
        CampaignTriggerControllersTest campaignTrigger = new CampaignTriggerControllersTest();

        setupData();

        try{
            update objCampaignMember2;
        }
        catch(DMLException e) {
            system.debug('Exception: '+e.getMessage());
        }
        try {
            delete objCampaignMember;
        }
        catch(Exception ex) {
            System.assert(ex.getMessage().contains('Can not delete Primary Campaign'));
        }

        Test.stopTest();
    }
    
     static testMethod void testCampaignTriggerControllers2(){
        Test.startTest();
               
        setupData();
        Map<id,CampaignMember> campMemberNewMap = new Map<id,CampaignMember>();
        campMemberNewMap.put(objCampaignMember.Id,objCampaignMember);
        campMemberNewMap.put(objCampaignMember2.Id,objCampaignMember2);
        try{
            CampaignTriggerUtil.checkIsPrimaryFlagOnInsert(campMemberNewMap);
               
           // CampaignTriggerUtil objCTU = new CampaignTriggerUtil();   
           // objCTU.validatePrimaryCampignMember();
            objCampaignMember3.Primary__c = true; 
            update objCampaignMember3;
        }
        catch(DMLException e) {
            system.debug('Exception: '+e.getMessage());
        }
        try {
           // delete objCampaignMember;
        }
        catch(Exception ex) {
            System.assert(ex.getMessage().contains('Can not delete Primary Campaign'));
        }

        Test.stopTest();
    }
    
    static testMethod void globalconfigCSPositiveTest(){
        Test.startTest();
        
        //generate Random String 
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        
         // Insert User
        User userTest = TestingSetupDataUtil.createUser('GC_'+randomstr.substring(0,4),randomstr+'gc@hp.com',randomstr+'gc@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','gc@hp.com','123'+randomstr.substring(0,4),Userinfo.getProfileId());
        // Karthik : Aug 19, 2013 : Providing User Role Type Data which is Mandatory : Start
        userTest.Adoption_Role_Type__c = 'IT';
        // Karthik : Aug 19, 2013 : Providing User Role Type Data which is Mandatory : End
        insert userTest ;
        
        Global_Config__c gcUser = new Global_Config__c();
        gcUser.SetupOwnerId = userTest.id;
        gcUser.Mute_Triggers__c = true;
        insert gcUser;
        
        system.runAs(userTest){
            try{
                setupData();
                Map<id,CampaignMember> campMemberNewMap = new Map<id,CampaignMember>();
                campMemberNewMap.put(objCampaignMember.Id,objCampaignMember);
                campMemberNewMap.put(objCampaignMember2.Id,objCampaignMember2);
                CampaignTriggerUtil.checkIsPrimaryFlagOnInsert(campMemberNewMap);
                objCampaignMember3.Primary__c = true; 
                update objCampaignMember3;
            }
            catch(DMLException e) {
                system.debug('Exception: '+e.getMessage());
            }
        }
        Test.stopTest();
    }
    
      static testMethod void testCampaignTriggerControllersForAfterDelete(){
        Test.startTest();
        CampaignTriggerControllersTest campaignTrigger = new CampaignTriggerControllersTest();

        setupData();

            delete objCampaignMember2;
        delete objCampaignMember3;
        objCampaignMember4 = new CampaignMember();
       objCampaignMember4 = TestingSetupDataUtil.createCampaignMember(objCampaign2.Id, testContact1.Id, false, lead.Id);     
       Insert objCampaignMember4;
       delete objCampaignMember4;
        Test.stopTest();
    }
    
}