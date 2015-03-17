/**
* Class Name: ContactBeforeInsert 
* Author: Accenture
* Date: 27-APR-2012 
* Requirement # Change request ID : 147
* Description: Contact Description should be keeping details pertaining to the Customer on Lead conversion.
*/
trigger ContactBeforeInsert on Contact (before insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    ContactTriggerController.beforeInsert();
    
}