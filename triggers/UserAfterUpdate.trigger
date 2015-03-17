trigger UserAfterUpdate on User (after update) {
    
    /* @description: The below class will assign permission sets to users based on the user rights triggered from Siebel.
    *  It has to be executed even if Mute Trigger is set to True.
    *  Added as part of R6 by PRM Team
    *  Requirement # : 
    */
    UserTriggerControllerForPermissionSet.afterUpdate(trigger.newMap, trigger.oldMap);
    
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if(globalConfig.Mute_Triggers__c) {
            return; 
        }
    }
    UserTriggerController.afterUpdate(trigger.newMap, trigger.oldmap);
}