/**
  * Trigger Name: ProductSpecialtyUserAssignmentAfterInsert
  * Release : HP R2
  * Author: rahul.kunal (Accenture)
  * Date:  
  * Requirement # Request Id: 
  * Description: Calls after insert on Product_Specialty_User_Assignment__c object.
  */
trigger ProductSpecialtyUserAssignmentAfterInsert on Product_Specialty_User_Assignment__c (after insert) {
	
	ProdSpcltyUserAsgnmtTriggerController.controlInsertUpdateUserMappingLogic(Trigger.newMap);
	
	ProdSpcltyUserAsgnmtTriggerController.controlInsertProdSpecltyUser(Trigger.newMap);

}