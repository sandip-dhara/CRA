/**********************************************************
* Class Name: SupportReqProductDetailController
* Author: Accenture
* Date: 12-June-2012 
* Requirement # Request Id:
* Description: Controller class for SupportReqProductDetail page
***********************************************************/
public class SupportReqProductDetailController {
    private Support_Request__c stdControllerRecord;
    public List<opportunityLineItem> OpportunityProductsList{get;set;}
    public boolean isOpportunityProductsListEmpty{get;set;}
    
    /**
    * @description: Class Constructor method
    * @param: Class Controller Apex Page
    * 
    */
    public SupportReqProductDetailController(ApexPages.StandardController controller) {
        stdControllerRecord = (Support_Request__c)controller.getRecord();
        OpportunityProductsList = [Select Id,Business_Group__c,Quantity,UnitPrice,Subtotal,ServiceDate,PricebookEntry.Product2.Name,GBU__c,HasSchedule from OpportunityLineItem where OpportunityId =:stdControllerRecord.Opportunity__c];
        if(OpportunityProductsList==null || OpportunityProductsList.size()<=0){
            isOpportunityProductsListEmpty=true;
        }
    }
}