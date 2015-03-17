/**********************************************************
* Class Name: ABPSharelistcontroller
* Author: HP
* Date:15/06/2013
* Requirement # Request Id:3276
* Description: Controller for ABPsharedMembers2 vf page to display members in the Account Plan sharing.
              
***********************************************************/

public class ABPSharelistcontroller {

    public ABPSharelistcontroller(ApexPages.StandardController controller) {

    }


    public List<cAccountShare> AccountShares {get; set;}

 public PageReference getRecordsToDisplay() {
        AccountShares = new List<cAccountShare>(); //set the AccountShares object to a new cAccountShare List
        Integer counter = 1; //row counter variable
        for ( Account_Plan__Share a : [SELECT Id, UserOrGroupId, AccessLevel, RowCause, LastModifiedDate FROM Account_Plan__Share  where ParentId =: ApexPages.currentPage().getParameters().get('id') and RowCause !='Rule'  ORDER BY LastModifiedDate DESC LIMIT 100]) { //query for the details of the records you want to display
            AccountShares.add(new cAccountShare(a)); //add the account and counter to our list
        }
        return null; //return the list of full records plus their row counter
    }



public class cAccountShare {
 public Account_Plan__Share share {get; set;}
 public User user {get; set;}
 public Group theGroup {get; set;}
 
 //public cAccountShare(){}
 
 public cAccountShare(Account_Plan__Share sParam) {
     share = sParam;
     String UserOrGroupId = String.valueOf(share.UserOrGroupId);
     if(UserOrGroupId.startsWith('005')){
         user = [SELECT Name,Business_Group__c,Employee_Country__c, Id FROM User WHERE id = :share.UserOrGroupId LIMIT 1];
     }else if(UserOrGroupId.startsWith('00G')){
         theGroup = [SELECT Name, Id FROM Group WHERE id = :share.UserOrGroupId LIMIT 1];
     }
  }
 }


}