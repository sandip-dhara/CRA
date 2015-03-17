/**********************************************************
* Class Name: CampaignMemberLookupController
* Author: HP
* Date: 13-SEP-2012 
* Requirement # Request Id: 
* Description: Customized Campaign Member Lookup
***********************************************************/

public class CampaignMemberLookupController{

    /************Variable Declaration*************/
    public String query {get;set;}
    public List<Campaign> campaigns1{set; get;}
    public List<Campaign> specificCamaigns{get; set;}
    public String searchText {get;set;}
    public String CampaignRecordType {get;set;}
    public String ProdCode {get;set;}
    public String subprdLine {get;set;}
    public String GBU {get;set;}
    public String prdLine {get;set;}
    public String CampListView {get;set;}
    public String CampSelectedRecType{get;set;}
    public Set<Id> campId{get;set;}
    public Boolean DefaultMsg{get; set;}
    public String marketingCampaignRT;
    public String SalesCampaignRT;
    public String testparam{get;set;}
    public String leadId{get;set;}
    public String RecTypeSearchText{get;set;}
    public Integer i = 0;
    public String UserId;
    
            // R6: Wrapper class added to escape special characters.
        Public class CampaignWrapper {
               public  String name {get; set;}
               public Campaign camp {get; set; }
        
                Public CampaignWrapper(Campaign cmpgn) {
                       this.camp = cmpgn; 
                       name = camp.name.replaceAll('\'','\\\\\'');
                       name = name.replaceAll('\"','``');
                       System.debug('??????'+ name);
                }
        }
    
    public ApexPages.StandardSetController campaigns2{ 
                                                        get{
                                                            if(i==0){
                                                                System.debug('????????3'+query);
                                                                campaigns2 = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                                                                campaigns2.setPageSize(10);
                                                                i=1;
                                                            }
                                                            return campaigns2;
                                                        }
                                                        set;
    }
    
    public Integer test{get;set;}
    
    

    public List<CampaignWrapper> campaigns{get{
    
                                        campaigns = new List<CampaignWrapper>();
                                        List<Campaign> campList = campaigns2.getRecords();
                                        for(Campaign cmpgn: campList) {
                                            CampaignWrapper cmpgnWrpr = new CampaignWrapper(cmpgn);
                                            campaigns.add(cmpgnWrpr); 
                                        }
                                        return campaigns;
                                    }
                                    set;
                                        
    }


                                            
    public Boolean hasNext {
        get {
            return campaigns2.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return campaigns2.getHasPrevious();
        }
        set;
    }
    
    public CampaignMemberLookupController(ApexPages.StandardController controller) {
        searchText = System.currentPageReference().getParameters().get('lksrch');     
        leadId= System.currentPageReference().getParameters().get('leadId');
        Schema.DescribeSObjectResult describeResult = Schema.SObjectType.Campaign; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = describeResult.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName1 =  rtMapByName.get('Sales Initiatives') ;
         Schema.RecordTypeInfo rtByName =  rtMapByName.get('Marketing Campaign');
        if (rtByName != null)  { 
            marketingCampaignRT = rtByName.getRecordTypeId();
           
        }
         if (rtByName1 != null)  { 
            
            SalesCampaignRT = rtByName1.getRecordTypeId();
        }
        UserId = UserInfo.getUserId();
        campaigns1 = new List<Campaign>();

    }
    
