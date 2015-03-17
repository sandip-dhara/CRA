/**
* Author: Shaijan Thomas
* Date: 13-JULY-2012 
* Requirement # Request Id: 1704(US-0573)
* Description: When deletes Team Member, Remove Team Name from users Teaam Field
*/
trigger UpdateUserFieldonDelete on Team_Member__c (after delete)
{ 
    UpdateUserTeamsTriggerController.afterDelete(trigger.Old);
}