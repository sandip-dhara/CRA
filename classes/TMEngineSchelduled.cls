global class TMEngineSchelduled implements Schedulable {

 
    /**
    * @description: Executes Account Profile Rule Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc)
    {
        try {
            
            TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues(Label.SchedularFlagVal);
            boolean flag = obj.SchedularFlag__c;
            system.debug('++++++'+flag);
        // TM: sreenath: Req-2089 oct 10, 2012:Handling Recordtype Partner for Account - Start
            TMEngineAccountRecordType__c obj2 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
            String currentRecordType1 = obj2.AccountRecordType__c;
            update obj2;
            system.debug(sc);
            TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues('LastCronJobTrigId');
            obj1.AccountRecordType__c = sc.getTriggerId();
            update obj1;
            system.debug('****Check Point1*****');
        //TM: Sreenath: Req-2089 oct 10, 2012:Handling Recordtype Partner for Account - End
        
        //TM: sreenath: Req-3095 dec 10, 2012:Handling Account type - Start
           /* TMEngineAccountRecordType__c accType = TMEngineAccountRecordType__c.getValues('Realignment_Account_Record_Type');
            String currentAccType1 = accType.AccountRecordType__c;
            update accType;*/
        //TM: sreenath: Req-3095 dec 10, 2012:Handling Account type - end
            if(!flag){
            
        //sreenath 2089 Delta changes for weekend variables starts
                  String ShortDayOfweek = DateTime.now().format('EEE');
                  datetime CurrentDateTime = datetime.now();
                  String Hour = String.valueOf(math.mod((currentDateTime.HourGMT()),60));
                  TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');      
                  TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
                  TMEngineAccountRecordType__c AccRecType = TMEngineAccountRecordType__c.getValues('Realignment_Account_Record_Type');

        // Sreenath data ends for 2089
                
                obj.SchedularFlag__c = true;
                update obj;
                 //sreenath 2089 start
                  Integer myInt = integer.valueOf(Hour);
                if(ShortDayOfweek == 'sat' && myInt >= 1 ){
                  Wobj1.SchedularFlag__c = true;
                  update Wobj1;
                  system.debug('++++++'+Wobj1);
                 }  
                //sreenath 2089 end
                //executing TMProcessAccountProfRulesBatch
                Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Profile batch size').Batch_Size__c);
                
                Id batchId = Database.executeBatch(new TMProcessAccountProfRulesBatch(), batchSize);
                
            }
        }catch(Exception e){
            system.debug('****Exception in TMEngineSchelduled ****' + e.getMessage());
        }
    }

}