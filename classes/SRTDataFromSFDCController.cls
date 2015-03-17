public class SRTDataFromSFDCController{  
    private ApexPages.StandardController stdCtrl {get; set;} 
    public List<Support_Request__c> SR {get; set;}     
    public List<Contract_Reference__c> conts {get; set;}     
    public List<HP_Quote__c> quotesList{get;set;}
    public List<OpportunityLineItem> opportunityLineItem {get; set;}     
    public Opportunity oppty {get; set;} 
    public Account account {get; set;} 
    public SRTDataFromSFDCController(ApexPages.StandardController std)  {   stdCtrl=std;   setupContacts();  }     
        private void setupContacts(){   
            SR = [select Opportunity__c from Support_Request__c where id=:stdCtrl.getId()];
            if(SR.size()==1){
                oppty = [select id,Name,AccountId from Opportunity where id = :SR[0].Opportunity__c];
                account = [Select id, Name from Account where id = :oppty.AccountId];
                conts=[select Name,Sales_Doc_Nbr__c, Document_Type__c, AMP_ID__c,Group_Contract_Nbr__c,SAID__c,Contract_Start_Date__c,Contract_End_date__c,Total_Contract_Value__c,Functional_Location__c from Contract_Reference__c where Original_Opportunity__c = :SR[0].Opportunity__c Limit 1000]; 
                opportunityLineItem=[select Sales_Doc_Nbr__c,Description,Quantity ,UnitPrice,ListPrice,Discount,ProductId__c,Product__c,ProductName__c from OpportunityLineItem where OpportunityId = :SR[0].Opportunity__c Limit 1000];
                quotesList = new List<HP_Quote__c>();
                quotesList = [Select Id, Originating_System_Quote_ID__c From HP_Quote__c Where Opportunity_Name__c = :SR[0].Opportunity__c Limit 1000];
                
            }
        /********Commented for optimization by Deepak Saxena**********************************************/
        /* for(Support_Request__c section : SR){ 
            oppty = [select id,Name,AccountId from Opportunity where id = :section.Opportunity__c];
            account = [Select id, Name from Account where id = :oppty.AccountId];
            conts=[select Name,Sales_Doc_Nbr__c, Document_Type__c, AMP_ID__c,Group_Contract_Nbr__c,SAID__c,Contract_Start_Date__c,Contract_End_date__c,Total_Contract_Value__c,Functional_Location__c from Contract_Reference__c where Original_Opportunity__c = :section.Opportunity__c]; 
            opportunityLineItem=[select Sales_Doc_Nbr__c,Description,Quantity ,UnitPrice,ListPrice,Discount,ProductId__c,Product__c,ProductName__c from OpportunityLineItem where OpportunityId = :section.Opportunity__c];
        } */
    } 
}