    /**
    * @description: Method Used by page, on page load to initalize start data
    * 
    */
    public void initialize() {
    
        RecTypeSearchText = CampaignRecordType;
        /* RecTypesearchText = RecTypesearchText + '%';
        campaigns1.clear(); */
        System.debug('????????12'+ RecTypesearchText);
        List<Campaign> c = new List<Campaign>([Select Id,ParentId, Marketing_Campaign_flag__c,Parent.Name, Name,RecordTypeId,RecordType.Name From Campaign Where isActive = True AND RecordType.Name  =:RecTypeSearchText AND OwnerId = :UserId AND RecordTypeId = :marketingCampaignRT  AND ((ParentId = null AND RecordTypeId = :SalesCampaignRT) OR (ParentId != null AND RecordTypeId = :SalesCampaignRT ) OR (ParentId != null AND RecordTypeId = :marketingCampaignRT)) limit 50000]);
        if(c.size()== 0)
            DefaultMsg = True;
        
        query = 'Select Id,ParentId, Marketing_Campaign_flag__c,Parent.Name, Name,RecordTypeId,RecordType.Name From Campaign Where isActive = True AND OwnerId = \'' + UserId + '\' AND RecordTypeId = :marketingCampaignRT  AND  ((ParentId = null AND RecordTypeId = :SalesCampaignRT) OR (ParentId != null AND RecordTypeId = :SalesCampaignRT ) OR (ParentId != null AND RecordTypeId = :marketingCampaignRT))' ;
                                                                 
    }  
    
    /**
    * @description: run the search and return the records found. 
    */
    public void searchCampaigns() {
        i=0;
        if (CampListView == Label.My_Active_Campaigns) {
            query = 'Select Id,ParentId, Marketing_Campaign_flag__c,Parent.Name, Name, RecordTypeId,RecordType.Name From Campaign Where isActive = True and OwnerId = \'' + UserId + '\' AND RecordType.Name  LIKE \'' + RecTypeSearchText + '\'  AND (ParentId = null AND RecordTypeId = :SalesCampaignRT ) limit 1000'; 
         
         }
              
        if (CampListView == Label.My_Campaigns) {
             query = 'Select Id,ParentId, Marketing_Campaign_flag__c, Parent.Name,Name,RecordTypeId,RecordType.Name From Campaign Where OwnerId = \''+ UserId + '\' AND RecordType.Name  LIKE \'' + RecTypeSearchText + '\'  AND (ParentId = null AND RecordTypeId = :SalesCampaignRT ) limit 1000';
            
        }
        if (CampListView == Label.All_Active_Campaigns) {
            query = 'Select Id,ParentId, Marketing_Campaign_flag__c, Parent.Name,Name,RecordTypeId,RecordType.Name From Campaign Where isActive = True AND RecordType.Name  LIKE \'' + RecTypeSearchText + '\'  limit 1000';
            
        }
        if (CampListView == Label.All_Campaigns) {
            query = 'Select Id,ParentId, Marketing_Campaign_flag__c,Parent.Name, Name,RecordTypeId,RecordType.Name From Campaign where RecordType.Name  LIKE \'' + RecTypeSearchText + '\'  limit 1000';
        }
        
        System.debug('????????1'+query);
                      
    }
    
    // returns the first page of records
    public void first() {
        campaigns2.first();
    }
 
    // returns the last page of records
    public void last() {
        campaigns2.last();
    }
 
    // returns the previous page of records
    public void previous() {
        campaigns2.previous();
    }
 
    // returns the next page of records
    public void next() {
        campaigns2.next();
    }
    
