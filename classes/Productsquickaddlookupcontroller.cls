public class Productsquickaddlookupcontroller {
    public List<WrapperPriceBook> lstPricebookEntries {set;get;}
    public Boolean noProductFound {get;set;}
    public Boolean largeProductFound {get;set;}
    public String hierarchyLevel{get;set;}
    public String productlevel{get;set;}
    public Boolean Issubproductlevel{get;set;}
    public String searchBusinessGroup{get;set;}
    public String searchProductLine{get;set;}
    public String searchSubProductLine{get;set;}
    public String opptyCurrency{get;set;}
    public String searchGlobalBusinessUnit{get;set;}
    public Integer numberOfItems{get;set;}
    public String BGvalue{set;get;}
    public String section{get;set;}
    public Boolean bgnotnull{get;set;}
    public Boolean gbunotnull{get;set;}
    
    public List<SelectOption> GBUPicklist{get;set;}
    public List<SelectOption> BGPicklist{get;set;}
    public Map<String,String> gbuandbgmap{get;set;}
    
   /**
    * @description:  To get all Picklist values of Business Group on Product
    * @return: List of Picklist values
    * 
    */
    public String filters { get; set; }
    {
       filters = 'startswith';
    }
    
     /*public String getFilters() {
            return filters;
     } */
                                             
               
  //R4.0 POC: BG field in add product page needs to be dynamic based on available active products
        
        public void setFilters(String filters) { this.Filters = filters; }
        public Map<String,String> BGChinesEnglistMap=new Map<String,String>();
        public Map<String,String> GBUChinesEnglistMap=new Map<String,String>();
        
        
        
        public List<SelectOption> BGPicklistvalues() {
        
        BGPicklist=new List<SelectOption> ();
        BGPicklist.add(new SelectOption('None','--None--'));
        List<Product2> activeBGList = new List<Product2>([Select id,toLabel(Business_Group__c) FROM Product2 WHERE IsActive=true and Product_Level__c=2 order by ID]);
        List<Product2> activeBGList1 = new List<Product2>([Select id,Business_Group__c FROM Product2 WHERE IsActive=true and Product_Level__c=2 order By ID]);
        for(integer i=0;i<activeBGList.size();i++){
            BGChinesEnglistMap.put(activeBGList[i].Business_Group__c,activeBGList1[i].Business_Group__c);
    
        }
        system.debug('%%%'+BGChinesEnglistMap);
        Set <String> bgs=new Set<String>();
        for(Product2 p : activeBGList){
         If(p.Business_Group__c != Null){
            bgs.add(p.Business_Group__c);            
         } 
        } 
        List<String> bgList = new List<String>();
        bgList.addAll(bgs);
        bgList.sort();
        for(String bg : bgList){       
          BGPicklist.add(new SelectOption(bg, bg));
        }    
        return BGPicklist;
        }
        
     public void GBUPicklistvalues() {
     //searchGlobalBusinessUnit=null;
        
        GBUPicklist=new List<SelectOption> ();        
        GBUPicklist.add(new SelectOption('None','--None--'));
        Set <String> gbus=new Set<String>();
        List<Product2> activeGBUList=new List<Product2>([Select toLabel(GBU__c),toLabel(Business_Group__c) FROM Product2 WHERE IsActive=true and Product_Level__c=2]);
        List<Product2> activeGBUList1=new List<Product2>([Select GBU__c,Business_Group__c FROM Product2 WHERE IsActive=true and Product_Level__c=2]);
        for(integer i=0;i<activeGBUList.size();i++){
            GBUChinesEnglistMap.put(activeGBUList[i].GBU__c,activeGBUList1[i].GBU__c);
    
        }
        system.debug('%%%'+GBUChinesEnglistMap);
        for(Product2 p: activeGBUList){
             If(p.GBU__c != Null){
             
                gbus.add(p.GBU__c);
                gbuandbgmap.put(p.GBU__c,p.Business_Group__c);                    
             } 
         }
          
        List<String> gbuList = new List<String>();
        gbuList.addAll(gbus);
        gbuList.sort();
        for(String gb : gbuList){
          GBUPicklist.add(new SelectOption(gb, gb));
        }     
        }
        
        public PageReference GBUFilter(){
           
            system.debug('BG value'+BGvalue);
            //getGBUPicklist();
            return null;
        
        }
    
   /**
    * searchProduct: Search for product for keysearch on BG,GBU,PL and SPL
    * @param: none
    * @return: void
    */
   public void searchProduct() {
   //new code added for ALM1796
   String searchProductLineQS;
   String searchSubProductLineQS;
            
            
            if(searchBusinessGroup!=null && searchBusinessGroup!='' && section!='edit' ){
                searchBusinessGroup=BGChinesEnglistMap.get(searchBusinessGroup);                
            }
            
            if(searchGlobalBusinessUnit!=null && searchGlobalBusinessUnit!='' && section!='edit' ){
                searchGlobalBusinessUnit=GBUChinesEnglistMap.get(searchGlobalBusinessUnit);
                
            }
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
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.GBU__c = \'' +  searchGlobalBusinessUnit+ '\' AND' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\'  AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+  
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchGlobalBusinessUnit!= '' && searchGlobalBusinessUnit!= null && searchGlobalBusinessUnit!= 'None' && searchProductLine!= '' && searchProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.GBU__c = \'' +  searchGlobalBusinessUnit+ '\' AND' +' '+
                            'Product2.Product_Line__c like \'' + searchProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchGlobalBusinessUnit!= '' && searchGlobalBusinessUnit!= null && searchGlobalBusinessUnit!= 'None' && searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.GBU__c = \'' +  searchGlobalBusinessUnit+ '\' AND' +' '+
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\'  AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchProductLine!= '' && searchProductLine!= null && searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\'  AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchGlobalBusinessUnit!= '' && searchGlobalBusinessUnit!= null && searchGlobalBusinessUnit!= 'None'){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Product2.GBU__c = \'' +  searchGlobalBusinessUnit+ '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' + 
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchProductLine!= '' && searchProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\'  AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\'  AND' +' '+
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+ 
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                } else {
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+ 
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' + 
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
            }
            else if(searchGlobalBusinessUnit!= '' && searchGlobalBusinessUnit!= null && searchGlobalBusinessUnit!= 'None') {
                if (searchProductLine!= '' && searchProductLine!= null && searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.GBU__c = \'' +  searchGlobalBusinessUnit+ '\' AND' +' '+
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\'  AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }
                else if (searchProductLine!= '' && searchProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.GBU__c = \'' +  searchGlobalBusinessUnit+ '\' AND' +' '+
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit '+ ' ' + Label.Query_Limit;
                }
                else if (searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.GBU__c = \'' +  searchGlobalBusinessUnit+ '\' AND' +' '+
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\'  AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                } else {
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.GBU__c = \'' +  searchGlobalBusinessUnit+ '\' AND' +' '+
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                }       
            }
            else if(searchProductLine!= '' && searchProductLine!= null) {
                if (searchSubProductLine!= '' && searchSubProductLine!= null){
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\' AND' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                } else {
                    query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Product_Line__c like \''  + searchProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+  
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                } 
            }
            else if(searchSubProductLine!= '' && searchSubProductLine!= null) {
                query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'Product2.Sub_Product_Line__c like \''  + searchSubProductLineQS+ '\' AND' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+  
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' + 
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit;
            }else{
                query = 'select Id, Name, IsActive, unitPrice, toLabel(Product2.Business_Group__c), toLabel(Product2.GBU__c),Product2.Service__c,' +
                            'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                            'CurrencyIsoCode = \'' + opptyCurrency + '\' AND' +' '+
                            'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                            'product2.name != \'1052 - Outside Segment Elimination Entrepreneur\' AND' +' '+ 
                            'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                            ' IsActive = true limit'+ ' ' + Label.Query_Limit; 
            }
        system.debug('DEBUG_PRODSEARCH' + query);
        lstPricebookEntries=new List<WrapperPriceBook>();
        for(PricebookEntry pe: Database.query(query)){
            if(section=='edit'){
            lstPricebookEntries.add(new WrapperPriceBook(pe,GBUChinesEnglistMap.get(pe.Product2.GBU__c)));
            }else{
                lstPricebookEntries.add(new WrapperPriceBook(pe,pe.Product2.GBU__c));
            }
        }
        
        //lstPricebookEntries = Database.query(query);
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
   public string getFormTag() {
        return System.currentPageReference().getParameters().get('lkfm');
   }
   /**
    * @description: used by the visualforce page to send the link to the right dom element
    * @return: String returns url lknm(TextBox) paramter value
    * 
    */ 
   public string getTextBox() {
        return System.currentPageReference().getParameters().get('lknm');
   }
   /**
    * @description: Class Constructor method
    *
    * 
    */
   public Productsquickaddlookupcontroller () {
        searchBusinessGroup = apexpages.currentpage().getparameters().get('bg');
        searchGlobalBusinessUnit = apexpages.currentpage().getparameters().get('gbu');
        searchProductLine = apexpages.currentpage().getparameters().get('pl');
        searchSubProductLine = apexpages.currentpage().getparameters().get('spl');
        hierarchyLevel = apexpages.currentpage().getparameters().get('level');
        section= apexpages.currentpage().getparameters().get('sec');
        opptyCurrency = apexpages.currentpage().getparameters().get('curr');
        noProductFound = false;
        bgnotnull=false;
        gbunotnull=false;
        Issubproductlevel=false;
        gbuandbgmap=new  Map<String,String>();
        
        if(hierarchyLevel=='4'){
            productlevel='Product Line';
        }else if(hierarchyLevel=='5'){
            productlevel='Sub Product Line';
            Issubproductlevel=true;
        }
        if(searchBusinessGroup!=null&&searchBusinessGroup!='None'){
            bgnotnull=true;
        }if(searchGlobalBusinessUnit!=null&&searchGlobalBusinessUnit!='None'){
            gbunotnull=true;
        }
        system.debug('@@@'+searchGlobalBusinessUnit );
        BGPicklistvalues();
        GBUPicklistvalues();
        
        searchProduct();
        system.debug('@@@'+searchGlobalBusinessUnit );
   }  
       /*******************************      
          Added for R4 
      ********************************/
      public void OnchangeofBG(){
          GBUPicklist=new List<SelectOption> ();
          GBUPicklist.add(new SelectOption('None','--None--'));
          Set <String> gbus=new Set<String>();
          if(searchBusinessGroup!=null && searchBusinessGroup!='' ){
                searchBusinessGroup=BGChinesEnglistMap.get(searchBusinessGroup);                
            }
          for(List<Product2> actgb : [Select toLabel(GBU__c),toLabel(Business_Group__c) FROM Product2 WHERE IsActive=true and Product_Level__c=2 and Business_Group__c=:searchBusinessGroup]){
                for(Product2 p: actgb){
                     If(p.GBU__c != Null){
                     
                        gbus.add(p.GBU__c);                    
                     } 
                 }
              }
            List<String> gbuList = new List<String>();
            gbuList.addAll(gbus);
            gbuList.sort();
            for(String gb : gbuList){         
              GBUPicklist.add(new SelectOption(gb, gb));
            } 
      }
    public void OnchangeOfGBU(){
 
      //searchBusinessGroup=gbuandbgmap.get(searchGlobalBusinessUnit); 
      
      searchProduct(); 
              
  }
   public void OnchangeOfBGmock(){
 
      //searchBusinessGroup=gbuandbgmap.get(searchGlobalBusinessUnit); 
      searchGlobalBusinessUnit='None';
      searchProduct(); 
              
  }
  
  public class WrapperPriceBook{
    public String BGUName{set;get;}
    public PricebookEntry pe{set;get;}
    public WrapperPriceBook(PricebookEntry pbe,String GBUVal){
        BGUName=GBUVal;
        pe=pbe;
    }
  
  
  }
  
  
   
}