@isTest
public class TestCCTaskAfterInsertUpdate
{
  static testMethod void TestCCTaskAfterInsertUpdate()
  {
    
      Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Task; 
      Map<String,Schema.RecordTypeInfo> TaskRecordTypeInfo
                   = cfrSchema.getRecordTypeInfosByName(); 
      //Now to get the recordTypeId we will have to use a method getRecordTypeId. 

      Id rtId= Schema.SObjectType.Task.getRecordTypeInfosByName().get('Contact Center Task Record Type').getRecordTypeId();
      //Now we can insert Task Record like 
       
      System.debug('rtid==='+rtId);
      
      lead l = new lead(LastName='Test123',Company = 'Hp',Email='hp@hp.com',Phone='9738335102',Status = 'Open',LeadSource = 'List Import');
      insert l;
      
      task t = new task(Subject='Call',Type='Outbound Call',Status='Not Started',
                 Priority='Normal',recordTypeId = rtId,Outcome__c = 'Call Back Later',whoid=l.id);
      insert t;
      
      lead l1 = new lead(LastName='Test123',Company = 'Hp',Email='hp@hp.com',Phone='9738335102',Status = 'Open',LeadSource = 'List Import');
      insert l1;
      
      task t1 = new task(Subject='Call',Type='Outbound Call',Status='Not Started',
                 Priority='Normal',recordTypeId = rtId,Outcome__c = 'Requested Forther Engagement',whoid=l1.id);
      insert t1;
      
      lead l2 = new lead(LastName='Test123',Company = 'Hp',Email='hp@hp.com',Phone='9738335102',Status = 'Open',LeadSource = 'List Import');
      insert l2;
      
      task t2 = new task(Subject='Call',Type='Outbound Call',Status='Not Started',
                 Priority='Normal',recordTypeId = rtId,Outcome__c = 'No Answer',whoid=l2.id);
      insert t2;
       
     }
  }