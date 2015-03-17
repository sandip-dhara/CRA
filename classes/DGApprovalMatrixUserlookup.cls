/********************************
Author : Abrar
Release : R5 
Created Date: 26-APR-2013
Capability: Deal Governance
Desc : Approval Matrix lookup VF page controller
********************************/

public class DGApprovalMatrixUserlookup{

public String ApType{get; set;}
public String ApFieldId{get; set;}
public list<User> UserList = new list<User>();
public List<QueueSobject> QueueList;
public List<String> JobFunctionList;

    public DGApprovalMatrixUserlookup(){
    ApType = System.currentPageReference().getParameters().get('ApproverType');
    System.debug('?????'+ApType);
    ApType = ApType.replace('%20', ' ');
    ApFieldId= System.currentPageReference().getParameters().get('ApproverFieldId');
    JobFunctionList=new List<String>();
    }
    
    
    /* getting the user list*/
    public list<User> getUserList(){
    if(ApType=='Approver Role')
    UserList = [Select Name,Approver_Role__c  from User where Approver_Role__c != Null];
    return UserList;
         }
    /* getting the queue list*/        
    public List<QueueSobject> getQueueList()
    {
    QueueList = [Select Id, q.Queue.Name,q.Queue.ID, SobjectType from QueueSobject q where SobjectType = 'Approval__c'  ORDER BY q.Queue.Name];
    return QueueList;
    } 
    
    /* getting the Job function list*/ 
    public List<String> getJobFunctionList()
    {
        String JFL = Label.Job_Functions;
        for(String vals: JFL.Split(',')){
            JobFunctionList.add(vals);
        }
        //JobFunctionList = JFL.Split(',');
        //system.debug(JobFunctionList);
        return JobFunctionList;
      } 
           
        
}