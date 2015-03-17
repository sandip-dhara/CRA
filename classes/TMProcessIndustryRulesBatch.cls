/**********************************************************
* Class Name: TMProcessIndustryRulesBatch 
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: This is a batch class that performs processing of Account aginst Industry Type Territory Definition.
***********************************************************/
global class TMProcessIndustryRulesBatch implements Database.batchable<sObject> ,  Database.Stateful{

       
    global String accountToProcess = TMBatchHelper.queryString2;
    
    /**
    * @description: Queries accounts to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/     
    global Database.queryLocator start(Database.BatchableContext ctx){  
        if ( Test.isRunningTest() ) accountToProcess += ' limit 30';
        system.debug('***accountToProcess Query2' + accountToProcess);
        return Database.getQueryLocator(accountToProcess);
    }
     
    /**
    * @description: Execute method for finding matching Industryrules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/
    global void execute(Database.BatchableContext ctx, List<Account> accountToProcessList){
        
        system.debug('****accountToProcessList****' + accountToProcessList.size());
        Map<Id, Account> allAccountsById = new Map<Id, Account>();
        List<Account> accUpdateList = new List<Account>();
        
        for(Account accObj : accountToProcessList){
            allAccountsById.put(accObj.Id,accObj);
            
         	accObj.LastIndustryAssignmentDate__c = Datetime.now();
            accUpdateList.add(accObj);
        }
        TerritoryAssignmentEngine.matchByIndustryRules(allAccountsById);
                
        try{
            if(!accUpdateList.isEmpty()){
                database.update(accUpdateList,true);
            }
        }catch(Exception e){
            system.debug('***Exception occured while setting LastIndustryAssignmentDate__c  in Industry Rules Batch on Account ****' + e.getMessage());
        }
    }

    /**
    * @description: finish method for sending completion mail of matching Industry rules and schedule for Coverage rules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/     
    global void finish(Database.BatchableContext ctx){
        
        //Mail notification...
        TMBatchHelper.sendEmailNotification(ctx, Label.Industry);
                          
        //Schedulable class Instance.
        TMProcessCoverageRulesSchedule coverageSchedule = new TMProcessCoverageRulesSchedule();
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule(Label.CoverageRules_Job+datetime.now(), schExp, coverageSchedule);
                         
    }
}