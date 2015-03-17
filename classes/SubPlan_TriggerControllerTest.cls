@isTest
Public class SubPlan_TriggerControllerTest{

     Static Account accRec = new Account();
     Static JBP__c jbp = new JBP__c();
     Static GBU_Specialization_Plans__c suPlan1 = new GBU_Specialization_Plans__c();
     Static GBU_Specialization_Plans__c suPlan2 = new GBU_Specialization_Plans__c();
     public static testMethod void testBeforeInsert() {
        Test.startTest();
        /* Create a test Account */        
        accRec = TestingSetupDataUtil.createAccount('Testing Account','testing@test.com','Partner');
        insert accRec;
        
         /*Create a JBP */
        jbp.Name = 'Test_SubPlan_TriggerControllerTest';
        jbp.BG__c = 'PPS';
        jbp.Partner_Account__c = accRec.id;
        jbp.Plan_End_Date__c = date.valueof('2014-08-14');
        insert jbp;
        
        /* Create Sub plans */
        List<GBU_Specialization_Plans__c> suPlanList = new List<GBU_Specialization_Plans__c>();
        suPlan1.GBU_Specialization__c = 'Supplies';
        suPlan1.Business_Group__c = 'PPS';
        suPlan1.Joint_Business_Plan__c = jbp.id;
        suPlan2.GBU_Specialization__c = 'Printing';
        suPlan2.Business_Group__c = 'PPS';
        suPlan2.Joint_Business_Plan__c = jbp.id;        
        suPlanList.add(suPlan1);
        suPlanList.add(suPlan2);
        insert suPlanList;
        suPlan1.GBU_Specialization__c = 'Computing';
        update suPlan1;
        Test.stopTest();
    }
}