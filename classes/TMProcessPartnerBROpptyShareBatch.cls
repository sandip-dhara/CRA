/*********************************************************************************
* Class Name: TMProcessPartnerBROpptyShareBatch 
* Author: HP
* Date: 21-AUG-2013 
* Requirement:R6 # Request Id: CR -11429
* Description: This is a batch class that performs sharing of Opptys to BRs.
***********************************************************************************/
global class TMProcessPartnerBROpptyShareBatch implements Database.Batchable<sObject>{
    
    global final Set<Id> matchingPartnerAccIdSet;
    
    public TMProcessPartnerBROpptyShareBatch(Set<Id> partnerAccIdSet){
        matchingPartnerAccIdSet = partnerAccIdSet;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String acpToProcessQuery = 'Select Id,Location__c,Opportunity__c,Channel_Partner__c From Channel_Partner__c'+
        ' Where Channel_Partner__c In :matchingPartnerAccIdSet And Opportunity__r.Confidential__c = false And Opportunity__r.Account.Confidential_Account__c = false';
        if(Test.isRunningTest()) acpToProcessQuery +=' limit 30';
        return Database.getQueryLocator(acpToProcessQuery);
    }
    
    global void execute(Database.BatchableContext bc,List<Channel_Partner__c> opptyToProcessList){
        TMPartnerBROpptyShare.createOpptyShare(opptyToProcessList);
    }
    
    global void finish(Database.BatchableContext bc){
        //Mail notification...
        TMBatchHelper.sendEmailNotification(bc, Label.Account_Profile);  
             
        //Schedulable class Instance.
        TMProcessIndustryRulesScheduled industrySchedule = new TMProcessIndustryRulesScheduled();
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule(Label.Industry_Rules_Job+datetime.now(), schExp, industrySchedule);
    }
}