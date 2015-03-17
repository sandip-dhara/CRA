/*
* Name : BGAccountDataBeforeDelete 
* Event :before delete
* Desc : Trigger to change value for RAD,Customer Segment,Named Account on Accountwhen data is deleted from BG Account Data
*/
trigger BGAccountDataBeforeDelete on BG_Account_Data__c (before delete) {

           //Method for Delete
    TriggerClassForBGAccountData.bgAccountDelete(trigger.old);
}