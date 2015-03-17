/**********************************************************
* Class Name: TMAddToAccountTeamScheduler
* Author: Accenture 
* Description: This is a scheduled class which calls for 
               TMAddToAccountTeamBatch class 
*              to process Users & create Account Team member entries.
***********************************************************/
global class TMAddToAccountTeamScheduler implements Schedulable {
    
  
    /**
    * @description: Executes 'Add To Account Team' Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc){
        
       Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
       
       Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
       system.abortJob(sc.getTriggerId());
    }
}