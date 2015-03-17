global class TMProcessIndustryRulesScheduled implements Schedulable {

    global Set<Id> accIdForAllBatch;
    
    /**
    * @description: Executes Industry Rule Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc){
        
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Industry batch size').Batch_Size__c);
        
        Id batchId = Database.executeBatch(new TMProcessIndustryRulesBatch(), batchSize);
        system.abortJob(sc.getTriggerId());
     // TM: Sreenath: Req-2089 Oct, 15 2012:Aborting Scheduled Job for Partner - Start
    TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');  
    // TM : Sreenath: Req-3095 Jan, 12 2012: Aborting Manual realignment Scheduled Job for both customer & partner starts
    
            TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
            String currentRecordType1 = obj1.AccountRecordType__c;
            TMEngineAccountRecordType__c obj2 = TMEngineAccountRecordType__c.getValues('LastCronJobTrigId');            
            Id jobTriggerId = obj2.AccountRecordType__c;
            TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
            
            if(Robj2.AccountRecordType__c != 'None'){
            system.abortJob(jobTriggerId);
            }

    // TM : Sreenath: Req-3095 Jan, 12 2012: Aborting Manual realignment Scheduled Job for both customer & partner ends
    
    // TM : Sreenath: Req-3095 Jan, 12 2012: Weekdays hourly job needs to abort before weekend job scheduling
       if(Wobj1.SchedularFlag__c == true && Robj2.AccountRecordType__c == 'None'){                      
            if(currentRecordType1 == 'Customer')
            system.abortJob(jobTriggerId);
        } 
      // TM: Sreenath: Req-2089 Oct, 15 2012:Aborting Scheduled Job for Partner - Start
    }
}