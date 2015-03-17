public class SupportRequestOverrideController {
    public Support_Request__c supportRequest{set;get;}
    
    public SupportRequestOverrideController(ApexPages.StandardController stdController){
        supportRequest = (Support_Request__c)stdController.getRecord();
        system.debug('--- supportRequest ---'+supportRequest);        
    }
    
    public PageReference redirectToDetailOrVF(){
        PageReference pageRef = null;
        Boolean isRedirectToVF = false;
        
        if(supportRequest != null && supportRequest.id != null)
        {
            List<Support_Request__c> supportReqList = [select Id from Support_Request__c 
                                                    where Id=:supportRequest.id and 
                                                    Support_Type__c='Functional Support' and 
                                                    Sub_Type__c='Reference Success Center' limit 1];
            if(supportReqList != null && supportReqList.size()>0)
            {
                isRedirectToVF = true;
            }
            system.debug('--- isRedirectToVF ---'+isRedirectToVF);
            //Redirect to VF page for Reference Success Center type
            //Redirect to standard detail page of Support Request for all other types
            if(isRedirectToVF)
            {
                pageRef = new PageReference('/apex/RSCSupportRequestPage?id='+supportRequest.id);
                pageRef.setRedirect(true);
                return pageRef;
            }
            else
            {
                pageRef = new PageReference('/'+supportRequest.id+'?nooverride=1');
                pageRef.setRedirect(true);
                return pageRef;
            }
        }
        return pageRef;
    }
}