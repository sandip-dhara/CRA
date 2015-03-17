/**
* Trigger Name:  
* Author: hp
* Date: 
* Description: Actions to be performed after delete on Channel_Partner__c object
*/
trigger ChannelPartnerBeforeDeleteST on Channel_Partner__c (before delete) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
    salesteamtriggercontroler.deletesalesteam(trigger.OldMap);
}