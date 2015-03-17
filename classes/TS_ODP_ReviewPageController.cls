public class TS_ODP_ReviewPageController{ 

    public LIST<Review__c> reviewers {get;set;}
    public LIST<Review__c> reviewsFilter {get;set;}
    public string UserId {get;set;}
    public boolean Recordspro {get;set;}
    public boolean RecordsUP {get;set;}
    public boolean Recordsnot {get;set;}
    public boolean showComplete {get;set;}
    public boolean DisplayIndicator {get;set;}
    public string sortField{get;set;}
    public boolean flag{get;set;}
    public string showCompleteCondition{get;set;}
    public set<string> statusValueSet{get;set;}
    public ApexPages.StandardSetController RevPagination{get;set;}
    public String FilterStatus{get;set;}
    public String StageStatus{get;set;}
    public String selectItem{get;set;} 
    public String selectItemName {get;set;}        
    public TS_ODP_ReviewPageController()
    {
        searchLabel = 'Search Filter';
        Recordspro = true;
        RecordsUP=false;
        Recordsnot= false;
        showComplete = false;
        UserId = UserInfo.getUserId();
        statusValueSet = new set<string>{'Under Review'};
        FilterStatus = 'In Progress';
        reviewInProgressInfo();
        StageStatus= '';
        if(reviewers.size() == 0){
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
    
    
    Public void reviewInProgressInfo()
    {
        reviewers = new list<Review__c>();
        
        selectItemName = getSelectItem(selectItem);
        String query = '';
        if(selectItemName != ''){
            system.debug('the searchFilter string is '+ searchFilter );
            query = 'AND ( '+ selectItemName + ' LIKE '+'\''+ '%'+ searchFilter + '%'+ '\''+' )';
        }else{
            query ='';
        }
                
        sortField = sortField==null ? 'Role_Name__c': sortField;
        showCompleteCondition = showComplete == true ? ' AND Complete__c = true ' : '';
        
        //Added By Ning - Apr 23 2014
        //--When viewing upcoming reviews also show Work Elements that are associated with Stages where status = "On Hold"
        //--When viewing history of reviews, also show Work Elements that are associated with Stages where status = "Canceled"
        string queryString = '';
        if(FilterStatus == 'In Progress'){
            StageStatus = 'In Progress';
            queryString = 'SELECT id,name,Team_Member_Name__c,Rating__c,Role_Name__c,Complete__c,Stage_Work_Element_Name__c,'+
                               ' Team_Member__r.User__r.Id,Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Status__c,Stage_Work_Element__r.Work_Element_Name__c,'+
                               ' Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Deliverable_Name__c,'+
                               ' Stage_Work_Element__r.Status__c,Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Review_Due_Date__c,'+
                               ' Stage_Work_Element__r.Accountable_User__c,Stage_Work_Element__r.Accountable_Process_Role_Name__c from Review__c' + 
                               ' where (Team_Member__r.User__r.Id=:UserId or Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id = :UserId)'+
                               ' AND (Stage_Work_Element__r.Status__c In: statusValueSet)'+ query + showCompleteCondition +' ORDER BY '+ sortField+' '+sortDirection;        
        }
        else if(FilterStatus == 'Upcoming'){
            StageStatus = 'On Hold';
            queryString = 'SELECT id,name,Team_Member_Name__c,Rating__c,Role_Name__c,Complete__c,Stage_Work_Element_Name__c,'+
                               ' Team_Member__r.User__r.Id,Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Status__c,Stage_Work_Element__r.Work_Element_Name__c,'+
                               ' Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Deliverable_Name__c,'+
                               ' Stage_Work_Element__r.Status__c,Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Review_Due_Date__c,'+
                               ' Stage_Work_Element__r.Accountable_User__c,Stage_Work_Element__r.Accountable_Process_Role_Name__c from Review__c' + 
                               ' where (Team_Member__r.User__r.Id=:UserId or Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id = :UserId)'+
                               ' AND (Stage_Work_Element__r.Status__c In: statusValueSet or Stage_Work_Element__r.Release_Stage_ID__r.Status__c =: StageStatus)'+ query +showCompleteCondition +' ORDER BY '+ sortField+' '+sortDirection;        
        }
        else if(FilterStatus == 'History'){
            StageStatus = 'Cancelled';
            queryString = 'SELECT id,name,Team_Member_Name__c,Rating__c,Role_Name__c,Complete__c,Stage_Work_Element_Name__c,'+
                               ' Team_Member__r.User__r.Id,Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Status__c,Stage_Work_Element__r.Work_Element_Name__c,'+
                               ' Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Deliverable_Name__c,'+
                               ' Stage_Work_Element__r.Status__c,Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Review_Due_Date__c,'+
                               ' Stage_Work_Element__r.Accountable_User__c,Stage_Work_Element__r.Accountable_Process_Role_Name__c from Review__c' + 
                               ' where (Team_Member__r.User__r.Id=:UserId or Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id = :UserId)'+
                               ' AND (Stage_Work_Element__r.Status__c In: statusValueSet or Stage_Work_Element__r.Release_Stage_ID__r.Status__c =: StageStatus)'+ query +showCompleteCondition +' ORDER BY '+ sortField+' '+sortDirection;        
        }

        reviewers= database.query(queryString);
      
        RevPagination= new ApexPages.StandardSetController(reviewers);
        RevPagination.setPageSize(25);
/*  
        if(searchFilter != null && searchFilter != ''){
            RevPagination= new ApexPages.StandardSetController(filterByName(reviewers));
            RevPagination.setPageSize(25);
        }else{
            RevPagination= new ApexPages.StandardSetController(reviewers);
            RevPagination.setPageSize(25);
        }
*/        
    }
    
    public PageReference InProgress() {
        FilterStatus = 'In Progress';
        flag = false;
        Recordspro = true;
        statusValueSet = new set<string>();
//        statusValueSet.add('In Progress);
        statusValueSet.add('Under Review');
        reviewInProgressInfo();
        return null;
    }
    public PageReference upcoming() {
        FilterStatus = 'Upcoming';
        flag = true;
        Recordspro = false;
        RecordsUP= true;
        //statusValueSet = new set<string>();
        //statusValueSet.add('Not Started');
        statusValueSet = new set<string>{'In Progress','Ready for Review','Not Started'};
        reviewInProgressInfo();
        return null;
    }
    public PageReference history() 
    {
        FilterStatus = 'History';
        flag = true;
        Recordsnot= true;
        Recordspro = false;
        RecordsUP= false;
//        statusValueSet = new set<string>{'Rework','Review Complete','Complete','Ready for Review','Under Review'};
        statusValueSet = new set<string>{'Review Complete','Complete'};
        reviewInProgressInfo();
        return null;
    }
    public PageReference showCompleted() 
    {
        showComplete = showComplete == false? true:false;
        reviewInProgressInfo();
        return null;
    }


    
    /* Sofi - search filter action */
    public void searchActLoad(){
        reviewInProgressInfo();
        //return null;    
    }    
    /* Sofi - search filter method filterByName*/
    public LIST<Review__c> filterByName(LIST<Review__c> Reviews){
        reviewsFilter = new list<Review__c>();
        //system.debug('the selectItem string is '+ selectItem );
        if(selectItem == '1'){
            for(Review__c r : Reviews){
                if(r.Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c.contains(searchFilter) == true){
                  reviewsFilter.add(r);
                }
            }
        }
        if(selectItem == '2'){
            for(Review__c r : Reviews){
                if(r.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Status__c.contains(searchFilter) == true){
                  reviewsFilter.add(r);
                }
            }
        }
        if(selectItem == '3'){
            for(Review__c r : Reviews){
                if(r.Stage_Work_Element__r.Stage_Name__c.contains(searchFilter) == true){
                  reviewsFilter.add(r);
                }
            }
        }                       
        if(selectItem == '4'){
            for(Review__c r : Reviews){
                if(r.Stage_Work_Element__r.Deliverable_Name__c.contains(searchFilter) == true){
                  reviewsFilter.add(r);
                }
            }
        }
        if(selectItem == '5'){
            for(Review__c r : Reviews){
                if(r.Stage_Work_Element__r.Accountable_Process_Role_Name__c.contains(searchFilter) == true){
                  reviewsFilter.add(r);
                }
            }
        }


        return reviewsFilter;
    }
    private String queryName = '';
    public String getSelectItem(String selectId){
        if(selectId== '1'){
            queryName = 'Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c';
        }
        if(selectId== '2'){
            queryName = 'Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Status__c';
        }        
        if(selectId== '3'){
            queryName = 'Stage_Work_Element__r.Stage_Name__c';
        }
        if(selectId== '4'){
            queryName = 'Stage_Work_Element__r.Deliverable_Name__c';
        }
        if(selectId== '5'){
            queryName = 'Stage_Work_Element__r.Accountable_Process_Role_Name__c';
        }
        return queryName;
    }    

 /*
    @Description: This methods returns the list of Reviewer.
    */
    
    public list<Review__c> getRevList(){
            return RevPagination.getRecords();
    }
    
    /*
    @Description: This methods is invoked when clicked on the next button in the Reviewer result table.
    */
    public void nextRevPage(){
        RevPagination.next();
    }
    
    /*
    @Description: This methods is invoked when clicked on the previous  button in the Reviewer result table.
    @param: none.
    @return: void
    */
    public void previousRevPage(){
        RevPagination.previous();
    }
    
    /*
    @Description: This methods is invoked when clicked on the first page button in the Reviewer result table.
    @param: none.
    @return: void
    */
    public void firstRevPage(){
        RevPagination.first();
    }
    
    /*
    @Description: This methods is invoked when clicked on the last page button in the Reviewer result table.
    @param: none.
    @return: void
    */
    public void lastRevPage(){
        RevPagination.last();
    }
    
    /*
    @Description: This methods is used to check if there are more records to be shown in the next page.
    @param: none.
    @return: boolean
    */
    public boolean gethasRevNext(){
        return RevPagination.getHasNext();
    }
    
    /*
    @Description: This methods is used to check if there are records in the previous page.
    @param: none.
    @return: boolean
    */
    public boolean gethasRevPrevious(){
        return RevPagination.getHasPrevious();
    }
    
    /*
    @Description: This methods is used to get the number of records returned in the SOQL.
    @param: none.
    @return: integer
    */
    public integer getRevResultSize(){
       return RevPagination.getResultSize();
    }
    
    public Id mid{get;set;}
    public String GetRating(){
        return 'myId:' + String.ValueOf(mid);
    }
    
    
    public String searchFilter{get;set;}
    public String searchLabel{get;set;}
    public List<SelectOption> getSearchItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Project Name'));
        options.add(new SelectOption('2','Project Status'));
        options.add(new SelectOption('3','Stage'));                        
        options.add(new SelectOption('4','Deliverable'));
        options.add(new SelectOption('5','Accountable Role'));
        return options;
    } 
    public string Sitems{get;set;}
    public string getSitems(){ 
        Decimal r;
        Sitems= 'not';

        return Sitems;
    }
}