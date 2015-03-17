public with sharing class DGApproverNewController {


public ApexPages.StandardController std; 
    public String id;
    public List<ApproverWrapperClass> ApproverWrapper;
    public boolean isaddrow;   
    public user activeUser {get;set;}
    public Opportunity oppty {get; set;}
    public Boolean isInsert;
    Public string str;
 public DGApproverNewController(ApexPages.StandardController controller) {
        Str =ApexPages.currentPage().getParameters().get('retURL').substringAfter('/');
        ApproverWrapper=new List<ApproverWrapperClass>();
          
        isaddrow=True;
        isInsert=false;
       
    }

/*getter seter for add row*/
    public List<ApproverWrapperClass> getApproverWrapper(){
        If(isaddrow == true){
         for(Integer i=0;i<6;i++){
            //ompetitorList.add(new CompetitorClass(competitorRecord.Opportunity__c));
        
            system.debug('******addrow2*******'+isaddrow);
            WS_Approver__c prAddRow=new WS_Approver__c();
            system.debug('******addrow3*******'+isaddrow);
            ApproverWrapperClass persuitresWrapper = new ApproverWrapperClass(prAddRow);
            system.debug('******addrow4*******'+isaddrow);
            persuitresWrapper.index = ApproverWrapper.size()+1;
            system.debug('******index *******'+ApproverWrapper.size());
            ApproverWrapper.add(persuitresWrapper);
            system.debug('******ApproverWrapper*******'+ApproverWrapper);
            }
            isaddrow = false;
            
        }
        return ApproverWrapper;
    }
  
    /* Custom save for adding the Pursuit Resource to the save*/ 
    public PageReference customSave(){ 
        Savepoint sp = Database.setSavepoint();
       
        try{
           
    
        
        List<WS_Approver__c> opprrToInsertList=new List<WS_Approver__c >();
        for (ApproverWrapperClass ppwc: ApproverWrapper) {
          if(ppwc.oApproverObj.Approver__c !=null  ){
          system.debug('ppwc.oApproverObj.Approver__c------'+ppwc.oApproverObj.Approver__c);
         
            ppwc.oApproverObj.Approval_status__c ='Pending';
            ppwc.oApproverObj.Reviewer_Workspace__c = str; 
            opprrToInsertList.add(ppwc.oApproverObj);
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
    public class ApproverWrapperClass
    {

        public integer index {get;set;}
        public WS_Approver__c oApproverObj{get;set;}
        public ApproverWrapperClass(WS_Approver__c oApproverObj){
            system.debug('Index****wrapper class:'+this.index);
            this.oApproverObj=oApproverObj;
        }
    }



}