/************************************************************************************************************
* Class Name: TMAddPtrShareNonPvtAccBatch
* Author: HP
* Date: 08-OCT-2013 
* Requirement # Request Id: 7525
* Description: This is a batch call that performs sharing of Opptys when Oppty's Account is made Non-Private.
*************************************************************************************************************/
global class TMAddPtrShareNonPvtAccBatch implements Database.Batchable<sObject>,Database.Stateful{
    global Set<Id> allAccountIdSet = new  Set<Id>();
    
    /**
    * @description: Queries Accounts that are marked non-private
    * @param: Database.BatchableContext bc    
    * @return: Database queryLocator
    **/ 
    global Database.QueryLocator start(Database.BatchableContext bc){
        String  qryToProcess = 'Select id from Account Where Private_Flag_Status__c = \'Marked Non-Private\'';
        if(Test.isRunningTest()){
            qryToProcess += ' Limit 5';
        }
        return Database.getQueryLocator(qryToProcess);
    }
    
    /**
    * @description: Execute method for creating opportunity share
    * @param: Database.BatchableContext bc, List<Account> accList - account list to process
    **/  
    global void execute(Database.BatchableContext bc,List<Account> accList){ 
        if(null != accList && !accList.isEmpty()){
            List<Account> accUpdtList = new List<Account>();
            for(Account acc:accList){
                allAccountIdSet.add(acc.Id);
                
                acc.Private_Flag_Status__c = '';
                accUpdtList.add(acc);
            }
            try{
                Database.SaveResult[] saveResultsAr = database.update(accUpdtList,false);
            }catch(Exception e){
                system.debug('***Exception occured while Updating Private_Flag_Status__c flag in TMAddPtrShareNonPvtAccBatch on Account ****' + e.getMessage());
            }
        }
    }
    
     /**
    * @description: finish method for calling TMCreatePartnerShareBatch
    * @param: Database.BatchableContext ctx
    **/  
    global void finish(Database.BatchableContext bc){
        if(null != allAccountIdSet && !allAccountIdSet.isEmpty()){
            Integer batchSize = Integer.valueOf(Batch_size__c.getValues('Partner Oppty Share batches size').Batch_size__c);
            Database.executeBatch(new TMCreatePartnerShareBatch(allAccountIdSet),batchSize);
        }else{
            TMBatchHelper.sendEmailNotification(bc,Label.Add_Partner_Share);
            
            TMRemovePtrSharePvtAccScheduler removeShareScheduler = new TMRemovePtrSharePvtAccScheduler();
            DateTime curDateTime = DateTime.now();
            String min = String.valueOf(math.mod((curDateTime.minute() + 2),60));
            String schExp = '0 '+min+' * * * ?' ;
            system.schedule('TM - Remove Partner Share for Private Customer Accounts',schExp,removeShareScheduler);
        }
        
    }
}