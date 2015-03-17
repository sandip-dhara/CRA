/**
* Class Name: OpportunityTriggerUtil
* Author: Accenture, Modified by Quang Vu (HP) 10/30/2012
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on User object
*/
public class OpportunityTriggerUtil{
    //Sameer CR – 0409 start.
    public static boolean loopOnlyOnce = true;
    //Sameer CR – 0409 End
    /**
    * @description: Populate/Update customer owner field with OwnerId
    * 
    * 
    */
    public static void updateOwner(List<Opportunity> lstopty) {
        if (lstopty != null && lstopty.size() > 0) {
            for (Opportunity opty : lstopty) {
                //If custom owner field is different than OwnerId, populate it
                if(opty.Owner__c != opty.OwnerId) {
                    opty.Owner__c = opty.OwnerId;
                }
            }
        }
    }
    
    /**
    * @description: Converts Id longer than 15 characters
    *               to 15 character Id
    * 
    */
    public Static String convertTo15Digit(String paramID){
        try{
            if(paramID.length()>15){
                paramID = paramID.substring(0,15);
            }
        }catch(Exception e){
        }
        return paramID;
    }
    
    /**
    * @description: fetches restricted profiles from custom setting
    * 
    */
    public Static Set<Id> getRestrictedProfileSet(){
        Set<Id> restrictedProfilesSet = new Set<Id>();
        Map<String,Admin_Profiles__c> adminProfilesMap = Admin_Profiles__c.getAll();
        for(Admin_Profiles__c prof : adminProfilesMap.values()){
            if(prof.Module__c!=null){
                if(prof.Module__c.equalsIgnoreCase(Label.Opty_Update_Restricted_Profile)){
                    if(prof.Profile_ID__c!=null){
                        restrictedProfilesSet.add(convertTo15Digit(prof.Profile_ID__c));
                    }
                }
            }
        }
        return restrictedProfilesSet;
    }
    
    /**
    * @description: Checks if logged in user's profile is among 
    *               restricted profiles, if yes adds error
    */ 
    public static void checkIsMarketingAdminProfile(Map<id,Opportunity> optyOldMap,Map<id,Opportunity> optyNewMap) {
        String ignoreFieldList = Label.Marketing_Admin_Ignore_Fields;
        String currentProfileId = convertTo15Digit(Userinfo.getProfileId());
        Set<Id> restrictedProfileSet = getRestrictedProfileSet();
        if(restrictedProfileSet.contains(currentProfileId)){
            Map<String, Schema.SObjectField> oppFieldMap = Schema.SObjectType.opportunity.fields.getMap();
            for(Opportunity oppObj : optyNewMap.values())
            {
                for(String oppFName: oppFieldMap.keySet()) 
                {
                    //Check if any field value on Opporunity is getting modified by user.If yes- then throw an error message.
                    if( oppObj.get(oppFName)!=optyOldMap.get(oppObj.Id).get(oppFName))
                    {
                        if(ignoreFieldList.contains(oppFName))
                            return;
                        oppObj.addError(Label.MarketingAdmin_Optyupdate_Error);
                    } 
                }
            }
        }
    }
    
