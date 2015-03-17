/*
* Name : BGAccountDataAfterUpdate 
* Event :  after update
* Desc : Trigger to update BG Account Data on Account level
*/

trigger BGAccountDataAfterUpdate on BG_Account_Data__c (after update) {

    
    //Method for Update
    TriggerClassForBGAccountData.bgAccountInsertUpdate(trigger.New);

}