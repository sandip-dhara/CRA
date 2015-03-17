/************************************
Author: Abrar
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Desc : Code for attaching documents
         in to Approval record.
************************************/

public with sharing class UpdateAttachmentController {
    public List<Attachment> allFileList {get; set;} 
    public Id ApprovalID;
    Public String ApprovalPage;
    Public String AttachmentId;
    Public Attachment AttachmentRec = new Attachment();
    Public AttachmentExtension__c AttachmentExtensionRec = new AttachmentExtension__c();
    Public AttachmentWrapper AttWrapper{get; set;}
    Public String filename;
    public List<Attachment> AttachList;
    List<ID> attachmentIDList=new List<ID>();
    public List<Decimal> versionList=new List<Decimal>();
    public String context;
    public String filename1{set;get;}
    public AttachmentExtension__c attToupdate;
    public UpdateAttachmentController (){
        ApprovalID = ApexPages.CurrentPage().getParameters().get('Approvalid');
        ApprovalPage = ApexPages.CurrentPage().getParameters().get('Page');
        AttachmentId = ApexPages.CurrentPage().getParameters().get('AttachmentId');
        //context=ApexPages.currentPage().getParameters().get('context');
        filename=ApexPages.currentPage().getParameters().get('filename');
        filename1=filename;
        system.debug('PageNAme##'+ApprovalPage);
        //AttachmentRec = [Select parentid,Description, Id, Name, body, CreatedDate, CreatedById from Attachment where id = :AttachmentId];
        //AttachmentExtensionRec = [Select id,Version_Number__c,Comments__c from AttachmentExtension__c where AttachmentReference__c = :AttachmentId];
        AttachmentRec.body = null;
         
        filename=filename.substringBefore('.');
        /*String SOQL='Select Description, Id, Name,isPrivate, CreatedDate, CreatedById, lastmodifiedDate, lastmodifiedbyid from Attachment  ';
        String wherecondition=' where name Like \''+filename+'%\' and parentID=\''+ApprovalID+'\'';
        SOQL=SOQL+wherecondition;
        AttachList = database.query(SOQL);
        for(Attachment att : AttachList ){
            attachmentIDList.add(att.id);
            
        }*/
        Attachment attDesc=[select id,description from Attachment where id =:AttachmentId ];
        attToupdate=[select id,version_number__c,AttachmentReference__c from AttachmentExtension__c where AttachmentReference__c = :AttachmentId ];
           
       
       AttachmentExtensionRec.version_number__c=attToupdate.version_number__c+1;
       AttachmentRec.description=attDesc.description;
        AttWrapper = new AttachmentWrapper(AttachmentRec,AttachmentExtensionRec);
    }
    
   /* Updating the Attachment and navigate back to Approval Detail Page or workspace detail page*/
   
    public PageReference UpdateAttachment() {
            
            if(AttWrapper.AttachmentRecordUI != null && AttWrapper.AttachmentExtensionRecordUI != null)  
            {  
                Attachment att=new Attachment();
                if(AttWrapper.AttachmentRecordUI.Name==null || AttWrapper.AttachmentRecordUI.Name==''){
                    att.description=AttWrapper.AttachmentRecordUI.description;
                    att.parentID=ApprovalID ;
                    att.id=AttachmentId ;
                    update att;
                    attToupdate.comments__c=AttWrapper.AttachmentExtensionRecordUI.comments__c;
                    update attToupdate;
                }else{
                    
                    //att.id=AttachmentRec.id;
                    att.description=AttWrapper.AttachmentRecordUI.description;
                    att.body=AttWrapper.AttachmentRecordUI.body;
                    att.Name=AttWrapper.AttachmentRecordUI.Name;
                    att.parentID=ApprovalID ;
                    system.debug('current file '+AttWrapper.AttachmentRecordUI.Name);
                    system.debug('current file '+filename);
                    if(!String.valueOf(AttWrapper.AttachmentRecordUI.Name.trim()).equals(filename1.trim())){
                        ApexPages.message msg=new ApexPages.message(ApexPages.Severity.ERROR,'You are editing an attachment. Please upload the updated file with same name.');
                        ApexPages.addMessage(msg);
                        return null;
                    }
                    try{
                        insert att;
                        AttachmentExtension__c attext=new AttachmentExtension__c();
                        //attext.Id=AttachmentExtensionRec.id;
                        attext.AttachmentReference__c =att.id;
                        attext.version_number__c = AttWrapper.AttachmentExtensionRecordUI.version_number__c;
                        attext.comments__c = AttWrapper.AttachmentExtensionRecordUI.comments__c;
                        insert attext;
                    }catch(Exception e){
                        ApexPages.message msg=new ApexPages.message(ApexPages.severity.ERROR,e.getMessage());
                        ApexPages.addMessage(msg);
                        return null;
                    }
                    
                }
                
                
                    try{
                        
                        /*attToupdate=[select id,version_number__c,AttachmentReference__c from AttachmentExtension__c where AttachmentReference__c = :AttachmentId ];*/
                        attToupdate.isChecked__c=false;
                        attToupdate.CheckedOutBy__c=null;
                        update attToupdate;
                    }catch(Exception e){
                        ApexPages.message msg=new ApexPages.message(ApexPages.Severity.Error,e.getMessage());
                        ApexPages.addMessage(msg);
                        return null;
                    }
            
            
            }
        
          
        PageReference NavigatetoApprovalPage= new PageReference('/apex/'+ApprovalPage+'?id='+ApprovalID);
        NavigatetoApprovalPage.setRedirect(false); 
        return NavigatetoApprovalPage;
    }
    
    
    
    /* on cancel navigate back to Approval Detail Page or workspace detail page*/
    public PageReference Cancel(){
                PageReference NavigateBacktoApprovalPage= new PageReference('/apex/'+ApprovalPage+'?id='+ApprovalID);
                NavigateBacktoApprovalPage.setRedirect(false); 
                return NavigateBacktoApprovalPage;
    }
    
    /*
    Public AttachmentWrapper getAttachmentDetail(){
    AttachmentRec = [Select parentid,Description, Id, Name, body, CreatedDate, CreatedById from Attachment where id = :AttachmentId];
    AttachmentExtensionRec = [Select Version_Number__c,Comments__c from Attachment where AttachmentReference = :AttachmentId];
    }*/

    public class AttachmentWrapper{
    Public Attachment AttachmentRecordUI{get; set;}
    Public AttachmentExtension__c AttachmentExtensionRecordUI{get; set;}   
    
        public AttachmentWrapper(Attachment AttachmentRecordUI, AttachmentExtension__c AttachmentExtensionRecordUI)
        {
        this.AttachmentRecordUI = AttachmentRecordUI;
        this.AttachmentExtensionRecordUI = AttachmentExtensionRecordUI;
        }
    
    }

}