/**********************************************************
* Class Name: TMDisplayTerritoryUsersController 
* Author:  Sunder Singh Tanwar
* Date: July 1, 2013
* Requirement # US-2489 / R6.0
* Description: Controller for Display Territory user's button. Display Territory user's button will display a AF page report which will have sorting option on most of the fields and option to export the report in excel.
**********************************************************/

public with sharing class TMDisplayTerritoryUsersController {

    public PageReference backPage() {
            Id id = ApexPages.currentPage().getParameters().get('id');
            PageReference bkPg = new PageReference('/'+id);
            return bkPg;
    }


    public List<Sales_Territory_User_Assignment__c> STUAList { get; set; }
    public List<Sales_Territory_User_Assignment__c> STUAList1 { get; set; }
    public String SalesTerritoryLocAssignSet { get; set; }
    public String SalesTerritoryUserAssignSet { get; set; }
    private String sortDirection = 'DESC';
    public Boolean isCustomSort = false;
    private String sortExp = 'Add_to_Account_Team__c';
    public integer counter=0;  
    public integer list_size=200; 
    public integer total_size; 
       
    
    public TMDisplayTerritoryUsersController(ApexPages.StandardController controller) {
        //total_size = [select count() from Sales_Territory_User_Assignment__c where sales_territory__c IN :SalesTerritorySet]; //set the total size in the constructor
    }
  
  
  
  public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

public String getSortDirection()
{
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
   else
     return sortDirection;
}

public void setSortDirection(String value)
{  
   sortDirection = value;
}
    
public List<Sales_Territory_User_Assignment__c> getsalesTerritoryLocAssign() {
        Id id = ApexPages.currentPage().getParameters().get('id');
           
            List<Sales_Territory_Location_Assignment__c > STList = new List<Sales_Territory_Location_Assignment__c >([SELECT Sales_Territory__c From Sales_Territory_Location_Assignment__c WHERE Location__c = :id]);
            Set<Id> SalesTerritorySet = new Set<Id>();
            for(Sales_Territory_Location_Assignment__c STLA : STList)
            {
                           SalesTerritorySet.add(STLA.Sales_Territory__c);
                }
       //build the full sort expression
       string sortFullExp = sortExpression  + ' ' + sortDirection;
      
       //query the database based on the sort expression
       total_size = [select count() from Sales_Territory_User_Assignment__c where sales_territory__c IN :SalesTerritorySet and IsActive__c = True]; //set the total size in the constructor
       String stuaQueryString='Select Add_to_Account_Team__c,Team_Role__c,IsActive__c,Sales_Territory__r.Id,Sales_Territory__r.MyComp_Sales_Territory_Name__c,User__r.Name,User__r.UserRole.Name,User__r.Proudct_speciality__c,User__r.Email,User__r.Lead_Eligibility_Flag__c,User__r.Renewal_Eligible_Status__c,User__r.IsActive,Id,Sales_Territory__r.MyComp_Territory_Country__c,Sales_Territory__r.MyComp_Territory_Region__c from Sales_Territory_User_Assignment__c where IsActive__c = True and sales_territory__c IN :SalesTerritorySet order by ' + sortFullExp + ' limit '+ list_size + ' offset ' + counter;
       STUAList = Database.query(stuaQueryString);
       return STUAList;
    }

   public PageReference ViewData() {
       getsalesTerritoryLocAssign();  
       return null;
   }
   
   public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      counter += list_size;
      return null;
   }
 
   public PageReference End() { //user clicked end
      if(math.mod(total_size, list_size) !=0)
      {
          counter = total_size - math.mod(total_size, list_size);
      }
      else
      {
          counter = total_size - list_size;
       }
      return null;
   }
 
   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
   public Integer getListSize() {
      return list_size;
   }
 
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
   
   public Boolean getDisableExportToXLS() { //this will disable the export buttons
      if (total_size > 0) return false; else return true;
   }
    public PageReference exportToExcel() {
        return Page.TMDisplayTerritoryUsersExcel;
    }
    
}