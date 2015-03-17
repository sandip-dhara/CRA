public with sharing class PavithraDeliverableExtension {
    public List<Stage_work_Element__c> workElementList {get;set;} 
    public List<Attachment> attachmentList{get;set;}
    public string SelectedWorkElementId { get; set; }
    public string SelectedAttachmentId { get; set; }
    Public String getURL{get;set;}
    public PavithraDeliverableExtension(ApexPages.StandardController controller) {
        getURL = ApexPages.currentPage().getParameters().get('Id'); 
        loadStageWorkElementsData();

    }
    
    private void loadStageWorkElementsData() {
    System.debug('Get URL :'+getURL);
        workElementList = [Select Id,Name,Stage_Name__c,Name__c,Status__c,Include__c,Release_Deliverable_ID__c from Stage_Work_Element__c where Release_Deliverable_ID__c= :getURL];
        attachmentList = [SELECT Body,ContentType,Name,ParentId,ownerId FROM Attachment WHERE Parentid=: getURL];
        System.debug('Work Element List :'+workElementList);
    }
     public pagereference deleteWorkElement(){
         if (SelectedWorkElementId == null) {
      
         return null;
      }
     
      
      Stage_Work_Element__c tobeDeleted = null;
      for(Stage_Work_Element__c a : workElementList)
       if (a.Id == SelectedWorkELementId) {
          tobeDeleted = a;
          break;
       }
      
      
      if (tobeDeleted != null) {
       Delete tobeDeleted;
      }
      PageReference pRef = new PageReference('/apex/Pavithra_DeliverableDetailsPage'); 
        pRef.getParameters().put('id', getURL); 
        pRef.setRedirect(true); 
        return pRef;

     } 
     
     public pagereference deleteAttachment(){
         if (SelectedAttachmentId == null) {
      
         return null ;
      }
     
      
      Attachment attachmentTOBeDeleted = null;
      for(Attachment attachment : attachmentList)
       if (attachment.Id == SelectedAttachmentId) {
          attachmentTOBeDeleted = attachment;
          break;
       }
      
      
      if (attachmentTOBeDeleted != null) {
       Delete attachmentTOBeDeleted;
      }
            PageReference pRef1 = new PageReference('/apex/Pavithra_DeliverableDetailsPage'); 
        pRef1.getParameters().put('id', getURL); 
        pRef1.setRedirect(true); 
        return pRef1;
     }    
    
    
}