public class inputfilecontroller {

public blob UploadValue {get;set;}
public string Url{get;set;}
public string CollateralId{get;set;}

    public void UpdateDocUrl()
    {
    string url=Url;
    string topicId=null;
    string collateralid=CollateralId;
    system.debug('URL:'+url+',CollateralId:'+collateralid);
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
             
            
           }
}