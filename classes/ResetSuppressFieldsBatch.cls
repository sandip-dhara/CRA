/**********************************************************
* Class Name: ResetSuppressFields
* Author: HP
* Date: 10-Oct-2012 
* Requirement # 
* Description: Batch to reset Suppression fields  
***********************************************************/
global class ResetSuppressFieldsBatch implements Database.Batchable<sObject>{
       
    global String query;
    
    global Database.QueryLocator start(Database.BatchableContext batchContext){
        query = 'Select Id,Suppression_End_Date__c,Suppression_Start_Date__c,Suppress_Marketing__c From Contact where Suppression_End_Date__c <Today AND Suppress_Marketing__c != null';
        Database.QueryLocator queryLocator = Database.getQueryLocator(query);
        return queryLocator;
    }

   /**
     * @description - resets Suppression fields  
     * @param Database.BatchableContext batchContext, List<sObject> scope   
     */    
    global void execute(Database.BatchableContext batchContext, List<sObject> scope){
         List<Contact> contList= new List<Contact>(); 
        for (sObject sObj : scope) {
            Contact currentContact = (Contact)sObj;
            currentContact.Suppression_End_Date__c= null;
            currentContact.Suppression_Start_Date__c= null;
            currentContact.Suppress_Marketing__c= False;
            contList.add(currentContact);
        }
        
        if(contList.size() > 0) {
            Database.update(contList, false);
        }
       
    }
    
    /**
     * @description - Sends an email to submitter of batch informing him the status of batch job. 
     * @param Database.BatchableContext batchContext   
     */
    global void finish(Database.BatchableContext batchContext){
      // Get the ID of the AsyncApexJob representing this batch job  
      // from Database.BatchableContext.    
      // Query the AsyncApexJob object to retrieve the current job's information.  
    
     AsyncApexJob apexJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                              TotalJobItems, CreatedBy.Email
                       from AsyncApexJob where Id =:batchContext.getJobId()];
    
      // Send an email to the Apex job's submitter notifying of job completion.  
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String[] toAddresses = new String[] {apexJob.CreatedBy.Email};
      mail.setToAddresses(toAddresses);
      mail.setSubject('Batch Job ' + apexJob.Status);
      mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems +
        ' batches with '+ apexJob.NumberOfErrors + ' failures.');
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
}