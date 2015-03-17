/**
* Trigger Name: MetricsBeforeInsert
* Author: HP
* Date: 25-Mar-2013 
* Requirement # Request Id: 5399 , 5472 
* Description: Ability for previous year actuals (from prev. year's JBP)
* to become this years previous year data. 
* Edited Date: 25- July-2013
*/

Trigger MetricsBeforeInsert on Metrics__c (before Insert) {

     Global_Config__c globalConfig = Global_Config__c.getInstance(); 
        if(globalConfig!=null){        
            // Do nothing if mute triggers set to true         
            if( globalConfig.Mute_Triggers__c == True ) {
                return; 
            }
        }
    //Req# 5399 added by Sameer -- Start
    JBP_MetricsBeforeInsertController.avoidDuplicateRecord(trigger.new);
    //Req# 5399   added by Sameer -- End
    //Req# 5472 added by Amala --- Start
    JBP_MetricsTriggerController.populatePreviousValues(trigger.new);
    //Req# 5472 added by Amala --- End
    
}