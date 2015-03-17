/**
* Class Name: CampaignObjectBeforeInsert 
* Author: Accenture
* Date: 24-JULY-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Campaign object
*/

trigger CampaignObjectBeforeInsert on Campaign (before insert) {

	Global_Config__c globalConfig = Global_Config__c.getInstance(); 
	if (globalConfig != null) {        
    	// Do nothing if mute triggers set to true         
    	if (globalConfig.Mute_Triggers__c == True) {
        	return; 
    	}
	}
    CampaignObjectTriggerController.beforeUpdate(Trigger.new);
}