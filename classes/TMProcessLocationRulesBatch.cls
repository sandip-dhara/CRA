/**********************************************************
* Class Name: TMProcessLocationRulesBatch 
* Author: HP
* Date: 19-MAR-2013 
* Requirement # Request Id: 6201
* Description: This is a batch class that performs processing of Location aginst Location Type Territory Definition.
***********************************************************/
global class TMProcessLocationRulesBatch implements Database.batchable<sObject> , Database.Stateful{
    global String locationToProcess = TMBatchHelper.queryString3;
    global Map<Id,List<Sales_Territory_Definition__c>> allMatchingRulesByLocIdMap = new Map <Id,List<Sales_Territory_Definition__c>>(); 
    /**
    * @description: Queries locations to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/ 
    global Database.QueryLocator start(Database.BatchableContext ctx){
            /*if ( Test.isRunningTest() ) locationToProcess += ' limit 30';*/
            return Database.getQueryLocator(locationToProcess);
    }
    
    /**
    * @description: Execute method for finding matching Location rules
    * @param: Database.BatchableContext ctx, List<Location> locationToProcessList - locations list to process
    **/
    global void execute(Database.BatchableContext ctx,List<Location__c> locationToProcessList){
        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocIdMap = new Map <Id,List<Sales_Territory_Definition__c>>();
        Map<Id,Location__c> allLocationsByIdMap = new Map<Id,Location__c>();
        List<Location__c> locUpdateList = new List<Location__c>();
        Set<Id> locationIdSet = new Set<Id>();
        for(Location__c loc:locationToProcessList){
            allLocationsByIdMap.put(loc.Id,loc);
            locationIdSet.add(loc.Id);
            TerritoryDeltaChanges__c terrChanges = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
            if(terrChanges.Territory_Evaluation__c == false){
                loc.EvaluateTerritory__c = false;
            }
            locUpdateList.add(loc);
        }
        //Method call to mark invalid Sales territory location assignment - Start
        TMPostLocationAssignment.processCleanUpLocation(locationIdSet);
        //Method call to mark invalid Sales territory location assignment - End
        matchingRulesByLocIdMap = TerritoryAssignmentEngine.matchByLocationRules(allLocationsByIdMap);
        
        if(matchingRulesByLocIdMap != null && !matchingRulesByLocIdMap.isEmpty()){
            allMatchingRulesByLocIdMap.putAll(matchingRulesByLocIdMap);
        }
        
        try{
            if(!locUpdateList.isEmpty()){
                Database.update(locUpdateList,true);
            }
        }catch(Exception e){
            system.debug('***Exception occured while Updating EvaluateTerritory__c flag in Location ****' + e.getMessage());
        }
    }
    
    /**
    * @description: finish method for sending completion mail of matching Location rules 
    * @param: Database.BatchableContext ctx, List<Location> locationToProcessList - locations list to process
    **/  
    global void finish(Database.BatchableContext ctx){
        
        if(allMatchingRulesByLocIdMap != null && !allMatchingRulesByLocIdMap.isEmpty()){
            Set<Id> locnIdSet = allMatchingRulesByLocIdMap.keySet();
            Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Location Oppty Share batch size').Batch_Size__c);
            Id batchId = Database.executeBatch(new TMProcessLocationOpptyShareBatch(locnIdSet),batchSize);    
        }else{
        
            TMBatchHelper.sendEmailNotification(ctx,Label.Location);
            
            TMProcessLocationCleanUpScheduler locCleanUpSc = new TMProcessLocationCleanUpScheduler();
        
            Datetime currentDateTime = Datetime.now();
        
            String min = String.valueOf(math.mod((currentDateTime.minute()+2),60)); 
            String schExp = '0 '+min+' * * * ? ';
            system.schedule('TM-Process Location CleanUp Job'+datetime.now(),schExp,locCleanUpSc);
        }
        
    }
}