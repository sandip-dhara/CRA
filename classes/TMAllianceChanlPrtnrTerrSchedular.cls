//TM Nasir Jawed: R4 req:3906: 26/11/2012: Allaince and channed partner batch schedular Start

global class TMAllianceChanlPrtnrTerrSchedular implements Schedulable {

    global void execute(SchedulableContext sc){    
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Alliance and Channel Partner').Batch_Size__c);
        
        Id batchId = Database.executeBatch(new TMAllianceChannedPartnerTerritoryBatch(), batchSize);
        
    }

}
// TM Nasir Jawed: R4 req:3906: End