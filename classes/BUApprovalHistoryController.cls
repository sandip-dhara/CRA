public class BUApprovalHistoryController {
    public String abpId {get;set;}
    public List<ProcessInstanceHistory> getApprovalSteps() {
      if (abpId!= null) {
      BU_Plan_Approval__c   quote = [Select Id, (Select SystemModstamp,Comments From ProcessSteps order by SystemModstamp desc) from BU_Plan_Approval__c where Id = :abpId];
        return quote.ProcessSteps;
      }
      return new List<ProcessInstanceHistory> ();
    }    
    }