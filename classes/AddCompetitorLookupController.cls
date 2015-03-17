/**********************************************************
* Class Name: AddCompetitorLookupController
* Author: HP
* Date: 25-July-2012 
* Requirement # Request Id:
* Description: Controller class for Competitor account lookup override
***********************************************************/

public with sharing class AddCompetitorLookupController {

    public User currentUser;
    public List<Account> listCompetitorAccounts{get;set;}
    public string UserBG;
    /*--------added to pass the accountid to MDCPCompetitor Search------------*/
    public string RegionMDCP {get;set;}
    public String UserRegion;
    public String searchText {get;set;}
    public String AccsearchText {get;set;}
    public String BGsearchText {get;set;}
    /* For Sorting Logic   */
    public String sortDirection = 'ASC';
    public String sortExp = 'name';
    /*  For Sorting Logic  */
    
    /**
    * @description: return flag is Search Result Empty or not
    * @return: boolean True if list is empty
    * 
    */
    
    
    public List<SelectOption> getBGPicklist() {
        List<SelectOption> optionsBG = new List<SelectOption>();
        optionsBG.add(new SelectOption('None','--None--'));
        Schema.DescribeFieldResult field = Account.Valid_Business_Group__c.getDescribe();
        List<Schema.PicklistEntry> valuesBG = field.getPicklistValues();
        for(Schema.PicklistEntry p : valuesBG){
            optionsBG.add(new SelectOption(p.getlabel(),p.getlabel()));
        }
        return optionsBG;
    }
    public Boolean getIsResultEmpty(){
        Boolean returnBoolean = false;
        if(listCompetitorAccounts==null || listCompetitorAccounts.size()<1){
            returnBoolean=true;
        }
        return returnBoolean;
            
    }
    
    /**
    * @description: Method Used by page, on page load to initalize start data
    * 
    * 
    */
    public void initialize() {
        searchText = System.currentPageReference().getParameters().get('lksrch');
       /* String Opportunityid= System.currentPageReference().getParameters().get('opptyid');
        Opportunity op=[select id,name,accountid from Opportunity where id=:opportunityid];
        Account a=[select id,name,regions__c from Account where id = :op.accountid];
        system.debug('currently added opportunity id ' +opportunityid); 
        currentUser = [Select Id, Name,Region__c, Business_Group__c 
                        From User 
                        where id=:Userinfo.getUserId()];
        //userBG= currentUser.Business_Group__c;
        userBG=a.regions__c;
        if(userBG==null){
            userBG='';
        }
        //userRegion= currentUser.Region__c;
        userRegion= a.regions__c;
        if(userRegion==null){
            userRegion='';
        }  */
        searchAccounts();                      
        system.debug('-->listCompetitorAccounts : ' + listCompetitorAccounts);                                            
    }
        /**
    * @description: Initialize AccountId to be passes to MDCPSearch. 
    * 
    * 
    */
    public AddCompetitorLookupController(){
        String Opportunityid= System.currentPageReference().getParameters().get('opptyid');
        Opportunity op=[select id,name,accountid from Opportunity where id=:opportunityid];
        Account a=[select id,name,WorldRegion_Region__c from Account where id = :op.accountid];
        system.debug('currently added opportunity id ' +opportunityid);
        RegionMDCP=a.WorldRegion_Region__c;
    }
     
    /**
    * @description: run the search and return the records found. 
    * 
    * 
    */
    public void searchAccounts() {
    
        String Opportunityid= System.currentPageReference().getParameters().get('opptyid');
        Opportunity op=[select id,name,accountid from Opportunity where id=:opportunityid];
        Account a=[select id,name,WorldRegion_Region__c from Account where id = :op.accountid];
        system.debug('currently added opportunity id ' +opportunityid);
        userRegion= a.WorldRegion_Region__c;
        if(userRegion==null){
            userRegion='';
        }
        /* SORTING  //build the full sort expression */
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        
        /* SORTING  */
        
        Id RecordTypeId=null;
        try{
            RecordTypeId = RecordTypeIdHelper.getRecordTypeId ('Account','Competitor');
        }catch(Exception ex){
            System.debug('Exception:'+ex.getMessage());
        }       
        String soql = 'Select OwnerId, Name, Id, Valid_Business_Group__c, Regions__c,Type From Account';
        String whereCondition = '';
        if(RecordTypeId!=null){
            whereCondition = whereCondition + ' RecordTypeId = \''+RecordTypeId+'\' and';
        }
        system.debug('-->searchText : ' + searchText ); 
        
        String tempAccsearchText=AccSearchText;
        String tempBGsearchText=BGSearchText;
        
       
        
        if (tempAccsearchText != null && tempAccsearchText != '') {
            system.debug('-->before query : '); 
            tempAccsearchText = tempAccsearchText.replaceAll('\\*','%');
            whereCondition = whereCondition +  ' name LIKE \''+'%' + tempAccsearchText +'%\' and';
        }
        
        if (tempBGsearchText != null && tempBGsearchText != '' && tempBGsearchText!='None') {
            system.debug('-->before query : '); 
            tempBGsearchText = tempBGsearchText.replaceAll('\\*','%');
            whereCondition = whereCondition +  ' Valid_Business_Group__c INCLUDES(\''+tempBGsearchText+'\') and';
        }
        /*if (userBG != null && userBG != '' && !(userBG.equalsIgnoreCase(Label.Cross_BG))) { 
            whereCondition = whereCondition +  ' Valid_Business_Group__c INCLUDES(\''+userBG+'\') and';
        }  commented by Prakash */
        if (userRegion != null && userRegion != '' ) {
            whereCondition = whereCondition +  ' Regions__c INCLUDES(\''+userRegion+'\') and';
        } 
        if(whereCondition!=null && whereCondition.length()>0 ){
            whereCondition = ' where'+whereCondition.substring(0,whereCondition.length()-4);
        }
        else{
            whereCondition = '';
        }
        soql = soql + whereCondition + 'Order by '+ sortFullExp + ' limit  200';
        System.debug('query>>>'+soql);
        listCompetitorAccounts = database.query(soql); 
        system.debug('-->listCompetitorAccounts : ' + listCompetitorAccounts);
    }

    /**
    * @description: used by the visualforce page to send the link to the right dom element
    * @return: String returns url lkfm(form) paramter value
    * 
    */
    public String getFormTag() {
        return System.currentPageReference().getParameters().get('lkfm');
    }

    /**
    * @description: sed by the visualforce page to send the link to the right dom element for the text box
    * @return: String returns url lknm paramter value
    * 
    */
    public String getTextBox() {
        return System.currentPageReference().getParameters().get('lknm');
    } 
    
    /* For Sorting Logic  */
    
     public String sortExpression
    {
        get
        {
        return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
            sortDirection = 'ASC';
        sortExp = value;
        }
    }
    
    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    public void setSortDirection(String value)
    {    
        sortDirection = value;
    }
    
    /* For Sorting Logic  */
}