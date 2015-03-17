/**
* Class Name: CPQAttachementFormController
* Author: HP - Mohit
* Date: 07-Nov-2012 
* Description: Contains CPQ ESSN/PPS custom attachment functionality 
*/
public class CPQAttachementFormController {
    public Attachment objAttachement{get;set;}
    public List<Attachment> showAllAttachment{
        get { return getshowAllAttachmentget(); }
    } 
    public Support_Request__c objSupportRequest;
    public String returnURL{get;set;}
    
    public CPQAttachementFormController(ApexPages.StandardController controller) {
        objAttachement = new Attachment();
        this.objSupportRequest = (Support_Request__c )controller.getRecord();
        returnURL = Apexpages.currentPage().getParameters().get('retUrl');
    }
    public List<Attachment> getshowAllAttachmentget(){
        
        List<Attachment> listAttachments = [select id,Name,LastModifiedDate,CreatedBy.Name,Body,ContentType from Attachment where ParentId =:objSupportRequest.Id ];
        return listAttachments;
    }
    
    public PageReference saveAttachment() {
        objAttachement.parentId = objSupportRequest.Id;
        //insert objAttachement;
        Database.SaveResult objSaveResult = Database.insert(objAttachement,false);
        // Iterate through the Save Results 
        if(!objSaveResult.isSuccess()){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select any file'));
            return null;
        }
        objAttachement = new Attachment();
        return null;
    }
    
    public PageReference DoneAttachment() {
        PageReference Page=new PageReference(returnURL);
        page.setRedirect(true);
        return page;
    }
    
    public void deleteAcctachment() {
        Id attachmentId = Apexpages.currentPage().getParameters().get('DelId');
        for(Attachment obj : showAllAttachment){
            if(obj.Id == attachmentId){
                Database.DeleteResult deleteAttachment = Database.delete(obj,false);
            }
        }
        
        //return null;
    }
    

}