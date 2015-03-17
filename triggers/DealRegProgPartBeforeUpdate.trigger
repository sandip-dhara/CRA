/**
 * Trigger Name: DealRegProgPartBeforeUpdate 
 * Author: HP
 * Date: 08-Oct-2012 
 * Requirement # Request Id: 3396
 * Description: Eliminate duplicate association of Partner to Program(Campaign)
 * Last Modified :Created for Campaign set up -9th Oct 2012
 */
trigger DealRegProgPartBeforeUpdate on Program_Partner_Association__c (before update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance();    
    if(null!=globalConfig){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    DealReg_DuplicatePartnerAssoCheck duplicatePartnerCheck = new DealReg_DuplicatePartnerAssoCheck();       
    duplicatePartnerCheck.progPartnerRecordBeforeUpdate(trigger.newMap,trigger.oldMap);
}