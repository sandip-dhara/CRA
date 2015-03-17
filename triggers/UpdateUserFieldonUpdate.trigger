/**
* Author: Shaijan Thomas
* Date: 13-JULY-2012 
* Requirement # Request Id: 1704(US-0573)
* Description: When Updates Team Member, Add Team Name from new users Teaam Field and Remove from Old Team Users Field
*/
trigger UpdateUserFieldonUpdate on Team_Member__c (after update)
{ 
    UpdateUserTeamsTriggerController.afterUpdate(trigger.New, trigger.Old);
}