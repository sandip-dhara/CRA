public with sharing class CCW_UploadFileController {    
    public Attachment tAttachment{get;set;}     
    public CCW_UploadFileController(){ 
        this.tAttachment = new Attachment();
    }
    public void doUploadFile(){ 
        Attachment a = this.tAttachment.clone(false, true, false, false);
        a.OwnerId = UserInfo.getUserId();
        a.ParentId = 'a6tZ00000008SCh'; 
        this.tAttachment.Body = null; 
        Database.Insert(a); 
    } 
}