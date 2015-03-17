/**
 * Trigger Name: PCLMOpptySalesTeamBeforeDelete 
 * Author: HP
 * Date: 03-Jan-2013
 * Requirement # Request Id: 
 * Description: Trigger invoked while removing sales team member in an Opportunity.
 */
trigger PCLMOpptySalesTeamBeforeDelete on OpportunityTeamMember (before delete) {
	Global_Config__c globalConfig = Global_Config__c.getInstance(); 
	if(globalConfig!=null){        
		// Do nothing if mute triggers set to true         
		if( globalConfig.Mute_Triggers__c == True ) {
			return; 
		}
	}
	/*PCLM_OpptySalesTeamUtil.removeOpptyShareFromSalesTerritoryUsers(trigger.old);*/
	PCLM_OpptySalesTeamUtil.removeOpptyShareFromSalesTerritoryUsersForLocation(trigger.old);
}