/**
* Class Name: AcctTerrListController 
* Author: Accenture
* Date: 27-Aug-2012 
* Description: This custom controller contains the logic to fetch probable Accounts as per definition of Territory and show them on a VF page
*/

public with sharing class SalesTerritoryPreview {
    
    public Sales_Territory__c salesTerr { get; set; }
    transient public List<Account> accounts{get;set;}
    transient List<Account> accounts1 = new List<Account>();
    transient List<Account> accounts2=new List<Account>();
    public Integer pageSize{get;set;}
    public Integer noOfPages{get;set;}
    public Integer pageNumber{get;set;}
    private Integer totalNoOfRecs,i1=0,i=0;
    private integer counter=0;  //keeps track of the offset
    private integer list_size=20; //sets the page size or number of rows
    public integer total_size; //used to show user the total size of the list
    List<Id> AccIdList=new List<Id>();
    
    
    public SalesTerritoryPreview(ApexPages.StandardController controller) {
        salesTerr = (Sales_Territory__c)controller.getRecord();  
        pageSize = 200;
    //TM:Debmalya:ALM5543:Comenting query on Account
        //total_size = [select count() from Account];
        system.debug(getCount());
        totalNoOfRecs = Database.countQuery(getCount());
        pageNumber = 1; 
        noOfPages = totalNoOfRecs/pageSize;
        if (Math.mod(totalNoOfRecs, pageSize) > 0)
            noOfPages++;
            
        //fetch initial set of Accounts
        queryAccounts();
        //getInitialAccountSet();  
    }

    public PageReference next(){ //User clciked next
        pageNumber++; 
        
        queryAccounts();
        return null;
    }

    public PageReference previous(){ //User clicked previous
        pageNumber--;
        if (pageNumber < 1)
            return null;
        
        queryAccounts();
        return null;
    }
    
    
    private void queryAccounts()
    {   
    
        //fetch all accounts 
        accounts2=fetchAllAccounts();
        system.debug('*******accounts2*******'+accounts2);
        if(!accounts2.isEmpty()){
        for ( i=((pageNumber-1)*pageSize);i<(pageNumber*pageSize);i++)
        if (i<totalNoOfRecs)
        AccIdList.add(accounts2[i].Id);
        system.debug('****AccIdList****'+AccIdList);
        String query = getQuery() + ') AND Id IN :AccIdList Order by Name ASC';
        System.debug('Query is'+query);
        try{
            accounts = Database.query(query);
            AccIdList.clear();
          }
        catch(Exception e){
            ApexPages.addMessages(e);
        }      
    }
   }
    
    public PageReference Beginning() { //user clicked beginning
      pageNumber = 1;
      queryAccounts();
      return null;
   }

   public PageReference End() { //user clicked end
      pageNumber = noOfPages ;
      queryAccounts();
      return null;
   }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (pageNumber>1) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (pageNumber * pageSize < totalNoOfRecs) return false; else return true;
   }
   
     public List <Account> fetchAllAccounts(){
        
        string strQuery1=getQuery() + ' ) Order By Name ASC';
        accounts1=Database.query(strQuery1);
        return accounts1;
        
    }

   public Integer getTotal_size() {
      return totalNoOfRecs;
   }

   public Integer getPageNumber() {
      return pageNumber/pageSize + 1;
   }

   public Integer getTotalPages() {
      if ((math.mod(totalNoOfRecs, pageSize) > 0) || (totalNoOfRecs == 0)) {
         return totalNoOfRecs/pageSize + 1;
      } else {
         return (totalNoOfRecs/pageSize);
      }
   }
    
    public string getQuery(){
      transient string strQuery = 'SELECT Id, Name, Industry_Vertical__c,AMID_L2__c,Confidential_Account__c, Named_Account__c , RAD__c, Coverage_Segmentation__c, World_Region__c, ShippingCountry, ShippingState, ShippingPostalCode FROM  Account  WHERE (';
      transient string querycon = '';
      //List<Sales_Territory__c> sterrList=[Select Id ,(Select AMID__c,Country__c,Geographic_Hierarchy__c,Industry_Vertical__c,MDCP_ID__c,Postal_Code_End__c,
                                               // Postal_Code_Start__c,Source_System_ID__c,State_Province__c, AccountPreviewQuery__c from Sales_Territory_Definitions__r) from Sales_Territory__c  where Id = :salesTerr.Id];
          
      //TM: Debmalya: Req 2089: Modify query to exclude definition with exclude checkbox checked 
          for (Sales_Territory__c stdObj:[Select Id ,(Select AMID__c,Business_Relationship__c,Partner_Locator_Id__c,Country__c,Geographic_Hierarchy__c,Industry_Vertical__c,MDCP_ID__c,Postal_Code_End__c,
                                                Postal_Code_Start__c,Source_System_ID__c,State_Province__c, AccountPreviewQuery__c from Sales_Territory_Definitions__r where Exclude__c = false) from Sales_Territory__c  where Id = :salesTerr.Id]){
            for (Sales_Territory_Definition__c salesTerrDefObj:stdObj.Sales_Territory_Definitions__r ){
                
                 system.debug('Value of Partner Locator ID is '+ salesTerrDefObj.Partner_Locator_Id__c);
           /* TM-R5:Modified the acccount preview query because of location object :Start: Mukul*/ 
                if (salesTerrDefObj.AccountPreviewQuery__c!=null &&
                   ((salesTerrDefObj.Partner_Locator_Id__c == null)))
                {
                	if(((salesTerrDefObj.Country__c ==null || 
                 		(salesTerrDefObj.Country__c ==null && salesTerrDefObj.State_Province__c ==null)||
                 		(salesTerrDefObj.Country__c ==null && salesTerrDefObj.Postal_Code_Start__c ==null)||
                 		(salesTerrDefObj.Geographic_Hierarchy__c ==null))))
                 		{	
                 	 		querycon += salesTerrDefObj.AccountPreviewQuery__c;
                 		}
                 		else if(!(salesTerrDefObj.MDCP_ID__c!=null && salesTerrDefObj.Business_Relationship__c!=null))
                 		{
                 			querycon += salesTerrDefObj.AccountPreviewQuery__c;
                 		}
                }
                 /* TM-R5:Modified the acccount preview query because of location object :End: Mukul*/ 
            }
             
            if(querycon.length()>0){
                 strQuery += (querycon.substring(0, querycon.length()-2));
             } else {
                 strQuery += (' Id = null ');
             }
             system.debug('************strQuery***********'+strQuery);
          }
      //TM: Debmalya: Req 2089: Remove Account which do not qualify due to Exclude Definition Criterias: Start
          querycon = '';
          for (Sales_Territory__c stdObj:[Select Id ,(Select AMID__c,Business_Relationship__c,Partner_Locator_Id__c,Country__c,Geographic_Hierarchy__c,Industry_Vertical__c,MDCP_ID__c,Postal_Code_End__c,
                                                    Postal_Code_Start__c,Source_System_ID__c,State_Province__c, AccountPreviewQuery__c from Sales_Territory_Definitions__r where Exclude__c = true) from Sales_Territory__c  where Id = :salesTerr.Id]){
             if(stdObj.Sales_Territory_Definitions__r.size() > 0){
                 strQuery += ') AND (';
             }
             for (Sales_Territory_Definition__c salesTerrDefObj:stdObj.Sales_Territory_Definitions__r ){
                
                 system.debug('Value of Partner Locator ID is '+ salesTerrDefObj.Partner_Locator_Id__c);
                String previewquery = salesTerrDefObj.AccountPreviewQuery__c;
                 /* TM-R5:Modified the acccount preview query because of location object :Start: Mukul*/ 
                 if (salesTerrDefObj.AccountPreviewQuery__c!=null && 
                 ((salesTerrDefObj.Partner_Locator_Id__c == null)))
             	{
             		if(((salesTerrDefObj.Country__c ==null || 
                 		(salesTerrDefObj.Country__c ==null && salesTerrDefObj.State_Province__c ==null)||
                 		(salesTerrDefObj.Country__c ==null && salesTerrDefObj.Postal_Code_Start__c ==null)||
                 		(salesTerrDefObj.Geographic_Hierarchy__c ==null))))
                 		{		
                 	 		querycon += salesTerrDefObj.AccountPreviewQuery__c;
                 		}
                 		else if(!(salesTerrDefObj.MDCP_ID__c!=null && salesTerrDefObj.Business_Relationship__c!=null))
                 		{
                 				
                 	 		querycon += salesTerrDefObj.AccountPreviewQuery__c;
                 		}
             	} 
             	 /* TM-R5:Modified the acccount preview query because of location object :End: Mukul*/  
             }
                         
             if(querycon.length()>0){
                strQuery += (querycon.substring(0, querycon.length()-3));
             } 
             system.debug('************strQuery***********'+strQuery);
          }
      //TM: Debmalya: Req 2089: Remove Account which do not qualify due to Exclude Definition Criterias: End
          
      return strQuery;
      
    }
    
    public string getCount(){
      transient string strQuery = 'SELECT Count() FROM  Account WHERE (';
      transient string querycon = '';
      //List<Sales_Territory__c> sterrList=[Select Id ,(Select AMID__c,Country__c,Geographic_Hierarchy__c,Industry_Vertical__c,MDCP_ID__c,Postal_Code_End__c,
                                               // Postal_Code_Start__c,Source_System_ID__c,State_Province__c, AccountPreviewQuery__c from Sales_Territory_Definitions__r) from Sales_Territory__c  where Id = :salesTerr.Id];
          
      //TM: Debmalya: Req 2089: Modify query to exclude definition with exclude checkbox checked 
          for (Sales_Territory__c stdObj:[Select Id ,(Select Business_Relationship__c,Partner_Locator_Id__c,AMID__c,Country__c,Geographic_Hierarchy__c,Industry_Vertical__c,MDCP_ID__c,Postal_Code_End__c,
                                                Postal_Code_Start__c,Source_System_ID__c,State_Province__c, AccountPreviewQuery__c from Sales_Territory_Definitions__r where Exclude__c = false) from Sales_Territory__c  where Id = :salesTerr.Id]){
            for (Sales_Territory_Definition__c salesTerrDefObj:stdObj.Sales_Territory_Definitions__r ){
                
                 system.debug('Value of Partner Locator ID is '+ salesTerrDefObj.Partner_Locator_Id__c);
                 /* TM-R5:Modified the acccount preview query because of location object :Start: Mukul*/ 
                if (salesTerrDefObj.AccountPreviewQuery__c!=null &&
                	((salesTerrDefObj.Partner_Locator_Id__c == null)))
               
               {
               		if(((salesTerrDefObj.Country__c ==null || 
                 		(salesTerrDefObj.Country__c ==null && salesTerrDefObj.State_Province__c ==null)||
                 		(salesTerrDefObj.Country__c ==null && salesTerrDefObj.Postal_Code_Start__c ==null)||
                 		(salesTerrDefObj.Geographic_Hierarchy__c ==null))))
                 		{		
                 	 		querycon += salesTerrDefObj.AccountPreviewQuery__c;
                 		}
                 		else if(!(salesTerrDefObj.MDCP_ID__c!=null && salesTerrDefObj.Business_Relationship__c!=null))
                 		{
                 			
                 	 		querycon += salesTerrDefObj.AccountPreviewQuery__c;
                 		}
               }
                /* TM-R5:Modified the acccount preview query because of location object :End: Mukul*/ 
            }
                      
            if(querycon.length()>0){
                 strQuery += querycon.substring(0, querycon.length()-2);
             } else {
                 strQuery += (' Id = null ');
             }
             system.debug('************strQuery***********'+strQuery);
          }
          //TM: Debmalya: Req 2089: Remove Account which do not qualify due to Exclude Definition Criterias: Start
          querycon = '';
          for (Sales_Territory__c stdObj:[Select Id ,(Select AMID__c,Business_Relationship__c,Partner_Locator_Id__c,Country__c,Geographic_Hierarchy__c,Industry_Vertical__c,MDCP_ID__c,Postal_Code_End__c,
                                                    Postal_Code_Start__c,Source_System_ID__c,State_Province__c, AccountPreviewQuery__c from Sales_Territory_Definitions__r where Exclude__c = true) from Sales_Territory__c  where Id = :salesTerr.Id]){
             if(stdObj.Sales_Territory_Definitions__r.size() > 0){
                 strQuery += ') AND (';
             }
             for (Sales_Territory_Definition__c salesTerrDefObj:stdObj.Sales_Territory_Definitions__r ){
                
                system.debug('Value of Partner Locator ID is '+ salesTerrDefObj.Partner_Locator_Id__c);
                 /* TM-R5:Modified the acccount preview query because of location object :Start: Mukul*/ 
                 if (salesTerrDefObj.AccountPreviewQuery__c!=null && ((salesTerrDefObj.Partner_Locator_Id__c == null)))
                 {
                 		if(((salesTerrDefObj.Country__c ==null || 
                 		(salesTerrDefObj.Country__c ==null && salesTerrDefObj.State_Province__c ==null)||
                 		(salesTerrDefObj.Country__c ==null && salesTerrDefObj.Postal_Code_Start__c ==null)||
                 		(salesTerrDefObj.Geographic_Hierarchy__c ==null))))
                 		{	
                 	 		querycon += salesTerrDefObj.AccountPreviewQuery__c;
                 		}
                 		else if(!(salesTerrDefObj.MDCP_ID__c!=null && salesTerrDefObj.Business_Relationship__c!=null))
                 		{                 			
                 	 		querycon += salesTerrDefObj.AccountPreviewQuery__c;
                 		}
                 }
                    /* TM-R5:Modified the acccount preview query because of location object :End: Mukul*/         
                
             }
            
             if(querycon.length()>0){
                strQuery += (querycon.substring(0, querycon.length()-3));
             } 
             system.debug('************strQuery***********'+strQuery);
          }
         //TM: Debmalya: Req 2089: Remove Account which do not qualify due to Exclude Definition Criterias: End
          
      return strQuery +=')';
      
    }

}