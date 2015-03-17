/**
* Class Name: PartnerCollabOpportunityUtil
* Author: Accenture
* Date: 13-JULY-2012
* Description: Contains support action methods for trigger on opportunity object for partner collaboration
* Last Modified date: 11th Feb,2013
*/

public class PartnerCollabOpportunityUtil{
    /**
    * @description - static variable to identify if lead conversion is in progress
    */
    public static boolean leadConversionInProgress = false;
    /**
    * @description - method to be called during lead conversion by partner
    */

    public static opportunity PartnerleadConversion(opportunity newOppty){
        leadConversionInProgress = true;
        Database.SaveResult newOpptyInsert;
        Strike_Count_Track__c strikeCountTrack = new Strike_Count_Track__c();
        list<user> partAccContList = new list<user>();
        string partnerType = 'partner';
        string userId = UserInfo.getUserId();
        string userType = UserInfo.getUserType();
        system.debug('a1a'+userType);
        if (!(userType.toLowerCase().contains(partnerType))&& Test.isRunningTest()==False){
            return newOppty;
        }                                                                                       
        if(Test.isRunningTest()==True){                                                     // For test class execution only
            User isPortalUser = [select Id, isPortalEnabled from User where Id=:userId];
            system.debug('a1a'+isPortalUser.Id+''+isPortalUser.isportalenabled);
            if(isPortalUser.isPortalEnabled == False){
                return newOppty;
            }
        }
        if( newOppty == null){
            return newOppty;
        }
        partAccContList = [SELECT AccountId, ContactId,Location_Record_Id__c, Partner_Portal_Eligible__c FROM user WHERE id =:userId];
        if( partAccContList == null || partAccContList.isEmpty()){
            return newOppty;
        }

        newOppty.OwnerId =  userId;
        newOppty.Assigned_to_partner_date__c = System.now();
        newOppty.Managed_By__c = 'Partner';
        newOppty.Partner_acknowledged__c = true;
        newOppty.Converted_by_Partner__c = true;
        
        //Insert Partner account into Alliance and Channel Partners object
        //insertPartnerAccountInChannelAlliance(newOppty,partAccContList[0].AccountId);
        /*     Commenting the above method since same functionality is taken care in other method of OpportunityAfterInsert trigger
               Last modified date : 11th Feb,2013 */
        
        //Insert Previous Lead owner into Sales Team of Opportunity
        insertPreviousOwnerOfLeadIntoSalesTeam(newOppty);
        
        strikeCountTrack.OwnerId = newOppty.OwnerId;  
        strikeCountTrack.Opportunity__c = newOppty.Id;
        strikeCountTrack.Owner_Partner_User__c = newOppty.OwnerId;
        strikeCountTrack.Partner_Account__c = partAccContList[0].AccountId;
        strikeCountTrack.Partner_Contact__c = partAccContList[0].ContactId;
        //PRM:Suchitra R5:Req:6219:Start
        strikeCountTrack.Partner_Location__c = partAccContList[0].Location_Record_Id__c;
        //PRM:Suchitra R5:Req:6219:End
        strikeCountTrack.User_Assignment_Date__c = system.now();

        try{
            newOpptyInsert = database.insert(strikeCountTrack, false);
        }
        catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, new List<Database.SaveResult>{newOpptyInsert}, 'opportunity', 'PartnerCollabOpportunityUtil', 'Class');
        }
        return newOppty;
    }
    
    /**
    * @description - Insert Partner account into Alliance and Channel Partners object
    * CR ID:- 2224
    *
    
    public static void insertPartnerAccountInChannelAlliance(opportunity newOppty,Id accountId){
        if(newOppty != null && accountId != null){
            Database.SaveResult channelPartnerInsertResult;
            Channel_Partner__c objChannelPartner = new Channel_Partner__c();
            objChannelPartner.Opportunity__c = newOppty.Id;
            objChannelPartner.Channel_Partner__c = accountId;
            objChannelPartner.Partner_Type__c = 'Channel Partner';
            try{
                channelPartnerInsertResult = Database.Insert(objChannelPartner, false);
            }
            catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, new List<Database.SaveResult>{channelPartnerInsertResult}, 'opportunity', 'PartnerCollabOpportunityUtil', 'Class');
            }
            
        }
    }*/ // Commenting the above method since same functionality is taken care in other method of OpportunityAfterInsert trigger
        // Last modified date : 11th Feb,2013 
    
    public static void insertPreviousOwnerOfLeadIntoSalesTeam(opportunity newOppty){
        if(newOppty != null){
            Database.SaveResult salesTeamInsertResult;
            List<Lead> listLead = [select id,Assigning_by_ISR__c from lead where ConvertedOpportunityId =: newOppty.id];
            if(!listLead.isEmpty()){
                OpportunityTeamMember objSalesTeam = new OpportunityTeamMember();
                objSalesTeam.OpportunityId = newOppty.Id;
                //objSalesTeam.OpportunityAccessLevel = 'Edit';
                objSalesTeam.UserId = listLead[0].Assigning_by_ISR__c;
                objSalesTeam.TeamMemberRole = 'Inside Sales';
                try{
                    salesTeamInsertResult = Database.Insert(objSalesTeam, false);
                }
                catch(Exception e){
                    CreateApexErrorLog.insertHandledExceptions(e, new List<Database.SaveResult>{salesTeamInsertResult}, 'opportunity', 'PartnerCollabOpportunityUtil', 'Class');
                }   
            }
        }
    }

