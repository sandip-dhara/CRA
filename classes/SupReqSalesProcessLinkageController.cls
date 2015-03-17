/**********************************************************
* Class Name: SupReqSalesProcessLinkageController
* Author: Accenture
* Date: 12-June-2012 
* Requirement # Request Id:
* Description: Controller class for SupReqSalesProcessLinkage vf page
***********************************************************/
public class SupReqSalesProcessLinkageController {
    private Support_Request__c stdControllerRecord;
    public List<Sales_Process_Linkage__c> SalesproclinkageList{get;set;}
    public Boolean isSalesproclinkageListEmpty{get;set;}
    
    public SupReqSalesProcessLinkageController(ApexPages.StandardController controller) {
     stdControllerRecord = (Support_Request__c)controller.getRecord();
     SalesproclinkageList=[SELECT ID__c, ID_Type__c, Opportunity__c, Name, Id, Unique_SalesLinkage_ID__c FROM Sales_Process_Linkage__c WHERE Opportunity__c =:stdControllerRecord.Opportunity__c];
     if(SalesproclinkageList==null || SalesproclinkageList.size()<=0)
            isSalesproclinkageListEmpty=true;
    }    
}