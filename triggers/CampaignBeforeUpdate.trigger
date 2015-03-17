/**
* Class Name: CampaignBeforeUpdate
* Author: Accenture
* Date: 5-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Campaign Member object
*/
trigger CampaignBeforeUpdate on CampaignMember (before update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if(globalConfig.Mute_Triggers__c == True) {
            return; 
        }
    }
    CampaignTriggerControllers.beforeUpdate();
}