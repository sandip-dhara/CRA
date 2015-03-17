/**
  * Trigger Name: RenewalForecastCategoryCommit 
  * Release : HP R2
  * Author: Accenture
  * Date:  
  * Requirement # Request Id: CR-0177 
  * Description: Calls before update on opportunity object & check if Opportunity is Renewal opportunity
  *              then for Sales 1 &2 Forecast category value should be "Pipeline" and for rest sales stage value should be "Commit".
  */
trigger RenewalForecastCategoryCommit on Opportunity (before insert){
    Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
    for (Opportunity opp : Trigger.new){
        if(opp.RecordTypeId  == RecordTypeId){ 
             opp.ForecastCategoryName = 'Commit';
             opp.StageName = '03 - Qualify the Opportunity';
             opp.Type = 'Renewal';           
        }
        system.debug('******BG*******'+opp.Business_Group2__c);
        /*if(opp.Type == 'Renewal' && opp.StageName != '03 - Qualify the Opportunity' && opp.Business_Group2__c != 'ES'){
       
             opp.ForecastCategoryName = 'Commit';
             opp.StageName = '03 - Qualify the Opportunity';
        }*/
    }
}