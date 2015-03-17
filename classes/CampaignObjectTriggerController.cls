/**
* Class Name: CampaignObjectTriggerController
* Author: Accenture
* Date: 24-JUL-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Campaign object
*/

public class CampaignObjectTriggerController {

   /**
    * @description: Action Before Campaign Insert 
    */
    public static void beforeInsert(List<Campaign> newCampaigns) {     
       CampaignTriggerUtil.updateCampaignFields(newCampaigns);   
    }
    
    /**
    * @description: Action Before Campaign Update 
    */
    public static void beforeUpdate(List<Campaign> newCampaigns) {  
        CampaignTriggerUtil.updateCampaignFields(newCampaigns);
    }
    
    /**
    * @description: Action After Campaign Insert 
    */
    /*
    public static void afterInsert(List<Campaign> newCampaigns) {  
        CampaignTriggerUtil.createProgramPermission(newCampaigns);
    }  
    */ 
    
}