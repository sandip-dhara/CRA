/**
* Class Name: SupportRequestRoutingRulesBeforeInsert 
* Author: Accenture
* Date: 29-Apr-2012 
* Requirement # Request Id: 
* Description: Calls Before Insert support action methods for trigger on SupportRequest_Routing_Rules__c object
*/

trigger SupportRequestRoutingRulesBeforeInsert on SupportRequest_Routing_Rules__c(Before Insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    SupportRoutingRulesTriggerController.beforeInsert();
}