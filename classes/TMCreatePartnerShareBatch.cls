/***************************************************************************************************
* Class Name: TMCreatePartnerShareBatch 
* Author: HP
* Date: 08-OCT-2013 
* Requirement # Request Id: 7525
* Description: This is a batch that performs sharing of Opptys when Oppty's Account is made non Private.
****************************************************************************************************/

global class TMCreatePartnerShareBatch implements Database.Batchable<sObject>{

    global Set<Id> accIdSet;
    
    global TMCreatePartnerShareBatch(Set<Id> accIdSet){
        this.accIdSet = accIdSet;
    }
   
   /**
    * @description: Queries opportunities to process
    * @param: Database.BatchableContext bc    
    * @return: Database queryLocator
    **/ 
    global Database.QueryLocator start(Database.BatchableContext bc){
        String qryToProcess = 'Select Id,AccountId,Confidential__c From Opportunity  Where AccountId In :accIdSet';
        if(Test.isRunningTest()){
            qryToProcess += ' Limit 5';
        }
        return Database.getQueryLocator(qryToProcess);
    }
    
    /**
    * @description: Execute method for creating opportunity share
    * @param: Database.BatchableContext bc, List<Opportunity> optyList - opportunity list to process
    **/  
    global void execute(Database.BatchableContext bc,List<Opportunity> optyList){
        
        if(null != optyList && !optyList.isEmpty()){
            Map<Id,Opportunity> optyMap = new Map<Id,Opportunity>(optyList);
            TMPartnerOpportunityShareController.addOpptyShareForPartnerTerritories(optyMap);
        }
    }
    
    /**
    * @description: finish method for sending completion mail  and schedule for Oppty share remove batch
    * @param: Database.BatchableContext bc
    **/  
    global void finish(Database.BatchableContext bc){
            AsyncApexJob apxjob = [Select TotalJobItems,CreatedBy.Email From AsyncApexJob Where Id = :bc.getJobId()];
            
            String emailMessage = 'Your Apex batch job for '
                                  +'TM Create Partner Share for Non-Private Accounts '
                                  +'has finished. It executed '
                                  +apxJob.TotalJobItems+' batches.';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{apxJob.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('noreply@salesforce.com');
            mail.setSenderDisplayName('Batch Job Summary');
            mail.setSubject('Batch Job Completed - TM Create Partner Share for Non-Private Accounts');
            mail.setPlainTextBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
            
            TMRemovePtrSharePvtAccScheduler removeShareScheduler = new TMRemovePtrSharePvtAccScheduler();
            DateTime curDateTime = DateTime.now();
            String min = String.valueOf(math.mod((curDateTime.minute() + 2),60));
            String schExp = '0 '+min+' * * * ?' ;
            system.schedule('TM - Remove Partner Share for Private Customer Accounts',schExp,removeShareScheduler);
    }
}