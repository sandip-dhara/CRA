public class ODP_RisksController {
    public String searchFilter{get;set;}
    public String searchLabel{get;set;}
    public LIST<Risks__c> risks{get;set;}
    public LIST<Risks__c> risksFilter{get;set;}
    public LIST<Risks__c> RisksList{get;set;}
    public ApexPages.StandardSetController Pagination{get;set;}
    public String FilterStatus {get;set;}
    public boolean ShowCompleted{get;set;}
    public String SortField{get;set;}
    private String sortDirection = 'ASC';
    public String selectItem{get;set;}
    public string selectItemName{get;set;}
    public string Role{get;set;}
    public List<Core_Team_Member__c> ctms{get;set;}
    public Core_Team_Member__c ctm{get;set;}
    public string uname{get;set;}
    public boolean IsPM{get;set;}
    public boolean IsRiskOwner{get;set;}
    public string uid {get;set;}   
    public String getSortDirection()
    {
         return (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }

    public void setSortDirection(String value)
    {  
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }
    
    public ODP_RisksController ()
    {
        IsPM = false;
        IsRiskOwner = false;
        uid= UserInfo.getUserId(); 
        SortField = 'Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Name__c';
        doQuery();
        
    }
    
    
    public void Sort()
    {
        doQuery();
    }

    
    public void doQuery()
    {    
        selectItemName = getSelectItem(selectItem);
        String query = '';
        if(selectItemName != ''){
            if(!selectItemName.contains('Risk_Priority_Number__c')){
                //system.debug('the searchFilter string is '+ searchFilter );
                query = ' and '+ selectItemName + ' LIKE '+'\''+ '%'+ searchFilter + '%'+ '\' ';
            }else{
                //query = ' and '+ selectItemName +  searchFilter;
                system.debug('the searchFilter string is '+ query);
            }    
        }else{
            query ='';
        }
    

        Set<string> projects = new Set<string>();
        ctms = [select id,Role_Name__c,Release_Role__c,Release_Name__c,User__r.Id from Core_Team_Member__c where User__r.Id=:uid];
       // ctm = [SELECT Id,Name,Release_Name__c,Release_Role__c,Role_Name__c,User__r.Last_First_Name__c FROM Core_Team_Member__c where User__c =:uid limit 1];
         ctm = [SELECT User__r.Last_First_Name__c FROM Core_Team_Member__c where User__c =:uid limit 1];
        uname = ctm.User__r.Last_First_Name__c; 
        //if(ctm != null){
        //    IsPM = true;
        //    IsRiskOwner = true; 
        //}
        
        for(Core_Team_Member__c c:ctms){
            if(!projects.contains(c.Release_Name__c))
                projects.add(c.Release_Name__c);
        }
            
        string queryString = 'select Id,Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Name__c,'+
                                     'Business_Impact_ID__r.Severity__c,Description__c,Name__c,Risk_Owner__r.Name,Risk_Owner__r.Last_First_Name__c,Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Owner__c,'+
                                     'Planned_Resolution_Date__c,Process_Control_ID__r.Detection__c,Risk_Priority_Number__c,'+
                                     'Root_Cause_ID__r.Occurance__c,Status__c '+
                                'from Risks__c '+   
                               'where Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Name__c in :projects '+ query +' Order By '+ SortField +' '+ SortDirection;                       

        risks = Database.Query(queryString);

        Pagination= new ApexPages.StandardSetController(risks);
        Pagination.setPageSize(25);
       
    }

    
    /* Sofi - search filter action */
    public void searchActLoad(){
        doQuery();
        //return null;    
    }    
   
    public List<SelectOption> getSearchItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Project'));
        options.add(new SelectOption('2','Risk'));
        options.add(new SelectOption('3','Status'));
        options.add(new SelectOption('4','RPN >='));
        options.add(new SelectOption('5','RPN <='));
        return options;
    } 
    
    
    
    private String queryName = '';
    public String getSelectItem(String selectId){
        if(selectId== '1'){
            queryName = 'Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Name__c';
        }else if(selectId== '2'){
            queryName = 'Name__c';
        }else if(selectId== '3'){
            queryName = 'Status__c';
        }else if(selectId=='4'){
            queryName = ' Risk_Priority_Number__c >= ';
        }else if(selectId=='5'){
            queryName = ' Risk_Priority_Number__c <= ';
        }
        
        return queryName;
    }
    
    
    /*
    @Description: This methods returns the list of Contributor.
    */
    
    public list<Release_Stage__c> getConList(){
            return Pagination.getRecords();
    }
    
     public list<Risks__c> getRisksList(){
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