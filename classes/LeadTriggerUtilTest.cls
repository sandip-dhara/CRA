/*********************************************************** 
* Class Name: LeadTriggerUtilTest
* Author: Accenture
* Date: 10-APR-2012 
* Description: This class does the test coverage for LeadConvertController class.
***********************************************************/

@isTest
private class LeadTriggerUtilTest {
    public static Lead newLead;
    public static User user1;
    public static List<Lead> newLeads;
    static void setupData() {
        //Insert account 
        Account account = TestingSetupDataUtil.createAccount('zAccenture', 'accountEmail@accenture.com','Customer'); 
        insert account;
        // Insert product
        Product2 product = TestingSetupDataUtil.createProduct(true ,'PL1','USD', 'ProductCode' ); 
        product.Product_Line__c = 'PL1';
        insert product;
        // Insert lead record
        newLead = new Lead();
        newLeads = new List<Lead>(); 
        newLead = TestingSetupDataUtil.createLead('TestLead0', null, 'Working', 'Accepted', '123', 'test@test.com');
        newLead.Response_Product_Line_1__c  = product.Name;
        newLead.Response_Product_Line_2__c  = product.Name;
        newLead.Response_Product_Line_3__c  = product.Name;
        newLead.Response_Product_Line_4__c  = product.Name;
        newLead.Response_Product_Line_5__c  = product.Name;
        newLead.Company = 'z';
        newLeads.add(newLead);
        Lead newLead1 = TestingSetupDataUtil.createLead('TestLead1', null, 'Open', 'New', '123', 'test1@test.com');
        newLeads.add(newLead1);
        /* Inserting User */
        user1 = new User();
        user1 = TestingSetupDataUtil.createUser('lTrgTest','abc@hp.com','trgEmail@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','leadTrg@hp.com','78900976',Userinfo.getProfileId());
        user1.ManagerId = TestingSetupDataUtil.testUser.Id;
        /* Karthik : Aug 06, 2013 : Start : Providing User Role Type Data which is Mandatory : Start */
        user1.Adoption_Role_Type__c = 'IT';
        /* Karthik : Aug 06, 2013 : End */
        insert user1;
    }
    
    /**
    * This method covers test coverage for assiging lead owner manager
    */ 
    static testMethod void testAssignLeadOwnerManagers() {
        setupData();

        Map<Id, Lead> newLeadsMap = new Map<Id, Lead>();
        Map<Id, Lead> oldLeadsMap  = new Map<Id, Lead>();
        newLeadsMap.put(newLeads[0].Id, newLeads[0]);
        oldLeadsMap.put(newLeads[0].Id, newLeads[0]);
        LeadTriggerUtil.updateLeadBUandGBU(newLeadsMap, oldLeadsMap);
            
            
        try {
            insert newLeads;
        }
        catch(Exception e) {
        
        }
        //newLeads = new List<Lead>(); 
        //newLead = TestingSetupDataUtil.createLead('TestLead1', null, 'Qualified', 'Accepted', '123', 'test@test.com');
       
        
        System.runAs(TestingSetupDataUtil.testUser) {
            newLeads[0].OwnerId = user1.Id; 
            newLeads[0].Company = 'zAccenture';
        }
        
        try {
            update newLeads;
        }
        catch(Exception e) {
        
        }
        Set<String> productLines = new Set<String>();
        productLines.add('PL1');
        LeadTriggerUtil.addLeadProducts(newLeads, productLines);
        LeadTriggerUtil.updateAccountOnLead(newLeads);
        
        /* Karthik : Aug 07, 2013 : Start */
        LeadTriggerUtil.InsertLeadRegion(newLeads);
        LeadTriggerUtil.updateLeadRegion(newLeadsMap);
        /* Karthik : Aug 07, 2013 : End */

    }
}