/**
* Class Name: CampaignTriggerControllers
* Author: Accenture
* Date: 4-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on CampaignMembers object
*/
public with sharing class CampaignTriggerControllers {
    /**
    * @description: Action Before CampaignMember Insert 
    */
    public static void beforeInsert() {
        //Map<id,CampaignMember > partnerNewMap = new Map<id,CampaignMember > ();
        //partnerNewMap = (CampaignMember)trigger.NewMap;
       //TestCampaignClass.beforeInsert(trigger.New);   
       new CampaignTriggerUtil().updatePrimaryCampaignMember();     
    }
    
    /**
    * @description: Action Before CampaignMember Update 
    */
    public static void beforeUpdate() { 
        //CampaignTriggerUtil.updateLeadCampaigns();
        //new CampaignTriggerUtil().validatePrimaryCampignMember();
    }
    
    public static void afterInsert(Map<id,CampaignMember > partnerNewMap){
        CampaignTriggerUtil.checkIsPrimaryFlagOnInsert(partnerNewMap);
        CampaignTriggerUtil.CCUpdatePrimaryCampaignOnLead(partnerNewMap);
    }
    
    public static void afterUpdate(Map<id,CampaignMember > partnerOldMap,Map<id,CampaignMember > partnerNewMap){
        CampaignTriggerUtil.checkIsPrimaryFlagOnUpdate(partnerOldMap,partnerNewMap);
        CampaignTriggerUtil.CCUpdatePrimaryCampaignOnLead(partnerNewMap);
    }
    
    /**
    * @description: Action Before CampaignMember Delete 
    */
    public static void beforeDelete() {  
    
         if(LeadConvertController.fromLeadConversion)return;    
        
        CampaignTriggerUtil.checkPrimaryCampaignBeforeDelete();
    }  
    
    public static void afterDelete() {  
            
        CampaignTriggerUtil.CCUpdatePrimaryCampaignOnLeadAfterDelete();
    }  
    
  /*
    **************************************************************************
    Name        :   CampaignTeamMemberAfterDelete 
    Usage       :   Below function is used to call captureDeletedCampaignTeamMemberRecords
    Date        :   10 May 2013
    Modefiy By  :   Devi 
    ***************************************************************************
 */
   
   public static void afterDelete(List<CampaignMember> oldCampaignMemberList) 
    {
           
       CampaignTriggerUtil.captureDeletedCampaignTeamMemberRecords(oldCampaignMemberList);     
    
    }
 
    
}