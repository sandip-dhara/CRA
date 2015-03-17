/**
* Trigger Name: JBP_subplanBeforeInsert
* Author: HP
* Date: 29-July-2013 
* Requirement # Request Id: 5472
* Description: 
*/

trigger JBP_subplanBeforeInsert on GBU_Specialization_Plans__c (before Insert) {
Global_Config__c globalConfig = Global_Config__c.getInstance(); 
     if(globalConfig!=null){        
     // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
           return; 
        }
     }
    //Req# 5472 added by Amala-- Start
    JBP_SubPlanTriggerController.beforeInsert(trigger.new);
    //Req# 5472 added by Amala-- End
}