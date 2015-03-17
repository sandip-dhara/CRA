/**
* Class Name: PartnerStrikeCountBatchExecutor
* Author: Accenture
* Date: 23-JULY-2012 
* Description: The scheduler class for executing the batch apex job to handle strike count for partners
*/
global with sharing class PartnerStrikeCountBatchExecutor implements Schedulable {
    /**
    * @description: Constructor method
    * 
    */
    public PartnerStrikeCountBatchExecutor(){}
    
    /**
    * @description: Execute method -Gets invoked by the force.com platform at scheduled time
    * @param: schedule context instance
    * 
    */
    global void execute(SchedulableContext shdCtx) {
        database.executeBatch(new PartnerStrikeCountBatch());
    }
}