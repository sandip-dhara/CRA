/**********************************************************
 * Class Name:JBP_MetricsBeforeInsertController 
 * Author: HP  
 * Date: 25-Mar-2013
 * Requirement # Request Id: 5399
 * Description:This is a controller for the Metrics__c before Insert Trigger.
 **********************************************************/
public class JBP_MetricsBeforeInsertController{

    /* ReqNumber -- 5399 Added by Sameer --  STARTS
     *  @description: This method is used to check if there are any records with the same record type for the same sub-plan. 
     *                If found then an error is thrown.
     *  @Params: trigger.new (list<metrics__c>)
     *  @return: void
     */

public static void avoidDuplicateRecord(list<metrics__c> newMetricList){

//Variable declarations.
map<id, list<metrics__c>> existingMetricMap = new map<id, list<metrics__c>>();
map<id, list<metrics__c>> newMetricsInsert = new map<id, list<metrics__c>>();
Map<Id, String> subPlanBGMap = new Map<Id, String>();
set<Id> gbuIdSet = new set<id>();
    //Check for duplicacy in the data supplied. 
    for(Metrics__c met : newMetricList){
        gbuIdSet.add(met.GBUSpecializationPlan__c);
        if(newMetricsInsert.containsKey(met.GBUSpecializationPlan__c)){
            for(metrics__c m : newMetricsInsert.get(met.GBUSpecializationPlan__c)){
                if(met.recordTypeId == m.recordTypeId && met.Metrics_Type__c== m.Metrics_Type__c && met.BG__c== m.BG__c && met.GbuSpecializationPlan__c== m.GbuSpecializationPlan__c){
                    met.addError(system.Label.Inconsistent_Data);
                }
            }
            list<metrics__c> tempMetricsList = newMetricsInsert.get(met.GBUSpecializationPlan__c);
            tempMetricsList.add(met);
            newMetricsInsert.put(met.GBUSpecializationPlan__c, tempMetricsList);
        }else{
            list<metrics__c> tempMetricsList = new list<metrics__c>();
            tempMetricsList.add(met);
            newMetricsInsert.put(met.GBUSpecializationPlan__c, tempMetricsList);
        }
    }
    if(gbuIdSet.size()>0){
        list<GBU_Specialization_Plans__c> gburec=[Select Id,  Business_Group__c from GBU_Specialization_Plans__c where Id IN:gbuIdSet];
        for(GBU_Specialization_Plans__c gbu: gburec){
            subPlanBGMap.put(gbu.Id, gbu.Business_Group__c);
        }
        for(metrics__c metric: [SELECT recordTypeId,GBUSpecializationPlan__c,GBUSpecializationPlan__r.name, BG__c, Metrics_Type__c
                                FROM metrics__c 
                                WHERE GBUSpecializationPlan__c 
                                IN : gbuIdSet]){
            if(existingMetricMap.containsKey(metric.GBUSpecializationPlan__c)){
                list<metrics__c> tempMetricList = existingMetricMap.get(metric.GBUSpecializationPlan__c);
                tempMetricList.add(metric);
                existingMetricMap.put(metric.GBUSpecializationPlan__c, tempMetricList);
            }else{
                list<metrics__c> tempMetricList = new list<metrics__c>();
                tempMetricList.add(metric);
                existingMetricMap.put(metric.GBUSpecializationPlan__c, tempMetricList);
            }
        }
    } 
    //Check if any of the record exit in the system.
    for(Metrics__c metrics : newMetricList){
        if(metrics.BG__c == subPlanBGMap.get(metrics.GBUSpecializationPlan__c)){
            if(existingMetricMap.containsKey(metrics.GBUSpecializationPlan__c)){
                for(metrics__c met : existingMetricMap.get(metrics.GBUSpecializationPlan__c)){
                    if(metrics.BG__c == met.BG__c && metrics.recordTypeId == met.recordTypeId && (String)(metrics.Metrics_Type__c).deleteWhitespace()== (String)(met.Metrics_Type__c).deleteWhitespace() &&met.GBUSpecializationPlan__c== met.GBUSpecializationPlan__c){
                        metrics.addError(System.Label.JBP_MetricsDuplicateCheck);
                    }
                }
            }
        }else{
            metrics.addError(System.Label.JBP_MetricBGCheck);
        }
    }
}
//Req# 5399  Added by sameer -- ENDS

}