// Commented the above method as it is not used in any of the classes.  (Last modified:24/05/2013)
    
    /**
    * @description: Method to obtains opportunity IDs where owner has changed
    * @param: Opportunity old and new map
    **/
    public static void OpptyUpdate(map<id, opportunity> oldMap, map<id, opportunity> newMap){
        
        /** 
        * @description: Check if lead conversion is in progress; if yes, no action is to be taken
        **/
        if(PartnerCollabOpportunityUtil.leadConversionInProgress == true){
            return;
        }
        set<Id> updatedOpptyIds = new set<Id>();
        set<Id> ownerIds = new set<Id>();
        string newOpptyOwner;
        for(Id opptyId: newMap.keySet()){           
            system.debug('opptyId'+opptyId);
            if(oldMap.get(opptyId).OwnerId != newMap.get(opptyId).OwnerId){
                updatedOpptyIds.add(opptyId);
                ownerIds.add(oldMap.get(opptyId).OwnerId);
                ownerIds.add(newMap.get(opptyId).OwnerId);
            }
        }
        
        if(updatedOpptyIds != null && updatedOpptyIds.size() > 0){
            PartnerCollabOpportunityUtil.updateOpportunityFields(updatedOpptyIds, ownerIds, oldMap, newMap);
        }
        
    }
    
    /** 
    * @description: Method to update opportunity fields based on old owner and new owner
    * @param: Set of IDs of opportunities where owner has changed, Set of user IDs, Old and new opportunity map
    **/
    public static void updateOpportunityFields(set<Id> updatedOpptyIdsSet, set<Id> ownerIds, map<id, opportunity> opptyOldMapForSCT, map<id, opportunity> opptyNewMapForSCT){
        string partnerType = 'partner';
        ownerIds.add(userInfo.getuserId());     //adding logged in user's id to the set
        system.debug('ownerids'+ownerIds);
        set<Id> opptyIdsforSCTToBeDeleted = new set<Id>(); 
        set<Id> updatedOwnerOpptyIdsSet = new set<Id>();
        Map<Id, user> allUsersMap = new Map<Id, user>([SELECT Id,IsPortalEnabled,UserType,ContactId,AccountId,Partner_Portal_Eligible__c FROM user WHERE Id IN :ownerIds]);
        boolean loggedInUserPortalEnabled = allUsersMap.get(userInfo.getUserId()).IsPortalEnabled;
        string LoggedInPartnerType = string.valueof(allUsersMap.get(userInfo.getUserId()).UserType);
        Boolean oldOwnerIsPartnerUser = false;
        Boolean newOwnerIsPartnerUser = false;
        Boolean oldOwnerIsInternalUser = false;
        Boolean newOwnerIsInternalUser = false;
        Database.DeleteResult[] deleteResults;
        
        updatedOwnerOpptyIdsSet = indicateOwnership(updatedOpptyIdsSet, allUsersMap, opptyOldMapForSCT, opptyNewMapForSCT);
        
        for(Id opptyIds: updatedOwnerOpptyIdsSet){
            oldOwnerIsPartnerUser = false;
            newOwnerIsPartnerUser = false;
            oldOwnerIsInternalUser = false;
            newOwnerIsInternalUser = false;
            
            oldOwnerIsPartnerUser = string.valueof(allUsersMap.get(opptyOldMapForSCT.get(opptyIds).ownerId).UserType).toLowerCase().contains(partnerType);
            newOwnerIsPartnerUser = string.valueof(allUsersMap.get(opptyNewMapForSCT.get(opptyIds).ownerId).UserType).toLowerCase().contains(partnerType);
            oldOwnerIsInternalUser = !(string.valueof(allUsersMap.get(opptyOldMapForSCT.get(opptyIds).ownerId).UserType).toLowerCase().contains(partnerType));
            newOwnerIsInternalUser = !(string.valueof(allUsersMap.get(opptyNewMapForSCT.get(opptyIds).ownerId).UserType).toLowerCase().contains(partnerType));
            
            /** 
            * @description: checking conditions when logged in user is an ISR
            **/
            if(loggedInUserPortalEnabled == false){
            system.debug('cond_for_ISR');
                if(newOwnerIsPartnerUser && (Integer.ValueOf(allUsersMap.get(opptyNewMapForSCT.get(opptyIds).ownerId).Partner_Portal_Eligible__c) == 0)){
                    opptyNewMapForSCT.get(opptyIds).addError(Label.Partner_Not_Eligible_for_Assignment);
                }else if(newOwnerIsInternalUser && oldOwnerIsPartnerUser){
                    system.debug('UC-1');
                    opptyNewMapForSCT.get(opptyIds).Converted_by_Partner__c = false;
                    opptyNewMapForSCT.get(opptyIds).Partner_acknowledged__c = false;
                    opptyIdsforSCTToBeDeleted.add(opptyIds);
                }else if(newOwnerIsPartnerUser && oldOwnerIsInternalUser){
                    system.debug('UC-3');
                    opptyNewMapForSCT.get(opptyIds).Assigned_to_partner_date__c = system.now();
                    opptyNewMapForSCT.get(opptyIds).Converted_by_Partner__c = false;
                    opptyNewMapForSCT.get(opptyIds).Partner_acknowledged__c = false;
                    opptyIdsforSCTToBeDeleted.add(opptyIds);
                }else if(newOwnerIsPartnerUser && oldOwnerIsPartnerUser){
                    if((allUsersMap.get(opptyNewMapForSCT.get(opptyIds).ownerId).AccountId) ==(allUsersMap.get(opptyOldMapForSCT.get(opptyIds).ownerId).AccountId)){
                        system.debug('UC-5');
                        opptyNewMapForSCT.get(opptyIds).Last_Modified_by_Partner__c = system.now();
                    }
                    else if((allUsersMap.get(opptyNewMapForSCT.get(opptyIds).ownerId).AccountId) !=(allUsersMap.get(opptyOldMapForSCT.get(opptyIds).ownerId).AccountId)){
                        system.debug('UC-4');
                        opptyNewMapForSCT.get(opptyIds).Assigned_to_partner_date__c = system.now();
                        opptyNewMapForSCT.get(opptyIds).Converted_by_Partner__c = false;
                        opptyNewMapForSCT.get(opptyIds).Partner_acknowledged__c = false;
                        opptyIdsforSCTToBeDeleted.add(opptyIds);
                    }
                }
            }
            
            /** 
            * @description: checking conditions when logged in user is a partner user
            **/
            if((loggedInUserPortalEnabled == true) && (LoggedInPartnerType.toLowerCase().contains(partnerType))){
                system.debug('cond_for_Partner');
                if(newOwnerIsInternalUser && oldOwnerIsPartnerUser){
                    system.debug('UC-6');
                    opptyNewMapForSCT.get(opptyIds).Assigned_to_partner_date__c = null;
                    opptyNewMapForSCT.get(opptyIds).Last_Modified_by_Partner__c = null;
                    opptyNewMapForSCT.get(opptyIds).Partner_acknowledged__c = false;
                    opptyNewMapForSCT.get(opptyIds).Converted_by_Partner__c = false;
                    opptyIdsforSCTToBeDeleted.add(opptyIds);
                }   
            }
        }
        
        /*
        List and SOQL to delete records from custom object - "strike count track"
        */
        
        list<Strike_Count_Track__c> SCTToBeDeleted = new list<Strike_Count_Track__c>();
        SCTToBeDeleted = [SELECT Id FROM Strike_Count_Track__c WHERE Opportunity__r.Id IN :opptyIdsforSCTToBeDeleted];
        try{
            if(SCTToBeDeleted.size() > 0){
                deleteResults = database.delete(SCTToBeDeleted, false);
            }
        }
        catch(exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Strike_Count_Track__c', 'PartnerCollabOpportunityUtil', 'Class');
        }
    }
    
    /** 
    * @description: Method to verify that internal user is eligible for participating in partner collaboration
    **/
    public static set<Id> indicateOwnership(set<Id> updatedOpptyIdsSet, map<Id, user> usersMap, map<id, opportunity> opptyOldMap, map<id, opportunity> opptyNewMap){
        set<Id> updatedOwnerOpptyIdsSet = new set<Id>();
        for(Id updtedOppty: updatedOpptyIdsSet){
            boolean IsNewOwnerPartner = string.valueOf(usersMap.get(opptyNewMap.get(updtedOppty).ownerId).UserType).toLowerCase().contains('partner');
            if(IsNewOwnerPartner){
                if((!PartnerCollabUtil.isLoggedInPartnerUser()) && (!PartnerCollabUtil.participatingInPartnerHandling())){
                    opptyNewMap.get(updtedOppty).addError(Label.HP_User_not_participating_in_partner_collaboration);
                }
                else{
                    updatedOwnerOpptyIdsSet.add(updtedOppty);
                    opptyNewMap.get(updtedOppty).Managed_By__c = 'Partner';
                }
            }
            else{
                updatedOwnerOpptyIdsSet.add(updtedOppty);
                opptyNewMap.get(updtedOppty).Managed_By__c = 'HP';
            }
        }
        return updatedOwnerOpptyIdsSet;
    }
}