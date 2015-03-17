/*
* Name : BUPlanStatusChange
* Event : before insert, before update
* Release :R5
* Desc : Trigger to Populate the Plan Status in Business Unit Plan and Owner in BU Plan Approval.
*/
trigger BUPlanStatusChange on BU_Plan_Approval__c (before insert, before update)
 {

  BU_Plan_Approval__c apr = Trigger.New[0];
  Business_Unit_Plan__c bup = [Select id, Plan_Status__c  from Business_Unit_Plan__c where id =: apr.Business_Unit_Plan__c];
  bup.Plan_Status__c = apr.Plan_Status__c;
 // User owneruser = [Select id,Name from User where id =:bup.ownerId ];
//  apr.Owner__c = owneruser.Name ;
  update bup;
}