    /**
    * @description: To check Book/Ship date of existing line items on to be updated Opportunity
    *               and error out if this date is less than CloseDate for certain stages
    * 
    * 
    */
    public static void checkLineItemShipDate(Map<id,Opportunity> optyOldMap,Map<id,Opportunity> optyNewMap) {
        System.debug('##############Inside checkLineItemShipDate###################');
        Boolean errorFlag = false;            
        List<Opportunity> listOpptyWithLineItems = new List<Opportunity>();
        Set<ID> oppIds = New Set<ID>();
        Map<Id,Opportunity> opptyByIdMap = new Map<Id,Opportunity>();
        List<OpportunityLineItem> listOppLineItem = new List<OpportunityLineItem>();
        
        for(Opportunity oppObj : optyNewMap.values()){
            if(oppObj.HasOpportunityLineItem == true){
                if (oppObj.CloseDate != optyOldMap.get(oppObj.Id).CloseDate && 
                    (oppObj.StageName == Label.Validate_Opportunity ||
                     oppObj.StageName == Label.Understand_Customer ||
                     oppObj.StageName == Label.Develop_Solution ||
                     oppObj.StageName == Label.Qualify_Opportunity ||
                     oppObj.StageName == Label.Propose_Solution ||
                     oppObj.StageName == Label.Negotiate_And_Close)){
                        oppIds.add(oppObj.Id);
                        opptyByIdMap.put(oppObj.Id,oppObj);
                }
            }       
        }
         /*@ Description: Comment the book/ship date error logic as per R4.0-4302 requirement
       /* if (oppIds.size()>0){
            listOppLineItem = [Select Id,OpportunityId, ServiceDate from OpportunityLineItem
                               where OpportunityId IN : oppIds];
             
            for(OpportunityLineItem oliObj : listOppLineItem) {
                if(oliObj.ServiceDate < opptyByIdMap.get(oliObj.OpportunityId).CloseDate  && 
                  (OpportunityTriggerController.isOpportunityInsert==false) &&
                    (opptyByIdMap.get(oliObj.OpportunityId).StageName == Label.Understand_Customer ||
                     opptyByIdMap.get(oliObj.OpportunityId).StageName == Label.Validate_Opportunity ||
                     opptyByIdMap.get(oliObj.OpportunityId).StageName == Label.Develop_Solution ||
                     opptyByIdMap.get(oliObj.OpportunityId).StageName == Label.Qualify_Opportunity ||
                     opptyByIdMap.get(oliObj.OpportunityId).StageName == Label.Propose_Solution ||
                     opptyByIdMap.get(oliObj.OpportunityId).StageName == Label.Negotiate_And_Close)){
                        opptyByIdMap.get(oliObj.OpportunityId).addError(Label.Ship_Date_Error);
                }  
            }
        }*/   
    }
     /**
    * @description: To check Products Hierarchy Level and Error Out if required hierarchy level product is not present on Opportunity Sales Stage change
    * 
    * 
    */
    
    /*
    public static void checkProductHierarchyLevel(Map<id,Opportunity> optyOldMap,Map<id,Opportunity> optyNewMap) {
        Set<Id> OpptyIds = New Set<Id>();
        Map<Id,Opportunity> opptyWithStageChangeByIdMap = new Map<Id,Opportunity>();
        List<OpportunityLineItem> listLineItem = new List<OpportunityLineItem>();
        for(Opportunity oppObj : optyNewMap.values()){
            if (oppObj.stageName!= optyOldMap.get(oppObj.Id).stageName){
                    OpptyIds.add(oppObj.Id);
                    opptyWithStageChangeByIdMap.put(oppObj.Id,oppObj);
            }
        }
        if (OpptyIds.size()>0){
            listLineItem = [Select Id,OpportunityId, ServiceDate,PricebookEntry.Product2.GBU__c, PricebookEntry.Product2.Business_Group__c, PricebookEntry.Product2.Product_Line__c,
                               PricebookEntry.Product2.Sub_Product_Line__c from OpportunityLineItem
                               where OpportunityId IN : OpptyIds];
            for(OpportunityLineItem oliObj : listLineItem) {
                if((opptyWithStageChangeByIdMap.get(oliObj.OpportunityId).StageName == Label.Develop_Solution ||
                    opptyWithStageChangeByIdMap.get(oliObj.OpportunityId).StageName == Label.Propose_Solution ||
                    opptyWithStageChangeByIdMap.get(oliObj.OpportunityId).StageName == Label.Negotiate_And_Close||
                    opptyWithStageChangeByIdMap.get(oliObj.OpportunityId).StageName == Label.Won_Deploy_Expand)
                    && (oliObj.PricebookEntry.Product2.Sub_Product_Line__c =='' || oliObj.PricebookEntry.Product2.Sub_Product_Line__c == null)){
                        if (opptyWithStageChangeByIdMap.get(oliObj.OpportunityId).Type != 'Renewal'){
                            opptyWithStageChangeByIdMap.get(oliObj.OpportunityId).addError(Label.Sub_Product_Line_Error);    
                        } else  if (opptyWithStageChangeByIdMap.get(oliObj.OpportunityId).Type == 'Renewal' && 
                            oliObj.PricebookEntry.Product2.Product_Line__c =='' || oliObj.PricebookEntry.Product2.Product_Line__c == null){
                            opptyWithStageChangeByIdMap.get(oliObj.OpportunityId).addError(Label.Product_Line_Error);
                        }
                }
            }
         }
    } 
    
   
    /**
    * @description: checks if opportunity update is a result of HPFS engagement
    * @params: none;
    * @returns: true if trigger is a result of the Engage HPFS button
    */
    
