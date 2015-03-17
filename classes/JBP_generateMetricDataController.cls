/**********************************************************
* Class Name: JBP_generateMetricDataController
* Author:  HP
* Date: 10-APRIL-2013
* Requirement # Request Id: 5365
* Description: This class is used to display the metrics records on the sub-plan record. Only the metrics with Sales,
               Partner Compensation, HP Share Of Business %, Attach%, Market Development Fund are displayed. 
**********************************************************/
public with sharing class JBP_generateMetricDataController{
    
    //Variable declaration
    public list<string> recordTypeArray{get;set;}
    public map<string, metrics__c> metricsMap{get;set;}
    public boolean isResellerRecType {get; set;}
    
    
    /*
    *  @description: This is the constructor of the class. In the constructor we query the metrics object related to the sub-plan
                     All the metrics records are displayed in a predefined order.
    *  @Params: ApexPages.standardController.
    *  @return: void
    */
    public JBP_generateMetricDataController(ApexPages.StandardController stdController){
        GBU_Specialization_Plans__c gbu = (GBU_Specialization_Plans__c )stdController.getRecord();
        isResellerRecType = false;
        id recTypeId = [SELECT Id,Name FROM RecordType where SobjectType ='GBU_Specialization_Plans__c' AND Name = 'Reseller'].id;  
        if(gbu.recordTypeId == recTypeId){
            isResellerRecType = true;
        }
        metricsMap = new map<string, metrics__c>();
        //Capture all the recordTypes of the metric in the order which we need to display. We cannot custom labels as we need to compare these in the VF page to 
        //to display the metrics in Order
        recordTypeArray = new list<string>{'Sales',
                                             'Attach %',
                                             'HP Share of Business %',
                                             'Partner Compensation',
                                             'Market Development Fund',
                                             'Weeks of Inventory',
                                             'Aged Inventory'};                                 
        list<Metrics__c> metricList = new list<metrics__c>();
        try{
             metricList = [SELECT id, recordType.name,Current_FY_Achievement_Q1__c,Current_FY_Achievement_Q2__c,Current_FY_Achievement_Q3__c,Current_FY_Achievement_Q4__c,Current_FY_Achievement_Total__c,Current_FY_Actual_Q1__c,Current_FY_Actual_Q2__c,Current_FY_Actual_Q3__c,Current_FY_Actual_Q4__c,Current_FY_Actual_Total__c,Current_FY_Planned_Q1__c,Current_FY_Planned_Q2__c,Current_FY_Planned_Q3__c,Current_FY_Planned_Q4__c,Current_FY_Planned_Total__c,Previous_FY_Actual_Q1__c,Previous_FY_Actual_Q2__c,Previous_FY_Actual_Q3__c,Previous_FY_Actual_Q4__c,Previous_FY_Actual_Total__c,YoY_gr_Comparision_Plan_Q1__c,YoY_gr_Comparision_Plan_Q2__c,YoY_gr_Comparision_Plan_Q3__c,YoY_gr_Comparision_Plan_Q4__c,YoY_gr_Comparision_Plan_Total__c,YoY_Actual_Growth_Q1__c,YoY_Actual_Growth_Q2__c,YoY_Actual_Growth_Q3__c,YoY_Actual_Growth_Q4__c,Total_YoY_Actual_Growth__c,Allocated_MDF_Amount_Q1__c,Allocated_MDF_Amount_Q2__c,Allocated_MDF_Amount_Q3__c,Allocated_MDF_Amount_Q4__c,Total_Allocated_MDFAmount__c,Previous_Year_MDF_Spent_Q1__c,Previous_Year_MDF_Spent_Q2__c,Previous_Year_MDF_Spent_Q3__c,Previous_Year_MDF_Spent_Q4__c,Previous_Year_MDF_Spent_Total__c,Total_MDF_Spent_Amount__c,Total_MDF_Utilization_Rate__c,MDF_Spent_Amount_Q1__c,MDF_Spent_Amount_Q2__c,MDF_Spent_Amount_Q3__c,MDF_Spent_Amount_Q4__c,MDF_Utilization_Rate_Q1__c,MDF_Utilization_Rate_Q2__c,MDF_Utilization_Rate_Q3__c,MDF_Utilization_Rate_Q4__c,GbuSpecializationPlan__c,Current_FY_Actual_Q1_percent__c,Current_FY_Actual_Q2_percent__c,Current_FY_Actual_Q3_percent__c,Current_FY_Actual_Q4_percent__c,Current_FY_Actual_Total_percent__c,Current_FY_Planned_Q1_percent__c,Current_FY_Planned_Q2_percent__c,Current_FY_Planned_Q3_percent__c,Current_FY_Planned_Q4_percent__c,Current_FY_Planned_Total_percent__c,Previous_FY_Actual_Q1_percent__c,Previous_FY_Actual_Q2_percent__c,Previous_FY_Actual_Q3_percent__c,Previous_FY_Actual_Q4_percent__c,Previous_FY_Actual_Total_percent__c, Previous_FY_Actual_Q1_Days__c,Previous_FY_Actual_Q2_Days__c,Previous_FY_Actual_Q3_Days__c,Previous_FY_Actual_Q4_Days__c,Previous_FY_Actual_Total_Days__c, Current_FY_Planned_Q1_Days__c, Current_FY_Planned_Q2_Days__c, Current_FY_Planned_Q3_Days__c, Current_FY_Planned_Q4_Days__c, Current_FY_Planned_Total_Days__c, Current_FY_Actual_Q1_Days__c, Current_FY_Actual_Q2_Days__c, Current_FY_Actual_Q3_Days__c, Current_FY_Actual_Q4_Days__c, Current_FY_Actual_Total_Days__c
                                           FROM Metrics__c 
                                           WHERE GbuSpecializationPlan__c=: gbu.id 
                                           AND recordType.Name IN : recordTypeArray];
        }catch(exception e){
        
        }
        if(metricList.size()>0){
            for(Metrics__c met:metricList){
                metricsMap.put(met.recordType.name, met);
            }
        }
        
        for(string recordTypeName : recordTypeArray){
            if(!metricsMap.containsKey(recordTypeName)){
                Metrics__c metric = new metrics__c();
                metricsMap.put(recordTypeName, metric);
            }
        }
    }
}