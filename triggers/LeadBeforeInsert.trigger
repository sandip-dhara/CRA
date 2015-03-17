/**
* Trigger Name: LeadBeforeInsert
* Author: Accenture
* Date: 4-APR-2012 
* Requirement # Request Id: 323
* Description: To perform actions After Insert on Lead
*/
trigger LeadBeforeInsert on Lead (before insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig != null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    system.debug('Trigger.new'+Trigger.new);
    LeadTriggerController.beforeInsert(Trigger.new);
}