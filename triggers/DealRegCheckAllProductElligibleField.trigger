/**
* Trigger Name: CheckAllProductElligibleField 
* Author: HP
* Date: 04-Oct-2012 
* Requirement # Request Id: 3396
* Description: To check if there are Program product Association records, if exists should not allow to change the All product eligible to true
* Last Modified :Created for Campaign set up -4th Oct 2012
*/
trigger DealRegCheckAllProductElligibleField on Campaign (before update) {
    List<Campaign> campaignList = null;
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(null != globalConfig){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    campaignList = new List<Campaign>();
    for(Campaign camp : trigger.new){
        campaignList.add(camp);
    }
    DealReg_CampaignBeforeUpdateController campBeforeUpdate = new DealReg_CampaignBeforeUpdateController();
    campBeforeUpdate.CheckAllProductElligibleField(campaignList);
    if(campaignList.size() > 0)
        campaignList.clear();
}