/**
* Class Name: SalesProcessLinkageBeforeInsert 
* Author: Accenture
* Date: 29-Apr-2012 
* Requirement # Request Id: 
* Description: Calls Before Insert support action methods for trigger on Sales_Process_Linkange__c object
*/

trigger SalesProcessLinkageBeforeInsert on Sales_Process_Linkage__c (Before Insert) {
    /*Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }*/
    SalesProcessLinkageTriggerController.beforeInsert();
}