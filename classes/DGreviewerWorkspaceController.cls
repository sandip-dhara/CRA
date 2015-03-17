public with sharing class DGreviewerWorkspaceController {
    public Reviewer_Workspace__c reviewerWorkspace{set;get;}
    public ID approvalID;
    Public ID workspaceID;
    public DGreviewerWorkspaceController(ApexPages.StandardController controller) {
        reviewerWorkspace=new Reviewer_Workspace__c ();
        workspaceID=ApexPages.currentPage().getParameters().get('id');
        if(WorkspaceID!=null){
            
            Reviewer_Workspace__c  rw=[select id,Approval_Level__c,Status__c,approval__r.id from Reviewer_Workspace__c  where id = :WorkspaceID];
            reviewerWorkspace.Approval_Level__c=rw.Approval_Level__c;
            reviewerWorkspace.Status__c =rw.Status__c ;
            reviewerWorkspace.approval__c=rw.approval__r.id;
        }
    }
    public pageReference Save(){
        try{
        approvalID=ApexPages.currentPage().getParameters().get(Label.ApprovalID);
        
        system.debug('#####   '+approvalID);
        
        if(workspaceID!=null){
            reviewerWorkspace.id=workspaceID;
            update reviewerWorkspace;
            //reviewerWorkspace
             return new PageReference('/Apex/DGWorkSpaceDetailPage?id='+workspaceID);
        }else{
            reviewerWorkspace.Approval__c=approvalID;
            Database.SaveResult res=Database.insert(reviewerWorkspace,false);
            system.debug('&&&&&  '+res.isSuccess());
            if(res.isSuccess())
            return new PageReference('/Apex/DGWorkSpaceDetailPage?id='+res.getID());
            else
            return null;
        }
        }
        catch(Exception e){
        return null;
        }
    }

}