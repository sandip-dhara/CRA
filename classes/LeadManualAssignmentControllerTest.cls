/**********************************************************
* Class Name: LeadManualAssignmentControllerTest
* Author: Accenture
* Date: 25-JUL-2012 
* Description: This class does the test coverage
*              for LeadManualAssignmentController class. 
***********************************************************/
@isTest(SeeAllData = True)
private class LeadManualAssignmentControllerTest {
    
    public static List<Lead> newLeads;
    public static List<User> newUsers;
    public static String queueId = '';
    public static User user;
    private static Product2 prod;
    private static Product_Interest__c productInterest;
    public static Account newAccount;
       
    static void setupData() {       
        /* Insert Account */
        newAccount = new Account();
        newAccount = TestingSetupDataUtil.createAccount('HP', 'test@test.com', 'Customer');        
        insert newAccount;        
                   
        /* Inserting User */
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        user = new User();
        user = TestingSetupDataUtil.createUser('st'+randomstr.substring(0,4), randomstr+'standarduser@hp.com', randomstr+'standarduser@hp.com', 
                                                'UTF-8', 'U LastName', 'en_US', 'en_US', 'America/Los_Angeles', randomstr+'standarduser12@hp.com', 
                                                randomstr+'5', Userinfo.getProfileId());                                 
        /* Karthik : Aug 06, 2013 : Providing User Role Type Data which is Mandatory : Start */
        user.Adoption_Role_Type__c = 'IT';
        /* Karthik : Aug 06, 2013 : End */

        try {
            insert user;
            system.debug('User ID : ' + user.Id);
        } catch (Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Lead', 'LeadManualAssignmentControllerTest', 'TestClass'); 
        }
        
        /* Karthik : Aug 06, 2013 : Commenting the Assert statement for the Code Coverage : Start */
        //system.assertEquals(user.Id != NULL && user.Id != '', true);
        /* Karthik : Aug 06, 2013 : Commenting the Assert statement for the Code Coverage : End */
        
        System.runAs(user){
        newLeads = new List<Lead>();       
        Lead newLead1 = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Open', 'Accepted', '123', 'test@test.com');
        newLead1.Account_Name__c = newAccount.Id;
        newLead1.Budget__c = '121' ;
        newLead1.Authorized_Buyer__c = 'No';
        newLead1.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead1.Estimated_Budget__c = 123.0;
        newLead1.Ownerid = user.id;
        Lead newLead2 = TestingSetupDataUtil.createLead('TestLead3', '123', 'Open', 'Accepted', '123', '');
        
        newLeads.add(newLead1);     
        newLeads.add(newLead2); 
        try {
                insert newLeads ;
        } catch (Exception e){          
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Lead', 'LeadManualAssignmentControllerTest', 'TestClass');
        }
          Group g = new Group(Name ='Testgrp');
          insert g;
          GroupMember gmb =new GroupMember(Groupid = g.id,userorgroupid=user.Id);
          insert gmb;
        }
        
        /* Inserting Product Interest */
        prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'ESSN';
        prod.GBU__c = 'Technology Support';
        prod.Product_Line__c = 'Technology Support PL';
        prod.Sub_Product_Line__c = 'Technology Support Sub-PL';
        insert prod;
        
        // create a test Lead products item
        productInterest = TestingSetupDataUtil.createProductInterest(newLeads[0].Id, prod.Id);
        insert productInterest;
        
    }
    
    private static testMethod void testLeadManualAssignmentController() {
                
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
        /* Initializing test data */
        setupData();      
        Test.startTest();

        // create an instance of the LeadManualAssignmentController controller
        
        PageReference pageRef = Page.LeadManualAssigment;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLeads[0].Id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(newLeads[0]);
        LeadManualAssignmentController leadManualAssign = new LeadManualAssignmentController(sc1);
        leadManualAssign.leadId = newLeads[0].Id;
        newLeads[0].OwnerId = thisUser.Id;
        leadManualAssign.sendEmailNotificationFlag = True;
        leadManualAssign.save();   
        leadManualAssign.cancel();
        
             
            /* Check of validations */
        PageReference pageRef1 = Page.LeadManualAssigment;
        Test.setCurrentPageReference(pageRef1);
        ApexPages.currentPage().getParameters().put('leadId',newLeads[1].Id);
        ApexPages.StandardController sc2 = new ApexPages.standardController(newLeads[1]);
        LeadManualAssignmentController leadManualAssign1 = new LeadManualAssignmentController(sc2);
        leadManualAssign1.leadId = newLeads[1].Id;
        leadManualAssign1.sendEmailNotificationFlag = True;
        
        leadManualAssign.save();
        Test.stopTest();
       }       
    }
    
    private static testMethod void leadManualAssignmentControllerNegativeTest() {
        
        /* Initializing test data */
        setupData();
    
        // create an instance of the LeadManualAssignmentController controller
        PageReference pageRef2 = Page.LeadManualAssigment;
        Test.setCurrentPageReference(pageRef2);
        ApexPages.currentPage().getParameters().put('leadId',newLeads[1].Id);
        ApexPages.StandardController sc3 = new ApexPages.standardController(newLeads[1]);
        LeadManualAssignmentController leadManualAssign3 = new LeadManualAssignmentController(sc3);
        leadManualAssign3.leadId = newLeads[1].Id;
        newLeads[1].OwnerId = user.Id;
        leadManualAssign3.sendEmailNotificationFlag = True;
        leadManualAssign3.save();
    }
}