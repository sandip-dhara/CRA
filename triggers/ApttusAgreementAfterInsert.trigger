/**
 * Trigger Name: ApttusAgreementAfterInsert 
 * Author: HP
 * Date: 30/4/2013
 * Requirement # Request Id: 
 * Description: Updating the Support Request with agreement Row Id.
 */
trigger ApttusAgreementAfterInsert on Apttus__APTS_Agreement__c (after insert) {
   Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
   Apttus_AgreementRequestCreation.updateSR(trigger.new);
  }