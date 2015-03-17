/**
* Trigger Name: SpecialtyAfterUpdate 
* Author: karan.shekhar Accenture
* Date: 3-JULY-2012 
* Requirement # 1686
* Description: Contact's BU should be updated with Contact's Owners BU .
*/
trigger SpecialtyAfterUpdate on Product_Specialty__c (after update) {
	
	//Called to handle the update logic for updating the Product Speciality at User level. Specially when name of Product Speciality is changed.
	ProdSpcltyUserAsgnmtTriggerController.executeUpdateProdSpcltyOnUser(trigger.new,trigger.old);
}