public class ODP_Extented_ChangeOwner {

    public Offering_Release__c ORC{get;set;}
    public string offrelID {get;set;}
    public ODP_Extented_ChangeOwner(ApexPages.StandardController controller) {
        ORC = (Offering_Release__c )controller.getRecord();
        offrelID = Apexpages.currentPage().getParameters().get('OFID');
        ORC = [select OwnerId, name from Offering_Release__c where id =: offrelID]; 
    }
    
    public PageReference save(){
        try{
            upsert ORC;
            PageReference OFPage = new PageReference('/'+offrelID);
            OFPage.setRedirect(true);
            return OFPage;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'exception:' + e.getMessage()));
            return null;   
        }  
    }
    public PageReference cancel(){
        PageReference OFPage = new PageReference('/'+offrelID);
        OFPage.setRedirect(true);
        return OFPage;
    }

}