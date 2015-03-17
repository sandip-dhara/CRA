/***************************************************************************************************
* Class Name: TMRemovePartnerShareBatch 
* Author: HP
* Date: 08-OCT-2013 
* Requirement # Request Id: 7525
* Description: This is a batch that removes sharing of Opptys when Oppty's Account is made Private.
****************************************************************************************************/
global class TMRemovePartnerShareBatch implements Database.Batchable<sObject>{
    global Set<Id> accountIdSet;
    
    global TMRemovePartnerShareBatch(Set<Id> accIdSet){ 
        accountIdSet = accIdSet;
    }
    
    /**
    * @description: Queries opportunities to process
    * @param: Database.BatchableContext bc    
    * @return: Database queryLocator
    **/ 
    global Database.QueryLocator start(Database.BatchableContext bc){
        String processQry = 'Select Id,AccountId,Confidential__c From Opportunity  Where AccountId In :accountIdSet';
        if(Test.isRunningTest()){
            processQry += ' Limit 5';
        }
        return Database.getQueryLocator(processQry);
    }
    
    /**
    * @description: Execute method for removing opportunity share
    * @param: Database.BatchableContext bc, List<Opportunity> opptyList - opportunity list to process
    **/  
    global void execute(Database.BatchableContext bc,List<Opportunity> opptyList){
        
        if(null != opptyList && !opptyList.isEmpty()){
            Map<Id,Opportunity> optyMap = new Map<Id,Opportunity>(opptyList);
            TMPartnerOpportunityShareController.removeOpptyShareForPartnerTerritories(optyMap);
        }
    }
    
    /**
    * @description: finish method for sending completion mail and schedule for Process clean up batch
    * @param: Database.BatchableContext bc
    **/  
    global void finish(Database.BatchableContext bc){
            AsyncApexJob apxjob = [Select TotalJobItems,CreatedBy.Email From AsyncApexJob Where Id = :bc.getJobId()];
            
            String emailMessage = 'Your Apex batch job for '
                                  +'TM Remove Partner Share  '
                                  +'has finished. It executed '
                                  +apxJob.TotalJobItems+' batches.';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{apxJob.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('noreply@salesforce.com');
            mail.setSenderDisplayName('Batch Job Summary');
            mail.setSubject('Batch Job Completed - TM Remove Partner Share');
            mail.setPlainTextBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                
            TMProcessCleanUpScheduler accTeamSc = new TMProcessCleanUpScheduler();
            DateTime curDateTime = DateTime.now();
            String min = String.valueOf(math.mod((curDateTime.minute() + 2),60));
            String schExp = '0 '+min+' * * * ?' ;
            system.schedule('TM-Process CleanUp Job'+DateTime.now(),schExp,accTeamSc);
    }
}