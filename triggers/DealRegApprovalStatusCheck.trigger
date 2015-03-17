/**********************************************************
* Trigger Name: DealRegApprovalStatusCheck 
* Author: HP
* Date: 09-OCT-2012 
* Description:This trigger will fire when 
**the Deal Registration status changed to Approved/Review Initiated/Rejected and Product Registration status is null
**Rejection reason is null when the Deal Registration status changed to Rejected
***********************************************************/

trigger DealRegApprovalStatusCheck on Deal_Registration__c (before update) {

   Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
// Validation to approve/reject Product Rejistrations before apprving deal reg and 
// making Reject Reason mandatory while rejecting the Deal Reg

    for (Deal_Registration__c deal :trigger.new){
        //To throw an error when the Product Registration status is nulll
        if((deal.Status__c=='Approved' || deal.Status__c=='Review Initiated'||deal.Status__c=='Rejected') && (deal.Product_Registrations_Count__c != 0)){
            deal.addError(System.Label.Product_Registration_Status_Required);
        }
        //To throw an error when the reason for rejection is blank 
        else if(deal.Status__c=='Rejected' && deal.Rejection_Reason__c == NULL){
             deal.addError(System.Label.Reject_Reason_Required);
        }
        //To Restrict the Approval for an Unverified Customer Account
        else if(deal.Verified_Account__c != 'True' && (deal.Status__c=='Review Initiated'||deal.Status__c=='Approved')){
            deal.addError(System.Label.Restrict_Unverified_Deal_Approval);
        }
        
        //Restrict to approve the deal reg if all the product registrations are rejected
        else if((deal.Status__c=='Approved' || deal.Status__c=='Review Initiated') && (deal.Product_Registration_Approved_count__c==0)){
            deal.addError(System.Label.Cannot_approve_the_deal_reg_since_all_product_registrations_are_rejected);
         }
     }
}