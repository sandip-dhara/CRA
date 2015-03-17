/*
* Trigger Name: CIOpptyAfterInsert  
* Author: HP
* Date: 28-MAR-2013
* Req#:
* Description: Actions to be performed after Delete on Campaign_Influence__c object
*/

trigger CIOpptyAfterDelete on Campaign_Influence__c (after delete) {

CampaignInfluenceTriggerUtil CITriggerUtil = new CampaignInfluenceTriggerUtil();
CITriggerUtil.removeOpptyAssociationAfterDelete(Trigger.Old);

}