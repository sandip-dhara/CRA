/**********************************************************
* Class Name: TurnEvaluateTerrFlagTrue 
* Author: HP
* Description: This batch turns the Evaluate Territory flag to true for all Accounts which have been affected due to change
*              in World Region Object
***********************************************************/

global class TurnEvalTerrFlagTrueBatch implements Database.batchable<sObject> ,  Database.Stateful{

    global String accQueryString = 'Select Id, EvaluateTerritory__c from Account where ';
    global Set<String> countryNames = new Set<String>();
    global Set<String> regionNames = new Set<String>();
    
     /**
    * @description: One argument constructor to hold QueryString to process Accounts.
    * @param: Set<Id> accIdSet  
    **/
    global TurnEvalTerrFlagTrueBatch (Set<String> cNames, Set<String> rNames){
        if(cNames.size() > 0){
            countryNames = cNames;
        }
        if(rNames.size() > 0){
            regionNames = rNames;
        }
        //accQueryString = qStr;
    }
    
     /**
    * @description: Queries accounts which needs Evaluate Territory to be turned true
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/
    global Database.queryLocator start(Database.BatchableContext ctx){
        Boolean cNameExists = false;
        if(countryNames.size() > 0){
            String cString = TerritoryAssignmentUtilities.getCommaSeperatedStringList(countryNames);
            accQueryString +='ShippingCountry IN' + cString;
            cNameExists = true;  
        }
        if(regionNames.size() > 0){
            if(cNameExists){
                accQueryString += ' OR ';
            }
            String rString = TerritoryAssignmentUtilities.getCommaSeperatedStringList(regionNames);
            accQueryString +='WorldRegion_SubRegion1__c IN' + rString +
                             ' OR WorldRegion_SubRegion2__c IN' + rString +
                             ' OR WorldRegion_SubRegion3__c IN' + rString; 
        }
        if ( Test.isRunningTest() ) accQueryString += ' limit 30';           
        return Database.getQueryLocator(accQueryString);
    }
    
    /**
    * @description: Execute method for finding matching Accounts
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/
    global void execute(Database.BatchableContext ctx, List<Account> accountToProcessList){
        try{
            for(Integer i = 0; i < accountToProcessList.size();i++){
                accountToProcessList[i].EvaluateTerritory__c = true;
            }
            if(accountToProcessList.size() > 0){
                database.update(accountToProcessList,true);
            }
        }catch(Exception e){
            system.debug('***Exception occured while Updating EvaluateTerritory__c flag in Account ****' + e.getMessage());
        }
    }
    
     /**
    * @description: finish method for sending completion mail of after turning Evaluate Territory Flag true 
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/
    global void finish(Database.BatchableContext ctx){
    }
}