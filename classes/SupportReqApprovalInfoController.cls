public class SupportReqApprovalInfoController {

    
    public list<Approval__c> ApprovalList{ get; set;}
    private Support_Request__c stdControllerRecord;
    public boolean isOpportunityApprovalListEmpty{get;set;}
    public Boolean isResultEmpty { get; set; }
    public List<ProcessInstance> ProcessInstanceList{get; set;}
    public list<User> listapprovers = new list<User>();
    public String approvernames{ get; set; }
    public list<Id> appIds = new list<Id>();
    public list<Opportunity_Pursuit_Resource_Requirement__c> PrList{set; get;}
    public list<Opportunity_Pursuit_Resource_Requirement__c> presourcelist = new list<Opportunity_Pursuit_Resource_Requirement__c>();
   
    
    
    public SupportReqApprovalInfoController(ApexPages.StandardController controller) {
        ApprovalList=new List<Approval__c>();
        isOpportunityApprovalListEmpty= false;
        stdControllerRecord = (Support_Request__c)controller.getRecord();
        PrList=new list<Opportunity_Pursuit_Resource_Requirement__c>();
        /*for(Approval__c approval: [select Id,Status__c,Pursuit_Budget__c,Name,Approved_Date__c from Approval__c where Opportunity__c =:stdControllerRecord.Opportunity__c and RecordType.Name = 'Opportunity Review' and status__c = 'Approved']){
            ApprovalList.add(approval);
        }*/
        ApprovalList=[select Id,Status__c,Pursuit_Budget__c,Name,Approved_Date__c from Approval__c where Opportunity__c =:stdControllerRecord.Opportunity__c and RecordType.Name = 'Opportunity Review' and status__c = 'Approved' ORDER BY Approved_Date__c DESC];
        system.debug('*******   '+ApprovalList.size());
        if(ApprovalList.size()==0)
            isOpportunityApprovalListEmpty= true;
            else{
            String selectQuery='SELECT Id,TargetObjectID,Lastmodifieddate,(SELECT Id, StepStatus,ActorId,OriginalActorId,Comments FROM StepsAndWorkitems where ' ;
            String whereCondition='(stepStatus = \'Approved\') )  FROM ProcessInstance where TargetObjectID in :ApprovalList ';
            String Query=selectQuery+whereCondition;
    
           ProcessInstanceList =new List<ProcessInstance> ();
            try{
                ProcessInstanceList=database.query(query);
            }Catch(Exception e){ isResultEmpty =true;}
            system.debug(ProcessInstanceList);
                for(ProcessInstance pi: ProcessInstanceList){
                
                //Approval__c approvalRec=approvalIDNameMap.get(pi.TargetObjectID);
                for(ProcessInstanceHistory pih: pi.StepsAndWorkitems){
                   appIds.add(pih.ActorId);
                    
                                }
                  listapprovers=[select Name from User where Id in :appIds];
                  system.debug('%%%%%'+listapprovers);
                  approvernames='';
                  for(User ap : listapprovers)
                  {
                   approvernames = ap.name+','+approvernames;
                   approvernames = approvernames.substring(0,approvernames.length()-1);
                   system.debug('&%%%&'+approvernames);
                  }
                }
            PrList=new list<Opportunity_Pursuit_Resource_Requirement__c>();
            if(ApprovalList!= Null)
            PrList=[select Pursuit_Team_Name_Role__c, Estimated_Start_Date__c, Estimated_End_Date__c from Opportunity_Pursuit_Resource_Requirement__c where Approval__c =:ApprovalList[0].Id];
        }
      system.debug('!!!@@@'+isOpportunityApprovalListEmpty);
  }
}