/**
 * Trigger Name: JBP_AfterInsertUpdate
 * Author: HP
 * Date: 21-Mar-2013 
 * Requirement # Request Id: 5418, 6249
 * Description: JBP Record is shared to the Hp Management Approver in order to Approve the Record
 *               and to share the JBP plan witn Non external territory groups of Account 
 * Edited Date: 23-July-2013
 */
trigger JBP_AfterInsertUpdate on JBP__c (after insert,after update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    if(trigger.isInsert){
        Map<Id,JBP__c> PlansMap = new Map<Id,JBP__c>();
        for(JBP__c jbp: trigger.new){
            if(jbp.Partner_Account__c != null)
                PlansMap.put(jbp.id,jbp);
        }
        if(PlansMap.size() >0){
            /* To share the plan to the Non external territory Groups of Plan Account */
            JBP_PlanShareCollabUtil.sharePlantoNonExternalTerritories(PlansMap);
        }
        /*Share the JBP record for the Approver*/
        JBP_PlanShareCollabUtil.afterInsert(Trigger.new);
    }
    else if(trigger.isUpdate){
        /*Share the JBP record for the Approver*/
        JBP_PlanShareCollabUtil.afterUpdate(Trigger.new, Trigger.old);
    }    
}