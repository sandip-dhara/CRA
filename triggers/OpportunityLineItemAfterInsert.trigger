/**
  * Trigger Name: OpportunityLineItemAfterInsert
  * Release : HP R2
  * Author: rahul.kunal (Accenture)
  * Date:  
  * Requirement # Request Id: 
  * Description: Calls After update on opportunityLineItem object.
  */
trigger OpportunityLineItemAfterInsert on OpportunityLineItem (after insert) {
/*
     Author: HP
     Description: To Rollup Subtotal value of all the lineitems to Total contract Value in associated contract Reference.
     */
    if(HPUtils.OpportunityLineItemAfterInsert == false){
    HPUtils.OpportunityLineItemAfterInsert=true;
    Set<Id> contractIds = new Set<Id>();
    for (OpportunityLineItem lineitem : Trigger.new){
        If(lineitem.Contract__c != null)
        {
            contractIds.add(lineitem.Contract__c);
        }
        
    }
    /*if (contractIds.size() >0)
    { 
        OppLineItemTriggerController.contractValueSumup(contractIds);
    }*/
    System.debug('*Insert Trigger*Contract Id is null');
    
    System.debug('*********Checking Trigger********');
     //added by Quang Vu quang.vu@hp.com to temporarily disable trigger for HPFS opportunities
     // Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('HPFS').getRecordTypeId();
     
     try{
        /*if (trigger.new[0].opportunity.recordtypeid == RecordTypeId){
             return;*/
         OppLineItemTriggerController.controlInsertOppLineItemLogic(Trigger.newMap);
       }
     catch(Exception excp){
        system.debug('Exception occured for Adding new trigger for After Insert Opportunity Line Item: '+excp.getMessage());
     }
    
    
    //Added in R5 BY Chintapalli Sudhakara reddy for updating Multi-GBU when lineitems has different GBU's
     OMOpportunityMultyBUFlagUpdate.hasBGGlobalUpdate(Trigger.New);
     
    //Commenting this mute trigger part as this trigger so far do not need this.In future if needed then uncomment the same peice of code.
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            if (contractIds.size() >0)
            {           
                OppLineItemTriggerController.contractValueSumup(contractIds);
            }
            return; 
        }
    }
    
    }
    //Code Start 
    //Added in R3 for User Story : US-0997
    //OpportunityLineItemGBUCalculation.primaryGBUCalculation(Trigger.newMap);    
    //Code End 
    
    
}