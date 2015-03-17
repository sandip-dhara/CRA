/**
* Class Name: AcctTerrListController 
* Author: Accenture
* Date: 27-Aug-2012 
* Description: This custom controller contains the logic to show Accounts falling under logged in User through Territory on a VF page
*/
public with sharing class AcctTerrListController{
    
  
    public List<Sales_Territory_Account_Assignment__c> accountAssignment{get;set;}
    transient List<Sales_Territory_Account_Assignment__c> accountAssignment2=new List<Sales_Territory_Account_Assignment__c>();
    transient List<Sales_Territory_Account_Assignment__c> accountAssignment1=new List<Sales_Territory_Account_Assignment__c>();
    public Integer pageSize{get;set;}
    public Integer noOfPages{get;set;}
    public Integer pageNumber{get;set;}
    private Integer totalNoOfRecs,i1=0,i=0;
    private integer counter=0;  //keeps track of the offset
    private integer list_size=20; //sets the page size or number of rows
    public integer total_size; //used to show user the total size of the list
    List<Id> terrUsersList=new List<Id>();
    List<Id> AccIdList=new List<Id>();
   
    // for standard list controllers 

     public AcctTerrListController() {
        terrUsersList=AcctTerrListController.getTerritoriesForUser(UserInfo.getUserId());
        pageSize = 200;
        //total_size = [select count() from Sales_Territory_Account_Assignment__c];
        totalNoOfRecs = Database.countQuery(getCount());
        pageNumber = 1;
        noOfPages = totalNoOfRecs/pageSize;
        if (Math.mod(totalNoOfRecs, pageSize) > 0)
            noOfPages++; 
        
        // call to queryAccountsAssignment to fetch initial set of Accounts
        queryAccountsAssignment();  
  }

   
    public PageReference next(){//User clicked next
        pageNumber++; 
        
        queryAccountsAssignment();
        return null;
    }

    public PageReference previous(){//User clicked next
        pageNumber--;
        if (pageNumber < 1)
            return null;
                    
        queryAccountsAssignment();
        return null;
    }
    
    
    private void queryAccountsAssignment()
    {  
        //Call AccountAssignment1 to fetch all records from query
        accountAssignment2=AccountAssignment1();
        system.debug('*******accountAssignment2*******'+accountAssignment2);
        if (!accountAssignment2.isEmpty()){
            for ( i=((pageNumber-1)*pageSize);i<(pageNumber*pageSize);i++){
            if (i<totalNoOfRecs)
            //Adding part of accountAssignment2 list to AccIdList
            AccIdList.add(accountAssignment2[i].Id);
           }
            system.debug('****AccIdList****'+AccIdList);       
            String query = getQuery() + ' AND Id IN :AccIdList Order by Account__r.Name ASC';
           // System.debug('Query is'+query);
            try{
                accountAssignment = Database.query(query);
                AccIdList.clear();
              }
            catch(Exception e){
                ApexPages.addMessages(e);
            }
       }  
    }
    
    public PageReference Beginning() { //user clicked beginning
      pageNumber = 1;
      queryAccountsAssignment();
      return null;
   }
      
   public PageReference End() { //user clicked end
      pageNumber = noOfPages ;
      queryAccountsAssignment();
      return null;
   }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (pageNumber>1) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (pageNumber * pageSize < totalNoOfRecs) return false; else return true;
   }

   public Integer getTotal_size() {
      return totalNoOfRecs;
   }

   public Integer getPageNumber() {
      return pageNumber/pageSize + 1;
   }
   
   
    public List <Sales_Territory_Account_Assignment__c> AccountAssignment1(){
        accountAssignment1=[SELECT Id,Sales_Territory__r.MyComp_Sales_Territory_Name__c  FROM Sales_Territory_Account_Assignment__c where Sales_Territory__c in:terrUsersList AND Sales_Territory__r.IsActive__c= True Order by Account__r.Name ASC];  
        return accountAssignment1;
    }
   
   public Integer getTotalPages() {
      if (math.mod(totalNoOfRecs, pageSize) > 0) {
         return totalNoOfRecs/pageSize + 1;
      } else {
         return (totalNoOfRecs/pageSize);
      }
   }
   
     public static List<Id> getTerritoriesForUser(String userId)
     {
         List<Id> listTerrIds = new List<Id>();
         List<Sales_Territory_User_Assignment__c> listTerrMembers = [Select Id, t.Sales_Territory__c From Sales_Territory_User_Assignment__c t
                                                 where t.User__c=:userId and t.IsActive__c = true];
                                                  
         if (listTerrMembers!=null && listTerrMembers.size()>0) {     
             for (Sales_Territory_User_Assignment__c ut:listTerrMembers) {
                 listTerrIds.add(ut.Sales_Territory__c);
             }
         }
          
         return listTerrIds;
     }
    
    public string getQuery(){
        
        transient string strQuery1='SELECT Sales_Territory__r.MyComp_Sales_Territory_Name__c,Account__c, Sales_Territory__c, Account__r.AMID_L2__c, Account__r.ShippingCity, Account__r.ShippingState, Account__r.ShippingCountry,Account__r.MDCP_Business_Relationship__c FROM Sales_Territory_Account_Assignment__c where Sales_Territory__c in:terrUsersList AND Sales_Territory__r.IsActive__c= True ';
        return strQuery1;
    }
    
    public string getCount(){
     
        transient string strQuery='SELECT count() FROM Sales_Territory_Account_Assignment__c where Sales_Territory__c in:terrUsersList AND Sales_Territory__r.IsActive__c= True';
        return strQuery;
        
    
    }
    
  
}