public class hpContactUsPage 
{
    // attribute properties
    
    public string callfunc{get;set;}
    
    public String strMsgClass { get; set; }
    public String strEmptyControlName {get;set;}
    
    // other properties
    public string strFirstName {get;set;}
    public string strLastName {get;set;}
    public string strCompanyName {get;set;}
    public string strEmailAddress {get;set;}
    public String strPhoneNumber { get; set; }
    public String strIntrestedInSolution {get;set;}
    public String strIntrestedInSolutionProvider {get;set;}
    public String strIsReseller {get;set;}
    public string strOpenResponse {get;set;}
    public string strTaskQuery {get;set;}
    public boolean isLoggedIn { get; set; }    
    public lead newLead {get;set;}
    public String SiteName{get;set;}
    public string isInserted {get; set;}
    public pagereference pageToRedirect;
    public string LoggedInUser{get;set;}
    public string logintype{get;set;}
    public contact objContact{get;set;}
    public User objUser{get;set;}
    public Account objAccount{get;set;}
    public String  ProductIntForTask{get;set;}
    
    public String  HomeredirectUrl {get;set;}
    public List<SelectOption> lstSelectOption {get; set;}
    public string strSelectedInterest{get; set;}
    
     //-----------Captcha Variable Declaration------------
    //Captcha DomainName: hphpportal.com.   
    //Assign Private & Public Key from custom label. 
    private static string secret = System.Label.hpCaptcha_Private_Key;
    public string publicKey { get { return System.Label.hpCaptcha_Public_Key; }} 
    private static string baseUrl = 'http://www.google.com/recaptcha/api/verify';     
    public string challenge {get; set;} { challenge = null; } 
    public string response {get; set; }  { response = null; }    
    public Boolean correctResponse { get; set; } { correctResponse = false; } 
    
    public boolean testlogin= false;
    
    // Constructor
    // Input Parameters :
    //      - None
    // Returns: 
    //      - None
    // Version#   Date             Author                    Description
    // ------------------------------------------------------------------------
    // 1.0        07-Aug-2012      Neeraj Chauhan            Initial Version
    // ------------------------------------------------------------------------
    public hpContactUsPage ()
    {
        
        
        strFirstName = '';
        strLastName = '';
        strCompanyName = '';
        strEmailAddress = '';
        strPhoneNumber = '';
        strIntrestedInSolution = '0';
        strIntrestedInSolutionProvider = '0';
        strIsReseller = '0';
        strOpenResponse = '';
        strTaskQuery = ''; 
        isLoggedIn = false;
        strEmptyControlName = '';
        SiteName = '';
        newLead = new Lead();
        isInserted = 'false'; 
        ProductIntForTask = '';       
        LoadData();
        HomeredirectUrl ='';
        
        
        lstSelectOption = new List<SelectOption>();
     
         lstSelectOption.add(new SelectOption('--None--', '--None--'));
         lstSelectOption.add(new SelectOption('Solution', 'Solution'));
         lstSelectOption.add(new SelectOption('Solutions Provider', 'Solutions provider'));
         lstSelectOption.add(new SelectOption('Re-seller', 'Re-seller'));
         
    }
    
    // Method to load initial data
    // Input Parameters :
    //      - None
    // Returns: 
    //      - none
    // Version#   Date             Author                    Description
    // ------------------------------------------------------------------------
    // 1.0        07-Aug-2012      Neeraj Chauhan            Initial Version
    // ------------------------------------------------------------------------
    public void LoadData()
    {
        
        
        if((new hpCommon()).IsUserLoggedIn())
        {
            SiteName = Site.getName();
        
        LoggedInUser  = UserInfo.getUserId();
        
        logintype = ApexPages.currentPage().getparameters().get('logintype');
        
        system.debug('logintype*******' +logintype) ;
            
            if((new hpCommon()).GetLoggedInContactId() != null)
            objContact = [SELECT FirstName, LastName, Account.Name,  Email, Phone FROM Contact where Id=:(new hpCommon()).GetLoggedInContactId()];
            system.debug('objContact----'+objContact);
            objUser = [SELECT FirstName, LastName,  Email, Contact.AccountId,Phone FROM User where Id=:LoggedInUser];
            
           if(site.getname()  == null)
            {
                strFirstName = objUser.FirstName == null ? '' : objUser.FirstName;
                strLastName = objUser.LastName == null ? '' : objUser.LastName;
               
                strEmailAddress = objUser.Email == null ? '' : objUser.Email;
                strPhoneNumber = objUser.Phone == null ? '' : objUser.Phone;
                
                
                strCompanyName = ' '; //Adding for test class condition 
             }   
         
         else
         {
           
             if(objContact != null)
             {
                strFirstName = objContact.FirstName == null ? '' : objContact.FirstName;
                strLastName = objContact.LastName == null ? '' : objContact.LastName;
                strCompanyName = objContact.Account.Name == null ? '' : objContact.Account.Name;
                strEmailAddress = objContact.Email == null ? '' : objContact.Email;
                strPhoneNumber = objContact.Phone == null ? '' : objContact.Phone;
             }   
                
         } 
            
            
            isLoggedIn = true;
        }
    }
    
