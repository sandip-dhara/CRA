public class HPDCMenu 
{
   public string urlHome{get;set;}
   public string urlSCRequest{get;set;}
   public string urlPortfolio{get;set;} 
   public list<HPMenu__c> Hpmenu{get;set;}
   public list<wrapper> lstWPMenu{get;set;}
   public list<String> lstMenuId{get;set;}
   public string submenuid{get;set;}
   public string desc1{get;set;}
   public HPMenu__c Objhpmenu{get;set;}
   public boolean IsuserloggedIn{get;set;}
   public pagereference pageToRedirect;
   public string homePage {get;set;}
   public string menuname{get;set;}    
   public transient boolean LoadJS{get; set;}
   
   /*Add by vivek*/
   public Contact objContact{get;set;}
    public string strUserName {get; set;}
    public string strPassword {get; set;}
    public string strErrorMessage;
    public string strNeedRegisterPageUrl {get; set;}
    public string returl{get;set;}
    public string strRegisterAsSalesRep{get; set;}
    public Page__c objpage{get;set;}
    
    public String msgClass { get; set; }
    public String strLastNameErrorCssClass {get; set;}
   /*End by vivek*/    
   
   public string MenuredirectUrl{get;set;}
   public boolean IsSiteLogin{get;set;}
   public string SignUpredirectUrl{get;set;}
   public string ContactusRedirectUrl{get;set;}
   public boolean IsTab{get;set;}
   public string strurl {get;set;}
   
    public HPDCMenu ()
    {  
//    test = ApexPages.currentPage();
    strurl = ApexPages.currentPage().getUrl();
    if(strurl.indexOf('apex/')> 0){
        strurl = strurl.split('apex/')[1];
    
        if(strurl.indexOf('hpTemplatePortfolio')> 0)
        {
            strurl= 'false';
        }else{
            strurl= 'true';
        }
    }else{
        strurl= 'true';
    }

    LoadJS = false;
        IsTab = true;
        Cookie tempCookie = ApexPages.currentPage().getCookies().get('tab'); 
        if(tempCookie != null){           
            if(tempCookie.getValue() != null){
                if(tempCookie.getValue() == 'true'){
                    IsTab = false;            
                }
            }
        }
             
        if(hpCommon.GetLoginType() == 'siteuser'){
            IsSiteLogin = true;
        }else{
            IsSiteLogin = false;
        }        
         
        urlHome = hpCommon.getURL('default');        //urlHome = hpCommon.getURL('Home');
        urlSCRequest = hpCommon.getURL('Leadrequest');
        urlPortfolio = hpCommon.getURL('Portfolio');
        
        strUserName ='';
        strPassword ='';
        lstWPMenu = new list<wrapper>();
        lstMenuId = new List<String>();
        strErrorMessage = '';
        objContact = new Contact();
      
        strNeedRegisterPageUrl  = hpCommon.GetPageUrlByVFTemplateName('HPDCSecureHomepage');
        returl = ApexPages.currentPage().getParameters().get('returl');
        
        
        if(!hpCommon.IsNullOrEmpty(returl) && returl !=''){
         returl  =  returl.replace('+', ' ');
         if(returl == 'Please enter all required fields')
            returl = null;
         }
        //system.debug('returl ***********' +returl );
        
      Hpmenu = new List<HPMenu__c>();
      List<HPMenu__c> tempLst = [Select id ,Name,Description__c, Order__c,ShortDescription__c, SiteURL__c , SubMenu__c ,SubMenuName__c, (Select id ,Description__c,ShortDescription__c,Name,  SiteURL__c , Order__c,SubMenu__c, SubMenuName__c from HPMenu__r where  SubMenu__c != null and Active__c = true order by Order__c) from HPMenu__c  where  SubMenu__c = null and Active__c = true order by Order__c];
      for(HPMenu__c ob: tempLst){
          if(ob.Description__c != null){
              Hpmenu.add(ob);
          }
      }      
      for(HPMenu__c ob1: Hpmenu){
          if(ob1.Description__c != null){
              wrapper wp = new wrapper();
              wp.Name = ob1.Name;
              String temp = ob1.Name.replace(' ','');
              wp.id = temp.trim();
              lstMenuId.add(temp.trim());
              wp.subMenu = new List<wrapper>();
              for(HPMenu__c ob2: ob1.HPMenu__r){
                wrapper wps = new wrapper();
                wps.Name = ob2.Name;
                wps.id = temp.trim();
                wp.subMenu.add(wps);  
              }
              lstWPMenu.add(wp);
          }
      }
      //system.debug('Hpmenu ****' +Hpmenu );
      
       //  homePage  = hpCommon.GetPageUrlByVFTemplateName('hpdcTemplateMemberLogin');
      
        Cookie cookie = ApexPages.currentPage().getCookies().get('conid');
        //System.Debug('cookie: ' + cookie);
        if(cookie == null || cookie.getValue() == null || cookie.getValue() == '')
            IsuserloggedIn = false;            
        else
                IsuserloggedIn = true;
            
      
         //IsSiteLogin = true;
         
         
       
         MenuredirectUrl =      hpCommon.getURL('services-details'); 
       
        if((new hpCommon()).IsUserLoggedIn())
        {          
           MenuredirectUrl =      hpCommon.getURL('services-details');
        }
        else
        {
           MenuredirectUrl =      hpCommon.getURL('services-details');
        }   
       
       SignUpredirectUrl = hpCommon.getURL('registration');
        
       ContactusRedirectUrl = hpCommon.getURL('contactus');    
            
    }
    
   /* public void getdescription()
    {
      //system.debug('getidtest**' + submenuid );
      
      if(submenuid != null)
      Objhpmenu = [Select id ,Name, Order__c,Description__c,ShortDescription__c,Menu__c , SiteURL__c , SubMenu__c ,SubMenuName__c from HPMenu__c  where  Active__c = true and id = : submenuid ];
    }*/
    
    
    public pagereference getdescription()
    {
            
             //system.debug('menuname*****' +menuname);
           // pageToRedirect =new PageReference('https://hp--admindev--c.cs10.visual.force.com/apex/hpdcAuthenticatedMenuDetailsTemplate?tab=+submenuid+');            
           pageToRedirect =new PageReference('https://hp--admindev--c.cs10.visual.force.com/apex/hpdcAuthenticatedMenuDetailsTemplate?menu='+menuname+'&tab='+submenuid);
           
            pageToRedirect.setRedirect(true);
            return pageToRedirect;
    }
   
   
    // Method to user login
    // Input Parameters :
    //      - None
    // Returns: 
    //      - pageReference : page
    // Version#   Date             Author                 Description
    // ------------------------------------------------------------------------
    // 1.0      24-July-2013   Vivek      Initial Version
    // ------------------------------------------------------------------------
    public pageReference login()
    {
        
       /* pagereference page = null;
        strErrorMessage =  system.label.hpCommon_Enter_Required_Fields;
        strUserName = 'Error';
        strPassword = 'Error';
        
   
        if(!hpCommon.IsNullOrEmpty(objContact.Username__c) &&
           !hpCommon.IsNullOrEmpty(objContact.Username__c.trim()) &&
           !hpCommon.IsNullOrEmpty(objContact.Password__c) &&
           !hpCommon.IsNullOrEmpty(objContact.Password__c.trim()))
        {
            
            strErrorMessage = system.label.hpMemberLogin_Invalid_User_Name;
            List<Contact> lstContact = [Select Id, 
                                               Password__c,
                                               Active__c 
                                        from Contact 
                                        where Username__c = :objContact.Username__c
                                        ];
            
            //system.debug('lstContact----------'+lstContact);                            
           
            if(lstContact != null && lstContact.size() == 1)
            {
               
                strErrorMessage = system.label.hpCommon_Invalid_Password;
                strUserName = '';
                
                if(lstContact[0].Password__c.equals(objContact.Password__c))
                {
                   
                    strErrorMessage = system.label.hpCommon_User_Inactive;
                    strPassword = '';
                    
                    if(lstContact[0].Active__c)
                    {
                        strErrorMessage = '';
                        
                        // set cookies
                        Cookie objCookie = new Cookie('conid', lstContact[0].Id, null, -1, false);
                        ApexPages.currentPage().setCookies(new Cookie[]{objCookie});
                        string strUrl = hpCommon.GetPageUrlByVFTemplateName('HPDCSecureHomepage');
                                                
                        // return on home page
                        //system.debug('Ankita'+ApexPages.currentPage().getCookies().get('conid') != null);
                        if(ApexPages.currentPage().getCookies().get('conid') != null)
                        {
                              strUrl = hpCommon.GetPageUrlByVFTemplateName('HPDCSecureHomepage');
                        
                        }
                        
                       if(returl != null && ApexPages.currentPage().getCookies().get('conid') != null)
                        {                          
                          objpage = [Select PageTemplate__c,
                                                Page_URL__c, 
                                                Id 
                                         from Page__c
                                         where id = :returl
                                         ];
                                         
                          strUrl = objpage.Page_URL__c;       
                          
                          if(returl == 'hpdcTemplateLeadRequestForm')
                             strUrl = hpCommon.GetPageUrlByVFTemplateName('hpdcTemplateLeadRequestForm');
                        }
                        
                     
                       page = new pagereference(strUrl);
                       page.setRedirect(true);
                   }
                }
            }
        }
        
        
        if(!hpCommon.IsNullOrEmpty(strErrorMessage))
        {            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, strErrorMessage));           
        }
        return page; */
        
        return null;  //edit for unsecure to secure , uncomment when deploy for unsecure case //3-sep-13
    }
    
    // Method to redirect on recover password page
    // Input Parameters :
    //      - None
    // Returns: 
    //      - pageReference : page
    // Version#   Date             Author                    Description
    // ------------------------------------------------------------------------
    // 1.0      24-May-2013     Vivek        Initial Version
    // ------------------------------------------------------------------------
    public pageReference recoverPassword()
    {   
        string strUrl = hpCommon.GetPageUrlByVFTemplateName('hpdcTemplateMemberLogin');
        if(!hpCommon.IsNullOrEmpty(strUrl))
        {
                strUrl += '?orderid=2';
        }
        pagereference page = new pagereference(strUrl);
        page.setRedirect(true);
        return page;
    }
    public pageReference LoginAsSalesRep()
    {   
        pagereference page = new pagereference('https://hp--admindev.cs10.my.salesforce.com/apex/page?pageid=a2SJ00000008aId&logintype=salesrep');
        page.setRedirect(true);
        return null;        
    }
    public pageReference Signup()
    {
       PageReference pageRef = null;
       pageRef  =new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpdcTemplateRegistrationPage'));
       
       pageRef.setRedirect(true);
       return pageRef;
    }
        
    
    public pageReference Contactus()
    {
       PageReference pageRef = null;
       //pageRef  =new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpdcTemplateContactUsPage'));
       pageRef  = new pageReference(hpCommon.getURL('contactus'));
       pageRef.setRedirect(true);
       return pageRef;
    }
    /*End By Vivek*/
    
    public PageReference LoginLogout()
    {
        //destroy the cookies in case of logout
        
       /*  if(ApexPages.currentPage().getCookies().get('logintype') != null)
         {
         
          return new pageReference('/secur/logout.jsp');
         
         } */
         
         if(hpCommon.GetLoginType() == 'internaluser')
        { 
          return new pageReference('/secur/logout.jsp');
        }
         
         
         else
        {
        if((new hpCommon()).IsUserLoggedIn())
        {
            Cookie conid = new Cookie('conid','' ,null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{conid});
            return new pageReference(hpCommon.getURL('default'));
        }
        
      }    
      return null;
    }
    
    
    public class wrapper{
        public string Name{get;set;}
        public string id{get;set;}
        public List<wrapper> subMenu{get;set;}
    }
}