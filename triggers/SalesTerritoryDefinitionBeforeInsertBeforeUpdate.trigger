trigger SalesTerritoryDefinitionBeforeInsertBeforeUpdate on Sales_Territory_Definition__c (before insert, before update) {
        
    if (Trigger.isInsert && Trigger.isBefore) {
        SalesTerritoryDefinitionController.beforeInsert(Trigger.new);
    }
    
    if (Trigger.isUpdate && Trigger.isBefore) {
        SalesTerritoryDefinitionController.beforeUpdate(trigger.new, trigger.old);
    }
}