/**
* Trigger Name: AccountAfterUpdate
* Author: Accenture
* Date: 24-JULY-2012 
* Description: When Account gets successfully updated, perform related activites
*/
trigger AccountAfterUpdate on Account (after update) {
    //AccountTriggerController.afterUpdate(trigger.newMap, trigger.oldMap);
    LocationUtil.createQueueForPartnerAccs(trigger.newMap, trigger.oldMap);
}