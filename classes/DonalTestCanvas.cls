public with sharing class DonalTestCanvas{

    public String jsonParms {get; set; }
    public boolean controllerRenderBoolVar { get; set; }
    public string strSearchValue{get;set;}
    Public String getSfInstance{
        get{
            return ApexPages.currentPage().getHeaders().get('Host');
            }
    }
    public string strSelectedOptions{get;set;}
    public string ReceivedString{get;set;}
    public string OperatingSystem{get;set;}
    public string Browser{get;set;}
    public MetricsAction__c myObj{get;set;}

    public DonalTestCanvas(SLP_GlobalSearch controller) {
        PageReference pageRef = ApexPages.currentPage();
        strSearchValue = pageRef.getParameters().get('SearchVal');

    
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;       
        metricsObj.Text__c=strSearchValue;
        metricsObj.ActionType__c='Global Search Button Click';
        metricsObj.ActionPath__c=getSfInstance+'/apex/SLP_GlobalSearch'+'?SearchOptions='+strSelectedOptions+'&SearchVal='+strSearchValue;
        metricsObj.PageName__c='Search Page';
        metricsObj.DeviceType__c='Mobile';
        metricsObj.SessionId__c=UserInfo.getSessionId();
        metricsObj.OperatingSystem__c=getOS();
        metricsObj.Browser__c=getBrowser();
        
        myObj = metricsObj;
    }
    
        public DonalTestCanvas(SLPM_ExpertSearchController controller) {
        PageReference pageRef = ApexPages.currentPage();
        strSearchValue = pageRef.getParameters().get('SearchVal');

    
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        metricsObj.Text__c=strSearchValue;
        metricsObj.ActionType__c='Expert Search Button Click';
        metricsObj.ActionPath__c=getSfInstance+'/apex/mobileExpertSearchNew&SearchVal='+strSearchValue;
        metricsObj.PageName__c='Expert search';
        metricsObj.DeviceType__c='Mobile';
        metricsObj.SessionId__c=UserInfo.getSessionId();
        metricsObj.OperatingSystem__c=getOS();
        metricsObj.Browser__c=getBrowser();
        
        myObj = metricsObj;
    }

    
    public void getInsertIt()
    {       
        if ((myObj.Text__c != '') && (myObj.Text__c != null)) {
            Insert(myObj);
        }
    }
  
    public String getOS() 
    {
        String ua = ApexPages.currentPage().getHeaders().get('User-Agent');
        String uaindex;
        String mobileOS;
        
        if ( ua.contains('iPad') || ua.contains('iPhone') )
        {
            mobileOS = 'iOS';
        }
        else if ( ua.contains('Android') )
        {
            mobileOS = 'Android';
        }
        else if ( ua.contains('Windows Phone') ) {
            mobileOS = 'Windows Phone';
        }
        else
        {
            mobileOS = ua;//'unknown-mobileOS';
        }
        return mobileOS;
    }
    
    public String getBrowser() 
    {
        String ua = ApexPages.currentPage().getHeaders().get('User-Agent');
        String uaindex;
        String browser;
        
        String os = getOS();
        
        if (os.equals('iOS')) {
                Integer br = ua.indexOf('Safari');
                Integer ends = ua.length();
                String bro = 'Safari'; 
                Integer ver = ua.indexOf('Version') + 7;
                String v = ua.substring(ver, ver+4).replace('/',' ');
                return bro + ' ' + v;
                
        }
        else if (ua.contains('Chrome')) {
            Integer br = ua.indexOf('Chrome');
            Integer ends = ua.lastIndexOf(' ');
            return ua.substring(br, ends).replace('/',' ').replace('Mobile', '');      
        }
        else if (ua.contains('MSIE')) {
            Integer br = ua.indexOf('MSIE');
            Integer ends = ua.lastIndexOf(' ');
            return ua.substring(br, ends).replace('/',' ');      
        }

        return ua;
    }


    public DonalTestCanvas(ApexPages.StandardController controller) {
         controllerRenderBoolVar  = false;
        
        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);
        
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('BoardId', 'a6tZ00000008Rlv');
        gen.writeStringField('tid', 'a6wZ00000008q2qIAA');
        gen.writeStringField('UserName', 'Sarah Kennedy');       
        gen.writeEndObject();
        
        // Get the JSON string.
        jsonParms = gen.getAsString();
        
        system.debug('jsonparms2 ' +  jsonParms);
    }





    public DonalTestCanvas(AthenaLearningBoardDtls controller) {
        controllerRenderBoolVar  = false;
        
        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);
        
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('BoardId', 'a6tZ00000008Rlv');
        gen.writeStringField('tid', 'a6wZ00000008q2qIAA');
        gen.writeStringField('UserName', 'Sarah Kennedy');       
        gen.writeEndObject();
        
        // Get the JSON string.
        jsonParms = gen.getAsString();
        
        system.debug('jsonparms3 ' +  jsonParms);
    }

    public DonalTestCanvas() {
        controllerRenderBoolVar  = false;
        
        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);
        
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('BoardId', 'a6tZ00000008Rlv');
        gen.writeStringField('tid', 'a6wZ00000008q2qIAA');
        gen.writeStringField('UserName', 'Sarah Kennedy');       
        gen.writeEndObject();
        
        // Get the JSON string.
        jsonParms = gen.getAsString();
        
        system.debug('jsonparms4 ' +  jsonParms);
   
    }
    
    public Void SetRender()
{
    controllerRenderBoolVar  = true;
}
}