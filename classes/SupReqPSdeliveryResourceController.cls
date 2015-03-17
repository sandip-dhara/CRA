public class SupReqPSdeliveryResourceController {
     
    public string SupportReqId{get;set;}
    public boolean isIndividualEmployeeListEmpty{get;set;}
    public List<Individual_Employee_Assignments__c> getEmployee() {
        //Support_Request__c oSupportRequest=[Select Id,Opportunity__c from Support_Request__c where Id=:this.SupportRequestId ];
            List<Individual_Employee_Assignments__c> spc = [Select Id, Home_Region__c, Organisation__c, Employee_Name__c, Employee_ID__c, Time_Tracking_Tool__c,Comments__c,Country__c,Estimated_End_Date__c,Estimated_Start_Date__c,Requested_Hours__c,Required_Level__c from Individual_Employee_Assignments__c
                                             where Support_Request__c=:this.SupportReqId];
        if(spc==null || spc.size()<=0)
            isIndividualEmployeeListEmpty=true;
        return spc;
    }

}