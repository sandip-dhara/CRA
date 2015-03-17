/*
* Trigger Name: CIOpptyAfterUpdate 
* Author: HP
* Date: 18-OCT-2012
* Req#:
* Description: Actions to be performed after Update on Campaign_Influence__c object
*/

trigger CIOpptyAfterUpdate on Campaign_Influence__c (after update) {
  /* Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
           if( globalConfig.Mute_Triggers__c == True ) {
            return; 
            }
    }*/
    //CampaignInfluenceCreateTriggerUtil CICTU = new CampaignInfluenceCreateTriggerUtil();
    System.debug('***********CampaignInfluenceCreateTriggerUtil.CIVar***'+CampaignInfluenceCreateTriggerUtil.CIVar );
    if(CampaignInfluenceCreateTriggerUtil.CIVar == TRUE){
    return;
    }
            CampaignInfluenceTriggerUtil CITU = new CampaignInfluenceTriggerUtil();
            CITU.checkPrimaryFlagAfterUpdate(Trigger.New, Trigger.OldMap);
            
                        
           }