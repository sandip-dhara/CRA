//TM Nasir Jawed: R5 CR-0712: 22/04/2013: This batch is querying the Sales territory account assignment and passing
// Opportunity id to the "TMProcessProdLineItemSOMBatch" batch: Start

global class TMProcessProdLineItemSOMBatchCall implements Database.batchable<sObject> ,  Database.Stateful{
    
    public String accountToProcess='select id,sales_Territory__r.New_User_Alert__c,Account__c from Sales_Territory_Account_Assignment__c where sales_Territory__r.New_User_Alert__c=true ';
    global set<Id> oppId= new set<Id>();
    global Datetime currentTime = system.Now();
    global String formatedDt = currentTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    
    global Database.queryLocator start(Database.BatchableContext ctx){ 
        if ( Test.isRunningTest() ) accountToProcess+= ' limit 30';
         system.debug('block1:'+ accountToProcess);
        return Database.getQueryLocator(accountToProcess); 
       
    }
    
    global void execute(Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> stua){
        set<Id> accId= new set<Id>();
        
        
        for(Sales_Territory_Account_Assignment__c accountId: stua){
            if(accountId!=null){
                accId.add(accountId.Account__c);
                system.debug('block2:'+ accId);
            }    
        }   
        for(Opportunity opp:[select id from opportunity where AccountID IN: accId]){
            if(opp!=null){
                oppId.add(opp.id);
                system.debug('block3:'+ oppId);
            }    
        }
        for(Channel_Partner__c cp:[select id,Opportunity__c from Channel_Partner__c where Channel_Partner__c IN:accId]){
            if(cp!=null){
                oppId.add(cp.Opportunity__c);
                system.debug('block4:'+ oppId);
            }
        }
          
    }
    
    
    global void finish(Database.BatchableContext ctx){ 
         Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('ProductLineItemSOMBatch').Batch_Size__c);
         ID batchEvalTerr = Database.executeBatch(new TMProcessProdLineItemSOMBatch(oppId,formatedDt),batchSize );    
    }
}

// TM Nasir Jawed: R5 CR-0712:End