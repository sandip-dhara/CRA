trigger ProductSpecialtyDefinitionBeforeInsert on Product_Specialty_Definition__c (before insert) {
    
    //Call Specialty Definition Uniqueness Logic
    ProdSpcltyUserAsgnmtTriggerController.controlSpecialtyDefinitionUniqueness(trigger.new);
}