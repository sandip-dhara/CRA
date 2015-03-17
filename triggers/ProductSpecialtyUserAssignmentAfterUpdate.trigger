/**
  * Trigger Name: ProductSpecialtyUserAssignmentAfterUpdate
  * Release : HP R2
  * Author: rahul.kunal (Accenture)
  * Date:  
  * Requirement # Request Id: 
  * Description: Calls After update on Specialty User Assignment object.
  */
trigger ProductSpecialtyUserAssignmentAfterUpdate on Product_Specialty_User_Assignment__c (after update) {
	
	ProdSpcltyUserAsgnmtTriggerController.controlInsertUpdateUserMappingLogic(Trigger.newMap);
	
}