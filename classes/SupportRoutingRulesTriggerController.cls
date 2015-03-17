/**********************************************************
* Class Name: SupportRequestTriggerController
* Author: Accenture
* Date: 12-June-2012 
* Requirement # Request Id:
* Description: Contains support action methods for trigger on Support_Request__c object
***********************************************************/

public class SupportRoutingRulesTriggerController{
    /**
    * @description: Action Before Support_Request__c Insert 
    * @return : Void
    * 
    */
    public Static void beforeInsert(){
        SupportRequestRoutingRulesTriggerUtil.populateRecordTypeId(trigger.New);
    }
    
    /**
    * @description: Action Before Support_Request__c Insert 
    * @return : Void
    * 
    */
    public Static void beforeUpdate(){
        SupportRequestRoutingRulesTriggerUtil.populateRecordTypeId(trigger.New);
    }

}