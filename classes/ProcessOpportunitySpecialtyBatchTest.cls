/**
 * This class contains unit tests for validating the behavior of Apex class ProcessOpportunitySpecialtyBatch
 * @author: rahul.kunal (Accenture)
 */
@isTest (SeeAllData = true)
private class ProcessOpportunitySpecialtyBatchTest {

    /* 
     * @Desiption: Specialty Batch Process Test for Specialty Realignment.
     *
     */
     
     static testMethod void specialtyBatchTest(){
        
        test.startTest();
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        //create a test opportunity
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        opty.Type = 'New Business';
        opty.Route_To_Market__c = 'Direct';
        insert opty;
        TMEngineScheduledFlag__c SpecialityFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
        SpecialityFlag.SchedularFlag__c = false;
        update SpecialityFlag;
        TMEngineScheduledFlag__c SpecialityFlag1 = TMEngineScheduledFlag__c.getInstance('SchedularFlagVal');
        SpecialityFlag1.SchedularFlag__c = false;
        update SpecialityFlag1;
        TMEngineScheduledFlag__c SpecialityFlag2 = TMEngineScheduledFlag__c.getInstance('TMEngineWeekend_flag');
        SpecialityFlag2.SchedularFlag__c = false;
        update SpecialityFlag2;

        Batch_Job_Invoker__c triggerObj = new Batch_Job_Invoker__c(Name='TestSpecialtyBatch',Region__c = 'APJ',STATUS__C='Submitted',Type__c = 'Specialty Realignment', Consider_New_or_Changed_Territories_Only__c = true,Account_Record_Type__c ='');
        insert triggerObj;
                
        test.stopTest();
        
     }
}