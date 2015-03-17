/****************************************
Author: Venkatesh S
Created Date: 22-MAY-2013
Release: R5
Capability: Deal Governance
Description: Validation rules to restrict creation of Workspace when the user is not coordinator and approval status approved.
****************************************/

trigger WorkspaceBeforeUpsert on Reviewer_Workspace__c (Before Insert,Before Update) {

Public user oCurrentUser;
oCurrentUser = [select Approver_Type__c from user where id =:UserInfo.getUserId()];
Public Set<id> ApprovalId = New Set<id>();
Public Map<id,Approval__c> WorkspaceMap = New Map<id,Approval__c>();

for(Reviewer_Workspace__c Workspace: Trigger.New)
    {
    ApprovalId.add(Workspace.approval__c);
    }
for(approval__c app: [select id,status__c from approval__c where id in :ApprovalId])
    {
    WorkspaceMap.put(app.id,app);
    }
for(Reviewer_Workspace__c Workspace: Trigger.New)
    {    
    If(oCurrentUser.Approver_Type__c != 'Coordinator')
        {
        Workspace.addError('You do not have access to Create/Update Workspace');
        }        
    If(WorkspaceMap.get(Workspace.Approval__c).Status__c == 'Approved')
        {
        Workspace.addError('Approval Request is already Approved');    
        }
    
    }
}