/**
* Trigger Name: MetricsBeforeUpdate
* Author: HP
* Date: 25-July-2013 
* Requirement # Request Id: 5472
* Description: Ability for previous year actuals (from prev. year's JBP)
* to become this years previous year data.

*/
trigger MetricsBeforeUpdate on Metrics__c (before Update) {

     Global_Config__c globalConfig = Global_Config__c.getInstance(); 
        if(globalConfig!=null){        
            // Do nothing if mute triggers set to true         
            if( globalConfig.Mute_Triggers__c == True ) {
                return; 
            }
        }
    //Req# 5472 added by Amala-- Start
    JBP_MetricsTriggerController.beforeUpdate(trigger.newMap, trigger.oldMap);
    //Req# 5472 added by Amala-- End
}