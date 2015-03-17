public with sharing class CSPAddCompetitor {

public String oppPlanId;
public String oppId;
public String compId {get;set;}


    public CSPAddCompetitor(ApexPages.StandardController controller){
        this.oppPlanId = ApexPages.currentPage().getParameters().get('oppPlanId');
        this.oppId = ApexPages.currentPage().getParameters().get('oppId');
    }
    
    public List<Competitors__c> getCompetitors(){
        List<Competitors__c> comp = new List<Competitors__c>([SELECT Id, Name, Competitor_Account__c,Competitor_Name__c,Opportunity__c FROM Competitors__c where Opportunity__c = :oppId ]);
        return comp;
    }
    
    public PageReference addCompetitor(){
    try{
        Competitive_Sales_Plan__c csp = new Competitive_Sales_Plan__c();
        csp.Opportunity_Plan__c = oppPlanId;
        csp.Competitors__c = compId;
        if (null!=compId){
            insert csp;
        }
        PageReference pr = new PageReference('/apex/CSP_List?id='+oppPlanId);
        pr.setRedirect(true);
        return pr;
       }catch(Exception e){
       ApexPages.addMessages(e);
           return null;
       }
    }
    
    public PageReference goBack(){
        PageReference pr = new PageReference('/apex/CSP_List?id='+oppPlanId);
        pr.setRedirect(true);
        return pr;
    }
    
}