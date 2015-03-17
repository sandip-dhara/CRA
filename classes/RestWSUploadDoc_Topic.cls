@RestResource(urlMapping='/UploadDoc_Topic/*')
global with sharing class RestWSUploadDoc_Topic{
    
    @HttpPost
        global static RestWSResult Post(String method,String url, String topicId, String docId,String collateralid) {
        RestWSResult result = new RestWSResult();
        if(method == 'UpdateTopic')
        {
             Learning__c lb = new Learning__c();
             lb.URL__c = url;
             lb.Id = topicId;
             lb.Doc_Id__c = docId;
             update lb;
             result.success=true;
        }
        else if(method == 'UpdateCollateral')
        {
             Collateral__c c = new Collateral__c();
             c.URL__c = url;
             c.Id = collateralid;
             c.Sharepoint_Document_ID__c = docId;
             update c;
             result.success=true;
        }
        else
        {
             result.success = false;
             result.error = 'Invalid method';
        }
        return result;
    }
}