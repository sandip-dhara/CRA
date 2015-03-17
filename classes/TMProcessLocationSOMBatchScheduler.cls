/**********************************************************
* Class Name: TMProcessLocationSOMBatchScheduler
* Author: Raghvendra Jha
* Date: 04-Jan-2013  
*  Requirement # Req Id:10320 
* Description: This is a scheduled class which calls for 
               TMProcessLocationSOMBatch class 
*              to process Location against SOM.
***********************************************************/
global class TMProcessLocationSOMBatchScheduler implements Schedulable{

global string stDatetime;
    
    public TMProcessLocationSOMBatchScheduler(String datetime2){
        stDatetime= datetime2;  
    }
    /**
    * @description: Executes Location SOM Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc) {
        
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProductLineItemSOMBatchCall').Batch_Size__c); 
                
        Id batchId = Database.executeBatch(new TMProcessLocationSOMBatch(stDatetime), batchSize);
        system.abortJob(sc.getTriggerId());
    }
}