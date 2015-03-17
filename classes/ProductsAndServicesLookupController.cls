/**
* Class Name: ProductsAndServicesLookupController 
* Author: Accenture
* Date: 05-JULY-2012 
* Requirement # Request Id: 
* Description: Controller for Add,Search,View,Edit & Delete Products/Services
*/
public class ProductsAndServicesLookupController {

public String test{get;set;}
    /*public List<PricebookEntry> lstPricebookEntries {set;get;}
    public Boolean noProductFound {get;set;}
    public Boolean largeProductFound {get;set;}
    public String hierarchyLevel{get;set;}
    public String searchBusinessGroup{get;set;}
    public String searchProductLine{get;set;}
    public String searchSubProductLine{get;set;}
    public String opptyCurrency{get;set;}
    public String searchGlobalBusinessUnit{get;set;}
    public Integer numberOfItems{get;set;}
     
   /**
    * @description:  To get all Picklist values of Business Group on Product
    * @return: List of Picklist values
    * 
    */
    /*public String filters { get; set; }
    {
       filters = 'startswith';
    }
    
    /* public String getFilters() {
            return filters;
     } */
                        
        /*public void setFilters(String filters) { this.Filters = filters; }
        public List<SelectOption> getBGPicklist() {
        List<SelectOption> optionsBG = new List<SelectOption>();
        optionsBG.add(new SelectOption('None','--None--'));
        Schema.DescribeFieldResult field = Product2.Business_Group__c.getDescribe();
        List<Schema.PicklistEntry> valuesBG = field.getPicklistValues();
        for(Schema.PicklistEntry p : valuesBG){
            optionsBG.add(new SelectOption(p.getlabel(),p.getlabel()));
        }
        return optionsBG;
    }
    /**
    * @description:  To get all Picklist values of Global Business Unit on Product
    * @return: List of Picklist values
    * 
    */
    /*public List<SelectOption> getGBUPicklist() {
        List<SelectOption> optionsGBU = new List<SelectOption>();
        optionsGBU.add(new SelectOption('None','--None--'));
        Schema.DescribeFieldResult field = Product2.GBU__c.getDescribe();
        List<Schema.PicklistEntry> valuesGBU = field.getPicklistValues();
        for(Schema.PicklistEntry p : valuesGBU){
            optionsGBU.add(new SelectOption(p.getlabel(),p.getlabel()));
        }
        return optionsGBU;
    }
   /**
    * searchProduct: Search for product for keysearch on BG,GBU,PL and SPL
    * @param: none
    * @return: void
    */
  /* public void searchProduct() {
   //new code added for ALM1796
   String searchProductLineQS;
   String searchSubProductLineQS;
            if(filters !=null){
                if(filters.equals('startswith')){
                    if(searchProductLine!=null  && searchProductLine!=''){
                        searchProductLineQS=searchProductLine + '%' ;
                    }
                    
                    if(searchSubProductLine!=null  && searchSubProductLine!=''){
                        searchSubProductLineQS=searchSubProductLine+ '%' ;
                    }
                
                } else if(filters.equals('contains')){
                    if(searchProductLine!=null  && searchProductLine!=''){
                        searchProductLineQS= '%' + searchProductLine+ '%' ;
                    }
                    
                    if(searchSubProductLine!=null  && searchSubProductLine!=''){
                        searchSubProductLineQS='%' + searchSubProductLine+ '%' ;
                    }
                    
                }
            
            } else {
            
                if(searchProductLine!=null  && searchProductLine!=''){
                        searchProductLineQS=searchProductLine.replace('\\*','%') ;
                    }
                    
                    if(searchSubProductLine!=null  && searchSubProductLine!=''){
                        searchSubProductLineQS=searchSubProductLine.replace('\\*','%') ;
                    }
            
            }
            
         
        String query;
            Pricebook2 pricebook = [SELECT Id, Name, IsActive From Pricebook2 WHERE Name = 'Products & Services' AND IsActive = true];
            if(searchBusinessGroup!= '' && searchBusinessGroup!= null && searchBusinessGroup!= 'None'){
                if (searchGlobalBusinessUnit!= '' && searchGlobalBusinessUnit!= null && searchGlobalBusinessUnit!= 'None' && searchProductLine!= '' && searchProductLine!= null && searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.GBU__c like \'' + '%' + searchGlobalBusinessUnit+ '%\' AND' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\'  AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchGlobalBusinessUnit!= '' && searchGlobalBusinessUnit!= null && searchGlobalBusinessUnit!= 'None' && searchProductLine!= '' && searchProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.GBU__c like \'' + '%' + searchGlobalBusinessUnit+ '%\' AND' +' '+ 
                            'Product2.Product_Line__c like \'' + searchProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchGlobalBusinessUnit!= '' && searchGlobalBusinessUnit!= null && searchGlobalBusinessUnit!= 'None' && searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.GBU__c like \'' + '%' + searchGlobalBusinessUnit+ '%\' AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\'  AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchProductLine!= '' && searchProductLine!= null && searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\'  AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchGlobalBusinessUnit!= '' && searchGlobalBusinessUnit!= null && searchGlobalBusinessUnit!= 'None'){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Product2.GBU__c like \'' + '%' + searchGlobalBusinessUnit+ '%\' AND' +' '+ 
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' + 
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchProductLine!= '' && searchProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\'  AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\'  AND' +' '+
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+ 
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                } else {
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+ 
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' + 
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
            }
            else if(searchGlobalBusinessUnit!= '' && searchGlobalBusinessUnit!= null && searchGlobalBusinessUnit!= 'None') {
                if (searchProductLine!= '' && searchProductLine!= null && searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.GBU__c like \'' + '%' + searchGlobalBusinessUnit+ '%\' AND' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\'  AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchProductLine!= '' && searchProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.GBU__c like \'' + '%' + searchGlobalBusinessUnit+ '%\' AND' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit '+ ' ' + Label.Query_Limit;
                }
                else if (searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.GBU__c like \'' + '%' + searchGlobalBusinessUnit+ '%\' AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\'  AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                } else {
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.GBU__c like \'' + '%' + searchGlobalBusinessUnit+ '%\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }       
            }
            else if(searchProductLine!= '' && searchProductLine!= null) {
                if (searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\' AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                } else {
                    query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                } 
            }
            else if(searchSubProductLine!= '' && searchSubProductLine!= null) {
                query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' + 
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
            }else{
                query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit; 
            }
        system.debug('DEBUG_PRODSEARCH' + query);
        lstPricebookEntries=new List<PricebookEntry>();
        lstPricebookEntries = Database.query(query);
        system.debug('DEBUG_PRODSEARCHSIZE' + lstPricebookEntries.size());
        
        if (lstPricebookEntries.size() == 0){
            noProductFound = true;
        } else{
            noProductFound = false; 
            numberOfItems = lstPricebookEntries.size();   
        }
        if (lstPricebookEntries.size() >= Integer.valueOf(Label.Query_Limit)){
            largeProductFound = true;
        } else{
            largeProductFound = false;    
        }
   }
   /**
    * @description: used by the visualforce page to send the link to the right dom element
    * @return: String returns url lkfm(form) paramter value
    * 
    */
   /*public string getFormTag() {
        return System.currentPageReference().getParameters().get('lkfm');
   }
   /**
    * @description: used by the visualforce page to send the link to the right dom element
    * @return: String returns url lknm(TextBox) paramter value
    * 
    */ 
   /*public string getTextBox() {
        return System.currentPageReference().getParameters().get('lknm');
   }
   /**
    * @description: Class Constructor method
    *
    * 
    */
   /*public ProductsAndServicesLookupController () {
        searchBusinessGroup = apexpages.currentpage().getparameters().get('bg');
        searchGlobalBusinessUnit = apexpages.currentpage().getparameters().get('gbu');
        searchProductLine = apexpages.currentpage().getparameters().get('pl');
        searchSubProductLine = apexpages.currentpage().getparameters().get('spl');
        hierarchyLevel = apexpages.currentpage().getparameters().get('level');
        opptyCurrency = apexpages.currentpage().getparameters().get('curr');
        noProductFound = false;
        searchProduct();
   }  */
   
}