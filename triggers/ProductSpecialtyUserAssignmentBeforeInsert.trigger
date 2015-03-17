/**
  * Trigger Name: ProductSpecialtyUserAssignmentBeforeInsert
  * Release : HP R2
  * Author: rahul.kunal (Accenture)
  * Date:  
  * Requirement # Request Id: 
  * Description: Calls before insert on Product_Specialty_User_Assignment__c object.
  */
trigger ProductSpecialtyUserAssignmentBeforeInsert on Product_Specialty_User_Assignment__c (before insert) {
	
	//Call the executeDuplicateUserCheck method for validating the record.
	ProdSpcltyUserAsgnmtTriggerController.executeUniqueUserCheck(trigger.new);
}