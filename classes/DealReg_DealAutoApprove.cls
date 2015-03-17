/**********************************************************
* Class Name: DealReg_DealAutoApprove
* Author: HP 
* Date: 09-Oct-2012 
* Description: To Auto approve the Deal Registration record after the level 1 approver approves
***********************************************************/

Public class DealReg_DealAutoApprove{

/*@description: Get the ProcessInstanceWorkItemId for records which are in pending status*/
public Id getWorkItemId(Id targetObjectId)
 {
   Id recordId= null;
   for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
       where p.ProcessInstance.TargetObjectId =: targetObjectId]){
              recordId=  workItem.Id;
       }   
          return recordId;
 }
   
/*@description: This method will Approve the Deal Registration*/
public void approveRecord(Deal_Registration__c dealReg)
  {
  Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
  request .setComments('Auto Approved');
  request .setAction('Approve');
  Id workItemId = getWorkItemId(dealReg.id);   
  if(workItemId == null){
     dealReg.addError('Error Occured in Trigger');
   }
   else{
     request.setWorkitemId(workItemId);
     // Submit the request for approval
     Approval.ProcessResult result =  Approval.process(request);
       }
   }
 }