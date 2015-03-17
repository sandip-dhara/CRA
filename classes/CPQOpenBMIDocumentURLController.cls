public class CPQOpenBMIDocumentURLController {
    public HP_Quote__c objHPQuote;
    public string BMIEditPage{set;get;}
    public CPQOpenBMIDocumentURLController(ApexPages.StandardController controller) {
        objHPQuote = (HP_Quote__c)controller.getRecord();
        BigMachines__Quote__c objBMIQuote = [Select id from BigMachines__Quote__c where Name=:objHPQuote.BMI_ID__c limit 1];
        BMIEditPage = '/apex/BigMachines__QuoteEdit?retURL=%2F'+objHPQuote.Id+'&scontrolCaching=1&sfdc.override=1&id='+objBMIQuote.Id;
    }
}