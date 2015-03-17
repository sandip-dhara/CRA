/*
* NAME : AptsViewAttachmentIds
* NOTE : class will used when user clicks on "View Attachment IDs" button,
*		 logic will show all Attachments of Current Agreement.
* Author : Apttus
*/
public with sharing class AptsViewAttachmentIds{
    
    public List<Attachment> lstAttachment{get;set;}
    public String agreementId{get;set;}
    
    public AptsViewAttachmentIds(){
        agreementId = Apexpages.currentPage().getParameters().get('id');
        lstAttachment = [SELECT Id,LastModifiedDate,Name,ParentId 
                        FROM Attachment
                        Where ParentId =: agreementId];        
    }
    
}