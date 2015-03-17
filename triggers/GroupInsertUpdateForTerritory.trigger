/*
* Name : GroupInsertUpdateForTerritory
* Event : after insert, before update
* Desc : Trigger to create & update Group On Sales Territory creation and update respectively.
*/

trigger GroupInsertUpdateForTerritory on Sales_Territory__c (after insert, after update) {

   
    // To create Group for Sales territory Created. (Group Name will be a combination of Territory Name + Auto Number)
    if(trigger.isInsert){
        
        SalesTerrGroupUtil.salesTerrAfterInsert(trigger.New);
    }
    
    // To update Group on change in Territory Name
    // To delete Group on Territory flagged Inactive.
    // To update definition filter on Confidential flag change.
    if(trigger.isUpdate){
        
        SalesTerrGroupUtil.salesTerrAfterUpdate(trigger.New, trigger.old);
    }
}