/**
 * Trigger Name: ApprovalBeforeInsert
 * Author: HP
 * Date: 27-SEP-2012 
 * Requirement # Request Id: 
 * Description: This trigger is to update one field of Approval.
 */

trigger ApprovalBeforeInsert on Approval__c (before Insert, before Update) {
	Global_Config__c globalConfig = Global_Config__c.getInstance();
	if(globalConfig.Mute_Triggers__c == False){
		for(Approval__C r:trigger.new){
			List<EmailTemplate> e=[Select id From EmailTemplate Where Name=:r.Approval_Type__C];
			if(e.size()>0){
				r.Template_Id__c= e[0].id;
			}
		}
	}
}