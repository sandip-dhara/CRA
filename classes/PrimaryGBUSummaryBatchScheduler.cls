/**********************************************************
* Class Name: PrimaryGBUSummaryBatchScheduler
* Author: Accenture 
* Description: This is a scheduled class which calls for 
         PrimaryGBUSummaryBatch class 
*         to process opportunities entries.
***********************************************************/
global class PrimaryGBUSummaryBatchScheduler implements Schedulable {
   
   public static Boolean isTestrunscheduler=false;
  /**
    * @description: Executes 'PrimaryGBUSummaryBatch' Batch
    * @param: SchedulableContext
    **/
  global void execute(SchedulableContext sc){
      
      Integer batchSize; 
      if(isTestrunscheduler){
          batchSize= Integer.valueOf(PrimaryGBUBatchConfig__c.getValues('PrimaryGBUtest').Batch_Size__c); 
      }else{
          batchSize= Integer.valueOf(PrimaryGBUBatchConfig__c.getValues('PrimaryGBU').Batch_Size__c); 
      }
        
        PrimaryGBUSummaryBatch gbusummarybatch=new PrimaryGBUSummaryBatch();
        
        PrimaryGBUSummaryBatch.isTestrun=isTestrunscheduler;
        
        Id batchId = Database.executeBatch(gbusummarybatch, batchSize);
        
    }
}