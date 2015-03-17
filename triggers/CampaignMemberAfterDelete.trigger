/**
* Class Name: CampaignMemberAfterDelete 
* Author: HP(Sreedhar Jagannath)
* Date: 15-July-2013
* Requirement # Request Id: 
* Description: Calls After Delete support action methods for trigger on Campaign Member object
*/
trigger CampaignMemberAfterDelete on CampaignMember(after delete) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    CampaignTriggerControllers.afterDelete();
}