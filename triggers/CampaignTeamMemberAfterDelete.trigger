/*
    **************************************************************************
    Name        :   CampaignTeamMemberAfterDelete 
    Usage       :   This trigger is used to store the data of delete campaign team data
    Date        :   09 May 2013
    Modefiy By  :   Devi 
    ***************************************************************************
 */
 
trigger CampaignTeamMemberAfterDelete on CampaignMember (after delete)
{

CampaignTriggerControllers.afterDelete(Trigger.old);

}