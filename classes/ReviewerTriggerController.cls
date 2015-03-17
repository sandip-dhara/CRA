/****************************************
Author: Mousumi Panda
Created Date: 26-July-2013
Release: R6
Capability: Deal Governance
Description: Validation rules to restrict an user form creating,editing and deleting Reviewers when he is not a coordinator, 
approval status approved and work space is closed.
****************************************/

public class ReviewerTriggerController{

 public static void lockCreateReviewer(list<Reviewer__c > newreviewerList ){
        User oCurrentUser;
        oCurrentUser = [select Approver_Type__c from user where id =:UserInfo.getUserId()];
         Set<Id> workspaceIds = new Set<Id>(); 
         for (Reviewer__c revnew : newreviewerList ) {
         if(revnew.Reviewer_Workspace__c != null){
         workspaceIds.add(revnew.Reviewer_Workspace__c);
        }
        }
    
    Map<ID, Reviewer_Workspace__c> workspaceentries = new Map<ID, Reviewer_Workspace__c>([SELECT Id, Approval_Level__c,status__c FROM Reviewer_Workspace__c WHERE id in :workspaceIds]);
    
    for (Reviewer__c revws : newreviewerList) {
        Reviewer_Workspace__c workspc = workspaceentries.get(revws.Reviewer_Workspace__c);
        
        If(oCurrentUser.Approver_Type__c != 'Coordinator')
          {
          revws.addError('You do not have access to Create/Update Reviewer');
          }    
        
        if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c != 'Coordinator') {
          revws.addError('Cannot create Reviewer as Workspace is closed. Please contact coordinator to provide your updates.');
          }
          if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c == 'Coordinator') {
          revws.addError('Cannot create Reviewer as Workspace is closed.');
          }
           
    }
}   
        
 public static void lockEditReviewer(list<Reviewer__c > editReviewerList ){
 
  User oCurrentUser;
     oCurrentUser = [select Approver_Type__c from user where id =:UserInfo.getUserId()];
       
       Set<Id> workspaceIds = new Set<Id>();
  for (Reviewer__c revedit : editReviewerList ) {
         if(revedit.Reviewer_Workspace__c != null){
         workspaceIds.add(revedit.Reviewer_Workspace__c);
        }
        }
       Map<ID, Reviewer_Workspace__c> workspaceentries = new Map<ID, Reviewer_Workspace__c>([SELECT Id, Approval_Level__c,status__c FROM Reviewer_Workspace__c WHERE id in :workspaceIds]);
      
    for (Reviewer__c revws : editReviewerList) {
        Reviewer_Workspace__c workspc = workspaceentries.get(revws.Reviewer_Workspace__c);
        
        if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c != 'Coordinator') {
          revws.addError('Cannot modify any Reviewer, as WorkSpace is closed,Please contact coordinator to provide your updates.');
        }
        if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c == 'Coordinator') {
          revws.addError('Cannot modify any Reviewer, as WorkSpace is closed.');
        }
    }

     
  
 }
        
 public static void lockDeleteReviewer(list<Reviewer__c > delReviewerList ){
    User oCurrentUser;
    oCurrentUser = [select Approver_Type__c from user where id =:UserInfo.getUserId()];
    Set<Id> workspaceIds = new Set<Id>();  
     for (Reviewer__c revdel : delReviewerList ) {
         if(revdel.Reviewer_Workspace__c != null){
         workspaceIds.add(revdel.Reviewer_Workspace__c);
        }
        }
 Map<ID, Reviewer_Workspace__c> workspaceentries = new Map<ID, Reviewer_Workspace__c>([SELECT Id, Approval_Level__c,status__c FROM Reviewer_Workspace__c WHERE id in :workspaceIds]);
      
    for (Reviewer__c revws : delReviewerList) {
        Reviewer_Workspace__c workspc = workspaceentries.get(revws.Reviewer_Workspace__c);
        
        If(oCurrentUser.Approver_Type__c != 'Coordinator')
        {
        revws.addError('You do not have access to Delete any Reviewer');
        }   
        if(workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c != 'Coordinator') {
          revws.addError('Cannot delete any Reviewer as Workspace is closed,Please contact coordinator to provide your updates.');
        }
        if(workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c == 'Coordinator') {
          revws.addError('Cannot delete any Reviewer as Workspace is closed.');
        }
       
    }       
                    

}

}