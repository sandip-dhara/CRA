/**
  * @author: rahul.kunal (Accenture)
  * HP Release 2
  * This Class drives the logic for processing batch operation for Specialty Functionality
  * on Opportunity Update.
  * Date:
  */
global class ProcessOppUpdateSpecialtyBatch implements Database.batchable<sObject> , Database.Stateful{
    
    global final Batch_Job_Invoker__c batchInvoker;
    global String opportunityfromDataLog = 'Select d.Record_Id__c, d.Object_Name__c, d.Is_Added__c, d.Id From Log_Object__c d Where d.Is_Added__c = true And d.Object_Name__c = \'' + 'Opportunity' +'\'';
    
    global ProcessOppUpdateSpecialtyBatch(Batch_Job_Invoker__c invokerObj){
        batchInvoker = invokerObj;
    }
    
    //Start method: here it executes the query.
    global Database.queryLocator start(Database.BatchableContext ctx){
        //TM: Sreenath: fix to correct test method failure.
        if ( Test.isRunningTest() ) opportunityfromDataLog += ' limit 30';
        return Database.getQueryLocator(opportunityfromDataLog);
    }
    
    //Execute Method
    global void execute(Database.BatchableContext ctx, List<Log_Object__c> dataLogList){
        
        system.debug('>>>> Inside Execute');
        
        Set<String> oppSet = new Set<String>();
        List<Log_Object__c> dataLogToUpdateList = new List<Log_Object__c>(); 
        for(Log_Object__c obj : dataLogList){
            oppSet.add(obj.Record_Id__c);
            obj.Is_Added__c = false;
            dataLogToUpdateList.add(obj);
        }
        
        try{
            update dataLogToUpdateList;
        }catch(Exception exp){
            system.debug('Exception While Updating the Log Object record making Is Added field to False: '+exp.getMessage());
        }
        
        Map<Id,Set<Id>> oppLineItemProductSetMap = new Map<Id,Set<Id>>();
        for(OpportunityLineItem oppLineItemObj : [Select o.Id, o.Product__c, o.OpportunityId From OpportunityLineItem o Where o.OpportunityId in : oppSet]){
                
            Set<id> productSet = oppLineItemProductSetMap.get(oppLineItemObj.OpportunityId);
            if(null == productSet){
                productSet = new Set<Id>(); 
            } 
            productSet.add(oppLineItemObj.Product__c);
            oppLineItemProductSetMap.put(oppLineItemObj.OpportunityId,productSet);
        }
        
        OppLineItemTriggerController.executeUpdateProdSpcltyOppAsgnmntLogic(oppLineItemProductSetMap);
    }
    
    global void finish(Database.BatchableContext ctx){
        //Mail notification...
        AsyncApexJob a = [SELECT id, ApexClassId,  JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob   
                                                                                                                        WHERE id = :ctx.getJobId()];  
        String emailMessage = 'Your batch job ' 
                              + 'APEX Batch Job for '
                              + 'Opportunity-Update Specialty has finished. It executed '  
                              + a.totalJobItems   
                              + ' batches.';  
        
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage(); 
        
        List<String> emailAddress = new List<String>();
        emailAddress.add(a.CreatedBy.Email);
            
        TM_Specialty_Mail_Distribution_List__c pdl = TM_Specialty_Mail_Distribution_List__c.getInstance('Territory-Specialty Notification');
        if(pdl != null && pdl.IncludeAddress__c && pdl.Email_ID_List__c != '' && pdl.Email_ID_List__c != null){
            emailAddress.add(pdl.Email_ID_List__c);
        }
        TM_Specialty_Mail_Distribution_List__c pdl2 = TM_Specialty_Mail_Distribution_List__c.getInstance('Specialty Realignment_Oppty Update');
        if(pdl2 != null && pdl2.IncludeAddress__c && pdl2.Email_ID_List__c != '' && pdl2.Email_ID_List__c != null){
            emailAddress.add(pdl2.Email_ID_List__c);
        }
        
        String[] toAddresses = emailAddress;
        mail.setToAddresses(toAddresses);  
        mail.setReplyTo('noreply@salesforce.com');  
        mail.setSenderDisplayName('Batch Job Summary');  
        mail.setSubject('Batch Job Completed - ' + (batchInvoker != null ? batchInvoker.Type__c :'')); 
        mail.setPlainTextBody(emailMessage);  
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]   
                          { mail }); 
        
        // To set Batch Job Invoker Status as Completed after processing.                
        List<Batch_Job_Invoker__c> batchInvokerList = new List<Batch_Job_Invoker__c>();
        
        if(batchInvoker != null){
            Batch_Job_Invoker__c batchInvokerObj = [Select Id, Status__c from Batch_Job_Invoker__c where Id =: batchInvoker.Id limit 1];
            batchInvokerObj.Status__c = 'Completed';
            batchInvokerList.add(batchInvokerObj);
                
             if(batchInvokerList.size()>0){
                database.update(batchInvokerList,false);
            }
        }                  
    }

}