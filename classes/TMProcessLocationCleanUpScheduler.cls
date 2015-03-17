/**********************************************************
* Class Name: TMProcessLocationCleanUpScheduler
* Author: HP
* Description: This is a scheduled class which calls for 
*              TMProcessLocationCleanUpBatch class to delete 
*              Sales territory location assignment entries.
***********************************************************/

global class TMProcessLocationCleanUpScheduler implements Schedulable{

    /**
    * @description: Executes 'Process Location CleanUp' Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc){
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProcessCleanUp').Batch_Size__c);
        Id batchId = database.executeBatch(new TMProcessLocationCleanUpBatch(),batchSize);
            system.abortJob(sc.getTriggerId());
     }
    
}