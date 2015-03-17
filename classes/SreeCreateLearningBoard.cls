public class SreeCreateLearningBoard {

    public SreeCreateLearningBoard(ApexPages.StandardController controller) {

    }


    public string TestCreate {get;set;}
    Public String strSearchValue{get;set;}
    public String LBName{get;set;}
    public String LBDescription{get;set;}   
        
    public SreeCreateLearningBoard() 
    {

    }   
    
     
    public PageReference  RedirectToSLP_GlobalSearch()
    {            
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
       
    Public String getStaticImagePath{
    get{
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
        }
    }
  
    Public String getSfInstance
    {
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    Public User GetLoggedinUserDtls()
    {
        User u = [Select Name,SmallPhotoUrl From User where User.id= :UserInfo.getUserId()];
        return U;
    }
     
 
    public PageReference CreateLrngBrd()
    {
        system.debug('testDebug:'+TestCreate);
        PageReference pRef = ApexPages.currentPage();
        
        //Learning_Board__c lrngBrd=new Learning_Board__c();        
        SreeLB__c lrngBrd=new SreeLB__c();
        
        lrngBrd.Name__c = LBName;
        lrngBrd.Description__c = LBDescription;
        system.debug('>>>>>>>>>>>>>>>>'+LBName);
        system.debug('<<<<<<<<<<<<<<<<'+LBDescription);
        insert lrngBrd;
       // pRef = new PageReference('/apex/AthenaEditLearningBoardDtls?id=' + this.LrngBrdId);
       pRef = new PageReference('/apex/AthenaSocialLearning');
       
        pRef.setRedirect(true);
        return pRef;
     }   
    
      private static String GetResourceURL(String resourceName)  
      {  
        //Fetching the resource 
        string resourcepath='';
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL          
           resourcepath= '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
        }  
        return resourcepath;  
       }
       
    //Search the Learning board: redirects to social learning page to display the search results
    public PageReference dosearch()
    {
        PageReference pRef = new PageReference('/apex/athenaSocialLearning');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
}