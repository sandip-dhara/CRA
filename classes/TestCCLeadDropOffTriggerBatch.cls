@isTest
private class TestCCLeadDropOffTriggerBatch{

    static testmethod void test() {
        // The query used by the batch job. 
        datetime dateTimeNow = DateTime.now();
        datetime newDate = dateTimeNow.addDays(-7);
        String dateTimeFormat = newDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String LeadRecordTypeId = String.valueof(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Unqualified Lead').getRecordTypeId());  
       
       // Create some test leads to be deleted 
    
       //   by the batch job. 
    
       Lead[] leads = new List<Lead>();
       for (Integer i=0;i<200;i++) {
           Lead lead = new Lead(
               LastName ='Test ' + i,
               Phone = '56727282',
               Company='HP',
               Email = 'test@hp.com',
               RecordTypeid = LeadRecordTypeId ,Status='Open',Last_Successful_Call__c = NULL,LeadSource ='List Import'
               );
           leads.add(lead);
       }
       insert leads;
       System.debug('@@@'+leads.size());
       System.debug('@@@'+leads);

       Test.startTest();
       CCLeadDropOffTriggerBatch c = new CCLeadDropOffTriggerBatch();
       c.query ='SELECT Id,CreatedDate,Closed_Reason__c,Status,LeadSource,LastModifiedDate from Lead where RecordTypeid=\'' + LeadRecordTypeId + '\' AND CreatedDate < '+ dateTimeFormat+'AND Status <> \'Closed\' AND Last_Successful_Call__c = NULL AND LeadSource = \'List Import\'';
       system.debug('@@@@'+c.query);
       scheduledCCLeadDropOffTriggerBatch  ccdropoff = new scheduledCCLeadDropOffTriggerBatch ();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('CCLeadDropOffTriggerBatch Test :'+datetime.now(), schExp, ccdropoff );
       ID batchprocessid = Database.executeBatch(c);
       Test.stopTest();       

       // Verify Leads got deleted  
    
       //System.AssertEquals(database.countquery('SELECT COUNT() FROM Lead '),5);
    }
}