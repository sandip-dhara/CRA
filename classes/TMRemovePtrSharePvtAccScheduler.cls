/**********************************************************
* Class Name: TMRemovePtrSharePvtAccScheduler
* Author: HP
* Date: 08-OCT-2013  
* Requirement # Request Id:7525
* Description: This is a scheduler class which calls for 
               TMRemovePtrSharePvtAccBatch class 
*              to process Accounts which are made Private.
***********************************************************/
global class TMRemovePtrSharePvtAccScheduler implements Schedulable{
    
     /**
    * @description: Executes TMRemovePtrSharePvtAccBatch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc){
        Integer batchSize = Integer.valueOf(Batch_size__c.getValues('Partner Oppty Share batches size').Batch_size__c);
        Id batchId = Database.executeBatch(new TMRemovePtrSharePvtAccBatch(),batchSize);
        System.abortJob(sc.getTriggerId());
    }
}