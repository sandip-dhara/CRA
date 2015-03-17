/**
* Trigger Name: LeadAfterUpdate 
* Author: HP
* Date: 22-Aug-2012 
* Requirement # Request Id: 2307
* Description: To perform actions After Update on Lead
*/
trigger LeadAfterUpdate on Lead (after update) {

    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig != null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }

    LeadTriggerController.afterUpdate(Trigger.newMap, Trigger.oldMap);
    
    LeadCollabACPUtil.addLeadShareToPartners(Trigger.newMap);
}