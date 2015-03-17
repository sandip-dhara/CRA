/**
* Class Name: AccountBeforeUpdate
* Author: Accenture
* Date: 21-APR-2012 
* Requirement # Request Id: 
* Description: Except Integration user, do not allow all other users to modify account field values.
*/
Trigger AccountBeforeUpdate on Account (before update) {
    
    /*Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }*/
    
    // Bypass validation for Lead Conversion
    if (!LeadConvertController.fromLeadConversion) {
        AccountTriggerController.validatePermissions();
        
    }
     AccountTriggerSequenceController.beforeUpdate(Trigger.newMap, Trigger.oldMap);
     //AccountTriggerSequenceController.partnerLeadStatusNotInactiveToProbation(Trigger.newMap,Trigger.oldMap);  
     
     /*TM:Vinay R6 EF1:Req-Id:7525 Start*/
    //Setting Private_Flag_Status__c based on Confidential_Account__c  flag
   
    Map<Id,Account> newAccMap = trigger.newMap;
    Map<Id,Account> oldAccMap = trigger.oldMap;
    
    if((null != newAccMap && !newAccMap.isEmpty()) && (null != oldAccMap && !oldAccMap.isEmpty())){
        for(Id accId:newAccMap.keySet()){
            Account oldRec = oldAccMap.get(accId);
            Account newRec = newAccMap.get(accId);
            if(oldRec.Confidential_Account__c == false && newRec.Confidential_Account__c == true ){
                newRec.Private_Flag_Status__c = 'Marked Private';
            }else if(oldRec.Confidential_Account__c == true && newRec.Confidential_Account__c == false){
                newRec.Private_Flag_Status__c = 'Marked Non-Private';
            }
        }
    }
    
    /*TM:Vinay R6 EF1:Req-Id:7525 End*/ 
}