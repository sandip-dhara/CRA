public class customRelatedCallPlans{
    private List<Call_Plan__c> relatedCallPlans;
    string oppPlanId;
    public String retURL {get;set;}
    public customRelatedCallPlans(ApexPages.StandardController controller) {
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        this.oppPlanId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public pageReference cancel(){
        pageReference pr = new pageReference(retURL);
        pr.setRedirect(true);
        return pr;
        }
    
    public List<Call_Plan__c> getrelatedCallPlans()
    {
         relatedCallPlans = [SELECT CreatedById,CreatedDate,Customer__c,Duration_of_Call__c,Meeting_Date__c,Name FROM Call_Plan__c WHERE Opportunity_Plan__c = :oppPlanId ORDER BY CreatedDate asc];
        return relatedCallPlans;
    }
}