trigger AccountBeforeInsert on Account (before insert) {

  /*Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
     }*/
     
        AccountTriggerSequenceController.beforeInsert(Trigger.new);
   
}