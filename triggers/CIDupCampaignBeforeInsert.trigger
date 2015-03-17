/*
* Trigger Name: CIDupCampaignBeforeInsert  
* Author: HP
* Date: 08-OCT-2012
* Req#:
* Description: Actions to be performed after Insert on Campaign_Influence__c object
*/
trigger CIDupCampaignBeforeInsert  on Campaign_Influence__c (before insert) {
/*Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
           if( globalConfig.Mute_Triggers__c == True ) {
            return; 
            }
    }*/
    
    System.debug('***********CampaignInfluenceCreateTriggerUtil.CIVar***'+CampaignInfluenceCreateTriggerUtil.CIVar );
    if(CampaignInfluenceCreateTriggerUtil.CIVar == TRUE){
    return;
    }
            CampaignInfluenceTriggerUtil CITriggerUtil = new CampaignInfluenceTriggerUtil();
            CITriggerUtil.checkDuplicateCampaignBeforeInsert(Trigger.New);
}