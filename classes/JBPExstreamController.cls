/**********************************************************
* Class Name: JBPExstreamController 
* Author: HP Release 5
* Date: 05-March-2013 
* Auth:- HP 
* Requirement # Request Id:5414
* Description: Controller class used to generate the ppt via SFDC->Tibco->JMS Queue->HP exstream.
* PPT_Translation__c table used to translate the pick list values at Tibco.Check the SOQL at Tibco.
***********************************************************/
global class JBPExstreamController {

  public  String jbpId='';
  public  String pptLanguage{get;set;}
  public  String currencyCode{get;set;}
  //To close the window-popup
  public  String success{get;set;}
  public  String isPartnerEnabled{get;set;}
  public  String isCompetitiveLandscapeSelectedForExport{get;set;}
  public  String isStrategicInitiativesDetailSelectedForExport{get;set;}
  public  String isStrategicInitiativesSummarySelectedForExport{get;set;}
  public  String isMetricsSelectedForExport{get;set;}
  public  String isFieldDefinitionsExport{get;set;}
 // Below Label used to for debug info in visual force page True/False- to see any errors (case sensitive) 
  public String debugFlagForAnyIssueAtTibco =Label.PPT_Debug_Flag;
  
  /*
  * This constructor used to initialize the jbp id and set the default JBP plan language and currency
  */     
   public JBPExstreamController() {
   
     jbpId = ApexPages.currentPage().getParameters().get('jbpId');
    String usersId =  UserInfo.getUserId();
       
     
    // Below code is to enable and disable the button for internal and Partner buttons
    List<User> userDetailsObjList = [SELECT IsportalEnabled FROM User where Id =:usersId limit 1];
   
    if(userDetailsObjList !=null){
      for(User userDetailsObject:userDetailsObjList){
             if(userDetailsObject.IsportalEnabled==true){
                 isPartnerEnabled= 'True';
                }
            else
             {
               isPartnerEnabled='False';
             }
          }
       }
        
     List<JBP__C> lstJbpList = [Select PPT_Export_Language__c,PPT_Export_Currency__c  from JBP__c where Id =:jbpId limit 1];       
       //Below condition used to to set the default language as 'English' .First if condition to show the alert in respective languages
      if(lstJbpList != null) {
      
        for(JBP__C lstJbpObj:lstJbpList){
        
           if(lstJbpObj.PPT_Export_Language__c != null)
             {
               this.pptLanguage = lstJbpObj.PPT_Export_Language__c; 
             } 
           }              
         } 
       else {
             this.pptLanguage= 'English';
        }
           
      //Below condition used to to set the default currency       
        if(lstJbpList != null)
           {
            for(JBP__C lstJbpObj:lstJbpList){
            
              PPT_Currency_Symbol__c pptCurrencyObj = [Select PPT_Currency_Code__c from PPT_Currency_Symbol__c where PPT_Currency_Code__c =:lstJbpObj.PPT_Export_Currency__c limit 1];
              //If JBP object contains the currency and not there in PPT_Currency_Code__c then below if and else condition will apply
                 if(pptCurrencyObj.PPT_Currency_Code__c != null) {
                     currencyCode = pptCurrencyObj.PPT_Currency_Code__c; 
                     }  
                 else {
                         this.currencyCode = 'USD';
                     }    
                }        
            } 
        else
           {
             this.currencyCode = 'USD';
           }  
    }
    
  /*
  * This method used to dynamically render the Language in drop down list in popup
  * and PPT_Language__c custome object contains Key and Value pair and third column same key maintained for respective language based on logged in user code
  */
  public List<SelectOption> getLanguage {get
        { 
         String userId =  UserInfo.getUserId(); 
         String languageCode='';
         List<SelectOption> optionsList= new List<SelectOption>();
         List<User> userDetailsObjList = [SELECT LanguageLocaleKey FROM User where Id =:userId limit 1];

         if(userDetailsObjList !=null){
          for(User userDetailsObject:userDetailsObjList){
            if(userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('es_MX') || userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('zh_TW') || userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('zh_CN') || userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('en_GB')){
              languageCode= userDetailsObject.LanguageLocaleKey; 
             }
            else{
               languageCode= userDetailsObject.LanguageLocaleKey.substring(0,2);    
              }
            }
          }
         else
          {
            languageCode= 'en';
          }
         
         List<PPT_Language__c> pptLanguageList = [Select Name from PPT_Language__c where PPT_Display_Language__c =:languageCode Order By Name];
         for(PPT_Language__c option : pptLanguageList )
            {
             if(option.Name!= null)
               optionsList.add(new SelectOption(option.Name,option.Name));            
            }
            return optionsList;
        }
        set;
      }
     
  /*
  * This method used to dynamically render the Country in drop down list in popup
  */      
   public List<SelectOption> getCurrency {get
        {          
         String userId =  UserInfo.getUserId(); 
         String languageCode='';

         List<User> userDetailsObjList = [SELECT LanguageLocaleKey FROM User where Id =:userId limit 1];

         if(userDetailsObjList !=null){
          for(User userDetailsObject:userDetailsObjList){
          // Simplified, traditional Chinese and Russian having different currency to value will be in respective languages and key will be in English so that DatedConversionRate can return the currency value
            if(userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('ru') || userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('zh_TW') || userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('zh_CN')){
              languageCode= userDetailsObject.LanguageLocaleKey; 
             }
            else{
               languageCode= 'en';   
              }
            }
          }
         else
          {
            languageCode= 'en';
          }
             
        List<SelectOption> optionsList= new List<SelectOption>();
        List<PPT_Currency_Symbol__c> pptCurrencyList = [Select PPT_Currency_Code_Key__c, PPT_Currency_Code__c from PPT_Currency_Symbol__c where PPT_Display_Code__c =:languageCode Order By PPT_Currency_Code__c];

        for (PPT_Currency_Symbol__c option : pptCurrencyList)
            {
             if(option.PPT_Currency_Code__c != null)
               optionsList.add(new SelectOption(option.PPT_Currency_Code_Key__c,option.PPT_Currency_Code__c));            
            }
            return optionsList;
        }
        set;
     }
     
    /*
     * This method used to call the HP Exstream via Tibco service and pptLanguageCode used for PPT and attachment and
     * loggedInUserLanguageCode used for email body in respective language
     */ 
   public PageReference invokeTibcoWsService() {
   
         system.debug('Entered into invokeTibcoWsService()');
           
           String userEmail='';
           String status = '';
           String country='';
           String currencySymbol='';
           String defaultCurrencyIsoCode ='';
           String metricCurrency='';
           String pptLanguageCode='';
           Date planCreatedDate;
           Double conversionRate1=1;
           Double conversionRate2=1;
           String loggedInUserLanguageCode='';
           String userId =  UserInfo.getUserId();
           Boolean isportalEnabled;
           
        try{    
          // PlanCreatedDate__c is formula field to get the createdTime from jbp object without the time stamp
           List<JBP__c> jbpObjList= [SELECT Plan_country__c,PlanCreatedDate__c,CurrencyIsoCode FROM JBP__c where Id =:jbpId limit 1];
           List<Metrics__c>  metricsObjList= [select CurrencyIsoCode from Metrics__c WHERE GbuSpecializationPlan__c in (select id from GBU_Specialization_Plans__c where Joint_Business_Plan__c=:jbpId) limit 1];
           List<User> userDetailsObjList = [SELECT email,IsportalEnabled,LanguageLocaleKey FROM User where Id =:userId limit 1];
           List<PPT_Currency_Symbol__c> pptCurrencyObjList = [Select Name from PPT_Currency_Symbol__c where PPT_Currency_Code__c =:currencyCode limit 1];
           List<PPT_Language__c> pptLanguageList = [Select PPT_Language_Code__c from PPT_Language__c where Name=:pptLanguage limit 1];
         
         if(jbpObjList!=null){ 
           for(JBP__c jbpObject :jbpObjList){
                country= jbpObject.Plan_country__c;
                planCreatedDate=jbpObject.PlanCreatedDate__c;
                defaultCurrencyIsoCode = jbpObject.CurrencyIsoCode;
             }
           }
           
         if(metricsObjList !=null){
           for(Metrics__c metricsObject : metricsObjList){
              metricCurrency =metricsObject.CurrencyIsoCode;
            } 
           }
          
          if(userDetailsObjList !=null){                
           for(User userDetailsObject:userDetailsObjList){
               userEmail = userDetailsObject.email;  
               isportalEnabled = userDetailsObject.IsportalEnabled;
               if(userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('es_MX') || userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('zh_TW') || userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('zh_CN')|| userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('en_GB') || userDetailsObject.LanguageLocaleKey.equalsIgnoreCase('pt_BR')){
                  loggedInUserLanguageCode = userDetailsObject.LanguageLocaleKey; 
                 }
               else{
                  loggedInUserLanguageCode = userDetailsObject.LanguageLocaleKey.substring(0,2);    
                 }             
             }
           }
           
          if(pptCurrencyObjList !=null){
           for(PPT_Currency_Symbol__c pptCurrencyObject :pptCurrencyObjList){
                currencySymbol = pptCurrencyObject.Name;                               
             }
            }
          // For English(Ke) passing the "en"(value)
          if(pptLanguageList != null){
             for(PPT_Language__c pptLanguageObject:pptLanguageList){
                pptLanguageCode= pptLanguageObject.PPT_Language_Code__c;             
             }
           }
        
          //Below method used for currency conversion, conversionRate1 is for Metric conversion and conversionRate2 for entire JBP plan.
          conversionRate1 = GetCoversionRate(metricCurrency,currencyCode,planCreatedDate);
          conversionRate2 = GetCoversionRate(defaultCurrencyIsoCode,currencyCode,planCreatedDate);  
       
          this.success='true';
          system.debug('jbpId1 '+jbpId+ 'pptLanguage '+pptLanguage+'pptLanguageCode'+pptLanguageCode+'currencyCode '+currencyCode+'userEmail '+userEmail+'currencySymbol '+currencySymbol+'conversionRate1  '+conversionRate1+'conversionRate2 '+conversionRate2 +'planCreatedDate' +planCreatedDate +'success'+success+'isFieldDefinitionsExport'+isFieldDefinitionsExport+'  isPartnerEnabled '+isPartnerEnabled+' loggedInUserLanguageCode  '+loggedInUserLanguageCode);         
          status = JBPWebSvcCallout.callWebservice(jbpId,userEmail,pptLanguage,pptLanguageCode,loggedInUserLanguageCode,country,currencyCode,currencySymbol,conversionRate1,conversionRate2,isFieldDefinitionsExport,isStrategicInitiativesSummarySelectedForExport,isCompetitiveLandscapeSelectedForExport,isMetricsSelectedForExport,isPartnerEnabled,isStrategicInitiativesDetailSelectedForExport);

          // To track how many end users are using the PPT export
           insertUsageMetric(userId); 
         }     
        catch(Exception e){
       /*  if(e.getMessage().contains('timed out')){
            this.success='true';
           }
         else{ */
           this.success=debugFlagForAnyIssueAtTibco;
       //  }
          system.debug('**Exception Occured while connecting the Tibco or HP Exstream ****' +  'Exception: ' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString() + '  '+success);
        }
       Pagereference pageRef=new Pagereference('/apex/JbpPptExportsCriteria?jbpId='+jbpId+'&success='+success);
       pageRef.setRedirect(true);
       return pageRef; 
    }
    
  /*
  * This method used to find the conversionRate for JBP plan creation date.
  * @ sfromCurrency  used to convert to @toCurrency
  * As we can't find the conversionRate in DatedConversionRate table so querying in between StartDate and NextStartDate 
  */ 
 public double GetCoversionRate(String sfromCurrency ,String toCurrency, Date sExchangeDate)
  {
    Double conversionRate=0.0;
    Double fromCurr_to_orgCon=1.0;
    Double fromTocurr_to_orgCon=1.0;
    
    if(sfromCurrency==toCurrency)
    {
        conversionRate=1.0;
    }
    else
    {
        List<String> currencyList= new List<String>{sfromCurrency,toCurrency};
        // Exm:-SELECT ISOCode, ConversionRate,StartDate, NextStartDate FROM DatedConversionRate WHERE ISOCode='INR'AND startdate <= 2000-01-01 and NextStartDate>2000-01-01 
        // Which will give StartDate =2000-01-01 and NextStartDate=2000-02-01
        List<DatedConversionRate> oConversionList=[SELECT ConversionRate,NextStartDate,StartDate,IsoCode 
                                                FROM DatedConversionRate
                                                 where IsoCode in :currencyList and StartDate<=:sExchangeDate and NextStartDate>:sExchangeDate];
   //     System.debug('*****************Conversion List**************'+oConversionList);
        if(oConversionList.isEmpty())
        {
         conversionRate=1.0;    
        }
        else
        {
          for(DatedConversionRate oCurrCon:oConversionList)
           {
             if(sfromCurrency==oCurrCon.IsoCode)
             {
                fromCurr_to_orgCon=oCurrCon.ConversionRate;
             }
             
             if(toCurrency==oCurrCon.IsoCode)
             {
                fromTocurr_to_orgCon=oCurrCon.ConversionRate;
             }
           }
        }                                        
        conversionRate= fromTocurr_to_orgCon/fromCurr_to_orgCon;                                    
    }
  //  System.debug('*****************************fromCurr_to_orgCon:'+fromCurr_to_orgCon+'\n**fromTocurr_to_orgCon****'+fromTocurr_to_orgCon);
   // System.debug('*****************Conversion Rate**************'+conversionRate);
    return(conversionRate);                                          
  }

 /*
  * This method used to increment PPT Usage Metrics --> ExportCount.
  * @ userId  used to retrieve user object from profile and increment Export Counter
  * Get user object from profile, get user record from PPT Usage Metric object if exists update counter, else insert record and start counter from 1 
  */ 
 public void insertUsageMetric(String userId)
  {
  String username;
  String userEmailId;
  String userCountryName;
  String userFirstName;
  String userLastName;
  String partnerAccountId;
  double userExportCount = 1;
  String planType = 'JBP';
  String userType;
  datetime userLastExportDate = datetime.now();
  
  try{
  
      // Below code is to retrieve User record
        List<User> userDetailsObjList = [SELECT Username, Email, Country, FirstName, LastName, Partner_account_ID__c FROM User where Id =:userId limit 1];
      //Retrieve PPT Metric Record where Username = userDetailsObjList.Username
          if(userDetailsObjList !=null){
              for(User userDetailsObject:userDetailsObjList){
                           username = userDetailsObject.Username;
                           userEmailId = userDetailsObject.Email;
                           userCountryName = userDetailsObject.Country;
                           userFirstName = userDetailsObject.FirstName;
                           userLastName = userDetailsObject.LastName;
                           partnerAccountId = userDetailsObject.Partner_account_ID__c; 
                           
                           if(partnerAccountId != null){
                            userType = 'EXTERNAL';
                           }
                           else
                           {
                            userType = 'INTERNAL';
                           }
                    
                    List<PPT_Usage_Metric__c> pptUsageMetricObjList = [SELECT Id, Name, UserExportCount__c FROM PPT_Usage_Metric__c where Name =:userDetailsObject.Username OR UserEmailId__c=:userDetailsObject.Email limit 1];
                    
                    if(pptUsageMetricObjList !=null && pptUsageMetricObjList.size()>0){ 
                    //If user already exists in PPT Usage Metric then get UserExportCount, Increment and Update the record-->UserExportCount                     
                       for(PPT_Usage_Metric__c pptUsageMetricObject:pptUsageMetricObjList){
                           userExportCount = pptUsageMetricObject.UserExportCount__c;
                           userExportCount++;                           
                           pptUsageMetricObject.UserLastExportDate__c = userLastExportDate;
                           pptUsageMetricObject.UserExportCount__c = userExportCount;                                                 
                           update(pptUsageMetricObject);
                       }
                    }
                    else{
                          //Else Insert User record and default the UserExportCounter to 1
                          PPT_Usage_Metric__c pptUsageMetric = new PPT_Usage_Metric__c();
                          pptUsageMetric.Name = username;
                          pptUsageMetric.UserEmailId__c = userEmailId;
                          pptUsageMetric.UserCountryName__c = userCountryName;
                          pptUsageMetric.UserFirstName__c = userFirstName;
                          pptUsageMetric.UserLastName__c = userLastName;
                          pptUsageMetric.PartnerAccountId__c = partnerAccountId;
                          pptUsageMetric.PlanType__c = planType;
                          pptUsageMetric.UserType__c = userType;
                          pptUsageMetric.UserExportCount__c = userExportCount.intValue();
                          pptUsageMetric.UserLastExportDate__c = userLastExportDate;
                          
                          insert pptUsageMetric;
                    }                         
               }
           }
      }
      catch(Exception e)
      {
        system.debug('**Exception Occured in method insertUsageMetric ****' +  'Exception: ' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
      }  
    }
}