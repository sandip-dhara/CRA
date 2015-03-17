/**
 * Trigger Name: DealRegProgPartBeforeInsert
 * Author: HP
 * Date: 08-Oct-2012 
 * Requirement # Request Id: 3396
 * Description: Eliminate duplicate association of Partner to Program(Campaign)
 * Last Modified :Created for Campaign set up -9th Oct 2012
 *               :Made it In active and commented as part of R6
 */
trigger DealRegProgPartBeforeInsert on Program_Partner_Association__c (before insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance();    
    if(null!=globalConfig){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
   /* Commented as Part of R6
    DealReg_DuplicatePartnerAssoCheck duplicatePartnerCheck = new DealReg_DuplicatePartnerAssoCheck();       
    duplicatePartnerCheck.progPartnerRecordBeforeInsert(trigger.new);
    */
}