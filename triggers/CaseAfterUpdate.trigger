/**
* Class Name: CaseAfterUpdate 
* Author: Accenture
* Date: 27-APR-2012 
* Requirement # Request Id: 
* Description: Trigger to update country of submitter
*/
trigger CaseAfterUpdate on Case (after update) {
     Set<Id>  AssociateIds = new Set<Id>(); 
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    /** CO R6 Bala */
     for(Case c : Trigger.New){
             if(c.Rework_to__c!=null && c.Status == 'Closed' &&  c.Sub_Case_Type__c =='Quality Check')
            {
            System.debug('Associated case number'+c.Rework_to__c);
            AssociateIds.add(c.Rework_to__c);  
            }
         }
    if(AssociateIds.size()>0)
    {
     CaseTriggerUtil.AssociateMilestonesUpdate(AssociateIds);
    }       
    CaseTriggerController.afterUpdate();
}