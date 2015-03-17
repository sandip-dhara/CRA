/**********************************************************
* Class Name: TMAddPtrShareNonPvtAccScheduler
* Author: HP
* Date: 08-OCT-2013  
* Requirement # Request Id:7525
* Description: This is a scheduler class which calls for 
               TMAddPtrShareNonPvtAccBatch class 
*              to process Accounts which are made Non-Private.
***********************************************************/

global class TMAddPtrShareNonPvtAccScheduler implements Schedulable{

     /**
    * @description: Executes TMAddPtrShareNonPvtAccBatch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc){
        Integer batchSize = Integer.valueOf(Batch_size__c.getValues('Partner Oppty Share batches size').Batch_size__c);
        Id batchId = Database.executeBatch(new TMAddPtrShareNonPvtAccBatch(),batchSize);
        System.abortJob(sc.getTriggerId());
    }
}