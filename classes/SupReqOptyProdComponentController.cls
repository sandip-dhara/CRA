/**********************************************************
* Class Name: SupReqOptyProdComponentController
* Author: HP
* Date: 13-July-2012 
* Requirement # Request Id:
* Description: Controller class for SupReqOptyProdComponent used in vf templates of support Request
***********************************************************/
public class SupReqOptyProdComponentController {
     
    public string SupportRequestId {get;set;}
    public boolean isOpportunityProductsListEmpty{get;set;}
    public List<OpportunityLineItem> getOptyProducts() {
        Support_Request__c oSupportRequest=[Select Id,Opportunity__c from Support_Request__c where Id=:this.SupportRequestId ];
            List<OpportunityLineItem> spc = [Select Id,Business_Group__c,Quantity,UnitPrice,Subtotal,ServiceDate,
                                             PricebookEntry.Product2.Name,PricebookEntry.Product2.PL_name__c,GBU__c,HasSchedule from OpportunityLineItem 
                                             where OpportunityId =:oSupportRequest.Opportunity__c];
        if(spc==null || spc.size()<=0)
            isOpportunityProductsListEmpty=true;
        return spc;
    }

}