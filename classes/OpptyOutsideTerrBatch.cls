/**********************************************************
* Class Name: OpptyOutsideTerrSchedule
* Author: HP
* Date: 03-Oct-2012  
* Requirement # Request Id: 1619 
* Description: This is a batch class that check if Opptunity Outside Territory flag should remain unchecked based on 
*              current territory assignments.  
***********************************************************/

global class OpptyOutsideTerrBatch implements Database.batchable<sObject> ,  Database.Stateful{
    
    global String opptoProcess = 'Select Id, Opportunity_Outside_Owner_s_Terr__c, Account.Id, Owner.Id from Opportunity where Opportunity_Outside_Owner_s_Terr__c = true';
    
    /**
    * @description: Queries accounts to process
    * @param: Database.BatchableContext ctx    
    * @return: Database queryLocator
    **/ 
    global Database.queryLocator start(Database.BatchableContext ctx){
        //if ( Test.isRunningTest() ) opptoProcess += ' limit 30';
        //TM: Sreenath modified isRunningTest to process proper oppty validation rules start
         if ( Test.isRunningTest() ){
            opptoProcess += ' and closedate > TODAY limit 10';
        }
        //TM: Sreenath modified isRunningTest to process proper oppty validation rules end
        return Database.getQueryLocator(opptoProcess);
    }
    
    /**
    * @description: Execute method for finding matching Opportunities with Opportunity_Outside_Owner_s_Terr__c true
    * @param: Database.BatchableContext ctx, List<Opportunity> opportunityToProcessList - opportunity list to process
    **/
    global void execute(Database.BatchableContext ctx, List<Opportunity> opportunityToProcessList){
        
        Set<Id> accSet = new Set<Id>();
        Set<Id> userSet = new Set<Id>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        
        for(Opportunity opp : opportunityToProcessList){
            accSet.add(opp.Account.Id);
            userSet.add(opp.Owner.Id);
        }
        
        Map<Id,Set<Id>> accStMap = CheckUserAccountTerritory.accSalesTerrMatches(accSet);
        Set<Id> saleTerrIds = new Set<Id>(); 
        
        for(Id accId: accStMap.keyset()){
            Set<Id> idSet = accStMap.get(accId);
            If(idSet.size() > 0){
                saleTerrIds.addAll(idSet);
            }
        }
        
        Map<Id,Set<Id>> userStMap = CheckUserAccountTerritory.userSalesTerrMatches(userSet,saleTerrIds);
        
        for(Opportunity opp : opportunityToProcessList){
            Set<Id> accSTSet = accStMap.get(opp.Account.Id);
            Set<Id> userStSet = userStMap.get(opp.Owner.Id);
            if(accStSet != null && userStSet != null){
                for(Id accSt : accStSet){
                    if(userStSet.contains(accSt)){
                        opp.Opportunity_Outside_Owner_s_Terr__c = false;
                        oppToUpdate.add(opp);
                        break;
                    }
                }
            }
        }
        
        if(oppToUpdate != null){
            update oppToUpdate;
        }
        
    }
    
    /**
    * @description: finish method for sending completion mail of batch
    * @param: Database.BatchableContext ctx, List<Opportunity> opportunityToProcessList - opportunity list to process
    **/    
    global void finish(Database.BatchableContext ctx){
        
    }
}