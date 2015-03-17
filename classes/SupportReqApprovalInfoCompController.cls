Global class SupportReqApprovalInfoCompController {

    
    public list<Approval__c> ApprovalList{get; set;}
    public integer info;
    public boolean isOpportunityApprovalListEmpty{get;set;}
    public Boolean isResultEmpty { get; set; }
    public List<ProcessInstance> ProcessInstanceList{get; set;}
    public list<User> listapprovers = new list<User>();
    public String approvernames{ set; get; }
    public String appnames;
    public list<Id> appIds = new list<Id>();
    public list<Opportunity_Pursuit_Resource_Requirement__c> PrList{set;get;}
    public list<Opportunity_Pursuit_Resource_Requirement__c> presourcelist = new list<Opportunity_Pursuit_Resource_Requirement__c>();
    public Id SRId {get;set;}
    public list<Approval__c> ApprovalList1{get; set;}
    public boolean ren{set; get;}
    
     public list<Approval__c> getinfo(){
         system.debug('**** '+SRId);
        ApprovalList1 = new List<Approval__c>();
         //approvernames = 'Abrar';
         isOpportunityApprovalListEmpty = false;
         Support_Request__c SupReqObj = new Support_Request__c();
           SupReqObj = [select Id, Opportunity__c from Support_Request__c where Id = :SRId];
           ApprovalList1 = [select Id,Status__c,Name,Pursuit_Budget_USD__c, Approved_Date__c from Approval__c where Opportunity__c =:SupReqObj.Opportunity__c and RecordType.Name = 'Opportunity Review' and status__c = 'Approved' ORDER BY Approved_Date__c DESC];
           
           
            if(ApprovalList1.size()<1){
            isOpportunityApprovalListEmpty= true;
            Approval__c ap = new Approval__c();
            ApprovalList1.add(ap);
            }
            else{
            PrList=[select Pursuit_Team_Name_Role__c, Estimated_Start_Date__c,Estimated_End_Date__c from Opportunity_Pursuit_Resource_Requirement__c where Approval__c =:ApprovalList1[0].Id];
            String selectQuery='SELECT Id,TargetObjectID,Lastmodifieddate,(SELECT Id, StepStatus,ActorId,OriginalActorId,Comments FROM StepsAndWorkitems where ' ;
            String whereCondition='(stepStatus = \'Approved\') )  FROM ProcessInstance where TargetObjectID in :ApprovalList1 ';
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
                  appnames='';
                  for(User ap : listapprovers)
                  {
                     appnames= ap.name+','+appnames;
                      approvernames=appnames.substring(0,appnames.length()-1);
                       system.debug('&%%%&'+approvernames );
                  }
                }
              }
             
              return null;
              
         
     }
          
     
       /* public list<Opportunity_Pursuit_Resource_Requirement__c> getPrList(){
            list<Opportunity_Pursuit_Resource_Requirement__c> PrList1 = new list<Opportunity_Pursuit_Resource_Requirement__c>();
            if(ApprovalList1!= null){
                system.debug('Inside IF'+ApprovalList1.size());
                PrList1=[select Pursuit_Team_Name_Role__c, Estimated_Start_Date__c, Estimated_End_Date__c from Opportunity_Pursuit_Resource_Requirement__c where Approval__c =:ApprovalList1[0].Id];
                
                }
            else
                isOpportunityApprovalListEmpty= true;
                system.debug('!@#$'+PrList1);
             return PrList1;
            }*/
  
}