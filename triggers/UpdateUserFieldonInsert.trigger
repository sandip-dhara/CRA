/**
* Author: Shaijan Thomas
* Date: 13-JULY-2012 
* Requirement # Request Id: 1704(US-0573)
* Description: When Insert Team Member, Update Team Name to users Teaam Field
*/
trigger UpdateUserFieldonInsert on Team_Member__c (after Insert)
{ 
    UpdateUserTeamsTriggerController.afterInsert(trigger.New);
}