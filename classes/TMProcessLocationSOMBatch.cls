/**********************************************************
* Class Name: TMProcessLocationSOMBatch 
* Author: Raghvendra Jha
* Date: 19-JUL-20123
* Requirement # Req Id:10320 
* Description: This is a batch class that performs processing of sales territory location assignment against SOM.
***********************************************************/

global class TMProcessLocationSOMBatch implements Database.batchable<sObject> ,  Database.Stateful{
    
    public String locToProcess='select id,Location__c from Sales_Territory_Location_Assignment__c where sales_Territory__r.New_User_Alert__c=true';
    global set<Id> oppId= new set<Id>();
    global string stDatetime;
    
    public TMProcessLocationSOMBatch(String datetime2){
        stDatetime= datetime2;  
    }
    
    global Database.queryLocator start(Database.BatchableContext ctx){ 
        if ( Test.isRunningTest() ) locToProcess+= ' limit 30';
         system.debug('block1:'+ locToProcess);
        return Database.getQueryLocator(locToProcess); 
       
    }
    
    global void execute(Database.BatchableContext ctx, List<Sales_Territory_Location_Assignment__c> stlaList){
        set<Id> locIdSet= new set<Id>();
        for(Sales_Territory_Location_Assignment__c locId: stlaList){
            if(locId!=null){
                locIdSet.add(locId.Location__c);
            }    
        }
        for(Channel_Partner__c cp:[select id,Opportunity__c from Channel_Partner__c where Location__c IN:locIdSet]){
            if(cp!=null){
                oppId.add(cp.Opportunity__c);
            }
        }
    
    }
    
    global void finish(Database.BatchableContext ctx){ 
        
         Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProductLineItemSOMBatch').Batch_Size__c);
         ID batchEvalTerr = Database.executeBatch(new TMProcessLocSOMCrtBatch (oppId,stDatetime),batchSize );   
    }
}