/*
Author: Praveen Kumar Reddy N
Relese : R6
Date: 11/July/2013

*/
public with sharing class DGWorkSpaceDetailPageController {
    
    public List<AttachWrapper> AttachList;
    public Id attId{set; get;}
    public boolean block{set; get;}
    public String filename{set;get;}
    public String id;
    public String loggedInUserName{set;get;}    
    public string sNoteId{get;set;}

    public DGWorkSpaceDetailPageController(ApexPages.StandardController controller) {
        this.id = ApexPages.currentPage().getParameters().get('id');
        loggedInUserName=userinfo.getName();
    }
    /* code for displaying the list of Attachments */
   /* code for displaying the list of Attachments */
    public List<AttachWrapper> getAttachments(){
        AttachList=new List<AttachWrapper>();
        List<ID> attachmentIDList=new List<ID>();
        Map<ID,Attachment> attMap=new Map<ID,Attachment>();
        List<Attachment> sotedAttachmentList=new List<Attachment>();
        for(Attachment att: [Select Description,parentID, Id, Name,isPrivate, CreatedDate, CreatedById, lastmodifiedDate, lastmodifiedbyid from Attachment where ParentId = :Id ORDER BY LastModifiedDate DESC]){
            attachmentIDList.add(att.ID);
            attMap.put(att.id,att);
            sotedAttachmentList.add(att);
        }
        Map<String,List<Decimal>> attNameVersionMap=new Map<String,List<Decimal>>();
        Map<String,Attachment> nameIDAttMap=new Map<String,Attachment>();
        Map<String,AttachmentExtension__c> attExtMap=new Map<String,AttachmentExtension__c>();
        for(AttachmentExtension__c  ate: [select id,version_number__c,AttachmentReference__c,isChecked__c,CheckedOutBy__c from AttachmentExtension__c where AttachmentReference__c in :attachmentIDList]){
            attExtMap.put(ate.AttachmentReference__c,ate);
           nameIDAttMap.put(ate.version_number__c+ate.AttachmentReference__c ,attMap.get(ate.AttachmentReference__c));//attMap.get(ate.AttachmentReference__c).name
           if(attNameVersionMap.containsKey(attMap.get(ate.AttachmentReference__c).name)){//ate.AttachmentReference__c +
               List<Decimal> versionList=new List<Decimal>();
               versionList=attNameVersionMap.get(attMap.get(ate.AttachmentReference__c).name);
               versionList.add(ate.version_number__c);
               attNameVersionMap.put(attMap.get(ate.AttachmentReference__c).name,versionList);
           }
           else{
               List<Decimal> versionList=new List<Decimal>();
               versionList.add(ate.version_number__c);
               attNameVersionMap.put(attMap.get(ate.AttachmentReference__c).name,versionList);
           }
        }
        for(String fName : attNameVersionMap.keyset()){
            List<Decimal> versionlist=new List<Decimal>();
            versionlist=attNameVersionMap.get(fName);
            versionlist.sort();
            List<Decimal> newVersionList=new List<Decimal>();
            newVersionList.add(versionlist.get(versionlist.size()-1));
            attNameVersionMap.put(fname,newVersionList);
        }
        
        for(Attachment attach: sotedAttachmentList){
            if(attNameVersionMap.containsKey(attach.name)){                
               if(nameIDAttMap.containsKey(attNameVersionMap.get(attach.name)[0]+string.valueOf(attach.id))){                    
                    Attachment originalAtt=nameIDAttMap.get(attNameVersionMap.get(attach.name)[0]+string.valueOf(attach.id));
                    AttachList.add(new AttachWrapper(originalAtt,attExtMap.get(attach.id).isChecked__c,attExtMap.get(attach.id).CheckedOutBy__c,attExtMap.get(attach.id).version_number__c));
                }
            }
               
        }
        return AttachList;
    }


    /* code for delaying the Attachments */
    public pagereference DeleteAttachment()
    {
        //system.debug('##AttachId'+attId);
        if(attId == null){
            return null;
        }
        Attachment attach=new Attachment();
        attach.id=attID;
        
        if(Attach!= null){
            delete Attach;
        }
        AttachmentExtension__c attExt=[select id,isChecked__c,CheckedOutBy__c from AttachmentExtension__c where AttachmentReference__c = :attID];
        if(attExt!=null)
        delete attExt;
        return null;
    }
    
    /* POC for R6 */
    public pagereference LockAttachment()
    {
        if(attId == null){
            return null;
        }
        
        AttachmentExtension__c  attachCheck=[select id,isChecked__c,CheckedOutBy__c from AttachmentExtension__c where AttachmentReference__c = :attID];
        system.debug('last modified  '+attachCheck.CheckedOutBy__c + '  '+userinfo.getUserID() +' private ' +attachCheck.isChecked__c);
        if(attachCheck.CheckedOutBy__c!=userinfo.getName() && attachCheck.isChecked__c==true ){
             //&& userinfo.getprofileID()!=[select id from profile where name='IT Administrator'].id
            system.debug('*** checked out');
            ApexPages.message msg=new ApexPages.message(ApexPages.Severity.ERROR,'This file has been checked out by another user' );
            ApexPages.addMessage(msg);
            return null;
        }
        if(block == true)
        {
         attachCheck.isChecked__c= true;
        }
        else
        {
         attachCheck.isChecked__c = false;
        }
        attachCheck.AttachmentReference__c  = attID;
        attachCheck.CheckedOutBy__c =userInfo.getName();
        Update attachCheck;
        
        return null;
    }
    
    
      public PageReference customAttachmentEdit(){

        PageReference pr = new PageReference('/apex/AttachmentEdit?Attachmentid='+attId+'&Approvalid='+id+'&filename='+filename+'&Page=DGWorkSpaceDetailPage');
        pr.setRedirect(true);
        return pr;

    }
    
    public Class AttachWrapper{
        public Boolean isChecked{set;get;}
        public String checkedOutBy{set;get;}
        public Decimal versionNumber{set;get;}
        public Attachment at{set;get;}
        public AttachWrapper(Attachment att,Boolean checked,String checkedout,Decimal version){
            this.at=att;
            this.isChecked=checked;
            this.checkedOutBy=checkedout;
            this.versionNumber=version;
            
        
        }
        
    }
    

    public list<Note> getWSNotes(){    
    List<Note> listWSNote = New List<Note>([SELECT IsPrivate,LastModifiedById,LastModifiedDate,Title FROM Note where parentid =:id]);
    return listWSNote;
    }

    public pagereference DeleteWS(){
    Note oNote = new Note();
        oNote.Id = sNoteId;
        delete oNote;
        return null;   
    }
    
   
}