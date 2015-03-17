/**
  * Trigger Name: OpportunityLineItemAfterDelete 
  * Author: Accenture
  * Date: 12-APR-2012 
  * Requirement # Request Id:
  * Description: To perform actions After Delete on Opportunity Products
  */
trigger OpportunityLineItemAfterDelete on OpportunityLineItem (after delete) {
 /*
      *Class Name: contractValueSumup
      *Author: HP
      *Description: To Rollup Subtotal value of all the lineitems to Total contract Value in associated contract Reference.
      */
   
Set<id> contractIds = new Set<id>();
    //if (Trigger.isDelete) {
    for (OpportunityLineItem lineitem : Trigger.old)
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
    //}
    
   
   //Added in R5 By Chintapalli Sudhakara reddy for updating Multi-GBU flag when lineitems has different GBU's
       //OMOpportunityMultyBUFlagUpdate.hasBGGlobalUpdate(Trigger.old);
   
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            //Log Opportunity Ids to Log Object so that they will picked from Batch to execute Specialty Functionality.
            if (contractIds.size() >0)
            {           
                OppLineItemTriggerController.contractValueSumup(contractIds);
            }
            OppLineItemTriggerController.logOpptyIdfromOLIDel(trigger.oldMap);
            return; 
        }
    }
    OpportunityLineItemTriggerController.afterDelete();
    
    /*
     * Start: R2 Release changes: Rahul Kunal
     * Date: 
     * @Description: Call logic for Product Specialty Oppty Assignment Delete on delete of Line Item.
     */
   
    system.debug('Flow Point 1 TriggerCalled');
    //This is to handle single entry on OLI Delete from UI.  
    OppLineItemTriggerController.controlDeleteOppLineItemLogic(Trigger.oldMap);
     
    /*
     * End: Changes for R2: Rahul Kunal
     */
     
    OpportunityLineItemGBUCalculation.primaryGBUCalculation(Trigger.oldMap);
    
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
/*******Commented by Deepak Saxena - Update trigger context is not applicable for delete trigger***********/
                /*if (Trigger.isUpdate){     
                   for(OpportunityLineItem oli: Trigger.New){
                    if(oli.Contract__c != null){
                          opps.put(oli.opportunityid,new opportunity(id=oli.opportunityid));              
                          opps.get(oli.opportunityid).SAP_Feed__c = False;
                          updateoppty.add(opps.get(oli.opportunityid));
                    }             
                   }
                }*/
                
                //if (Trigger.isDelete){     
                   for(OpportunityLineItem oli: Trigger.old){
                      if(oli.Contract__c != null){
                          opps.put(oli.opportunityid,new opportunity(id=oli.opportunityid));        
                          opps.get(oli.opportunityid).SAP_Feed__c = False;
                          updateoppty.add(opps.get(oli.opportunityid));
                      }           
                   }
                //}
                              
              
                if(updateoppty.size()>0){
                    opptyList.addall(updateoppty);    
                    update opptyList;
                }
            
            } catch(Exception ex) {
                    System.debug(' Exception Occured' + ex);
            }
    //Added in R5 By Chintapalli Sudhakara reddy for updating Multi-GBU flag when lineitems has different GBU's
   OMOpportunityMultyBUFlagUpdate.hasBGGlobalUpdate(Trigger.old);
   /*
       Commented by DeviSudhakaran on 05/08/2013 
       The below trigger is added to capture deleted records  and stored into Opportunity_Product_Delete_Capture__c
   */
   /*
   Map<Id,Id> oppLineItemIdMap = new Map<Id,Id>();
   List<Opportunity_Product_Delete_Capture__c> histObjList = new List<Opportunity_Product_Delete_Capture__c>();
    
    for(OpportunityLineItem oli: Trigger.old)
    {
        oppLineItemIdMap.put(oli.Id,oli.OpportunityId);
    }

    if(oppLineItemIdMap.size()>0)
    {
        for(Id otmId : oppLineItemIdMap.keySet())
        {
            Opportunity_Product_Delete_Capture__c histObj = new Opportunity_Product_Delete_Capture__c();
            histObj.Deleted_Record_Id__c = otmId;
            histObj.Deleted_Record_Opportunity_Id__c = oppLineItemIdMap.get(otmId);
            histObj.Deleted_Record_Object_Type__c = 'OpportunityLineItem';
            histObjList.add(histObj);
        }
    }
    
    if(histObjList.size()>0)
    {
        insert histObjList;
    }
    */
 }