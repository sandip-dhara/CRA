/************************************
Author: Abrar
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Desc : Code for attaching documents
         in to Approval record.
************************************/

public with sharing class AttachmentController {
    public List<Attachment> allFileList {get; set;} 
    public Id ApprovalID;
    Public String ApprovalPage;
    Public AttachmentExtension__c  oAE;
    Public List<AttachmentExtension__c>  listAE;
    Public String context;
    public AttachmentController (){
        ApprovalID = ApexPages.CurrentPage().getParameters().get('Approvalid');
        ApprovalPage = ApexPages.CurrentPage().getParameters().get('Page');
        context=ApexPages.currentPage().getParameters().get('context');
        system.debug('PageNAme##'+ApprovalPage);
        allFileList =new List<Attachment>();
         for(Integer i = 1 ; i <=5; i++)  
            allFileList.add(new Attachment()); 
    }
    
   /* Upload Attachment and navigate back to Approval Detail Page or Workspace detail page*/
   
    public PageReference SaveAttachments() {
          List<Attachment> listToInsert = new List<Attachment>() ;
          Approval__c app =new Approval__c();
          Reviewer_Workspace__c  rw=new Reviewer_Workspace__c ();
          if(context=='Approval')
             app=[select id,name from Approval__c where id= :ApprovalID];
           else if(context=='Workspace')
               rw=[select id,name from Reviewer_Workspace__c where id= :ApprovalID];
        //Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);  
        Map<String,String> existingAttachmentNameMap=new Map<String,String>();
        for(Attachment at: [select id,name from Attachment where parentID= : ApprovalID]){
            existingAttachmentNameMap.put(at.name.toLowerCase(),at.name.toLowerCase());
        }
        system.debug(' ** existingAttachmentNameMap '+ existingAttachmentNameMap);
        for(Attachment a: allFileList)  
        {  
            //system.debug('********* file name '+a.name.toLowerCase() );
            if(a.name !=null){
                if(existingAttachmentNameMap.containsKey(a.name.toLowerCase())){
                    ApexPages.message msg=new ApexPages.message(Apexpages.Severity.ERROR,'A file already exist with same name. Please upload the file with different name');
                    ApexPAges.addMessage(msg);
                    return null;
                }
            }
            if(a.name != '' && a.name != '' && a.body != null)  {
                if(context=='Approval')
                listToInsert.add(new Attachment(parentId = app.id, description=a.description,name = a.name, body = a.body)) ; 
                if(context=='Workspace')
                listToInsert.add(new Attachment(parentId = rw.id, description=a.description,name = a.name, body = a.body)) ;  
            }
        }  
          
        //Inserting attachments  
        if(listToInsert.size() > 0)  
        {  
            insert listToInsert ;
            
            List<AttachmentExtension__c> listAE  = new list<AttachmentExtension__c>(); 
            for (Attachment a1:listToInsert)
            {
            AttachmentExtension__c oAE = new AttachmentExtension__c();
            oAE.version_number__c = 1;
            oAE.AttachmentReference__c = a1.id;
            listAE.add(oAE);
            
            }
            
            insert listAE;
             
         }
        PageReference NavigatetoApprovalPage;
        if(context=='Approval')
        NavigatetoApprovalPage= new PageReference('/apex/'+ApprovalPage+'?id='+ApprovalID);
        if(context=='Workspace')
        NavigatetoApprovalPage= new PageReference('/apex/DGWorkSpaceDetailPage?id='+ApprovalID);
        NavigatetoApprovalPage.setRedirect(false); 
        return NavigatetoApprovalPage;
    }
    
    /* on cancel navigate back to Approval Detail Page or Workspace detail page*/
    public PageReference Cancel(){
                PageReference NavigateBacktoApprovalPage= new PageReference('/apex/'+ApprovalPage+'?id='+ApprovalID);
                NavigateBacktoApprovalPage.setRedirect(false); 
                return NavigateBacktoApprovalPage;
    }

}