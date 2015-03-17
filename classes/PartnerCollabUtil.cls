/**
* Class Name: PartnerCollabUtil
* Author: Accenture
* Date: 18-JULY-2012 
* Description: Contains helper methods for partner collaboration triggers, classes, batch class
*/
public with sharing class PartnerCollabUtil {
    public static boolean loggedInPartner = false;
    public static boolean strkCntBatchRunning = false;
    public static List<Strike_Count_Track__c> strCntsToDelete = new List<Strike_Count_Track__c>();
    /*public static List<Id> partnerLocationIdsToStrike = new List<Id>();
    public static List<Id> partnerUserIdsToStrike = new List<Id>();
    public static List<Strike_Count_Track__c> updateStrikeDate = new List<Strike_Count_Track__c>();
    public static Map<String,Partner_Collaboration_Email_Templates__c> allEmailTemplates = new Map<String,Partner_Collaboration_Email_Templates__c>();
    public static List<String> emailTemplateNames = new List<String>{'Two_day_lead_update_failure_notification', 'Stale_Lead_notification', 
                                                        'Opportunity_update_reminder'};
    public static Map<String,Map<Id, Id>> allEmailsToSend = new Map<String,Map<Id, Id>>(); // map of email-template-name, Sobject Id & recepient
    public static Set<Id> emailRecipientUserIds = new Set<Id>();*/
    public static Map<Id,RecordType> allRecordTypes = new Map<Id,RecordType>([Select SobjectType, Name, Id From RecordType]);
    
    /**
    * @description: Check whether currently logged-in user is partner user 
    */  
    public static boolean isLoggedInPartnerUser(){
        Id LoggedInUserId = UserInfo.getUserId(); 
        String LoggedInUserType = UserInfo.getUserType();       
        if(LoggedInUserType.toLowerCase().contains('partner')){
            loggedInPartner = true;
        }
        return loggedInPartner;
    }
    
    // Replaced the use of below method with "RecordTypeIdHelper.getRecordTypeName" method 
    // in all the referenced classes to avoid the use of query in 'allRecordTypes' map variable
    /**
    * @description: Check whether currently logged-in user is partner user 
    *   
    public static String getRecordTypeName(Id getRecordTypeId){
        return allRecordTypes.get(getRecordTypeId).Name;
    }*/
    
    /**
    * @description: Check whether currently logged-in internal user has permissions to handle partner users / queues 
    */  
    public static boolean participatingInPartnerHandling(){
        Id LoggedInUserId = UserInfo.getUserId(); 
        map<id, user> userMap = new map<id, user>([SELECT Id, UserType, Partner_Collaboration_Participating_User__c, IsActive FROM user WHERE Id = :LoggedInUserId]);
        if(userMap.get(LoggedInUserId).Partner_Collaboration_Participating_User__c){
            return true;
        }else{
            return false;
        }       
    }
    
    /**
    * @description: Handle 2-day SLA breach for lead
    * @param: list of tracking records corresponding to 2-day SLA breached leads
    * 
    */
    public static void handleTwoDaySLAs(List<Strike_Count_Track__c> twoDaySLATracks){
        List<Strike_Count_Track__c> queueOwnedLeadTracks = new List<Strike_Count_Track__c>();
        List<Strike_Count_Track__c> userOwnedLeadTracks = new List<Strike_Count_Track__c>();
        
        for(Strike_Count_Track__c strCnt : twoDaySLATracks){
            if(strCnt.Lead__c != null && strCnt.Queue_Assignment_Date__c != null){
                queueOwnedLeadTracks.add(strCnt);
            }
            //else if(strCnt.Lead__c != null && strCnt.Owner_Partner_User__c != null){
               // userOwnedLeadTracks.add(strCnt);
            //}
        }
        
        //system.debug('>>queueOwnedLeadTracks>>'+queueOwnedLeadTracks);
        
        if(queueOwnedLeadTracks != null && queueOwnedLeadTracks.size()>0){
            handleQueueOwnedLeadTracks(queueOwnedLeadTracks);
        }
        
        //system.debug('>>userOwnedLeadTracks>>'+userOwnedLeadTracks);
        
        //if(userOwnedLeadTracks != null && userOwnedLeadTracks.size()>0){
            //handlUserOwnedLeadTracks(userOwnedLeadTracks);
        //}
    }   
    
    /**
    * @description: Reassign back to previous owner for leads assigned to partner queues and breached 2-day SLA
    * @param: list of tracking records corresponding to 2-day SLA breached leads assigned to partner queues
    * 
    */
    public static void handleQueueOwnedLeadTracks(List<Strike_Count_Track__c> queueOwnedLeadTracks){
        Set<Id> queueOwnedLeadIds = new Set<Id>();
        Map<Id,Lead> queueOwnedLeads = new Map<Id,Lead>();
        List<Lead> strCntLeadsUpdate = new List<Lead>();    
        
        for(Strike_Count_Track__c strCnt: queueOwnedLeadTracks){
            if(strCnt.Lead__c != null && String.valueOf(strCnt.Lead__c) != ''){
                queueOwnedLeadIds.add(strCnt.Lead__c);
            }
        }
        queueOwnedLeads = new Map<Id,Lead>([Select Id,OwnerId From Lead where Id in: queueOwnedLeadIds]);
        
        for(Strike_Count_Track__c strCnt: queueOwnedLeadTracks){
            if(strCnt.Previous_Lead_Owner_Id__c != null && String.valueOf(strCnt.Previous_Lead_Owner_Id__c)!= ''){
                Lead leadToUpdate = queueOwnedLeads.get(strCnt.Lead__c);
                leadToUpdate.OwnerId = strCnt.Previous_Lead_Owner_Id__c ;
                leadToUpdate.Last_Modified_by_Partner__c = null;
                strCntLeadsUpdate.add(leadToUpdate);
                
                strCntsToDelete.add(strCnt);
            }
        }
        
        //system.debug('>>queueOwnedLeadTracks22>>'+queueOwnedLeadTracks);
        //system.debug('>>strCntLeadsUpdate>>'+strCntLeadsUpdate);
        
        Database.SaveResult[] leadUpdateResults = database.update(strCntLeadsUpdate,false);             
    }
    
    /**
    * @description: Increment strike for leads assigned to partner users and breached 2-day SLA
    * @param: list of tracking records corresponding to 2-day SLA breached leads assigned to partner users
    * 
    */
    /*public static void handlUserOwnedLeadTracks(List<Strike_Count_Track__c> userOwnedLeadTracks){
        Map<Id, Id> twoDayNotifications = new Map<Id, Id>();
        
        for(Strike_Count_Track__c strCnt: userOwnedLeadTracks){
            system.debug('>>inside loop strCnt33 >>'+strCnt);
            if(strCnt.Owner_Partner_User__c != null && String.valueOf(strCnt.Owner_Partner_User__c) != ''){
                partnerUserIdsToStrike.add(strCnt.Owner_Partner_User__c);
                system.debug('>>partnerUserIdsToStrike >>'+partnerUserIdsToStrike);
            }
            if(strCnt.Partner_Location__c != null && String.valueOf(strCnt.Partner_Location__c) != ''){
                partnerLocationIdsToStrike.add(strCnt.Partner_Location__c);
            }
            
            strCnt.Strike_Increment_Date__c = system.today();
            system.debug('>>strCnt33 >>'+strCnt);
            updateStrikeDate.add(strCnt);
            system.debug('>>strCnt.Lead__c >>'+strCnt.Lead__c);
            system.debug('>>strCnt.Owner_Partner_User__c >>'+strCnt.Owner_Partner_User__c);
            twoDayNotifications.put(strCnt.Lead__c , strCnt.Owner_Partner_User__c);
            system.debug('>>twoDayNotifications >>'+twoDayNotifications);
            system.debug('>>strCnt.Owner_Partner_User__c >>'+strCnt.Owner_Partner_User__c);
            emailRecipientUserIds.add(strCnt.Owner_Partner_User__c);
            system.debug('>>emailRecipientUserIds666666 >>'+emailRecipientUserIds);
        }
        
        system.debug('>>twoDayNotifications>>'+twoDayNotifications);
        
        allEmailsToSend.put(emailTemplateNames[0],twoDayNotifications); 
        
    }*/
    
    /**
    * @description: Increment strike for leads / opportunities assigned to partner users and breached 30-day SLA
    * @param: list of tracking records corresponding to 30-day SLA breached leads / opportunities assigned to partner users
    * 
    */
    /*public static void handleThirtyDaySLAs(List<Strike_Count_Track__c> thirtyDaySLATracks){
        
        for(Strike_Count_Track__c strCnt: thirtyDaySLATracks){
            if(strCnt.Owner_Partner_User__c != null && String.valueOf(strCnt.Owner_Partner_User__c) != ''){
                partnerUserIdsToStrike.add(strCnt.Owner_Partner_User__c);
            }
            if(strCnt.Partner_Location__c != null && String.valueOf(strCnt.Partner_Location__c) != ''){
                partnerLocationIdsToStrike.add(strCnt.Partner_Location__c);
            }
            
            strCnt.Strike_Increment_Date__c = system.today();
            updateStrikeDate.add(strCnt);
        }
        
        //system.debug('>>updateStrikeDate444>>'+updateStrikeDate);
        
    }*/
    
    /**
    * @description: Perform DML operation to increment strike count on partner location for leads / opportunities breached 2-day or 30-day SLA 
    */
    /*public static void incrementPartnerLocationStrike (){
        List<Location__c> partnerLocationsToStrike = new List<Location__c>();
        List<Location__c> toUpdateLocationToStrikeList = new List<Location__c>();
        partnerLocationsToStrike = [Select Id, Demerit_Count__c from Location__c where Id in: partnerLocationIdsToStrike];
        system.debug('a1a'+partnerLocationsToStrike.size());
        system.debug('a1b'+partnerLocationIdsToStrike.size());
        system.debug('a1c'+partnerLocationsToStrike);
        system.debug('a1d'+partnerLocationIdsToStrike);
            if(partnerLocationsToStrike.size()>0 && partnerLocationsToStrike.size()>0){
            for(Location__c partnerLoc : partnerLocationsToStrike){
                for(Id partnerLocationIdsToStrikeVar:partnerLocationIdsToStrike){
                    if(partnerLocationIdsToStrikeVar == partnerLoc.Id){
                        if(partnerLoc.Demerit_Count__c != null && String.valueOf(partnerLoc.Demerit_Count__c) != ''){
                            partnerLoc.Demerit_Count__c = partnerLoc.Demerit_Count__c + 1;
                        }else{
                            partnerLoc.Demerit_Count__c = 1;
                        }  
                    }
                }
                toUpdateLocationToStrikeList.add(partnerLoc);
            }
        } 
        system.debug('>>updateStrikeDate444>>'+toUpdateLocationToStrikeList);
        
        Database.SaveResult[] accUpdateResults = database.update(toUpdateLocationToStrikeList,false);              
    }*/
    
    /**
    * @description: Perform DML operation to increment strike count on partner users for leads / opportunities breached 2-day or 30-day SLA 
    */
    /*public static void incrementPartnerUserStrike(){        
        List<User> partnerUsersToStrike = new List<User>();
        List<User> toUpdatePartnerUsersToStrikeList = new List<User>();
        partnerUsersToStrike = [Select Id, Strike_Count__c from User where Id in: partnerUserIdsToStrike];
        
        if(partnerUsersToStrike.size()>0 && partnerUserIdsToStrike.size()>0){
            for(User partnerUsr : partnerUsersToStrike){
                for(Id partnerUserIdsToStrikeVar:partnerUserIdsToStrike){
                    if(partnerUserIdsToStrikeVar == partnerUsr.Id){
                        if(partnerUsr.Strike_Count__c != null && String.valueOf(partnerUsr.Strike_Count__c) != ''){
                            partnerUsr.Strike_Count__c = partnerUsr.Strike_Count__c + 1;
                        }else{
                            partnerUsr.Strike_Count__c = 1;
                        }
                    }
                }
                toUpdatePartnerUsersToStrikeList.add(partnerUsr);
            }
        }   
        system.debug('>>partnerUsersToStrike>>'+toUpdatePartnerUsersToStrikeList);
        
        Database.SaveResult[] userUpdateResults = database.update(toUpdatePartnerUsersToStrikeList,false);              
    }*/
    
    /**
    * @description: Perform DML operation to update strike increment date on tracking object for leads / opportunities breached 2-day or 30-day SLA 
    */
    /*public static void updateStrikeIncrementDate (){
        for(Strike_Count_Track__c strkDateTrack : updateStrikeDate){
            strkDateTrack.Strike_Increment_Date__c = system.today();
        }
        
        system.debug('>>updateStrikeDate>>'+updateStrikeDate);
        
        Database.SaveResult[] strkUpdateResults = database.update(updateStrikeDate,false);              
    }*/
    
    public static void deleteStrkRecords (){
        List<Strike_Count_Track__c> deleteStrikes = new List<Strike_Count_Track__c>();
        system.debug('>>strCntsToDelete111111>>'+strCntsToDelete);
        if(strCntsToDelete != null && strCntsToDelete.size()>0 && strCntsToDelete.size()< 10000){
            system.debug('>>strCntsToDelete>>'+strCntsToDelete);
            Database.DeleteResult[] userUpdateResults = database.delete(strCntsToDelete,false);           
        }else if(strCntsToDelete.size()>10000){
            for(integer i=0; i < 10000; i++){
                deleteStrikes.add(strCntsToDelete[i]);
            }
            Database.DeleteResult[] userUpdateResults = database.delete(deleteStrikes,false);           
        }             
    }
    
    /*public static void handleProactiveNotifications(List<Strike_Count_Track__c> proactiveNotificationTracks){
        Map<Id, Id> leadNotifications = new Map<ID, Id>();
        Map<Id, Id> opptyNotifications = new Map<ID, Id>(); 
        for(Strike_Count_Track__c proStrkDateTrack : proactiveNotificationTracks){                  
            if(proStrkDateTrack.Lead__c != null && String.valueOf(proStrkDateTrack.Lead__c) != ''){
                leadNotifications.put(proStrkDateTrack.Lead__c , proStrkDateTrack.Owner_Partner_User__c);               
            }else if(proStrkDateTrack.Opportunity__c != null && String.valueOf(proStrkDateTrack.Opportunity__c) != ''){
                leadNotifications.put(proStrkDateTrack.Opportunity__c , proStrkDateTrack.Owner_Partner_User__c);                
            }
            emailRecipientUserIds.add(proStrkDateTrack.Owner_Partner_User__c);
        }
        
        //system.debug('>>leadNotifications>>'+leadNotifications);
        //system.debug('>>opptyNotifications>>'+opptyNotifications);
        
        allEmailsToSend.put(emailTemplateNames[1],leadNotifications);   
        allEmailsToSend.put(emailTemplateNames[2],opptyNotifications);  
    }
    
    public static void sendNotifications(){
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
       //Map<Id, User> recepientUsers = new Map<Id, User>([select Id, Email from User where Id in: emailRecipientUserIds]);
        Map<Id, EmailTemplate> stikeEmailTemplates = new Map<Id, EmailTemplate>([Select Id, DeveloperName From EmailTemplate where DeveloperName in: emailTemplateNames]);
        system.debug('a1f'+stikeEmailTemplates);
        for(String emailType : emailTemplateNames){         
            for(EmailTemplate emailTemp : stikeEmailTemplates.values()){
                if(emailType.equalsIgnoreCase(emailTemp.DeveloperName)&&allEmailsToSend.containsKey(emailType)){
                    Map<Id, Id> recordIdWithOwner = allEmailsToSend.get(emailType);
                    system.debug('a1e'+recordIdWithOwner);
                    if(recordIdWithOwner.size()>0){
                        for(Id recId : recordIdWithOwner.keySet()){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setTargetObjectId(recId);
                            mail.setOrgWideEmailAddressId (Label.OrgWideEmailAddressId);  
                           // mail.setToAddresses(new List<String> {recepientUsers.get(recordIdWithOwner.get(recId)).Email});
                            mail.setTemplateId(emailTemp.Id);
                            emailMessages.add(mail);
                            system.debug('>>>>>mail<<<<<<'+mail);
                        }                       
                    }
                }
            }
        }       
        
        if(emailMessages != null && emailMessages.size()>0){
            Messaging.sendEmail(emailMessages);     
        }
    }*/
    
     /**
     * Get String from Datetime which can be used in the where clause of the query
     */
     public static string getStringFromDate(Date dt){
      String queryClause = '';
      String dtStr = dt+'';
      List<String> dateParts = dtStr.split(' ');
      queryClause = dateParts[0];    
      return queryClause;     
     }
    
}