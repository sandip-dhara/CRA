public class customRelatedDecision{
    private List<Decision__c> relatedDecisions;
    string oppPlanId;
    public customRelatedDecision(ApexPages.StandardController controller) {
        this.oppPlanId = ApexPages.currentPage().getParameters().get('id');
    }
    public List<Decision__c> getrelatedDecisions()
    {
        relatedDecisions = [SELECT Criteria__c,Decision__c,Id,Step__c,When__c,Who__c, contact_id__c, Status__c FROM Decision__c where Opportunity_Plan__c = :oppPlanId ORDER BY When__c asc];
        return relatedDecisions;
    }
}