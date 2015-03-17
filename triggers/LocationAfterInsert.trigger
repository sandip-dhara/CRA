/**
* Trigger Name: LocationAfterInsert 
* Author: HP
* Date: 12-March-2013 
* Description: Trigger invoked after inserting Location object record.
*/
trigger LocationAfterInsert on Location__c (after insert) {
        
      /*  Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }*/
    
        LocationUtil.createPartnerAccQueueOnLocInsert(trigger.new);
}