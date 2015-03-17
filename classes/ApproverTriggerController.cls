/****************************************
Author: Mousumi Panda
Created Date: 26-July-2013
Release: R6
Capability: Deal Governance
Description: Validation rules to restrict an user form creating,editing and deleting approvers when he is not a coordinator, 
approval status approved and work space is closed.
****************************************/
public class ApproverTriggerController{

 public static void lockCreateApprover(list<WS_Approver__c > newapproverList ){
         User oCurrentUser;
         oCurrentUser = [select Approver_Type__c from user where id =:UserInfo.getUserId()];
         Set<Id> workspaceIds = new Set<Id>(); 
         for (WS_Approver__c app : newapproverList ) {
         if(app.Reviewer_Workspace__c != null){
         workspaceIds.add(app.Reviewer_Workspace__c);
        }
        }
    
    Map<ID, Reviewer_Workspace__c> workspaceentries = new Map<ID, Reviewer_Workspace__c>([SELECT Id, Approval_Level__c,status__c FROM Reviewer_Workspace__c WHERE id in :workspaceIds]);
    
    for (WS_Approver__c appws : newapproverList) {
        Reviewer_Workspace__c workspc = workspaceentries.get(appws.Reviewer_Workspace__c);
         If(oCurrentUser.Approver_Type__c != 'Coordinator')
        {
        appws.addError('You do not have access to Create/Update Approver.');
        }    
         if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c == 'Coordinator') {
          appws.addError('Cannot create Approver as Workspace is closed.');
        }
        if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c != 'Coordinator') {
          appws.addError('Cannot create Approver as Workspace is closed. Please contact coordinator to provide your updates.');
        }
           

    }
}   
        
 public static void lockEditApprover(list<WS_Approver__c > editapproverList ){
      User oCurrentUser;
      oCurrentUser = [select Approver_Type__c from user where id =:UserInfo.getUserId()];
       Set<Id> workspaceIds = new Set<Id>();
     for (WS_Approver__c appedit : editapproverList ) {
         if(appedit.Reviewer_Workspace__c != null){
         workspaceIds.add(appedit.Reviewer_Workspace__c);
        }
        }
       Map<ID, Reviewer_Workspace__c> workspaceentries = new Map<ID, Reviewer_Workspace__c>([SELECT Id, Approval_Level__c,status__c FROM Reviewer_Workspace__c WHERE id in :workspaceIds]);
      
    for (WS_Approver__c appws : editapproverList) {
        Reviewer_Workspace__c workspc = workspaceentries.get(appws.Reviewer_Workspace__c);
        
        if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c != 'Coordinator') {
          appws.addError('Cannot modify any Approver as Workspace is closed, Please contact coordinator to provide your updates.');
        }
        if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c == 'Coordinator') {
          appws.addError('Cannot modify any Approver as Workspace is closed.');
        }
    }

     
  
 }
        
 public static void lockDeleteApprover(list<WS_Approver__c > delapproverList ){
    User oCurrentUser;
    oCurrentUser = [select Approver_Type__c from user where id =:UserInfo.getUserId()];
    Set<Id> workspaceIds = new Set<Id>();  
     for (WS_Approver__c appdel : delapproverList ) {
         if(appdel.Reviewer_Workspace__c != null){
         workspaceIds.add(appdel.Reviewer_Workspace__c);
        }
        }
 Map<ID, Reviewer_Workspace__c> workspaceentries = new Map<ID, Reviewer_Workspace__c>([SELECT Id, Approval_Level__c,status__c FROM Reviewer_Workspace__c WHERE id in :workspaceIds]);
      
    for (WS_Approver__c appws : delapproverList) {
        Reviewer_Workspace__c workspc = workspaceentries.get(appws.Reviewer_Workspace__c);
        If(oCurrentUser.Approver_Type__c != 'Coordinator')
        {
        appws.addError('You do not have access to Delete any Approver');
        }   
        if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c != 'Coordinator') {
          appws.addError('Cannot delete any Approver as Workspace is closed, Please contact coordinator to provide your updates.');
        }
        if (workspc.Status__c == 'Closed' && oCurrentUser.Approver_Type__c == 'Coordinator') {
          appws.addError('Cannot delete any Approver as WorkSpace is closed.');
        }
          
    }       
                    

}

}