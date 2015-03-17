/**
* Class Name: SupportRequestRoutingRulesBeforeUpdate 
* Author: Accenture
* Date: 29-Apr-2012 
* Requirement # Request Id: 
* Description: Calls Before Update support action methods for trigger on SupportRequest_Routing_Rules__c object
*/

trigger SupportRequestRoutingRulesBeforeUpdate on SupportRequest_Routing_Rules__c(Before Update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    SupportRoutingRulesTriggerController.beforeUpdate();
}