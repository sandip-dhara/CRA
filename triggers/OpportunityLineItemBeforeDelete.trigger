/**
* Trigger Name: OpportunityLineItemBeforeDelete 
* Author: Accenture
* Date: 30-APR-2012 
* Requirement # Request Id:
* Description: To perform actions Before Delete on Opportunity Products
*/


/*
Abrar- 05-06-2012 : commented the mute trigger code for ALM2845
*/
trigger OpportunityLineItemBeforeDelete on OpportunityLineItem (before delete) {
    /* Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    */
    OpportunityLineItemTriggerController.beforeDelete();
}