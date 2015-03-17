/**************************************************************************************************************
* Description:
*   This is a batch class that performs processing of Account aginst Territory Definition after Territory re-allighnment.
*
***************************************************************************************************************/

global class AccountProcessOnTMReallignment implements Database.batchable<sObject> ,  Database.Stateful{
    
    
    global final Batch_Job_Invoker__c batchInvoker;
    
    // One Argument Constructor to capture Batch Job Invoker Id.
    global AccountProcessOnTMReallignment(Batch_Job_Invoker__c invokerObj){
            batchInvoker = invokerObj; 
    } 
    global String accountToProcess = 'Select Id, EvaluateTerritory__c From Account where EvaluateTerritory__c = false AND RecordType.Name = \'Customer\'';
    
    global Database.queryLocator start(Database.BatchableContext ctx){
        if ( Test.isRunningTest() ) accountToProcess += ' limit 30';
        return Database.getQueryLocator(accountToProcess);
    }
     
    
    //Execute Method
    global void execute(Database.BatchableContext ctx, List<Account> accountToProcessList){
        
        List<Account> accUpdateList = new List<Account>();
        
        for(Account accObj : accountToProcessList){
            accObj.EvaluateTerritory__c = true;
            accUpdateList.add(accObj);
        }
        
        if(!accUpdateList.isEmpty()){
            
            try{
                database.update(accUpdateList,true);
                
            } catch(Exception e){
                system.debug('**Exception Occured during Account Update in AccountProcessOnTMReallignment Batch ****' +  e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext ctx){
        //Mail notification...
            AsyncApexJob a = [SELECT id, ApexClassId,   
                   JobItemsProcessed, TotalJobItems,   
                   NumberOfErrors, CreatedBy.Email   
                   FROM AsyncApexJob   
                   WHERE id = :ctx.getJobId()];  
            
            String emailMessage = 'Your APEX Batch Job for Account Assignment after Territory re-allignment has been set for processing. It executed '  
                  + a.totalJobItems   
                  + ' Account batches for processing.';  
            Messaging.SingleEmailMessage mail =   
                  new Messaging.SingleEmailMessage();
                  
            List<String> emailAddress = new List<String>();
            emailAddress.add(a.CreatedBy.Email);
            
            TM_Specialty_Mail_Distribution_List__c pdl = TM_Specialty_Mail_Distribution_List__c.getInstance('Territory-Specialty Notification');
            if(pdl != null && pdl.IncludeAddress__c && pdl.Email_ID_List__c != '' && pdl.Email_ID_List__c != null){
                emailAddress.add(pdl.Email_ID_List__c);
            }
            
            String[] toAddresses = emailAddress;
            mail.setToAddresses(toAddresses);  
            mail.setReplyTo('noreply@salesforce.com');  
            mail.setSenderDisplayName('Batch Job Summary');  
            mail.setSubject('Batch Job Completed - ' + batchInvoker.Type__c);  
            mail.setPlainTextBody(emailMessage);  
            mail.setHtmlBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]   
                              { mail });  
                     
            // To set Batch Job Invoker Status as Completed after processing.                 
            List<Batch_Job_Invoker__c> batchInvokerList = new List<Batch_Job_Invoker__c>();
            Batch_Job_Invoker__c batchInvokerObj = [Select Id, Status__c from Batch_Job_Invoker__c where Id=: batchInvoker.Id limit 1];
                batchInvokerObj.Status__c = 'Completed';
                batchInvokerList.add(batchInvokerObj);
                
             if(batchInvokerList.size()>0){
                
                try{
                    database.update(batchInvokerList,false);
                
                } catch(Exception e){
                    system.debug('**Exception Occured during Account Update in AccountProcessOnTMReallignment Batch ****' +  e.getMessage());
                }
                
            }        
        }
}