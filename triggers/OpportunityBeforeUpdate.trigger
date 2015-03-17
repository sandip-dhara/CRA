/**
* Class Name: OpportunityBeforeUpdate
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Calls Before update support action methods for trigger on opportunity object
*/
trigger OpportunityBeforeUpdate on Opportunity (before update) {    
    //Getting opportunities with partner ownerids
    if(HPUtils.OpportunityPartnerFileds==False){
    HPUtils.OpportunityPartnerFileds=True;
    OpportunityTriggerController.partnerOpptyFiledsDefulat(Trigger.new); 
    }
    /*** R4.0 Populate Go to Market Route *****/   
    system.debug('******Trigger.newmap****'+Trigger.newmap);
    system.debug('******Trigger.newmap****'+Trigger.new);
    OpportunityTriggerController.addGoToMarketRoute(Trigger.new,Trigger.oldmap); 
     /*
     * Start: HP R2 realese Change : Rahul Kunal
     * Description: Updating isUpdatedFlag for bulk upload.
     */
     
       
    Bulk_Upload_Profile__c bulkProfile = Bulk_Upload_Profile__c.getInstance('Bulk Uplaod Profile Exemption');
    system.debug('>>>>Check bulk Profile: '+bulkProfile);
    if ((bulkProfile != null && bulkProfile.Profile_Id__c == UserInfo.getProfileId()) || Test.isRunningTest()){
        OppLineItemTriggerController.logOpptyId(trigger.newMap,trigger.oldMap);
    }
       
    /*
     * End: Rahul Kunal
     */
    
    OpportunityTriggerController.neverBypassMethod();
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    

    
     //quang.vu@hp.com, 10/30/2012
    //if triggered by HPFS engagement, skip trigger

    if(OpportunityTriggerUtil.triggeredByHPFS()){
        return;
    }
        
    /************* OMPM Renewal R3.0 Owner: Deepak Saxena*********Open****************/
    //List<Id> recordTypeIds= new List<Id>();
    //for(Opportunity opp:trigger.new)
    //    recordTypeIds.add(opp.RecordTypeId);
    
    //Map<Id,RecordType> recordtypeMap= new Map<Id,RecordType>([Select id, Name From RecordType Where id IN :recordTypeIds ]);
    Id RenewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
    Id HPFSRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('HPFS').getRecordTypeId();
    Id StandardRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
    Id PartnerDealRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Partner Deal').getRecordTypeId();
    
    //System.debug('???????'+RenewalRecordTypeId +'????????'+HPFSRecordTypeId+'????????????'+StandardRecordTypeId+'???????'+PartnerDealRecordTypeId);
    for(Opportunity opp:trigger.new){
        //RecordType recordtype= recordTypeMap.get(opp.RecordTypeId);
        if(opp.RecordTypeId != null){
          if(opp.RecordTypeId == HPFSRecordTypeId)
            opp.Record_Type_Name__C='HPFS';
          else if(opp.RecordTypeId == RenewalRecordTypeId)
            opp.Record_Type_Name__C='Renewal';
            else if(opp.RecordTypeId == StandardRecordTypeId)
              opp.Record_Type_Name__C='Standard';
              else if(opp.RecordTypeId == PartnerDealRecordTypeId)
                opp.Record_Type_Name__C='Partner Deal';
        }      
            
    }
    /************* OMPM Renewal R3.0 Owner: Deepak Saxena*********Close****************/
    
    
    /************* OMPM Renewal R3.0 Owner: Laura Castro*************************/
    
    Set<ID> optyid = new Set<Id>();
    for (Opportunity opp : Trigger.New){
    // Check if oppty is premier
    // if it is then add opty id for fetching support req because only on passed opty we have to validate
            if(opp.SW_Premier__C == true & opp.StageName == '06 - Won, Deploy & Expand' ){
                optyid.add(opp.id);
            }
    }
        if(optyid.size()> 0){
        List<Support_Request__c> requestRecord = [Select Support_Sub_Type__c, Request_Status__c, Customer_Contact_Name__c, Customer_Contact_Phone__c, Customer_Contact_Email__c From Support_Request__c Where ( Support_Sub_Type__c = 'Premier Resource' AND Opportunity__c = :Trigger.New) ]; 
        for(Opportunity opp: Trigger.New){
        if( requestRecord.size()>0){
            for (Support_Request__c suppReq : requestRecord ){
            // check here for the four fields & give error if not filled out/submitted
            if(suppReq.Request_Status__c == NULL){
                opp.addError('Premier Resource/Close Deal Support Request must be submitted before moving to Sales Stage 6');
            }    else if ( (suppReq.Customer_Contact_Name__c == NULL || suppReq.Customer_Contact_Phone__c == NULL || suppReq.Customer_Contact_Email__c == NULL) ){
                    opp.addError('Close Deal form fields on Premier Resource/Close Deal Support Request must be filled out before moving to Sales Stage 6');
                } 
        }
        
        }else{opp.addError('Premier Resource/Closed Deal Form Support Request must be created, filled out, and submitted before moving to Sales Stage 6');}
        }
    }
        
        
        
    
    

    /************* OMPM Renewal R3.0 Owner: Laura Castro*************************/
    
    
    
    //when ISR change owner ship to Partner use then giving access to ISR: Added for R3
        OpportunityTriggerController.beforeUpdate(trigger.OldMap,trigger.NewMap);
    
    
    /** 
    *    Desc : Opportunity Blacklisting Before Update
    *    Author : Abrar
    */

      if(HPUtils.OpportunityBlacklisting==false){
      HPUtils.OpportunityBlacklisting = True;
     List<Opportunity> oplist = new List<Opportunity>();
     if(Trigger.isUpdate){
    OpportunityBlacklisting obj=new OpportunityBlacklisting();
    for(Opportunity opty : trigger.new)
    {
    if(opty.Name != trigger.oldmap.get(opty.id).Name || opty.Description!=trigger.oldmap.get(opty.id).Description || opty.Opportunity_Update__c!=trigger.oldmap.get(opty.id).Opportunity_Update__c)
    oplist.add(opty);
    }
    obj.filterwords(oplist);
    }
    
 }   
}