/*********************************************************
* Class Name: JBPApprovalHistoryControllerTest
* Author: HP  
* Date: 21-March-2013 
* Requirement #: 5429
* Description: Test Class for JBPApprovalHistoryController
*********************************************************/
@isTest
public class JBPApprovalHistoryControllerTest{
    private static testMethod void testJBP(){
    //Setup Data to create Partner Account
        Account partAcc = new Account();
        partAcc = TestingSetupDataUtil.createAccount('JBPAccount', 'partnerJBP@hp.com','Partner');
        partAcc.Partner_Portal_Eligible__c = true;
        insert partAcc;
    //Setup Data to Create Joint Business Plan 
        JBP__c jbp= new JBP__c(Name='TestJbp', Partner_Account__c=partAcc.Id, BG__c='EG', PPT_Export_Currency__c='USD', PPT_Export_Language__c='English',Plan_End_Date__c=system.today()+20);
        insert jbp;
        JBP__c jbp1= new JBP__c();
        JBPApprovalHistoryController jbpHistroy = new JBPApprovalHistoryController ();
        jbpHistroy.JBPId =jbp.Id;
        jbpHistroy.getApprovalSteps();
        JBPApprovalHistoryController jbpHistroy1 = new JBPApprovalHistoryController ();
        jbpHistroy1.JBPID= jbp1.Id;
        jbpHistroy1.getApprovalSteps();      
    }
}