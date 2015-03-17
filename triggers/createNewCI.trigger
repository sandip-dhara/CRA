trigger createNewCI on Opportunity (after insert,before update) {
 

    if(LeadConvertController.bypassOpptyTrigger == true) {
        System.debug('**********222' + LeadConvertController.bypassOpptyTrigger);        
        return;
        }
        
     
    if(CheckContactController.bypassOpptyTrigger == true) {
        System.debug('**********9999' + CheckContactController.bypassOpptyTrigger);        
        return;
        }
           
        System.debug('**********3333' + LeadConvertController.bypassOpptyTrigger); 
    Map<Id,Id> mapOpportunityWithCampaignId = new Map<Id,Id>();
    //Insert
    if(Trigger.isInsert){
        if(CampaignInfluenceTriggerUtil.CIvarChk == TRUE){
            return;
        }
        for(Opportunity objOppty : Trigger.New){
            if(objOppty.CampaignId != null ){
               
                mapOpportunityWithCampaignId.put(objOppty.Id,objOppty.CampaignId);
            }
        }
        if(!mapOpportunityWithCampaignId.isEmpty()){
        System.debug('*** 555' + LeadConvertController.bypassOpptyTrigger); 
            CampaignInfluenceCreateTriggerUtil.resetExistingPrimaryAndInsertOrUpdateCIPrimary(mapOpportunityWithCampaignId,'Insert');
            System.debug('*** 444' + LeadConvertController.bypassOpptyTrigger); 
        }
    }  
    //Opportunity Mass Update
    else{
        if(CampaignInfluenceTriggerUtil.CIvarChk == TRUE){
            return;
        }
        for(Opportunity objOppty : Trigger.New){
            if(objOppty.CampaignId != null && Trigger.NewMap.get(objOppty.Id).CampaignId != Trigger.OldMap.get(objOppty.Id).CampaignId){
                mapOpportunityWithCampaignId.put(objOppty.Id,objOppty.CampaignId);
            }
        }
        if(!mapOpportunityWithCampaignId.isEmpty()){
            System.debug('*** 666' + LeadConvertController.bypassOpptyTrigger); 
            CampaignInfluenceCreateTriggerUtil.resetExistingPrimaryAndInsertOrUpdateCIPrimary(mapOpportunityWithCampaignId,'Update');
            System.debug('*** 777' + LeadConvertController.bypassOpptyTrigger); 
        }
    }
}