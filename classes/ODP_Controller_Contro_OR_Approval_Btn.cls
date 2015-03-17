public class ODP_Controller_Contro_OR_Approval_Btn {

    public Offering_Release__c OfferingRelease {get;set;}
    public ODP_Controller_Contro_OR_Approval_Btn(ApexPages.StandardController controller) {
        OfferingRelease = (Offering_Release__c)controller.getRecord();
        if(OfferingRelease != null && OfferingRelease.Id != null)
        {
            OfferingRelease = [select status__c from Offering_Release__c where Id=:OfferingRelease.Id];
            
        }
    }

}