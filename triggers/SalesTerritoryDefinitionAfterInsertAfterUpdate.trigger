/*
TM : SREENATH Req-2089 
@description : Trigger logic contains for insert,update & delete (only delete logic is added in R3.0)
*/
trigger SalesTerritoryDefinitionAfterInsertAfterUpdate on Sales_Territory_Definition__c (after insert, after Update, after Delete) {

    if(Trigger.isInsert && Trigger.isAfter) {
    system.debug('after insert testing territory definitions');
    SalesTerritoryDefinitionController.afterInsertafterDelete(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter) {
    SalesTerritoryDefinitionController.afterUpdate(Trigger.newmap, Trigger.oldmap);
    }
    
    if(Trigger.isDelete && Trigger.isAfter) {
    SalesTerritoryDefinitionController.afterInsertafterDelete(Trigger.old);
    }
    
}