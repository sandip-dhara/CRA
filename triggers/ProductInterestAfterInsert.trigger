/**
* Trigger Name: ProductInterestAfterInsert
* Author: Accenture
* Date: 13-AUG-2012\
* Change Request#: CR-0125  
* Description: After inserting product interests need to update 1st two product names on lead
*/
trigger ProductInterestAfterInsert on Product_Interest__c (after insert) {
	Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig != null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    ProductInterestTriggerController.afterInsert(Trigger.new);
}