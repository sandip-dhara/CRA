/**
* Class Name: ChannelPartnerAfterUpdate
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Calls After update support action methods for trigger on Channel_Partner__c object
*/
trigger CampaignMemberAfterUpdate on CampaignMember(after update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    CampaignTriggerControllers.afterUpdate(trigger.OldMap,trigger.NewMap);
}