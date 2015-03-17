/**
* Class Name: CampaignObjectAfterInsert 
* Author: HP
* Date:  
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Campaign object
*/

trigger CampaignObjectAfterInsert on Campaign (after insert) {

  Global_Config__c globalConfig = Global_Config__c.getInstance(); 
  if (globalConfig != null) {        
      // Do nothing if mute triggers set to true         
      if (globalConfig.Mute_Triggers__c == True) {
          return; 
      }
  }
  /* 
  // Commented as part of R6
    CampaignObjectTriggerController.afterInsert(Trigger.new);
    */
}