    // Method to save details(If Logged in: It creates Task, If not Logged in: It creates Lead)
    // Input Parameters :
    //      - None
    // Returns: 
    //      - none
    // Version#   Date             Author                    Description
    // ------------------------------------------------------------------------
    // 1.0        07-Aug-2012      Neeraj Chauhan            Initial Version
    // 1.1        24-Jul-2013      Vivek Kumar Sharma        Update Version
    // ------------------------------------------------------------------------
    public PageReference SaveDetails() 
    {
        
       // System.debug('ProductIntForTask**' +ProductIntForTask);
        
        //System.debug('strLastName****' + strLastName );
        //System.debug('strEmailAddress***' +strEmailAddress);
        //System.debug('strCompanyName****'+strCompanyName );
        
        
      /*  if(strLastName =='' || strEmailAddress=='' ||strCompanyName ==''){
            //callfunc = '<script>reLoadCaptcha();</script>';
            strMsgClass = 'errorMsgNf';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Enter_Required_Fields));
            return null;
            
        } */
        
        
       
        
       if(site.getname()  == null)
        {
        
        if(strLastName =='' || strEmailAddress==''  ){
            strMsgClass = 'errorMsgNf';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Enter_Required_Fields));
            return null;
        }
        
        }
        
        else{
        if(strLastName =='' || strEmailAddress=='' || strCompanyName == '' ){
            strMsgClass = 'errorMsgNf';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Enter_Required_Fields));
            return null;
        }
        
        } 
        
        system.debug('UserLogin----'+(new hpCommon()).IsUserLoggedIn());
        
        
        if(!Test.isRunningTest())
        testlogin = (new hpCommon().IsUserLoggedIn());
        
        if(testlogin)
        {
            
            
            system.debug('--strEmailAddress----'+strEmailAddress);
            if(!hpCommon.IsNullOrEmpty(strEmailAddress))
            {
                 if(hpCommon.IsNullOrEmpty(strTaskQuery))
                 {
                   // callfunc = '<script>reLoadCaptcha();</script>';
                    strMsgClass = 'errorMsg';
                    strEmptyControlName = 'Query';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_TaskQuery));
                    return null;
                 }
                
                //Called Captcha method.
                verify();
            
                //Validate Captcha.
                if(correctResponse == false)
                {                   
                    strMsgClass = 'errorMsg';                   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.hpCaptcha_Validation_Error));
                    return null;        
                }
                
            
                Task newTask = new Task(); 
                /*Commneted By : Vivek 
                * Commented Date : 29/July/2013
                * According to discussion with Bijay he said comment these fields */
                /*newTask.Full_Name__c = strFirstName +' '+ strLastName;
                newTask.Company_Name__c = strCompanyName;
                newTask.Phone_Number__c = strPhoneNumber;
                newTask.Email_Address__c = strEmailAddress;
                */
               // newTask.Subject = 'Contact us re: ' + ProductIntForTask;
               
               newTask.Subject = 'Contact us re: ' + strSelectedInterest;
                
                newTask.Description = strTaskQuery;   
                
                newtask.activitydate = system.today();                 
                strEmptyControlName = '';
                
               
            
               string mstrWhoId = null;
               string mstrWhatId = null;
               
               if(hpCommon.GetLoginType() != 'customer')
                mstrWhoId = (new hpCommon()).GetLoggedInContactId();   //changed by naveen
               
               if(mstrWhoId != null)
                   newTask.WhoId = mstrWhoId;
               
                //system.debug('(new hpCommon()).GetLoggedInContactId()***' + (new hpCommon()).GetLoggedInContactId());
                
                //system.debug('(new hpCommon()).GetLoggedInContactId()WhatId***' + (new hpCommon()).GetLoggedInContactId().AccountId);
                
                
                
                //newTask.WhoId = [Select AccountId from contact where Id =: (new hpCommon()).GetLoggedInContactId()].AccountId;
                //system.debug('--newTask.WhoId----'+newTask.WhoId);
            
                //RecordType objRecordType = [Select Id from RecordType where Name='ISV Activities' and SobjectType='Task' limit 1];
                //if(objRecordType != null)   
                    //newTask.RecordTypeId = objRecordType.Id;
                
                if((new hpCommon()).GetLoggedInContactId() != null)
                  mstrWhatId = [Select AccountId from contact where Id =: (new hpCommon()).GetLoggedInContactId()].AccountId;
                
                
                //system.debug('newTask.WhatId**'+ newTask.WhatId) ;
                
                if(mstrWhatId != null)
                {
                if(hpCommon.GetLoginType() != 'customer')
                    newTask.WhatId = mstrWhatId;
                    
                    objAccount = [Select OwnerId from Account where id =: mstrWhatId] ;
                    newTask.ownerId = objAccount.OwnerId; //'005d0000000fHj4';
                }
                objUser = [SELECT FirstName, LastName,  Email, Contact.AccountId,Phone FROM User where Id=:LoggedInUser];
                
                            
                
                insert newTask; 
                isInserted = 'true';
                //system.debug('--TestTask----'+newTask);
                //strMsgClass = 'successMsg';
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpContactUs_Task_Insert_Success));
                ResetFields();
            }
            else
            {
                //callfunc = '<script>reLoadCaptcha();</script>';
                strMsgClass = 'errorMsgNf';
                strEmptyControlName = 'Email';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Enter_Required_Fields));
            }
            
            
            
              
        }
        else
        {   
            system.debug('TestElse----');
            if(!hpCommon.IsNullOrEmpty(strEmailAddress) && !hpCommon.IsNullOrEmpty(strLastName) && !hpCommon.IsNullOrEmpty(strOpenResponse))
            {
                if(!hpCommon.IsEmailValid(strEmailAddress))
                {
                   // callfunc = '<script>reLoadCaptcha();</script>';
                    strMsgClass = 'errorMsg';
                    strEmptyControlName = 'Email';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Invalid_Email));
                    return null;
                }
                //Called Captcha method.
                verify();
               // newLead = new Lead();
             //Validate Captcha.
                if(correctResponse == false)
                {                   
                    strMsgClass = 'errorMsg';                   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.hpCaptcha_Validation_Error));
                    return null;        
                }
             
                newLead.FirstName = strFirstName;
                newLead.LastName = strLastName;
                newLead.Company = strCompanyName;
                 
                newLead.Email = strEmailAddress;
                strEmptyControlName = '';
               
                
                newLead.Phone = strPhoneNumber;
                //newLead.hpIsInterested_in_a_solution__c= strIntrestedInSolution == '0' ? false : true;
                //newLead.hpIsInterested_in_a_solutions_provider__c = strIntrestedInSolutionProvider == '0' ? false : true;
                //newLead.hpIsReseller__c = strIsReseller == '0' ? false : true;
                newLead.Description = strOpenResponse;
                
                //RecordType objRecordType = [Select Id, Name from RecordType where Name='ISV' and SobjectType='Lead' limit 1];
                //if(objRecordType != null)   
                  //  newLead.RecordTypeId = objRecordType.Id;
                newLead.Additional_Notes__c = strSelectedInterest;
                insert newLead;
                isInserted = 'true';
                //strMsgClass = 'successMsg';
                //system.debug('AnkitasuccessMsg--'+strMsgClass );
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpContactUs_Task_Insert_Success));
                ResetFields();
                
            }
            else
            {
               // system.debug('-----------'+strEmptyControlName);
                //callfunc = '<script>reLoadCaptcha();</script>';
                strMsgClass = 'errorMsg';
                if(hpCommon.IsNullOrEmpty(strEmailAddress))
                {
                    strEmptyControlName = 'Email';
                }
                else
                {
                    //system.debug('6666666');
                    strEmptyControlName = 'LastName';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Enter_Required_Fields));
                    return null;
                }
            }
            
           
        }
         
        //system.debug('TestSitename----'+ Site.getName());
        /*if(Site.getName()==null)
        {
          
            //PageReference pageRef = new PageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008XmIMAU');
            //pageRef.setRedirect(true);
            //return pageRef;
            
            //pageToRedirect =new PageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008XmIMAU');
            //pageToRedirect =new PageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008aId');
            
            
           //pageToRedirect  = new pageReference(hpCommon.getURL('Home'));
           //pageToRedirect.setRedirect(true);
           
           HomeredirectUrl = hpCommon.getURL('Home');
           system.debug('HomePag URL987*****' +HomeredirectUrl);
           
        }
        
        if(Site.getName()!=null)
        {
          HomeredirectUrl = hpCommon.getURL('default');
          
          HomeredirectUrl = '/hpdevice'+ HomeredirectUrl;
        
        }
        
        
        if((new hpCommon()).IsUserLoggedIn())
        {
            //return new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceSecureContHomePage'));
           
            //pageToRedirect = new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceSecureContHomePage'));
           //pageToRedirect =  new pageReference(hpCommon.GetPageUrlByVFTemplateName('HPDCSecureHomepage'));
           //pageToRedirect =  new pageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008aId');
             
          // pageToRedirect  = new pageReference(hpCommon.getURL('Home'));
           //pageToRedirect.setRedirect(true);
           
           HomeredirectUrl = hpCommon.getURL('Home');
           system.debug('HomePag URL567*****' +HomeredirectUrl);
           
            if(Site.getName()!=null)
            {
              HomeredirectUrl = hpCommon.getURL('Home');
              
              HomeredirectUrl = '/hpdevice'+HomeredirectUrl;
            
            }
           
        }
        else
        {
           // return new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceSecureContHomePage'));
          
            //pageToRedirect= new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceUnSecureContHomePage'));
            //pageToRedirect= new pageReference(hpCommon.GetPageUrlByVFTemplateName('HPDCUnsecureHomepage'));
             //pageToRedirect= new pageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008aHf');
             //pageToRedirect= new pageReference(hpCommon.getURL('default'));
             HomeredirectUrl = hpCommon.getURL('default');
             if(Site.getName()!=null)
            {
              HomeredirectUrl = hpCommon.getURL('default');
              
              HomeredirectUrl = '/hpdevice'+HomeredirectUrl;
            
            }
           
        }*/
         ///// HomeredirectUrl = hpCommon.getURL('thank-you-for-contact-us');
          HomeredirectUrl = hpCommon.getURL('thank-you-for-contact-us');
          
          
         system.debug('Site.getName()**' +Site.getName());
        
        if(Site.getName()!=null)
        {
        HomeredirectUrl = HomeredirectUrl = '/hpdevice'+HomeredirectUrl ;
        }
        
        if(Site.getName()==null)
        {
        HomeredirectUrl = HomeredirectUrl ;
        }
          
          //HomeredirectUrl = '/hpdevice' + HomeredirectUrl;
          
        /* pageToRedirect  = new pageReference(hpCommon.getURL('thank-you-for-contact-us'));
         pageToRedirect.setRedirect(true);*/
        return null;
    }
    public void goToRedirect()
    {
       //system.debug('----TestRedirect--'+pageToRedirect);
       if(Site.getName()==null)
       {
            /*Commented By Vivek on 24/July/2013
            *Access new contact us page
            */
            //pageToRedirect =new PageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008XmIMAU');
            /*pageToRedirect =new PageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008aId');            
            pageToRedirect.setRedirect(true);
             */
             
           //pageToRedirect  = new pageReference(hpCommon.getURL('Home'));
           //pageToRedirect.setRedirect(true);
           //return pageToRedirect ;
           
           HomeredirectUrl = hpCommon.getURL('default');
           //system.debug('HomePag URL123*****' +HomeredirectUrl);
           
       }
       else
       {
            //return pageToRedirect ;
            HomeredirectUrl = hpCommon.getURL('default');
            //system.debug('HomePag URL123456***' +HomeredirectUrl);
       }
    
    }
    public void ResetFields()
    {
        system.debug('TestingUser---'+!(new hpCommon().IsUserLoggedIn()));
        
        if(!Test.isRunningTest())
        testlogin = (!(new hpCommon()).IsUserLoggedIn());
        
        if(testlogin)
        
        {
            strFirstName = '';
            strLastName = '';
            strCompanyName = '';
            strEmailAddress = '';
            strPhoneNumber = '';
            strIntrestedInSolution = '0';
            strIntrestedInSolutionProvider = '0';
            strIsReseller = '0';
            strOpenResponse = '';
        }
        strTaskQuery = '';
        newLead = new Lead();
    }
    
    // Method is used Redirect on Home Page.
    // Input Parameters :
    //      - None
    // Returns: 
    //      - None
    // Version#   Date             Author                    Description
    // -------------------------------------------------------------------------
    // 1.0        21-Aug-2012      Neeraj Chauhan            Initial Version
    // -------------------------------------------------------------------------
    public PageReference GoToHomePage()
    {
       // system.debug('getname-----'+Site.getName());
        if(Site.getName()==null)
        {
           //PageReference pageRef = new PageReference('https://hp--admindev.cs10.my.salesforce.com/servlet/servlet.Integration?lid=01rJ00000000Oim&ic=1');  //updated by naveen 11-july-13
            //PageReference pageRef = new PageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceSecureContHomePage'));
            //Commented By Vivek
            //PageReference pageRef = new PageReference('/apex/page?pageid=a2SJ00000008XmIMAU');
           /* PageReference pageRef = new PageReference('/apex/page?pageid=a2SJ00000008aId');
            return pageRef;*/
            
           PageReference pageRef  = new pageReference(hpCommon.getURL('default'));
           pageRef.setRedirect(true);
           return pageRef;
        }
        
        if(!Test.isRunningTest())
        testlogin = ((new hpCommon()).IsUserLoggedIn());
        
        if(testlogin)
        {
            /*Commented By Vivek on 24/July/2013*/
            //return new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceSecureContHomePage'));
            //return new pageReference(hpCommon.GetPageUrlByVFTemplateName('HPDCSecureHomepage'));
            //return new pageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008aId');
           PageReference pageRef  = new pageReference(hpCommon.getURL('default'));
           pageRef.setRedirect(true);
           return pageRef;
        }
        else
        {
        /*Commented By Vivek on 24/July/2013*/
            //return new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceUnSecureContHomePage'));
            //return new pageReference(hpCommon.GetPageUrlByVFTemplateName('HPDCUnsecureHomepage'));
            //return new pageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008aHf');
           PageReference pageRef  = new pageReference(hpCommon.getURL('default'));
           pageRef.setRedirect(true);
           return pageRef;
        }
        return null;
    }  
    
    //-----------------Implimentation for Captcha.---------------------------
    
    // ------------------------------------------------------------------------
    //This method is used to verify the entered text in Captcha. This method called in Submit method.
    // Input Parameters:
    //      - None
    // Returns: 
    //      - Nothing
    // Version#      Date            Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0         27-Aug-2012    Piyush singh            Initial Version
    // ------------------------------------------------------------------------------------------- 
    public Pagereference verify() 
    {
        //system.debug( 'verify called ');
        // first time thru, this parameter is null, so no request to make yet
        if( challenge == null || response == null ) 
        { 
            //system.debug( 'verify called null ');
            return null; 
        }
                    
        HttpResponse r = makeRequest(  baseUrl , 'privatekey='+ secret + '&remoteip=' + remoteHost + '&challenge=' + challenge + '&response=' + response + '&error=incorrect-captcha-sol');
        
        if ( r != null ) 
        {  
            // is null when test methods run
            correctResponse = ( r.getBody().contains('true') );
        } 
   
        return null;    
    }
    
     // ------------------------------------------------------------------------
    //This method is used to reset the Captcha.
    // Input Parameters:
    //      - None
    // Returns: 
    //      - Nothing
    // Version#      Date            Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0         27-Aug-2012    Piyush singh            Initial Version
    // ------------------------------------------------------------------------------------------- 
    public PageReference reset() 
    {
        challenge = null;
        response = null; 
        return null; 
    }   
    
    // ---------------------------------------------------------------------------------------------------------------
    //This method is used to make a request on captcha server by using url & body. This method called in Verify method. 
    // Input Parameters:
    //      - Request Url string, string body
    // Returns: 
    //      - return server response.
    // Version#      Date            Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0         27-Aug-2012    Piyush singh            Initial Version
    // ------------------------------------------------------------------------------------------- 
    public static HttpResponse makeRequest(string url, string body)  
    {
        //Http request on captcha server through POST method.
        HttpRequest req = new HttpRequest();   
        HttpResponse response = null;
        req.setEndpoint( url );
        req.setMethod('POST');
        req.setBody ( body);
        try 
        {
            Http http = new Http();
            response = http.send(req);
            System.debug('response: '+ response);
            System.debug('body: '+ response.getBody());       
        } catch( System.Exception e) 
        {
         System.debug('ERROR: '+ e);
        }
        return response;
    }  
     
    // ---------------------------------------------------------------------------------------------------------------
    //This method is used to get remote host & take visualforce page name on which captcha applied.  
    // Input Parameters:
    //      - None
    // Returns: 
    //      - return page header.
    // Version#      Date            Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0         27-Aug-2012    Piyush singh            Initial Version
    // -------------------------------------------------------------------------------------------     
    public string remoteHost 
    { 
        get 
        { string ret = '127.0.0.1';
            // also could use x-original-remote-host 
            
            PageReference pageRef = new PageReference(hpCommon.getURL('contactus'));
            map<string , string> hdrs = ApexPages.currentPage().getHeaders();
            if ( hdrs.get('x-original-remote-addr') != null)
                ret =  hdrs.get('x-original-remote-addr');
            else if ( hdrs.get('X-Salesforce-SIP') != null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        } 
    }
}