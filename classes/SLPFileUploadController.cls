public with sharing class SLPFileUploadController {

public blob UploadValue {get;set;}
public string Url{get;set;}
public string CollateralId{get;set;}
public string CommunityId{get;set;}
public string LearningBoardId{get;set;}
public string TopicId{get;set;}
     
    public PageReference UpdateDocUrl()
    {
    string redirectUrl='';
    string id='';
    string url=Url;
    string topicid=TopicId;
    string collateralid=CollateralId;
    system.debug('Sree - In Upload Doc URL');
           If( topicId != ''){
                 Learning__c lb = new Learning__c();
                 lb.URL__c = url;
                 lb.Id = topicId;
                 update lb;
             }
            If( collateralid != ''){ 
                 Collateral__c c = new Collateral__c();
                 c.URL__c = url;
                 c.Id = collateralid;
                 update c;
             }
        if(CollateralId!='')
        {
        redirectUrl='/apex/SLP_EditCommunity';
        id=CommunityId;
        }
        
        if(LearningBoardId!='')
        {
        redirectUrl='/apex/AthenaEditLearningBoardDtls';
        id=LearningBoardId;
        }
        
        PageReference pRef = new PageReference(redirectUrl);
        pRef.getParameters().put('id',id);
        pRef.getParameters().put('u','y');
        pRef.setRedirect(true);
        return pRef;
    }
}