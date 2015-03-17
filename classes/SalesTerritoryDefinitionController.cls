/**********************************************************
* Class Name: SalesTerritoryDefinitionController
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: This class has methods called from Trigger.
               They make call to other business logic methods.  
***********************************************************/ 
public class SalesTerritoryDefinitionController {

    /**
    * @description: This method is called from before update trigger
    *               It calls methods to populate filter & 
    *               to check for rule duplication.
    * @param: List of new Sales Territory Definitions
    **/ 
    public static void beforeInsert(List<Sales_Territory_Definition__c> newDefinition) {

        SalesTerritoryUtil.populateFilter(newDefinition);
        // Duplicate Record Check.
        SalesTerritoryUtil.duplicateCheckForDefInsert(newDefinition); 
    } 
    
    /**
    * @description: This method is called from before update trigger
    *               It calls methods to populate filter & 
    *               to check for rule duplication.
    * @param: List of new & old Sales Territory Definitions
    **/     
    public static void beforeUpdate(List<Sales_Territory_Definition__c> newDefinition, List<Sales_Territory_Definition__c> oldDefinition) {

        SalesTerritoryUtil.populateFilter(newDefinition);
        // Duplicate Record Check.
        SalesTerritoryUtil.duplicateCheckForDefUpdate(newDefinition, oldDefinition); 
    }
    /*sreenath 9/23/2012 territory updation in defination creation or updation*/
    
public static void afterInsertafterDelete(List<Sales_Territory_Definition__c> newDefinition) {

       /* SalesTerritoryUtil.populateFilter(newDefinition);
        // Duplicate Record Check.
        SalesTerritoryUtil.duplicateCheckForDefInsert(newDefinition); */
        SalesTerritoryUtil.evaluateTerritory(newDefinition);
        
    } 
    public static void afterUpdate(Map<id,Sales_Territory_Definition__c> newDefinition, Map<id,Sales_Territory_Definition__c> oldDefinition){
    SalesTerritoryUtil.evaluateTerritory(newDefinition,oldDefinition);
    }

}