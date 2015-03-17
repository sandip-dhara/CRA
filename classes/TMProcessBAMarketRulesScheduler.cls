/**********************************************************
* Class Name: TMProcessBAMarketRulesScheduler
* Author: HP:Debmalya
* Date: 04-Jan-2013  
* Requirement # Request Id:3999 
* Description: This is a scheduled class which calls for 
               TMProcessBAMarketRulesBatch class 
*              to process Accounts against Territory Definitions.
***********************************************************/
global class TMProcessBAMarketRulesScheduler implements Schedulable{


	/**
    * @description: Executes Market Rule Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc) {
        
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Market batch size').Batch_Size__c);
                
        Id batchId = Database.executeBatch(new TMProcessBAMarketRulesBatch(), batchSize);
        system.abortJob(sc.getTriggerId());
    }
}