/*********************************************************
* Class Name: ABPApprovalHistoryControllerTest
* Author: HP  
* Date: 18-June-2013 
* Requirement : CR-0888
* Description: Test Class for ABPApprovalHistoryController
*********************************************************/
@isTest
public class ABPApprovalHistoryControllerTest{
    private static testMethod void testABP(){
   Account acc = new Account(Name = 'Test Account');
        insert acc;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
       User u = new User(Alias = 'standt', Email='standarduser@hp.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,Legacy_Employee_Ref__c='********',Email_Address__c ='qwert@hp.com',Business_Group__c ='IPG',
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser01a@testorg.com');
        ABP_Approval__c apr  = new ABP_Approval__c(Approver__c = u.id, Account_Plan__c = acp.id);
        insert apr;
         ABP_Approval__c apr1 = new  ABP_Approval__c() ;
        ABPApprovalHistoryController abpHistroy = new ABPApprovalHistoryController ();
        abpHistroy.abpId =apr.Id;
       abpHistroy.getApprovalSteps();
         ABPApprovalHistoryController abpHistroy1 = new  ABPApprovalHistoryController ();
        abpHistroy1.ABPID= apr1.Id;
        abpHistroy1.getApprovalSteps();      
    }
}