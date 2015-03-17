public with sharing class ODP_DeliverableDetailsController {
    public List<Stage_work_Element__c> workElementList {get;set;}
    public string SelectedWorkElementId { get; set; }
    Public String getURL{get;set;}
    public ODP_DeliverableDetailsController(ApexPages.StandardController controller) {
        getURL = ApexPages.currentPage().getParameters().get('Id'); 
        loadStageWorkElementsData();

    }
    
    private void loadStageWorkElementsData() {
    System.debug('Get URL :'+getURL);
        workElementList = [Select Id,Name,Stage_Name__c,Name__c,Status__c,Include__c,Release_Deliverable_ID__c from Stage_Work_Element__c where Release_Deliverable_ID__c= :getURL];
        
        System.debug('Work Element List :'+workElementList);
    }
     public void deleteWorkElement(){
         if (SelectedWorkElementId == null) {
      
         return;
      }
     
      // find the work element record within the collection
      Stage_Work_Element__c tobeDeleted = null;
      for(Stage_Work_Element__c a : workElementList)
       if (a.Id == SelectedWorkELementId) {
          tobeDeleted = a;
          break;
       }
      
      //if work element record found delete it
      if (tobeDeleted != null) {
       Delete tobeDeleted;
      }
     }    
    
    
}