/**********************************************************
* Class Name: TMProcessBAMarketRulesBatch 
* Author: Debmalya:HP
* Date: 20-JUL-2012  
* Requirement # Request Id:3999 
* Description: This is a batch class that performs processing of Account against BA Market Rule Type Territory Definitions.
***********************************************************/
global class TMProcessBAMarketRulesBatch implements Database.batchable<sObject> ,  Database.Stateful{


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
        TerritoryAssignmentEngine.matchByBAMarketRules(allAccountsById);      
          
        try{
            if(!accUpdateList.isEmpty()){
                database.update(accUpdateList,true);
            }
        }catch(Exception e){
            system.debug('***Exception occured while setting LastCoverageAssignmentDate__c in BA Market Rules Batch on Account ****' + e.getMessage());
        }
    }
    
    /**
    * @description: finish method for sending completion mail of matching coverage rules and schedule for Geo rules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/    
    global void finish(Database.BatchableContext ctx){
        
        //Mail notification...
        TMBatchHelper.sendEmailNotification(ctx, 'Coverage');
                          
        //Schedulable class Instance.
        TMProcessGeoRulesSchedule geoSchedule = new TMProcessGeoRulesSchedule();
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule(Label.Geo_Rules_Job+datetime.now(), schExp,geoSchedule);
                         
    }
}