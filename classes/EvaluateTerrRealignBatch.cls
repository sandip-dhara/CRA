/**********************************************************
* Class Name: EvaluateTerrRealignBatch
* Author: HP - (Req:2089)
* Description: This batch resets flags on Objects. We need to pass the query string and the field which need to be reset.
* Irrespective of the Object the field for that object will get reset to false.
*/

global class EvaluateTerrRealignBatch implements Database.batchable<sObject> , Database.Stateful {

    global string TerrListvalues;
    //TM:Debmalya:CR:3737:Creating a Generic Batch:Start
    global String queryStr;
    global String paramStr;
    
    global EvaluateTerrRealignBatch(String QueryString,String Parameter){
        queryStr = QueryString;
        paramStr = Parameter;
    }
    //TM:Debmalya:CR:3737:Creating a Generic Batch:End
   
    global  Database.queryLocator start(Database.BatchableContext ctx){
    //TerrListvalues = 'select id,EvaluateTerritory_for_Realignment__c  from Sales_Territory__c where EvaluateTerritory_for_Realignment__c = true';
    if ( Test.isRunningTest() ) queryStr += ' limit 30';
    system.debug('test:'+ queryStr);
    return Database.getQueryLocator(queryStr);
    
    }
    
    global void execute(Database.BatchableContext ctx, List<SObject> TerrList){
    //TM:Sreenath 5909 02-May-2013 starts
    if(paramStr == 'delete'){
    Delete TerrList;
    }       
    else{
    //TM:Sreenath 5909 02-May-2013 ends
    //TM:Debmalya:Cr3737:Creating a Generic Batch:Start
        for(SObject terr : TerrList){
            terr.put(paramStr,false);
        }
        update TerrList;
    //TM:Debmalya:Cr3737:Creating a Generic Batch:End
    }
    }
    global void finish(Database.BatchableContext ctx){
        if(paramStr == 'New_Or_Updated__c'){
            TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues('CreateRemAcctTeam');
            obj.SchedularFlag__c = false;
            update obj;
        } 
    }

}