/**********************************************************
* Class Name: ProductSpecUserBatchScheduler
* Author: HP:Debmalya:ALM5362
* Description: This is a scheduled class which calls for 
*              ProductSpecialityUserBatch.
***********************************************************/
global class ProductSpecUserBatchScheduler implements Schedulable {
       
     /**
    * @description: Executes 'Addition/Deletion of User in Sales Territories to AccountTeams' Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc){
    
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProductSpecialityUser').Batch_Size__c);
         
        Id batchId = Database.executeBatch(new ProductSpecialityUserBatch(), batchSize);
        system.abortJob(sc.getTriggerId());
    }
}