/**
  * Trigger Name: ProductSpecialtyUserAssignmentBeforeDelete
  * Release : HP R2
  * Author: rahul.kunal (Accenture)
  * Date:  
  * Requirement # Request Id: 
  * Description: Calls before Delete on Product_Specialty_User_Assignment__c object.
  */
  //TM:Sreenath Req:5909 getting error of Unable to LOCK ROW for BEFORE DELETE event. we changing this one to After delete to resolve this error.
  /*trigger ProductSpecialtyUserAssignmentBeforeDelete on Product_Specialty_User_Assignment__c (Before delete) {*/
trigger ProductSpecialtyUserAssignmentBeforeDelete on Product_Specialty_User_Assignment__c (After delete) {
    
    //Call Delete Logic for Product Specialty Oppty Assignment before Deleting the Product Specialty User Assignment Records.
    ProdSpcltyUserAsgnmtTriggerController.controlProdSpcltyUserAsgnmntDelete(Trigger.oldMap);  

}