/**
* Trigger Name: LocationBeforeUpdate 
* Author: HP
* Date: 20-March-2013 
* Description: Trigger invoked before updating location object record.
*/

trigger LocationBeforeUpdate on Location__c (before update) {

Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }

    LocationTriggerController.toUpdateStrikeCount(trigger.NewMap,trigger.OldMap);
    LocationTriggerController.locationStatusNotInactiveToNoncompliant(trigger.NewMap,trigger.OldMap);
    /**
    *TM:R5:Req-6021:HP: Vinay M
    *Description:Trigger to set evaluate territory flag to true on field change
    **/
    LocationTriggerController.beforeUpdate(trigger.NewMap,trigger.OldMap);
}