/****************************************************************
* Tigger Name: Account_Plan_Before_Insert
* Author: HP
* Date:05/03/2013 
* Requirement:  
* Description: Tigger to execute before insert of Account Plan
****************************************************************/
trigger Account_Plan_Before_Insert on Account_Plan__c (before insert) 
{
    Account acc;
    for(Account_Plan__c abp : trigger.new)
    {
        acc = [Select id, Confidential_Account__c from Account where id =: abp.Primary_AccountAccount__c];
        if(acc.Confidential_Account__c == true)
        {
            abp.Private_Account__c = true;
        }
    }   
}