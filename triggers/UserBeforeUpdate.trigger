/**
* Class Name: UserBeforeUpdate
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Contains Before update support action methods for trigger on user object
*/
trigger UserBeforeUpdate on User (before update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    UserTriggerController.beforeUpdate();
    UserTriggerController.beforeUpdate(trigger.newMap, trigger.oldmap);
}