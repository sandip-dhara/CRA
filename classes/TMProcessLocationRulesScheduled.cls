/*********************************************************************************
* Class Name: TMProcessLocationRulesScheduled
* Author: HP
* Date: 19-MAR-2013 
* Requirement # Request Id:R5:6201
* Description: Schedular class for location rules batch.
***********************************************************************************/
global class TMProcessLocationRulesScheduled implements Schedulable{
    
    global void execute(SchedulableContext sc){
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Location batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMProcessLocationRulesBatch(),batchSize);
            system.abortJob(sc.getTriggerId());
    }
}