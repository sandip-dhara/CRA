/**********************************************************
* Class Name: InitiateBatchProcessTest
* Author: Accenture
* Description: This class does the test coverage for InitiateBatchProcess Trigger. 
***********************************************************/

@isTest (SeeAllData = true)
private class InitiateBatchProcessTest {

     /*
      * @description: test Batch Job.
      */
    static testMethod void testBatchTM() {
       
       test.startTest();
        /* Account inset*/ 
        List<Account> accList = new List<Account>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        for(Integer i=0;i<20;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = false);
            accList.add(acc) ;
        }
        insert accList;
        System.assertEquals(accList[0].Name,'testAccount0');
        
        //Insert Batch Invoker Record for Teritory Management
        Batch_Job_Invoker__c triggerObj = new Batch_Job_Invoker__c(Name='TestTM',STATUS__C='Submitted',Type__c = 'Territory Management', REgion__C = 'EMEA', Consider_New_or_Changed_Territories_Only__c = true, SubRegion1__c = 'France');
        
        insert triggerObj; 
         
        
        TMEngineScheduledFlag__c specialtyFlag = new TMEngineScheduledFlag__c(Name='specialtyFlag', SchedularFlag__c=true);  
        insert specialtyFlag;

        test.stopTest();
    }
    //TM: Nasir Jawed 8/13/2013 Test method for Specialty realignment batch.Start
    static testMethod void testBatchTMSpecialtyRealignment() {
        test.startTest();
        Batch_Job_Invoker__c triggerObj = new Batch_Job_Invoker__c(Name='TestTM1',STATUS__C='Submitted',Type__c = 'Specialty Realignment', REgion__C = 'Asia Pacific', Consider_New_or_Changed_Territories_Only__c = true, SubRegion1__c = 'Japan',Account_Record_Type__c='');
        insert triggerObj; 
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('SpecialtyReallignmentBatchSize').Batch_Size__c);
 //TM: Manasa 9/10/2013 Test method for Specialty realignment batch.Adding subregion2:Start
        Batch_Job_Invoker__c triggerObj_subregion2 = new Batch_Job_Invoker__c(Name='TestTM1',STATUS__C='Submitted',Type__c = 'Specialty Realignment', REgion__C = 'Asia Pacific', Consider_New_or_Changed_Territories_Only__c = true, SubRegion1__c = 'Japan',SubRegion2__c = 'Japan',Account_Record_Type__c='');
        insert triggerObj_subregion2; 
        Integer batchSize_sunregion2 = Integer.valueOf(Batch_Size__c.getValues('SpecialtyReallignmentBatchSize').Batch_Size__c);        
//TM: Manasa 9/10/2013 Test method for Specialty realignment batch.Adding subregion2:End        
       // Id batchId = Database.executeBatch(new TMOpportunityShareSOMBatch(), batchSize);         
        test.stopTest();
    }
    //TM: Nasir Jawed 8/13/2013 Test method for Specialty realignment batch.End
}