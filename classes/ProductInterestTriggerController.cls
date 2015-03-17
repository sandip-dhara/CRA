/**
* Trigger Name: ProductInterestAfterInsert
* Author: Accenture
* Date: 13-AUG-2012
* Change Request#: CR-0125  
* Description: After inserting product interests need to update 1st two product names on lead
*/
public with sharing class ProductInterestTriggerController {
	/**
    * @description: Action After Inserting Product Interest  
    */
    public static void afterInsert(List<Product_Interest__c> newLeadProducts) {
        LeadTriggerUtil.updateProductInfoOnLead(newLeadProducts);
    }
}