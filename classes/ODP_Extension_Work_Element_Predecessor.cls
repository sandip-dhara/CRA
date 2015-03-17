public class ODP_Extension_Work_Element_Predecessor {
   public Stage_Work_Element_Predecessor__c workElementName {get;set;}

    public ODP_Extension_Work_Element_Predecessor(ApexPages.StandardController controller) {
    }
    public pageReference readWorkElementName() {
        workElementName = [select Id,Predecessor_Stage_Work_Element_Name__c from Stage_Work_Element_Predecessor__c];
        return null;
    }
    
    
   
}