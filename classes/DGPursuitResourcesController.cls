/*
Created by: Venkatesh S
Created on: 15/04/2013
Comments  : Controller for Component DGPursuitResourcesComponent to show Pursuit Resources as a table in Deal Goverance Email Notification
*/
public class DGPursuitResourcesController {
public string AppId{get;set;}
public List<Opportunity_Pursuit_Resource_Requirement__c> getPursuitResource() 
    {
    List<Opportunity_Pursuit_Resource_Requirement__c> listPursuitResources = [ Select Pursuit_Team_Name_Role__c, Region_subregion_Country__c, Estimated_Start_Date__c, Estimated_End_Date__c, Requested_Hours__c from Opportunity_Pursuit_Resource_Requirement__c where Approval__c=:this.AppId];
    return listPursuitResources;
    }
    
public List<approval__c> getOpportunityInfo() 
    {
    List<approval__c> ListApprovalOpportunityInfo = [ Select id, Opportunity_Id__c, Opportunity_Name__c, Account_Name__c, Account_Shipping_City__c, Total_Opportunity_Value__c, Opportunity__r.Description, Approval_Description__c, Requestor_Comments__c, Pursuit_Budget_USD__c, Pricing_Approach__c from approval__c where id=:this.AppId];
    return listApprovalOpportunityInfo;
    }
}