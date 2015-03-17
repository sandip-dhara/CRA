public with Sharing  class AthenaLearnings {

    /*** PROPERTIES ***/
    private ApexPages.StandardController myStdController;
    public String queryString {get;set;}
    
    /*** CONSTRUCTOR ***/
    public AthenaLearnings(ApexPages.StandardController stdController) {
        myStdController = stdController;
        PageReference thisPage = ApexPages.currentPage();
        List<String> url = thisPage.getUrl().split('\\?');
        queryString = url[1];
    }

    /*** ACTIONS ***/
    public PageReference saveandnew(){
        try {
            myStdController.save();
            
            Schema.DescribeSObjectResult describeResult = myStdController.getRecord().getSObjectType().getDescribe();
            
            PageReference pr = new PageReference('/' + describeResult.getKeyPrefix() + '/e?' + queryString);
            pr.setRedirect(true);
            return pr;  } 
         catch(System.Exception e) 
         { 
         return null;
         }
    }
}