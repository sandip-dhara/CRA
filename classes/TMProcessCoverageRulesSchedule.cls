/**********************************************************
* Class Name: TMProcessCoverageRulesSchedule
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: This is a scheduled class which calls for 
               TMProcessCoverageRulesBatch class 
*              to process Accounts against Territory Definitions.
***********************************************************/
global class TMProcessCoverageRulesSchedule implements Schedulable {

    
    /**
    * @description: Executes Coverage Rule Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc) {
        
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Coverage batch size').Batch_Size__c);
                
        Id batchId = Database.executeBatch(new TMProcessCoverageRulesBatch(), batchSize);
        system.abortJob(sc.getTriggerId());
    }
}