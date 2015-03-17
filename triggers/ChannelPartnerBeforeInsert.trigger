/**
* Class Name: ChannelPartnerAfterInsert 
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Contains After update support action methods for trigger on Channel_Partner__c object
*/
trigger ChannelPartnerBeforeInsert on Channel_Partner__c (before insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
    ChannelPartnerTriggerController.beforeInsert(trigger.New);
    
}