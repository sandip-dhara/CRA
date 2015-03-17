public class ODP_Extension_SOFITEST_Contribution
{
    public String searchFilter{get;set;}
    public String searchLabel{get;set;}
    public LIST<Contributor__c> contributors {get;set;}
    public LIST<Contributor__c> contributorsFilter {get;set;}
    public string UserId {get;set;}
    public boolean Recordspro {get;set;}
    public boolean RecordsUP {get;set;}
    public boolean Recordsnot {get;set;}
    public boolean DisplayIndicator {get;set;}
    public boolean showComplete {get;set;}
    public string showCompleteCondition{get;set;}
    public string sortField{get;set;}
    public boolean flag{get;set;}
    public set<string> statusValueSet{get;set;}
    public ApexPages.StandardSetController ContriPagination{get;set;}
    public String FilterStatus{get;set;}
    public String StageStatus{get;set;}
    public String selectItem{get;set;}
    public String selectItemName {get;set;}
    
    public ODP_Extension_SOFITEST_Contribution(){
        searchLabel = 'Search Filter';
        Recordspro = true;
        RecordsUP=false;
        Recordsnot= false;
        showComplete = false;
        UserId = UserInfo.getUserId();
        statusValueSet = new set<string>{'In Progress'};
        FilterStatus = 'In Progress';
        contributionInProgressInfo();
        StageStatus = '';    
        if(contributors.size() == 0){
            DisplayIndicator = false;
        }
        else{
            DisplayIndicator = true;
        }
    }
    
    
    private String sortDirection = 'ASC';
    public String getSortDirection()
    {
         return (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }

    public void setSortDirection(String value)
    {  
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }
    
    
    Public void contributionInProgressInfo()
    {
        contributors = new list<Contributor__c>();
        //get search filter value and name if user user filter 
        selectItemName = getSelectItem(selectItem);
        String query = '';
        if(selectItemName != ''){
            system.debug('the searchFilter string is '+ searchFilter );
            query = 'AND ( '+ selectItemName + ' LIKE '+'\''+ '%'+ searchFilter + '%'+ '\''+' )';
        }else{
            query ='';
        }
        
        //contributorsFilter = new list<Contributor__c>();
        sortField = sortField==null ? 'Role_Name__c': sortField;       
        showCompleteCondition = showComplete == true ? ' AND Completed__c = true ' : 'AND Completed__c = false';
        
        //Added By Ning - Apr 23 2014
        //--When viewing upcoming contrbutions, also show Work Elements that are associated with Stages where status = "On Hold"
        //--When viewing history of contrbutions, also show Work Elements that are associated with Stages where status = "Canceled"
        string queryString = '';
        if(FilterStatus == 'In Progress'){
            StageStatus = 'In Progress';
            queryString = 'SELECT id,name,Stage_Work_Element__r.Description_Text_Area__c,Team_Member_Name__c,Role_Name__c,Completed__c,Stage_Work_Element_Name__c,'+
                        ' Team_Members__r.User__r.Id,Stage_Work_Element__r.Work_Element_Name__c,'+
                        ' Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Deliverable_Name__c,'+
                        ' Stage_Work_Element__r.Status__c,Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Contribute_Due_Date__c,'+
                        ' Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id,Stage_Work_Element__r.Accountable_Process_Role_Name__c,'+
                        ' Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.Status__c from Contributor__c where (Team_Members__r.User__r.Id=:UserId '+
                        ' OR Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id =:UserId) AND (Stage_Work_Element__r.Status__c'+
                        ' In: statusValueSet )'+ query + showCompleteCondition +' ORDER BY '+ sortField+' '+sortDirection;      
        }
        else if(FilterStatus == 'Upcoming'){
            StageStatus = 'On Hold';
            queryString = 'SELECT id,name,Stage_Work_Element__r.Description_Text_Area__c,Team_Member_Name__c,Role_Name__c,Completed__c,Stage_Work_Element_Name__c,'+
                        ' Team_Members__r.User__r.Id,Stage_Work_Element__r.Work_Element_Name__c,'+
                        ' Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Deliverable_Name__c,'+
                        ' Stage_Work_Element__r.Status__c,Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Contribute_Due_Date__c,'+
                        ' Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id,Stage_Work_Element__r.Accountable_Process_Role_Name__c,'+
                        ' Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.Status__c from Contributor__c where (Team_Members__r.User__r.Id=:UserId '+
                        ' OR Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id =:UserId) AND (Stage_Work_Element__r.Release_Stage_ID__r.Status__c =: StageStatus or Stage_Work_Element__r.Status__c'+
                        ' In: statusValueSet )'+ query + showCompleteCondition +' ORDER BY '+ sortField+' '+sortDirection;         
        }
        else if(FilterStatus == 'History'){
            StageStatus = 'Cancelled';
            queryString = 'SELECT id,name,Stage_Work_Element__r.Description_Text_Area__c,Team_Member_Name__c,Role_Name__c,Completed__c,Stage_Work_Element_Name__c,'+
                        ' Team_Members__r.User__r.Id,Stage_Work_Element__r.Work_Element_Name__c,'+
                        ' Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Deliverable_Name__c,'+
                        ' Stage_Work_Element__r.Status__c,Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Contribute_Due_Date__c,'+
                        ' Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id,Stage_Work_Element__r.Accountable_Process_Role_Name__c,'+
                        ' Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.Status__c from Contributor__c where (Team_Members__r.User__r.Id=:UserId '+
                        ' OR Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id =:UserId) AND (Stage_Work_Element__r.Release_Stage_ID__r.Status__c =: StageStatus or Stage_Work_Element__r.Status__c'+
                        ' In: statusValueSet )'+ query + showCompleteCondition +' ORDER BY '+ sortField+' '+sortDirection;         
        }
/*        
        queryString = 'SELECT id,name,Stage_Work_Element__r.Description_Text_Area__c,Team_Member_Name__c,Role_Name__c,Completed__c,Stage_Work_Element_Name__c,'+
                        ' Team_Members__r.User__r.Id,Stage_Work_Element__r.Work_Element_Name__c,'+
                        ' Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Deliverable_Name__c,'+
                        ' Stage_Work_Element__r.Status__c,Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Contribute_Due_Date__c,'+
                        ' Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id,Stage_Work_Element__r.Accountable_Process_Role_Name__c,'+
                        ' Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.Status__c from Contributor__c where (Team_Members__r.User__r.Id=:UserId '+
                        ' OR Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id =:UserId) AND (Stage_Work_Element__r.Release_Stage_ID__r.Status__c =: onholdstatus or Stage_Work_Element__r.Status__c'+
                        ' In: statusValueSet )'+ showCompleteCondition +' ORDER BY '+ sortField+' '+sortDirection;
*/                        
        system.debug('the query string is '+ queryString);
        contributors = database.query(queryString);
        ContriPagination= new ApexPages.StandardSetController(contributors);
        ContriPagination.setPageSize(25);

    }
    
    public PageReference InProgress() {
        flag = false;
        Recordspro = true;
        statusValueSet = new set<string>();
        statusValueSet.add('In Progress');
        contributionInProgressInfo();
        FilterStatus = 'In Progress';
        return null;
    }
    public PageReference upcoming() {
        FilterStatus = 'Upcoming';
        flag = true;
        Recordspro = false;
        RecordsUP= true;
        statusValueSet = new set<string>{'Not Started','On Hold'};
        contributionInProgressInfo();
        return null;
    }
    public PageReference history() 
    {
        FilterStatus = 'History';
        flag = true;
        Recordsnot= true;
        Recordspro = false;
        RecordsUP= false;
        statusValueSet = new set<string>{'Review Complete','Complete','Ready for Review','Under Review'};
        contributionInProgressInfo();
        return null;
    }
    
    public PageReference showCompleted() 
    {      
        contributionInProgressInfo();
        return null;
    }
    
    /* search filter action */
    public PageReference searchActLoad(){
        contributionInProgressInfo();
        return null;    
    }
    /* get select item name by select id*/
    private String queryName = '';
    public String getSelectItem(String selectId){
        if(selectId== '1'){
           queryName = 'Stage_Work_Element__r.Work_Element_Name__c';
        }else if(selectId== '2'){
            queryName = 'Stage_Work_Element__r.Status__c';
        }else if(selectId== '3'){
            queryName = 'Stage_Work_Element__r.Deliverable_Name__c';
        }else if(selectId== '4'){
            queryName = 'Stage_Work_Element__r.Accountable_Process_Role_Name__c';
        }else if(selectId== '5'){
            queryName = 'Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c';
        }else if(selectId== '6'){
            queryName = 'Stage_Work_Element__r.Stage_Name__c';
        }
        return queryName;
    }

     /*
    @Description: This methods returns the list of Contributor.
    */
    
    public list<Contributor__c> getConList(){
            return ContriPagination.getRecords();
    }
    
    /*
    @Description: This methods is invoked when clicked on the next button in the Contributor result table.
    */
    public void nextConPage(){
        ContriPagination.next();
    }
    
    /*
    @Description: This methods is invoked when clicked on the previous  button in the Contributor result table.
    @param: none.
    @return: void
    */
    public void previousConPage(){
        ContriPagination.previous();
    }
    
    /*
    @Description: This methods is invoked when clicked on the first page button in the Contributor result table.
    @param: none.
    @return: void
    */
    public void firstConPage(){
        ContriPagination.first();
    }
    
    /*
    @Description: This methods is invoked when clicked on the last page button in the Contributor result table.
    @param: none.
    @return: void
    */
    public void lastConPage(){
        ContriPagination.last();
    }
    
    /*
    @Description: This methods is used to check if there are more records to be shown in the next page.
    @param: none.
    @return: boolean
    */
    public boolean gethasConNext(){
        return ContriPagination.getHasNext();
    }
    
    /*
    @Description: This methods is used to check if there are records in the previous page.
    @param: none.
    @return: boolean
    */
    public boolean gethasConPrevious(){
        return ContriPagination.getHasPrevious();
    }
    
    /*
    @Description: This methods is used to get the number of records returned in the SOQL.
    @param: none.
    @return: integer
    */
    public integer getConResultSize(){
       return ContriPagination.getResultSize();
    }
    
    

    public List<SelectOption> getSearchItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Work Element Name'));
        options.add(new SelectOption('2','Work Element Status'));
        options.add(new SelectOption('3','Deliverable'));
        options.add(new SelectOption('4','Accountable Role'));
        options.add(new SelectOption('5','Project Name'));
        options.add(new SelectOption('6','Stage'));
        
        return options;
    }
    public string rating{get;set;}
    public string getRating(){ 
        Decimal r;
        rating = 'not';

        return rating;
    }
    
}