/**
* Trigger Name: OpportunityLineItemAfterUpdate 
* Author: HP
* Date: 08-AUG-2012 
* Description: To Rollup Subtotal value of all the lineitems to Total contract Value in associated contract Reference.
*/
trigger OpportunityLineItemAfterUpdate on OpportunityLineItem (after Update) {
    if(HPUtils.OpportunityLineItemAfterUpdate== false){
        HPUtils.OpportunityLineItemAfterUpdate= True;
        Set<id> contractIds = new Set<id>();  
        for (OpportunityLineItem lineitem : Trigger.new)
            {
            if (lineitem.Contract__c != null)
                {
                    contractIds.add(lineitem.Contract__c);
                }
            }
        /*if (contractIds.size() >0)
             {           
             OppLineItemTriggerController.contractValueSumup(contractIds);
             }*/
        /***********OMPM Renewals 3.0 Owner: Deepak Saxena****************/ 
            
            /* List<OpportunityLineItem> OLIList = [Select id, Product_Line__c, HasProductline__c, Sub_Product_Line__c, HasSubProductline__c  From OpportunityLineItem Where Id IN : trigger.new];
            for(OpportunityLineItem objOLI : OLIList){
                if((objOLI.Product_Line__c != null)  && (objOLI.Product_Line__c != '')){
                    objOLI.HasProductline__c=1;
                }
                else
                    objOLI.HasProductline__c=0;
        
        
                if((objOLI.Sub_Product_Line__c != null) && (objOLI.Sub_Product_Line__c != '')){
                    objOLI.HasSubProductline__c=1;
                }
                else
                    objOLI.HasSubProductline__c=0;
            }
            update OLIList; */
            
           //Added in R5 BY Chintapalli Sudhakara reddy for updating Multi-GBU when lineitems has different GBU's
            List<OpportunityLineItem> opplitemsList=new List<OpportunityLineItem>();
            for(OpportunityLineItem oppl : Trigger.New){
                if(trigger.oldmap.get(oppl.id).GBU__c != oppl.GBU__c){
                  opplitemsList.add(oppl);  
                
                }
            }
            if(opplitemsList.size()>0)
            OMOpportunityMultyBUFlagUpdate.hasBGGlobalUpdate(Trigger.New);
           
                      
            /***********OMPM Renewals 3.0 Owner: Deepak Saxena****************/
            Global_Config__c globalConfig = Global_Config__c.getInstance(); 
            if(globalConfig!=null)
            {        
                // Do nothing if mute triggers set to true         
                if( globalConfig.Mute_Triggers__c == True ) 
                    {
                    if (contractIds.size() >0)
                    {           
                        OppLineItemTriggerController.contractValueSumup(contractIds);
                    }
                    return; 
                    }
            }
            
/*******************Code of RenewalUpdateAutoSync **************************************************/
/**
* Trigger Name: RenewalUpdateAutoSync 
* Author: Accenture
* Date: 08-AUG-2012 
* Description: To update the Auto Sync flag to "False", for update/delete operation on line item.
*/
            Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            List<Opportunity> opptyList = new List<Opportunity>();
            Set<Opportunity> updateoppty = new set<Opportunity>();
            Map<Id,Opportunity> opps = new Map<id,opportunity>();
            
            try{
                //if (Trigger.isUpdate){     
                   for(OpportunityLineItem oli: Trigger.New){
                    if(oli.Contract__c != null){
                          opps.put(oli.opportunityid,new opportunity(id=oli.opportunityid));              
                          opps.get(oli.opportunityid).SAP_Feed__c = False;
                          updateoppty.add(opps.get(oli.opportunityid));
                    }             
                   }
                //}
/*******Commented by Deepak Saxena - Delete trigger context is not applicable for update trigger***********/
                /*if (Trigger.isDelete){     
                   for(OpportunityLineItem oli: Trigger.old){
                      if(oli.Contract__c != null){
                          opps.put(oli.opportunityid,new opportunity(id=oli.opportunityid));        
                          opps.get(oli.opportunityid).SAP_Feed__c = False;
                          updateoppty.add(opps.get(oli.opportunityid));
                      }           
                   }
                }*/
                              
              
                if(updateoppty.size()>0){
                    opptyList.addall(updateoppty);    
                    update opptyList;
                }
            
            } catch(Exception ex) {
                    System.debug(' Exception Occured' + ex);
            }
           
    }
    //Code Start 
    //Added in R3 for User Story : US-0997
    //OpportunityLineItemGBUCalculation.primaryGBUCalculation(Trigger.newMap);
    //Code End 
    
    //Added in R5 BY Chintapalli Sudhakara reddy for updating Multi-GBU when lineitems has different GBU's
    List<OpportunityLineItem> opplitemsList=new List<OpportunityLineItem>();
    for(OpportunityLineItem oppl : Trigger.New){
        if(trigger.oldmap.get(oppl.id).GBU__c != oppl.GBU__c){
          opplitemsList.add(oppl);  
        
        }
    }
   /* if(opplitemsList.size()>0)
    OMOpportunityMultyBUFlagUpdate.hasBGGlobalUpdate(Trigger.New);*/
}