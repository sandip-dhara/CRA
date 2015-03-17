/*
* Trigger Name: CIOpptybeforeUpdate 
* Author: HP
* Date: 08-OCT-2012
* Req#:
* Description: Actions to be performed before Update on Campaign_Influence__c object
*/

trigger CIOpptybeforeUpdate on Campaign_Influence__c (before update) {
Set<Id> CINewSetId = new Set<Id>();
Set<Id> CIOldSetId = new Set<Id>();
   Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
           if( globalConfig.Mute_Triggers__c == True ) {
            return; 
            }
    }
    
   /* 
      if(CampaignInfluenceTriggerUtil.CIbeforeUpdateChk == TRUE){
            return;
    }
    
    */
           CampaignInfluenceTriggerUtil CITU = new CampaignInfluenceTriggerUtil();
            CITU.checkPrimaryFlagBeforeUpdate(Trigger.New, Trigger.OldMap);
            
            for(Campaign_Influence__c camp: Trigger.New){
                CINewSetId.add(camp.Id);
                CIOldSetId.add(Trigger.OldMap.get(camp.Id).Id);
            }
           // CampaignInfluenceTriggerUtil.checkPrimaryFlagBeforeUpdate1(CINewSetId, CIOldSetId);
}