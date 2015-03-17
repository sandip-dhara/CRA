global class inputfilecontroller2 {

public blob UploadValue {get;set;}

 public inputfilecontroller2()
     {
     }
     
 @RemoteAction
    global static string UpdateDocUrl(String url, String topicId, String collateralid)
    {
    system.debug('Sree - In Upload Doc URL');
           If( topicId != null){
                 Learning__c lb = new Learning__c();
                 lb.URL__c = url;
                 lb.Id = topicId;
                 update lb;
             }
            If( collateralid != null){ 
                 Collateral__c c = new Collateral__c();
                 c.URL__c = url;
                 c.Id = collateralid;
                 update c;
             }
        return null;
    }
}