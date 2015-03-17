/**
 * Trigger Name: PCLMOpptySalesTeamAfterInsert 
 * Author: HP
 * Date: 03-Jan-2013
 * Requirement # Request Id: 
 * Description: Trigger invoked after inserting sales team member in an Opportunity.
 */
trigger PCLMOpptySalesTeamAfterInsert on OpportunityTeamMember (after insert) {
	Global_Config__c globalConfig = Global_Config__c.getInstance(); 
	if(globalConfig!=null){        
		// Do nothing if mute triggers set to true         
		if( globalConfig.Mute_Triggers__c == True ) {
			return; 
		}
	}
	/*PCLM_OpptySalesTeamUtil.shareOpptyWithSalesTerritoryUsers(trigger.new);*/
	PCLM_OpptySalesTeamUtil.shareOpptyWithSalesTerritoryUsersForLocation(trigger.new);
}