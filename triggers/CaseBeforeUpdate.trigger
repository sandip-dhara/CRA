/**
* Class Name: CaseBeforeUpdate 
* Author: Accenture
* Date: 3-May-2012 
* Requirement # Change Request Id: 683
* Description: Trigger on Case before update
*/

trigger CaseBeforeUpdate on Case (before update) {
List<CaseMilestone> cmUpdate=new List<CaseMilestone>();
List<Support_Request__c> srsupdate = new List<Support_Request__c>();
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if(globalConfig.Mute_Triggers__c == True) {
            return; 
        }
    }
    
    If(HPUtils.CaseAfterInsert == False){
    CaseTriggerUtil.CaseMileStonesUpdate(Trigger.new); 
    CaseTriggerUtil.CaseWorldRegionUpdate(Trigger.new);   
    }
     /**********R5.0 Customer Operations Owner Deepak Saxena Closed*************/
     /** R6.0 EF code bala */
 
for(Case c: Trigger.new){
                    
 if((c.Request_Type__c!=Trigger.oldMap.get(c.ID).Request_Type__c)|| (c.Program_Type__c!=Trigger.oldMap.get(c.ID).Program_Type__c) || (c.Business_Type__c!=Trigger.oldMap.get(c.ID).Business_Type__c)||((c.Case_Classification__c!=Trigger.oldMap.get(c.ID).Case_Classification__c)&& c.ParentId!=null)||(c.Country__c!=Trigger.oldMap.get(c.ID).Country__c))
 {
 c.Due_Date__c = null; 
   CaseTriggerUtil.SetCaseEntitlements(Trigger.new);
 }                  
}


     /** R6.0 EF code bala end */
    
   
}