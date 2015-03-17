/************************************
Name : NotificationtoSalesTeamController 
Author: Abrar
Date: 29/07/2013
Desc : Controller for showing the request
submitted for the oppties owned by logged in user.
*************************************/

public class NotificationtoSalesTeamController {

    public NotificationtoSalesTeamController(ApexPages.StandardSetController controller) {

    }

    
    public Id LoggedinUserId;
    public Id STRecordId{get; set;}
    public List<Add_to_Sales_Team__c> listSalesTeam;
    public List<Add_to_Sales_Team__c> listSalesTeamtoinsert = new List<Add_to_Sales_Team__c>();
    public list<OpportunityShare> listopptyShareOwToInsert=new list<OpportunityShare>();
    public Add_to_Sales_Team__c ST = new Add_to_Sales_Team__c();
   
       
    public NotificationtoSalesTeamController(ApexPages.StandardController controller) {
        
        }
    
    //Getter setter method to show Request owned by logged in User
    
    public List<Add_to_Sales_Team__c> getListSalesTeam(){
        LoggedinUserId = UserInfo.getUserId();
        listSalesTeam = [select Id,Opportunity__c,Opportunity__r.Name,Opportunity_Owner__c,Account__c, Status__c,RequestedUser__c,Requested_user_Id__c ,Opportunity_Team_role__c,Permission__c,Comments__c from Add_to_Sales_Team__c where Opportunity__r.OwnerId = :LoggedinUserId and status__c = 'Pending'];  
        system.debug('@@@@'+listSalesTeam);
        return listSalesTeam;
        }
      
      /*
      Code for Accepting the request, 
      Insert the opty Sales Team and 
      send email notification to requestor.
      */
      
      public PageReference SaveAccept() {
        String oAccess;
        for(Add_to_Sales_Team__c STobj :listSalesTeam){
        if(STobj.Id == STRecordId){
        ST = STobj;
        system.debug('@@@@ST'+ST);
        }
        }
        
        ST.Status__c = 'Accepted';
        //system.debug('after update'+ST.Comments__c);
        update ST;// updating Sales Team request record with status as Accepted
        
        if(ST.Permission__c == 'Read Only')
        oAccess = 'Read';
        else
        oAccess = 'Edit';
        
        //code for inserting OpportunityTeammember record
        OpportunityTeamMember OTeamMember = new OpportunityTeamMember();
        OTeamMember.OpportunityId = ST.Opportunity__c;
        OTeamMember.TeamMemberRole = ST.Opportunity_Team_role__c;
        OTeamMember.UserId = ST.Requested_user_Id__c;
        insert OTeamMember;//insert statement for inserting Teammember record
        
        //code for inserting OpportunityTeammember record
        OpportunityShare opptyShareOw=new OpportunityShare();
        opptyShareOw.OpportunityId =ST.Opportunity__c;
        opptyShareOw.OpportunityAccessLevel = oAccess;
        opptyShareOw.UserOrGroupId = ST.Requested_user_Id__c;
        insert opptyShareOw;//insert statement for inserting OpportunityShare for the inserted TeamMember
        
        /* code for sending the email notification
         to the requestor when the request is accepted.
         */
        EmailTemplate et =  [select id from EmailTemplate where developername='Opportunity_Access_Request_Status'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(ST.Requested_user_Id__c);
        mail.settemplateid(et.Id);
        mail.setwhatId(ST.Id);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return new PageReference('/apex/SalesTeamNotificationPage');        
        }//End of SaveAccept
      
       /*
      Code for Accepting the request, 
      Insert the opty Sales Team and 
      send email notification to requestor.
      */  
      public PageReference SaveReject() {
        for(Add_to_Sales_Team__c STob :listSalesTeam){
        if(STob.Id == STRecordId)
        ST = STob;
        }
        ST.Status__c = 'Rejected';
        update ST;// updating Sales Team request record with status as Rejected
        
        /* code for sending the email notification
         to the requestor when the request is accepted.
         */
        EmailTemplate et2 =  [select id from EmailTemplate where developername='Opportunity_Access_Request_Status'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(ST.Requested_user_Id__c);
        mail.settemplateid(et2.Id);
        mail.setwhatId(ST.Id);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return new PageReference('/apex/SalesTeamNotificationPage');     
        }//End of SaveReject  
        
     public integer getPendingRequestCount()
        {
        List<Add_to_Sales_Team__c> SalesTeamRequest = new List<Add_to_Sales_Team__c>();
        SalesTeamRequest = [select Id from Add_to_Sales_Team__c where Opportunity__r.OwnerId = :UserInfo.getUserId() and status__c = 'Pending'];
        return SalesTeamRequest.Size();
        }


     
               

}