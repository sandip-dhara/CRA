Trigger OpportunityCreateActivity on Opportunity (before update){

    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if(globalConfig.Mute_Triggers__c == True) {
            return; 
        }
    }
    
    OpportunityActivityPlan.CreateActivityForOptyUpdation(Trigger.New,Trigger.oldMap);

}