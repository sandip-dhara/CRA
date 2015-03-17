public class DGApproverNewEdit {

  public WS_Approver__c Approver;
  
  String Str;
  public string ApprovalId{get;set;}
  public Boolean var{get;set;}
  String ApprovalStatus ;

    public DGApproverNewEdit(ApexPages.StandardController controller) {
      
       Approver = (WS_Approver__c)controller.getrecord();
       system.debug('approver-----'+approver);
        var = false;
        
         
       Str =ApexPages.currentPage().getParameters().get('retURL').substringAfter('/');
               Approvalid = approver.id;
        if(approvalid!=null)
           var = HasAccessLogic(approvalid);
         
    }


   Public Pagereference Approve(){
   
   try{
      Approver.Approval_status__c ='Approved';
      Approver.Actual_Approver__c = userinfo.getuserid();
     //  = comments;
      system.debug('Approver----'+Approver.comments__c);
      Update Approver;
      PageReference pg = new PageReference('/'+str);
      return pg;
      }
    catch(Exception e) 
    {
    return null;
    }
     
   }
   
   Public Pagereference Reject(){
   try{
      Approver.Approval_status__c ='Rejected';
      Approver.Actual_Approver__c = userinfo.getuserid();
      Update Approver;
      PageReference pg = new PageReference('/'+str);
      return pg;
      }
    catch(Exception e){
    return null;
    }  
   }
   Public Pagereference SaveApprove(){
   try{
     Approver.Approval_status__c ='Pending';
     Approver.Reviewer_Workspace__c = str;    
      Insert Approver;
       PageReference pg = new PageReference('/'+str);
      return pg;
      }
      Catch(Exception e){
     return null;
      }
     
   }
  public static boolean HasAccessLogic(string ApprovalId){
    
       Boolean HasAccess = false;
       WS_Approver__c Approvers;
       
            Approvers = [select id,Approval_Status__c,Approver__c,Approval__c,createdbyid,comments__c from WS_Approver__c where id =:Approvalid]; 
            
          /*  Set<ID> userIdSet=new Set<ID>();
            userIdSet.add(userInfo.getUSerID());
            String Approval = approvers.Approval__c;
            System.debug('Approval-------'+Approval);
            
            for(GroupMember gm: [SELECT GroupId,Id,SystemModstamp,UserOrGroupId FROM GroupMember WHERE GroupId in (select id from group where type='Queue') and UserOrGroupId=:userInfo.getUSerID()])
            {
              userIDSet.add(gm.GroupId);
            }
            System.debug('UserIdSet--------'+UserIdSet);
            List<ProcessInstance> ProcessInstanceList =new List<ProcessInstance> ();
            List<String> FinalList = new List<String>();
            ProcessInstanceList = [SELECT Id,TargetObjectID,(SELECT Id, StepStatus,ActorId,OriginalActorId,Comments FROM StepsAndWorkitems where ActorId in :userIdSet) FROM ProcessInstance where TargetObjectID=:Approval];
           for(ProcessInstance pi: ProcessInstanceList){ 
             for(ProcessInstanceHistory pih: pi.StepsAndWorkitems){
               FinalList.add(pih.id);
             }
            }
           
            If(FinalList.size() > 0 || approvers.createdbyid == Userinfo.getUserId()||Approvers.Approver__c == Userinfo.getUserid())
              HasAccess = true;*/
            
            String UserApprovertype =[select Approver_type__c from user where id=:userinfo.getuserid()].Approver_type__c;
            system.debug('Approvalid-----'+ApprovalId);
            system.debug('Approvers.Approval__c======='+Approvers.Approval__c);
             list<Id> ProcessList = new list<Id>();            
             list<GroupMember> GroupMember = new list<GroupMember>();
             for(ProcessInstanceWorkitem p :[Select ProcessInstance.Status,ProcessInstance.TargetObjectId,ProcessInstanceId,OriginalActorId,Id,ActorId From ProcessInstanceWorkitem  where ProcessInstance.TargetObjectId =:Approvers.Approval__c ])
                ProcessList.add(p.actorid);
           
             if(ProcessList.size()>0) 
        GroupMember = new list<GroupMember>([SELECT GroupId,Id,SystemModstamp,UserOrGroupId FROM GroupMember WHERE GroupId IN:ProcessList]);
         
         
          if(userApproverType =='Coordinator'|| Approvers.Approver__c == Userinfo.getUserid() ||GroupMember.size()>0)
             HasAccess = true;
           return HasAccess;
              
  
  }
}