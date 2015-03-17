/*************************************************************************
* Class Name: PreviewLocationsController 
* Author: HP: Vinay M 
* Date: 19-MAR-2013 
* Requirement # Request Id:6201 
* Description: This custom controller contains the logic to fetch probable
        Locations as per definition of Territory and show them on a VF page
***************************************************************************/

public with sharing class TMPreviewLocationsController {

    public Sales_Territory__c salesTerritory { get;set; }
    transient public List<Location__c> locationList { get;set; }
    transient public List<Location__c> locationList1 { get;set; }
    transient public List<Location__c> locationList2 { get;set; }
    public Integer pageSize { get;set; }
    public Integer pageNumber { get;set; }
    public Integer noOfPages { get;set; }
    private Integer totalNoOfRecords { get;set; }
    private Integer i=0;
    public Integer totalSize;
    public List<Id> locIdList = new List<Id>();
     
    public TMPreviewLocationsController(ApexPages.StandardController controller) {
        salesTerritory = (Sales_Territory__c)controller.getRecord();
        pageSize = 50;
        String ctqr = getCount();
        totalNoOfRecords = Database.countQuery(getCount());
        pageNumber = 1;
        noOfPages = totalNoOfRecords/pageSize;
        if(Math.mod(totalNoOfRecords,pageSize) > 0){
            noOfPages++;
        }
        queryLocations();
    }
    /**
    * @description:Helps navigate to next page.
    * @params: void
    * @returns: PageReference 
    */
    public PageReference next(){
        pageNumber++;
        queryLocations();
        return null;
    }
    /**
    * @description:Helps navigate to previous page.
    * @params: void
    * @returns: PageReference 
    */
    public PageReference previous(){
        pageNumber--;
        if(pageNumber<1){
            return null;
        }
        queryLocations();
        return null;
    }
    /**
    * @description:Helps navigate to starting page.
    * @params: void
    * @returns: PageReference 
    */
    public PageReference beginning(){
        pageNumber = 1;
        queryLocations();
        return null;
    }
    /**
    * @description:Helps navigate to last page.
    * @params: void
    * @returns: PageReference 
    */
    public PageReference endp(){
        pageNumber = noOfPages;
        queryLocations();
        return null;
    }
    /**
    * @description:Checks if previous page button should be disabled or not.
    * @params: void
    * @returns: Boolean
    */
    public Boolean getDisablePrevious(){
        if(pageNumber > 1)
            return false;
        else
            return true;
    }
    /**
    * @description:Checks if next page button should be disabled or not.
    * @params: void
    * @returns: Boolean
    */
    public Boolean getDisableNext(){
        if(pageNumber * pageSize < totalNoOfRecords)
            return false;
        else
            return true;
    }
    /**
    * @description:Returns total number of records fetched.
    * @params: void
    * @returns: Integer
    */
    public Integer getTotalSize(){
        return totalNoOfRecords;
    }
    /**
    * @description:Returns total number of pages.
    * @params: void
    * @returns: Integer
    */
    public Integer getTotalPages(){
        if((math.mod(totalNoOfRecords,pageSize) > 0) || (totalNoOfRecords == 0)){
            return totalNoOfRecords/pageSize + 1;     
        }else{
            return (totalNoOfRecords/pageSize);
        }
    }
    /**
    * @description:Returns query string for the count of total number of records fetched based on condition.
    * @params: void
    * @returns: String
    */
    public String getCount(){
        transient String strQuery = 'SELECT Count() FROM Location__c WHERE (';
        transient String queryCon = '';
        
        for(Sales_Territory__c salesTerr: [Select Id,(Select Business_Relationship__c,Country__c,Geographic_Hierarchy__c,
                                            LocationPreviewQuery__c,MDCP_ID__c,Partner_Locator_Id__c,Postal_Code_End__c,
                                            Postal_Code_Start__c,State_Province__c From Sales_Territory_Definitions__r
                                            Where Exclude__c = False)From Sales_Territory__c  where Id = :salesTerritory.Id]){
            for(Sales_Territory_Definition__c std: salesTerr.Sales_Territory_Definitions__r ){
                if(std.LocationPreviewQuery__c != null && std.LocationPreviewQuery__c !=''){
                    if(std.Partner_Locator_Id__c != null || std.Country__c != null || std.Postal_Code_End__c !=null ||
                        std.Postal_Code_Start__c != null || std.Geographic_Hierarchy__c != null || std.State_Province__c != null){
                        queryCon += std.LocationPreviewQuery__c;
                    }
                }
            }
            if(queryCon.length() > 0){
                    strQuery += queryCon.substring(0,queryCon.length()-2);
            }else{
                strQuery += ('Id = null');
            }
        }
        return strQuery += ')';
    }
    /**
    * @description:Queries locations based on condition.
    * @params: void
    * @returns: void
    */
    private void queryLocations(){
        locationList2 = fetchAllLocations();
        if(!locationList2.isEmpty()){
            for(i=((pageNumber-1)*pageSize);i<(pageNumber*pageSize);i++)
                if(i < totalNoOfRecords)
                    locIdList.add(locationList2[i].Id);
                    
            String query = getQuery() + ') AND Id IN :locIdList Order by Name ASC';
            try{
                locationList = Database.query(query);
                locIdList.clear();
            }catch(Exception e){
                ApexPages.addMessages(e);
            }
        }
    }
    /**
    * @description:Fetches all locations based on condition.
    * @params: void
    * @returns: List of location objects
    */
    public List<Location__c> fetchAllLocations(){
        String strQuery1 = getQuery() + ') ORDER BY Name ASC';
        locationList1 = Database.query(strQuery1);
        return locationList1;
    }
    /**
    * @description:Returns query string.
    * @params: void
    * @returns: String
    */
    public String getQuery(){
        transient String strQuery = 'SELECT Id,Name,Location_Name__c,Business_Relationship__c,MDCP_Organization_ID__c,State__c,Country__c,Postal_Code__c,WorldRegion_Hierarchy__c FROM Location__c WHERE (';
        transient String queryCon = '';
        
        for(Sales_Territory__c salesTerr: [Select Id,(Select Business_Relationship__c,Country__c,Geographic_Hierarchy__c,
                                            LocationPreviewQuery__c,MDCP_ID__c,Partner_Locator_Id__c,Postal_Code_End__c,
                                            Postal_Code_Start__c,State_Province__c From Sales_Territory_Definitions__r
                                            Where Exclude__c = False)From Sales_Territory__c  where Id = :salesTerritory.Id]){
            for(Sales_Territory_Definition__c std: salesTerr.Sales_Territory_Definitions__r ){
                if(std.Partner_Locator_Id__c != null || std.Country__c != null || std.Postal_Code_End__c !=null ||
                        std.Postal_Code_Start__c != null || std.Geographic_Hierarchy__c != null || std.State_Province__c != null){
                        queryCon += std.LocationPreviewQuery__c;
                    }
            }
            if(queryCon.length() > 0){
                    strQuery += queryCon.substring(0,queryCon.length()-2);
                }else{
                    strQuery += ('Id = null');
                }
        }
        return strQuery;
    }
}