/**
* Class Name: CampaignTriggerUtil
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on CampaignMember object
* R1.EF02 (file://r1.ef02/) Julalin 13/06/2012: modified the code to fix the ALM defect 1107.
* Accenture 7/24/2012 : Added method to update BU and SUB-BU feilds on campaign according to workgroup values 
*               using custom setting Campaign_WorkGroup_BU_Mapping__c 
*
*/
public class CampaignTriggerUtil{
    

    /**
    * @description: unCheck other campMember's primary flag
    */
    public static void checkIsPrimaryFlagOnInsert(Map<id,CampaignMember> campMemberNewMap) {
        Set<Id> leadIds = new Set<Id>();
        //Set<Id> primaryFlagLeadIdSet = new Set<Id>();
        List<CampaignMember> campMemberToupdateList = new List<CampaignMember>();
        for(CampaignMember campMember : campMemberNewMap.values()){
            if(campMember.Primary__c == true){
                leadIds.add(campMember.LeadId);
            }
        }
        if(leadIds.size()>0){
            for (CampaignMember cp : [Select id,Primary__c 
                                            From CampaignMember 
                                            Where Primary__c = true 
                                            And LeadId IN : leadIds
                                            And Id NOT IN : campMemberNewMap.keySet()]) {
                cp.Primary__c = false;
                campMemberToupdateList.add(cp);
                //primaryFlagLeadIdSet.add(cp.LeadId);
            }
            system.debug('campMemberToupdateList>>>>'+campMemberToupdateList);
        }
        
        /*for(CampaignMember objCampaignMember:(List<campaignMember>)Trigger.new){    
            if(!primaryFlagLeadIdSet.contains(objCampaignMember.LeadId) ){
                objCampaignMember.Primary__c = true;
                //campMemberToupdateList.add(objCampaignMember);
                primaryFlagLeadIdSet.add(objCampaignMember.LeadId);
            }
        }*/
        
        
        if(campMemberToupdateList.size()>0){
            try {
                Database.SaveResult[] results = Database.update(campMemberToupdateList,false);
                system.debug('results>>>>'+results);
                Integer counter = 0;
                for(Database.SaveResult result : results){
                    if (!result.isSuccess())
                    {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs){
                            if(campMemberNewMap.containsKey(campMemberToupdateList.get(counter).id)){
                                campMemberNewMap.get(campMemberToupdateList.get(counter).id).Primary__c.addError(err.getMessage());
                            }
                        }
                    }  
                    counter++;
                }
            } catch (Exception e) {
                    System.debug('Exception:CampaignTriggerUtil.checkIsPrimaryFlag:'+e.getMessage());
            } 
        }
    }
    
    /**
    * @description: unCheck other campMember's primary flag
    */
    public static void checkIsPrimaryFlagOnUpdate(Map<id,CampaignMember> campMemberOldMap,Map<id,CampaignMember> campMemberNewMap) {
        system.debug('campMemberNewMap'+campMemberNewMap);
        Set<Id> leadIds = new Set<Id>();
        //Set<Id> campaignMemberIdSet  = new Set<Id>(); 
        List<CampaignMember> campMemberToupdateList = new List<CampaignMember>();
        for(CampaignMember campMember : campMemberNewMap.values()){
            leadIds.add(campMember.LeadId);
            /*if(campMember.Primary__c == true && campMemberOldMap.get(campMember.id).Primary__c != campMember.Primary__c ){
                leadIds.add(campMember.LeadId);
            }
            if(campMember.Primary__c == false && campMemberOldMap.get(campMember.id).Primary__c != campMember.Primary__c ){
                campaignMemberIdSet.add(campMember.id);
            }*/
        }
        system.debug('leadIds>>>>>>'+leadIds);
        Set<Id> primaryFlagLeadIdSet = new Set<Id>();
        if(leadIds.size()>0){
            for (CampaignMember cp : [Select id,Primary__c,LeadId  
                                            From CampaignMember 
                                            Where Primary__c =: true 
                                            And LeadId IN : leadIds
                                            And Id NOT IN : campMemberNewMap.keySet()]) {
                cp.Primary__c = false;
                campMemberToupdateList.add(cp);
                primaryFlagLeadIdSet.add(cp.LeadId);
            }
        }
        for(CampaignMember objCampaignMember:(List<campaignMember>)Trigger.new){    
            if(objCampaignMember.Primary__c == false && campMemberOldMap.get(objCampaignMember.id).Primary__c != objCampaignMember.Primary__c && !primaryFlagLeadIdSet.contains(objCampaignMember.LeadId)){
                objCampaignMember.addError('There should be atleast one primary campaign member on a Lead.');
            }
        }
        system.debug('update:campMemberToupdateList>>>>>>'+campMemberToupdateList);
        system.debug('primaryFlagLeadIdSet>>>>>>'+primaryFlagLeadIdSet);
        if(campMemberToupdateList.size()>0){
            try {
                Database.SaveResult[] results = Database.update(campMemberToupdateList,false);
                Integer counter = 0;
                for(Database.SaveResult result : results){
                    if (!result.isSuccess()){
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs){
                            if(campMemberNewMap.containsKey(campMemberToupdateList.get(counter).id)){
                                campMemberNewMap.get(campMemberToupdateList.get(counter).id).Primary__c.addError(err.getMessage());
                            }
                        }
                    }  
                    counter++;
                }
            } catch (Exception e) {
                    System.debug('Exception:CampaignTriggerUtil.checkIsPrimaryFlag:'+e.getMessage());
            } 
        }
    }
    
    /**
    * Author: HP (Sreedhar Jagannath)
    * Date: 15-JUL-2013 
    * @Description: Update Primary Campaign Field on Lead Based on Campaign Added to Lead Record
    */
    
    public static void CCUpdatePrimaryCampaignOnLead(Map<id,CampaignMember> campMemberNewMap) {
    
    List<CampaignMember> cmpmembers = new List<CampaignMember>(); 
    List<Lead> leadstoupdate = new List<Lead>();
    
        for(CampaignMember cmp : campMemberNewMap.values()){
            if(cmp.Primary__c == TRUE){
                Lead leadupdate = new Lead (Id=cmp.Leadid);
                leadupdate.Campaign__c = cmp.Campaignid;
                leadstoupdate.add(leadupdate);
            }       
        }
    
        if(leadstoupdate.size()>0){
            try{
                 Database.update(leadstoupdate,false);
            }
            catch(Exception e){
                System.debug('Exception:CampaignTriggerUtil.CCUpdatePrimaryCampaignOnLead:'+e.getMessage());
            }
        }
    
    }
    
    public static void CCUpdatePrimaryCampaignOnLeadAfterDelete(){
    
    List<CampaignMember> deletecmpmem = (List<CampaignMember>)Trigger.old;
    List<Lead> leadstoupdate = new List<Lead>();
        for(CampaignMember cmp : deletecmpmem ){
            if(cmp.Primary__c == TRUE){
                Lead leadupdate = new Lead (Id=cmp.Leadid);
                leadupdate.Campaign__c =NULL;
                leadstoupdate.add(leadupdate);
            }       
        }
        if(leadstoupdate.size()>0){
            try{
                 Database.update(leadstoupdate,false);
            }
            catch(Exception e){
                System.debug('Exception:CampaignTriggerUtil.CCUpdatePrimaryCampaignOnLeadAfterDelete:'+e.getMessage());
            }
        }
    
    }
    
    /**
    * @description: Check campaign before delete
    */
    public static void checkPrimaryCampaignBeforeDelete() {
        /*List<CampaignMember> deleteCampaignMembers = (List<CampaignMember>)Trigger.old;
        for (CampaignMember deleteMember: deleteCampaignMembers) {
            if (deleteMember.Primary__c) {
                deleteMember.addError('Can not delete Primary Campaign');   
            }
        }*/
             List<CampaignMember> deleteCampaignMembers = (List<CampaignMember>)Trigger.old;
        Set<Id> leadIds = new Set<Id>();
        for (CampaignMember deleteMember: deleteCampaignMembers) {
            leadIds.add(deleteMember.LeadId);        
        }
        List<CampaignMember> cms = new List<CampaignMember>();
        if(leadIds != null) {
            cms = [Select Id, LeadId 
                    From CampaignMember
                    Where LeadID IN :leadIds];  
        }
        Map<Id, List<CampaignMember>> checkForLeadIds = new Map<Id, List<CampaignMember>>();
        List<CampaignMember> checkForCms = new List<CampaignMember>();
        for (CampaignMember deleteMember: cms) {
            if(checkForLeadIds.containsKey(deleteMember.LeadId)) {
                checkForCms.add(deleteMember);
                checkForLeadIds.put(deleteMember.LeadId, checkForCms);
            } else {
                checkForCms = new List<CampaignMember>();
                checkForCms.add(deleteMember);
                checkForLeadIds.put(deleteMember.LeadId, checkForCms);
            }           
        }
        Set<Id> ignoreCm = new Set<Id>();
        for(Id key: checkForLeadIds.KeySet()) {
            system.debug('checkForLeadIds.get(key).size()>>>>'+checkForLeadIds.get(key).size());
            if(checkForLeadIds.get(key).size() == 1) {
                ignoreCm.add(checkForLeadIds.get(key)[0].Id);
                system.debug('>>>>>>>>>ignoreCm>>>'+checkForLeadIds.get(key)[0].Id);
            }
        }
        system.debug('ignoreCm>>>'+ignoreCm);
        for (CampaignMember deleteMember: deleteCampaignMembers) {
            if (deleteMember.Primary__c && !ignoreCm.contains(deleteMember.Id)) {
                deleteMember.addError('Can not delete Primary Campaign');   
            }
        }
    }
   
    /**
    * @description: Check campaign before delete
    */
    public  void validatePrimaryCampignMember() {
        Map<ID,List<ID>> leadcampaignMap= new Map<ID,List<ID>>();           
        for(CampaignMember objCampaignMember:(List<campaignMember>) Trigger.new){
            List<ID> campaignMembers= new List<ID>();
                if(leadcampaignMap.containsKey(objCampaignMember.leadId)){
                    campaignMembers = leadcampaignMap.get(objCampaignMember.leadId);
                    campaignMembers.add(objCampaignMember.Id);
                } else {
                    campaignMembers.add(objCampaignMember.Id);
                    leadcampaignMap.put(objCampaignMember.leadId,campaignMembers);
                }
        } 
        for(CampaignMember objCampaignMember:(List<campaignMember>)Trigger.new){
            if(objCampaignMember.primary__c==false && ((campaignMember)Trigger.oldMap.get(objCampaignMember.Id)).primary__c==true){            
                if(leadcampaignMap.get(objCampaignMember.leadId).size()==1){
                    objCampaignMember.addError('You can not remove primary campaign on the lead');
                }      
            }
        }
     }
     
     /**
    * @description: Method to update the primary campaign member
    */
     public void updatePrimaryCampaignMember(){
        Set<Id> leadIds = new Set<Id>();
        Set<Id> setOfleadIds = new Set<Id>();
        List<CampaignMember> campList = new List<CampaignMember>();//Added
        for(CampaignMember objCampaignMember:(List<campaignMember>)Trigger.new){
            /*if(LeadTriggerController.isLeadInsert){
                objCampaignMember.primary__c = true;
            }*/
            
        if(objCampaignMember.LeadId != null)
            leadIds.add(objCampaignMember.LeadId);
          
        }  
        List<CampaignMember> cms = new List<CampaignMember>();
        if (leadIds != null) {
            cms = [Select Id, LeadId From CampaignMember Where LeadID IN :leadIds and Primary__c=true];
        }
        for(CampaignMember cm: cms) {
            setOfleadIds.add(cm.LeadId);    
        }
        if (setOfleadIds != null) {
            for(CampaignMember objCampaignMember:(List<campaignMember>)Trigger.new){
                if(!setOfleadIds.contains(objCampaignMember.LeadId)) {
                    objCampaignMember.primary__c=true;
                    campList.add(objCampaignMember);
                    System.debug('*****campList**********'+campList.size());
                    setOfleadIds.add(objCampaignMember.LeadId);
                }
              else if(campList.size()==1)
            {
               objCampaignMember.primary__c=False;
            }
     
            }
         }
    }
    
    /**
    * @description: Update BU and SUB-BU feilds on campaign according to workgroup values 
    *               using custom setting Campaign_WorkGroup_BU_Mapping__c 
    */
    public static void updateCampaignFields(List<Campaign> newCampaigns){
        
        /* Fetching all the values for Campaign_WorkGroup_BU_Mapping__c custom setting */
        Map<String, Campaign_WorkGroup_BU_Mapping__c> campaignWorkgroupBUMap = Campaign_WorkGroup_BU_Mapping__c.getAll();
                
        /* Setting the BU and SUB-BU value according to the workgroup on the campaign */
        for (Campaign campaign : newCampaigns) {         
            Campaign_WorkGroup_BU_Mapping__c buMapping = campaignWorkgroupBUMap.get(campaign.Work_group__c);
            if (buMapping != null) {
                campaign.Business_Unit__c = buMapping.Business_Unit__c;
                campaign.Sub_Business_Unit__c = buMapping.Sub_Business_Unit__c;
            } 
        }   
    }
    
    
    /**
    * @description: Creates a new ProgramPermission record with "Deal Reg Tab Permission Set" as permission set  
    */
    /* Commented as Part of R6
    public static void createProgramPermission(List<Campaign> newCampaignsList){
        List<Campaign> newProgramsList = new List<Campaign>();
        List<Programs_and_permissions__c> newProgPermInsertList = new List<Programs_and_permissions__c>();
        Programs_and_permissions__c tempProgPermInsert ;
        Id partprogRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Partner Program').getRecordTypeId(); 
        for(Campaign newCampaignsListVar:newCampaignsList){
            if(newCampaignsListVar.RecordtypeId == partprogRecordTypeId){
                tempProgPermInsert = new Programs_and_permissions__c();
                tempProgPermInsert.Name = newCampaignsListVar.Name;
                tempProgPermInsert.Program__c = newCampaignsListVar.Id;
                tempProgPermInsert.PermissionSets__c = 'Deal_Reg_Tab_Permission_Set';
                newProgPermInsertList.add(tempProgPermInsert);
            }
        }
        if(newProgPermInsertList.size()>0)
        insert newProgPermInsertList;
    }
    */
    
  /*
    **************************************************************************
    Name        :   CampaignTeamMemberAfterDelete 
    Usage       :   This fucntion is used to store the data of delete campaign team data
    Date        :   09 May 2013
    Modefiy By  :   Devi 
    ***************************************************************************
 */
    
    
    public static void captureDeletedCampaignTeamMemberRecords(List<CampaignMember> oldCampaignMemberList)
    {
            
         Map<id,id> cTeamMemberIDMap=new Map<id,id>();
        
         List<Opportunity_Product_Delete_Capture__c> histObjList = new List<Opportunity_Product_Delete_Capture__c>();
        
            for(CampaignMember ctm : oldCampaignMemberList)
            {
               if(ctm.LeadId !=NULL )
               {
                cTeamMemberIDMap.put(ctm.Id,ctm.campaignID);
               }
            }
            
            
            if(cTeamMemberIDMap.size()>0)
            {
                for(Id ctmId : cTeamMemberIDMap.keySet())
                {
                   
                    Opportunity_Product_Delete_Capture__c histObj = new Opportunity_Product_Delete_Capture__c();
                    histObj.Deleted_Record_Id__c= ctmId;
                    //histObj.Deleted_Record_Campaign_Id__c = cTeamMemberIDMap.get(ctmId);
                    histObj.Deleted_Record_Parent_Id__c = cTeamMemberIDMap.get(ctmId);
                    histObj.Deleted_Record_Object_Type__c = 'CampaignMember';
                    histObjList.add(histObj);
                }
            }
            
            if(histObjList.size()>0)
            {
                insert histObjList;
            }
        
            
    }
}