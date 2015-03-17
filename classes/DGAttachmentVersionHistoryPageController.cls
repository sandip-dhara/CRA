/*
Author: Praveen Kumar Reddy N
Relese : R6
Date: 11/July/2013
For displaying the mulitiple verions of the attachment at approval level and worksapce level
*/
public with sharing class DGAttachmentVersionHistoryPageController {

    String filename;
    ID ApprovalWorkspaceID;
    public List<Attachment> AttachList;
    public List<AttachmentExtension__c> attachmentExtensionList;
    public String ApprovalPage;
    public DGAttachmentVersionHistoryPageController (){
        filename=ApexPages.currentPage().getParameters().get('filename');
        ApprovalWorkspaceID=ApexPages.currentPage().getParameters().get('ApprovalWorkspaceID');
        ApprovalPage=ApexPages.CurrentPage().getParameters().get('Page');
    }
    /* logic to get the all versin of the attachment  */
    public List<AttachmentWrapper> getAttachments(){
    
        List<ID> attachmentIDList=new List<ID>();
        Map<ID,Attachment> attchmentMap=new Map<ID,Attachment>();
        List<AttachmentWrapper> attWrapper=new List<AttachmentWrapper>();
        filename=filename.substringBefore('.');
        String SOQL='Select Description, Id, Name,isPrivate, CreatedDate, CreatedById, lastmodifiedDate, lastmodifiedbyid from Attachment  ';
        String wherecondition=' where name Like \''+filename+'%\'  and parentid=\''+ApprovalWorkspaceID+'\' ';
        SOQL=SOQL+wherecondition;
        AttachList = database.query(SOQL);
        for(Attachment att : AttachList ){
            attachmentIDList.add(att.id);
            attchmentMap.put(att.id,att);
        }
        for(AttachmentExtension__c  ate: [select id,version_number__c,Comments__c,AttachmentReference__c from AttachmentExtension__c where AttachmentReference__c in :attachmentIDList order by version_number__c DESC]){
            attWrapper.add(new AttachmentWrapper(ate.version_number__c,ate.Comments__c,attchmentMap.get(ate.AttachmentReference__c)));
        }
        return attWrapper;
    }
    /* just for navigating to main page if it is open from Approval it navigates to approval record or if it is open from workspace it navigates to workspace record */
    public PageReference gotoPreviousPage() {
        PageReference NavigatetoApprovalPage= new PageReference('/apex/'+ApprovalPage+'?id='+ApprovalWorkspaceID);
        NavigatetoApprovalPage.setRedirect(false); 
        return NavigatetoApprovalPage;
    }
    
    private class AttachmentWrapper{
        public Decimal versionNumber{set;get;}
        public Attachment at{set;get;}
        public String Comments{set;get;}
        public AttachmentWrapper(Decimal VersionNumber,String comment,Attachment att){
            at=att;
            this.comments=comment;
            this.versionNumber=VersionNumber;
        }
    }
}