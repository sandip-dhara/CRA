/**********************************************************
* Class Name: OpptyClone
* Author: HP
* Date: 10-DEC-2012  
* Requirement # Request Id: 
* Description: Clone Opportunity wit/without Product,Cpmpetetor,Partner 
*************************************************************/
public class OpptyClone{
public String opptyId;
public Boolean Product{get;set;}
public Boolean Partner{get;set;}
public Boolean Competitor{get;set;}
public String URLStrprd{get;set;}
public String URLStrwp{get;set;}



public OpptyClone(ApexPages.StandardController controller) {
    opptyId= ApexPages.currentPage().getParameters().get('id');
    
            List<OpportunityLineItem> OLI = [SELECT PricebookEntry.Product2Id,PricebookEntry.Product2.IsActive FROM OpportunityLineItem where OpportunityId =:opptyId AND PricebookEntry.Product2.IsActive = TRUE];       
        System.debug('*****************OLI******'+OLI);
        
        if(OLI.size()>0){
            Product = TRUE;
        }
        
        else{
           Product = FALSE; 
        }
 }   
       
    public pageReference Go(){
    System.debug('************Product'+Product);
    System.debug('************Product'+Partner);
    System.debug('************Product'+Competitor);
    String urlparam  = opptyId;
    Pagereference pgref;
    
   if(Partner == True){
   urlparam = urlparam+'Partner';
   } 
   if(Competitor == True){
   urlparam = urlparam+'Competitor';
   } 
        
        if(Product == True)
        URLStrprd = '/'+opptyId+'/e?clone=1&00NZ0000000jQKW='+urlparam+'&retURL='+opptyId+'&cloneli=1';        
        
        else
        URLStrprd = '/'+opptyId+'/e?clone=1&00NZ0000000jQKW='+urlparam+'&retURL='+opptyId;
        pgref = new Pagereference(URLStrprd);
        return pgref;        
    }
    
}