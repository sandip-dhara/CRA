/**********************************************************
* Class Name: RemoveContractAssociation
* Author: HP
* Date: 06-August-2012 
* Requirement # 
* Description: Controller class to create Opportunity Plan.
***********************************************************/

global class CreateOpportunityPlan {

WebService Static Id CreateOpptyPlan(Id OppId) 
    {
    Id OppPlanId;
    integer plancount;
    Opportunity_Plan__c OppPlanList;
    
    plancount = [select count() from Opportunity_Plan__c where Opportunity__c = :OppId];
   
    If(plancount < 1)
        {
        Opportunity_plan__c NewOppPlan = new Opportunity_plan__c(Opportunity__c = OppId);
        try
            {
            insert NewOppPlan;
            OppPlanId = NewOppPlan.Id;
            return OppPlanId;
            }
        catch (DmlException e) 
            {
            system.debug('There was an error during insert');
            return null;
            }
        }
     else
        {
        OppPlanList = [select Id from Opportunity_Plan__c where Opportunity__c = :OppId LIMIT 1];
        OppPlanId = OppPlanList.Id;
        return OppPlanId;
        }
    }
}