/**********************************************************
* Trigger Name: DealRegOpportunityLineItemBeforeDelete 
* Author: HP
* Date: 18-JULY-2013 
* Description: This trigger will fire when OpportunityLineItem records are deleted from Opportunity and
**corresponding Product Registration records will be deleted.
**********************************************************/
trigger DealRegOpportunityLineItemBeforeDelete on OpportunityLineItem (before delete) {
    List<Id> opportunityIdList = new List<Id>();
    List<String> ProductLineList = new List<String>();
    
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    OpportunityProductTriggerController testTrigger = new OpportunityProductTriggerController();
    testTrigger.controlDeleteProdReg(Trigger.Old);
}