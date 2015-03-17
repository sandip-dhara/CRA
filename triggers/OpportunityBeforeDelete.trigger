/**
  * Trigger Name: OpportunityAfterUpdate
  * Release : HP R2
  * Author: rahul.kunal (Accenture)
  * Date:  
  * Requirement # Request Id: 
  * Description: Calls before Delete on opportunity object.
  */
trigger OpportunityBeforeDelete on Opportunity (before delete) {
    
    try{
    	OppLineItemTriggerController.controlDeleteOpportunityLogic(trigger.oldMap);
    }catch(Exception excp){
     	system.debug('Exception occured for deleting opportunity record: '+excp.getMessage());
     }
    

}