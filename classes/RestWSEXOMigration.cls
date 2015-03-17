@RestResource(urlMapping='/ExoMigration/*')
global with sharing class RestWSEXOMigration{
    
    @HttpPost
        global static RestWSResult Post(String url, String id) {
        RestWSResult result = new RestWSResult();
        String method='';
        //String docId='0';
        String collateralid='';
        String topicId='';
       
        List<Learning__c> lstLearning = [Select id From Learning__c where id = :id];
        List<Collateral__c> lstCollateral = [Select id From Collateral__c where id = :id];
        
        List<Learning_Board_Learning__c> lstLBL = [Select Learning_ID__c,Learning_Board_ID__c From Learning_Board_Learning__c where Learning_ID__c in :lstLearning ];
        
       if(lstLearning.size() > 0)
       {
           method='UpdateTopic';
           topicId=id;
       }
       else if(lstCollateral.size() > 0)
       {
           method='UpdateCollateral';
           collateralid=id;   
       }
       
        
        if(method == 'UpdateTopic')
        {
             Learning__c lb = new Learning__c();
             //lb.URL__c = url;
             lb.ExoURL__c = url;
             lb.Id = topicId;
             //lb.Doc_Id__c = docId;
             update lb;
             result.success=true;
        }
        else if(method == 'UpdateCollateral')
        {
             Collateral__c c = new Collateral__c();
             //c.URL__c = url;
             c.EXOURL__c = url;
             c.Id = collateralid;
             //c.Sharepoint_Document_ID__c = docId;
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