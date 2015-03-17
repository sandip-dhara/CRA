/************************************************************************************************************
* Class Name: TMRemovePtrSharePvtAccBatch
* Author: HP
* Date: 08-OCT-2013 
* Requirement # Request Id: 7525
* Description: This is a batch call that removes sharing of Opptys when Oppty's Account is made Private.
*************************************************************************************************************/

global class TMRemovePtrSharePvtAccBatch implements Database.Batchable<sObject>,Database.Stateful{
    global Set<Id> allAccountIdSet = new Set<Id>();
    
     /**
    * @description: Queries Accounts that are marked private
    * @param: Database.BatchableContext bc    
    * @return: Database queryLocator
    **/ 
    global Database.QueryLocator start(Database.BatchableContext bc){
        String processQry = 'Select id from Account Where Private_Flag_Status__c = \'Marked Private\'';
        if(Test.isRunningTest()){
            processQry += ' Limit 5';
        }
        return Database.getQueryLocator(processQry);
    }
    
    /**
    * @description: Execute method for removing opportunity share
    * @param: Database.BatchableContext bc, List<Account> accountList - account list to process
    **/  
    global void execute(Database.BatchableContext bc,List<Account> accountList){
        if(null != accountList && !accountList.isEmpty()){
            List<Account> accUpdtList = new List<Account>();
            
            for(Account acc:accountList){
                allAccountIdSet.add(acc.Id);
                acc.Private_Flag_Status__c = '';
                accUpdtList.add(acc);
            }
            
            try{
                Database.SaveResult[] saveResultsAr = database.update(accUpdtList,false);
            }catch(Exception e){
                system.debug('***Exception occured while Updating Private_Flag_Status__c flag in TMRemovePtrSharePvtAccBatch on Account ****' + e.getMessage());
            }
        }
    }
    
     /**
    * @description: finish method for calling TMRemovePartnerShareBatch
    * @param: Database.BatchableContext ctx
    **/  
    global void finish(Database.BatchableContext bc){
        if(null != allAccountIdSet && !allAccountIdSet.isEmpty()){
            Integer batchSize = Integer.valueOf(Batch_size__c.getValues('Partner Oppty Share batches size').Batch_size__c);
            database.executeBatch(new TMRemovePartnerShareBatch(allAccountIdSet),batchSize);
        }else{
            AsyncApexJob apxjob = [Select TotalJobItems,CreatedBy.Email From AsyncApexJob Where Id = :bc.getJobId()];
            
            String emailMessage = 'Your Apex batch job for '
                                  +'TM Remove Partner Share for Private Accounts '
                                  +'has finished. It executed '
                                  +apxJob.TotalJobItems+' batches.';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{apxJob.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('noreply@salesforce.com');
            mail.setSenderDisplayName('Batch Job Summary');
            mail.setSubject('Batch Job Completed - TM Remove Partner Share for Private Accounts');
            mail.setPlainTextBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                
            TMProcessCleanUpScheduler accTeamSc = new TMProcessCleanUpScheduler();
            DateTime curDateTime = DateTime.now();
            String min = String.valueOf(math.mod((curDateTime.minute() + 2),60));
            String schExp = '0 '+min+' * * * ?' ;
            system.schedule('TM-Process CleanUp Job'+DateTime.now(),schExp,accTeamSc);
        }
    }
}