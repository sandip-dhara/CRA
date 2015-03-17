/**********************************************************
* Class Name: TMProcessAccountProfRulesBatch
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: This is a batch class that performs processing of Account aginst Account Profile Type Territory Definition.
***********************************************************/
global class TMProcessAccountProfRulesBatch implements Database.batchable<sObject> ,  Database.Stateful{


    global String accountToProcess = TMBatchHelper.queryString;
    global Set<Id> accIdForAllBatch = new Set<Id>();
    //TM:R6:CR-ID:11429:Vinay:Start
    global Map<Id,List<Sales_Territory_Definition__c>> allMatchingBRRulesByAccId = new Map<Id,List<Sales_Territory_Definition__c>>();
    public TMEngineAccountRecordType__c recTypeObj = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
    public String curRecordType = recTypeObj.AccountRecordType__c;
   
    //TM:R6:CR-ID:11429:Vinay:End
    /**
    * @description: Queries accounts to process
    * @param: Database.BatchableContext ctx    
    * @return: Database queryLocator
    **/ 
    global Database.queryLocator start(Database.BatchableContext ctx){
     system.debug('accToProcess>>>> '+accountToProcess);
        system.debug(accountToProcess);
        if ( Test.isRunningTest() ) accountToProcess += ' limit 30';
        return Database.getQueryLocator(accountToProcess);
    }

    /**
    * @description: Execute method for finding matching Account profile rules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/      
    global void execute(Database.BatchableContext ctx, List<Account> accountToProcessList){
        Map<Id,List<Sales_Territory_Definition__c>> matchingBRRulesByAccId = new Map<Id,List<Sales_Territory_Definition__c>>();
        Map<Id, Account> allAccountsById = new Map<Id, Account>();
        Set<Id> accountIds = new Set<Id>();
        List<Account> accUpdateList = new List<Account>();
        system.debug(accountToProcessList);
        for(Account accObj : accountToProcessList){
            allAccountsById.put(accObj.Id,accObj);
            accountIds.add(accObj.Id);
            
            accObj.AccountProfileEvaluated__c = true;
            accObj.LastAcountProfAssignmentDate__c = Datetime.now();
            accUpdateList.add(accObj);
            
            
        }
        TerritoryManagementPostAssignment.processCleanUp(accountIds);
        //TM:R6:CR-ID:11429:Vinay:Start
        if(curRecordType == 'Partner'){
            matchingBRRulesByAccId = TerritoryAssignmentEngine.matchByPartnerBRRules(allAccountsById);
            if(null != matchingBRRulesByAccId && !matchingBRRulesByAccId.isEmpty()){
                allMatchingBRRulesByAccId.putAll(matchingBRRulesByAccId);
            }
        }else{
            TerritoryAssignmentEngine.matchByAccountProfileRules(allAccountsById);
        }
        //TM:R6:CR-ID:11429:Vinay:End
        
        try{
            if(!accUpdateList.isEmpty()){
                database.update(accUpdateList,true);
            }
        }catch(Exception e){
            system.debug('***Exception occured while Updating AccountProfileEvaluated__c flag in AccountProfileBatch on Account ****' + e.getMessage());
        }
    }
    
    /**
    * @description: finish method for sending completion mail of matching Account profile rules and schedule for Industry rules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/    
    global void finish(Database.BatchableContext ctx){
        //TM:R6:CR-ID:11429:Vinay:Start
        if(curRecordType == 'Partner' && null != allMatchingBRRulesByAccId && !allMatchingBRRulesByAccId.isEmpty()){
            Set<Id> partnerAccIdSet = allMatchingBRRulesByAccId.keySet();
            Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Partner BR Oppty Share batch size').Batch_Size__c);
            Database.executeBatch(new TMProcessPartnerBROpptyShareBatch(partnerAccIdSet),batchSize);
        }else{
            //Mail notification...
        TMBatchHelper.sendEmailNotification(ctx, Label.Account_Profile);  
             
        //Schedulable class Instance.
        TMProcessIndustryRulesScheduled industrySchedule = new TMProcessIndustryRulesScheduled();
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule(Label.Industry_Rules_Job+datetime.now(), schExp, industrySchedule);     
        }
        //TM:R6:CR-ID:11429:Vinay:End                           
    }
}