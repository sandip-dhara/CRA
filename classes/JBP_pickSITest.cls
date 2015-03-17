/**********************************************************
* Class Name: JBP_pickSITest
* Author: HP 
* Date: 06-May-20123
* Description: This class contains the test code coverage for the class "JBP_pickSIController"
***********************************************************/
@isTest(seeAllData = true)
private class JBP_pickSITest{
    static testMethod void testJBP_pickSIController(){
        Id recordId=schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account newAccount=new Account(Name='TestAccountForTestClass',RecordTypeId=recordId,ShippingCountry='India',ShippingPostalCode='234562345',ShippingState='Karnataka123',ShippingStreet='Esomecity');
        insert newAccount;
        newAccount.IsPartner=true;
        update newAccount;
        
        JBP__c testJBP = new JBP__c();
        testJBP.name = 'Test JBP123456';
        testJBP.Partner_Account__c = newAccount.ID;
        testJBP.BG__c = 'HPFS';
        testJBP.PPT_Export_Currency__c='USD';
        testJBP.PPT_Export_Language__c='English';
        testJBP.Plan_End_Date__c=system.today()+20;
        insert testJBP;
        
        GBU_Specialization_Plans__c subPlan = new GBU_Specialization_Plans__c();
        subPlan.Business_Group__c='HPFS';
        subplan.GBU_Specialization__c='HPFS';
        subplan.Joint_Business_Plan__c=testJBP.id;
        insert subPlan;
        
        /*GBU_Specialization_Plans__c subPlan1 = new GBU_Specialization_Plans__c();
        subPlan1.Business_Group__c='HPFS';
        subPlan1.GBU_Specialization__c='HPFS';
        subPlan1.Joint_Business_Plan__c=testJBP.id;
        insert subPlan1;*/
        
        JBP_Strategic_Initiative__c SI = new JBP_Strategic_Initiative__c();
        SI.Joint_Business_Plan__c = testJBP.id;
        SI.Plan_BG_2__c = 'HPFS';
        SI.Strategic_Initiative_Name_picklist__c='HPFS - Fair Market Value Refresh';
        SI.Description__c='test';
        SI.Start_Date__c=system.today();
        SI.End_Date__c=system.today();
        insert SI;
        
        JBP_Strategic_Initiative__c SI1 = new JBP_Strategic_Initiative__c();
        SI1.Joint_Business_Plan__c = testJBP.id;
        SI1.Plan_BG_2__c = 'HPFS';
        SI1.Strategic_Initiative_Name_picklist__c='HPFS - Fair Market Value Refresh';
        SI1.Description__c='test';
        SI1.Start_Date__c=system.today();
        SI1.End_Date__c=system.today();
        insert SI1;
        
        Strategic_Initiative_Junction__c SIJ = new Strategic_Initiative_Junction__c();
        SIJ.Strategic_Initiative__c=SI.id;
        SIJ.GBU_Specialization_Plan__c=subPlan.id;
        insert SIJ;
        
        test.startTest();
        PageReference pageRef = new PageReference('/apex/JBP_pickSIPage?gbuId='+subPlan.id+'&jbpId='+testJBP.id);
        Test.setCurrentPage(pageRef);
        JBP_pickSIController testpickSI = new JBP_pickSIController();
        testpickSI.getAssociatedSI();
        testpickSI.add();
        JBP_pickSIController.SIWrapperClass wrapperClass = new JBP_pickSIController.SIWrapperClass(SI1);
        wrapperClass.selected = true;
        testpickSI.SIWrapperList.add(wrapperClass);
        testpickSI.add();
        testpickSI.cancel();
        test.stopTest();
    }
}