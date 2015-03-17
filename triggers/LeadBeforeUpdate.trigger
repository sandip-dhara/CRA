/**
* Trigger Name: LeadBeforeUpdate
* Author: Accenture
* Date: 4-APR-2012 
* Requirement # Request Id: 323
* Description: To perform actions Before Update on Lead
*/
trigger LeadBeforeUpdate on Lead (before update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    LeadTriggerController.beforeUpdate(Trigger.newmap, Trigger.oldmap);
    LeadTriggerController.ContactCenterBeforeUpdateLead(Trigger.newmap);
}