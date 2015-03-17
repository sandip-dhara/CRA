trigger ABPScoreupdateTrigger on ABP_Scorecard__c (before insert, before update) {
ABP_Scorecard__c abpscore = Trigger.New[0];
Account_Plan__c abp = [Select Account_Summary_Score__c,Customer_Biz_Priority_Score__c,Total_Customer_Experience_Score__c,Partner_Landscape_Score__c,Business_Unit_Plans_Score__c,Competitive_Landscapes_Score__c,HP_Strategic_Initiatives_Score_1__c,Customer_Relationship_Maps_Score__c from Account_Plan__c where id =: abpscore.Account_Plan__c];
abp.Account_Summary_Score__c = abpscore.Account_Summary_avg__c;


abp.Customer_Biz_Priority_Score__c = abpscore.Customer_Business_Priorities_Avg__c;
abp.HP_Strategic_Initiatives_Score_1__c = abpscore.HPSI_Avg__c;
abp.Total_Score_Update__c =abpscore.Totals__c;
abp.Business_Unit_Plans_Score__c = abpscore.Q6__c;
abp.Competitive_Landscapes_Score__c = abpscore.Q7__c;
abp.Partner_Landscape_Score__c =abpscore.Q9__c;
abp.Total_Customer_Experience_Score__c =abpscore.Q10__c;
abp.Customer_Relationship_Maps_Score__c=abpscore.Q8__c;




 

update abp;
   
}