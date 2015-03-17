/**********************************************************
* Class Name: TMProcessCoverageRulesBatch 
* Author: Accenture
* Date: 20-JUL-2012  
* Requirement # Request Id: 
* Description: This is a batch class that performs processing of Account against Coverage Type Territory Definition.
***********************************************************/
global class TMProcessCoverageRulesBatch implements Database.batchable<sObject> ,  Database.Stateful{


    global String accountToProcess = TMBatchHelper.queryString2;
      
    /**
    * @description: Queries accounts to process
    * @param: Database.BatchableContext ctx
    **/    
    global Database.queryLocator start(Database.BatchableContext ctx){
        if ( Test.isRunningTest() ) accountToProcess += ' limit 30';  
        return Database.getQueryLocator(accountToProcess);
    }
     
    /**
    * @description: Execute method for finding matching coverage rules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/ 
    global void execute(Database.BatchableContext ctx, List<Account> accountToProcessList){
        
        Map<Id, Account> allAccountsById = new Map<Id, Account>();
        List<Account> accUpdateList = new List<Account>();
        
        for(Account accObj : accountToProcessList){
           allAccountsById.put(accObj.Id,accObj);
           
           accObj.LastCoverageAssignmentDate__c = Datetime.now();
           accUpdateList.add(accObj);
        }
        TerritoryAssignmentEngine.matchByCoverageRules(allAccountsById);      
          
        try{
            if(!accUpdateList.isEmpty()){
                database.update(accUpdateList,true);
            }
        }catch(Exception e){
            system.debug('***Exception occured while setting LastCoverageAssignmentDate__c in Coverage Rules Batch on Account ****' + e.getMessage());
        }
    }
    
    /**
    * @description: finish method for sending completion mail of matching coverage rules and schedule for Geo rules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/    
    global void finish(Database.BatchableContext ctx){
        
        //Mail notification...
        TMBatchHelper.sendEmailNotification(ctx, 'Coverage');
                          
        //TM:R4:CR3999:Debmalya:4th Jan,2013:call BA Market Rules Scheduler:Start
        //Schedulable class Instance.
        TMProcessBAMarketRulesScheduler marketSchedule = new TMProcessBAMarketRulesScheduler();
        //TM:R4:CR3999:Debmalya:4th Jan,2013:call BA Market Rules Scheduler:End
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule(Label.Market_Rules_Job+datetime.now(), schExp,marketSchedule);
                         
    }
}