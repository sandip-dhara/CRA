/**
  * @author: rahul.kunal (Accenture)
  * HP Release 2
  * This Class drives the logic for processing batch operation for Specialty Functionality
  * on Opportunity Update or Specialty Realignment.
  * Date:
  */
global class ProcessOpportunitySpecialtyBatch implements Database.batchable<sObject> , Database.Stateful{
    
    global final Batch_Job_Invoker__c batchInvoker;
    global String opportunityToProcess;
    
    //Constructor
    global ProcessOpportunitySpecialtyBatch(Batch_Job_Invoker__c invokerObj){
        batchInvoker = invokerObj; 
    }
    
    global ProcessOpportunitySpecialtyBatch(){
        
    }
  
    //Start method: here it executes the query.
    global Database.queryLocator start(Database.BatchableContext ctx){
        //check whether the type of batch invoke is Specialty Oppty Update or Specialty Realignment depending on them excute the specific query.
        /*
         * Start: Changes for CR-0134: Rahul Kunal
         * Date: 8/8/2012
         * Description: Removing Opportunity Update Call from this batch.
         */
        /*if(batchInvoker != null && batchInvoker.Type__c.equalsIgnoreCase('Specialty Oppty Update')){
            opportunityToProcess = 'Select o.isUpdated__c, o.Id From Opportunity o Where o.isUpdated__c = true';
        }else*/
        
        /*
         * End: Changes for CR-0134.
         */
        if(batchInvoker != null && batchInvoker.Type__c.equalsIgnoreCase('Specialty Realignment')){
             // TM: R5: Nasir Jawed filtering the query, so that unwanted records gets reduced from the opportunity.Start
            opportunityToProcess ='select id from Opportunity'+
                        ' where isClosed=False ';
             // TM: R5: Nasir Jawed: End
            //opportunityToProcess = 'Select o.Id from Opportunity o ';
        }
        if ( Test.isRunningTest() ) opportunityToProcess += ' limit 30';
        return Database.getQueryLocator(opportunityToProcess);
    }
    
    //Execute Method
    global void execute(Database.BatchableContext ctx, List<Opportunity> opportunityToProcessList){
        Map<Id,Opportunity> oppIdOppObjMap = new Map<Id,Opportunity>();
        /*
         * Start: Changes for CR-0134: Rahul Kunal
         * Date: 8/8/2012
         * Description: Removing Opportunity Update Call from this batch.
         *              Also commenting all the code related to IsUpdated flag.
         */
            /*List<Opportunity> oppUpdateList = new List<Opportunity>();
            
            for(Opportunity oppObj : opportunityToProcessList){
                if(batchInvoker != null && batchInvoker.Type__c.equalsIgnoreCase('Specialty Oppty Update')){
                    oppObj.isUpdated__c = false;
                    oppUpdateList.add(oppObj);
                }
                oppIdOppObjMap.put(oppObj.Id,oppObj);
            }
            
            if(oppUpdateList != null && oppUpdateList.size() > 0){
                try{
                    update oppUpdateList;
                }catch(Exception excp){
                    system.debug('Exception occured while updating the isUpdated field to false before processing batch '+excp.getMessage());
                }
            }*/
        
        for(Opportunity oppObj : opportunityToProcessList){
            oppIdOppObjMap.put(oppObj.Id,oppObj);
        }
        /*
         * End: Changes for CR-0134.
         */
        Map<Id,Set<Id>> oppLineItemProductSetMap = new Map<Id,Set<Id>>();
        for(OpportunityLineItem oppLineItemObj : [Select o.Id, o.Product__c, o.OpportunityId From OpportunityLineItem o Where o.OpportunityId in : oppIdOppObjMap.keySet()]){
                
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
                              + (batchInvoker != null ? batchInvoker.Type__c :'') + ' has finished. It executed '  
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
                try{
                    database.update(batchInvokerList,false);
                }catch(Exception exp){
                    system.debug('Exception occured while updating Realignment Scheduler record to complete: '+exp.getMessage());
                }
                
            }
        }
        
    }
    

}