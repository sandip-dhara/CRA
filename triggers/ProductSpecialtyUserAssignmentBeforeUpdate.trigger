/**
  * Trigger Name: ProductSpecialtyUserAssignmentBeforeUpdate
  * Release : HP R2
  * Author: rahul.kunal (Accenture)
  * Date:  
  * Requirement # Request Id: 
  * Description: Calls Before update on Specialty User Assignment object.
  */
trigger ProductSpecialtyUserAssignmentBeforeUpdate on Product_Specialty_User_Assignment__c (before update) {
    
    //Call the executeDuplicateUserCheck method for validating the record.    
    //TM:Sreenath:ALM5362:Modified Unique check funtionality in case of Update
    //ProdSpcltyUserAsgnmtTriggerController.executeUniqueUserCheck(trigger.new);
    ProdSpcltyUserAsgnmtTriggerController.executeUniqueUserCheckupdate(trigger.newMap,trigger.oldMap);
    ProdSpcltyUserAsgnmtTriggerController.controlProdSpcltyUserAsgnmntUpdate(Trigger.oldMap, Trigger.newMap);

}