public class DGparticipantNewEditController {

Reviewer__c Reviewer;
public string str;
public Boolean HasAccess{get;set;}
    public DGparticipantNewEditController(ApexPages.StandardController controller) {

      Reviewer = (Reviewer__c)controller.getrecord();
      Str =ApexPages.currentPage().getParameters().get('retURL').substringAfter('/');
      HasAccess =False;
      If(Reviewer.id!=null)
      HasAccess =HasAccessLogic(Reviewer.Id);
    }

Public Pagereference SaveReviewer(){
     try{
      if(Reviewer.id == null){
          Reviewer.Reviewer_Workspace__c = str;
          Insert Reviewer;
      }
      else{
        update reviewer;
      }
      PageReference pg = new PageReference('/'+str);
      return pg;
      }
      Catch(Exception e)
      {
      return null;
      }
   }
   
    public static boolean HasAccessLogic(string ReviewerId){
    
       Boolean HasAccess = false;
       Reviewer__c Reviewers;
       
            Reviewers = [select id,Approval__c,createdbyid,Reviewer__c from Reviewer__c where id =:Reviewerid]; 
           system.debug('Reviewers--------'+Reviewers);
            
            String UserApprovertype =[select Approver_type__c from user where id=:userinfo.getuserid()].Approver_type__c;
                  
       list<Id> ProcessList = new list<Id>();            
             list<GroupMember> GroupMember = new list<GroupMember>();
             for(ProcessInstanceWorkitem p :[Select ProcessInstance.Status,ProcessInstance.TargetObjectId,ProcessInstanceId,OriginalActorId,Id,ActorId From ProcessInstanceWorkitem  where ProcessInstance.TargetObjectId =:Reviewers.Approval__c ])
                ProcessList.add(p.actorid);
           
             if(ProcessList.size()>0) 
        GroupMember = new list<GroupMember>([SELECT GroupId,Id,SystemModstamp,UserOrGroupId FROM GroupMember WHERE GroupId IN:ProcessList]);
          
        
         
          if(userApproverType =='Coordinator'|| Reviewers.Reviewer__c == Userinfo.getUserid() ||GroupMember.size()>0)
             HasAccess = true;
           return HasAccess;
              
  
  }
}