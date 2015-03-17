/**
* Trigger Name: OpportunityLineItemBeforeInsert 
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id:
* Description: To perform actions Before Insert on Opportunity Products
*/
trigger OpportunityLineItemBeforeInsert on OpportunityLineItem (before insert) {
   /* OppLineItemTriggerController.calculateMonthlyRevenue(trigger.new, false); */
   /* As per Laura request below line added owner Bala */
   calculateMonthlyRevenueController.calculateMonthlyRevenue(trigger.new);
   OppLineItemTriggerController.LineItemAnnualizationlogic(trigger.new);
    /***********OMPM Renewals 3.0 Owner: Deepak Saxena****************/ 
    
    /* for(OpportunityLineItem objOLI : trigger.new){
        if((objOLI.Product_Line__c != null) && (objOLI.Product_Line__c != '')){
                objOLI.HasProductline__c=1;
        }
        else
            objOLI.HasProductline__c=0;
            
                
        if((objOLI.Sub_Product_Line__c != null) && (objOLI.Sub_Product_Line__c != '')){
                objOLI.HasSubProductline__c=1; 
        }
        else
            objOLI.HasSubProductline__c=0;
    } */
    /***********OMPM Renewals 3.0 Owner: Deepak Saxena****************/    
    Global_Config__c globalConfig = Global_Config__c.getInstance();     
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
        
         for(OpportunityLineItem objOLI : trigger.new){
        objOLI.Max_Book_Ship_date__c=objOLI.servicedate;
        
        }
    }
       

            OpportunityLineItemTriggerController.beforeInsert();
    
}