/**
  * Trigger Name: OpportunityAfterUpdate
  * Release : HP R2
  * Author: rahul.kunal (Accenture)
  * Date:  
  * Requirement # Request Id: 
  * Description: Calls After update on opportunity object.
  */
trigger OpportunityAfterUpdate on Opportunity (after update) {
    
    if(HPUtils.OpportunityAfterUpdate == false){
    
    //Sameer R4:Req:4043:Start
    //This is used update the sharing to the territory when the owner of the Opportunity is changed from / to a portal user.
    /*OpportunityTriggerUtil.afterUpdateTerritoryUpdate(trigger.oldMap,trigger.newMap);*/
    system.debug('inside opty update trigger');
    OpportunityTriggerUtil.afterOptyUpdateTerritoryUpdateForLocation(trigger.newMap, trigger.oldMap);
    //Sameer R4:Req:4043:End
    
    //Vinay R6 EF-01:Req:7525:Start
    //This is used to remove/add sharing to the territory when the Opportunity is made Confidential/Non-Confidential
    system.debug('old conf >>>> '+ Trigger.old.get(0).Confidential__c);
    system.debug('new conf >>>> '+ Trigger.new.get(0).Confidential__c);
    OpportunityTriggerUtil.afterOpptyConfidentialUpdateTerritorySharing(Trigger.newMap, trigger.oldMap);
    //Vinay R6 EF-01:Req:7525:End

      HPUtils.OpportunityAfterUpdate=True;
     /* To collect all oppty Ids for calculating monthly revenue R3.0 Owner: Accenture */
    Set<Id> opportunityIds = new Set<Id>();
    for(Opportunity opp:trigger.new){
    /* CR-0275: For calculating monthly revenue R3.0 Owner: Accenture */
        if (opp.CloseDate != Trigger.oldMap.get(opp.Id).get('CloseDate')) {
            opportunityIds.add(opp.Id);
        }
    }
    List<OpportunityLineItem> opptyLineItems = new List<OpportunityLineItem>();
    opptyLineItems = [Select Opportunity_Close_Date__c, ServiceDate, Quote_Start_Date__c, Quote_End_Date__c,OpportunityId, Month_5_Revenue__c, Month_4_Revenue__c, 
                            Month_3_Revenue__c, RTS_Component__c, Subtotal, Month_2_Revenue__c, Month_1_Revenue__c, Id, 
                            Contract_Start_Date__c, Contract_End_Date__c 
                    From OpportunityLineItem
                    Where OpportunityId In:opportunityIds] ;
    if (opptyLineItems != null) {
       /* OppLineItemTriggerController.calculateMonthlyRevenue(opptyLineItems, true);*/
       /* As per Laura request below line added owner Bala */
       calculateMonthlyRevenueController.calculateMonthlyRevenue(opptyLineItems);
    }   
    /*End of code for CR-0275: revenue calculation */
    
    // Call the Update Controlling method to drive the logic for opportunity update specially for Product Specialty Oppty Assignment.
    Bulk_Upload_Profile__c bulkProfile = Bulk_Upload_Profile__c.getInstance('Bulk Uplaod Profile Exemption');
    system.debug('bulkProfile.Profile_Id__c '+bulkProfile);
    if (bulkProfile != null && bulkProfile.Profile_Id__c != UserInfo.getProfileId()){
        OppLineItemTriggerController.controlUpdateOppOrLineItemLogic(trigger.OldMap,trigger.NewMap);
        UpdateOpptySharingTriggerController.afterUpdate(trigger.OldMap,trigger.NewMap);
    }
   
    }
    
    
    /*******
    * dESC : Opportunity BG Speicifc Workflow
    * Author : Abrar
    *********/
     if(HPUtils.BGSpecificWorkflows == false){
     HPUtils.BGSpecificWorkflows = true;
    list<Opportunity> opList= new List<Opportunity>();
    List<Opportunity> renewalOppList= new List<Opportunity>();
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    //quang.vu@hp.com 10/30/2012
    //if this opp update is triggered by HPFS engagement, skip trigger
    if(OpportunityTriggerUtil.triggeredByHPFS()){
        return;
    }
    /****** 
     * Desc:  Automatically adjust Ship/Book Dates when Close Date is updated. Ship/Book Dates should be set after Close Date.
     * Release: R4.0- 4302
     * Author: hp
     *********/
    updateOpportunityLineItemBookShipDate.updateBookshipDate(trigger.newMap,Trigger.oldMap);
    /* End R4.0- 4302 logic */
    Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('HPFS').getRecordTypeId();
    if (trigger.new[0].recordtypeid == RecordTypeId){
             return;
         }
    if(Trigger.isUpdate){
        //R5.0 CPQ Team CR-7643
        set<Id> setOpportunityId = new set<Id>();
        //End R5.0 CPQ Team CR-7643
        for(opportunity objoppty:trigger.new){
            //R5.0 CPQ Team CR-7643
            for(string salesStage : SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',Label.CPQHPQuoteExpirationEmailWorkflow)){
                if(objoppty.StageName != trigger.oldmap.get(objoppty.Id).StageName && objoppty.StageName == salesStage){
                    setOpportunityId.add(objoppty.Id);
                }
            }
            //End R5.0 CPQ Team CR-7643
            if(objoppty.Record_Type_Name__c=='Renewal')
                renewalOppList.add(objoppty);
            else{
                if(objoppty.Business_Group2__c=='ES')
                {
                    system.debug('Current '+objoppty.Amount+'Old Value'+trigger.oldmap.get(objoppty.id).amount);
    
                    if(objoppty.Amount != trigger.oldmap.get(objoppty.id).amount || objoppty.StageName!=trigger.oldmap.get(objoppty.id).StageName)
                    {
                        opList.add(objoppty);
                        system.debug('Inside condidtion of Amount##');
                    }
                }
                else if(objoppty.Business_Group2__c=='TS')
                    {
                        opList.add(objoppty);
                    }
                }
            }
        //R5.0 CPQ Team CR-7643
        if(!setOpportunityId.isEmpty()){
            CPQHPQuoteExpirationEmailWorkflow.CPQHPQuoteUpdateExpirationWorkflow(setOpportunityId);
        }
        //End R5.0 CPQ Team CR-7643
        system.debug('Size of oplist'+opList.size());
        if(opList.size()>0)
        {
            OpportunityBGActivityPlan.CreateActivityForOptyUpdation(opList,0);
            system.debug('Inside the Oplist IF condition '+opList[0]);
        }
        
        
        if(renewalOppList.size()>0){
            OpportunityBGActivityPlan.CreateActivityForOptyUpdation(renewalOppList,1);
        }
       }
    }
    
    /** To capture deleted opportunitylineitemschedule records */
    /*
    system.debug('--- executing to capture deleted records---');
    Set<Id> oppIdSet = new Set<Id>();
    for(Opportunity opp : Trigger.new){
        oppIdSet.add(opp.Id);
    }
    system.debug('--- oppIdSet ---'+oppIdSet);
    if(oppIdSet.size()>0){
        List<OpportunityLineItemschedule> deletedOLISList = new list<OpportunityLineItemschedule>();
        List<OpportunityLineItemschedule> olisListAll = [select Id, OpportunityLineItem.OpportunityId, IsDeleted from OpportunityLineItemSchedule 
                                          where OpportunityLineItem.OpportunityId in :oppIdSet ALL ROWS];
        
        if(olisListAll != null && olisListAll.size()>0){
            for(OpportunityLineItemschedule olisA : olisListAll){
                if(olisA.IsDeleted){
                    deletedOLISList.add(olisA);
                }
            }
            if(deletedOLISList.size()>0){
                List<Opportunity_Product_Delete_Capture__c> histObjList = new List<Opportunity_Product_Delete_Capture__c>();
                for(OpportunityLineItemschedule olis : deletedOLISList){
                    Opportunity_Product_Delete_Capture__c histObj = new Opportunity_Product_Delete_Capture__c();
                    histObj.Deleted_Record_Id__c = olis.id;
                    histObj.Deleted_Record_Parent_Id__c = olis.OpportunityLineItem.OpportunityId;
                    histObj.Deleted_Record_Object_Type__c = 'OpportunityLineItemSchedule';
                    histObjList.add(histObj);
                }
                Database.insert(histObjList);
            }
        }
    }*/
}