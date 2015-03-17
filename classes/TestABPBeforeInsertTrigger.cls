/****************************************************************
* Class Name: TestABPBeforeInsertTrigger
* Author: HP
* Date:11/03/2013 
* Requirement:  
* Description: Test class for Account_Plan_Before_Insert trigger
****************************************************************/
@isTest
public class TestABPBeforeInsertTrigger
{
    static testMethod void myTest()
    {
        Account acc = new Account(Name = 'Test Account', Confidential_Account__c = true);
        insert acc;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
    }
}