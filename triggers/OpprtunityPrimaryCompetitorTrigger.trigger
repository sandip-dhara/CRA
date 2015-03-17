trigger OpprtunityPrimaryCompetitorTrigger on Competitors__c (after insert, after update, after delete) {
 
  OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
 
  if(Trigger.isInsert && Trigger.isAfter) {
    handler.OnAfterInsert(Trigger.new);
 
  }if(Trigger.isUpdate && Trigger.isAfter) { 
    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
 
  }if(Trigger.isDelete && Trigger.isAfter) { 
    handler.OnAfterDelete(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
  }
 
}