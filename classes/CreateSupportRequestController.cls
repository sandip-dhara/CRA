/**********************************************************
* Class Name: CreateSupportRequestController
* Author: Accenture
* Date: 12-June-2012 
* Requirement # Request Id:
* Description: Controller class for CreateSupportRequest page
***********************************************************/
public with sharing class CreateSupportRequestController {
    
    public Boolean isDisabled{get;set;}
    public Support_Request__c sRequest{get;set;}
    private Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = null;
    public String selectedRequestType{get;set;}
    public String selectedSubType{get;set;}
    public Map<String,String> mainDetails{get;set;}
    public String mainDetailHeader{get;set;}
    private String BusinessGroup;
    private boolean showDirectDetailPage;
    private boolean showDirectVisualforcePage;
    private String recordTypeName = null ;
    private User objUser;
    private String redirectVFPageName;
    public String SupportCategoryLabel {get;set;}
    public String SupportSubTypeLabel {get;set;}
    public Id opptyId{get;set;}
    //Apttus: SFDC-Apttus Interface fields
    public  Opportunity oppId{get;set;}
    public String managedBy{get;set;}
    public String renewalType{get;set;}
    public String opptyType{get;set;}
    public String route{get;set;}
    /**
    * @description: Class Constructor method
    * @param: Class Controller Apex Page
    * 
    */
     private Boolean redirectFlag;
    public CreateSupportRequestController(ApexPages.StandardController controller) {
        sRequest = (Support_Request__c)controller.getRecord();
        opptyId = Apexpages.currentPage().getParameters().get('CF00NG0000008SOJn_lkid');
        System.debug(  'opptyId1  '+opptyId );      
        if(opptyId != null){
            sRequest.Opportunity__c = opptyId;
            //Start Apttus: SFDC-Apttus Interface
            Opportunity opportunity =[select Managed_By__c,Renewal_Type__c,type,Route_To_Market__c from Opportunity where id=:opptyId];
            managedBy=opportunity.Managed_By__c;
            renewalType=opportunity.Renewal_Type__c;
            opptyType=opportunity.type;
            route=opportunity.Route_To_Market__c;
            //End Apttus: SFDC-Apttus Interface
           }
        system.debug('Renewal_Type__c--------'+opportunity.Renewal_Type__c+ 'type----'+opportunity.type);
        SupportCategoryLabel =Support_Request__c.fields.Support_Type__c.getDescribe().getLabel();
        SupportSubTypeLabel = Support_Request__c.fields.Sub_Type__c.getDescribe().getLabel();
        sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        mainDetails = new Map<String,String>();
        showDirectDetailPage = false;
        showDirectVisualforcePage = false;
        objUser = [select Business_Group__c,Country,Region__c,Sub_Region__c from user where id=:userinfo.getuserid()];
        BusinessGroup = objUser.Business_Group__c;
    }
    
    /**
    * @description: Getter method that creates select options for Support Request Type
    *               from Support Request custom setting records 
    */
    public List<SelectOption> getSupportRequestTypes()
    {
        List<SelectOption> options = new List<SelectOption>();
        Set<string> requestTypeSet= new set<string>();
        mainDetails.clear();
        mainDetailHeader =SupportCategoryLabel;
        options.add(new SelectOption('','--None--'));
        
        List<String> sortedvalues=new List<String>();
        
        for(Support_Request_FS_CS__c requestType : sRequestFieldSetCSMap.values()){
             if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Eligible_BG__c).contains(BusinessGroup)){
               
                if(!requestTypeSet.contains(requestType.SupportReqType__c)){
                   
                    requestTypeSet.add(requestType.SupportReqType__c);
                    //options.add(new SelectOption(requestType.SupportReqType__c,requestType.SupportReqType__c));
                    sortedvalues.add(requestType.SupportReqType__c);
                    if(requestType.Type_Detail__c==null){
                        mainDetails.put(requestType.SupportReqType__c,'');
                        
                    }
                    else{
                        mainDetails.put(requestType.SupportReqType__c,requestType.Type_Detail__c);
                        
                    }
                }
            }
        }
        sortedvalues.sort();
       
        for(String sortval: sortedvalues){
           options.add(new SelectOption(sortval,sortval));
        }
        
        
        return options;
    }
    
    /**
    * @description: Getter method that creates select options for Support Request Sub-Type
    *               from Support Request custom setting records 
    */
    public List<SelectOption> getSupportRequestSubTypes()
    {
        selectedSubType = '';
        List<SelectOption> options = new List<SelectOption>();
        Map<String,String> tmpMainDetails = new Map<String,String>();
        options.add(new SelectOption('','--None--'));
        
        List<String> sortedvalues=new List<String>();
        
        for(Support_Request_FS_CS__c requestType : sRequestFieldSetCSMap.values()){
           if(requestType.SupportReqType__c.equals(selectedRequestType)){
                if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Eligible_BG__c).contains(BusinessGroup)){
                    if(requestType.Request_SubType__c == 'Config / Price / Quote' && SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.Restrict_Quote_Functionality).contains(objUser.Business_Group__c+':'+objUser.Region__c)){}
                    else{
                    
                        //options.add(new SelectOption(requestType.Request_SubType__c,requestType.Request_SubType__c));
                        sortedvalues.add(requestType.Request_SubType__c);
                    }
                    if(requestType.SubType_Detail__c==null){
                        tmpMainDetails.put(requestType.Request_SubType__c,'');
                    }
                    else{
                        tmpMainDetails.put(requestType.Request_SubType__c,requestType.SubType_Detail__c);
                    }
                }
            }
        }
        sortedvalues.sort();
        for(String sortval: sortedvalues){
            options.add(new SelectOption(sortval,sortval));
        }
        if(tmpMainDetails.size()>0){
           mainDetailHeader =SupportSubTypeLabel;
           mainDetails.clear();
           for(String key: tmpMainDetails.keySet()){
               mainDetails.put(key,tmpMainDetails.get(key));
           }
        }else{
            getSupportRequestTypes();
        }
        return options;
    }
    
    /**
    * @description: Searches record type for selected Support Request Type & selected
    *               Support Request Sub-Type & returns its id
    * @return: return record type id, null in case of any Error  
    */
    private String getRecordTypeID(){
      // String recordTypeName = null;
        Id recordTypeid = null;
        for(Support_Request_FS_CS__c requestType : sRequestFieldSetCSMap.values()){
            if((requestType.SupportReqType__c.equals(selectedRequestType) && requestType.Request_SubType__c.equals(selectedSubType))&& SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Eligible_BG__c).contains(BusinessGroup)){
                if(requestType.isBG_Specific_RecordType__c && BusinessGroup!=null)
                    recordTypeName = BusinessGroup+'-'+requestType.RecordType_Name__c;
                else
                    recordTypeName = requestType.RecordType_Name__c;
                
                if(requestType.isVisualforce__c && requestType.Visualforce_Page_Name__c != null && !SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Non_Eligible_Countries__c).contains(objUser.Business_Group__c+':'+objUser.Sub_Region__c)){
                    showDirectVisualforcePage = true;
                    sRequest.Request_Submitted_From__c = requestType.View_VF_Page_Name__c;
                    redirectVFPageName = requestType.Visualforce_Page_Name__c;
                }
                if((requestType.punchOut_BG__c!=null && !requestType.isVisualforce__c)|| (requestType.isVisualforce__c && SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Non_Eligible_Countries__c).contains(objUser.Business_Group__c+':'+objUser.Sub_Region__c))){
                    if(requestType.punchOut_BG__c.contains(BusinessGroup)){
                        showDirectDetailPage = true;
                    }
                }
                //RSC Change START
                if(recordTypeName == 'ES-Functional Support-RSC'){
                    redirectFlag = true;
                }else
                    redirectFlag = false;
                //RSC Change END
            }
        }
        //System.debug('###############################:'+recordTypeName);
        return SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(recordTypeName);
    }
    
    /**
    * @description: Calls methos redirect on next button click  
    */
    public pageReference nextPage()
    {
        return redirect();
    }
    
    /**
    * @description: Redirects user to New Support Request page & 
    *               adds url parameters for record type etc   
    * @return: pagereference to New Support Request page  
    */
    private Pagereference redirect() {
        Pagereference pgRef;
        //navigationURL = '/006/e?opp11=01 - Understand Customer&nooverride=1';
        Id recordtypeid = getRecordTypeID();
        //System.debug('$$$$$$$$$$$$$$$$$4'+recordtypeid);
        if(recordtypeid == null){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.No_RecordType_Found));
            return null;
        }
        //RSC Change START
        system.debug('--- redirectFlag ---'+redirectFlag);
        if(redirectFlag){
            system.debug('--- checking for reference success center ---');
            List<Support_Request__c> supportReqList = [select Id from Support_Request__c where Opportunity__c=:sRequest.Opportunity__c and Support_Type__c='Functional Support' and Sub_Type__c='Reference Success Center'];
            if(supportReqList != null && supportReqList.size()>0){
                pgRef = new Pagereference('/apex/RSCSupportRequestPage?id='+supportReqList.get(0).id);
            }else{
                sRequest.recordTypeId = recordtypeid;
                insert sRequest;
                pgRef = new Pagereference('/apex/RSCSupportRequestPage?id='+sRequest.id);
            }
            return pgRef;
        }
        //RSC Change END
        if(showDirectVisualforcePage){
            sRequest.recordTypeId=recordtypeid;
            insert sRequest;
            pgRef = new Pagereference('/apex/'+redirectVFPageName+'?id='+sRequest.id);
            return pgRef;
        }
        if(showDirectDetailPage){
            //Support_Request__c newSR = new Support_Request__c();
            sRequest.recordTypeId=recordtypeid;
            sRequest.Request_Description__c =Label.SupportRequest_PunchOutDescription;
            insert sRequest;
            pgRef = new Pagereference('/'+sRequest.id);
            return pgRef;
        }
        
        
        List<String> oppId = new List<String>();
        oppId.add(sRequest.Opportunity__c);
      //  system.debug('+++'+oppId);
        List<opportunity> qryOptyList = [select id,AccountId,Account.WorldRegion_Region__c,Account.WorldRegion_SubRegion1__c,Account.ShippingCountry from opportunity where id IN: oppId ];
        system.debug('&&&&'+qryOptyList);
        
      
       If(recordTypeName != null && (recordTypeName.containsany('Functional Support') || recordTypeName.containsany('Event') || recordTypeName.containsany('Sales Engineering') || recordTypeName.containsany('Opportunity') || recordTypeName.containsany('Quote') || recordTypeName.containsany('Vertica') || recordTypeName.containsany('GSB Site Survey')))

       {
       System.debug('#####################'+recordTypeName );
       
       if(qryOptyList[0].Account.WorldRegion_SubRegion1__c=='UK & I'){
       
        URL_Parameters__c abp = [select Routing_Region__c,Routing_BG__c,Routing_Sub_Region__c,Routing_Country__c from URL_Parameters__c limit 1];
          
        String navigationURL = '/'+Schema.SObjectType.Support_Request__c.getKeyPrefix()+'/e?nooverride=1&'+abp.Routing_Region__c+'='+qryOptyList[0].Account.WorldRegion_Region__c+'&'+abp.Routing_BG__c+'='+BusinessGroup+'&'+abp.Routing_Sub_Region__c+'=UK %26 I&'+abp.Routing_Country__c+'='+qryOptyList[0].Account.ShippingCountry+'&RecordType='+recordtypeid;
         System.debug('#####################'+navigationURL );
        pgRef = new Pagereference(navigationURL);
        
        }else
      {
      
           URL_Parameters__c abp = [select Routing_Region__c,Routing_BG__c,Routing_Sub_Region__c,Routing_Country__c from URL_Parameters__c limit 1];
           //system.debug(';;;;;;;'+abp.Routing_Country__c);
        String navigationURL = '/'+Schema.SObjectType.Support_Request__c.getKeyPrefix()+'/e?nooverride=1&'+abp.Routing_Region__c+'='+qryOptyList[0].Account.WorldRegion_Region__c+'&'+abp.Routing_BG__c+'='+BusinessGroup+'&'+abp.Routing_Sub_Region__c+'='+qryOptyList[0].Account.WorldRegion_SubRegion1__c+'&'+abp.Routing_Country__c+'='+qryOptyList[0].Account.ShippingCountry+'&RecordType='+recordtypeid;
        System.debug('#####################'+navigationURL );
        pgRef = new Pagereference(navigationURL);
        
        }
        
        }
        
        else
       
         {
            
         String navigationURL = '/'+Schema.SObjectType.Support_Request__c.getKeyPrefix()+'/e?nooverride=1&RecordType='+recordtypeid;
        System.debug('#####################'+navigationURL );
        pgRef = new Pagereference(navigationURL);
         }
        
        map<String, String> mapUrlParam = Apexpages.currentPage().getParameters();
        if(mapUrlParam != null && mapUrlParam.size() > 0) {
            if(mapUrlParam.containskey('sfdc.override')) {
                mapUrlParam.remove('sfdc.override');
            }
            if(mapUrlParam.containskey('save_new')) {
                mapUrlParam.remove('save_new');
            }
            if(mapUrlParam.containskey('com.salesforce.visualforce.ViewStateCSRF')) {
                mapUrlParam.remove('com.salesforce.visualforce.ViewStateCSRF');
            }
            
            for(String key : mapUrlParam.keyset()){
                pgRef.getParameters().put(key,mapUrlParam.get(key));
            }    
        }
        //System.debug('>>>>>>>>>>>'+pgRef);
        pgRef.setRedirect(true);
        return pgRef;
    }
}