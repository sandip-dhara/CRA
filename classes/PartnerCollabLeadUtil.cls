/**
    * Class Name: PartnerCollabLeadUtil
    * Author: Accenture
    * Date: 13-JULY-2012 
    * Description: Contains support action methods for trigger on lead object for partner collaboration
    */
    public class PartnerCollabLeadUtil {
        /**
        * @description - This method will be called from lead trigger for before-update event. To pickup leads with ownership change
        * @param: new & old maps of updates leads
        */
        public static void leadUpdate(map<id, lead> newLeadMap, map<id, lead> oldLeadMap){      
            set<Id> updatedLeadIds = new set<Id>();
            set<Id> ownerIds = new set<Id>();
            
            if(!PartnerCollabUtil.strkCntBatchRunning){
                PartnerCollabLeadUtil.closedLeadsHandler(newLeadMap, oldLeadMap);
            }
            
            for(Id leadId: newLeadMap.keySet()){
                if((oldLeadMap.get(leadId).OwnerId != newLeadMap.get(leadId).OwnerId) && (newLeadMap.get(leadId).Status != 'Closed') && (newLeadMap.get(leadId).Status != 'Nurturing')){
                    updatedLeadIds.add(leadId);
                    ownerIds.add(oldLeadMap.get(leadId).OwnerId);
                    ownerIds.add(newLeadMap.get(leadId).OwnerId);
                }
            }
            if(updatedLeadIds.size()>0){
                PartnerCollabLeadUtil.partnerLeadProcess(updatedLeadIds, ownerIds, oldLeadMap, newLeadMap);
            }
        }
        
        /**
        * @description - This method will be called from leadUpdate method. To pickup leads with ownership change and Insert the sharing for ISR
        */
        
        public static void insertSharingForISR(Map<id, lead> newLeadMap,Map<id, lead> oldLeadMap){
            List<LeadShare> listinsertLeadShare = new List<LeadShare>();
            for(Id leadId : newLeadMap.keyset()){
                if(newLeadMap.get(leadId).Assigning_by_ISR__c != null){
                    LeadShare objLeadShare = new LeadShare();
                    objLeadShare.LeadAccessLevel = 'Read';
                    objLeadShare.LeadId = leadId;
                    objLeadShare.UserOrGroupId = newLeadMap.get(leadId).Assigning_by_ISR__c;
                    listinsertLeadShare.add(objLeadShare);
                }
            }
            if(!listinsertLeadShare.isEmpty()){
                Database.SaveResult[] leadShareSaveResult = Database.Insert(listinsertLeadShare, false);
            }
        }
        
        
        /**
        * @description - To process leads with ownership change involving partners for strike count mechanism
        * @param: set of leads to be processed & new, old maps of updates leads
        */
        public static void partnerLeadProcess (set<Id> updatedLeadIds, set<Id> ownerIds, map<id, lead> oldLeadMap, map<id, lead> newLeadMap){
            String partnerType = 'partner';
            Map<Id, user> leadOwnerUsers = new Map<Id, user>();
            Map<Id, Group> leadOwnerQueues = new Map<Id, Group>();
            set<Id> queueOwnedLeads = new set<Id>();
            set<Id> partneUserOwnedLeads = new set<Id>();
            set<Id> deleteStrkCntForLeads = new set<Id>();
            List<Strike_Count_Track__c> strikeCountTracks = new List<Strike_Count_Track__c>();          
            Boolean oldOwnerIsPartnerUser = false;
            Boolean newOwnerIsPartnerUser = false;
            Boolean oldOwnerIsPartnerQueue = false;
            Boolean newOwnerIsPartnerQueue = false;
            
            leadOwnerUsers = new Map<Id, user>([Select Id, LanguageLocaleKey, UserType, ContactId, AccountId, Location_Record_Id__c, Partner_Portal_Eligible__c from User where Id IN: ownerIds]);
            leadOwnerQueues = new Map<Id, Group>([Select Type, Name, Id, Email, DeveloperName From Group where Id IN:ownerIds and Type = 'Queue']);
            
            for(Id leadId: updatedLeadIds){         
                oldOwnerIsPartnerUser = false;
                newOwnerIsPartnerUser = false;
                oldOwnerIsPartnerQueue = false;
                newOwnerIsPartnerQueue = false;
                
                if(leadOwnerUsers.keySet().contains(oldLeadMap.get(leadId).ownerId)){
                    oldOwnerIsPartnerUser = string.valueof(leadOwnerUsers.get(oldLeadMap.get(leadId).ownerId).UserType).toLowerCase().contains(partnerType);
                }
                if(leadOwnerUsers.keySet().contains(newLeadMap.get(leadId).ownerId)){
                    newOwnerIsPartnerUser = string.valueof(leadOwnerUsers.get(newLeadMap.get(leadId).ownerId).UserType).toLowerCase().contains(partnerType);
                }
                if(leadOwnerQueues.keySet().contains(oldLeadMap.get(leadId).ownerId)){
                    oldOwnerIsPartnerQueue = String.valueOf(leadOwnerQueues.get(oldLeadMap.get(leadId).ownerId).DeveloperName).startsWith('Partner_Queue_');
                }
                if(leadOwnerQueues.keySet().contains(newLeadMap.get(leadId).ownerId)){
                    newOwnerIsPartnerQueue = String.valueOf(leadOwnerQueues.get(newLeadMap.get(leadId).ownerId).DeveloperName).startsWith('Partner_Queue_');
                }
                
                
                // throw error if the currently loggedin HP internal user is not participating in partner collab management
                if( (newOwnerIsPartnerUser || newOwnerIsPartnerQueue) && (!PartnerCollabUtil.isLoggedInPartnerUser()) && (!PartnerCollabUtil.participatingInPartnerHandling())){
                    newLeadMap.get(leadId).addError(Label.HP_User_not_participating_in_partner_collaboration);
                }else if( (newOwnerIsPartnerUser || newOwnerIsPartnerQueue) && 
                            (!RecordTypeIdHelper.getRecordTypeName('Lead',newLeadMap.get(leadId).RecordTypeId).equalsIgnoreCase('Qualified Lead')) ){
                    // throw error to show that only qualified (recordtype = qualified) leads can be assigned to partners
                    newLeadMap.get(leadId).addError(Label.Unqualified_leads_cannot_be_assigned_to_partners);
                }else if(newOwnerIsPartnerUser && (Integer.valueOf(leadOwnerUsers.get(newLeadMap.get(leadId).ownerId).Partner_Portal_Eligible__c) == 0 )){
                    // throw error if the partner user is not eligible to get leads / opportunities assigned, It is derived from the info on partner account
                    newLeadMap.get(leadId).addError(Label.Partner_Not_Eligible_for_Assignment);
                }else if(newOwnerIsPartnerUser){
                    partneUserOwnedLeads.add(leadId);
                    deleteStrkCntForLeads.add(leadId);
                    newLeadMap.get(leadId).Last_Modified_by_Partner__c = system.now();
                    newLeadMap.get(leadId).Partner_Owner_User_Language__c = String.valueOf(leadOwnerUsers.get(newLeadMap.get(leadId).ownerId).LanguageLocaleKey);
                    newLeadMap.get(leadId).Lead_State__c = 'Accepted';
                    newLeadMap.get(leadId).Partner_Owned__c = true;
                }else if(newOwnerIsPartnerQueue){
                    queueOwnedLeads.add(leadId);
                    deleteStrkCntForLeads.add(leadId);
                    newLeadMap.get(leadId).Last_Modified_by_Partner__c = null;
                }else if(oldOwnerIsPartnerUser || oldOwnerIsPartnerQueue){
                    deleteStrkCntForLeads.add(leadId);
                    newLeadMap.get(leadId).Last_Modified_by_Partner__c = null;
                    newLeadMap.get(leadId).Partner_Owned__c = false;
                }
                if((oldLeadMap.get(leadId).OwnerId != newLeadMap.get(leadId).OwnerId) && (string.valueOf(oldLeadMap.get(leadId).OwnerId).startsWith('00G') == false) && (newOwnerIsPartnerUser || newOwnerIsPartnerQueue)){
                    newLeadMap.get(leadId).Assigning_by_ISR__c = oldLeadMap.get(leadId).OwnerId;
                }
                if((oldLeadMap.get(leadId).OwnerId != newLeadMap.get(leadId).OwnerId) && (string.valueOf(oldLeadMap.get(leadId).OwnerId).startsWith('00G') && !oldOwnerIsPartnerQueue) && (newOwnerIsPartnerQueue)){
                    newLeadMap.get(leadId).Assigning_by_ISR__c = UserInfo.getUserId();
                }
                if(oldOwnerIsPartnerUser && !newOwnerIsPartnerUser){
                    newLeadMap.get(leadId).Assigning_by_ISR__c = null;
                }
            }
            
            
            if ((!PartnerCollabUtil.strkCntBatchRunning) && deleteStrkCntForLeads != null && deleteStrkCntForLeads.size()>0){
                strikeCountTracks = [Select Id, Lead__c from Strike_Count_Track__c where Lead__c in: deleteStrkCntForLeads];
                if(strikeCountTracks != null && strikeCountTracks.size()>0){
                    delete strikeCountTracks;
                } 
            }       
            if(queueOwnedLeads.size()>0 && leadOwnerQueues.size()>0){
                queueAssignmentHandler(queueOwnedLeads, oldLeadMap, newLeadMap);
            }
            if(partneUserOwnedLeads.size()>0 && leadOwnerUsers.size()>0){
                userAssignmentHandler(partneUserOwnedLeads, leadOwnerUsers, oldLeadMap, newLeadMap);
            }       
        }
        
        /**
        * @description - To handle leads assigned to partner queues for strike count mechanism
        * @param: set of leads owned by queues & new, old maps of updates leads
        */
        public static void queueAssignmentHandler(set<Id> queueOwnedLeads, map<id, lead> oldLeadMap, map<id, lead> newLeadMap){     
            List<Strike_Count_Track__c> newStrikeCounts = new List<Strike_Count_Track__c>();
            for(Id leadId: queueOwnedLeads){
                Strike_Count_Track__c strkCnt = new Strike_Count_Track__c();
                strkCnt.Lead__c = leadId;
                strkCnt.Previous_Lead_Owner_Id__c = oldLeadMap.get(leadId).ownerId;
                strkCnt.Queue_Assignment_Date__c = system.now();
                strkCnt.ownerId = newLeadMap.get(leadId).ownerId; 
                newStrikeCounts.add(strkCnt);
            }
            Database.SaveResult[] saveResults;
            try{            
                saveResults = database.insert(newStrikeCounts,false);  
            }catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, saveResults, 'Lead', 'PartnerCollabLeadUtil', 'Class');
            }
        }
        
        /**
        * @description - To handle leads assigned to partner users for strike count mechanism
        * @param: set of leads owned by partner users & new, old maps of updates leads
        */
        public static void userAssignmentHandler(set<Id> partneUserOwnedLeads, Map<Id, user> leadOwnerUsers, map<id, lead> oldLeadMap, map<id, lead> newLeadMap){
            List<Strike_Count_Track__c> newStrikeCounts = new List<Strike_Count_Track__c>();
            for(Id leadId: partneUserOwnedLeads){
                Strike_Count_Track__c strkCnt = new Strike_Count_Track__c();
                strkCnt.Lead__c = leadId;
                strkCnt.Owner_Partner_User__c = newLeadMap.get(leadId).ownerId;
                strkCnt.User_Assignment_Date__c = system.now(); 
                strkCnt.Partner_Account__c = leadOwnerUsers.get(newLeadMap.get(leadId).ownerId).AccountId;
                 //PRM:Suchitra R5:Req:6219:Start
                strkCnt.Partner_Location__c = leadOwnerUsers.get(newLeadMap.get(leadId).ownerId).Location_Record_Id__c;
                //PRM:Suchitra R5:Req:6219:End
                strkCnt.Partner_Contact__c = leadOwnerUsers.get(newLeadMap.get(leadId).ownerId).ContactId; 
                strkCnt.ownerId = newLeadMap.get(leadId).ownerId; 
                newStrikeCounts.add(strkCnt);
            }
            Database.SaveResult[] saveResults;
            try{            
                saveResults = database.insert(newStrikeCounts,false);  
            }catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, saveResults, 'Lead', 'PartnerCollabLeadUtil', 'Class');
            }
        }
        
        /**
        * @description - To stop the strike count calculations for leads in closed / Nurturing status
        * @param: new, old maps of updates leads
        */
        public static void closedLeadsHandler(map<id, lead> newLeadMap, map<id, lead> oldLeadMap){
            set<Id> StopStrkCntForLeads = new set<Id>();
            List<Strike_Count_Track__c> strikeCountsToremove = new List<Strike_Count_Track__c>();
            for(Id leadId: newLeadMap.keySet()){
                if((newLeadMap.get(leadId).Status == 'Closed') || (newLeadMap.get(leadId).Status == 'Nurturing' ) || (newLeadMap.get(leadId).Status == 'Working') || (newLeadMap.get(leadId).IsConverted) ){
                    StopStrkCntForLeads.add(leadId);
                    newLeadMap.get(leadId).Last_Modified_by_Partner__c = null;
                }
            }
            if(StopStrkCntForLeads == null || StopStrkCntForLeads.isEmpty()){
                return; 
            }
            try{
                strikeCountsToremove = [Select Id,Lead__c from Strike_Count_Track__c where Lead__c in: StopStrkCntForLeads];
                if(strikeCountsToremove != null && strikeCountsToremove.size()>0){
                    delete strikeCountsToremove;
                }
            }catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, null, 'Lead', 'PartnerCollabLeadUtil', 'Class');
            }
        }   

    }