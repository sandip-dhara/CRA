/**********************************************************
* Class Name: PartnerOpptyHomePageListController
* Author: Accenture
* Date: 04-JULY-2012 
* Requirement # Request Id:
* Description: Controller class for custom list view of opportunity on partner home page.
***********************************************************/

public class PartnerOpptyHomePageListController {
    public List<Opportunity> partnerOpportunities{get;set;}
    public list<Opportunity> opptiesToBeUpdated{get;set;}
    public id selectedOppty{get;set;}
    string userId{get;set;}
    
    /**
    * @description: Class constructor method
    **/
    
    public PartnerOpptyHomePageListController(){
	    partnerOpportunities = new list<Opportunity>();
	    opptiesToBeUpdated = new list<Opportunity>();
	    userId = userInfo.getUserId();
    }
     
     /**
     * @description: initialization of the StandardSetController
     **/
          
    public apexPages.StandardSetController setOpptyHomePageList{
        get{
            
            if (setOpptyHomePageList == null){
                setOpptyHomePageList = new apexPages.StandardSetController (Database.getQueryLocator(
                [Select Name, Account.Name, Amount, CloseDate, StageName, Assigned_to_partner_date__c, Last_Modified_Full_Name__c From Opportunity
                WHERE Partner_acknowledged__c !=true  AND Converted_by_Partner__c !=true AND OwnerId =: userId AND Assigned_to_partner_date__c = LAST_N_DAYS:7
                ORDER BY LastModifiedDate desc]));
                
                //"LastModifiedDate = LAST_N_DAYS:7" is removed
                
                /**
                * @description: set the number of records for each page
                **/

                setOpptyHomePageList.setPageSize(5);
            }
            return setOpptyHomePageList;
        }
        set;
    }
    
    /**
    * @description: initialize and return opportunity list
    **/
    
    public List<Opportunity> getOpportunities() {
        partnerOpportunities = (List<Opportunity>) setOpptyHomePageList.getRecords();
        return partnerOpportunities;
    }
    
    /**
    * @description: Update checkbox 'partner acknowledged' on opportunity
    **/
    
    public void ackOppty() {
    	Database.SaveResult[] opptyUpdateResult;
        for(opportunity partOptty :partnerOpportunities){
            if(partOptty.id == selectedOppty){
                partOptty.Partner_acknowledged__c = true;
                opptiesToBeUpdated.add(partOptty);
            }
        }
        try {
            opptyUpdateResult =  database.update(opptiesToBeUpdated, false);
        }catch(Exception ex) {
            CreateApexErrorLog.insertHandledExceptions(ex, opptyUpdateResult, 'Opportunity', 'PartnerOpptyHomePageListController', 'Class');
        }
    }
    
    /*
    * @description: indicates whether there are more records after the current page set
    */
    
    public Boolean hasNext {
        get {
            return setOpptyHomePageList.getHasNext();
        }
        set;
    }
 
    /*
    * @description: indicates whether there are more records before the current page set
    */
    
    public Boolean hasPrevious {
        get {
            return setOpptyHomePageList.getHasPrevious();
        }
        set;
    }
 
    /*
    *@description: returns the page number of the current page set
    */
    
    public Integer pageNumber {
        get {
            return setOpptyHomePageList.getPageNumber();
        }
        set;
    }
 
    /*
    * @description: returns the first page of records
    */
    
    public void first() {
        setOpptyHomePageList.first();
    }
 
    /*
    * @description: returns the last page of records
    */
    
    public void last() {
        setOpptyHomePageList.last();
    }
 
    /*
    * @description: returns the previous page of records
    */
    
    public void previous() {
        setOpptyHomePageList.previous();
    }
 
    /*
    * @description: returns the next page of records
    */
    
    public void next() {
        setOpptyHomePageList.next();
    }
}