trigger CampaignBeforeDelete on CampaignMember (before delete) {
  
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    CampaignTriggerControllers.beforeDelete();
}