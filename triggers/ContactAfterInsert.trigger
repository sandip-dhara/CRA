/**
* Trigger Name: ContactAfterInsert
* Author: Accenture
* Date: 3-JULY-2012 
* Requirement # 1682
* Description: Contact's BU should be updated with Contact's Owners BU on insert .
*/

trigger ContactAfterInsert on Contact (after insert) {

        Global_Config__c globalConfig = Global_Config__c.getInstance(); 
        if(globalConfig!=null){        
            // Do nothing if mute triggers set to true         
            if( globalConfig.Mute_Triggers__c == True ) {
                return; 
            }
        }
    
    if(Trigger.isInsert){
        //Contact's BU Information on Insert.
        FlagContactByBU.insertBUInformation(trigger.newMap);
    }
    
    
}