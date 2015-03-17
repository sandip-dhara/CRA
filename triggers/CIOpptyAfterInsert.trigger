/*
* Trigger Name: CIOpptyAfterInsert  
* Author: HP
* Date: 08-OCT-2012
* Req#:
* Description: Actions to be performed after Insert on Campaign_Influence__c object
*/
trigger CIOpptyAfterInsert on Campaign_Influence__c (after insert) {
//List<Campaign_Influence__c> CIList  = new List<Campaign_Influence__c>();
          
    System.debug('***********CampaignInfluenceCreateTriggerUtil.CIVar***'+CampaignInfluenceCreateTriggerUtil.CIVar );
    if(CampaignInfluenceCreateTriggerUtil.CIVar == TRUE){
    return;
    }
            
            CampaignInfluenceTriggerUtil CITriggerUtil = new CampaignInfluenceTriggerUtil();
            CITriggerUtil.checkPrimaryFlagAfterInsert(Trigger.New);
            
            
    }