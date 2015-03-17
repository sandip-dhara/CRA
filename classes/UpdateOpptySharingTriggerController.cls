public class UpdateOpptySharingTriggerController
{
    public static void afterUpdate(Map<id,Opportunity>  Newone, Map<id,Opportunity> Old)
    {
        UpdateOpportunitySharingTriggerUtil.UpdateOpportunitySharing(Newone,Old);
    }
    }