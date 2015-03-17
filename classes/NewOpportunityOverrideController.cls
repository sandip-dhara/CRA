/**********************************************************
* Class Name: NewOpportunityOverrideController
* Author: Accenture
* Date: 30-March-2012 
* Requirement # Request Id:
* Description: Controller class for Sales process linkage Add page
***********************************************************/
public class NewOpportunityOverrideController {
    
    /**
    * @description: Class Constructor method
    * @param: Class Controller Apex Page
    * 
    */
    public NewOpportunityOverrideController(ApexPages.StandardController controller) {
        
    }
    
   	/**
    * @description: Redirects to standard new opportunity page & passes extra url
    *               parameters to default some values like Stage on new opportunity
    * @return: return page url
    * 
    */
    public Pagereference redirect() {
        Pagereference pgRef;
        //navigationURL = '/006/e?opp11=01 - Understand Customer&nooverride=1';
        String navigationURL = Label.HP_New_Opty_URL;
        pgRef = new Pagereference(navigationURL);
        
        map<String, String> mapUrlParam = Apexpages.currentPage().getParameters();
        if(mapUrlParam != null && mapUrlParam.size() > 0) {
            if(mapUrlParam.containskey('sfdc.override')) {
                mapUrlParam.remove('sfdc.override');
            }
            if(mapUrlParam.containskey('save_new')) {
                mapUrlParam.remove('save_new');
            }
            for(String key : mapUrlParam.keyset()){
                pgRef.getParameters().put(key,mapUrlParam.get(key));
            }    
        }
        pgRef.setRedirect(true);
        return pgRef;
    }
}