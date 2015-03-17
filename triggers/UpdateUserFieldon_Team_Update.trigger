/**
* Author: Shaijan Thomas
* Date: 13-JULY-2012 
* Requirement # Request Id: 1704(US-0573)
* Description: When Team Name updates, Update Team Name on each team users Teams Field with new Team Name
*/
trigger UpdateUserFieldon_Team_Update on Team__c (after update) 
{
   UpdateUserTeamsTriggerController.AfterTeamUpdate(trigger.New, trigger.Old); 
}