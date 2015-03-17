/**********************************************************
* Class Name: PCLM_PortalLeadOpptySearchController
* Author: HP  
* Date: 08-JANUARY-2013 
* Requirement #: 4042
* Description:This is used by the PartnerPortalLeadOpptySearch page to search and display the appropriate Lead and Opportunity.
              Only those records where the user is a owner or is part of the sales team are displayed in the result set.
**********************************************************/
public class PCLM_PortalLeadOpptySearchController{

    public string userInputValue;
    public string soqlLead;
    public string soqloppty;
    public list<lead> leadResultList= new list<Lead>();
    public list<opportunity> opptyResultList= new list<opportunity>();
    public list<id> teamMemberOpptyIdList = new list<id>();
    public ApexPages.StandardSetController leadPagination{get;set;}
    public ApexPages.StandardSetController opptyPagination{get;set;}
    public boolean insufficientCharLen{get;set;}
    
    /*@Description: This is the constructor. The logic here picks the search keyword from the URL and fetches those lead and opportunity where the name contains
                    the search keyword and displays only those records where the user is the owner of the record or is in the sales team.
      @param: none.
   */    
    public PCLM_PortalLeadOpptySearchController(){
           
        String userInputValue= ApexPages.currentPage().getParameters().get('searchText');
        String star='*';
        star=star.repeat(userInputValue.length());
        String percent='%';
        percent=percent.repeat(userInputValue.length());
        if(userInputValue.length()>1 && (!userInputValue.contains(star)&& !userInputValue.contains(percent))){
            insufficientCharLen = false;
            userInputValue = string.escapeSingleQuotes(userInputValue);
            userInputValue = userInputValue.replaceAll('\\*','%');
            userInputValue = '%'+userInputValue+'%';
            for(opportunityTeamMember otm : [select opportunityId from opportunityTeamMember where UserId = :userInfo.getuserId() AND (opportunity.name LIKE : userInputValue OR opportunity.Opportunity_ID__c LIKE : userInputValue OR opportunity.Deal_Id__c LIKE : userInputValue)]){
                teamMemberOpptyIdList.add(otm.opportunityId);
            }
            string teamMemeberId = getSalesTeamMemberIds(teamMemberOpptyIdList);
            
            soqlLead = 'SELECT id, name, title, email, status, company, phone, ownerid, owner.name, owner.alias FROM Lead WHERE (Name LIKE \''+userInputValue+'\' OR company LIKE \''+userInputValue+'\') AND  ownerId = \'' + userInfo.getUserID() + '\'' ;
            
            if(teamMemberOpptyIdList.size() > 0){
                soqlOppty = 'SELECT Id, Name, stageName, account.name, accountid, closeDate, Value__c, owner.alias, Owner.name, ownerId, Amount, type FROM opportunity WHERE (Name LIKE \''+userInputValue+'\' OR Opportunity_ID__c LIKE \''+userInputValue+'\' OR Deal_Id__c LIKE \''+userInputValue+'\' ) AND (OwnerId = \''+ userInfo.getUserId()+'\' OR Id IN ' + teamMemeberId+ ')';
            }else{
                soqlOppty = 'SELECT Id, Name, stageName, account.name, accountid, closeDate, Value__c, owner.alias, Owner.name, ownerId, Amount, type FROM opportunity WHERE (Name LIKE \''+userInputValue+'\' OR Opportunity_ID__c LIKE \''+userInputValue+'\' OR Deal_Id__c LIKE \''+userInputValue+'\' ) AND OwnerId = \''+ userInfo.getUserId()+'\'';
            }
            try{
                leadResultList = database.query(soqlLead  +' order by ' + sortFieldLead+ ' ' + sortDirLead);
                opptyResultList = database.query(soqlOppty + ' order by ' + sortFieldOppty + ' ' + sortDirOppty);
            } catch(exception e){}
            leadPagination= new ApexPages.StandardSetController(leadResultList);
            leadPagination.setPageSize(25);
            
            opptyPagination= new ApexPages.StandardSetController(opptyResultList);
            opptyPagination.setPageSize(25);
        } 
        else{
            insufficientCharLen = true;
            leadPagination= new ApexPages.StandardSetController(leadResultList);
            leadPagination.setPageSize(25);
            opptyPagination= new ApexPages.StandardSetController(opptyResultList);
            opptyPagination.setPageSize(25);
        }
    }
    
    // This getter-setter is used to get/set the sorting direction for thr opportunity result table. By default it is set to ASC.
    public String sortDirOppty {
        get  { if (sortDirOppty == null) {  sortDirOppty = 'asc'; } return sortDirOppty;}
        set;
    }
 
    // This getter-setter is used to get/set the field(column) name for which the sorting is applied in the Opportunity Table. It defaults to Name.
    public String sortFieldOppty {
        get  { if (sortFieldOppty == null) {sortFieldOppty = 'Name'; } return sortFieldOppty;  }
        set;
    } 
    
