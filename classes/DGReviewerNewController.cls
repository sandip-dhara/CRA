public with sharing class DGReviewerNewController {


public ApexPages.StandardController std; 
    public String id;
    public List<DGReviewerNewClassWrapper> ReviewerWrapper;
    public boolean isaddrow;   
    public user activeUser {get;set;}
    public Opportunity oppty {get; set;}
    public Boolean isInsert;
    Public string str;
    
 public DGReviewerNewController (ApexPages.StandardController controller) {
        Str =ApexPages.currentPage().getParameters().get('retURL').substringAfter('/');
        ReviewerWrapper=new List<DGReviewerNewClassWrapper>();       
        isaddrow =true;
        isInsert=false;
       
    }

/*getter seter for add row*/
    public List<DGReviewerNewClassWrapper> getReviewerWrapper(){
        If(isaddrow == true){
           for(Integer i=0;i<6;i++){
            system.debug('******addrow2*******'+isaddrow);
            Reviewer__c prAddRow=new Reviewer__c();
            system.debug('******addrow3*******'+isaddrow);
            DGReviewerNewClassWrapper RevWrapper = new DGReviewerNewClassWrapper(prAddRow);
            system.debug('******addrow4*******'+isaddrow);
            RevWrapper.index = ReviewerWrapper.size()+1;
            system.debug('******index *******'+ReviewerWrapper.size());
            ReviewerWrapper.add(RevWrapper);
            system.debug('******ReviewerWrapper*******'+ReviewerWrapper);
           } 
            isaddrow = false;
        }
        return ReviewerWrapper;
    }
    
    /* Custom save for adding the Reviewer to the save*/ 
    public PageReference customSave(){ 
        Savepoint sp = Database.setSavepoint();
       
        try{
           
    
        
        List<Reviewer__c> opprrToInsertList=new List<Reviewer__c >();
        for (DGReviewerNewClassWrapper ppwc: ReviewerWrapper) {
           if(ppwc.reviewerObj.Reviewer__c !=null){
            ppwc.reviewerObj.Reviewer_Workspace__c = str; 
            opprrToInsertList.add(ppwc.reviewerObj);
            }
        }
        system.debug('List*********  '+opprrToInsertList.size());
        insert opprrToInsertList;
        PageReference pr = new PageReference('/'+str);
        pr.setRedirect(true); 
        return pr;
        }
        catch(Exception e){
          //Database.rollback( sp );
          isInsert=true;
          string msg=e.getMessage();
          system.debug('msg***************'+msg);
          ApexPages.addmessages(e);
        return null;
        }
       
    }  

/*Wrapper class for adding and deleting row on fly without committing to the database.*/
    public class DGReviewerNewClassWrapper
    {

        public integer index {get;set;}
        public Reviewer__c reviewerObj{get;set;}
        public DGReviewerNewClassWrapper(Reviewer__c reviewerObj){
            system.debug('Index****wrapper class:'+this.index);
            this.reviewerObj=reviewerObj;
        }
    }


}