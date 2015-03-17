/**
* Class Name: UserBeforeInsert
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Contains Before Insert support action methods for trigger on user object
*/
trigger UserBeforeInsert on User (before insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    UserTriggerController.beforeInsert();
}