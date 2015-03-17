/**
 * Trigger Name:    DealRegProgramPartnerAssociation
 * Author:          HP
 * Date:            08-Oct-2012 
 * Requirement Id:  3396,4086
 * Description:
 * Last Modified:   29-Nov-2012 R4 requirement # 4086, for adding Permission set to Partner Users.
 *              :   Commented and in activated the trigger as part of R6
 */
trigger DealRegProgramPartnerAssociation on Program_Partner_Association__c (before insert, after insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance();    
    if(null!=globalConfig){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }/* Commented as part of R6
    // Trigger for beforeInsert 
    if(Trigger.isBefore && Trigger.isInsert){
        DealReg_ProgPartTrgController.progPartnerRecordBeforeInsert(trigger.new);
    }
    // Trigger for afterInsert 
    if(Trigger.isAfter && Trigger.isInsert){
        DealReg_ProgPartTrgController.AddtoPartnerProgramUser(trigger.new);
    }
    */
}