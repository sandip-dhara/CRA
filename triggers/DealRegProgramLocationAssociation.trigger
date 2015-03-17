/*
 * Trigger Name:    DealRegProgramLocationAssociation
 * Author:          HP
 * Date:            04-04-2013 
 * Requirement Id:  
 * Description:     List of all triggers related to Program_Location_Association object
 */
trigger DealRegProgramLocationAssociation on Program_Location_Association__c (before insert, after insert, before update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance();    
    if(null!=globalConfig){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
    /* Trigger for beforeInsert*/ 
    if(Trigger.isBefore && Trigger.isInsert){
        DealReg_ProgLocTrgController beforeInsert = new DealReg_ProgLocTrgController();
        beforeinsert.progLocBeforeInsert(trigger.new);
    }
    /* Commented as part of R6
    // Trigger for afterInsert 
    if(Trigger.isAfter && Trigger.isInsert){
        DealReg_ProgLocTrgController.assignPermissiontoUsers(trigger.new);
    }
    */
    /* Trigger for beforeUpdate */
    if(Trigger.isBefore && Trigger.isUpdate){
        DealReg_ProgLocTrgController beforeUpdate = new DealReg_ProgLocTrgController();
        beforeUpdate.progLocBeforeUpdate(trigger.newMap,trigger.oldMap);
    }
    
}