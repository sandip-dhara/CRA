/**
  * @author: HP
  * HP Release 
  * This class drives the logic for DealRegOpportunityLineItemBeforeDelete trigger.
  * Date: 19/08/2013
  */
public with sharing class OpportunityProductTriggerController {
    /*
     * @Description: Method to control delete Logic for Product Registration records.
     * @Param: List<OpportunityLineItem> oliList
     */
    public Pagereference controlDeleteProdReg(List<OpportunityLineItem> oliList){
        List<Id> oppIdList = new List<Id>();
        List<String> prodLineList= new List<String>();
        List<Product_Registration__c> productRegList = new List<Product_Registration__c>();
        List<Product_Registration__c> productRegdelList = new List<Product_Registration__c>();
        Map<String, Product_Registration__c> progRegMap= new Map<String, Product_Registration__c>();
        
        for(OpportunityLineItem oli: oliList){
            oppIdList.add(oli.OpportunityId);
            prodLineList.add(oli.Product_Line__c);
        }
        productRegList =[select status__c,Product_Line__c ,opportunity__r.Name, Deal_Registration__r.Product_Registration_Approved_count__c, id from Product_Registration__c where Opportunity__c IN: oppIdList and Opportunity__r.Deal_Registration_Status__c IN( 'Open', 'approved','rejected') and Product_Line__c IN :prodLineList];
        for(Product_Registration__c progReg: productRegList ){
            progRegMap.put(progReg.Product_Line__c,progReg);
        }
        for(OpportunityLineItem oli: oliList){
            if(progRegMap.ContainsKey(oli.Product_Line__c)){
                if(progRegMap.get(oli.Product_Line__c).Deal_Registration__r.Product_Registration_Approved_count__c==1 && progRegMap.get(oli.Product_Line__c).status__c=='Approved'){
                    oli.addError('Selected Product cannot be deleted as corresponding Product Registration is the only approved record in Deal Registration.');
                }
                else{
                    productRegdelList.add(progRegMap.get(oli.Product_Line__c));
                }
            }
        }
        try{
            Delete productRegdelList;
        }
        catch(DMLException ex){
            system.debug('***Error occurred while deleting***');
        }
        return null;
    }
}