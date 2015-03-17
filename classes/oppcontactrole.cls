global with sharing class oppcontactrole{
string oppId;
string oppPlanName;
string oppPlanId;
public Decision__c decision;
private ApexPages.StandardController decisioncontroller;

global oppcontactrole(ApexPages.StandardController controller) {
        this.oppId= ApexPages.currentPage().getParameters().get('oppId');
        this.oppPlanName = ApexPages.currentPage().getParameters().get('oppPlanName');
        this.oppPlanId = ApexPages.currentPage().getParameters().get('oppPlanId');
        decision =new Decision__c();
        decisioncontroller= controller;
        
         this.decision= (Decision__c)decisioncontroller.getRecord();
    }

global string getOppId() {return oppId;}
global string getOppPlanName() {return oppPlanName;}
global string getOppPlanId() {return oppPlanId;}

@RemoteAction
global static List<Contact> getContacts (String oppidquery){
    
    try{
    List<Contact> contacts = new List<Contact>();
    contacts = [SELECT Id, FirstName, LastName, (select OpportunityContactRole.Role from Contact.OpportunityContactRoles where OpportunityId = :oppidquery), (Select Relationship_Suite__c.PP_Result__c from Relationship_Suite__r ) from Contact where Id in (Select ContactId from OpportunityContactRole where OpportunityId = :oppidquery)];
    return contacts;
    }
    catch(Exception err){
        return null;
    }
    
    
}

public PageReference saveAndGo() {
try{
  //controller.save(); // This takes care of the details for you.
  upsert decision;
  PageReference summary = new PageReference('/apex/decision_grid_summary?id='+oppPlanId);
  summary.setRedirect(true);
  return summary;
 }catch(Exception e){
     ApexPages.addMessages(e);
     return null;
 }
}

}