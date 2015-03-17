/**
* Class Name: ChannelPartnerTriggerController
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Channel_Partner__c object
*/
public class ChannelPartnerTriggerController{
    
    /**
    * @description: Action After Channel_Partner__c Insert
    * 
    * 
    */
    
    public static void afterInsert(Map<id,Channel_Partner__c> partnerNewMap){    
        ChannelPartnerTriggerUtil.checkIsPrimaryFlagOnInsert(partnerNewMap); 
        PartnerCollabACPUtil.addOpptyShareToPartners(partnerNewMap);    
    }
    /**
    * @description: Action After Channel_Partner__c Insert
    * 
    * 
    */
    public static void beforeInsert(List<Channel_Partner__c> partnerNewList){        
        ChannelPartnerTriggerUtil.checkPrimaryFlag(partnerNewList);         
    }
    
    /**
    * @description: Action  Channel_Partner__c after Delete
    * 
    * 
    */
    public static void afterDelete(){      
         ChannelPartnerTriggerUtil.checkPrimaryChannelPArtnerAfterDelete();       
    }
    /**
    * @description: Action After Channel_Partner__c Update
    * 
    * 
    */
    public static void afterUpdate(Map<id,Channel_Partner__c> partnerOldMap,Map<id,Channel_Partner__c> partnerNewMap){
        ChannelPartnerTriggerUtil.checkIsPrimaryFlagOnUpdate(partnerOldMap,partnerNewMap);
        PartnerCollabACPUtil.removeOpptyShareToPartners(partnerOldMap);
        PartnerCollabACPUtil.addOpptyShareToPartners(partnerNewMap);        
    }
    
    /**
    * @description: Action  Channel_Partner__c before Delete
    * 
    * 
    */
    public static void beforeDelete(Map<id,Channel_Partner__c> partnerOldMap){      
         PartnerCollabACPUtil.removeOpptyShareToPartners(partnerOldMap);          
    }
}