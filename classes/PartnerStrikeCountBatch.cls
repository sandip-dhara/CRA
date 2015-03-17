/**
* Class Name: PartnerStrikeCountBatch
* Author: Accenture
* Date: 18-JULY-2012 
* Description: The batch apex job to handle strike count for partners
*/
global with sharing class PartnerStrikeCountBatch implements Database.Batchable<sObject> {
    
    public string query {get; set;}
    public  integer batchSize;
    
    global PartnerStrikeCountBatch(){
        query = 'Select User_Assignment_Date__c, Two_Day_SLA_Date__c, Thirty_Day_SLA_Date__c, Strike_Increment_Date__c, Queue_Assignment_Date__c, '+ 
                'Previous_Lead_Owner_Id__c, Partner_Contact__c,Partner_Location__c, Partner_Account__c, Owner_Partner_User__c, OwnerId, Opportunity__c, Opportunity_Stage__c, '+ 
                'Opportunity_Last_Modified_by_Partner__c, Lead__c, Lead_Status__c, Lead_Last_Modified_by_Partner__c, Id from Strike_Count_Track__c '+
                ' Where Two_Day_SLA_Date__c <= ' + PartnerCollabUtil.getStringFromDate(system.today()) + ' or Thirty_Day_SLA_Date__c = ' + PartnerCollabUtil.getStringFromDate(system.today()) + ' or Thirty_Day_SLA_Date__c = ' + PartnerCollabUtil.getStringFromDate(system.today().addDays(5));
        
        if(test.isRunningTest()== true){
           query=query+' Limit 199';
           batchSize=199;
        }else{
           query=query;
           batchSize=200;
        }   
    }
    
    /**
    * @description: Start method of the batch class
    * @param: context instance
    * 
    */
    global Database.QueryLocator start(Database.BatchableContext BC){
        PartnerCollabUtil.strkCntBatchRunning = true;
        PartnerCollabUtil.strCntsToDelete = new List<Strike_Count_Track__c>();
        //PartnerCollabUtil.allEmailTemplates = Partner_Collaboration_Email_Templates__c.getAll();        
        return Database.getQueryLocator(query);
    }
    
    /**
    * @description: execute method of the batch class
    * @param: context instance & the scope of the current batch execution
    * 
    */
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Strike_Count_Track__c> allStrikeCountTracks = new List<Strike_Count_Track__c>();
        List<Strike_Count_Track__c> twoDaySLATracks = new List<Strike_Count_Track__c>();
        List<Strike_Count_Track__c> thirtyDaySLATracks = new List<Strike_Count_Track__c>();
        List<Strike_Count_Track__c> proactiveNotificationTracks = new List<Strike_Count_Track__c>();
        
        //PartnerCollabUtil.partnerLocationIdsToStrike = new List<Id>();
        //PartnerCollabUtil.partnerUserIdsToStrike = new List<Id>();
        //PartnerCollabUtil.updateStrikeDate = new List<Strike_Count_Track__c>();
        
        if(scope == null || scope.size() == 0){
            return;
        }
        allStrikeCountTracks = (List<Strike_Count_Track__c>) scope;
        
        /**
         * handling following 3 cases differently
         * 1. The 2-day SLA breach for lead
         * 2. The 30-day SLA breach for lead or opportunity
         * 3. The proactive notification on 25th day for Lead & Opportunity 
         */
        for(Strike_Count_Track__c strkCnt : allStrikeCountTracks){
            if(strkCnt.Two_Day_SLA_Date__c == system.today()){
                twoDaySLATracks.add(strkCnt);
            }
            /*else if(strkCnt.Thirty_Day_SLA_Date__c == system.today()){
                thirtyDaySLATracks.add(strkCnt);
            }else if(strkCnt.Thirty_Day_SLA_Date__c == system.today().addDays(5)){
                proactiveNotificationTracks.add(strkCnt);
            }*/
        }
        
        if(twoDaySLATracks != null && twoDaySLATracks.size()>0){
            PartnerCollabUtil.handleTwoDaySLAs(twoDaySLATracks);
        }
        /*if(thirtyDaySLATracks != null && thirtyDaySLATracks.size()>0){
            PartnerCollabUtil.handleThirtyDaySLAs(thirtyDaySLATracks);
        }
        if(proactiveNotificationTracks != null && proactiveNotificationTracks.size()>0){
            PartnerCollabUtil.handleProactiveNotifications(proactiveNotificationTracks);
        }*/
        
        /**
         * Increment strike count on partne user & account
         * Update strike date on Tracking object
         */
        /*if(PartnerCollabUtil.partnerLocationIdsToStrike.size()>0){
            PartnerCollabUtil.incrementPartnerLocationStrike();
        }
        if(PartnerCollabUtil.partnerUserIdsToStrike.size()>0){
            PartnerCollabUtil.incrementPartnerUserStrike();
        }
        if(PartnerCollabUtil.updateStrikeDate.size()>0){
            PartnerCollabUtil.updateStrikeIncrementDate();
        }
        
        PartnerCollabUtil.sendNotifications();*/
    }
    
    /**
    * @description: finish method of the batch class
    * @param: context instance
    * 
    */
    global void finish(Database.BatchableContext BC){
        PartnerCollabUtil.deleteStrkRecords();
    }
}