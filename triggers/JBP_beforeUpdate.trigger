/**
* Trigger Name: JBP_beforeUpdate
* Author: HP
* Date: 22-July-2013 
* Requirement Id: 7025
* Description: All Partner contact fields on SFDC should only allow contacts to be selected
* which are associated to the account the plan is associated to.
* And Populate the Partner User by checking JBP Capability
*/

trigger JBP_beforeUpdate on JBP__c (before update) {
Global_Config__c globalConfig = Global_Config__c.getInstance(); 
     if(globalConfig!=null){        
     // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
           return; 
        }
     }
    //Req# 7025 added by Amala-- Start
    JBP_TriggerController.beforeUpdate(trigger.newMap, trigger.oldMap);
    //Req# 7025 added by Amala-- End
}