@isTest
private class TestCCDeleteExpiredClosedLeads {

    static testmethod void test() {
        // The query used by the batch job. 
        datetime dateTimeNow = DateTime.now();
        datetime newDate = dateTimeNow.addDays(-180);
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
               Status='Closed',
               Email = 'test@hp.com',
               RecordTypeid = LeadRecordTypeId ,Closed_Reason__c ='Lead Expired',LeadSource ='List Import'
               );
           leads.add(lead);
       }
       insert leads;
       System.debug('@@@'+leads.size());
       System.debug('@@@'+leads);

       Test.startTest();
      CCDeleteExpiredClosedLeads c = new CCDeleteExpiredClosedLeads ();
       c.query = 'SELECT Id,CreatedDate,Closed_Reason__c,Status,LeadSource from Lead where RecordTypeid=\'' + LeadRecordTypeId + '\' AND CreatedDate <= '+ dateTimeFormat+'AND Closed_Reason__c =\'Lead Expired\' AND Status = \'Closed\' AND LeadSource = \'List Import\''; system.debug('@@@@'+c.query);
         scheduledBatchable ccdelete = new scheduledBatchable ();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('CCDeleteExpiredClosedLeads  :'+datetime.now(), schExp, ccdelete);
         ID batchprocessid = Database.executeBatch(c);
       Test.stopTest();       

       // Verify Leads got deleted  
    
       //System.AssertEquals(database.countquery('SELECT COUNT() FROM Lead '),5);
    }
}