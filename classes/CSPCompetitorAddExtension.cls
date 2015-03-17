public class CSPCompetitorAddExtension {
public Competitive_Sales_Plan__c CSP;
public String retURL {get;set;}

    string OppPlanId;
    public CSPCompetitorAddExtension(ApexPages.StandardController controller) {
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        this.CSP = (Competitive_Sales_Plan__c)controller.getRecord();
        oppPlanId = ApexPages.currentPage().getParameters().get('OppPlanId');
    }
    
    public Competitive_Sales_Plan__c getCSP()
    {
    return CSP;
    }

    
    Public PageReference initialize()
    {
    this.CSP.Opportunity_plan__c = OppPlanId;
    return null;
    }
    
    Public PageReference Save()
    {
            ApexPages.StandardController controller = new ApexPages.StandardController(CSP);
            pageReference pr = cancel();
            controller.save();
            return pr;
            
    }
    
     public pageReference cancel(){
        pageReference pr = new pageReference(retURL);
        pr.setRedirect(true);
        return pr;
    }
    
}