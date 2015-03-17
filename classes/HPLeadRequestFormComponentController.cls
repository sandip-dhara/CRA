public class HPLeadRequestFormComponentController 
{
    public boolean renderPnlSalesForce {get;set;}
    public boolean renderPnlUser{get;set;}
    public String msgClass { get; set; }
    public String SiteName{ get; set; }
    public String strLastNameErrorCssClass {get; set;}
    public String strEmailErrorCssClass {get; set;}
    public String strCompanyErrorCssClass {get; set;}
    public Lead Objlead { get; set; }
    public User ObjUser { get; set; }
    public User ObjLeadOwner { get; set; }
    public List<SelectOption> lstSelectOption {get; set;}
    public List<SelectOption> lstSelectOptionCustomozationreq {get; set;}
    public String strMessageText{get; set;}
    public pageReference x;
    public string y;
    public List<SelectOption> options{get;set;}
    public string isInserted {get; set;}
    public pagereference pageToRedirect;
    public Group ObjGroup{get;set;}
    public QueueSobject objQuery{get;set;}
    public string pageid{get;set;}
    public string Estimated_Unit_Volume {get; set;}
    public string Budgets{get; set;}
    public string Product_details {get; set;}
   
    public string strSelectedInterest{get; set;}
    public boolean testlogin = false;
    public string testsitename = null;
    
    
    
    public HPLeadRequestFormComponentController()
    {
      pageid = System.currentPageReference().getParameters().get('pageid');    
      Objlead = new lead();
      x = ApexPages.currentPage();
      y = ApexPages.currentPage().getURL();
       
      isInserted = 'true';
     RenderPanel();
     
     lstSelectOption = new List<SelectOption>();
     
     lstSelectOption.add(new SelectOption('--None--', '--None--'));
     lstSelectOption.add(new SelectOption('Custom App', 'Custom App'));
     lstSelectOption.add(new SelectOption('App Migration', 'App Migration'));
     lstSelectOption.add(new SelectOption('Laser Etch', 'Laser Etch'));
     lstSelectOption.add(new SelectOption('Color Bond', 'Color Bond'));
     lstSelectOption.add(new SelectOption('General Inquiry', 'General Inquiry'));
     
     system.debug('enter controller***');
     
     
    }
    public void RenderPanel()
    {
     if(hpCommon.GetLoginType() == 'internaluser'){
          renderPnlSalesForce = true;
          renderPnlUser = false;
      }
      else{
         renderPnlUser = true;
         renderPnlSalesForce = false;
      }
    }
    public pagereference  Submit()
    {    
         //system.debug('enter submit***');
         //system.debug('strSelectedInterest***' +strSelectedInterest);
         //system.debug('Lastname----'+Objlead.LastName);
         //system.debug('FirstName*****'+objlead.FirstName );
         //system.debug('Company*****'+objlead.Company  );
         //system.debug('Email*****'+objlead.Email ) ;
         //system.debug('Phone *****'+objlead.Phone  );
         //system.debug('Estimated_Unit_Volume__c*****'+objlead.Estimated_Unit_Volume__c ) ;
         //system.debug('Month__c *****'+objlead.Month__c  );
         //system.debug('Year__c *****'+objlead.Year__c ); 
         //system.debug('Budgets__c *****'+objlead.Budgets__c) ;
         //system.debug('Product_details__c *****'+objlead.Product_details__c) ;
        
        /* if(objlead.Estimated_Unit_Volume__c != null || objlead.Estimated_Unit_Volume__c != ''){
             if(objlead.Estimated_Unit_Volume__c == 'Eg: 30000')
                 objlead.Estimated_Unit_Volume__c = null;
         }
         
         if(objlead.Budgets__c!= null || objlead.Budgets__c!= ''){
             if(objlead.Budgets__c == 'Eg: 250000')
                 objlead.Budgets__c = null;
         }
         
         if(objlead.Product_details__c!= null || objlead.Product_details__c!= ''){
             if(objlead.Product_details__c== 'Eg: HP Elitebooks')
                 objlead.Product_details__c = null;
         }*/
         
         
         
         
         if(Objlead.FirstName == null || Objlead.FirstName == '' || Objlead.LastName ==null || 
            Objlead.LastName =='' || Objlead.Company ==null || Objlead.Company == '' || 
            objlead.Email ==null || objlead.Email =='' || objlead.Phone ==null || 
            objlead.Phone==''  ||
              Objlead.description == null || Objlead.description == '')
            //Objlead.Month__c == null || Objlead.Month__c == '' ||  Objlead.Year__c == null || Objlead.Year__c == ''  )// || objlead.Budgets__c == null || objlead.Budgets__c == '')// ||
            //objlead.Product_details__c == null || objlead.Product_details__c == '' || objlead.Estimated_Unit_Volume__c == null || objlead.Estimated_Unit_Volume__c == '')
          {
               RenderPanel();
               msgClass = 'errorMsgNf';
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Enter_Required_Fields));
               return null;
          } 
            if(hpCommon.IsEmailValid(objlead.Email))
            {
                //newLead.Email = strEmailAddress;
                // strEmptyControlName = '';
            }
            else
            {
                MsgClass = 'errorMsgNf';
                RenderPanel();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Invalid_Email));
                return null;
            }
                
                /*Add By Vivek On 24/July/2013
                *Check on hp contact email in null or blank*/
                
            /*   if(objlead.HP_Contact_e_mail__c != null && objlead.HP_Contact_e_mail__c != '')
               {
                    if(hpCommon.IsEmailValid( objlead.HP_Contact_e_mail__c))
                    {
                        //newLead.Email = strEmailAddress;
                       // strEmptyControlName = '';
                    }
                    else
                    {
                        MsgClass = 'errorMsgNf';
                        RenderPanel();
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Invalid_Email));
                        return null;
                    }
               }  */
             /*  if(hpCommon.GetLoginType() == 'internaluser'){
                   if( Objlead.working_with_a_specific_customer__c == 'Yes')
                   {
                      if(hpCommon.IsNullOrEmpty(objlead.Customer_Name__c))
                      {
                        MsgClass = 'errorMsgNf';
                        RenderPanel();
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Enter_Required_Fields));
                        return null;
                      }
                      if(hpCommon.IsNullOrEmpty(objlead.Customer_AMID_ID__c))
                      {
                        MsgClass = 'errorMsgNf';
                        RenderPanel();
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Enter_Required_Fields));
                        return null;
                      }
                   }
                   
                   if( Objlead.opportunity_registered_in_salesforce__c== 'Yes')
                   {
                      if(hpCommon.IsNullOrEmpty(objlead.Opportunities_Id__c))
                      {
                        MsgClass = 'errorMsgNf';
                        RenderPanel();
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.hpCommon_Enter_Required_Fields));
                        return null;
                      }                    
                   }
                   
               } */
               /*End By Vivek on 24/July/2013*/
                
          ObjUser = [Select Id, ContactId, AccountId From User Where Id = : UserInfo.getUserId()];
          system.debug('ObjUser------'+ObjUser);
          
          //ObjLeadOwner = [Select Id, ContactId, AccountId From User Where email =  'manvir.sandhu@hp.com'];
          //system.debug('ObjLeadOwner------'+ObjLeadOwner);
          
          
          ObjGroup = [Select RelatedId, Name, Id, DeveloperName From Group  where DeveloperName ='Queue_For_Lead_Request'];
          //system.debug('ObjGroup***' +ObjGroup);
          //system.debug('ObjGroup.id***' +ObjGroup.id);
          
        /*  if(ObjGroup != null)
          {
              //objQuery = [Select Id From QueueSobject where Id =: ObjGroup.Id];
              objQuery = [Select Queue.Name, Queue.Id, QueueId, Id From QueueSobject  where Queue.Id =: ObjGroup.Id];
              
              system.debug('objQuery***' +objQuery.id);
          } */
          
          if(ObjUser != null)
          {
            //objlead.Account_Name__c = ObjUser.AccountId;// comment for unsecure to secure
            //objlead.OwnerId = ObjLeadOwner.id;
             
             if(ObjGroup != null)
          {
              objlead.OwnerId =ObjGroup.id;
          }
          
          }
          //Objlead.Timing__c = Objlead.Month__c + ', ' + Objlead.Year__c;
          Objlead.Additional_Notes__c = strSelectedInterest;
         // system.debug('strSelectedInterest***' +strSelectedInterest);
         // system.debug('Objlead.Additional_Notes__c***' +Objlead.Additional_Notes__c);
         insert objlead;
         //system.debug('objleadn***' +objlead.id);
         
         if(objlead.id != null)
         {
             isInserted = 'true';
         }
         
         if(objlead.id !=null || objlead.id !='')
         { 
                // system.debug('TestSitename----'+ Site.getName());
             
            if(!Test.isRunningTest())
            
            testlogin = (new hpCommon().IsUserLoggedIn());
            
            system.debug('testlogin*****'+ testlogin);
            if(testlogin)
            // if(new hpCommon().IsUserLoggedIn())
             {
                //return new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceSecureContHomePage'));
       
                //pageToRedirect= new pageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008aId');
               if(hpCommon.GetLoginType() == 'internaluser'){
                    pageToRedirect  = new pageReference(hpCommon.getURL('thank-you-for-lead'));
                    pageToRedirect.setRedirect(true);
                    return pageToRedirect ;
                }else{
                   pageToRedirect  = new pageReference(hpCommon.getURL('thank-you-for-lead'));
                }
             }
             else
             {
               // return new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceSecureContHomePage'));
               //pageToRedirect= new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceSecureContHomePage'));
       
               if(hpCommon.GetLoginType() == 'internaluser'){
                    pageToRedirect  = new pageReference(hpCommon.getURL('thank-you-for-lead'));
                    pageToRedirect.setRedirect(true);
                    return pageToRedirect ;
                }else{
                   pageToRedirect  = new pageReference(hpCommon.getURL('thank-you-for-lead'));
                }
               
             }
             
            //if(!Test.isRunningTest())
            
            //testsitename = (Site.getName());
            
            
            //if(testsitename == null )
             
            if(Site.getName()==null)
             {
                if(hpCommon.GetLoginType() == 'internaluser'){
                    pageToRedirect  = new pageReference(hpCommon.getURL('thank-you-for-lead'));
                    pageToRedirect.setRedirect(true);
                    return pageToRedirect ;
                }else{
                   pageToRedirect  = new pageReference(hpCommon.getURL('thank-you-for-lead'));
                }
            
             }
             
         }     
      
      Objlead = new lead();
      
      return null;
    }
    
    
    
    public pagereference goToRedirect()
    {
        //system.debug('----TestRedirect--'+pageToRedirect);
       
       
      //system.debug('----TestRedirect--'+pageToRedirect);
       if(Site.getName()==null)
       {
            //pageToRedirect =new PageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008aId');
            pageToRedirect  = new pageReference(hpCommon.getURL('Home'));
            pageToRedirect.setRedirect(true);
            return pageToRedirect ;
       }
       else
       {
            return pageToRedirect ;
       } 
       
       return null;
    
    }
    
    public pagereference Cancel()
    {
       //system.debug('TestSiteCancel-----'+Site.getName());
       if(hpCommon.GetLoginType()== 'internaluser' )
        {    
            PageReference pageRef  = new pageReference(hpCommon.getURL('Home'));
            pageRef.setRedirect(true);
            return pageRef;
        }
        
        //if(!Test.isRunningTest())
            
           // testlogin = (new hpCommon().IsUserLoggedIn());
            
           // system.debug('testlogin*****'+ testlogin);
           // if(testlogin)
           // {
        if((new hpCommon()).IsUserLoggedIn()){
                
                //return new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceSecureContHomePage'));
               // return new pageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008aId');
               PageReference pageRef  = new pageReference(hpCommon.getURL('Home'));
               pageRef.setRedirect(true);
               return pageRef;
        }
        else
        {
            //return new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateHPDeviceUnSecureContHomePage'));
            
           PageReference pageRef  = new pageReference(hpCommon.getURL('default'));
           pageRef.setRedirect(true);
           return pageRef;
        }
        return null;
    }
    
    public PageReference CheckIsUserLoggedIn() 
    {
        SiteName = Site.getName();
        //system.debug('111111111'+SiteName);
        //system.debug('new hpCommon().IsUserLoggedIn()****before' +new hpCommon().IsUserLoggedIn());
        if((new hpCommon()).IsUserLoggedIn() &&  Site.getName() !=null)
        {
            //return new pageReference(hpCommon.GetPageUrlByVFTemplateName('hpTemplateLeadRequestForm'));
            
           PageReference pageRef  = new pageReference(hpCommon.getURL('Leadrequest'));
           pageRef.setRedirect(true);
           return pageRef;
       
        } 
        if(Site.getName()==null)
        { //Lead page Should be chage
           
            //PageReference pageRef = new PageReference('https://hp--admindev--c.cs10.visual.force.com/apex/page?pageid=a2SJ00000008Z8t&logintype=salesrep'); 
            PageReference pageRef  = new pageReference(hpCommon.getURL('Leadrequest'));
            pageRef.setRedirect(true);
            return pageRef;
        } 
        else
        {           
           return new pageReference(hpCommon.GetLoginPageUrl());//+'?returl=hpdcTemplateLeadRequestForm');
        }
    }
    
}