    public static Boolean triggeredByHPFS(){
        for (Opportunity opp : (List<Opportunity>)trigger.new) {
            try{
                Opportunity oldOpp = (Opportunity)trigger.oldMap.get(opp.Id);
                if (opp.HPFS_Needed__c != oldOpp.HPFS_Needed__c) {
                    return true;
                }
            }
            catch (exception ex){
                System.debug('hpfs update check failed with exception: ' + ex);
                return false;
            }
        }
        return false;
    }
    
/*Added by Sameer CR – 0409 Start
*  @description: This method will change the ForcaseCatagoryName of an opportunity to 'Upside' if the Current User is a portalUser, owner of the opportunity
*                is not a portalUser and when the stageName is changed to '05 - Negotiate & Close'.
*
*/
    public static void partnerPortalForcastChangeToUpside(map<id, opportunity> oldOpportunityMap, list<opportunity> newOpptyList){
        if(loopOnlyOnce){
        system.debug('inside if loop');
            user loggedInUser = [select name, isPortalEnabled from user where id=: userInfo.getUserID() Limit 1];
            system.debug('loggedinuser' +loggedInUser.name + '----' + loggedInUser.isPortalEnabled);
            for(opportunity opp : newOpptyList){
                opportunity oldOpp = oldOpportunityMap.get(opp.id);
                if(opp.StageName=='05 - Negotiate & Close' && loggedInUser.isPortalEnabled && (opp.StageName <> oldOpp.StageName)){
                    opp.ForecastCategoryName = 'Pipeline';
                   // loopOnlyOnce =false;
                }
            }
            loopOnlyOnce =false;
        }
    }
//CR – 0409 END
    
    public static void updatingWithPriceBookId(List<Opportunity> opplist){
       PriceBook2 pb=[select id,name from PriceBook2 where name='Products & Services'];
       for(opportunity op : opplist){
           op.pricebook2id=pb.id;
       }
   
   } 
   
   //PRM:Vinay R4:Req:4043:Start
   
    /**
    * @description: This method provides sharing access to 
      sales territories when Partner creates an opportunity
    * @params: trigger.newMap;
    * @returns: void
    */
   
    /*public static void afterInsertTerritoryUpdate(Map<Id,Opportunity> opptyMap){
        Map<Id,Opportunity> processAddMap = new Map<Id,Opportunity>();
        set<id> opptyOwnerIDSet = new set<id>();
        Map<Id, user> opptyOwnerisPortalMap = new Map<id, user>();
        list<user> opptyPortalOwnerList = new list<user>();
        
        for(opportunity opp: opptyMap.values()){
            opptyOwnerIDSet.add(opp.ownerId);
        }
        for(user u : [select id,isPortalEnabled, Partner_Account_Id__c from user where id IN: opptyOwnerIdSet]){
            opptyOwnerisPortalMap.put(u.id, u);
        }
        
        for(opportunity oppt: opptyMap.values()){
            user tempUser = opptyOwnerisPortalMap.get(oppt.ownerId);
            if(tempUser.isPortalEnabled){
                processAddMap.put(oppt.id, oppt);
                opptyPortalOwnerList.add(tempUser);
            }
        }
            
        PCLM_OppOwnerChngTerrUpdateController.addOpptyShareToPartners(processAddMap,opptyPortalOwnerList);
    }*/
    //PRM:Vinay R4:Req:4043:End
    
