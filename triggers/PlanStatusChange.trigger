trigger PlanStatusChange on ABP_Approval__c (before insert, before update) {

ABP_Approval__c apr = Trigger.New[0];
Account_Plan__c abp = [Select id, Plan_Status__c, OwnerId from Account_Plan__c where id =: apr.Account_Plan__c];
abp.Plan_Status__c = apr.Plan_Status__c;

User owneruser = [Select id,Name from User where id =:abp.ownerId ];
apr.ABP_Owner__c = owneruser.Name ;

 

update abp;
   

}