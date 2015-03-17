/**
* Trigger Name: AgreementCreation
* Author: HP (Sreekanth)
* Date: 21-Feb-2013
* Description: Support Request page layout.
*/

trigger ApttusSupportRequestAfterUpdate on Support_Request__c (after update) {
     Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    Apttus_supportRequestUtil.afterUpdate(trigger.new,trigger.oldMap,trigger.newMap);
}