    //TM:Vinay R5:Req:6201:Start
     public static void afterOptyInsertTerritoryUpdateForLocation(Map<Id,Opportunity>newOptyMap){
        Map<Id,Opportunity> processOptyMap = new Map<Id,Opportunity>();
        Set<Id>  optyOwnerSet = new Set<Id>();
        Map<Id,User> optyOwnerIsPortalEnabledMap = new Map<Id,User>();
        List<User> optyPortalOwnerList = new List<User>();
        
        for(Opportunity opty: newOptyMap.values()){
            system.debug('opportunity owner id***'+opty.ownerId);
            optyOwnerSet.add(opty.ownerId);
        }
        for(User u: [Select Id,IsPortalEnabled,ContactId,Partner_Account_Id__c From User Where Id IN: optyOwnerSet]){
            system.debug('ContactId ***'+u.ContactId);
            optyOwnerIsPortalEnabledMap.put(u.Id,u);
        }
        for(Opportunity opty: newOptyMap.values()){
            User tmpUser = optyOwnerIsPortalEnabledMap.get(opty.ownerId);
            if(tmpUser.IsPortalEnabled){
                system.debug('opty inserted>>>>'+opty.Id);
                processOptyMap.put(opty.Id,opty);
                system.debug('contact inserted>>>'+tmpUser.contactId);
                optyPortalOwnerList.add(tmpUser);
            }
        }
        PCLM_OppOwnerChngTerrUpdateController.addOpptyShareToPartnersForLocation(processOptyMap,optyPortalOwnerList);
    }
    //TM:Vinay R5:Req:6201:End
    
    //PRM:Sameer R4:Req:4043:Start
    
    /**
    * @description: This is used update the sharing to the territory when the owner 
      of the Opportunity is changed from / to a portal user.
    * @params: trigger.oldMap,trigger.newMap;
    * @returns: void
    */
       
    /*public static void afterUpdateTerritoryUpdate(Map<Id,Opportunity>oldMap,Map<Id,Opportunity> newMap){
        Map<id,Opportunity> processAddMap = new Map<id,Opportunity>();
        Map<id,Opportunity> processRemMap = new Map<id,Opportunity>();
        Set<id> opptyOwnerIDSet = new Set<id>();
        Map<id, user> opptyOwnerisPortalMap = new Map<id, user>();
        Set<id> changedOpptySet = new Set<id>();
        list<user> opptyAddPartnerUserList = new list<user>();
        list<user> opptyRemPartnerUserList = new list<user>();
        
        for(Opportunity opp: newMap.values()){
            opptyOwnerIDSet.add(opp.ownerId);
        }
        for(Opportunity oppt: oldMap.values()){
            opptyOwnerIDSet.add(oppt.OwnerId);
        }
        for(User u : [select id, isPortalEnabled, Partner_account_Id__c from user where Id IN:opptyOwnerIDSet]){
            opptyOwnerisPortalMap.put(u.id, u);
        }
        
        for(Opportunity newop: newMap.values()){
            Opportunity oldop = oldMap.get(newop.Id);
            user newOwnerUser = opptyOwnerisPortalMap.get(newop.Ownerid);
            user oldOwnerUser = opptyOwnerisPortalMap.get(oldop.Ownerid);
            if(oldop.ownerId != newop.ownerId){
                system.debug('inside this if' + oldop.ownerId +'----new owner'+newop.ownerId);
                if(newOwnerUser.isPortalEnabled){ 
                    processAddMap.put(newop.id,newop);
                    opptyAddPartnerUserList.add(newOwnerUser);
                } 
                if(oldOwnerUser.isPortalEnabled && newOwnerUser.Partner_account_Id__c <> oldOwnerUser.Partner_Account_Id__c){ 
                    processRemMap.put(oldop.id,oldop);
                    opptyRemPartnerUserList.add(oldOwnerUser);
                }
            }
        }
        
        if(processAddMap != null && processAddMap.size() > 0){
            PCLM_OppOwnerChngTerrUpdateController.addOpptyShareToPartners(processAddMap,opptyAddPartnerUserList);
        }
        
        if(processRemMap != null && processRemMap.size() > 0){
            PCLM_OppOwnerChngTerrUpdateController.removeOpptyShareToPartners(processRemMap,opptyRemPartnerUserList);
        }
    }*/
    //PRM:Sameer R4:Req:4043:End
    