    /*
    @Description: This methods toggles the direction of sorting on the opportunity table.
    @param: none.
    @return: void.
    */
    public void toggleSortOppty() {
        // simply toggle the direction
        sortDirOppty = sortDirOppty.equals('asc') ? 'desc' : 'asc';
        // run the query again
        opptyResultList = Database.Query(soqlOppty + ' order by ' + sortFieldOppty+ ' ' + sortDirOppty );
        opptyPagination= new ApexPages.StandardSetController(opptyResultList);
        opptyPagination.setPageSize(25);
        getOpptyList();
    }
    
    // // This getter-setter is used to get/set the sorting direction for thr Lead result table. By default it is set to ASC.
    public String sortDirLead {
        get  { if (sortDirLead == null) {  sortDirLead = 'asc'; } return sortDirLead;}
        set;
    }
 
    // This getter-setter is used to get/set the field(column) name for which the sorting is applied in the Lead result Table. It defaults to Name.
    public String sortFieldLead {
        get  { if (sortFieldLead == null) {sortFieldLead = 'Name'; } return sortFieldLead;  }
        set;
    }
    
    /*
    @Description: This methods toggles the direction of sorting on the Lead table.
    @param: none.
    @return: void.
    */
    
    public void toggleSortLead() {
        // simply toggle the direction
        sortDirLead = sortDirLead.equals('asc') ? 'desc' : 'asc';
        // run the query again
        leadResultList = Database.Query(soqlLead + ' order by ' + sortFieldLead+ ' ' + sortDirLead );
        leadPagination= new ApexPages.StandardSetController(leadResultList);
        leadPagination.setPageSize(25);
        getleadList();
    }
    
    /*
    @Description: This methods returns the list of lead.
    @param: none.
    @return: list<lead>.
    */
    
    public list<lead> getleadList(){
            return leadPagination.getRecords();
    }
    
    /*
    @Description: This methods returns the list of opportunity.
    @param: none.
    @return: list<lead>.
    */
    public list<opportunity> getOpptyList(){
            return opptyPagination.getRecords();
    }
    
    /*
    @Description: This methods is invoked when clicked on the next button in the lead result table.
    @param: none.
    @return: void
    */
    public void nextLeadPage(){
        leadPagination.next();
    }
    
    /*
    @Description: This methods is invoked when clicked on the previous  button in the lead result table.
    @param: none.
    @return: void
    */
    public void previousLeadPage(){
        leadPagination.previous();
    }
    
    /*
    @Description: This methods is invoked when clicked on the first page button in the lead result table.
    @param: none.
    @return: void
    */
    public void firstLeadPage(){
        leadPagination.first();
    }
    
    /*
    @Description: This methods is invoked when clicked on the last page button in the lead result table.
    @param: none.
    @return: void
    */
    public void lastLeadPage(){
        leadPagination.last();
    }
    
    /*
    @Description: This methods is used to check if there are more records to be shown in the next page.
    @param: none.
    @return: boolean
    */
    public boolean gethasLeadNext(){
        return leadPagination.getHasNext();
    }
    
    /*
    @Description: This methods is used to check if there are records in the previous page.
    @param: none.
    @return: boolean
    */
    public boolean gethasLeadPrevious(){
        return leadPagination.getHasPrevious();
    }
    
    /*
    @Description: This methods is used to get the number of records returned in the SOQL.
    @param: none.
    @return: integer
    */
    public integer getleadResultSize(){
       return leadPagination.getResultSize();
    }
    
    /*
    @Description: This methods is invoked when clicked on the next  button in the opportunity result table.
    @param: none.
    @return: void
    */
    public void nextOpptyPage(){
        opptyPagination.next();
       // return null;
    }
    
    /*
    @Description: This methods is invoked when clicked on the previous  button in the opportunity result table.
    @param: none.
    @return: void
    */
    public void previousOpptyPage(){
        opptyPagination.previous();
    }
    
    /*
    @Description: This methods is invoked when clicked on the first  button in the opportunity result table.
    @param: none.
    @return: void
    */
    public void firstOpptyPage(){
        opptyPagination.first();
    }
    
    /*
    @Description: This methods is invoked when clicked on the last  button in the opportunity result table.
    @param: none.
    @return: void
    */
    public void lastOpptyPage(){
        opptyPagination.last();
    }
    
    //This getter-setter returs a boolean if there is next page.
    public boolean hasOpptyNext{
        get {
            return opptyPagination.getHasNext();
        }
        set;
    }
    
    //This Getter-setter returns a boolean. this is used tio check if there is a previous page.
    public boolean hasOpptyPrevious{
        get{
            return opptyPagination.getHasPrevious();
        }
        set;
    }
    /*
    @Description: This methods is used to get the size of the opportunity result set.
    @param: none.
    @return: integer.
    */
    public integer getopptyResultSize(){
        return opptyPagination.getResultSize();
    }
    
    /*
    @Description: This methods is used concatenate the teamMember id, so that it can be appropriately used in the database.query.
    @param: list<id>.
    @return: string.
    */
    
    private static string getSalesTeamMemberIds(list<id> IdsToConcatenate_List){
        string strReturnedIds = '(';
        for(id idItem : IdsToConcatenate_List){
            // If strReturnedIds is not empty, adds a comma as separator before adding new values.
            if(strReturnedIds.length() > 1)
            strReturnedIds += ','; 
            strReturnedIds += '\'' + idItem + '\'';
        }
        strReturnedIds += ')';
        return strReturnedIds;
    }
}