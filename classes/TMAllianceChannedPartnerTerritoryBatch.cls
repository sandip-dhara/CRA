/******************************************************************************************************************
* Class Name: TMAllianceChannedPartnerTerritoryBatch 
* Author: HP
* Description: This is a batch class that performs opportunity share for territories based on location added as ACP
*******************************************************************************************************************/
global class TMAllianceChannedPartnerTerritoryBatch implements Database.batchable<sObject> ,  Database.Stateful{

public String partnerLocationQuery;
    /**
    * @description: Queries  Sales Territory Location Assignments to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/    
global Database.queryLocator start(Database.BatchableContext ctx){
    TMEngineAccountRecordType__c lastRun = TMEngineAccountRecordType__c.getValues('Allianc/ChanPartTimeStamp');
    
    if(lastRun.AccountRecordType__c != null){
        DateTime stDate = DateTime.valueOf(lastRun.AccountRecordType__c);
        partnerLocationQuery = 'Select Id,IsDeleted,Sales_Territory__r.IsPartner__c,Sales_Territory__r.GroupID__c,Location__c From Sales_Territory_Location_Assignment__c Where Sales_Territory__r.IsPartner__c = true And Sales_Territory__r.IsExternal__c = false And (createddate >= :stDate OR (IsDeleted = true and LastModifiedDate >= :stDate)) ALL ROWS';
        DateTime newTimeStamp = datetime.now();
        lastRun.AccountRecordType__c = String.valueOf(newTimeStamp);
        update lastRun;
    }else{
        partnerLocationQuery = 'Select Id,IsDeleted,Sales_Territory__r.IsPartner__c,Sales_Territory__r.GroupID__c,Location__c From Sales_Territory_Location_Assignment__c Where Sales_Territory__r.IsPartner__c = true And Sales_Territory__r.IsExternal__c = false ALL ROWS';
        DateTime newTimeStamp = datetime.now();
        lastRun.AccountRecordType__c = String.valueOf(newTimeStamp);
        update lastRun;
    }
    if ( Test.isRunningTest() ){             
                 partnerLocationQuery = partnerLocationQuery.substring(0,partnerLocationQuery.length()- 9);
                 partnerLocationQuery += ' Limit 2 ALL ROWS';           
        }
    return Database.getQueryLocator(partnerLocationQuery);
}
    /**
    * @description: Execute method for adding or removing opportunity shares based on location
    * @param: Database.BatchableContext ctx, List<Sales_Territory_Location_Assignment__c> channelPartnerLocationList - location list to process
    * @return: void
    **/
global void execute(Database.BatchableContext ctx,List<Sales_Territory_Location_Assignment__c> channelPartnerLocationList){
    Map<Id,Channel_Partner__c> channelPartnerMap = new Map<Id,Channel_Partner__c>();
    Set<Id> locationIdSet = new Set<Id>();
    Map<Id,Set<String>> locGroupIdMap = new Map<Id,Set<String>>();
    Map<Id,Set<String>> oppGroupIdMap = new Map<Id,Set<String>>();
    Set<Id> locationIdDelSet = new Set<Id>();
    
    for(Sales_Territory_Location_Assignment__c stla: channelPartnerLocationList){
        if(stla.IsDeleted == false){
            locationIdSet.add(stla.location__c);
        }else {
            locationIdDelSet.add(stla.location__c);
            if(!locGroupIdMap.containsKey(stla.location__c)){
                Set<String> relGrpIdSet = new Set<String>();
                relGrpIdSet.add(stla.Sales_Territory__r.GroupID__c);
                locGroupIdMap.put(stla.location__c,relGrpIdSet);
            }else{
                locGroupIdMap.get(stla.location__c).add(stla.Sales_Territory__r.GroupID__c);
            }
        }
    }
    
    if(locationIdSet != null){
        for(Channel_Partner__c channelPrtRec: [Select id,Channel_Partner__c,Location__c,Opportunity__c from Channel_Partner__c where Location__c IN: locationIdSet]){
            channelPartnerMap.put(channelPrtRec.id,channelPrtRec);
        }
    }
    if(locationIdDelSet != null){
        for(Channel_Partner__c channelPrtRec: [Select id,Channel_Partner__c,Location__c,Opportunity__c from Channel_Partner__c where Location__c IN: locationIdDelSet]){
            if(!oppGroupIdMap.containsKey(channelPrtRec.Opportunity__c)){
                Set<String> relGrpIdSet = new Set<String>();
                relGrpIdSet.addAll(locGroupIdMap.get(channelPrtRec.Location__c));
                oppGroupIdMap.put(channelPrtRec.Opportunity__c,relGrpIdSet);
            }else{
                oppGroupIdMap.get(channelPrtRec.Opportunity__c).addAll(locGroupIdMap.get(channelPrtRec.Location__c));
            }
        }
    }
    //TM:R5 EF02:CR-10319 Vinay:Flag to Set when batch is run
    PartnerCollabACPUtil.setExeFromBatchFlag();
    
    if(channelPartnerMap != null && channelPartnerMap.size() > 0){
        PartnerCollabACPUtil.addOpptyShareToPartners(channelPartnerMap);
    }
    if(oppGroupIdMap != null && oppGroupIdMap.size() > 0){
        PartnerCollabACPUtil.removeOpptyShareToPartnersincremental(oppGroupIdMap);
    }
    
}
    /**
    * @description: finish method for sending completion mail of TMAllianceChannelPartner batch
    * @param: Database.BatchableContext ctx
    * @return: void
    **/    
global void finish(Database.BatchableContext ctx){
          if (ctx != null) {
            AsyncApexJob apexJob = [SELECT id, ApexClassId,   
                                       JobItemsProcessed, TotalJobItems,   
                                       NumberOfErrors, CreatedBy.Email   
                                    FROM AsyncApexJob   
                                    WHERE id = :ctx.getJobId()];  
            
            String emailMessage = 'Your APEX Batch Job for TMAllianceChannedPartnerTerritoryBatch has been completed ';  
            Messaging.SingleEmailMessage mail =   
                  new Messaging.SingleEmailMessage();  
            String[] toAddresses = new String[] {apexJob.CreatedBy.Email};
            mail.setToAddresses(toAddresses);  
            mail.setReplyTo('noreply@salesforce.com');  
            mail.setSenderDisplayName(Label.SenderDisplayName);  
            mail.setSubject(Label.Subject);  
            mail.setPlainTextBody(emailMessage);  
            mail.setHtmlBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]  
                              { mail });
        }
    
    }

}