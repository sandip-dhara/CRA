/**
* Trigger Name: ContactAfterUpdate
* Author: Accenture
* Date: 3-JULY-2012 
* Requirement # 1682
* Description: Contact's BU should be updated with Contact's Owners BU on update.
*/

trigger ContactAfterUpdate on Contact (after update) {

            Global_Config__c globalConfig = Global_Config__c.getInstance(); 
            if(globalConfig!=null){        
                // Do nothing if mute triggers set to true         
                if( globalConfig.Mute_Triggers__c == True ) {
                    return; 
                }
            }
    
    if (Trigger.isUpdate){
        //Contact's BU Information on Update.
        FlagContactByBU.updateBUInformation(trigger.new, trigger.old);
    }
}