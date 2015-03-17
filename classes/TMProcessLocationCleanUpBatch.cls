/**************************************************************************************************************
* Class Name: TMProcessLocationCleanUpBatch 
* Author: HP
* Description: This batch deletes associations between Location and Sales Territories no longer Valid
***************************************************************************************************************/

global class TMProcessLocationCleanUpBatch implements Database.batchable<sObject>, Database.Stateful{

    global String stLocToProcess = 'Select Id,Location__c,Sales_Territory__c,TrackAssociationToDelete__c,Sales_Territory__r.GroupId__c From Sales_Territory_Location_Assignment__c where TrackAssociationToDelete__c = true';
    
    /**
    * @description: Queries accounts in Sales_Territory_Location_Assignment__c to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/
    global Database.QueryLocator start(Database.BatchableContext bc){
        if ( Test.isRunningTest() ) stLocToProcess += ' limit 30';
        return Database.getQueryLocator(stLocToProcess);
    }
    
    /**
    * @description: Execute method for finding location assignment records that needs to be deleted
    * @param: Database.BatchableContext ctx, List<Account> stlaProcessList - location assignment list to process
    **/
    global void execute(Database.BatchableContext bc,List<Sales_Territory_Location_Assignment__c> stlaProcessList){
        try{
            List<Sales_Territory_Location_Assignment__c> stlaDeletionList = new List<Sales_Territory_Location_Assignment__c>();
            List<OpportunityShare> oppShare = new List<OpportunityShare>();
            Set<Id> locOppToDelete = new Set<Id>();
            Set<Id> grpToDelete = new Set<Id>();
            for(Sales_Territory_Location_Assignment__c stla: stlaProcessList){
                stlaDeletionList.add(stla);
                locOppToDelete.add(stla.location__c);
                grpToDelete.add(stla.Sales_Territory__r.GroupId__c);
            }
            if(!stlaDeletionList.isEmpty()){
                delete stlaDeletionList;
            }
            if(locOppToDelete !=null)
            {
                Set<Id> opptyId = new Set<Id>();
                List<Channel_Partner__c> oppToDel = [select id, Opportunity__c,location__c from Channel_Partner__c where location__c in :locOppToDelete ];
                for(integer i =0; i< oppToDel.size();i++)
                {
                    opptyId.add(oppToDel[i].Opportunity__c);
                }               
                for(OpportunityShare oppSh : [Select Id, opportunityId , UserOrGroupId from OpportunityShare where opportunityID IN : opptyId AND UserOrGroupId IN : grpToDelete AND RowCause = 'Manual'])
                {
                    oppShare.add(oppSh);
                }
                if(oppShare !=null)
                {
                    delete oppShare;
                }
            }        
        }catch(Exception e){
            system.debug('******Exception in TMProcessLocationCleanUpBatch*****'+e.getMessage());
        }
    }
    
    /**
    * @description: finish method for sending completion mail of location clean up process
    * @param: Database.BatchableContext ctx
    **/  
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select id, ApexClassId, JobItemsProcessed, NumberOfErrors, TotalJobItems, CreatedBy.Email From AsyncApexJob
                                                                                                            Where id =: bc.getJobId()];
        String emailMessage = 'Your batch job ' 
                              + 'APEX Batch Job for '
                              + 'TM Process Location Clean up' + ' has finished. It executed '  
                              + a.totalJobItems   
                              + ' batches.';  
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        String[] toAddress = new String[]{a.CreatedBy.Email};
        mail.setToAddresses(toAddress);
        mail.setReplyTo('noreply@salesforce.com');
        mail.setSenderDisplayName('Batch Job Summary');
        mail.setSubject('Batch Job Completed - TM Process Location Clean up Batch');
        mail.setPlainTextBody(emailMessage);
        Messaging.sendEmail(new Messaging.Singleemailmessage[]{mail});
        
        TMAddPtrShareNonPvtAccScheduler addPtrShare = new TMAddPtrShareNonPvtAccScheduler();
        
        Datetime currentDateTime = Datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2), 60));
        String schExp = '0 '+min+' * * * ?' ;
        system.schedule('TM - Add Partner Share for Non Private Customer Accounts', schExp, addPtrShare);
    }
}