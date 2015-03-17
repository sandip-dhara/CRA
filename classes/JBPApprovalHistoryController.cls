/*********************************************************
* Class Name: JBPApprovalHistoryController
* Author: HP  
* Date: 21-March-2013 
* Requirement #: 5429
* Description: To get the Approval History of JBP to display in Email Template
*********************************************************/
public class JBPApprovalHistoryController {
    public String JBPId {get;set;}
    public List<ProcessInstanceHistory> getApprovalSteps() {
    if (JBPId != null){
        JBP__c jbp = [Select Id, (Select SystemModstamp, StepStatus, OriginalActorId, Comments, ActorId From ProcessSteps order by SystemModstamp desc) from JBP__c where Id = :jbpId];
        return jbp.ProcessSteps;
    }
    return new List<ProcessInstanceHistory> ();
    } 
}