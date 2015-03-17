/**
* Trigger Name: JBP_subplanBeforeUpdate
* Author: HP
* Date: 29-July-2013 
* Requirement # Request Id: 5472
* Description: 

*/
trigger JBP_subplanBeforeUpdate on GBU_Specialization_Plans__c (Before Update) {
 Global_Config__c globalConfig = Global_Config__c.getInstance(); 
     if(globalConfig!=null){        
     // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
           return; 
        }
     }
    //Req# 5472 added by Amala-- Start
    JBP_SubPlanTriggerController.beforeUpdate(trigger.newMap, trigger.oldMap);
    //Req# 5472 added by Amala-- End
}