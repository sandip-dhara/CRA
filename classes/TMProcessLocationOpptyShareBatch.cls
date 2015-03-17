/*********************************************************************************
* Class Name: TMProcessLocationOpptyShareBatch 
* Author: HP
* Date: 29-JUL-2013 
* Requirement # Request Id:R5 EF02:CR-10319
* Description: This is a batch class that performs sharing of Opptys to Locations.
***********************************************************************************/
global class TMProcessLocationOpptyShareBatch implements Database.Batchable<sObject>{

    global final Set<Id> matchingLocnIdSet;
    
    public TMProcessLocationOpptyShareBatch(Set<Id> locnIdSet){
        matchingLocnIdSet = locnIdSet;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        //TM:Vinay R6:Req 7525:Start
        //Filter Private Customer Account Opptys/Confidential Opptys
        String acpToProcessQuery = 'Select Id,Location__c,Opportunity__c,Channel_Partner__c From Channel_Partner__c'+
        ' Where Location__c In :matchingLocnIdSet And Opportunity__r.Confidential__c = false And Opportunity__r.Account.Confidential_Account__c = false';
        //TM:Vinay R6:Req 7525:End
        if ( Test.isRunningTest() ) acpToProcessQuery += ' limit 30';
        return Database.getQueryLocator(acpToProcessQuery);
    }
    
    global void execute(Database.BatchableContext bc,List<Channel_Partner__c> opptyToProcessList){
        TMLocationOpptyShare.createOpptyShare(opptyToProcessList);    
    }
    
    global void finish(Database.BatchableContext bc){
    
        TMBatchHelper.sendEmailNotification(bc,Label.Location);
        
        TMProcessLocationCleanUpScheduler locCleanUpSc = new TMProcessLocationCleanUpScheduler();
        
        Datetime currentDateTime = Datetime.now();
        
        String min = String.valueOf(math.mod((currentDateTime.minute()+2),60)); 
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM-Process Location CleanUp Job'+datetime.now(),schExp,locCleanUpSc);
    }
}