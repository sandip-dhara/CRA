public with sharing class hpThankYou {
    public boolean isLoggedIn { get; set; }   
    public string mstr_message {get; set; }
    public String SiteName{get;set;}
    public string LoggedInUser{get;set;}
    public string logintype{get;set;}
        
 public hpThankYou(){
     isLoggedIn = false;
     SiteName  = '';
     LoggedInUser = '';
     logintype = '';
     LoadData();
 }
  public void LoadData()
   {   
         SiteName = Site.getName();
        
        LoggedInUser  = UserInfo.getUserId();
        
        logintype = ApexPages.currentPage().getparameters().get('logintype');
        
        system.debug('logintype*******' +logintype) ;
   
        if((new hpCommon()).IsUserLoggedIn())
        {
            isLoggedIn = true;

        }
      mstr_message = 'Hello Vivek';
   }
}