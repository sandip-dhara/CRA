//TM Nasir Jawed: R5 CR-0712: 12/04/2013: Specialty Opportunity match Start

global class TMProcessProdLineItemSOMSchedular implements Schedulable {

    global void execute(SchedulableContext sc){ 
      
        TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues(Label.TMProcessProdLineItemSOMBatch);
        boolean flag = obj.SchedularFlag__c;
        if(flag== false){
            obj.SchedularFlag__c = true;
            update obj;
            
            Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProductLineItemSOMBatchCall').Batch_Size__c);        
            Id batchId = Database.executeBatch(new TMProcessProdLineItemSOMBatchCall(), batchSize);
        }
        
        
    }

}
// TM Nasir Jawed: R4 CR-0712: End