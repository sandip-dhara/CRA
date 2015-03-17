/**********************************************************
* Class Name: JBP_generateMetricDataControllerTest
* Author: HP 
* Date: 06-May-20123
* Description: This class contains the test code coverage for the class "JBP_generateMetricDataController"
***********************************************************/
@isTest(seeAllData = true)
private class JBP_generateMetricDataControllerTest{

    static testMethod void testJBP_generateMetricData(){
    List<Metrics__c> previousmet = new List<Metrics__c>();
    List<Metrics__c> previousmetUpdate = new List<Metrics__c>();
    
        Date endDate= system.today();
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
        testJBP.Plan_End_Date__c= system.today();
        testJBP.BG__c ='HPFS';
        
        insert testJBP;
        
        JBP__c testNextYearJBP = new JBP__c();
        testNextYearJBP.name = 'JBP123456Next';
        testNextYearJBP.Partner_Account__c = newAccount.ID;
        testNextYearJBP.BG__c = 'HPFS';
        testNextYearJBP.PPT_Export_Currency__c='USD';
        testNextYearJBP.PPT_Export_Language__c='English';
        testNextYearJBP.Plan_End_Date__c= system.today().addYears(1) ;
        testNextYearJBP.BG__c ='HPFS';
        
        insert testNextYearJBP;
        
        GBU_Specialization_Plans__c subPlan = new GBU_Specialization_Plans__c();
        subPlan.Business_Group__c='HPFS';
        subplan.GBU_Specialization__c='HPFS';
        subplan.Joint_Business_Plan__c=testJBP.id;
        insert subPlan;
        
        GBU_Specialization_Plans__c subPlan2 = new GBU_Specialization_Plans__c();
        subPlan2.Business_Group__c='HPFS';
        subPlan2.GBU_Specialization__c='HPFS';
        subPlan2.Joint_Business_Plan__c=testNextYearJBP.id;
        insert subPlan2;
        
        Metrics__c met = new metrics__c();
        met.BG__c = 'HPFS';
        met.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        system.debug('the record Id is ' + schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Sales').getRecordTypeId());
        met.GbuSpecializationPlan__c = subPlan.id;
        met.Metrics_Type__c= 'Sales';
        met.Current_FY_Actual_Q1__c= 12;
        met.Current_FY_Actual_Q2__c=23;
        met.Current_FY_Actual_Q3__c=45;
        met.Current_FY_Actual_Q4__c=89;
        previousmet.add(met);
        
        Metrics__c metPercent = new metrics__c();
        metPercent.BG__c = 'HPFS';
        metPercent.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('HP Share of Business %').getRecordTypeId();
        metPercent.Metrics_Type__c='HP Share of Business %';
        metPercent.GbuSpecializationPlan__c = subPlan.id;
        metPercent.Current_FY_Actual_Q1_percent__c= 12;
        metPercent.Current_FY_Actual_Q2_percent__c=244;
        metPercent.Current_FY_Actual_Q3_percent__c=45;
        metPercent.Current_FY_Actual_Q4_percent__c=89;
        previousmet.add(metPercent);

        Metrics__c metMDF = new metrics__c();
        metMDF.BG__c = 'HPFS';
        metMDF.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Market Development Fund').getRecordTypeId();
        metMDF.Metrics_Type__c='Market Development Fund';
        metMDF.GbuSpecializationPlan__c = subPlan.id;
        metMDF.MDF_Spent_Amount_Q1__c=23;
        metMDF.MDF_Spent_Amount_Q2__c=34;
        metMDF.MDF_Spent_Amount_Q3__c=78;
        metMDF.MDF_Spent_Amount_Q4__c=98;
        previousmet.add(metMDF);
        
        Metrics__c metWoI = new metrics__c();
        metWoI.BG__c = 'HPFS';
        metWoI.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Weeks of Inventory').getRecordTypeId();
        metWoI.Metrics_Type__c='Weeks of Inventory';
        metWoI.GbuSpecializationPlan__c = subPlan.id;
        metWoI.Current_FY_Actual_Q1_Days__c=78;
        metWoI.Current_FY_Actual_Q2_Days__c=987;
        metWoI.Current_FY_Actual_Q3_Days__c=876;
        metWoI.Current_FY_Actual_Q4_Days__c=875;
       previousmet.add(metWoI);
       
       if(previousmet.size()>0)
       insert previousmet;
       
        //Check duplicate insertion of metrics 
        Metrics__c duplicateMet = new metrics__c();
        duplicateMet.BG__c = 'HPFS';
        duplicateMet.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        duplicateMet.Metrics_Type__c='Sales';
        duplicateMet.GbuSpecializationPlan__c = subPlan.id;
        try{
        insert duplicateMet ;
        }catch(Exception e){
        }
        //Next year Metrics
        List<Metrics__c> nextYearmet = new List<metrics__c>();
        Metrics__c metNextYear = new metrics__c();
        metNextYear.BG__c = 'HPFS';
        metNextYear.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        metNextYear.Metrics_Type__c='Sales';
        metNextYear.GbuSpecializationPlan__c =subPlan2.Id;
        nextYearmet.add(metNextYear);

        Metrics__c metNextYearPercent = new metrics__c();
        metNextYearPercent.BG__c = 'HPFS';
        metNextYearPercent.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('HP Share of Business %').getRecordTypeId();
        metNextYearPercent.Metrics_Type__c='HP Share of Business %';
        metNextYearPercent.GbuSpecializationPlan__c =subPlan2.Id;
        nextYearmet.add(metNextYearPercent);
        
        Metrics__c metNextYearHp = new metrics__c();
        metNextYearHp.BG__c = 'HPFS';
        metNextYearHp.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Market Development Fund').getRecordTypeId();
        metNextYearHp.Metrics_Type__c='Market Development Fund';
        metNextYearHp.GbuSpecializationPlan__c =subPlan2.Id;
        nextYearmet.add(metNextYearHp);
        
        Metrics__c metNextYearWeek = new metrics__c();
        metNextYearWeek.BG__c = 'HPFS';
        metNextYearWeek.recordTypeId = schema.SObjectType.metrics__c.getRecordTypeInfosByName().get('Weeks of Inventory').getRecordTypeId();
        metNextYearWeek.Metrics_Type__c='Weeks of Inventory';
        metNextYearWeek.GbuSpecializationPlan__c =subPlan2.Id;
        nextYearmet.add(metNextYearWeek);
        
        insert nextYearmet;
        
        //Update the metrics
              //Update the Actuals

        Metrics__c metupdate = new metrics__c();
        metupdate.ID = met.Id;
        metupdate.Current_FY_Actual_Q1__c= 112;
        metupdate.Current_FY_Actual_Q2__c=222;
        metupdate.Current_FY_Actual_Q3__c=888;
        metupdate.Current_FY_Actual_Q4__c=899;
        previousmetUpdate.add(metupdate);
        
        Metrics__c metPercentUpdate = new metrics__c();
        metPercentUpdate.Id = metPercent.Id;
        metPercentUpdate.Current_FY_Actual_Q1_percent__c= 121;
        metPercentUpdate.Current_FY_Actual_Q2_percent__c=2441;
        metPercentUpdate.Current_FY_Actual_Q3_percent__c=451;
        metPercentUpdate.Current_FY_Actual_Q4_percent__c=891;
        previousmetUpdate.add(metPercentUpdate);

        Metrics__c metMDFUpdate = new metrics__c();
        metMDFUpdate.Id = metMDF.Id;
        metMDFUpdate.MDF_Spent_Amount_Q1__c=2312;
        metMDFUpdate.MDF_Spent_Amount_Q2__c=34122;
        metMDFUpdate.MDF_Spent_Amount_Q3__c=7812;
        metMDFUpdate.MDF_Spent_Amount_Q4__c=9812;
        previousmetUpdate.add(metMDFUpdate);
        
        Metrics__c metWoIUpdate = new metrics__c();
        metWoIUpdate.Id = metWoI.Id;
        metWoIUpdate.Current_FY_Actual_Q1_Days__c=781;
        metWoIUpdate.Current_FY_Actual_Q2_Days__c=9871;
        metWoIUpdate.Current_FY_Actual_Q3_Days__c=8761;
        metWoIUpdate.Current_FY_Actual_Q4_Days__c=8751;
        previousmetUpdate.add(metWoIUpdate);      
       
        update previousmetUpdate;
        
        metrics__c m = [select id, recordType.name from metrics__c where id = : met.id];
        system.debug('the name of the metrics '+ m.recordType.Name);
        ApexPages.StandardController sc = new ApexPages.StandardController(subPlan);
        JBP_generateMetricDataController cont = new JBP_generateMetricDataController(sc);
     
    }
}