/**
  * @author: rahul.kunal (Accenture)
  * HP Release 2
  * This Class drives the logic for Scheduling batch operation for Specialty Functionality From end of TMProcessGeoRulesBatch.
  * Date:
  */
global class SpecialtyBatchScheduler implements Schedulable {
    
    global SpecialtyBatchScheduler (){
       
    }
    
 	global void execute(SchedulableContext sc) {
 		
 		Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Specialty batch size').Batch_Size__c);
 		
        Id batchId = Database.executeBatch(new ProcessScheduledSpecltyBatch(), batchSize);
        system.abortJob(sc.getTriggerId());
    } 
}