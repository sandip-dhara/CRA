/**
 * Trigger Name: OpportunityLineItemBeforeUpdate 
 * Author: Accenture
 * Date: 12-APR-2012 
 * Requirement # Request Id:
 * Description: To perform actions Before Update on Opportunity Products
 */
trigger OpportunityLineItemBeforeUpdate on OpportunityLineItem (before update) {
    
    if(Trigger.isBefore &&Trigger.isUpdate ){
       MaxBookShipDate.updateBookshipDate(Trigger.New,Trigger.Old);
   }
    
    
    /* CR-0275: For calculating monthly revenue R3.0 Owner: Accenture */
    if(HPUtils.OpportunityLineItemBeforeUpdate == false){
        HPUtils.OpportunityLineItemBeforeUpdate=true;
       /* OppLineItemTriggerController.calculateMonthlyRevenue(trigger.new, false);*/
       /* As per Laura request below line added owner Bala */
       calculateMonthlyRevenueController.calculateMonthlyRevenue(trigger.new);
       OppLineItemTriggerController.LineItemAnnualizationlogic(trigger.new);
        Global_Config__c globalConfig = Global_Config__c.getInstance();     
        if(globalConfig!=null){        
            // Do nothing if mute triggers set to true         
            if( globalConfig.Mute_Triggers__c == True ) {
                return; 
            }
        }
        OpportunityLineItemTriggerController.beforeUpdate();
    }
    
    
}