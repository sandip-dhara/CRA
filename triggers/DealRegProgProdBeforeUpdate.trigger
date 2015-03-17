/**
* Trigger Name: DealRegProgProdBeforeUpdate
* Author: HP
* Date: 08-Oct-2012 
* Requirement # Request Id: 3396
* Description: To check if there are Program product Association already present in the database
*/
trigger DealRegProgProdBeforeUpdate on Program_Product_Association__c(before update){
Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(null != globalConfig){        
        // Do nothing if mute triggers set to true         
        if(globalConfig.Mute_Triggers__c == True){
            return; 
        }
    }
    DealReg_ProgProductTriggerController progProdAssociation = new DealReg_ProgProductTriggerController();
    progProdAssociation.progProductRecordBeforeUpdate(trigger.newMap, trigger.oldMap);    
}