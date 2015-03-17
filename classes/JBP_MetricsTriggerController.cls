/**********************************************************
 * Class Name:JBP_MetricsTriggerController 
 * Author: HP  
 * Date: 27-June-2013
 * Requirement #: R6:5472 
 * Description:This is a controller for the Metrics__c before Insert Trigger.
 **********************************************************/
public class JBP_MetricsTriggerController{
    public static void beforeUpdate(Map<Id,metrics__c> newMetricsMap, Map<Id,metrics__c> oldMetrics){
        List<metrics__c> newMetList = new List<metrics__c>();
        List<Id> subPlanIdList = new List<Id>();
        for(Id met:newMetricsMap.keyset()){
            newMetList.add(newMetricsMap.get(met)); 
            if(oldMetrics.get(met).Metrics_Type__c != newMetricsMap.get(met).Metrics_Type__c || oldMetrics.get(met).BG__c != newMetricsMap.get(met).BG__c || oldMetrics.get(met).RecordTypeId != newMetricsMap.get(met).RecordTypeId ){
                subPlanIdList.add(newMetricsMap.get(met).GbuSpecializationPlan__c); 
            }
        }
        if(subPlanIdList.size()>0){
            JBP_MetricsBeforeInsertController.avoidDuplicateRecord(newMetList);
        }
        populatePreviousValues(newMetList); 
    }
    public static void populatePreviousValues(list<metrics__c> newMetricList){
        Set<Id> metricsSubplanIdSet = new Set<Id>();
        List<String> JBPDetailsList = new List<String>();
        List<String> subplanGBUList = new List<String>();
        List<String> subPlanBGList = new List<String>();
        List<Integer> JBPEndDateList = new List<Integer>();
        List<Id> sunplanIdList = new List<Id>();
        List<Metrics__c> subPlanPreviousMetrixList = new List<Metrics__c>();
        List<GBU_Specialization_Plans__c> subPlanPreviousList = new List<GBU_Specialization_Plans__c>();
        Map<String, Id> subplanCombinationIdMap = new Map<String, Id>();
        List<GBU_Specialization_Plans__c> subPlanExistingList = new List<GBU_Specialization_Plans__c>();
        Map<Id, List<String>> subplanIDMetricCombMap = new Map<Id, List<String>> ();
        Map<Id, List<String>> subplannewIdMetriCombMap = new Map<Id, List<String>>(); 
        Map<String, Metrics__c> newMetricCombSUbplanId = new Map<String, Metrics__c>();
        Map<Id, Id> newOldSubplanMap = new Map<Id, Id>();
        Id AttachRecordTypeId = RecordTypeIdHelper.getRecordTypeId('Metrics__c',Label.AttachPercent);
        Id bgPercentRecordTypeId = RecordTypeIdHelper.getRecordTypeId('Metrics__c',Label.BGSpecificPercentage);
        Id bgDollarRecordTypeId = RecordTypeIdHelper.getRecordTypeId('Metrics__c',Label.BGSpecificCurrecy);
        Id bgDaysRecordTypeId = RecordTypeIdHelper.getRecordTypeId('Metrics__c',Label.BGSpecificDays);
        Id hpShareBusinessRecordTypeId = RecordTypeIdHelper.getRecordTypeID('Metrics__c',Label.HPShareOfBusinessPercent);
        Id MDFRecordTypeId = RecordTypeIdHelper.getRecordTypeID('Metrics__c',Label.MarketDevelopmentFund);
        Id salesRecordTypeId = RecordTypeIdHelper.getRecordTypeID('Metrics__c',Label.Sales);
        Id salesGoalAttRecordTypeId = RecordTypeIdHelper.getRecordTypeID('Metrics__c',Label.SalesGoalAttainment);
        Id weekOfInventoryRecordTypeId = RecordTypeIdHelper.getRecordTypeId('Metrics__c',Label.JBP_Weeks_of_Inventory);
        Id agedInventoryRecordTypeId = RecordTypeIdHelper.getRecordTypeId('Metrics__c',Label.JBP_Aged_Inventory );

        for(Metrics__c metric: newMetricList){
            Map<String, Metrics__c> metCombMetricsMap = new Map<String, Metrics__c>();
            metCombMetricsMap.put(metric.BG__c+metric.Metrics_Type__c+metric.RecordTypeId, metric);
            metricsSubplanIdSet.add(metric.GBUSpecializationPlan__c);
            if(subplanIDMetricCombMap.containsKey(metric.GBUSpecializationPlan__c)){
                subplanIDMetricCombMap.get(metric.GBUSpecializationPlan__c).add(metric.BG__c+metric.Metrics_Type__c+metric.RecordTypeId+'|'+metric.GBUSpecializationPlan__c);
            }else{
                subplanIDMetricCombMap.put(metric.GBUSpecializationPlan__c,new List<String>());
                subplanIDMetricCombMap.get(metric.GBUSpecializationPlan__c).add(metric.BG__c+metric.Metrics_Type__c+metric.RecordTypeId+'|'+metric.GBUSpecializationPlan__c);
            }
        }
        System.debug('metricsSubplanIdSet***'+metricsSubplanIdSet);
        subPlanExistingList=[SELECT  Id, GBU_Specialization__c, JBPDetails__c, JBPEndDate__c, Business_Group__c FROM GBU_Specialization_Plans__c where Id IN: metricsSubplanIdSet]; 
        System.debug('subPlanExistingList**'+ subPlanExistingList);
        if(trigger.IsInsert){
        System.debug('I am in Insert');
            for(GBU_Specialization_Plans__c subplanVar:subPlanExistingList){
                JBPDetailsList.add(subplanVar.JBPDetails__c);
                JBPEndDateList.add(subplanVar.JBPEndDate__c.year()-1);
                subplanGBUList.add(subplanVar.GBU_Specialization__c);
                subPlanBGList.add(subplanVar.Business_Group__c);
                subplanCombinationIdMap.put(subplanVar.Business_Group__c+subplanVar.GBU_Specialization__c+subplanVar.JBPDetails__c,subplanVar.Id);
            }
        }
        else if(trigger.IsUpdate){
        System.debug('I am in update');
            for(GBU_Specialization_Plans__c subplanVar:subPlanExistingList){
                JBPDetailsList.add(subplanVar.JBPDetails__c);
                JBPEndDateList.add(subplanVar.JBPEndDate__c.year()+1);
                subplanGBUList.add(subplanVar.GBU_Specialization__c);
                subPlanBGList.add(subplanVar.Business_Group__c);
                subplanCombinationIdMap.put(subplanVar.Business_Group__c+subplanVar.GBU_Specialization__c+subplanVar.JBPDetails__c,subplanVar.Id);
            }
        }
        System.debug('subplanCombinationIdMap***'+ subplanCombinationIdMap) ;
        subPlanPreviousList = [Select Id , JBPDetails__c, GBU_Specialization__c, JBPEndDate__c,Business_Group__c FROM GBU_Specialization_Plans__c where Business_Group__c IN: subPlanBGList and CALENDAR_YEAR(JBPEndDate__c) IN:JBPEndDateList and JBPDetails__c IN:JBPDetailsList and GBU_Specialization__c IN:subplanGBUList];
        for(GBU_Specialization_Plans__c subPlanprev: subPlanPreviousList){
            for(String subplncom: subplanCombinationIdMap.keySet()){
                if(subPlanprev.Business_Group__c+subPlanprev.GBU_Specialization__c+subPlanprev.JBPDetails__c == subplncom){
                    sunplanIdList.add(subPlanprev.Id);
                    newOldSubplanMap.put(subPlanprev.Id, subplanCombinationIdMap.get(subPlanprev.Business_Group__c+subPlanprev.GBU_Specialization__c+subPlanprev.JBPDetails__c));
                }
            }
        }
        System.debug('newOldSubplanMap***'+ newOldSubplanMap);
        subPlanPreviousMetrixList= [ SELECT Id,GbuSpecializationPlan__c,Metrics_Type__c,  RecordTypeId, BG__c, Current_FY_Actual_Q1_Days__c, Current_FY_Actual_Q1__c, Current_FY_Actual_Q1_percent__c, Current_FY_Actual_Q2_Days__c, Current_FY_Actual_Q2__c, Current_FY_Actual_Q2_percent__c, Current_FY_Actual_Q3_Days__c, Current_FY_Actual_Q3__c, Current_FY_Actual_Q3_percent__c, Current_FY_Actual_Q4_Days__c, Current_FY_Actual_Q4__c, Current_FY_Actual_Q4_percent__c, MDF_Spent_Amount_Q1__c,MDF_Spent_Amount_Q2__c,MDF_Spent_Amount_Q3__c,MDF_Spent_Amount_Q4__c FROM Metrics__c where GbuSpecializationPlan__c IN:sunplanIdList];
        
        for(Metrics__c prevMetrics: subPlanPreviousMetrixList){
            for( String str: subplanIDMetricCombMap.get(newOldSubplanMap.get(prevMetrics.GbuSpecializationPlan__c))){
                String[] slpitString= str.split('\\|');
                String toCompare=slpitString[0];
                    if(toCompare.deleteWhitespace()== (string)(prevMetrics.BG__c+prevMetrics.Metrics_Type__c+prevMetrics.RecordTypeId).deleteWhitespace()){
                    newMetricCombSUbplanId.put(str,prevMetrics);
                }
            }
        }
        System.debug('newMetricCombSUbplanId***'+ newMetricCombSUbplanId);
        if(Trigger.IsInsert){
            Metrics__c prevMet = new Metrics__c();
            for(Metrics__c metricnew: newMetricList){
                for(String metCombvar: newMetricCombSUbplanId.keySet()){
                    if(metricnew.BG__c+metricnew.Metrics_Type__c+metricnew.RecordTypeId+'|'+metricnew.GbuSpecializationPlan__c == metCombvar){
                        prevMet=newMetricCombSUbplanId.get(metricnew.BG__c+metricnew.Metrics_Type__c+metricnew.RecordTypeId+'|'+metricnew.GbuSpecializationPlan__c);
                        if(metricnew.RecordTypeId== AttachRecordTypeId  || metricnew.RecordTypeId == bgPercentRecordTypeId || metricnew.RecordTypeId== hpShareBusinessRecordTypeId){
                            metricnew.Previous_FY_Actual_Q1_percent__c=prevMet.Current_FY_Actual_Q1_percent__c;
                            metricnew.Previous_FY_Actual_Q2_percent__c=prevMet.Current_FY_Actual_Q2_percent__c;
                            metricnew.Previous_FY_Actual_Q3_percent__c=prevMet.Current_FY_Actual_Q3_percent__c;
                            metricnew.Previous_FY_Actual_Q4_percent__c=prevMet.Current_FY_Actual_Q4_percent__c;
                        }
                        else if(metricnew.RecordTypeId== bgDollarRecordTypeId || metricnew.RecordTypeId == salesRecordTypeId || metricnew.RecordTypeId == salesGoalAttRecordTypeId){//BG Specific $, Sales Goal Attainment, Sales
                            metricnew.Previous_FY_Actual_Q1__c=prevMet.Current_FY_Actual_Q1__c;
                            metricnew.Previous_FY_Actual_Q2__c=prevMet.Current_FY_Actual_Q2__c;
                            metricnew.Previous_FY_Actual_Q3__c=prevMet.Current_FY_Actual_Q3__c;
                            metricnew.Previous_FY_Actual_Q4__c=prevMet.Current_FY_Actual_Q4__c;
                        }
                        else if(metricnew.RecordTypeId == bgDaysRecordTypeId || metricnew.RecordTypeId == weekOfInventoryRecordTypeId || metricnew.RecordTypeId == agedInventoryRecordTypeId ){//BG Specific #
                            metricnew.Previous_FY_Actual_Q1_Days__c=prevMet.Current_FY_Actual_Q1_Days__c;
                            metricnew.Previous_FY_Actual_Q2_Days__c=prevMet.Current_FY_Actual_Q2_Days__c;
                            metricnew.Previous_FY_Actual_Q3_Days__c=prevMet.Current_FY_Actual_Q3_Days__c;
                            metricnew.Previous_FY_Actual_Q4_Days__c=prevMet.Current_FY_Actual_Q4_Days__c;
                        }   
                        else if(metricnew.RecordTypeId == MDFRecordTypeId){//MDF
                            metricnew.Previous_Year_MDF_Spent_Q1__c=prevMet.MDF_Spent_Amount_Q1__c;
                            metricnew.Previous_Year_MDF_Spent_Q2__c=prevMet.MDF_Spent_Amount_Q2__c;
                            metricnew.Previous_Year_MDF_Spent_Q3__c=prevMet.MDF_Spent_Amount_Q3__c;
                            metricnew.Previous_Year_MDF_Spent_Q4__c=prevMet.MDF_Spent_Amount_Q4__c;
                        }
                    }           
                }
            } 
        }
        if(Trigger.IsUpdate){
        System.debug('Update****');
            List<Metrics__c> toUpdateList= new List<Metrics__c>();
            for(Metrics__c metricnew: newMetricList){
                for(String metCombvar: newMetricCombSUbplanId.keySet()){
                    if(metricnew.BG__c+metricnew.Metrics_Type__c+metricnew.RecordTypeId+'|'+metricnew.GbuSpecializationPlan__c == metCombvar){
                        Metrics__c prevMet = new Metrics__c();
                        prevMet=newMetricCombSUbplanId.get(metricnew.BG__c+metricnew.Metrics_Type__c+metricnew.RecordTypeId+'|'+metricnew.GbuSpecializationPlan__c);
                        if(metricnew.RecordTypeId== AttachRecordTypeId  || metricnew.RecordTypeId == bgPercentRecordTypeId || metricnew.RecordTypeId== hpShareBusinessRecordTypeId){
                            prevMet.Previous_FY_Actual_Q1_percent__c=metricnew.Current_FY_Actual_Q1_percent__c;
                            prevMet.Previous_FY_Actual_Q2_percent__c=metricnew.Current_FY_Actual_Q2_percent__c;
                            prevMet.Previous_FY_Actual_Q3_percent__c=metricnew.Current_FY_Actual_Q3_percent__c;
                            prevMet.Previous_FY_Actual_Q4_percent__c=metricnew.Current_FY_Actual_Q4_percent__c;
                            toUpdateList.add(prevMet);
                        }
                        else if(metricnew.RecordTypeId== bgDollarRecordTypeId || metricnew.RecordTypeId == salesRecordTypeId || metricnew.RecordTypeId == salesGoalAttRecordTypeId){//BG Specific $, Sales Goal Attainment, Sales
                            prevMet.Previous_FY_Actual_Q1__c=metricnew.Current_FY_Actual_Q1__c;
                            prevMet.Previous_FY_Actual_Q2__c=metricnew.Current_FY_Actual_Q2__c;
                            prevMet.Previous_FY_Actual_Q3__c=metricnew.Current_FY_Actual_Q3__c;
                            prevMet.Previous_FY_Actual_Q4__c=metricnew.Current_FY_Actual_Q4__c;
                            toUpdateList.add(prevMet);
                        }
                        else if(metricnew.RecordTypeId == bgDaysRecordTypeId || metricnew.RecordTypeId == weekOfInventoryRecordTypeId || metricnew.RecordTypeId == agedInventoryRecordTypeId){//BG Specific #
                            prevMet.Previous_FY_Actual_Q1_Days__c=metricnew.Current_FY_Actual_Q1_Days__c;
                            prevMet.Previous_FY_Actual_Q2_Days__c=metricnew.Current_FY_Actual_Q2_Days__c;
                            prevMet.Previous_FY_Actual_Q3_Days__c=metricnew.Current_FY_Actual_Q3_Days__c;
                            prevMet.Previous_FY_Actual_Q4_Days__c=metricnew.Current_FY_Actual_Q4_Days__c;
                            toUpdateList.add(prevMet);
                        }   
                        else if(metricnew.RecordTypeId == MDFRecordTypeId){//MDF
                            prevMet.Previous_Year_MDF_Spent_Q1__c=metricnew.MDF_Spent_Amount_Q1__c;
                            prevMet.Previous_Year_MDF_Spent_Q2__c=metricnew.MDF_Spent_Amount_Q2__c;
                            prevMet.Previous_Year_MDF_Spent_Q3__c=metricnew.MDF_Spent_Amount_Q3__c;
                            prevMet.Previous_Year_MDF_Spent_Q4__c=metricnew.MDF_Spent_Amount_Q4__c;
                            toUpdateList.add(prevMet);
                        }
                    }           
                }
            } 
            if(toUpdateList.size()>0){
            try{
                Database.update(toUpdateList);
            }Catch(Exception e){
                 system.debug('**Exception in MetricUpdateMethod ****' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
            }
            }
        }
    }
}