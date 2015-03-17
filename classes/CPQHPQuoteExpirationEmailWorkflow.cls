/**
* Class Name: CPQHPQuoteExpirationEmailWorkflow 
* Author: HP - Mohit
* Date: 14-May-2013
* Description: This will update the HP Quotes so that Quotes will remove from timebase Queue 
*/
public class CPQHPQuoteExpirationEmailWorkflow {
    public static void CPQHPQuoteUpdateExpirationWorkflow(Set<Id> setOpportunityId){
        List<HP_Quote__c> listHPQuote = new List<HP_Quote__c>();
        for(HP_Quote__c objHPQuote : [select id from HP_Quote__c where Opportunity_Name__c IN:setOpportunityId and Synced_To_Opportunity__c = true and Hide_Record__c=false and Quote_End_Date__c >= Today]){
            listHPQuote.add(objHPQuote);
        }
        if(!listHPQuote.isEmpty()){
            Database.SaveResult[] listUpdateHpQuote = Database.update(listHPQuote,false);
        }
    }
}