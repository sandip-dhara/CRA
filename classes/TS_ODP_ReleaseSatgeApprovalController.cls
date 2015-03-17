public with sharing class TS_ODP_ReleaseSatgeApprovalController 
{
    public String searchFilter{get;set;}
    public String searchLabel{get;set;}
    public LIST<Stage_Review__c> deliverableReview{get;set;}
    public LIST<Release_Stage__c> StgeFilter{get;set;}
    public LIST<Release_Stage__c> StageList{get;set;}
    public ApexPages.StandardSetController Pagination{get;set;}
    public String FilterStatus {get;set;}
    public boolean ShowCompleted{get;set;}
    public String SortField{get;set;}
    private String sortDirection = 'ASC';
    public String selectItem{get;set;}
        
    public String getSortDirection()
    {
         return (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }

    public void setSortDirection(String value)
    {  
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }
    
    public TS_ODP_ReleaseSatgeApprovalController()
    {
        searchLabel = 'Search Filter';
        FilterStatus = 'InProgress';
        SortField = 'Release_Stage_ID__r.Release_Name__c';
        ShowCompleted = false;
        SortDirection = '';
        doQuery();
    }
    
    public void FilterInProgress()
    {
        FilterStatus = 'InProgress';
        doQuery();
    }
    
    public void FilterUpcoming()
    {
        FilterStatus = 'Upcoming';
        doQuery();
    }
    
    public void FilterHistory()
    {
        FilterStatus = 'History';
        doQuery();
    }
    
    public void Sort()
    {
        doQuery();
    }

    
    public void doQuery()
    {
        string whereThisUser = '';
        string queryString = '';
        string whereStatus = '';
        string whereCompleted = '';
        string userId = UserInfo.getUserId();
        whereThisUser = ' WHERE (PAC_Member_ID__r.User__c = :userId or Release_Stage_ID__r.Offering_Release_ID__r.OwnerId = :userId or Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__c = :userId)';
        
        //Hunter:add new filter for If I am offering manger for some project
        
        
        if(FilterStatus == 'InProgress')
        {
            whereStatus = ' and Release_Stage_ID__r.Status__c=\'In Review\'';
        }
        else if(FilterStatus == 'Upcoming')
        {
            whereStatus = ' and Release_Stage_ID__r.Status__c=\'In Progress\'';
        }
        else if(FilterStatus == 'History')
        {
            //whereStatus = ' and Release_Stage_ID__r.Status__c!=\'In Progress\' and Release_Stage_ID__r.Status__c!=\'In Review\'';
            whereStatus = ' and (Release_Stage_ID__r.Status__c =\'Complete\' or Release_Stage_ID__r.Status__c =\'Review Complete\' or Release_Stage_ID__r.Status__c =\'On Hold\' or Release_Stage_ID__r.Status__c =\'Cancelled\')';
        }
        
        if(ShowCompleted)
        {
            whereCompleted = ' and Complete__c=true';
        }
        else
        {
            whereCompleted = ' and Complete__c=false';
        }
        
        queryString = 'SELECT id,Name,Release_Stage_ID__c,Stage_Name__c,Decision__c,PAC_Member_Name__c,PAC_Member_ID__r.User__c,PAC_Member_ID__r.User__r.Name,'+
                    'Complete__c,Comment__c,' +
                    'Release_Stage_ID__r.Release_Name__c, Release_Stage_ID__r.Current_Baseline_End_Date__c, Release_Stage_ID__r.Status__c,Release_Stage_ID__r.Offering_Release_ID__c ' +
                    'from Stage_Review__c' +
                     whereThisUser  + whereStatus + whereCompleted +
                    ' Order By ' +SortField +' ' + SortDirection;                            
        deliverableReview = Database.Query(queryString);
        Set<ID> stageIdSet = new Set<ID>();
        for(Stage_Review__c reviewer:deliverableReview){
            if(!stageIdSet.contains(reviewer.Release_Stage_ID__c)){
                stageIdSet.add(reviewer.Release_Stage_ID__c);
            }
        }
        StageList = [select Id,Stage_Name__c,Release_Name__c,Status__c,Current_Baseline_End_Date__c from Release_Stage__c where id in :stageIdSet];
        
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, queryString));
/*
        Pagination= new ApexPages.StandardSetController(deliverableReview);
        Pagination.setPageSize(25);
*/
        if(searchFilter != null && searchFilter != ''){
            //system.debug('the filter string is '+ searchFilter);
            Pagination= new ApexPages.StandardSetController(filterByName(StageList));
            Pagination.setPageSize(25);
        }else{
            Pagination= new ApexPages.StandardSetController(StageList);
            Pagination.setPageSize(25);
        }        
    }

    
    /* Sofi - search filter action */
    public void searchActLoad(){
        doQuery();
        //return null;    
    }    
    /* Sofi - search filter method filterByName*/
    public LIST<Release_Stage__c> filterByName(LIST<Release_Stage__c> Stages ){
        StgeFilter = new list<Release_Stage__c>();
        //system.debug('the selectItem string is '+ selectItem );
        if(selectItem == '1'){
            for(Release_Stage__c s : Stages ){
                if(s.Release_Name__c.contains(searchFilter) == true){
                  StgeFilter.add(s);
                }
            }
        }
        else if(selectItem == '2'){
            for(Release_Stage__c s : Stages ){
                if(s.Stage_Name__c.contains(searchFilter) == true){
                  StgeFilter.add(s);
                }
            }
        }
        return StgeFilter;
    }
    public List<SelectOption> getSearchItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Project Name'));
        options.add(new SelectOption('2','Stage Name'));
        return options;
    } 
    
    /*
    @Description: This methods returns the list of Contributor.
    */
    
    public list<Release_Stage__c> getConList(){
            return Pagination.getRecords();
    }
    
    /*
    @Description: This methods is invoked when clicked on the next button in the Contributor result table.
    */
    public void nextConPage(){
        Pagination.next();
    }
    
    /*
    @Description: This methods is invoked when clicked on the previous  button in the Contributor result table.
    @param: none.
    @return: void
    */
    public void previousConPage(){
        Pagination.previous();
    }
    
    /*
    @Description: This methods is invoked when clicked on the first page button in the Contributor result table.
    @param: none.
    @return: void
    */
    public void firstConPage(){
        Pagination.first();
    }
    
    /*
    @Description: This methods is invoked when clicked on the last page button in the Contributor result table.
    @param: none.
    @return: void
    */
    public void lastConPage(){
        Pagination.last();
    }
    
    /*
    @Description: This methods is used to check if there are more records to be shown in the next page.
    @param: none.
    @return: boolean
    */
    public boolean gethasConNext(){
        return Pagination.getHasNext();
    }
    
    /*
    @Description: This methods is used to check if there are records in the previous page.
    @param: none.
    @return: boolean
    */
    public boolean gethasConPrevious(){
        return Pagination.getHasPrevious();
    }
    
    /*
    @Description: This methods is used to get the number of records returned in the SOQL.
    @param: none.
    @return: integer
    */
    public integer getConResultSize(){
       return Pagination.getResultSize();
    }
}