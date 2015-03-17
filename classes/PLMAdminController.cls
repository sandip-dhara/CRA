public class PLMAdminController {

    public String CurSLName{get;set;}
    public String CurDescripion{get;set;}
    public Boolean CurActive{get;set;}
    public PageReference save() {
        try{
            SLC = new Service_Line__c(Name__c =CurSLName, Short_Description__c =CurDescripion, Is_Active__c=CurActive );
            insert SLC;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'OK'));        
        
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please Check your input before saving. Name must be provided and unique'));        
        
        }
        return null;
    }


    public Service_Line__c SLC{get;set;}
}