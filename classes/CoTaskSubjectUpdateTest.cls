/**
* Class Name: COTaskSubjectUpdateTest
* Author: hp
* Date: 5/17/2013 
* Requirement # Request Id: 
* Description: Code coverage for update or Insert Task "Subject" based on "Task Type"
*/
@isTest
Public class CoTaskSubjectUpdateTest{

               public static testMethod void testTask(){
                Id RecId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CO Task').getRecordTypeId();
                System.Debug('Record type id=====>'+RecId);
                Task t1=new Task(Task_Type__c='Support Call');
                t1.Subject = 'Support Call'; 
                t1.RecordTypeId = RecId;
                insert t1;
                
                Task t2=new Task(Task_Type__c='');
                t2.Subject= 'CO Task';
                t2.RecordTypeId = RecId;                
                insert t2;
                }
}