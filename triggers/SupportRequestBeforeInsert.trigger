/**
* Class Name: SupportRequestBeforeInsert
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Contains Before Insert support action methods for trigger on SupportRequest object
*/
trigger SupportRequestBeforeInsert on Support_Request__c(before insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    SupportRequestTriggerController.beforeInsert();
 /**
    * @description: R5---Associating the contact role and Global account in SR from opportunity related list.
    * @param: list of SObject - Support Request
  **/ 
   if(HPUtils.globalAccountFlag == False){
       HPUtils.globalAccountFlag = True;
       SupportRequestTriggerController.beforeInsertForContRole(trigger.new);
      }
    if(HPUtils.contactRoleFlag== False){
       HPUtils.contactRoleFlag= True;
       SupportRequestTriggerController.beforeInsertForGlobalAcct(trigger.new);
      }
}