     //TM:R5:Vinay 6201-Start
    public static void afterOptyUpdateTerritoryUpdateForLocation(Map<Id,Opportunity> newMap,Map<Id,Opportunity> oldMap){
        Set<Id> optyOwnerIdSet = new Set<Id>();
        Map<Id,User> optyOwnerIsPortalMap = new Map<Id,User>();
        Map<Id,Opportunity> processAddShareOptyMap = new Map<Id,Opportunity>();
        Map<Id,Opportunity> procesRemoveShareOptyMap = new Map<Id,Opportunity>();
        List<User> optyAddPartnerUserList = new List<User>();
        List<User> optyRemovePartnerUserList =new List<User>();
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id,Id> contactIdLocIdMap = new Map<Id,Id>();
        
        for(Opportunity opty: newMap.values()){
            optyOwnerIdSet.add(opty.OwnerId);
        }
        for(Opportunity opty: oldMap.values()){
            optyOwnerIdSet.add(opty.OwnerId);
        }
        for(User u:[Select Id,ContactId,isPortalEnabled From User Where Id IN: optyOwnerIdSet]){
            optyOwnerIsPortalMap.put(u.Id,u);
            contactIdSet.add(u.ContactId);
        }
        for(Location_Partner_Users__c lpUser:[Select contact__c,location__c From Location_Partner_Users__c Where contact__c IN:contactIdSet]){
            contactIdLocIdMap.put(lpUser.contact__c,lpUser.location__c);
        }
        
        for(Opportunity newOpty: newMap.values()){
            Opportunity oldOpty = oldMap.get(newOpty.Id);
            User newOwnerUser = optyOwnerIsPortalMap.get(newOpty.OwnerId);
            User oldOwnerUser = optyOwnerIsPortalMap.get(oldOpty.OwnerId);
            
            if(oldOpty.OwnerId != newOpty.OwnerId){
                if(newOwnerUser.isPortalEnabled){
                    system.debug('Opty to be shared>>>'+newOpty.Id);
                    processAddShareOptyMap.put(newOpty.Id,newOpty);
                    optyAddPartnerUserList.add(newOwnerUser);
                }
                if(oldOwnerUser.IsPortalEnabled && contactIdLocIdMap.get(newOwnerUser.contactId)<> contactIdLocIdMap.get(oldOwnerUser.contactId)){
                    procesRemoveShareOptyMap.put(oldOpty.Id,oldOpty);
                    optyRemovePartnerUserList.add(oldOwnerUser);
                }
            }
        }
        if(processAddShareOptyMap != null && processAddShareOptyMap.size() > 0){
            system.debug('inside add share'+processAddShareOptyMap.size());
            PCLM_OppOwnerChngTerrUpdateController.addOpptyShareToPartnersForLocation(processAddShareOptyMap,optyAddPartnerUserList);
        }
        if(procesRemoveShareOptyMap != null && procesRemoveShareOptyMap.size() > 0){
            PCLM_OppOwnerChngTerrUpdateController.removeOpptyShareToPartnersForLocation(procesRemoveShareOptyMap,optyRemovePartnerUserList);
        }
    }
    //TM:R5:Vinay 6201-End
    
