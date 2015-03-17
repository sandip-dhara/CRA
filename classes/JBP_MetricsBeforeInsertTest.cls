/**********************************************************
* Class Name: JBP_MetricsBeforeInsertTest
* Author: HP 
* Date: 06-May-20123
* Description: This class contains the test code coverage for the class "JBP_MetricsBeforeInsertController"
***********************************************************/
@isTest(seeAllData = true)
private class JBP_MetricsBeforeInsertTest{
    static testMethod void testJBP_MetricsBeforeInsert(){
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
        
        Metrics__c met = new metrics__c();
        met.BG__c = 'HPFS';
        met.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        met.GbuSpecializationPlan__c = subPlan.id;
        insert met;
        
       // test.startTest();
       try{
            Metrics__c met1 = new metrics__c();
            met1 .BG__c = 'HPFS';
            met1 .recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
            met1 .GbuSpecializationPlan__c = subPlan.id;
            insert met1;
            
            Metrics__c met2 = new metrics__c();
            met2 .BG__c = 'HPFS';
            met2 .recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Attach %').getRecordTypeId();
            met2 .GbuSpecializationPlan__c = subPlan.id;
            //insert met2;
            Metrics__c met3 = new metrics__c();
            met3 .BG__c = 'HPFS';
            met3 .recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Attach %').getRecordTypeId();
            met3 .GbuSpecializationPlan__c = subPlan.id;
            //insert met3;
            list<metrics__c> metriclist = new list<metrics__c>();
            metricList.add(met2);
            metricList.add(met3);
            insert metricList;
        }catch(exception e){
            system.debug('the exception is '+ e.getMessage());
        }
       try{
            Metrics__c met11 = new metrics__c();
            met11.BG__c = 'HPFS';
            met11.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
            met11.GbuSpecializationPlan__c = subPlan.id;
            //insert met11;
            
            Metrics__c met21 = new metrics__c();
            met21.BG__c = 'HPFS';
            met21.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Attach %').getRecordTypeId();
            met21.GbuSpecializationPlan__c = subPlan.id;
            //insert met21;
            Metrics__c met31 = new metrics__c();
            met31.BG__c = 'HPFS';
            met31.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Attach %').getRecordTypeId();
            met31.GbuSpecializationPlan__c = subPlan.id;
            //insert met3;
            list<metrics__c> metriclist1 = new list<metrics__c>();
            metricList1.add(met11);
            metricList1.add(met21);
            metricList1.add(met31);
            JBP_MetricsBeforeInsertController.avoidDuplicateRecord(metriclist1);
        }catch(exception e){
            system.debug('the exception is '+ e.getMessage());
        }
       // test.stopTest();
     }
}