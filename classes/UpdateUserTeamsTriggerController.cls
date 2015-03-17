/**
* Author: Shaijan Thomas
* Date: 13-JULY-2012 
* Requirement # Request Id: 1704(US-0573)
* Description: Controler class for UpdateUserTeamsTriggerUtil Class
*/
public class UpdateUserTeamsTriggerController
{
    public static void afterInsert(List<Team_Member__c > tm)
    {
        UpdateUserTeamsTriggerUtil.UpdateUserTeamField(tm);
    }
    public static void afterUpdate(List<Team_Member__c > Newone, List<Team_Member__c > Old)
    {
        UpdateUserTeamsTriggerUtil.UpdateUserTeamFieldonupdate(Newone,Old);
    }
    public static void afterDelete(List<Team_Member__c > Old)
    {
        UpdateUserTeamsTriggerUtil.UpdateUserTeamFieldondelete(Old);
    }
    public static void BeforeDelete(List<Team__c> Old)
    {
        UpdateUserTeamsTriggerUtil.UpdateUserTeamdelete(Old);
    }
    public static void AfterTeamUpdate(List<Team__c > NewOne,List<Team__c > Old)
    {
        UpdateUserTeamsTriggerUtil.UpdateUserTeamUpdate(NewOne, Old);
    }
}