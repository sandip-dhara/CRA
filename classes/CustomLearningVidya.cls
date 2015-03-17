public with sharing class CustomLearningVidya{
    private ApexPages.StandardController myStdController;
    public String queryString {get;set;}
    
    /*** CONSTRUCTOR ***/
    /*https://hp--esit--c.cs11.visual.force.com/s.gif*/
    public CustomLearningVidya(ApexPages.StandardController stdController) {
        myStdController = stdController;
        PageReference thisPage = ApexPages.currentPage();
        List<String> url = thisPage.getUrl().split('\\?');
        queryString = url[1];
    }

    /*** ACTIONS ***/
    public PageReference savennew(){
        try {
            myStdController.save();
            
            Schema.DescribeSObjectResult describeResult = myStdController.getRecord().getSObjectType().getDescribe();
            
            PageReference pr = new PageReference('/' + describeResult.getKeyPrefix() + '/e?' + queryString);
            pr.setRedirect(true);
            return pr;  

        } catch(System.DMLException e) {
            // Note: not spitting out any error messages, as SF seems to be handling the errors fine, at least for my simple object; your mileage my vary.
            return null;
        }
    }
}