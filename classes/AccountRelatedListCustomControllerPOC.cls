public class AccountRelatedListCustomControllerPOC {

String acctId = ApexPages.currentPage().getParameters().get('id');
   
public List<Opportunity> OpportunityList { get; set; }
public List<Contact> ContactList { get; set; }
public List<Lead> LeadList { get; set; }
//  public List<Account> AccountList { get; set; }
public List<OpenActivity> ActivityList { get; set; }
    
public AccountRelatedListCustomControllerPOC() {
    OpportunityList = new List<Opportunity>();
    OpportunityList = (List<Opportunity>)[Select ID, Name, RecordTypeId, StageName, CloseDate, Value__c  from Opportunity where AccountId = :acctId];
    
    ContactList = new List<Contact>();
    ContactList = (List<Contact>)[Select ID, Name, Title, Email, Phone__c, Left_Company__c from Contact where AccountId = :acctId];

    LeadList = new List<Lead>();
    LeadList = (List<Lead>)[Select ID, Name, Company, Country, Email, Status, Created_Calendar_Date__c, Timeframe_to_Buy_1__c, Estimated_Budget__c from Lead where Account_Name__c = :acctId];


    //*****  This did not work for getting the OpenActivites for the Account
    //    AccountList = new List<Account>();
    //    AccountList = (List<Account>)[SELECT (SELECT ID, ActivityDate, Description, Subject FROM OpenActivities) FROM Account where ID = :acctId];
    //    System.debug(AccountList.OpenActivites);
    //    ActivityList = new List<Task>();
    //    ActivityList = (List<Task>)AccountList.OpenActivities;
    
    //****  This works for retieving the OpenActivities for the Account
    for (Account acct : [SELECT ID, Name, (SELECT ID, Subject, WhoId, Who.Name, WhatId, ActivityDate, Status, Priority, OwnerId, Owner.Name FROM OpenActivities) FROM Account where ID = :acctId]){
        ActivityList = acct.OpenActivities;  
    }  
}
}