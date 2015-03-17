/*
* Name : BGAccountDataAfterInsert 
* Event : after insert
* Desc : Trigger to create BG Account Data on Account level
*/

trigger BGAccountDataAfterInsert on BG_Account_Data__c (after insert) {
 
  
    //Method for Insert
    TriggerClassForBGAccountData.bgAccountInsertUpdate(trigger.new);

}