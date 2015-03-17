/*********************************************************
* Class Name: BUApprovalHistoryControllerTest
* Author: HP  
* Date: 18-June-2013 
* Requirement : CR-0888
* Description: Test Class for BUApprovalHistoryController
*********************************************************/
@isTest
public class BUApprovalHistoryControllerTest{
    private static testMethod void testBU(){
   Account acc = new Account(Name = 'Test Account');
        insert acc;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
         Business_Unit_Plan__c bup = new Business_Unit_Plan__c (Account_Plan__c = acp.id , Name ='Test');
        insert bup;
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
       User u = new User(Alias = 'standt', Email='standarduser@hp.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,Legacy_Employee_Ref__c='********',Email_Address__c ='qwert@hp.com',Business_Group__c ='IPG',
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser01a@testorg.com');
       BU_Plan_Approval__c bpr  = new BU_Plan_Approval__c(Approver__c = u.id, Business_Unit_Plan__c = bup.id);
        insert bpr;
         BU_Plan_Approval__c bpr1 = new  BU_Plan_Approval__c() ;
        BUApprovalHistoryController abpHistroy = new BUApprovalHistoryController ();
        abpHistroy.abpId =bpr.Id;
       abpHistroy.getApprovalSteps();
         BUApprovalHistoryController abpHistroy1 = new  BUApprovalHistoryController ();
        abpHistroy1.ABPID= bpr1.Id;
        abpHistroy1.getApprovalSteps();      
    }
}