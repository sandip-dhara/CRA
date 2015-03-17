//TM sreenath: R5 req:5909: 5/4/2013: ProdSpecialtyOpptyDelBatch schedular Start

global class ProdSpecialtyOpptyDelSchedular implements Schedulable {


    global void execute(SchedulableContext sc){
     /*TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues(Label.TMProcessProdLineItemSOMBatch);
        boolean flag = obj.SchedularFlag__c;
        if(flag== false){
            obj.SchedularFlag__c = true;
            update obj;}*/
            
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProdSpecialtyOpptyDelBatch Size').Batch_Size__c);
        Id batchId = Database.executeBatch(new ProdSpecialtyOpptyDelBatch(), batchSize);
        //system.abortJob(sc.getTriggerId());
        
        /*else{
        ProdSpecialtyOpptyDelSchedular tm= new ProdSpecialtyOpptyDelSchedular();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 15),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('ProdSpecialtyOpptyDelSchedular', schExp, tm);
        }*/
 
    }

}
// TM Sreenath: R5 req:5909: End