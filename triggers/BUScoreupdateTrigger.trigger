/**********************************************************
* Class Name: BUScoreupdateTrigger 
* Author: HP
* Date:15/06/2012 
* Requirement # Request Id:6495
* Description: Trigger to update the scores to the associated BU Plan
              
***********************************************************/

trigger BUScoreupdateTrigger on BU_plan_Scorecard__c (before insert, before update) {
BU_plan_Scorecard__c abpscore = Trigger.New[0];
Business_Unit_Plan__c abp = [Select Score__c ,Q1__c,Q2__c,Q3__c,Q4__c,Q5__c from Business_Unit_Plan__c where id =: abpscore.Business_Unit_Plan__c];
abp.Score__c = abpscore.Avg__c;
abp.Q1__c = abpscore.Q1__c;
abp.Q2__c = abpscore.Q2__c;
abp.Q3__c = abpscore.Q3__c;
abp.Q4__c = abpscore.Q4__c;
abp.Q5__c = abpscore.Q5__c;

update abp;
   
}