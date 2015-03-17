trigger OpprtunityPrimaryPartnerTrigger on Channel_Partner__c (after insert, after update, after delete) {
 
  OpportunityTriggerHandlerPartner handler = new OpportunityTriggerHandlerPartner();
 
  if(Trigger.isInsert && Trigger.isAfter) {
    handler.OnAfterInsert(Trigger.new);
 
  }if(Trigger.isUpdate && Trigger.isAfter) { 
    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
 
  }if(Trigger.isDelete && Trigger.isAfter) { 
    handler.OnAfterDelete(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
  }
 
}