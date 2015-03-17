public class ExtendedReleaseDeliverable {
    
    public ExtendedReleaseDeliverable(ApexPages.StandardController controller) {
        rdc = (Release_Deliverable__c)controller.getRecord();
        mytype = String.ValueOf(rdc.RecordType);
    }

    final Release_Deliverable__c rdc;
    public string mytype {get;set;}
}