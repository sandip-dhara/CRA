/**
* Author: Shaijan Thomas
* Date: 13-JULY-2012 
* Requirement # Request Id: 1704(US-0573)
* Description: When deletes Team, Remove Team Names from each team member users Team Field
*/
trigger UpdateUserFieldon_Team_Delete on Team__c (Before delete) 
{
    UpdateUserTeamsTriggerController.BeforeDelete(trigger.Old);
}