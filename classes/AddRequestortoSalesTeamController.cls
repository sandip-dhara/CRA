/************************************
Name : AddRequestortoSalesTeamController 
Author: Abrar
Date: 29/07/2013
Desc : Controller for Add to Sales Team Request
*************************************/

public class AddRequestortoSalesTeamController {

    public Add_to_Sales_Team__c SalesTeam{get; set;}
    public String OpId;
    public String Optyname;
    public String STMessage{get; set;}
    
    /* Constructor for getting Opty Id, Name */
    
    public AddRequestortoSalesTeamController(ApexPages.StandardController controller) {
         OpId= ApexPages.CurrentPage().getParameters().get('Id');
         Optyname= ApexPages.CurrentPage().getParameters().get('Name');
         SalesTeam = new Add_to_Sales_Team__c();
    }
    
    /* code for Save method for inserting record*/
    
    public PageReference save() {
        
        Opportunity opty = [select Owner__c from Opportunity where Id =:OpId];
        SalesTeam.Opportunity__c = OpId;
        SalesTeam.RequestedUser__c= UserInfo.getName();
        SalesTeam.Requested_user_Id__c = UserInfo.getUserId();
        SalesTeam.Status__c = 'Pending'; //making status to Pending for newly inserted record.

        /*insert statement to insert record  in Add_to_sales_team__c */
        insert SalesTeam;
        
        //system.debug('Owner@@@@'+SalesTeam.Opportunity_Owner__c);
        
        /* Desc : Code for inserting a Chatter feed 
        on creation of the Add_to_sales_team__c record
         on the opty owner profile */
         
        FeedItem post = new FeedItem();
        post.ParentId = opty.Owner__c;
        post.Body = Optyname+' has a Sales Team Request pending. Please view all your Notifications to Approve or Reject.';
        post.Title = 'Notification';
        post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+ '/apex/SalesTeamNotificationPage';
        insert post;
        //system.debug('!@After Insert'+ SalesTeam.id);
        ApexPages.Message msg;
        
        /* Code for showing message to close the window after inserting the record */
        
        if(SalesTeam.id != null)
        {
        //system.debug('!@Inserted');
        msg=new ApexPages.Message(ApexPages.Severity.CONFIRM,'Request for Sales Team has been submitted. You may now close the window.');
        ApexPages.addMessage(msg);
        }
         return null;
       }
    
}