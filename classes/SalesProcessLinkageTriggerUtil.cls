/**
* Class Name: SalesProcessLinkageTriggerUtil
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods 
*/

public class SalesProcessLinkageTriggerUtil{
    public static void populateSalesLinkageId(List<Sales_Process_Linkage__c> salesLinkageNewList){
        for(Sales_Process_Linkage__c salesLinkageRecord :  salesLinkageNewList){
            salesLinkageRecord.Unique_SalesLinkage_ID__c = salesLinkageRecord.Opportunity__c + '-' + salesLinkageRecord.ID_Type__c + '-' + salesLinkageRecord.ID__c;
        }
    }
}