    /**
    * @description: run the specific search and return the records found. 
    */
     public void searchSpecificCampaigns() {
     
        String tmpSearchText = String.escapeSingleQuotes(searchText); 
        tmpSearchText = '%' + tmpSearchText + '%';
        campaigns1.clear();
        i=0;
        
        RecTypeSearchText = CampaignRecordType;
        RecTypesearchText = RecTypesearchText + '%';
        campaigns1.clear();
        
        System.debug('???????51'+RecTypesearchText);
         
         if(tmpSearchText.contains('*')){
             tmpSearchText = tmpSearchText.remove('*');
         }
         
         if(tmpSearchText == null || tmpSearchText == '' )
             searchCampaigns();
             
         else{
         
         if (CampListView == Label.My_Active_Campaigns) 
         {
             
             query = 'Select Id,ParentId, Marketing_Campaign_flag__c,Parent.Name, Name,RecordTypeId,RecordType.Name  From Campaign Where OwnerId = \''+ UserId + '\' AND isActive = True and RecordType.Name  LIKE \'' + RecTypeSearchText + '\'  AND ((Parent.Name  LIKE \'' + tmpSearchText + '\' ) OR (Name LIKE \'' + tmpSearchText + '\' AND ParentId = null AND RecordTypeId = :SalesCampaignRT )) Order By Name limit 1000';
                     
         }
        if (CampListView == Label.My_Campaigns) {
              query = 'Select Id,ParentId, Marketing_Campaign_flag__c,Parent.Name, Name,RecordTypeId,RecordType.Name  From Campaign Where OwnerId = \''+ UserId + '\' AND RecordType.Name  LIKE \'' + RecTypeSearchText + '\' AND ((Parent.Name  LIKE \'' +tmpSearchText + '\' ) OR (Name LIKE \'' +tmpSearchText + '\' AND ParentId = null AND RecordTypeId = :SalesCampaignRT )) Order By Name limit 1000';        
             
         }
        if (CampListView == Label.All_Active_Campaigns) {
            query = 'Select Id,ParentId, Marketing_Campaign_flag__c,Parent.Name, Name,RecordTypeId,RecordType.Name  From Campaign Where isActive = True AND RecordType.Name  LIKE \'' + RecTypeSearchText + '\' AND ((Parent.Name  LIKE \'' +tmpSearchText + '\' ) OR (Name LIKE \'' +tmpSearchText + '\' AND ParentId = null AND RecordTypeId = :SalesCampaignRT )) Order By Name limit 1000';
            
        }
        if (CampListView == Label.All_Campaigns) {
            query = 'Select Id,ParentId, Marketing_Campaign_flag__c,Parent.Name, Name,RecordTypeId,RecordType.Name  From Campaign Where RecordType.Name  LIKE \'' + RecTypeSearchText + '\' AND ((Parent.Name  LIKE \'' +tmpSearchText + '\' ) OR (Name LIKE \'' +tmpSearchText + '\' AND ParentId = null AND RecordTypeId = :SalesCampaignRT )) Order By Name limit 1000';
            
            }
        }
        System.debug('????????2'+query);
     }    
    
    
    /**
    * @description: used by the visualforce page to send the link to the right dom element
    * @return: String returns url lkfm(form) paramter value
    */
    public String getFormTag() {
        return System.currentPageReference().getParameters().get('lkfm');
    }

    /**
    * @description: sed by the visualforce page to send the link to the right dom element for the text box
    * @return: String returns url lknm paramter value
    */
    public String getTextBox() {
        return System.currentPageReference().getParameters().get('lknm');
    } 
    
    
    /**
    * @description: For displaying Campaign Search LOV in VF page
    * @return: List of Values of Campaign Search LOV 
    */  
     public List<SelectOption> getCampaignView() {
        List<SelectOption> option = new List<SelectOption>(); 
            option.add(new SelectOption(Label.My_Active_Campaigns,Label.My_Active_Campaigns));
            option.add(new SelectOption(Label.My_Campaigns,Label.My_Campaigns));
            option.add(new SelectOption(Label.All_Active_Campaigns,Label.All_Active_Campaigns));
            option.add(new SelectOption(Label.All_Campaigns,Label.All_Campaigns));
            return option;
    } 
    
    
      /**
    * @description: For displaying Campaign Record Types VF page
    * @return: Campaign Record Types except Partner 
    */  
     public List<SelectOption> getCampRecType() {
        List<SelectOption> option = new List<SelectOption>(); 
            //option.add(new SelectOption('None','None'));
            option.add(new SelectOption('Marketing Campaign','Marketing Campaign'));
            option.add(new SelectOption('Sales Initiatives','Sales Initiatives'));
            return option;
    }
    
    
    public pageReference check(){
        //PageReference pgref = new PageReference('/apex/CampaignMemberPage?campId='+testparam+'&leadId='+leadId+'&retURL='+leadId);
       PageReference pgref = new PageReference('https://cs11.salesforce.com/00v/e?c_id='+testparam+'&parent_id='+leadId+'&retURL='+leadId);
       return pgref;
    }              
}