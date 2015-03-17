/**********************************************************
* Class Name: TMProcessGeoRulesBatch 
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: This is a batch class that performs processing of Account aginst Goe Type Territory Definition.
***********************************************************/
global class TMProcessGeoRulesBatch implements Database.batchable<sObject> ,  Database.Stateful{


    global String accountToProcess = TMBatchHelper.queryString2;
    
   
    /**
    * @description: Queries accounts to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/    
    global Database.queryLocator start(Database.BatchableContext ctx){
        if ( Test.isRunningTest() ) accountToProcess += ' limit 30';  
        return Database.getQueryLocator(accountToProcess);
    }
     
    /**
    * @description: Execute method for finding matching Geo rules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/
    global void execute(Database.BatchableContext ctx, List<Account> accountToProcessList){
        
        Map<Id, Account> allAccountsById = new Map<Id, Account>();
        List<Account> accUpdateList = new List<Account>();
        
        for(Account accObj : accountToProcessList){
            
                allAccountsById.put(accObj.Id,accObj);
                /* Sreenath Req - 2089 10/25/2012 starts */
                  //Evaluate territory flag should not false for delta changes
                  
                  TerritoryDeltaChanges__c Terrchanges = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
                  if(Terrchanges.Territory_Evaluation__c == false){
                  accObj.EvaluateTerritory__c = false;
                  }
                /* Sreenath Req - 2089 10/25/2012 ends */
                
                //Update flag = false.
                accObj.AccountProfileEvaluated__c = false;
                accObj.LastAssignmentDate__c = DateTime.now();
                accUpdateList.add(accObj);
        }
        
        TerritoryAssignmentEngine.matchByGeoRules(allAccountsById);
        
        try{
            if(!accUpdateList.isEmpty()){
                database.update(accUpdateList,true);
            }
        }catch(Exception e){
            system.debug('***Exception occured while Updating EvaluateTerritory__c flag in Account ****' + e.getMessage());
        }
    }

    /**
    * @description: finish method for sending completion mail of matching Geo rules 
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/      
    global void finish(Database.BatchableContext ctx){
              
        //Mail notification...
        TMBatchHelper.sendEmailNotification(ctx, Label.Geographic);
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute()+2),60));
        String schExp = '0 '+min+' * * * ? ';
        
        TMEngineAccountRecordType__c recTypeObj = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        //TM:R5:Vinay M:May 6 2013 Fix for CR:7252--Start
        //Adding condition based on type of batch (Customer/Partner)--Start
        if(recTypeObj.AccountRecordType__c == 'Partner'){
            TMProcessLocationRulesScheduled locationScheduled = new TMProcessLocationRulesScheduled();
            system.schedule(Label.LocationRules_Job+datetime.now(), schExp, locationScheduled);
        }else if(recTypeObj.AccountRecordType__c == 'Customer'){
            TMProcessCleanUpScheduler accTeamSc = new TMProcessCleanUpScheduler();
            system.schedule('TM-Process CleanUp Job'+datetime.now(), schExp, accTeamSc);
        }
        //TM:R5:Vinay M:May 6 2013 Fix for CR:7252--End
    }
}