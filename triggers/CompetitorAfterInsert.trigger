/**
* Class Name: CompetitorAfterInsert 
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Contains After update support action methods for trigger on Competitors__c object
*/
trigger CompetitorAfterInsert on Competitors__c (after Insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    CompetitorTriggerController.afterInsert(trigger.NewMap);
}