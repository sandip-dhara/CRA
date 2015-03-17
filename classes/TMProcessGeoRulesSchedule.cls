/**********************************************************
* Class Name: TMProcessGeoRulesSchedule
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: This is a scheduled class which calls for 
               TMProcessGeoRulesBatch class 
*              to process Accounts against Territory Definitions.
***********************************************************/
global class TMProcessGeoRulesSchedule implements Schedulable {

   
    /**
    * @description: Executes Coverage Rule Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc){
        
       Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Geo batch size').Batch_Size__c);
       
       Id batchId = Database.executeBatch(new TMProcessGeoRulesBatch(), batchSize);
       system.abortJob(sc.getTriggerId());
    }
}