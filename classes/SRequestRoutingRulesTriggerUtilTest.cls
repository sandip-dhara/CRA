/**********************************************************
* Class Name: SRequestRoutingRulesTriggerUtilTest
* Author: Accenture
* Date: 24-JUL-2012 
* Description: This class does the test coverage for SupportRequestRoutingRulesTriggerUtil class.
***********************************************************/
@isTest(SeeAllData=true)
private class SRequestRoutingRulesTriggerUtilTest{
    //Method for Positive test
    private static testMethod void SupportRequestRoutingRulePositiveTest() {
        Test.startTest();
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Support_Request__c' LIMIT 1];
        SupportRequest_Routing_Rules__c rule = new SupportRequest_Routing_Rules__c();
        rule.Form_Name_RecordType_Name__c =rt.name;
        insert rule;
        Test.stopTest();
    }
    //Method for Positive test
    private static testMethod void SupportRequestRoutingRulePositiveTest2() {
        Test.startTest();
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Support_Request__c' LIMIT 1];
        SupportRequest_Routing_Rules__c rule = new SupportRequest_Routing_Rules__c();
        rule.Form_Name_RecordType_Name__c =rt.name;
        insert rule;
        rule.AssignToQueue__c ='New Q';
        update rule;
        Test.stopTest();
    }

}