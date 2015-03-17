//TM Nasir Jawed: 7/06/2013: CR-0979 Specialty Opportunity match Delete for Won/Lost Opportunities Start

global class TMWonLostSOMDeleteBatchSchedular implements Schedulable {

    global void execute(SchedulableContext sc){ 
      
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('TMWonLostSOMDeleteBatch').Batch_Size__c);        
        Id batchId = Database.executeBatch(new TMWonLostSOMDeleteBatch(), batchSize);     
    }

}
// TM Nasir Jawed: CR-0979:  End