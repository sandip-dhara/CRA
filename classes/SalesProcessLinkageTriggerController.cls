/**
* Class Name: SalesProcessLinkageTriggerController
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Sales_Process_Linkange__c object
*/

public class SalesProcessLinkageTriggerController{
    /**
    * @description: Action Before Sales_Process_Linkange__c Insert 
    * 
    * 
    */
    public Static void beforeInsert(){
        SalesProcessLinkageTriggerUtil.populateSalesLinkageId(trigger.New);
    }
    
    /**
    * @description: Action Before Sales_Process_Linkange__c Update
    * 
    * 
    */
    public Static void beforeUpdate(){
        SalesProcessLinkageTriggerUtil.populateSalesLinkageId(trigger.New);
    }

}