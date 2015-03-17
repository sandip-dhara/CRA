public class cpqHPQuoteEditIntermediateController {
    public HP_Quote__c objHPQuote;
    public Boolean renderError {get;set;}
    public cpqHPQuoteEditIntermediateController(ApexPages.StandardController controller) {
        this.objHPQuote = (HP_Quote__c)controller.getRecord();
        renderError = false;
    }
    
    public Pagereference redirectToBMIEditPage(){
        if(objHPQuote.Originating_Quote_System__c == 'BMI'){
            String reDirectURL='';
            if(objHPQuote.BMI_ID__c != null && objHPQuote.BMI_ID__c != ''){
                List<BigMachines__Quote__c> listBMIQuote = [Select id from BigMachines__Quote__c where Name=:objHPQuote.BMI_ID__c];
                if(!listBMIQuote.isEmpty()){
                    reDirectURL = '/apex/BigMachines__QuoteEdit?retURL=%2F'+objHPQuote.Id+'&scontrolCaching=1&sfdc.override=1&id='+listBMIQuote[0].Id;
                    PageReference Page=new PageReference(reDirectURL);
                    page.setRedirect(true);
                    return page;
                }
            }
        }
        renderError = true;
        return null;
    }

}