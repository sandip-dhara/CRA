public class RSCSupportRequestController{
    public Support_Request__c supportRequest{set;get;}
    public RSCSupportRequestController(ApexPages.standardController stdController){
        system.debug('--- constructor ---');
        String supportRequestId = ApexPages.currentPage().getParameters().get('id');
        if(supportRequestId != null){
            List<Support_Request__c> tempList = [select Id, Opportunity__c, Support_Type__c,Sub_Type__c, CreatedBy.Name, CreatedDate, 
                                                LastModifiedBy.Name,LastModifiedDate,Name 
                                                from Support_Request__c 
                                                where Id=:supportRequestId];
            if(tempList != null && tempList.size()>0){
                supportRequest = tempList.get(0);
            }
            
        }
    }
    }