/**********************************************************
* Class Name: ActivateProductsBatch
* Author: Accenture
* Date: 10-May-2012 
* Requirement # 718
* Description: Batch to activate products & pricebook entries 
***********************************************************/
global class ActivateProductsBatch implements Database.Batchable<sObject>{
	   
    global String query;
    
    
   /**
     * @description - It fetches the query Locator for the provided query.
     * @param Database.BatchableContext batchContext
     * @return Database.QueryLocator
     */
    global Database.QueryLocator start(Database.BatchableContext batchContext){
        query = 'Select Id, IsActive, (Select Id, IsActive From PricebookEntries) From Product2 where IsActive = false';
        Database.QueryLocator queryLocator = Database.getQueryLocator(query);
        return queryLocator;
    }

   /**
     * @description - marks products & pricebookentry active & updates them  
     * @param Database.BatchableContext batchContext, List<sObject> scope   
     */    
    global void execute(Database.BatchableContext batchContext, List<sObject> scope){
        List<Product2> productList = new List<Product2>();
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>(); 
        for (sObject sObj : scope) {
            Product2 currentProduct = (Product2)sObj;
            currentProduct.IsActive = true;
            productList.add(currentProduct);
            for(PricebookEntry pricebookEntry :currentProduct.PricebookEntries) {
            	pricebookEntry.IsActive = true;
            	priceBookEntryList.add(pricebookEntry);
            }
        }
        if(productList.size() > 0) {
        	Database.update(productList, false);
        }
        if(priceBookEntryList.size() > 0) {
        	Database.update(priceBookEntryList, false);
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