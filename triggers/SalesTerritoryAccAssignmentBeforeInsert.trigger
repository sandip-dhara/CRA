/*
* Name : SalesTerritoryAccAssignmentBeforeInsert
* Event : before insert
* Desc : Trigger to manually add Account to Sales territory.
*/

trigger SalesTerritoryAccAssignmentBeforeInsert on Sales_Territory_Account_Assignment__c (before insert, before delete) {

                   
        if(trigger.isInsert){
            TerritoryManagementPostAssignment.manualAccountAssignment(Trigger.New);
        }
        
        if(trigger.isDelete){
            TerritoryManagementPostAssignment.manualAccountAssignmentDelete(trigger.old);
        }        
}