    //Vinay R6 EF-01:Req:7525:Start
    public static void afterOpptyConfidentialUpdateTerritorySharing(Map<Id,Opportunity> newOpptyMap,Map<Id,Opportunity> oldOpptyMap){
        
        Map<Id,Opportunity> removeOpptyShareMap = new Map<Id,Opportunity>();
        Map<Id,Opportunity> addOpptyShareMap = new Map<Id,Opportunity>();
        Map<Id,Account> opptyIdOldAccountMap = new Map<Id,Account>();
        Map<Id,Account> opptyIdNewAccountMap = new Map<Id,Account>();
        Set<Id> accountIdSet = new Set<Id>();
        
        //Fetch all Opportunities which are marked Confidential after update
        for(Opportunity newOppty:newOpptyMap.values()){
            Opportunity oldOppty = oldOpptyMap.get(newOppty.Id);
            system.debug('old conf>>> '+oldOppty.Confidential__c);
            system.debug('new conf>>> '+newOppty.Confidential__c);
            if(oldOppty.Confidential__c == false && newOppty.Confidential__c == true){
                removeOpptyShareMap.put(newOppty.Id,newOppty);
            }else if(oldOppty.Confidential__c == true && newOppty.Confidential__c == false){
                addOpptyShareMap.put(newOppty.Id,newOppty);
            }
        }
        
        for(Opportunity oldOpty:oldOpptyMap.values()){
            accountIdSet.add(oldOpty.AccountId);
        }
        
        for(Opportunity newOpty:newOpptyMap.values()){
            accountIdSet.add(newOpty.AccountId);
        }
        
        
        Map<Id,Account> accountMap = new Map<Id,Account>([Select Id,Confidential_Account__c From Account Where Id In :accountIdSet]);
        
    
        for(Opportunity oldOppty: oldOpptyMap.values()){
            if(accountMap != null && accountMap.containskey(oldOppty.AccountId)){
                opptyIdOldAccountMap.put(oldOppty.Id,accountMap.get(oldOppty.AccountId));
            }
        }
            
        for(Opportunity newOppty: newOpptyMap.values()){
            if(accountMap != null && accountMap.containsKey(newOppty.AccountId)){
                opptyIdNewAccountMap.put(newOppty.Id,accountMap.get(newOppty.AccountId));
            }
        }
        
        
        //Fetch all Opportunities whose Customer Account got changed to a Private Customer Account
        for(Id optyId:opptyIdNewAccountMap.keySet()){
            Account newAcct = opptyIdNewAccountMap.get(optyId);
            Account oldAcct = opptyIdOldAccountMap.get(optyId);
            if(oldAcct.Id != newAcct.Id && oldAcct.Confidential_Account__c == false && newAcct.Confidential_Account__c == true){
                if(!removeOpptyShareMap.containsKey(optyId)){
                    removeOpptyShareMap.put(optyId,newOpptyMap.get(optyId));
                }
            }else if(oldAcct.Id != newAcct.Id && oldAcct.Confidential_Account__c == true && newAcct.Confidential_Account__c == false){
                if(!addOpptyShareMap.containsKey(optyId)){
                    addOpptyShareMap.put(optyId,newOpptyMap.get(optyId));
                }
            }
        }
        
        if(null != removeOpptyShareMap && !removeOpptyShareMap.isEmpty()){
            TMPartnerOpportunityShareController.removeOpptyShareForPartnerTerritories(removeOpptyShareMap);
        }
        
        if(null != addOpptyShareMap && !addOpptyShareMap.isEmpty()){
            TMPartnerOpportunityShareController.addOpptyShareForPartnerTerritories(addOpptyShareMap);
        }
        
    }
    //Vinay R6 EF-01:Req:7525:End
    
}