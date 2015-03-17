/***************************************************************************************************************
* Class Name: TMLocationTerritoryController 
* Author: HP
* Date: 11-JUN-2013
* Requirement # Request Id : R5:CR-7730
* Description: This custom controller contains the logic to show Locations falling under logged in User 
               through Territory on a VF page
*****************************************************************************************************************/

public with sharing class TMLocationTerritoryController{
    
    public Integer numberOfRecords{get;set;}
    
    public Integer size{get;set;}
    
    public boolean hasNext{
        get{
            return setController.getHasNext();
        }
        set;
    }
    
    public boolean hasPrevious{
        get{
            return setController.getHasPrevious();
        }
        set;
    }
    
    public Integer pageNumber{
        get{
            return setController.getPageNumber();
        }
        set;
    } 

    public ApexPages.StandardSetController setController{
        get{
            if(setController == null){
                Set<Id> salesTerritorySet = getUsersSalesTerritorySet(UserInfo.getUserId());
                size = 200;
                setController = new ApexPages.StandardSetController(Database.getQueryLocator([Select location__c,location__r.Location_Name__c,location__r.Account__r.Name,location__r.Country__c,location__r.City__c,Sales_Territory__r.MyComp_Sales_Territory_Name__c,location__r.Sell_Into_Market__c,location__r.MDCP_Organization_ID__c,location__r.Business_Relationship__c,location__r.Source_System_Account_ID__c,Sales_Territory__r.MyComp_Territory_Region__c,Sales_Territory__r.MyComp_Territory_Country__c,Sales_Territory__c from Sales_Territory_Location_Assignment__c where Sales_Territory__c IN :salesTerritorySet]));
                setController.setPageSize(size);
                numberOfRecords = setController.getResultSize();
            }
            return setController;
        }
        set;
    }
    
    /**
    * @description:Fetches set of Sales Territory assigned to the logged in User.
    * @params: userId
    * @returns: Set<Id> 
    */
    public Set<Id> getUsersSalesTerritorySet(Id userId){
        Set<Id> usersSalesTerritorySet = new Set<Id>();
        if(userId != null){
            for(Sales_Territory_User_Assignment__c stua:[Select Sales_Territory__c,Sales_Territory__r.Name From Sales_Territory_User_Assignment__c where User__c = :userId AND IsActive__c = true AND Sales_Territory__r.IsActive__c = true]){
                usersSalesTerritorySet .add(stua.Sales_Territory__c);
            }
        }
        return usersSalesTerritorySet;
    }
    /**
    * @description:Fetches all the location records related to logged in user through territories
    * @params: none
    * @returns: List<Sales_Territory_Location_Assignment__c>
    */
    public List<Sales_Territory_Location_Assignment__c> getLocations(){
        return setController.getRecords();
    }
    
    /**
    * @description:Fetches next set of records.
    * @params: none
    * @returns: void
    */
    public void next() {
        setController.next();
    }
    
    /**
    * @description:Fetches previous set of records.
    * @params: none
    * @returns: void
    */
    public void previous(){
        setController.previous();
    }
    
    /**
    * @description:Returns the first page of records.
    * @params: none
    * @returns: void
    */
    public void first(){
        setController.first();
    }
    
    /**
    * @description:Returns the last page of records.
    * @params: none
    * @returns: void
    */
    public void last(){
        setController.last();
    }
     
}