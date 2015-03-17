/************************************************************************************
* Class Name: JointPlanSpclControllerTest
* Author: HP
* Date: 07-MAY-2013 
* Requirement # Request Id: 5357
* Description: This class does the test coverage for JointPlanSpclController class.
*************************************************************************************/
@isTest(seeAllData = True)
public class JointPlanSpclControllerTest{
    static Account accTPartner1 = new Account();
    
    public static testMethod void PositiveTest() {
        accTPartner1 = TestingSetupDataUtil.createAccount('partnerAccTestJBP', 'partnerAccTest1@hp.com', 'Partner');
        insert accTPartner1;
        accTPartner1.isPartner = true;
        update accTPartner1;
        
        Extended_Profile_Category__c EPCT = new Extended_Profile_Category__c(Name = 'PartnerOne Specializations Test',   MDCP_Active__c = 'Yes',     Userkey__c = '122901');
        Insert EPCT;
        
        Extended_Profile_Category__c NEPT = new Extended_Profile_Category__c(Name = 'PartnerOne Specializations FINAL Test', Parent_Category_Name__c = EPCT.Id);
        Insert NEPT;
        
        Date today = Date.Today();
        Date Exp = today + 365;
        Extended_Profile_Category_Item__c EPCIT = new Extended_Profile_Category_Item__c(Name = 'PartnerOne Specializations FINAL HP Imaging and Printing Specialist Test', Business_Area_Group__c = 'PPS - Printing', Status__c = 'Active', Type__c = 'Specialization', Extended_Profile_Category__c = NEPT.Id, Effective_Date__c = today, MDCP_Active__c = 'NO');
        Insert EPCIT;
        
        Extended_Profile_Category_Item_Asgn__c EPCIAT = new Extended_Profile_Category_Item_Asgn__c(Account__c = accTPartner1.Id, Extended_Profile_Category_Item__c = EPCIT.Id, Status__c = 'Assigned', Effective_Date__c = today, Expiry_Date__c = Exp, MDCP_Active__c = 'Yes' );
        Insert EPCIAT;
        
        JBP__c jbpPlan = new JBP__c(Name = 'TestJBPPlan99', Partner_Account__c = accTPartner1.Id, BG__c = 'PPS', PPT_Export_Currency__c = 'English', PPT_Export_Language__c = 'GBP', Plan_End_Date__c=system.today()+20);
        Insert jbpPlan;
                
        ApexPages.StandardController stdController = new ApexPages.StandardController(jbpPlan);
        JointPlanSpclController  jbpController = new JointPlanSpclController(stdController);
        jbpController.getspclList();


        //ApexPages.currentPage().getParameters().put(jbpPlan.Id, accTPartner1.Id);
    }
}