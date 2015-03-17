public with sharing class Sree_ODP_NewContributionsPageController 
{
    public String searchFilter{get;set;}
    public String searchLabel{get;set;}
    public LIST<Contributor__c> contributors {get;set;}
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
    public String onholdstatus{get;set;}    
    public LIST<AggregateResult> projectName;// {get;set;}
    public Sree_ODP_NewContributionsPageController(){
        searchLabel = 'Search Filter';
        Recordspro = true;
        RecordsUP=false;
        Recordsnot= false;
        showComplete = false;
        UserId = UserInfo.getUserId();
        statusValueSet = new set<string>{'In Progress'};
        FilterStatus = 'In Progress';
        contributionInProgressInfo();
        onholdstatus = 'On Hold';    
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
        system.debug('the string set is '+ statusValueSet);
        sortField = sortField==null ? 'Role_Name__c': sortField;
        system.debug('the vlaue of the sortfield '+ sortField);
        
        showCompleteCondition = showComplete == true ? ' AND Completed__c = true ' : 'AND Completed__c = false'; 
        //showCompleteCondition = showComplete == true ? ' AND Completed__c = true ' : ' '; 
        
                string queryString = 'SELECT id,name,Stage_Work_Element__r.Description_Text_Area__c,Team_Member_Name__c,Role_Name__c,Completed__c,Stage_Work_Element_Name__c,'+
                                ' Team_Members__r.User__r.Id,Stage_Work_Element__r.Work_Element_Name__c,'+
                                ' Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Deliverable_Name__c,'+
                                ' Stage_Work_Element__r.Status__c,Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Contribute_Due_Date__c,'+
                                ' Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id,Stage_Work_Element__r.Accountable_Process_Role_Name__c,'+
                                ' Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.Status__c from Contributor__c where (Team_Members__r.User__r.Id=:UserId '+
                                ' OR Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id =:UserId) AND (Stage_Work_Element__r.Release_Stage_ID__r.Status__c =: onholdstatus or Stage_Work_Element__r.Status__c'+
                                ' In: statusValueSet )'+ showCompleteCondition +' ORDER BY '+ sortField+' '+sortDirection;
                system.debug('the query string is '+ queryString);
        contributors = database.query(queryString);
        
 /*       //Added for Project Name Filter
                String queryProjectName ='Select Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.Name__c from contributor__c where (Team_Members__r.User__r.Id = :UserId '+
                                ' OR Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id =:UserId) AND (Stage_Work_Element__r.Status__c In: statusValueSet ) '+ showCompleteCondition +' GROUP BY '+
                                ' Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.Name__c,id,name';
                                
               // list<AggregateResult> projectName = new list<AggregateResult>();
                projectName = database.query(queryProjectName);
                system.debug('Project Name: '+projectName );
                for(AggregateResult ar : projectName){
                 System.debug('In For loop :'+ar.get('id'));
                }
                //Select Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c from contributor__c where (Team_Members__r.User__r.Id = :UserId OR Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id =:UserId) AND (Stage_Work_Element__r.Status__c In: statusValueSet )'+ showCompleteCondition
                                
        //End of Project status Filter */
                        
        ContriPagination= new ApexPages.StandardSetController(contributors);
        ContriPagination.setPageSize(25);

    }
    
    //Added for Project Name Filter
        public List<SelectOption> getProjName() {
            set<String> pName = new set<String>();
            for(Contributor__c c : contributors){
                pName.add(c.Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c);
            }
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('0','--select--'));
            for(String ar : pName){
                options.add(new SelectOption(ar,ar));
            }
            return options;
        }
    //End of Project Name Filter
    
    //Added for Project Status Filter
        public List<SelectOption> getProjStatus() {
        integer i=0;
            set<String> pStatus = new set<String>();
            for(Contributor__c c : contributors){
                pStatus.add(c.Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.Status__c);
            }
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('0','--select--'));
                for(String ar : pStatus){
                if(ar!= null)
                    options.add(new SelectOption(ar,ar));
                else if(ar == null && i == 0)
                    options.add(new SelectOption('Blank','Blank'));
                    i++;
                }
                    
            return options;
        }
    //End of Project Status Filter
    
        //Added for Stage Filter
        public List<SelectOption> getStage() {
            set<String> stage = new set<String>();
            for(Contributor__c c : contributors){
                stage.add(c.Stage_Work_Element__r.Stage_Name__c);
            }
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('0','--select--'));
            for(String ar : stage){
                options.add(new SelectOption(ar,ar));
            }
            return options;
        }
    //End of Stage Filter
    
    //Added for My Role Filter
        public List<SelectOption> getMyRole() {
            set<String> myrole = new set<String>();
            for(Contributor__c c : contributors){
                myrole.add(c.Role_Name__c);
            }
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('0','--select--'));
            for(String ar : myrole){
                options.add(new SelectOption(ar,ar));
            }
            return options;
        }
    //End of My Role Filter
    
    //Added for Accountable Role Filter
        public List<SelectOption> getAccountableRole() {
            set<String> arole = new set<String>();
            for(Contributor__c c : contributors){
                arole.add(c.Stage_Work_Element__r.Accountable_Process_Role_Name__c);
            }
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('0','--select--'));
            for(String ar : arole ){
                options.add(new SelectOption(ar,ar));
            }
            return options;
        }
    //End of Accountable Role Filter
    
    //Added for Deliverable Filter
        public List<SelectOption> getDeliverable() {
        integer i=0;
            set<String> del = new set<String>();
            for(Contributor__c c : contributors){
                del.add(c.Stage_Work_Element__r.Deliverable_Name__c);
            }
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('0','--select--'));
            for(String ar : del ){
                if(ar!= null)
                    options.add(new SelectOption(ar,ar));
                else if(ar == null && i == 0)
                    options.add(new SelectOption('Blank','Blank'));
                    i++;
                }
            return options;
        }
    //End of Deliverable Filter
    
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
        statusValueSet = new set<string>();
        statusValueSet.add('Not Started');
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
        statusValueSet = new set<string>{'Rework','Review Complete','Complete','Ready for Review','Under Review'};
        contributionInProgressInfo();
        return null;
    }
    
    public PageReference showCompleted() 
    {
        //showComplete = showComplete == false? true:false;
        //statusValueSet = new set<string>();
        //statusValueSet.add('Complete');        
        contributionInProgressInfo();
        return null;
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
        options.add(new SelectOption('0','--select--'));
        options.add(new SelectOption('1','Work Element Status'));
        options.add(new SelectOption('2','Deliverable'));
        options.add(new SelectOption('3','Accountable Role'));
        options.add(new SelectOption('4','Project Name'));
        options.add(new SelectOption('5','Stage'));
        options.add(new SelectOption('6','Work Element Name'));
        return options;
    }
    public string rating{get;set;}
    public string getRating(){ 
        Decimal r;
        rating = 'not';

        return rating;
    }
    

}