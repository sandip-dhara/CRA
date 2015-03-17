public class ABPApprovalHistoryController {
    public String abpId {get;set;}
    public List<ProcessInstanceHistory> getApprovalSteps() {
      if (abpId!= null) {
      ABP_Approval__c   quote = [Select Id, (Select SystemModstamp,Comments From ProcessSteps order by SystemModstamp desc) from ABP_Approval__c where Id = :abpId];
        return quote.ProcessSteps;
      }
      return new List<ProcessInstanceHistory> ();
    }    
    }