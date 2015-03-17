/**
* Class Name: SupportRequestBeforeUpdate 
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Contains Before Update support action methods for trigger on SupportRequest object
*/
trigger SupportRequestBeforeUpdate on Support_Request__c(before update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    SupportRequestTriggerController.beforeUpdate();
}