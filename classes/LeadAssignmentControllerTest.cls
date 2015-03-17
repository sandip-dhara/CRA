/**********************************************************
* Class Name: AccountTeamListControllerTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage for AccountTeamListController class. 
***********************************************************/
@isTest(SeeAllData=True)
public class LeadAssignmentControllerTest {
    private static Account acc;
    private static Opportunity opty;
    private static Pricebook2 price;
    private static Product2 prod;
    private static Product_Interest__c productInterest;
    private static Sales_Territory__c salesTerr;
    private static List<Sales_Territory_User_Assignment__c> salesTerrUsers;
    private static Sales_Territory_Account_Assignment__c salesTerrAcc;
    private static Product_Specialty__c prodSpclty;
    private static Product_Specialty_Definition__c prodSpcltyDef;
    private static List<Product_Specialty_User_Assignment__c> prodSpcltyUsers;
    private static Product_Specialty_Oppty_Assignment__c prodSpcltyOpty;
    private static List<User> users;
    private static Profile prof;
    private static List<AccountTeamMember> accTeamMem;
    private static List<Lead> newLeads;
    private static Campaign testParentCampaign, testChildCampaign;
    /*
     * Method for creating test data.
     */
    private static void setUpData(){
        system.debug('Enter setUpData()');
        newLeads = new List<Lead>();
        users = new List<User>();
        
        //Create a test account
        //sales_Territory__c testTerr = new sales_Territory__c(name='TestTerritory');
        acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com', 'Customer');
        //testTerr.MyComp_Sales_Territory_Name__c = testTerr.name;
        /* R6 : Karthik : Start : Providing World Region ID */
        //acc.World_Region1__c = 'a24J00000001MZBIA2';
        /* R6 : Karthik : End */
        insert acc;
        
        //Insert Lead
        newLeads = new List<Lead>();       
        Lead newLead = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Qualified', 'Accepted', '123', 'test@test.com');
        newLead.Account_Name__c = acc.Id;
        newLead.Budget__c = '121' ;
        newLead.Authorized_Buyer__c = 'No';
        newLead.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead.Estimated_Budget__c = 123.0;
        newLeads.add(newLead);
        //insert newLead;
        
        Lead newLead1 = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Qualified', 'Accepted', '123', 'test@test.com');
        //newLead1.Account_Name__c = acc.Id;
        newLead1.Budget__c = '121' ;
        newLead1.Authorized_Buyer__c = 'No';
        newLead1.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead1.Estimated_Budget__c = 123.0;

        newLeads.add(newLead1);
        insert newLeads;        
        
        // create a test Product2
        prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'ESSN';
        prod.GBU__c = 'Technology Support';
        prod.Product_Line__c = 'Technology Support PL';
        prod.Sub_Product_Line__c = 'Technology Support Sub-PL';
        insert prod;
        
        
        // create a test Lead products item
        productInterest = TestingSetupDataUtil.createProductInterest(newLeads[0].Id, prod.Id);
        insert productInterest;
        
        //OppLineItem = TestingSetupDataUtil.createProductInterest(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        
        //create a test sales territroy record.
        salesTerr = new Sales_Territory__c(Name = 'testSalesTerritory', IsActive__c = true);
        salesTerr.MyComp_Sales_Territory_Name__c = 'Test Sales Territory Name';
        insert salesTerr;
        
        //Create test User
        users = new List<User>();
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('stTest1','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@ca.com','1111111111',Userinfo.getProfileId());
        user1.Lead_Eligibility_Flag__c = true;
        user1.Global_Business_Unit__c = 'test';
        /* R6 : Karthik : Start : Providing User Role Type Data which is Mandatory */
        user1.Adoption_Role_Type__c = 'IT';
        /* R6 : Karthik : End */
        users.add(user1);
        
        //Create test User2
        User user2 = new User();
        user2 = TestingSetupDataUtil.createUser('stTest','abc2@hp.com','email12@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest2@ca.com','2222222222',Userinfo.getProfileId());
        user2.Lead_Eligibility_Flag__c = true;
        user2.Global_Business_Unit__c = 'test';
        /* R6 : Karthik : Start : Providing User Role Type Data which is Mandatory */
        user2.Adoption_Role_Type__c = 'IT';
        /* R6 : Karthik : End */
        users.add(user2);
        
        insert users;
        
        //create user in sales terr
        salesTerrUsers = new List<Sales_Territory_User_Assignment__c>();
        Sales_Territory_User_Assignment__c salesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, User__c = users[0].Id);
        Sales_Territory_User_Assignment__c salesTerrUser1 = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, User__c = users[1].Id);
        salesTerrUsers.add(salesTerrUser);
        salesTerrUsers.add(salesTerrUser1);
        insert salesTerrUsers;
        
        //create a Sales Territory Account record
        salesTerrAcc = new Sales_Territory_Account_Assignment__c(Account__c = acc.Id, Sales_Territory__c = salesTerr.Id);
        insert salesTerrAcc;
        
        //Create record for AccountTeamMember
        accTeamMem = new List<AccountTeamMember>();
        AccountTeamMember teamMem = new AccountTeamMember(AccountId = acc.Id, UserId = users[0].Id);
        AccountTeamMember teamMem1 = new AccountTeamMember(AccountId = acc.Id, UserId = users[1].Id);
        accTeamMem.add(teamMem);
        accTeamMem.add(teamMem1);
        insert accTeamMem;
        
        // create a test Specialty
        prodSpclty = new Product_Specialty__c(Name = 'testSpecialty');
        insert prodSpclty;
        
        //create a test record for Specialty Definition
        prodSpcltyDef = new Product_Specialty_Definition__c(Opportunity_Type__c = 'New Business', Route__c = 'Direct',  Product__c = prod.Id, Product_Specialty__c = prodSpclty.Id);
        insert prodSpcltyDef;
        
        //create a test record for SpeciaProduct_Specialty_User_Assignment__clty User assignment
        prodSpcltyUsers = new List<Product_Specialty_User_Assignment__c>();
        Product_Specialty_User_Assignment__c prodSpcltyUser = new Product_Specialty_User_Assignment__c(Product_Specialty__c = prodSpclty.Id, User__c = users[0].Id);
        Product_Specialty_User_Assignment__c prodSpcltyUser1 = new Product_Specialty_User_Assignment__c(Product_Specialty__c = prodSpclty.Id, User__c = users[1].Id);
        prodSpcltyUsers.add(prodSpcltyUser);
        prodSpcltyUsers.add(prodSpcltyUser1);
        insert prodSpcltyUsers;
        
        /* Inserting Contact */
        Contact testContact = new Contact();
        testContact = TestingSetupDataUtil.createContact(acc.Id, 'Test1LastName');
        
        /* Get User ID */
        ID userID = UserInfo.getUserId();

        /* Karthik : Aug 05, 2013 : Inserting Parent Campaign : Start */
        //testParentCampaign = new Campaign();
        testParentCampaign = TestingSetupDataUtil.createCampaign(true, 1, 1, 'Campaign02', userID, 'test', System.today()+1, 1, 1, 1, System.today(), 'Planned', 'Banner Ads');
        testParentCampaign.Sub_Business_Unit__c = 'test';
        //testParentCampaign.RecordType.Name = 'Sales_Mkt_Campaign';
        //testParentCampaign.RecordType.Name = 'Marketing Campaign';
        insert testParentCampaign;
        /* Karthik : Aug 05, 2013 : Inserting Parent Campaign : End */
        
        /* Karthik : Aug 05, 2013 : Inserting Child Campaign : Start */
        //testChildCampaign = new Campaign();
        testChildCampaign = TestingSetupDataUtil.createCampaign(true, 1, 1, 'Campaign03', userID, 'test', System.today()+1, 1, 1, 1, System.today(), 'Planned', 'Banner Ads');
        testChildCampaign.Sub_Business_Unit__c = 'test';
        //testChildCampaign.RecordType.Name = 'Sales_Mkt_Campaign';
        //testChildCampaign.RecordType.Name = 'Marketing Campaign';
        testChildCampaign.ParentId = testParentCampaign.Id;
        insert testChildCampaign;
        /* Karthik : Aug 05, 2013 : Inserting Child Campaign : End */

        /* Create Campaign Members */
        CampaignMember testCampaignMemb = new CampaignMember();
        testCampaignMemb = TestingSetupDataUtil.createCampaignMember(testChildCampaign.Id, testContact.Id, true, newLead.Id);     
        insert testCampaignMemb;
        
        system.debug('Exit setUpData()');
    }
    
    static testMethod void LeadAssignmentControllerPositiveTest() {
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        PageReference pageRef = Page.LeadManualAssigment;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id',newLeads[0].Id);
        ApexPages.Standardsetcontroller sc1 = new ApexPages.Standardsetcontroller(newLeads);
        LeadAssignmentController leadAssign = new LeadAssignmentController(sc1);
        pageRef = leadAssign.assignLeads();
        pageRef = leadAssign.returnBack();
        ApexPages.currentPage().getParameters().put('id',newLeads[1].Id);
        ApexPages.Standardsetcontroller sc2 = new ApexPages.Standardsetcontroller(newLeads);
        LeadAssignmentController leadAssign1 = new LeadAssignmentController(sc2);
        pageRef = leadAssign1.assignLeads();

        users[0].Global_Business_Unit__c = 'GBU';
        update users;
        /* RunAs testUser*/
        System.runAs(users[0]) {
            pageRef = Page.LeadManualAssigment;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id',newLeads[0].Id);
            sc1 = new ApexPages.Standardsetcontroller(newLeads);
            leadAssign = new LeadAssignmentController(sc1);
            pageRef = leadAssign.assignLeads();
            pageRef = leadAssign.returnBack();
            ApexPages.currentPage().getParameters().put('id',newLeads[1].Id);
            sc2 = new ApexPages.Standardsetcontroller(newLeads);
            leadAssign1 = new LeadAssignmentController(sc2);
            pageRef = leadAssign1.assignLeads();
        }
        
        /**/
        users[1].Global_Business_Unit__c = 'GBU';
       // update users;
        
        users[0].Lead_Eligibility_Flag__c = false;
        users[1].Lead_Eligibility_Flag__c = false;
        update users;
    }
      
    
    static testMethod void LeadAssignmentControllerNegativeTest() {
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        PageReference pageRef = Page.LeadManualAssigment;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id',newLeads[0].Id);
        ApexPages.Standardsetcontroller sc1 = new ApexPages.Standardsetcontroller(newLeads);
        LeadAssignmentController leadAssign = new LeadAssignmentController(sc1);

        ApexPages.currentPage().getParameters().put('id',newLeads[1].Id);
        ApexPages.Standardsetcontroller sc2 = new ApexPages.Standardsetcontroller(newLeads);
        LeadAssignmentController leadAssign1 = new LeadAssignmentController(sc2);

        /**/

        /* RunAs testUser*/
        System.runAs(users[0]) {
            pageRef = Page.LeadManualAssigment;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id',newLeads[0].Id);
            sc1 = new ApexPages.Standardsetcontroller(newLeads);
            leadAssign = new LeadAssignmentController(sc1);
 
            ApexPages.currentPage().getParameters().put('id',newLeads[1].Id);
            sc2 = new ApexPages.Standardsetcontroller(newLeads);
            leadAssign1 = new LeadAssignmentController(sc2);

        }
        
        users[1].Global_Business_Unit__c = 'GBU';
        
        users[0].Lead_Eligibility_Flag__c = false;
        users[1].Lead_Eligibility_Flag__c = false;
        update users;
        
       
       pageRef = Page.LeadManualAssigment;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id',newLeads[0].Id);
        sc1 = new ApexPages.Standardsetcontroller(newLeads);
        leadAssign = new LeadAssignmentController(sc1);
        pageRef = leadAssign.assignLeads();
        pageRef = leadAssign.returnBack();
        ApexPages.currentPage().getParameters().put('id',newLeads[1].Id);
        sc2 = new ApexPages.Standardsetcontroller(newLeads);
        leadAssign1 = new LeadAssignmentController(sc2);
        pageRef = leadAssign1.assignLeads();  
         
    }
}