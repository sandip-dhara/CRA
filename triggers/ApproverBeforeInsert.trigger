/****************************************
Author: Mousumi Panda
Created Date: 26-July-2013
Release: R6
Capability: Deal Governance
Description: Validation rules to restrict an user form creating approvers when he is not a coordinator and work space is closed.
****************************************/
trigger ApproverBeforeInsert on WS_Approver__c (before insert) {
Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
ApproverTriggerController.lockCreateApprover(Trigger.New);
}