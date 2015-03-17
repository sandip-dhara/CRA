/***********************************************************
* Class Name: CCLeadDropOffTriggerBatch
* Author: HP (Sreedhar Jagannath)
* Date: 15-JUL-2013 
* Requirement # Request Id: 
* Description: Batch Class to Update Lead Records to Closed If SysDate > Created Date + 7 
***********************************************************/
global class CCLeadDropOffTriggerBatch implements Database.Batchable<sObject> {
     
      datetime dateTimeNow = DateTime.now();
      datetime newDate = dateTimeNow.addDays(-7);
      String dateTimeFormat = newDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
      String LeadRecordTypeId = String.valueof(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Unqualified Lead').getRecordTypeId());     
      public String query =  'SELECT Id,CreatedDate,Closed_Reason__c,Status,LeadSource,LastModifiedDate from Lead where RecordTypeid=\'' + LeadRecordTypeId + '\' AND CreatedDate < '+ dateTimeFormat+'AND Status <> \'Closed\' AND Last_Successful_Call__c = NULL AND LeadSource = \'List Import\'';
      public Integer counter = [select count() from Lead where RecordTypeId =:LeadRecordTypeId  AND Status <> 'Closed' AND Last_Successful_Call__c = NULL AND LeadSource = 'List Import' AND CreatedDate <: newDate ];
      
      global Database.QueryLocator start(Database.BatchableContext BC){ 
        system.debug('#####'+query);
        return Database.getQueryLocator(query);   
     
      }
     
      global void execute(Database.BatchableContext BC, List<sObject> scope){ 
        List<Lead> leads = new List<Lead>(); 
        for(sObject s : scope){
           Lead c = (Lead)s;
           c.Status = 'Closed';
           c.Closed_Reason__c = 'Lead Expired';
                leads.add(c);
            }
        Database.update(leads,false);   
     }
     
      global void finish(Database.BatchableContext BC){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
        system.debug('JobItemsProcessed'+a.JobItemsProcessed);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> idList = new List<String>();  
        String[] toAddresses = new String[] {};  
        Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name =:Label.CC_Public_Group]; 
        for (GroupMember gm : g.groupMembers) {        
            idList.add(gm.userOrGroupId);    
        }    
        User[] usr = [SELECT email FROM user WHERE id IN :idList];    
        for(User u : usr) {        
            toAddresses.add(u.email);    
        }  
        mail.setToAddresses(toAddresses);
        mail.setSubject('Contact Center Leads Dropped off from the Lead List View ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + counter  +'  successful records with'+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      }
     
    }