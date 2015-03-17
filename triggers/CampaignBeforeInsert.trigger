/**
* Class Name: CampaignBeforeInsert
* Author: Accenture
* Date: 5-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Campaign Member object
*/
trigger CampaignBeforeInsert on CampaignMember (before insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if(globalConfig.Mute_Triggers__c == True) {
            return; 
        }
    }
    CampaignTriggerControllers.beforeInsert();
}