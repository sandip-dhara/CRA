trigger CompetitorAfterDelete on Competitors__c (after delete) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    system.debug('>>>>>Inside delete trigger');
    system.debug('>>>>>Trigger.Old'+trigger.Old);
    CompetitorTriggerController.afterDelete();
    
}