/**********************************************************
* Class Name: TMProcessCleanUpScheduler
* Author: HP
* Description: This is a scheduled class which calls for 
*              TMProcessCleanUpBatch class to delete 
*              Users & Account Team member entries.
***********************************************************/
global class TMProcessCleanUpScheduler implements Schedulable {
       
     /**
    * @description: Executes 'Process CleanUp' Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc){
    
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProcessCleanUp').Batch_Size__c);
         
        Id batchId = Database.executeBatch(new TMProcessCleanUpBatch(), batchSize);
        system.abortJob(sc.getTriggerId());
    }
}