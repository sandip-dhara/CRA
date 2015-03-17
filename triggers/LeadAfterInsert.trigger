/**
* Trigger Name: LeadAfterInsert
* Author: Accenture
* Date: 19-JULY-2012 
* Requirement # Request Id: 
* Description: To perform actions After Insert on Lead
*/
trigger LeadAfterInsert on Lead (after insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig != null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    LeadTriggerController.afterInsert(Trigger.newMap, Trigger.oldMap);
}