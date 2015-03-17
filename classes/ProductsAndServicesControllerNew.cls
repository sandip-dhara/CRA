/**
 * Class Name: ProductsAndServicesController 
 * Author: HP
 * Date: 18-Sep-2012 
 * Requirement # Request Id: 
 * Description: Controller for Add,Search1,View,Edit, Delete Products/Services and appply program for selected product and send for an approval
 * Last Modified :Modified for Deal Registration 
 */
public class ProductsAndServicesControllerNew {

        public String showAdd{get; set;}
        public String isAddProd{get; set;}
        List<Product_Registration__c> test = new List<Product_Registration__c>();
        public Opportunity oppty {get; set;}
        public Opportunity opp {get; set;}
        public user activeUser {get;set;}
        public OpportunityLineItem testOpptyProduct {get;set;}
        public string existingProductsQuery;
        public string oppId{get;set;}
        private String sortExp = '';
        public String sortFullExp = '';
        private String sortDirection = Label.ASC;
        public string opptyCloseDate  {get;set;}
        public string action {get;set;}
        public String action0{get;set;}
        public integer tableWidth {get;set;}
        public Set<Id> restrictedSet;

        /* Added for Quote Functionality */
        public Boolean showSyncButton{get;set;}
        public opportunity objOpportunity;
        public User objUser{get;set;}
        public Boolean showRetain{get;set;}

        /* Created for CR-0139 - Stop SAP Functionality for RENEWALS  - 10th Aug 2012   */    
        public Id RecordTypeId {get; set;}
        public boolean IsRecordType {get;set;}

        /*Search Strings to search existing Line items*/
        public string searchExistingBusinessGroup {get;set;}
        /*  public string searchExistingGlobalBusinessUnit {get;set;}*/
        public string searchExistingProductLine {get;set;}
        public string searchExistingSubProductLine {get;set;}

        /*Lists of Product Names for Success & Error Messages : Bulk Operation*/
        public list<string> listEditSuccess {get;set;}
        public list<string> listEditFailure {get;set;}
        public list<string> listDeleteSuccess {get;set;}
        public list<string> listDeleteFailure {get;set;}
        public list<string> listInsertSuccess {get;set;}
        public list<string> listInsertFailure {get;set;}
        public list<string> listDisassociateSuccess {get;set;}
        public list<string> listDisassociateFailure {get;set;}
        public list<string> listAssociationSuccess {get;set;}
        public list<string> listAssociationFailure {get;set;}
        public list<string> listEditBookshipdate {get;set;}

        /*Flags used on Page*/
        public boolean navigationFlag {get; set;}
        public boolean EsSpecificFlag {get; set;}
        public boolean RTSSpecificFlag {get; set;}
        public boolean largeResultFlag {get; set;}
        public boolean collapsibleFlag {get; set;}
        public boolean collapsibleFlag0 {get; set;}
        public boolean allProductsFlag {get; set;} 
        public boolean noAccessFlag {get; set;}
        public Boolean noResultsFlag {get; set;}
        public Boolean convertCurrencyFlag {get; set;}
        public Boolean existingProductsFilterFlag {get; set;}
        public Boolean masterCheckboxFlag {get; set;}
        public Boolean isOrphanFlag {get; set;}
        public Boolean isEdittedFlag {get; set;}
        public Boolean isEditFailureFlag {get; set;}
        public Boolean isInsertedFlag {get; set;}
        public Boolean isInsertFailureFlag {get; set;}
        public Boolean isDeletedFlag {get; set;}
        public Boolean isDeleteFailureFlag {get; set;}
        public Boolean isInsertAfterDeleteFlag {get; set;}
        public Boolean isInsertAfterDeleteFailureFlag{get; set;}
        public Boolean isDeleteBeforeInsertFlag {get; set;}
        public Boolean isDeleteBeforeInsertFailureFlag {get; set;}
        public Boolean isWarnBookShipDateChange {get; set;}
        public Boolean isInactvieProduct{get; set;}
        
        
        
        /*Line Item Lists & Wrapper Lists */
        public List<wrapperLineItem> existingLineItemList {get; set;}
        public List<wrapperLineItem> newLineItemList;
        public List<wrapperLineItem> deletedLineItemList;
        public List<OpportunityLineItem> newLineItems;
        public List<OpportunityLineItem> deleteAndInsertLineItems;
        public List<OpportunityLineItem> insertLineItems;
        public List<OpportunityLineItem> edittedLineItems;
        public Set<Id> lineitemIds;
        public Set<Id> edittedLineitemIds;
        public Set<Id> deletedLineitemIds;
        public Set<Id> pendingLineitemIds;

        /*Pagination*/
        public Integer noOfRecordPerPage {get;set;}
        public Integer selectedPage {get;set;}
        public Integer selectedPageMore {get;set;}
        public Map<Integer, List<wrapperLineItem>> mapOpportunityLineItems{get;set;}
        public List<selectoption> pagesOptions {get;set;}
         public List<selectoption> pagesOptionsforMoreRecords {get;set;}
         public Integer noOfRecordPerPageMore {get;set;}
        String searchExistingGlobalBusinessUnit;

        // Starting the Deal Registration code
        Public boolean isPartner{get;set;}
        public List<programwrapper> programList {get;set;}
        public List<OpportunityLineItem> selectedPrograms = new List<OpportunityLineItem>();
        public Boolean hasSelectedPrograms {get;set;}
        public Set<String> selProgramName {get;set;}
        public List<OpportunityLineItem> opportunityLineItemList = new List<OpportunityLineItem>(); 
        public User partnerUserIdValue{get;set;}   
        public String getsearchExistingGlobalBusinessUnit () { return this.searchExistingGlobalBusinessUnit ; }
        public void setsearchExistingGlobalBusinessUnit (String s) { this.searchExistingGlobalBusinessUnit = s; }
        Set<Id> insertSuccessId = new Set<Id>();
        Set<Id> deleteInsertSuccessId = new Set<Id>();
        Set<string> programName = new Set<string>();              
        list<String> insertedProductList= new list<String>(); 
        Public boolean ApplyProgramFlag{get;set;}
        public list<OpportunityLineItem> insertedProduct= new list<OpportunityLineItem>();
        public Opportunity opty=new Opportunity();
        public List<String> programProductAssociationIds{get;set;}
        public User partnerUser = new User();
        public User portalUser = new User();
        public List<Program_Partner_Association__c> programPatnerAssociation=  new List<Program_Partner_Association__c>();
        public List<Program_Product_Association__c> programProductAssociation=new List<Program_Product_Association__c>();
        public List<Program_Location_Association__c> programLocationAssociation;
        public boolean programVisibilityFlag{get;set;}
        public List<Campaign> eligibleProgramsList=new List<Campaign>();
        public List<string> allProductEligibleProgram=new List<string>();
        // End of the Deal Registration code
        
        //added for R4
        public wrapperLineItem OpportunityLineItemSingle{get;set;}  

        // Properties for Quick add Section
        public String searchBusinessGroup{get;set;}
        public String searchGlobalBusinessUnit{get;set;}
        public String productlinename{get;set;}
        public String subproductlinename{get;set;}
        public String hierarchyLevel{get;set;}
        public integer quantity{get;set;}
        public Integer existingrecordsize{get;set;}

        public Pricebook2 pricebook;
        public PricebookEntry pricebookentryrecord;
        public Boolean Islineiteminserted{get;set;}
        public Boolean Isiteminsertfailed{get;set;}
        public String opplineitemname{get;set;}
        public Map<String,String> gbuandbgmap{get;set;}
        public List<SelectOption>  BGPicklist{get;set;}
        public List<SelectOption> GBUPicklist{get;set;}
        public OpportunityLineItem opplineitem{get;set;}
        public String pricebookentryid{get;set;}
        public List<SelectOption>  BGPicklist1{get;set;}
        public List<SelectOption> GBUPicklist1{get;set;}
        public Map<String,List<String>> bgandgbucontrainmap{get;set;}

        public string quantityop{set;get;}
        public wrapperLineItem newlyaddedlineitem{get; set;}
        public void nextPage(){

        }
        
        public Map<String,String> BGChinesEnglistMap=new Map<String,String>();
        public Map<String,String> GBUChinesEnglistMap=new Map<String,String>();
        //R6 code for ICOEM functionality
        Decimal deleteIcoemUnitPrice;
        Decimal insertIcoemUnitPrice;
        Boolean isICOEMExist=false;
        
        //Mass bookship Date changes
        
        public String filters { get; set; }
    {
       filters = 'updateboksh';
    }
    public void setFilters(String filters) { this.Filters = filters; }
        
        public List<SelectOption> BGPicklistvalues() {
                BGPicklist=new List<SelectOption> ();
                BGPicklist.add(new SelectOption('None','--None--')); 
                String oldbg=null;               
                List<String> gbuvaluelist=new List<String>();
                List<Product2> activeBGList = new List<Product2>([Select GBU__c,Business_Group__c FROM Product2 WHERE IsActive=true and Product_Level__c=2 order by ID]);
                Set <String> bgs=new Set<String>();
                for(Product2 p : activeBGList){
                        If(p.Business_Group__c != Null){
                                //bgs.add(p.Business_Group__c);   
                                oldbg=p.Business_Group__c;
                                if(bgandgbucontrainmap.containsKey(p.Business_Group__c )){
                                        List<String> gbulist=new List<String>();
                                        gbulist=bgandgbucontrainmap.get(p.Business_Group__c);
                                        gbulist.add(p.gbu__c);                
                                        bgandgbucontrainmap.put(p.Business_Group__c,gbulist);                        
                                }
                                else{
                                        List<String> gbuvals=new List<String>();
                                        gbuvals.add(p.gbu__c);
                                        bgandgbucontrainmap.put(p.Business_Group__c,gbuvals);
                                }

                        } 
                } 
                List<Product2> activeBGList1 = new List<Product2>([Select toLabel(GBU__c),toLabel(Business_Group__c) FROM Product2 WHERE IsActive=true and Product_Level__c=2 order by ID]);
                
                for(integer i=0;i<activeBGList.size();i++){
                    BGChinesEnglistMap.put(activeBGList1[i].Business_Group__c,activeBGList[i].Business_Group__c);
    
                }
                
                for(Product2 p: activeBGList1){
                    If(p.Business_Group__c != Null){
                        bgs.add(p.Business_Group__c);
                    }
                }
                List<String> bgList = new List<String>();
                bgList.addAll(bgs);
                bgList.sort();
                system.debug('bg list '+bgs);
                for(String bg : bgList){       
                        BGPicklist.add(new SelectOption(bg, bg));
                }    
                return BGPicklist;
        }
        public void GBUPicklistvalues() {
                searchGlobalBusinessUnit=null;
                productlinename=null;
                subproductlinename=null;
                GBUPicklist=new List<SelectOption> ();        
                GBUPicklist.add(new SelectOption('None','--None--'));
                Set <String> gbus=new Set<String>();
                List<Product2> activeGBUList=new List<Product2>([Select toLabel(GBU__c),toLabel(Business_Group__c) FROM Product2 WHERE IsActive=true and Product_Level__c=2 order by ID]);
                List<Product2> activeGBUList1=new List<Product2>([Select GBU__c,Business_Group__c FROM Product2 WHERE IsActive=true and Product_Level__c=2 order by ID]);
                for(integer i=0;i<activeGBUList.size();i++){
                    GBUChinesEnglistMap.put(activeGBUList[i].GBU__c,activeGBUList1[i].GBU__c);
    
                }
               
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
        /**
         * @description: fetches restricted profiles from custom setting
         * 
         */
        public List<SelectOption> getBGPicklist1() {
                List<SelectOption> optionsBG = new List<SelectOption>();
                optionsBG.add(new SelectOption('None','--None--'));        
                List<Product2> activeBGList = new List<Product2>([Select toLabel(Business_Group__c) FROM Product2 WHERE IsActive=true and Product_Level__c=2]);
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
                        optionsBG.add(new SelectOption(bg, bg));
                }    
                return optionsBG;
        }

        public List<SelectOption> getGBUPicklist1() {
                List<SelectOption> optionsGBU = new List<SelectOption>();
                optionsGBU.add(new SelectOption('None','--None--'));
                Set <String> gbus=new Set<String>();
                for(List<Product2> actgb : [Select GBU__c FROM Product2 WHERE IsActive=true and Product_Level__c=2]){
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
                        optionsGBU.add(new SelectOption(gb, gb));
                }     
                return optionsGBU;
        }

        public Id ProductLineIsEmpty(){

                try{      
                        if(searchBusinessGroup!=null && searchBusinessGroup!='' ){
                            searchBusinessGroup=BGChinesEnglistMap.get(searchBusinessGroup);                
                        }
            
                        if(searchGlobalBusinessUnit!=null && searchGlobalBusinessUnit!='' ){
                            searchGlobalBusinessUnit=GBUChinesEnglistMap.get(searchGlobalBusinessUnit);                
                        }
                        String query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                        'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                        'Product2.Business_Group__c =\'' + searchBusinessGroup + '\' AND' +' '+  
                        'Product2.GBU__c =\'' + searchGlobalBusinessUnit+ '\' AND' +' '+                                                                                     
                        'CurrencyIsoCode = \'' + oppty.CurrencyIsoCode+ '\' AND' +' '+
                        'Pricebook2id = \'' + pricebook.id + '\' AND' +' '+ 
                        'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                        ' IsActive = true limit'+ ' ' + Label.Query_Limit;
                        system.debug('query'+query);
                        pricebookentryrecord=Database.query(query);    
                        system.debug('%%%%%%'+pricebookentryrecord);
                        if(pricebookentryrecord==null){

                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error message')); 
                                return null;
                        }
                }catch(Exception e){
                        return null;
                }
                system.debug('***'+pricebookentryid);

                return pricebookentryrecord.id;
        }
       public PageReference SaveLinteItem(){  
                //insert OpportunityLineItemSingle;
                system.debug('******************************');
                system.debug('ITEMID&&&'+(Pricebookentryid));
                Database.SaveResult[] results=null;             
                OpportunityLineItem opplineitemrecord=new OpportunityLineItem();
                try{
                        clearAllFlags();
                        List<OpportunityLineItem> linitemlist=new List<OpportunityLineItem>();
                        system.debug('testing-outside');
                           

                        if(oppty.Deal_Registration_Status__c =='Approved'||oppty.Deal_Registration_Status__c =='Rejected'||oppty.Deal_Registration_Status__c =='Submitted' || oppty.Deal_Registration_Status__c =='Review Initiated'){

                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.DEAL_UNDER_PROGRESS)); 

                        }else{
                                if(productlinename==null||productlinename==''){

                                        opplineitem.Pricebookentryid=ProductLineIsEmpty();
                                }       
                                opplineitem.OpportunityId=oppid;     
                                opplineitem.Quantity=quantity;
                                linitemlist.add(opplineitem);   

                                if(opplineitem.pricebookEntryId ==Null || searchGlobalBusinessUnit ==Null || searchBusinessGroup==Null || quantity==Null || opplineitem.UnitPrice==Null || opplineitem.ServiceDate==Null){
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Blank_product_service_save));  
                                        return null;
                                }  
                                 if(opplineitem.Servicedate<oppty.closedate){
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Ship_Date_Error));  
                                        return null;
                                } 
                                 
                                 
                                results = database.insert(linitemlist);
                                if(results[0].isSuccess()){
                                        Islineiteminserted=true;
                                        quantity=1;
                                        opplineitemrecord=[select Product_Line__c,GBU__c,PricebookEntry.Product2.Name, First_Fiscal_Year_Value__c, First_12_Month_Value__c, PricebookEntry.Product2.Service__c, PricebookEntry.Product2.Business_Group__c,PricebookEntry.Product2.GBU__c,UnitPrice,Margin_Amount__c, Attach__c, PricebookEntry.Product2.Product_Line__c, PricebookEntry.Product2.Sub_Product_Line__c, ServiceDate, Quantity, opportunityid, PricebookEntry.Name, opportunity.name, subtotal, TotalPrice,Contract__c, Opportunity_Close_Date__c, Start_Date__c, End_Date__c, keep__c,HasSchedule, RTS_Component__c, Win_Back__c, RTS__c,FFYR_Margin_Amount__c,ProductName__c,Scope_Type__c  from OpportunityLineItem where id=:results[0].Id];
                                        newlyaddedlineitem=new wrapperLineItem(opplineitemrecord,opplineitemrecord.PricebookEntry.Product2.Name,opplineitemrecord.PricebookEntry.Product2.Business_Group__c,opplineitemrecord.PricebookEntry.Product2.GBU__c,opplineitemrecord.PricebookEntry.Product2.Product_Line__c,opplineitemrecord.PricebookEntry.Product2.Sub_Product_Line__c,opplineitemrecord.PricebookEntry.Product2.Service__c,bgandgbucontrainmap,null,null);

                                        if(opplineitemrecord.product_line__c!=null&&opplineitemrecord.product_line__c!=''){
                                                opplineitemname=opplineitemrecord.product_line__c;
                                        }else if(opplineitemrecord.GBU__c!=null&&opplineitemrecord.GBU__c!=''){
                                                opplineitemname=opplineitemrecord.GBU__c;
                                        }

                                }else{
                                        Isiteminsertfailed=true;
                                }
                           system.debug('ITEMID&&& 1: '+(Pricebookentryid));
                           //R6 code for ICOEM functionality added by Praveen Kumar Reddy  
                                 if(opplineitem.ICOEM__c==true && Islineiteminserted==true){
                                   
                                    opportunityLineItem ioceLineItem ;
                                    try{
                                        ioceLineItem=new opportunityLineItem ();
                                        ioceLineItem=[select id,ICOEM__c,quantity,PricebookEntry.Product2.Name,subtotal,UnitPrice,PricebookEntry.Product2.Business_Group__c,PricebookEntry.Product2.GBU__c,PricebookEntry.Product2.Product_Line__c,PricebookEntry.Product2.Sub_Product_Line__c,PricebookEntry.Product2.Service__c,ProductName__c,Scope_Type__c  from OpportunityLineItem where opportunityID= :oppid and  PricebookEntry.Product2.Name='1052 - Outside Segment Elimination Entrepreneur' ];
                                    }catch(Exception e){ioceLineItem=null;}
                                    if(ioceLineItem !=null ){
                                        ioceLineItem.UnitPrice=ioceLineItem.UnitPrice-(opplineitem.unitprice * opplineitem.quantity);
                                        ioceLineItem.servicedate=opty.CloseDate;
                                        update ioceLineItem;
                                    }else{
                                        ioceLineItem=new opportunityLineItem ();
                                        PriceBookEntry pbe=new PriceBookEntry();
                                        try{
                                        pbe=[select id,name,PricebookEntry.Product2.Business_Group__c,PricebookEntry.Product2.GBU__c,PricebookEntry.Product2.Product_Line__c,PricebookEntry.Product2.Sub_Product_Line__c,PricebookEntry.Product2.Service__c from PriceBookEntry where PriceBookEntry.product2.name='1052 - Outside Segment Elimination Entrepreneur' and CurrencyIsoCode = :opty.CurrencyIsoCode and PricebookEntry.Product2.product_level__c=5 and pricebook2ID = :pricebook.id  limit 1];
                                        }catch(Exception e){
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'1052 - Outside Segment Elimination Entrepreneur pricebooke entry doesnt exist'));
                                            return null;
                                        }
                                        ioceLineItem=new opportunityLineItem(opportunityId=oppid,Pricebookentryid=pbe.id,Quantity=opplineitem.Quantity,UnitPrice=-opplineitem.unitprice,servicedate=opplineitem.servicedate);
                                        insert ioceLineItem;
                                        
                                    
                                    } 
                                    newlyaddedlineitem=new wrapperLineItem(ioceLineItem,ioceLineItem.PricebookEntry.Product2.Name,ioceLineItem.PricebookEntry.Product2.Business_Group__c,ioceLineItem.PricebookEntry.Product2.GBU__c,ioceLineItem.PricebookEntry.Product2.Product_Line__c,ioceLineItem.PricebookEntry.Product2.Sub_Product_Line__c,ioceLineItem.PricebookEntry.Product2.Service__c,null,null,null);
                                 } 
                        }
                }catch(System.DmlException dmlEx){
                  CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity Product', 'ProductsAndServicesController', 'Class');
                    for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                       Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                       isInsertFailureFlag = true;
                    system.debug('***************messagefor com-subproductline'+dmlEx.getDmlMessage(i));
                    
                    }
                return null;
                }
                 
                // Below piece of code added for R5 - display warning message if BG/GBU is not from the given list
                
                TSAttachBgGbuList__c BG_GBUList1 = TSAttachBgGbuList__c.getInstance('First');
                TSAttachBgGbuList__c BG_GBUList2 = TSAttachBgGbuList__c.getInstance('Second');
                
                if (opplineitemrecord.PricebookEntry.Product2.Business_Group__c == BG_GBUList1.BG__c && Islineiteminserted==true)
                {
                    if (!(opplineitemrecord.PricebookEntry.Product2.GBU__c == BG_GBUList1.GBU__c ||
                          opplineitemrecord.PricebookEntry.Product2.GBU__c == BG_GBUList2.GBU__c) )
                    {
                        TSAttachwarninglink__c TSlink1 = TSAttachwarninglink__c.getInstance('1');
                        TSAttachwarninglink__c TSlink2 = TSAttachwarninglink__c.getInstance('2');
                                                
                        String BG_GBUmsg=''+system.label.TSAttach_warning_msg+'<br /><a href="'+TSlink1.URL__c+'" target="_blank">'+TSlink1.Display_name__c+'</a>and the<a href="'+TSlink2.URL__c+'" target="_blank">'+TSlink2.Display_name__c+'</a>';
                        ApexPages.Message Apexmsg=new  ApexPages.Message(ApexPages.Severity.WARNING,BG_GBUmsg);
                        ApexPages.addmessage(Apexmsg);  
                    }
                }
                
                // R4 code Added for Apply Program Button 
                system.debug('ITEMID0&&&'+(opplineitem.Pricebookentryid));
                if(results.size()>0 && portalUser.isPortalEnabled){
                        insertedProduct= [Select product_line__c from OpportunityLineItem where Id =:results[0].Id]; 
                        for(OpportunityLineItem opptyLineItem:insertedProduct){
                                insertedProductList.add(opptyLineItem.product_line__c);
                        }
                        programProductAssociation=[select program__r.name from Program_Product_Association__c where product__r.product_line__c IN :insertedProductList]; 
                        for(Program_Product_Association__c  P: programProductAssociation){
                                programName.add(P.program__r.name);
                        }      
                        partnerUser =[Select Partner_account_ID__c,isPortalEnabled,Location_Record_Id__c from User where Id= :UserInfo.getUserId()]; 
                        programLocationAssociation =[Select program__r.name,Program__r.isActive from Program_Location_Association__c where Location__c=:partnerUser.Location_Record_Id__c ];
                        eligibleProgramsList=new List<Campaign>();
                        allProductEligibleProgram=new List<string>();
                        for(Program_Location_Association__c progPatrner:programLocationAssociation){
                                allProductEligibleProgram.add(progPatrner.Program__r.name);
                        }
                        eligibleProgramsList=[Select All_Products_Eligible__c from Campaign where IsActive=True and All_Products_Eligible__c='Yes' and name in:allProductEligibleProgram ];
                        if(eligibleProgramsList.size()>0 && opplineitemrecord.product_line__c!=null){
                                programVisibilityFlag=True;
                        }else{

                                for(Program_Location_Association__c progPartnerMap: programLocationAssociation ){ 

                                        if(progPartnerMap.program__r.IsActive==true){
                                                programVisibilityFlag = programName.contains(progPartnerMap.program__r.name);
                                                if(programVisibilityFlag==True){
                                                        break;
                                                }
                                        }                         
                                }    
                        }
                        set<id> existingLineItemsIds=new set<id>();
                        if(programVisibilityFlag!=True){
                                for(OpportunityLineItem existingLineItems:[select id from OpportunityLineItem where opportunityId=:oppId and product_line__c!=null]){
                                        existingLineItemsIds.add(existingLineItems.Id);
                                }
                                if(existingLineItemsIds.size()>0){
                                        ApplyProgramVisiblityForSave(existingLineItemsIds);
                                }
                        }
                }
                system.debug('ITEMID&&& 2: '+(Pricebookentryid));
                Clearquickaddsection();          
                oppty = fetchOpptyStatistics();
                opplineitem=new OpportunityLineItem();
                opplineitem.ServiceDate=oppty.Closedate;
                selectedPage = 1;
                selectedPageMore = 0;
                GBUPicklistvalues();
                system.debug('ITEMID&&& 3: '+(Pricebookentryid));
                return null;

        }
        private Static Set<Id> getRestrictedProfileSet(){
                Set<Id> restrictedProfilesSet = new Set<Id>();
                Map<String,Admin_Profiles__c> adminProfilesMap = Admin_Profiles__c.getAll();
                for(Admin_Profiles__c prof : adminProfilesMap.values()){
                        if(prof.Module__c!=null){
                                if(prof.Module__c.equalsIgnoreCase(Label.Opty_Update_Restricted_Profile)){
                                        if(prof.Profile_ID__c!=null){
                                                restrictedProfilesSet.add(convertTo15Digit(prof.Profile_ID__c));
                                        }
                                }
                        }
                }
                return restrictedProfilesSet;
        }
        /**
         * @description: Converts Id longer than 15 characters
         *               to 15 character Id
         * 
         */
        private Static String convertTo15Digit(String paramID){
                try{
                        if(paramID.length()>15){
                                paramID = paramID.substring(0,15);
                        }
                }catch(Exception e){
                }
                return paramID;
        }
        /**
         * @description: Only Let the user with R/W access to Opportunity to Modify Products & Services
         * 
         * 
         */
        public void opptyAccess(){
                String result = CheckOptyAccess.checkOptyEditAccess(oppty.Id);
                if (result == Label.FAIL){
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'You do not have permission to modify Products & Services.')); 
                        noAccessFlag = true;
                } else {
                        restrictedSet = new Set<Id>();
                        restrictedSet = getRestrictedProfileSet();
                        String currentProfileId = convertTo15Digit(Userinfo.getProfileId());
                        if(restrictedSet.contains(currentProfileId)){
                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'You do not have permission to modify Products & Services.')); 
                                noAccessFlag = true;
                        }

                }
                //String qry = Label.Existing_Line_Items_Query + '\'' + oppId + '\' order by '+ sortFullExp;
        }

        /**
         * @description: Sort dynamically by generating query
         * 
         * 
         */
        public void viewData(){
                sortFullExp = sortExpression  + ' ' + sortDirection;
                generateQuery();
                //String qry = Label.Existing_Line_Items_Query + '\'' + oppId + '\' order by '+ sortFullExp;
        }

        /**
         * @description: sort Expression from VF Page
         * @return: expression on which sorting is to be done
         * 
         */
        public String sortExpression{
                get{
                        return sortExp;
                }
                set{
                        //if the column is clicked on then switch between Ascending and Descending modes
                        if (value == sortExp){
                                sortDirection = (sortDirection == Label.ASC)? Label.DESC : Label.ASC;
                        }
                        else{
                                sortDirection = Label.ASC;
                        }
                        sortExp = value;
                }
        }

        /**
         * @description: Sort Direction getter
         * @return: Direction Ascending or decending
         * 
         */
        public String getSortDirection(){
                //if not column is selected 
                if (sortExpression == null || sortExpression == ''){
                        return Label.ASC;
                }
                else{
                        return sortDirection;
                }
        }

        /**
         * @description: Sort Direction settter
         * 
         * 
         */
        public void setSortDirection(String value){  
                sortDirection = value;
        }

        public ProductsAndServicesControllerNew () {

                oppId = ApexPages.currentPage().getParameters().get('id'); 
                oppty = fetchOpptyStatistics();      
        }


        /**
         * @description: Class Constructor method
         * @param StandardController Apex Page
         * 
         */
        public ProductsAndServicesControllerNew (ApexPages.StandardController controller) {

                showRetain = true;
                objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
                if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.Restrict_Sync_Functionality).contains(objUser.Business_Group__c+':'+objUser.Region__c)){
                        showRetain=false;

                }

                showAdd = ApexPages.currentPage().getParameters().get('addProd');
                if(showAdd == 'true')
                {       
                        isAddProd = 'background-color:#E6E6FA';
                }
                oppId = ApexPages.currentPage().getParameters().get('oppId');
                RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId(); 
                partnerUser =[Select Partner_account_ID__c,Location_Record_Id__c,IsportalEnabled from User where Id= :UserInfo.getUserId()];   
                opty = [select CloseDate,ownerid,Business_Group2__c from Opportunity where id=:oppId];  
                portalUser=[select isPortalEnabled,Partner_account_Id__c from User where id=:opty.ownerId]; 
                convertCurrencyFlag = false;
                tableWidth = 1285;
                oppty = fetchOpptyStatistics();
                system.debug('%%%'+oppty);
                opptyCloseDate = oppty.CloseDate.format();
                testOpptyProduct = new OpportunityLineItem();
                allProductsFlag = true;
                existingProductsFilterFlag = true;
                collapsibleFlag = true;
                noResultsFlag = false;
                largeResultFlag = false;
                noAccessFlag = false;
                masterCheckboxFlag = false;
                EsSpecificFlag = false;
                RTSSpecificFlag = false;
                action = 'View';
                action0 = 'View';
                navigationFlag = true;
                selectedPage = 1;
                selectedPageMore =0;
                cancelUpdate();
                recordTypeFlag();
                applyProgramVisibility();
                RTSSpecificFlag=false;
                isWarnBookShipDateChange =False;
                listEditBookshipdate = new List<string>();
                


                //Added for Quick add functionality
                pricebook= [SELECT Id, Name, IsActive From Pricebook2 WHERE Name = 'Products & Services' AND IsActive = true];
                bgandgbucontrainmap=new Map<String,List<String>>();
                gbuandbgmap=new  Map<String,String>();
                opplineitem=new OpportunityLineItem();
                hierarchyLevel='2';
                quantity=1;
                BGPicklistvalues();
                GBUPicklistvalues();
                opplineitem.ServiceDate=oppty.Closedate;

                //Quick Add section instatiation ends here

                List<Opportunity> o=[Select id, Renewal_Type__C From Opportunity Where id=:oppId];

                if(o[0].Renewal_Type__c== 'SW Renewal'){
                        collapsibleFlag0 = true;
                }

                else{
                        collapsibleFlag0 = false;
                }

                if (objUser.business_group__c == 'ES'){
                        displayEsInfo();
                }
             inactiveMeth();   
                
        }

        /**
         * @description: Applying programs for the selected products if the user is eligible. 
         * @return: page is returned to DealReg_AddPromotionForProduct
         * 
         */
        public PageReference applyPrograms(){  
                if(opty.CloseDate < System.today()){
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Opportunity Close date in the past, program cannot be applied'));
                        return null;
                }else{     
                        Opportunity optylists = new Opportunity();      
                        optylists= [select Deal_Registration_Status__c from Opportunity where id=:oppId];
                        opportunityLineItemList= [Select UnitPrice from OpportunityLineItem where OpportunityId= :oppId ];  
                        if(optylists.Deal_Registration_Status__c =='Submitted' || optylists.Deal_Registration_Status__c =='Review Initiated'){
                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.DEAL_UNDER_PROGRESS)); 
                                return null;
                        }else{
                                Pagereference pageRef=new Pagereference('/apex/DealReg_AddPromotionForProduct?id='+oppId);
                                pageRef.setRedirect(true);
                                return pageRef;
                        }  
                }      
                return null;        
        } 

       /**
         * @description: Program visibility depending on the selected product and logged user.
         *   
         * 
         */
         public void applyProgramVisibility(){ 

                programLocationAssociation=  new List<Program_Location_Association__c>();
                programProductAssociationIds=new List<String>();
                programProductAssociation=new list<Program_Product_Association__c>();
                Profile profileName = [SELECT Name FROM Profile WHERE Id = :Userinfo.getProfileId()];
                if(partnerUser.isPortalEnabled && portalUser.isPortalEnabled){          
                        programLocationAssociation=[Select  Program__c, Program__r.name,Program__r.isActive  from Program_Location_Association__c where Location__c=:partnerUser.Location_Record_Id__c];               
                        try{           
                                for(OpportunityLineItem opptyProduct:[Select product_line__c from OpportunityLineItem where OpportunityId=:oppId]){
                                        if(opptyProduct.product_line__c!=null){
                                                programProductAssociationIds.add(opptyProduct.product_line__c );   
                                        }     
                                }
                                programProductAssociation=[select program__r.name from Program_Product_Association__c where Product__r.product_line__c IN :programProductAssociationIds]; 
                                Set<string> programName = new Set<string>();
                                for(Program_Product_Association__c  programProduct: programProductAssociation){
                                        programName.add(programProduct.program__r.name);
                                }  

                                for(Program_Location_Association__c programPartner: programLocationAssociation ){
                                        if(programPartner.program__r.isActive==true){
                                                programVisibilityFlag = programName.contains(programPartner.program__r.name);          
                                                if(programVisibilityFlag==true){
                                                        break;                   
                                                }
                                        }
                                }
                                if(programProductAssociationIds.size()!=0){
                                        eligibleProgramsList=new List<Campaign>();
                                        allProductEligibleProgram=new List<string>();
                                        for(Program_Location_Association__c pPatrner:programLocationAssociation){
                                                allProductEligibleProgram.add(pPatrner.Program__r.name);
                                        }
                                        eligibleProgramsList=[Select All_Products_Eligible__c from Campaign where IsActive=true and name in:allProductEligibleProgram];            
                                        for(Campaign programForPartner:eligibleProgramsList){
                                                if(programForpartner.All_Products_Eligible__c=='Yes'){
                                                        programVisibilityFlag=True;
                                                        break;
                                                }
                                        }  
                                }else{
                                        programVisibilityFlag=False;
                                }
                        }catch(Exception e){
                                System.debug('Exception occured while products do not have programs........');
                        }     
                }  
        }

        /**
         * @description:  To get all Picklist values of Business Group on Product
         * @return: List of Picklist values
         * 
         */
        public List<SelectOption> getBGPicklistExist() {
                List<SelectOption> optionsBG = new List<SelectOption>();
                optionsBG.add(new SelectOption('None','--None--'));
                List<OpportunityLineItem> allLineItems = new List<OpportunityLineItem>();
                Set<String> allBG = new Set<String>();
                allLineItems = [Select Id,PricebookEntry.Product2.Business_Group__c, PricebookEntry.Product2.GBU__c from OpportunityLineItem where OpportunityId =: oppId]; 
                for(OpportunityLineItem i: allLineItems ){
                        allBG.add(i.PricebookEntry.Product2.Business_Group__c);   
                }
                for (String bg: allBG){
                        if (bg!= null){
                                optionsBG.add(new SelectOption(bg,bg)); 
                        }    
                }
                return optionsBG;
        }
        /**
         * @description:  To get all Picklist values of Business Group on Product
         * @return: List of Picklist values
         * 
         */
        /*
    public List<SelectOption> getProgramPicklist() {
        List<SelectOption> optionsBG = new List<SelectOption>();
        optionsBG.add(new SelectOption('None','--None--'));
        List<Campaign> allLineItems = new List<Campaign>();
        Set<String> allBG = new Set<String>();
        allLineItems = [Select Id, Campaign.Name from Campaign where Campaign.Sub_Business_Unit__c=:searchExistingBusinessGroup]; 
        for(Campaign i: allLineItems ){
            allBG.add(i.Name);   
        }
        for (String bg: allBG){
            if (bg!= null){
                optionsBG.add(new SelectOption(bg,bg)); 
            }    
        }
        return optionsBG;
    }
         */
        /**
         * @description:  To get all Picklist values of Global Business Unit on Product
         * @return: List of Picklist values
         * 
         */
        public List<SelectOption> getGBUPicklistExist() {
                List<SelectOption> optionsGBU = new List<SelectOption>();
                optionsGBU.add(new SelectOption('None','--None--'));
                List<OpportunityLineItem> allLineItems = new List<OpportunityLineItem>();
                Set<String> allGBU = new Set<String>();
                if(searchExistingBusinessGroup != null && searchExistingBusinessGroup!='None')
                        allLineItems = [Select Id, PricebookEntry.Product2.Business_Group__c, PricebookEntry.Product2.GBU__c from OpportunityLineItem where OpportunityId =: oppId and business_group__c= :searchExistingBusinessGroup]; 
                else{
                        allLineItems = [Select Id, PricebookEntry.Product2.Business_Group__c, PricebookEntry.Product2.GBU__c from OpportunityLineItem where OpportunityId =: oppId]; 
                }
                for(OpportunityLineItem i: allLineItems ){
                        allGBU.add(i.PricebookEntry.Product2.GBU__c);   
                }
                for (String gbu: allGBU){
                        if (gbu!= null){
                                optionsGBU.add(new SelectOption(gbu,gbu)); 
                        }    
                }
                return optionsGBU;
        }


        /**
         * @description:  To check the recordtype id of the Opportunity
         * @return: void method
         * @Created for CR-0139 - Stop SAP Functionality for RENEWALS  - 10th Aug 2012 
         */
        public void recordTypeFlag(){
                if(oppty.RecordtypeId == RecordTypeId){
                        IsRecordType = true;
                }else{
                        IsRecordType = false;
                }       
        }     
        /**
         * @description:  To get new statistics on Opportunity after Line Items Update
         * @return: Opportunity
         * 
         */
        public Opportunity fetchOpptyStatistics() {

                Opportunity op;
                try{
                op = [Select Name, Id, SW_Premier__c, Account.Name, Opportunity_ID__c, Deal_Registration_Status__c, CloseDate, StageName, Total_First_12_Month_Value__c,  CurrencyIsoCode, Total_First_Fiscal_Yr_Value__c, Total_Margin_Amount__c,Total_Margin_Percentage__c, Amount, RecordtypeId, SAP_Feed__c,Business_Group2__c from Opportunity where id =: oppId];
                activeUser = [Select Name, Id, CurrencyIsoCode,Global_Business_Unit__c, DefaultCurrencyIsoCode from User where Id=: userinfo.getuserid()];
                if (activeUser.DefaultCurrencyIsoCode != op.CurrencyIsoCode){
                        opp = [Select Name, Id, CloseDate, StageName, ConvertCurrency(Total_First_12_Month_Value__c),  CurrencyIsoCode, ConvertCurrency(Total_First_Fiscal_Yr_Value__c), ConvertCurrency(Total_Margin_Amount__c), Total_Margin_Percentage__c, ConvertCurrency(Amount), RecordtypeId, SAP_Feed__c from Opportunity where id =: oppId];
                        convertCurrencyFlag = true;
                }
                }Catch(Exception e){}
                return op;   
        }
        /**
         * @description:  To get new statistics on Opportunity after Line Items Delete
         * @return: Opportunity
         * 
         */
        public PageReference newOpptyStatistics() {
                oppty = fetchOpptyStatistics();
                return null;
        }
        /**
         * @description:  To generate Query for displaying only seached line items on the Page
         * @return: String
         * 
         */
        public void generateQuery() {
                masterCheckboxFlag = false;
                if(searchExistingBusinessGroup!= '' && searchExistingBusinessGroup!= null && searchExistingBusinessGroup!= 'None'){
                        if (searchExistingGlobalBusinessUnit!= '' && searchExistingGlobalBusinessUnit!= null && searchExistingGlobalBusinessUnit!= 'None' && searchExistingProductLine!= '' && searchExistingProductLine!= null && searchExistingSubProductLine!= '' && searchExistingSubProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%\' order by '+ sortFullExp +'';
                                } else{
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%' +'\'';
                                }
                        }
                        else if (searchExistingGlobalBusinessUnit!= '' && searchExistingGlobalBusinessUnit!= null && searchExistingGlobalBusinessUnit!= 'None' && searchExistingProductLine!= '' && searchExistingProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%\' order by '+ sortFullExp +'';
                                } else{
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%' +'\'';
                                }
                        }           
                        else if (searchExistingGlobalBusinessUnit!= '' && searchExistingGlobalBusinessUnit!= null && searchExistingGlobalBusinessUnit!= 'None' && searchExistingSubProductLine!= '' && searchExistingSubProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%\' order by '+ sortFullExp +'';
                                } else {
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%' +'\'';
                                }
                        }
                        else if (searchExistingProductLine!= '' && searchExistingProductLine!= null && searchExistingSubProductLine!= '' && searchExistingSubProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%\' order by '+ sortFullExp +'';
                                } else {
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%' +'\'';
                                }
                        }
                        else if (searchExistingGlobalBusinessUnit!= '' && searchExistingGlobalBusinessUnit!= null && searchExistingGlobalBusinessUnit!= 'None'){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%\' order by '+ sortFullExp +'';
                                } else {
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%' +'\'';
                                }               
                        }
                        else if (searchExistingProductLine!= '' && searchExistingProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%\' order by '+ sortFullExp +'';
                                } else {
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%' +'\'';
                                }
                        }
                        else if (searchExistingSubProductLine!= '' && searchExistingSubProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\''  + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine + '%\' order by '+ sortFullExp +'';
                                } else {
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\''  + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' AND' +' '+ 
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine + '%' +'\'';
                                }
                        } else {
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '\' order by '+ sortFullExp +'';
                                } else {
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Business_Group__c =\'' + searchExistingBusinessGroup + '' + '\'';
                                }        
                        }
                } 
                else if(searchExistingGlobalBusinessUnit!= '' && searchExistingGlobalBusinessUnit!= null && searchExistingGlobalBusinessUnit!= 'None') {
                        if (searchExistingProductLine!= '' && searchExistingProductLine!= null && searchExistingSubProductLine!= '' && searchExistingSubProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%\' order by '+ sortFullExp +'';
                                } else {
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%\' AND' +' '+
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%' +'\'';
                                }
                        }
                        else if (searchExistingProductLine!= '' && searchExistingProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%\' order by '+ sortFullExp +'';
                                } else {
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%' +'\'';
                                }
                        }
                        else if (searchExistingSubProductLine!= '' && searchExistingSubProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%\' order by '+ sortFullExp +'';
                                } else{
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%' +'\'';
                                }
                        } else {
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%\' order by '+ sortFullExp +'';
                                } else{
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.GBU__c like \'' + '%' + searchExistingGlobalBusinessUnit+ '%' +'\'';
                                }
                        }       
                } 
                else if(searchExistingProductLine!= '' && searchExistingProductLine!= null) {
                        if (searchExistingSubProductLine!= '' && searchExistingSubProductLine!= null){
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%\' order by '+ sortFullExp +'';
                                } else {
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine + '%\' AND' +' '+ 
                                        'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%' +'\'';
                                }
                        } else {
                                if (sortFullExp!= ''){
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%\' order by '+ sortFullExp +'';
                                } else{
                                        existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                        'PricebookEntry.Product2.Product_Line__c like \'' + '%' + searchExistingProductLine+ '%' +'\'';
                                }
                        } 
                } 
                else if(searchExistingSubProductLine!= '' && searchExistingSubProductLine!= null) {
                        if (sortFullExp!= ''){
                                existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%\' order by '+ sortFullExp +'';
                        } else{
                                existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' AND' +' '+
                                'PricebookEntry.Product2.Sub_Product_Line__c like \'' + '%' + searchExistingSubProductLine+ '%' +'\'';
                        }
                }
                else{
                        if (sortFullExp!= ''){
                                existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId + '\' order by '+ sortFullExp +'';
                        }else {
                                existingProductsQuery = Label.Existing_Line_Items_Query + '\'' + oppId +'\'';
                        }
                }
                system.debug('>>>>>>>existingProductsQuery '+existingProductsQuery );

        }
        /**
         * @description:  To display line items and additional binding fields of Wrapper on Page
         * @return: List of wrapper items
         * 
         */
         //R6 code for Inactive Warning message functionality added by Sudhakar Reddy 
         public void inactiveMeth(){
         existingProductsQuery ='';
              generateQuery();
              isInactvieProduct=false;
         try{
             for(OpportunityLineItem li : Database.query(existingProductsQuery)) {
              if(li.PricebookEntry.isActive!=true){
                        isInactvieProduct=true;                  
                    }
                                
                    }
                        }Catch(Exception exp){
                                system.debug('Exception Occured while fetching Line Items: '+exp.getMessage());
                        }            
         
         }
         //End R6 code for Inactive Warning message functionality
        public Map<Integer, List<wrapperLineItem>> getOpportunityLineItems() {

                inactiveMeth();
                navigationFlag = true;
                largeResultFlag = false;
                masterCheckboxFlag = false;
                existingLineItemList = new List<wrapperLineItem>();
                if(existingLineItemList != null){
                        List<wrapperLineItem> blankLineItemList = new List<wrapperLineItem>();
                        existingProductsQuery ='';
                        generateQuery();  
                        mapOpportunityLineItems =new Map<Integer, List<wrapperLineItem>> ();
                        noOfRecordPerPage = 15;
                        noOfRecordPerPageMore = 25; 
                        /*Append Blank row above*/    
                        if(newLineItemList != null){
                                existingLineItemList.addAll(newLineItemList);
                        }
                        system.debug('>>>>>>>EXISTINGLIST'+newLineItemList);
                        /*Display Line Items*/ 
                        
                        //R6 code for Inactive Image functionality added by Sudhakar Reddy    
                        try{
                            system.debug('query exit '+ existingProductsQuery);
                                for(OpportunityLineItem li : Database.query(existingProductsQuery)) {
                                    system.debug('@@@@@@@@@@@  '+li.PricebookEntry.Product2.Product_Level__c);
                                        if(li.PricebookEntry.isActive==true){
                                        existingLineItemList.add(new wrapperLineItem(li,li.PricebookEntry.Product2.Name,li.PricebookEntry.Product2.Business_Group__c,li.PricebookEntry.Product2.GBU__c,
                                                        li.PricebookEntry.Product2.Product_Line__c,li.PricebookEntry.Product2.Sub_Product_Line__c,li.PricebookEntry.Product2.Service__c,bgandgbucontrainmap,true,string.valueOf(li.PricebookEntry.Product2.Product_Level__c)));
                                           if(isInactvieProduct!=true)            
                                            isInactvieProduct=false;       
                                       } else{
                                            existingLineItemList.add(new wrapperLineItem(li,li.PricebookEntry.Product2.Name,li.PricebookEntry.Product2.Business_Group__c,li.PricebookEntry.Product2.GBU__c,
                                                        li.PricebookEntry.Product2.Product_Line__c,li.PricebookEntry.Product2.Sub_Product_Line__c,li.PricebookEntry.Product2.Service__c,bgandgbucontrainmap,false,string.valueOf(li.PricebookEntry.Product2.Product_Level__c)));
                                          isInactvieProduct=true;              
                                        }
                                }
                        }Catch(Exception exp){
                                system.debug('Exception Occured while fetching Line Items: '+exp.getMessage());
                        }                    
                          //End R6 code for Inactive Image functionality
                        if (existingLineItemList.size() == 0){
                                selectedPage = 1;
                                selectedPageMore = 0;
                                mapOpportunityLineItems.put(1, blankLineItemList);
                                noResultsFlag = true;
                        }else{
                                noResultsFlag = false;
                        }
                        /*keep Unprocessed line items checked*/
                        for (wrapperLineItem w: existingLineItemList){
                                if(lineitemIds.contains(w.oli.Id)|| pendingLineitemIds.contains(w.oli.Id)){
                                        w.Selected = true;
                                }
                        }
                }
                /*Paginating all the Opportunity Line Items*/
                
                if(existingLineItemList.size()>0){
                          system.debug('*********selectedPageMore********'+selectedPageMore);
                          if(selectedPageMore == 0 || selectedPageMore ==null)
                          {
                          selectedPageMore = 15;
                          }
                        pagesOptionsforMoreRecords = new List<SelectOption>();
                               
                        system.debug('*********selectedPageMore********'+selectedPageMore);
                        integer noOfRecordPerPageMore = 15;
                        
                        while(true){                               
                                
                                pagesOptionsforMoreRecords.add(new SelectOption(noOfRecordPerPageMore+'',noOfRecordPerPageMore +''));
                                if(noOfRecordPerPageMore >= existingLineItemList.size())
                                {
                                break;
                                }
                                if(noOfRecordPerPageMore == 15)
                                {
                                noOfRecordPerPageMore = 50;
                                }
                                else
                                {
                                noOfRecordPerPageMore = noOfRecordPerPageMore + 50;
                                }
                                
                                
                       }
                       }
                
                
                if(existingLineItemList.size()>0){
                        pagesOptions = new List<SelectOption>();
                        integer total_no_of_pages = existingLineItemList.size()/selectedPageMore;                 
                        if(math.mod(existingLineItemList.size(),selectedPageMore) > 0){
                                total_no_of_pages = total_no_of_pages +1;
                        }
                        if(newLineItemList != null){
                                if (newLineItemList.size()>0){
                                        navigationFlag = false;
                                        selectedPage = 1;
                                        
                                }
                        }
                        if(selectedPage > total_no_of_pages){
                                selectedPage = total_no_of_pages;    
                        }
                        integer pageStartValue = 0;
                        integer pageEndValue = selectedPageMore;
                        List<wrapperLineItem> AllopportunityLineItemList;
                        if(newlyaddedlineitem!=null ){
                        OpportunityLineItem opplineitemrecordsingle=[select Product_Line__c,GBU__c,ICOEM__c,PricebookEntry.Product2.Name,PricebookEntry.isActive,PricebookEntry.Product2.Product_Level__c, First_Fiscal_Year_Value__c, First_12_Month_Value__c, PricebookEntry.Product2.Service__c, PricebookEntry.Product2.Business_Group__c,PricebookEntry.Product2.GBU__c,UnitPrice,Margin_Amount__c, Attach__c, PricebookEntry.Product2.Product_Line__c, PricebookEntry.Product2.Sub_Product_Line__c, ServiceDate, Quantity, opportunityid, PricebookEntry.Name, opportunity.name, subtotal, TotalPrice,Contract__c, Opportunity_Close_Date__c, Start_Date__c, End_Date__c, keep__c,HasSchedule, RTS_Component__c, Win_Back__c, RTS__c,FFYR_Margin_Amount__c,ProductName__c,Scope_Type__c  from OpportunityLineItem where id=:newlyaddedlineitem.oli.Id];
                        if(opplineitemrecordsingle.PricebookEntry.isActive==true){                           
                        newlyaddedlineitem=new wrapperLineItem(opplineitemrecordsingle,opplineitemrecordsingle.PricebookEntry.Product2.Name,opplineitemrecordsingle.PricebookEntry.Product2.Business_Group__c,opplineitemrecordsingle.PricebookEntry.Product2.GBU__c,opplineitemrecordsingle.PricebookEntry.Product2.Product_Line__c,opplineitemrecordsingle.PricebookEntry.Product2.Sub_Product_Line__c,opplineitemrecordsingle.PricebookEntry.Product2.Service__c,bgandgbucontrainmap,true,string.valueOf(opplineitemrecordsingle.PricebookEntry.Product2.Product_Level__c));
                        }else{
                        newlyaddedlineitem=new wrapperLineItem(opplineitemrecordsingle,opplineitemrecordsingle.PricebookEntry.Product2.Name,opplineitemrecordsingle.PricebookEntry.Product2.Business_Group__c,opplineitemrecordsingle.PricebookEntry.Product2.GBU__c,opplineitemrecordsingle.PricebookEntry.Product2.Product_Line__c,opplineitemrecordsingle.PricebookEntry.Product2.Sub_Product_Line__c,opplineitemrecordsingle.PricebookEntry.Product2.Service__c,bgandgbucontrainmap,false,string.valueOf(opplineitemrecordsingle.PricebookEntry.Product2.Product_Level__c));
                        }
                        AllopportunityLineItemList=new wrapperLineItem[]{newlyaddedlineitem};  
                        for(Integer z=0;z<existingLineItemList.size();z++){
                                if(existingLineItemList[z].oli.id==newlyaddedlineitem.oli.id){ 
                                    existingLineItemList.remove(z);
                                }   
                              }
                          AllopportunityLineItemList.addall(existingLineItemList);
                          existingLineItemList.clear();
                          existingLineItemList.addall(AllopportunityLineItemList);
                        }else{
                            AllopportunityLineItemList=new wrapperLineItem[]{};   
                            AllopportunityLineItemList.addall(existingLineItemList);
                            existingLineItemList.clear();
                            existingLineItemList.addall(AllopportunityLineItemList);    
                        }
                        for(integer i = 0; i<total_no_of_pages ; i++){
                                integer counter = i+1;
                                pagesOptions.add(new SelectOption(counter+'',counter +''));
                                List<wrapperLineItem> OpportunityLineItemList = new List<wrapperLineItem>();
                                for(integer j = pageStartValue ; j< pageEndValue; j++){
                                        try{
                                                OpportunityLineItemList.add(AllopportunityLineItemList[j]);
                                        }catch(Exception e) {
                                        }
                                }
                                pageStartValue = pageEndValue;
                                pageEndValue = selectedPageMore*(i+2);
                                mapOpportunityLineItems.put(counter,OpportunityLineItemList);
                                if(mapOpportunityLineItems.get(selectedPage)!= null){
                                        if ((mapOpportunityLineItems.get(selectedPage).size() >= selectedPageMore) && (newLineItemList.size()== 0) && (existingLineItemList.size() != selectedPageMore)){
                                                largeResultFlag = true;
                                        }
                                }
                        }
                }
                
                
                
                existingrecordsize=mapOpportunityLineItems.values().size();
                return mapOpportunityLineItems;
        }
        /**
         * @description:  To clear all Search values on Page
         * @return: Null
         * 
         */
        public pagereference clearAllSearch() {
                clearAllFlags();
                searchExistingBusinessGroup = 'None';
                searchExistingGlobalBusinessUnit = 'None';
                searchExistingProductLine = '';
                searchExistingSubProductLine = '';
                return null;
        }

        public pagereference closeAllSearch() {
                clearAllFlags();
                searchExistingBusinessGroup = 'None';
                searchExistingGlobalBusinessUnit = 'None';
                searchExistingProductLine = '';
                searchExistingSubProductLine = '';
                return null;
        }

        /**
         * @description:  To clear all parameters of the Page
         * @return: Null
         * 
         */
        public PageReference cancelUpdate() {
                deletedLineitemIds = new Set<Id>();
                edittedLineitemIds = new Set<Id>();
                pendingLineitemIds = new Set<Id>();
                lineitemIds = new Set<Id>();
                testOpptyProduct.ServiceDate = null;
                testOpptyProduct.Add_days_to_BookShip_Date__c = null;
                collapsibleFlag = true;
                newLineItemList = new List<wrapperLineItem>();
                clearAllFlags();
                return null;
        }

        public PageReference Cancelsinglerow(){
                String msgId = ApexPages.currentPage().getParameters().get('paramid');
                system.debug('msgId**************************'+msgId);    
                return null;
        }

        /**
         * @description:  To display RTS Specific Info as per 
    OMPM Renewal R3.o
         * @Owner: Deepak Saxena
         * @return: Null
         * 
         */
        public PageReference displayRTSInfo() {
                if (RTSSpecificFlag == false){
                        RTSSpecificFlag = true;
                        EsSpecificFlag = false;
                        tableWidth = 1200;
                        action0 = 'Collapse';
                        action='View';
                } else if(RTSSpecificFlag == true){
                        RTSSpecificFlag = false;
                        tableWidth = 1200;
                        action0 = 'View';
                }    
                return null;
        }

        /**
         * @description:  To display ES Specific Info
         * @return: Null
         * 
         */
        public PageReference displayEsInfo() {
                if (EsSpecificFlag == false){
                        EsSpecificFlag = true;
                        RTSSpecificFlag = false;
                        tableWidth = 1200;
                        action = 'Collapse';
                        action0='View';
                } else if(EsSpecificFlag == true){
                        EsSpecificFlag = false;
                        tableWidth = 1200;
                        action = 'View';
                }    
                return null;
        }
        /**
         * @description:  To clear all Messages on Page
         * @return: Null
         * 
         */
        public PageReference clearAllFlags() {
                isInsertedFlag = false;
                IsInsertFailureFlag = false;
                isDeleteFailureFlag = false;
                isEditFailureFlag = false;
                isEdittedFlag = false;
                isDeletedFlag = false;
                isInsertAfterDeleteFlag = false;
                isDeleteBeforeInsertFailureFlag = false;
                isDeleteBeforeInsertFlag = false;
                isInsertAfterDeleteFailureFlag= false;
                isOrphanFlag = false;
                /**
                 * Veribles added for R4 enhancement
                 **/
                Islineiteminserted=false;
                Isiteminsertfailed=false;        
                return null;
        }
        /**
         * @description:  To add a new row inorder to associate New Product/Service
         * @return: Null
         * 
         */
        public PageReference addRow() {
                Opportunity optylists = new Opportunity();

                optylists= [select Deal_Registration_Status__c from Opportunity where id=:oppId];


                if(optylists.Deal_Registration_Status__c =='Submitted' || optylists.Deal_Registration_Status__c =='Review Initiated'){

                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.DEAL_UNDER_PROGRESS)); 

                }else{

                        pendingLineitemIds = new Set<Id>();
                        clearAllFlags();
                        OpportunityLineItem newOpptLineItem = new OpportunityLineItem();
                        newOpptLineItem.OpportunityId = oppty.Id;
                        newOpptLineItem.Quantity = 1;
                        newOpptLineItem.Keep__c=true;
                        newLineItemList.add(new wrapperLineItem(newOpptLineItem,'','','','','',false,null,null,null));   
                        for (wrapperLineItem lil : newLineItemList){
                                lil.selected=true; 
                                lil.isNew = true;
                        }
                        /*for (wrapperLineItem oliItm : existingLineItemList){
             if (oliItm.selected==true){
                 pendingLineitemIds.add(oliItm.oli.Id); 
             } 

        }*/
                }
                return null;    
        }
        /**
         * @description:  To associate a New Product on Page & Disassociate
         * @return: Null
         * 
         */
        public PageReference associateAndDelete() {
                System.Savepoint sp1 = null;
                listDisassociateSuccess = new list<string>();
                listDisassociateFailure = new list<string>();
                listAssociationSuccess = new list<string>();
                listAssociationFailure = new list<string>();
                set<String> deleteInsertErrorMessage = new set<String>();
                set<String> insertDeleteErrorMessage = new set<String>();

                set<Id> insertDeleteSuccessId = new set<Id>();
                list<PricebookEntry> tempPbSuccess = new List<PricebookEntry>();
                list<PricebookEntry> tempPbFailure = new List<PricebookEntry>();
                Set<String> tempPbSuccessId = new Set<String>();
                Set<String> tempPbFailureId = new Set<String>();

                /*Try association of new product only if disassociation Successful*/
                if(deletedLineItemList.size()>0){
                        for(wrapperLineItem wItem : deletedLineItemList) { 
                                insertLineItems.add(wItem.oli);
                        }
                }
                if (insertLineItems.size()>0){
                        try{
                                sp1 = Database.setSavepoint();
                                Database.SaveResult[] results = database.insert(insertLineItems,false);
                                for (Database.SaveResult result : results) {
                                        if (result.isSuccess()) {
                                                deleteInsertSuccessId.add(result.getId()); 
                                                isInsertAfterDeleteFlag = true;
                                                newlyaddedlineitem=null;
                                        } 
                                        if (!result.isSuccess()) {
                                                isInsertAfterDeleteFailureFlag= true;
                                                isInsertAfterDeleteFlag = false;
                                                Database.rollback(sp1);
                                                Database.Error[] insErrors = result.getErrors();
                                                for(Database.Error er : insErrors){
                                                        deleteInsertErrorMessage.add(er.getMessage());
                                                }
                                        }    
                                }
                                ApplyProgramvisiblityForSave(deleteInsertSuccessId);
                                for (OpportunityLineItem oppl : insertLineItems){
                                        if(deleteInsertSuccessId.contains(oppl.Id)){
                                                tempPbSuccessId.add(oppl.PricebookEntryId);
                                        }else {
                                                isDeleteBeforeInsertFlag = false;
                                                isDeleteBeforeInsertFailureFlag = false;
                                                tempPbFailureId.addAll(tempPbSuccessId);
                                                tempPbFailureId.add(oppl.PricebookEntryId);
                                        }
                                }
                                if (tempPbSuccessId.size()>0){
                                        tempPbSuccess = [Select Id,Name,Product2.name from PricebookEntry where Id =: tempPbSuccessId];
                                        for (PricebookEntry pb: tempPbSuccess){
                                                listAssociationSuccess.add(pb.Product2.Name);
                                        }
                                }
                                if (tempPbFailureId.size()>0){
                                        tempPbFailure = [Select Id,Name,Product2.name from PricebookEntry where Id =: tempPbFailureId];
                                        for (PricebookEntry pb1: tempPbFailure){
                                                listAssociationFailure.add(pb1.Product2.Name);
                                        }
                                }     
                                for (String errMsg : deleteInsertErrorMessage){
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errMsg));    
                                } 
                        }catch(DmlException dmlEx){
                                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity Product', 'ProductsAndServicesController', 'Class');
                                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                                }
                                return null;
                        }
                }
                
                
                if (deleteAndInsertLineItems.size()>0 && listAssociationFailure.size()==0){
                        try{
                                Database.DeleteResult[] delResults = database.delete(deleteAndInsertLineItems,false);
                                for (Database.DeleteResult delResult : delResults) {
                                        if (delResult.isSuccess()) {
                                                insertDeleteSuccessId.add(delResult.getId()); 
                                                isDeleteBeforeInsertFlag = true;
                                        } 
                                        if (!delResult.isSuccess()) {
                                                isDeleteBeforeInsertFailureFlag = true;
                                                isInsertAfterDeleteFlag = false;
                                                Database.Error[] delErrs = delResult.getErrors();
                                                for(Database.Error error : delErrs){
                                                        insertDeleteErrorMessage.add(error.getMessage());
                                                }
                                        } 
                                }
                                for (OpportunityLineItem oplin : deleteAndInsertLineItems){
                                        if(insertDeleteSuccessId.contains(oplin.Id)){
                                                listDisassociateSuccess.add(oplin.PricebookEntry.Product2.Name);

                                        }else {
                                                Database.rollback(sp1);
                                                listDisassociateFailure.add(oplin.PricebookEntry.Product2.Name);
                                        }
                                }
                                for (String delErrMsg : insertDeleteErrorMessage){
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,delErrMsg));    
                                }
                        }catch(DmlException dmlEx){
                                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity Product', 'ProductsAndServicesController', 'Class');
                                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                                }
                                return null;
                        }    
                }
                //R6 code for ICOEM functionality added by Praveen Kumar Reddy  
                List<OpportunityLineItem> icoemLineItemsList=new List<OpportunityLineItem>();
                
                icoemLineItemsList=[select id,PricebookEntry.Product2.Name,subtotal,UnitPrice,ProductName__c,Scope_Type__c  from OpportunityLineItem where opportunityID= :oppid and ( PricebookEntry.Product2.Name='1052 - Outside Segment Elimination Entrepreneur' or ICOEM__c=true)];
                integer lineitemCount=0;
                integer icoemitemCount=0;
                Decimal lineitemVal=0;
                OpportunityLineItem singleIcoemlineitem=new OpportunityLineItem();
                for(OpportunityLineItem icoem : icoemLineItemsList){
                    if( icoem.PricebookEntry.Product2.Name!='1052 - Outside Segment Elimination Entrepreneur'){
                        lineitemVal=lineitemVal + icoem.subtotal;
                        lineitemCount=lineitemCount+1;
                    }
                    if( icoem.PricebookEntry.Product2.Name=='1052 - Outside Segment Elimination Entrepreneur'){
                        singleIcoemlineitem=icoem;
                        icoemitemCount=1;
                    }
                }
                try{
                    if(icoemitemCount==0 && isICOEMExist==true){
                    
                        opportunityLineItem ioceLineItem=new opportunityLineItem ();
                        decimal netval=insertIcoemUnitPrice-deleteIcoemUnitPrice;
                        PriceBookEntry pbe=new PriceBookEntry();
                        try{
                        pbe=[select id,name,PricebookEntry.Product2.Business_Group__c,PricebookEntry.Product2.GBU__c,PricebookEntry.Product2.Product_Line__c,PricebookEntry.Product2.Sub_Product_Line__c,PricebookEntry.Product2.Service__c from PriceBookEntry where PriceBookEntry.product2.name='1052 - Outside Segment Elimination Entrepreneur' and PricebookEntry.Product2.product_level__c=5 and pricebook2ID = :pricebook.id and CurrencyIsoCode = :opty.CurrencyIsoCode limit 1];
                        }catch(Exception e){
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'1052 - Outside Segment Elimination Entrepreneur pricebooke entry doesnt exist'));
                            return null;
                        }
                        ioceLineItem=new opportunityLineItem(opportunityId=oppid,Pricebookentryid=pbe.id,Quantity=1,UnitPrice=-netval,servicedate=opty.closedate+1);
                        insert ioceLineItem;
                        
                    
                    }
                
                     if(lineitemCount>0 && icoemitemCount==1){
                                    decimal netval=insertIcoemUnitPrice-deleteIcoemUnitPrice;
                                    system.debug('netval  '+ netval);
                                    singleIcoemlineitem.UnitPrice=-lineitemVal;
                                    system.debug('singleIcoemlineitem1   '+singleIcoemlineitem);
                                    update singleIcoemlineitem;
                     }
                    if(lineitemCount==0 && icoemitemCount==1)
                    delete singleIcoemlineitem; 
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
                }
                //End R6 code for ICOEM functionality   
                return null;
        }
        /**
         * @description:  To disassociate existing Product on Page & Add new
         * @return: Null
         * 
         */
        public PageReference deleteAndAssociate() {
                System.Savepoint sp = null;
                listDisassociateSuccess = new list<string>();
                listDisassociateFailure = new list<string>();
                listAssociationSuccess = new list<string>();
                listAssociationFailure = new list<string>();
                set<String> deleteInsertErrorMessage = new set<String>();
                set<String> insertDeleteErrorMessage = new set<String>();
                deleteInsertSuccessId = new set<Id>();
                set<Id> insertDeleteSuccessId = new set<Id>();
                list<PricebookEntry> tempPbSuccess = new List<PricebookEntry>();
                list<PricebookEntry> tempPbFailure = new List<PricebookEntry>();
                Set<String> tempPbSuccessId = new Set<String>();
                Set<String> tempPbFailureId = new Set<String>();
                
                
                if (deleteAndInsertLineItems.size()>0){
                        try{
                                sp = Database.setSavepoint();
                                Database.DeleteResult[] delResults = database.delete(deleteAndInsertLineItems,false);
                                for (Database.DeleteResult delResult : delResults) {
                                        if (delResult.isSuccess()) {
                                                insertDeleteSuccessId.add(delResult.getId()); 
                                                isDeleteBeforeInsertFlag = true;
                                                newlyaddedlineitem=null;
                                        } 
                                        if (!delResult.isSuccess()) {
                                                isDeleteBeforeInsertFailureFlag = true;
                                                Database.Error[] delErrs = delResult.getErrors();
                                                for(Database.Error error : delErrs){
                                                        insertDeleteErrorMessage.add(error.getMessage());
                                                }
                                        } 
                                }
                                for (OpportunityLineItem oplin : deleteAndInsertLineItems){
                                        if(insertDeleteSuccessId.contains(oplin.Id)){
                                                listDisassociateSuccess.add(oplin.PricebookEntry.Product2.Name);

                                        }else {
                                                listDisassociateFailure.add(oplin.PricebookEntry.Product2.Name);
                                        }
                                }
                                for (String delErrMsg : insertDeleteErrorMessage){
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,delErrMsg));    
                                }
                        }catch(DmlException dmlEx){
                                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity Product', 'ProductsAndServicesController', 'Class');
                                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                                }
                                return null;
                        }    
                }
                /*Try association of new product only if disassociation Successful*/
                if(deletedLineItemList.size()>0 && listDisassociateFailure.size()==0){
                        for(wrapperLineItem wItem : deletedLineItemList) { 
                                insertLineItems.add(wItem.oli);
                        }
                }
               
                if (insertLineItems.size()>0){
                        try{
                                Database.SaveResult[] results = database.insert(insertLineItems,false);
                                for (Database.SaveResult result : results) {
                                        if (result.isSuccess()) {
                                                deleteInsertSuccessId.add(result.getId()); 
                                                isInsertAfterDeleteFlag = true;
                                        } 
                                        if (!result.isSuccess()) {
                                                isInsertAfterDeleteFailureFlag= true;
                                                Database.Error[] insErrors = result.getErrors();
                                                for(Database.Error er : insErrors){
                                                        deleteInsertErrorMessage.add(er.getMessage());
                                                }
                                        }    
                                }
                                ApplyProgramvisiblityForSave(deleteInsertSuccessId);
                                for (OpportunityLineItem oppl : insertLineItems){
                                        if(deleteInsertSuccessId.contains(oppl.Id)){
                                                tempPbSuccessId.add(oppl.PricebookEntryId);
                                        }else {
                                                Database.rollback(sp);
                                                isDeleteBeforeInsertFlag = false;
                                                isInsertAfterDeleteFlag = false;
                                                isDeleteBeforeInsertFailureFlag = false;
                                                tempPbFailureId.addAll(tempPbSuccessId);
                                                tempPbFailureId.add(oppl.PricebookEntryId);
                                        }
                                }
                                if (tempPbSuccessId.size()>0){
                                        tempPbSuccess = [Select Id,Name,Product2.name from PricebookEntry where Id =: tempPbSuccessId];
                                        for (PricebookEntry pb: tempPbSuccess){
                                                listAssociationSuccess.add(pb.Product2.Name);
                                        }
                                }
                                if (tempPbFailureId.size()>0){
                                        tempPbFailure = [Select Id,Name,Product2.name from PricebookEntry where Id =: tempPbFailureId];
                                        for (PricebookEntry pb1: tempPbFailure){
                                                listAssociationFailure.add(pb1.Product2.Name);
                                        }
                                }     
                                for (String errMsg : deleteInsertErrorMessage){
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errMsg));    
                                } 
                        }catch(DmlException dmlEx){
                                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity Product', 'ProductsAndServicesController', 'Class');
                                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                                }
                                return null;
                        }
                }
                  //R6 code for ICOEM functionality added by Praveen Kumar Reddy 
                
                List<OpportunityLineItem> icoemLineItemsList=new List<OpportunityLineItem>();
                
                icoemLineItemsList=[select id,PricebookEntry.Product2.Name,subtotal,UnitPrice,ProductName__c,Scope_Type__c  from OpportunityLineItem where opportunityID= :oppid and ( PricebookEntry.Product2.Name='1052 - Outside Segment Elimination Entrepreneur' or ICOEM__c=true)];
                integer lineitemCount=0;
                integer icoemitemCount=0;
                Decimal lineitemVal=0;
                OpportunityLineItem singleIcoemlineitem=new OpportunityLineItem();
                for(OpportunityLineItem icoem : icoemLineItemsList){
                    if( icoem.PricebookEntry.Product2.Name!='1052 - Outside Segment Elimination Entrepreneur'){
                        lineitemVal =lineitemVal+icoem.subtotal;
                        lineitemCount=lineitemCount+1;
                    }
                    if( icoem.PricebookEntry.Product2.Name=='1052 - Outside Segment Elimination Entrepreneur'){
                        singleIcoemlineitem=icoem;
                        icoemitemCount=1;
                    }
                }
                try{
                    if(icoemitemCount==0 && isICOEMExist==true){
                    
                        opportunityLineItem ioceLineItem=new opportunityLineItem ();
                        decimal netval=insertIcoemUnitPrice-deleteIcoemUnitPrice;
                        PriceBookEntry pbe=new PriceBookEntry();
                        try{
                        pbe=[select id,name,PricebookEntry.Product2.Business_Group__c,PricebookEntry.Product2.GBU__c,PricebookEntry.Product2.Product_Line__c,PricebookEntry.Product2.Sub_Product_Line__c,PricebookEntry.Product2.Service__c from PriceBookEntry where PriceBookEntry.product2.name='1052 - Outside Segment Elimination Entrepreneur' and PricebookEntry.Product2.product_level__c=5 and pricebook2ID = :pricebook.id and CurrencyIsoCode = :opty.CurrencyIsoCode limit 1];
                        }catch(Exception e){
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'1052 - Outside Segment Elimination Entrepreneur pricebooke entry doesnt exist'));
                            return null;
                        }
                        ioceLineItem=new opportunityLineItem(opportunityId=oppid,Pricebookentryid=pbe.id,Quantity=1,UnitPrice=-netval,servicedate=opty.closedate+1);
                        insert ioceLineItem;
                        
                    
                    }
               
                     if(lineitemCount>0 && icoemitemCount==1){
                                    decimal netval=insertIcoemUnitPrice-deleteIcoemUnitPrice;
                                    system.debug('netval  '+ netval);
                                    singleIcoemlineitem.UnitPrice=-lineitemVal;
                                    singleIcoemlineitem.servicedate=opty.closedate +1;
                                    system.debug('singleIcoemlineitem2   '+singleIcoemlineitem);
                                    
                                    update singleIcoemlineitem;
                     }
                    if(lineitemCount==0 && icoemitemCount==1)
                    delete singleIcoemlineitem; 
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
                }
                
                //End R6 code for ICOEM functionality   
                return null;
        }
        /**
         * @description:  To save the new Product/Service added on New Row.And checking products and partner having eligiblity for programs.
         * @return: Null
         * 
         */
        public PageReference saveNewProducts() {
                System.debug('Haui');
                list<PricebookEntry> tempPbEntrySuccess = new List<PricebookEntry>();
                list<PricebookEntry> tempPbEntryFailure = new List<PricebookEntry>();
                Set<String> tempPbEntrySuccessId = new Set<String>();
                Set<String> tempPbEntryFailureId = new Set<String>();
                listInsertSuccess = new List<string>();
                listInsertFailure = new List<string>();
                set<String> insertErrorMessage = new set<String>();
                if (newLineItems.size()>0 ){
                        try{
                                Database.SaveResult[] results = database.insert(newLineItems,false);
                                for (Database.SaveResult result : results) {
                                        if (result.isSuccess()) {
                                                insertSuccessId.add(result.getId()); 
                                                isInsertedFlag = true;
                                                newlyaddedlineitem=null;
                                        } 
                                        if (!result.isSuccess()) {
                                                isInsertFailureFlag = true;
                                                Database.Error[] insErrors = result.getErrors();
                                                for(Database.Error er : insErrors){
                                                        insertErrorMessage.add(er.getMessage());
                                                }
                                        }    
                                }
                                ApplyProgramvisiblityForSave(insertSuccessId);

                                for (OpportunityLineItem oppl : newLineItems){
                                        if(insertSuccessId.contains(oppl.Id)){
                                                tempPbEntrySuccessId.add(oppl.PricebookEntryId);
                                        }else {
                                                tempPbEntryFailureId.add(oppl.PricebookEntryId);
                                        }
                                }
                                if (tempPbEntrySuccessId.size()>0){
                                        tempPbEntrySuccess = [Select Id,Name,Product2.name from PricebookEntry where Id =: tempPbEntrySuccessId];
                                        for (PricebookEntry pb: tempPbEntrySuccess){
                                                listInsertSuccess.add(pb.Product2.Name);
                                        }
                                } 
                                if (tempPbEntryFailureId.size()>0){   
                                        tempPbEntryFailure = [Select Id,Name,Product2.name from PricebookEntry where Id =: tempPbEntryFailureId];
                                        for (PricebookEntry pb1: tempPbEntryFailure){
                                                listInsertFailure.add(pb1.Product2.Name);
                                        }
                                }
                                /*Remove successfully added products from the New Product List*/
                                Integer i;
                                Integer listSize = newLineItemList.size();
                                for (i=listSize; i > 0 ; i--) {
                                        if (tempPbEntrySuccessId.contains(newLineItemList[i-1].PricebookEntryId)){
                                                newLineItemList.remove(i-1);
                                        } 
                                }
                                for (String errMsg : insertErrorMessage){
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errMsg));    
                                } 
                        }catch(DmlException dmlEx){
                                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity Product', 'ProductsAndServicesController', 'Class');
                                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                                }
                                return null;
                        }
                }
                newLineItems=null;
                return null;
        }
        /**
         * @description:  To identify the action User wants to perform among (Edit, Save or associate/disassociate).
         *                to save editted products/Services
         * @return: Null
         * 
         */
        public PageReference saveInline() {
                Opportunity optylists = new Opportunity();
                Set<ID> deleteLineIDSet=new Set<ID>();
                Set<ID> editLineIDSet=new Set<ID>();
                system.debug('saveinline');
                deleteIcoemUnitPrice=0;
                insertIcoemUnitPrice=0;
                Decimal editIcoemUnitPrice=0;
                isICOEMExist=false;
                optylists= [select Deal_Registration_Status__c from Opportunity where id=:oppId];


                if(optylists.Deal_Registration_Status__c =='Approved'||optylists.Deal_Registration_Status__c =='Rejected'||optylists.Deal_Registration_Status__c =='Submitted' || optylists.Deal_Registration_Status__c =='Review Initiated'){

                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.DEAL_UNDER_PROGRESS)); 

                }else{
                        collapsibleFlag = true;
                        decimal totalAssociationValue = 0.00;
                        boolean valueFlag = false;
                        edittedLineItems = new List<OpportunityLineItem>();
                        insertLineItems = new List<OpportunityLineItem>();
                        newLineItems = new List<OpportunityLineItem>();
                        deleteAndInsertLineItems = new List<OpportunityLineItem>();
                        deletedLineItemList = new List<wrapperLineItem>();
                        edittedLineitemIds = new set<Id>();
                        pendingLineitemIds = new set<Id>();
                        lineitemIds = new set<Id>();
                        clearAllFlags();
                        set<String> errorMessage = new set<String>();
                        set<Id> successId = new set<Id>();
                        listEditSuccess = new List<string>();
                        listEditFailure = new List<string>();

                        /*Operation Identification Logic*/
                        for(wrapperLineItem wItem : existingLineItemList) {

                                /****** OMPM Renewal R3.0******* Owner: Deepak Saxena********Open*********/
                                if(wItem.oli.RTS_Component__c==null){
                                        wItem.oli.RTS_Component__c=0;
                                }            
                                if(wItem.Selected == true && wItem.oli.RTS__c== True && wItem.oli.Quantity!=0){

                                        if(wItem.oli.RTS_Component__c!=wItem.RTSComponent){

                                                wItem.oli.UnitPrice = wItem.oli.UnitPrice - wItem.oli.RTS_Component__c + wItem.RTSComponent/wItem.oli.Quantity;
                                                wItem.oli.RTS_Component__c = wItem.RTSComponent; 
                                        }

                                }

                                System.debug('///////////'+wItem.oli.UnitPrice+'//////////'+ wItem.oli.RTS_Component__c);
                                /****** OMPM Renewal R3.0******* Owner: Deepak Saxena********Close*********/
                                system.debug('ITEMTOEDIT'+wItem);     
                                /*if(wItem.pricebookEntryId==''){
                wItem.isNew = true;
                if(productlinename==null||productlinename==''){
                        wItem.PricebookEntryId =ProductLineIsEmpty();
                   }
            }*/       
                                if(wItem.Selected == true && wItem.isNew == false) {
                                        //if(witem.existingSubProductLine == null || witem.existingSubProductLine==''){

                                                edittedLineItems.add(wItem.oli);
                                                if(wItem.oli.icoem__c==true){
                                                    isICOEMExist=true;
                                                    editIcoemUnitPrice=editIcoemUnitPrice+(wItem.oli.unitprice * wItem.oli.quantity);
                                                    editLineIDSet.add(wItem.oli.id);
                                                }    
                                        //}   
                                }else if (wItem.Selected == true && wItem.isNew == true && wItem.pricebookEntryId !=''){
                                        if (wItem.oli.Id == null){
                                                if(wItem.oli.PricebookEntryId == null){
                                                        wItem.oli.PricebookEntryId = wItem.pricebookEntryId;
                                                } else if (wItem.oli.PricebookEntryId != null &&  (wItem.oli.PricebookEntryId != wItem.pricebookEntryId)){
                                                        wItem.oli.PricebookEntryId =  wItem.pricebookEntryId;
                                                }  
                                                newLineItems.add(wItem.oli);
                                        } else {
                                                if (wItem.oli.Id != null){
                                                        valueFlag = true;
                                                        if(wItem.oli.icoem__c==true){
                                                            isICOEMExist=true;
                                                            deleteLineIDSet.add(wItem.oli.Id);
                                                            insertIcoemUnitPrice=insertIcoemUnitPrice+(wItem.oli.unitprice * wItem.oli.quantity);
                                                        }
                                                        deleteAndInsertLineItems.add(wItem.oli);
                                                        OpportunityLineItem ol = new OpportunityLineItem();
                                                        ol.OpportunityId = oppty.Id;
                                                        ol.Quantity = wItem.oli.Quantity;
                                                        ol.UnitPrice =  wItem.oli.UnitPrice;
                                                        ol.First_Fiscal_Year_Value__c = wItem.oli.First_Fiscal_Year_Value__c;
                                                        ol.Margin_Amount__c = wItem.oli.Margin_Amount__c;
                                                        ol.ICOEM__c = wItem.oli.ICOEM__c;
                                                        if((wItem.pricebookEntryId=='null' || wItem.pricebookEntryId=='') && (witem.existingSubProductLine == null || witem.existingSubProductLine=='')){
                                                                String query = 'select Id, Name, IsActive, unitPrice, Product2.Business_Group__c, Product2.GBU__c,Product2.Service__c,' +
                                                                'Product2.Product_Line__c, Product2.Sub_Product_Line__c, Product2.Product_Level__c  from PricebookEntry Where' +' '+ 
                                                                'Product2.Business_Group__c =\'' + witem.existingbusinessgroup + '\' AND' +' '+  
                                                                'Product2.GBU__c like \'' + '%' + witem.existingGlobalBusinessUnit + '%\' AND' +' '+                                                                                     
                                                                'CurrencyIsoCode = \'' + oppty.CurrencyIsoCode+ '\' AND' +' '+
                                                                'Pricebook2id = \'' + pricebook.id + '\'AND' +' '+ 
                                                                'Product2.Product_Level__c ='+hierarchylevel +' '+'AND' + ' ' +
                                                                ' IsActive = true limit'+ ' ' + Label.Query_Limit;

                                                                PricebookEntry pricebookentryrecord1=Database.query(query); 
                                                                ol.PricebookEntryId =pricebookentryrecord1.id;
                                                        }else{
                                                                ol.PricebookEntryId=wItem.PricebookEntryId;
                                                        }
                                                        ol.serviceDate = wItem.oli.serviceDate;
                                                        if (wItem.isService == true){
                                                                ol.Start_Date__c = wItem.oli.Start_Date__c;
                                                                ol.End_Date__c = wItem.oli.End_Date__c;
                                                                ol.Attach__c = wItem.oli.Attach__c;
                                                                ol.First_12_Month_Value__c = wItem.oli.First_12_Month_Value__c;
                                                                ol.FFYR_Margin_Amount__c = wItem.oli.FFYR_Margin_Amount__c;
                                                        }
                                                        deletedLineItemList.add(new wrapperLineItem(ol,'',wItem.existingBusinessGroup,wItem.existingGlobalBusinessUnit,wItem.existingProductLine,wItem.existingSubProductLine,wItem.isService,null,null,null));
                                                }  
                                        }
                                }else if (wItem.isNew == true && wItem.Selected == true && wItem.pricebookEntryId ==''){
                                        isOrphanFlag = true;
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Blank_Row_Save));    
                                }
                                if (!valueFlag && wItem.oli.Subtotal!=null){
                                        totalAssociationValue = totalAssociationValue + wItem.oli.Subtotal;
                                } else{
                                        valueFlag = false;
                                }
                        }
                        if(edittedLineItems.size()==0 && newLineItems.size()==0 && deleteAndInsertLineItems.size()==0 && isOrphanFlag ==false) {
                                isOrphanFlag = true;
                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Save_Without_Select));
                        }
                        /*Remove unadded rows*/
                        Integer j;
                        Integer listSize = newLineItemList.size();
                        for (j=listSize; j > 0 ; j--) {
                                if (newLineItemList[j-1].Selected == false && newLineItemList[j-1].isNew == true){
                                        newLineItemList.remove(j-1);
                                } 
                        }
                        
                       //R6 code for ICOEM functionality added by Praveen Kumar Reddy 
                       
                        insertIcoemUnitPrice=insertIcoemUnitPrice+editIcoemUnitPrice;
                        for(OpportunityLineItem olitem: [select id,unitprice,quantity,subtotal from opportunityLineItem where (id in : deleteLineIDSet or id in :editLineIDSet ) and icoem__c =true]){
                                                       
                            deleteIcoemUnitPrice=deleteIcoemUnitPrice+(olitem.unitprice * olitem.quantity);
                        }
                        /* Inserting Editted Line Items*/

                        if(edittedLineItems.size()> 0) {
                                
                                system.debug('inserting');
                                try{
                                        system.debug('&&&&'+edittedLineItems);
                                        Database.SaveResult[] results = database.update(edittedLineItems,false);
                                        for (Database.SaveResult result : results) {
                                                if (result.isSuccess()) {
                                                        successId.add(result.getId()); 
                                                        isEdittedFlag = true;
                                                } 
                                                if (!result.isSuccess()) {
                                                        isEditFailureFlag = true;
                                                        Database.Error[] errs = result.getErrors();
                                                        for(Database.Error err : errs){
                                                                errorMessage.add(err.getMessage());
                                                        }
                                                }    
                                        }
                                        for (OpportunityLineItem opplin : edittedLineItems){
                                                if(successId.contains(opplin.Id)){
                                                        listEditSuccess.add(opplin.PricebookEntry.Product2.Name);
                                                }else {
                                                        edittedLineitemIds.add(opplin.Id);
                                                        listEditFailure.add(opplin.PricebookEntry.Product2.Name);
                                                }
                                                system.debug('*****************************************Hasscheduled****'+opplin.HasSchedule);
                                                system.debug('*************isWarnBookShipDateChange***********'+isWarnBookShipDateChange);
                                                if(opplin.HasSchedule==true){

                                                        listEditBookshipdate.add(opplin.PricebookEntry.Product2.Name);
                                                        isWarnBookShipDateChange= true;
                                                }

                                        }
                                        for (String errMsg : errorMessage){
                                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errMsg));    
                                        } 
                                }catch(DmlException dmlEx){
                                        CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity Product', 'ProductsAndServicesController', 'Class');
                                        for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                                        }
                                        return null;
                                }
                        }
                        
                        //R6 code for ICOEM functionality added by Praveen Kumar Reddy 
                        if(edittedLineItems.size()> 0 && deleteAndInsertLineItems.size()<=0){
                            List<OpportunityLineItem> icoemLineItemsList=new List<OpportunityLineItem>();
                    
                            icoemLineItemsList=[select id,PricebookEntry.Product2.Name,subtotal,UnitPrice,quantity  from OpportunityLineItem where opportunityID= :oppid and ( PricebookEntry.Product2.Name='1052 - Outside Segment Elimination Entrepreneur' or ICOEM__c=true)];
                            integer lineitemCount=0;
                            integer icoemitemCount=0;
                            Boolean isICOEMEDIT=false;
                            Decimal lineitemVal=0;
                            OpportunityLineItem singleIcoemlineitem=new OpportunityLineItem();
                            for(OpportunityLineItem icoem : icoemLineItemsList){
                                if( icoem.PricebookEntry.Product2.Name!='1052 - Outside Segment Elimination Entrepreneur'){
                                    lineitemVal=lineitemVal+icoem.subtotal;
                                    lineitemCount=lineitemCount+1;
                                }
                                if( icoem.PricebookEntry.Product2.Name=='1052 - Outside Segment Elimination Entrepreneur'){
                                    singleIcoemlineitem=icoem;
                                    icoemitemCount=1;
                                    isICOEMEDIT=true;
                                }
                            }
                            try{
                                if(icoemitemCount==0 && icoemLineItemsList.size()>0){
                                
                                    opportunityLineItem ioceLineItem=new opportunityLineItem ();
                                    decimal netval=insertIcoemUnitPrice-deleteIcoemUnitPrice;
                                    PriceBookEntry pbe=new PriceBookEntry();
                                    try{
                                    pbe=[select id,name,PricebookEntry.Product2.Business_Group__c,PricebookEntry.Product2.GBU__c,PricebookEntry.Product2.Product_Line__c,PricebookEntry.Product2.Sub_Product_Line__c,PricebookEntry.Product2.Service__c from PriceBookEntry where PriceBookEntry.product2.name='1052 - Outside Segment Elimination Entrepreneur' and PricebookEntry.Product2.product_level__c=5 and pricebook2ID = :pricebook.id and CurrencyIsoCode = :opty.CurrencyIsoCode limit 1];
                                    }catch(Exception e){
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'1052 - Outside Segment Elimination Entrepreneur pricebooke entry doesnt exist'));
                                        return null;
                                    }
                                    ioceLineItem=new opportunityLineItem(opportunityId=oppid,Pricebookentryid=pbe.id,Quantity=1,UnitPrice=-netval,servicedate=opty.closedate+1);
                                    insert ioceLineItem;
                                    
                                
                                }
                          
                                 if(lineitemCount>0 && icoemitemCount==1){
                                                decimal netval=insertIcoemUnitPrice-deleteIcoemUnitPrice;
                                                system.debug('netval  '+ netval);
                                                if(netval==0)
                                                netval=insertIcoemUnitPrice;
                                                singleIcoemlineitem.UnitPrice=-lineitemVal;
                                                singleIcoemlineitem.servicedate=opty.closedate +1;
                                                system.debug('singleIcoemlineitem2   '+singleIcoemlineitem);
                                                
                                                update singleIcoemlineitem;
                                 }
                                if(lineitemCount==0 && icoemitemCount==1)
                                delete singleIcoemlineitem; 
                            }catch(Exception e){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
                                return null;
                            }
                            
                            //End R6 code for ICOEM functionality   
                        }
                        /*Calling Method to Save New Products*/
                        if (newLineItems.size()>0){
                                system.debug('Save New Products');
                                saveNewProducts();
                        }
                        /*Calling Method to Associate New & Delete Existing*/
                        if (deleteAndInsertLineItems.size()>0 && totalAssociationValue == 0){
                                system.debug('New & Delete Existing');
                                associateAndDelete();
                                /*Calling Method to Delete Existing & Associate New*/
                        }else if (deleteAndInsertLineItems.size()>0){
                                system.debug('Delete Existing & Associate New');
                                deleteAndAssociate();
                        }
                }
               oppty = fetchOpptyStatistics();
                return null;
        } 
        /**
         * @description:  To delete the existing Product/Service associated
         * @return: Null
         * 
         */
        public PageReference DeleteSelected() {
                Opportunity optylists = new Opportunity();

                optylists= [select Deal_Registration_Status__c from Opportunity where id=:oppId];


                if(optylists.Deal_Registration_Status__c =='Rejected'||optylists.Deal_Registration_Status__c =='Approved'||optylists.Deal_Registration_Status__c =='Submitted' || optylists.Deal_Registration_Status__c =='Review Initiated'){

                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.DEAL_UNDER_PROGRESS)); 

                }else{
                        lineitemIds = new set<Id>();
                        clearAllFlags();
                        listDeleteSuccess = new List<string>();
                        listDeleteFailure = new List<string>();
                        set<String> deleteErrorMessage = new set<String>();
                        set<Id> successDeleteId = new set<Id>();
                        List<OpportunityLineItem> lineItemsToDelete = new List<OpportunityLineItem>();
                        List<OpportunityLineItem> ICOEMLineItemsToDelete = new List<OpportunityLineItem>();
                        Decimal deleteIcoemUnitPrice=0;
                        for(wrapperLineItem wLine : existingLineItemList) {
                                if(wLine.selected == true && wLine.oli.Id != null) {
                                        if(wLine.isNew == false){
                                                lineItemsToDelete.add(wLine.oli);
                                                if(newlyaddedlineitem!=null){
                                                if(newlyaddedlineitem.oli.id==wLine.oli.Id){
                                                  newlyaddedlineitem=null;
                                                 }
                                              }
                                              if(wLine.oli.ICOEM__c==true){ //R6 code for ICOEM  functionality
                                                deleteIcoemUnitPrice=deleteIcoemUnitPrice+wLine.oli.unitprice; 
                                                ICOEMLineItemsToDelete.add(wLine.oli);
                                              }
                                        }else{
                                                isOrphanFlag = true;
                                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Invalid_Product_Delete));
                                        }
                                }else if (wLine.selected == true && wLine.oli.Id == null){
                                        isOrphanFlag = true;
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Invalid_Product_Delete));
                                }
                        }
                        if(lineItemsToDelete.size()==0 && isOrphanFlag ==false){
                                isOrphanFlag = true;
                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Save_Without_Select));
                        }
                        /*Perform Delete Operation on Selected Line Items*/
                        if (lineItemsToDelete.size() > 0) {
                                try{
                                        Database.DeleteResult[] delResults = database.delete(lineItemsToDelete,false);
                                        for (Database.DeleteResult delResult : delResults) {
                                                if (delResult.isSuccess()) {
                                                        successDeleteId.add(delResult.getId()); 
                                                        isDeletedFlag = true;
                                                } 
                                                if (!delResult.isSuccess()) {
                                                        isDeleteFailureFlag = true;
                                                        Database.Error[] delErrs = delResult.getErrors();
                                                        for(Database.Error error : delErrs){
                                                                deleteErrorMessage.add(error.getMessage());
                                                        }
                                                } 
                                        }
                                        /*Fetching success & failure product names*/
                                        for (OpportunityLineItem oplin : lineItemsToDelete){
                                                if(successDeleteId.contains(oplin.Id)){
                                                        listDeleteSuccess.add(oplin.PricebookEntry.Product2.Name);
                                                        
                                                        //isDeletedFlag = true;
                                                }else {
                                                        lineitemIds.add(oplin.Id);
                                                        listDeleteFailure.add(oplin.PricebookEntry.Product2.Name);
                                                }
                                        }
                                        /*Displaying error messages*/
                                        for (String delErrMsg : deleteErrorMessage){
                                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,delErrMsg));    
                                        }
                                }catch(DmlException dmlEx){
                                        CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity Product', 'ProductsAndServicesControllerNew', 'Class');
                                        for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                                        }
                                        return null;
                                }
                        }
                        //R6 code for ICOEM to update ICOEM lineitem  
                        if(ICOEMLineItemsToDelete.size()>0){
                            List<OpportunityLineItem> icoemLineItemsList=new List<OpportunityLineItem>();
                            icoemLineItemsList=[select id,ICOEM__c,PricebookEntry.Product2.Name,subtotal,UnitPrice,ProductName__c,Scope_Type__c  from OpportunityLineItem where opportunityID= :oppid and  (PricebookEntry.Product2.Name='1052 - Outside Segment Elimination Entrepreneur' or ICOEM__c=true)];
                            integer lineitemcount=0;
                            integer icoemcount=0;
                            Decimal lineitemVal=0;
                            OpportunityLineItem singleIcoemlineitem=new OpportunityLineItem();
                            for(OpportunityLineItem icoem : icoemLineItemsList){
                                if( icoem.PricebookEntry.Product2.Name!='1052 - Outside Segment Elimination Entrepreneur'){
                                    lineitemVal =lineitemVal+icoem.subtotal;
                                    lineitemcount=lineitemcount+1;
                                }
                                if( icoem.PricebookEntry.Product2.Name=='1052 - Outside Segment Elimination Entrepreneur'){
                                    singleIcoemlineitem=icoem;
                                    icoemcount=icoemcount+1;
                                }
                            }
                            if(lineitemcount>0){
                                singleIcoemlineitem.UnitPrice=-lineitemVal ;
                                singleIcoemlineitem.servicedate=opty.closedate +1;
                                update singleIcoemlineitem;
                            }
                            if(lineitemcount==0 && icoemcount >0)
                            delete singleIcoemlineitem; 
                            
                        }
                        applyProgramVisibility();
                }
                oppty = fetchOpptyStatistics();
                newlyaddedlineitem=null;
                inactivemeth();
                return null;
        } 

        // Starting of deal registration apply program code

        public PageReference applyPromotions() {

                pagereference ref=new pagereference('/apex/DealReg_AddPromotionForProduct');
                ref.setredirect(true);

                return ref;
        }

        /*
         *  This method used to Cancel the deal and return to ProductsAndServices page
         */
        public PageReference doCancel() {

                pagereference ref=new pagereference('/apex/ProductsAndServicesNew?oppId='+oppId);
                ref.setredirect(true);
                return ref;  
        }


    /*
     * This method used to submit the deal for an approval
     */
    public PageReference doSubmitBusinessUnit()
    {           
            User userPartnerAccount = new User();
            Account partnerAccountName = new Account();
//          Opportunity dealId = new Opportunity();       
            Set<String> newProductLinesSet = new Set<String>();
//          Set<String> businessUnitName = new Set<String>();
//          Set<ID> L1AppId;
            Set<String> newProgSet = new Set<String>();
//          List<String> productId= new List<String>(); 
            List<Deal_Registration__c> duplicateDealRegistrationList = new List<Deal_Registration__c>();
            List<Product_Registration__c> newProductRegistraionList = new List<Product_Registration__c>();
            List<String> newProductLinesList = new List<String>();
            List<Product_Registration__c> duplicateProductRegistrationList = new List<Product_Registration__c>();
//          List<Deal_Registration__c> dealRegistraionItem = new List<Deal_Registration__c>();
            List<Deal_Registration__c> updateDRStatusList = new List<Deal_Registration__c>();
            List<Product_Registration__c> newProdRegList = new List<Product_Registration__c>();
            List<Deal_Registration__c> businessUnitinsertRecords = new List<Deal_Registration__c >();
            List<OpportunityLineItem> opportunityBusinessUnit = new List<OpportunityLineItem>();
            List<String> businessUnitList = new List<String>();
            List<Deal_Registration__c> dealRegistrationList = new List<Deal_Registration__c>();
            List<String> selectedProgramList= new List<String>();
            List<Product_Registration__c> updateProdRegList = new List<Product_Registration__c>();
            List<Campaign> campaignList = new List<Campaign>(); 
            List<Product_Registration__c> prodRegList = new List<Product_Registration__c>();
            List<Deal_Registration__c> allDealRegList = new List<Deal_Registration__c>();
            List<Deal_Registration__c> updDRCommentList = new List<Deal_Registration__c>();         
            Map<String, List<OpportunityLineItem>> finalProgOLMap = new Map<String, List<OpportunityLineItem>>();
            Map<String, ID> businessUnitApproverMap = new Map<String, ID>();
            Map<String, Set<String>> progProdNameMap = new Map<String, Set<String>>();
            Map<String, List<OpportunityLineItem>> progOLMap = new Map<String, List<OpportunityLineItem>>();
            Map<String, Set<String>> progProdLinePRMap = new Map<String, Set<String>>();
            Id CustId; 
            
            hasSelectedPrograms = false;
            Opportunity opptyRT = [select Deal_Registration_Status__c,Opportunity_ID__c,RecordType.Name,AccountId from Opportunity where Id=: oppId];
            
            if(opptyRT.Deal_Registration_Status__c == 'Submitted'){           
                    ApexPages.Message errorMsg= new ApexPages.Message(ApexPages.Severity.INFO,'Cannot resubmit the deal');
                    return null;
            }
            system.debug('z1a'+programList);
/*                List<OpportunityLineItem> updateOpty = new List<OpportunityLineItem>();
            for(ProgramWrapper programWrapper : programList ){

                    if(programWrapper.isSelected){

                            Set<String> productLineSelected=programWrapper.productList;
                            selectedProgramList.add(programWrapper.selectedPrograms);
                            system.debug('z1b'+productLineSelected);
                            system.debug('z1c'+selectedProgramList);
//                                try{
//                                        List<OpportunityLineItem> selectedPrograms = [SELECT OpportunityId,Product__c,Program_Code__c FROM OpportunityLineItem WHERE Product_Line__c IN:productLineSelected AND OpportunityId=:oppId];
//
//                                        for(OpportunityLineItem selectedOptyLineIteam:selectedPrograms)
//                                        {
//                                                selectedOptyLineIteam.Program_Code__c = programWrapper.selectedPrograms;   
//                                                updateOpty.add(selectedOptyLineIteam);
//                                        }
                            }
//                                catch(Exception e){
//                                        System.debug(e);
//                                }

                            if(programWrapper.isSelected){
                                    hasSelectedPrograms = true;        
                            }
                    }     //End of Venkatesh code  
            }
*/
            for(ProgramWrapper programWrapperVar : programList){
                if(programWrapperVar.isSelected){
                    selectedProgramList.add(programWrapperVar.selectedPrograms);                                //Get the list of selected programs
                    progProdNameMap.put(programWrapperVar.selectedPrograms,programWrapperVar.ProductList);      //Map on program & list of products
                    hasSelectedPrograms = true;
                }
                
            }               

            // Below lines of code updates the Opportunity Record Type and auto generates Deal Id
            try{
                    string oppIDNumber = OpptyRT.Opportunity_ID__c;
                    CustId = opptyRT.AccountId;
//                  RecordType DealRT = [select Id from RecordType where Name ='Partner Deal' and SobjectType = 'Opportunity'];
                    opptyRT.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Partner Deal').getRecordTypeId();
                    opptyRT.Deal_Id__c = 'REG-' + oppIDNumber.substringAfter('-');
//                  opptyRT.isResubmitted__c = True;
                    Update opptyRT;
            }
            catch(Exception e){
                    System.debug(e);
            }

            /* Start---Lines below are used to create records in Deal_Registration and Product_Registration objects and 
             * initiate the approval process on Deal_Registration object  
             */ 

            opportunityBusinessUnit= [Select  Id,Product_Line__c,GBU__c,Program_Code__c, OpportunityId,Business_Group__c, Product__c from OpportunityLineItem where OpportunityId= :oppId ]; 
            userPartnerAccount=[select Partner_account_ID__c,Location_Record_Id__c from user where id=:UserInfo.getUserId()]; 
            partnerAccountName = [select Name from Account where Id =:userPartnerAccount.Partner_account_ID__c];
            system.debug('y1a'+opportunityBusinessUnit);
            system.debug('y1z'+progProdNameMap);
            for(Integer i=0;i<opportunityBusinessUnit.size();i++){
                for(String progProdNameMapVar:progProdNameMap.keySet()){
                    for(String prodlistVar:progProdNameMap.get(progProdNameMapVar)){
                        system.debug('d1a'+prodlistVar);
                        system.debug('d1b'+opportunityBusinessUnit[i].Product_Line__c);
                        if(prodlistVar == opportunityBusinessUnit[i].Product_Line__c){
                            if(progOLMap.containsKey(progProdNameMapVar)){                                  //Map on selected program & list of line items
                                progOLMap.get(progProdNameMapVar).add(opportunityBusinessUnit[i]);
                            }else{
                                progOLMap.put(progProdNameMapVar,new List<OpportunityLineItem>());
                                progOLMap.get(progProdNameMapVar).add(opportunityBusinessUnit[i]);
                            }
                        }
                    }
                }
            }
            system.debug('n1a'+progOLMap);
            campaignList = [Select Name,Level_1_Approver_1__c,Level_1_Approver_2__c,Level_1_Approver_3__c,Level_1_Approver_4__c,Level_1_Approver_5__c,Level_1_Approver_6__c,Level_1_Approver_7__c,Level_1_Approver_8__c,Level_1_Approver_9__c,Level_1_Approver_10__c,Level_1_Approver_11__c,Level_1_Approver_12__c,Business_Unit__c from Campaign where Name In:selectedProgramList and isActive = True];                     
            duplicateDealRegistrationList = [select Id,Program__r.Name from Deal_Registration__c where Opportunity__c = :oppId and Program__r.Name IN :selectedProgramList];            
//          dealId=[select Deal_Id__c from Opportunity where id=:oppId];
            newProgSet.addall(selectedProgramList);
            //Removes duplicate program from the final program list based on the deal-reg records
            for(Deal_Registration__c duplicateDealRegistrationListVar:duplicateDealRegistrationList){
                newProgSet.remove(duplicateDealRegistrationListVar.Program__r.Name);
            }
            //Creates a new deal reg record if there is no existing one.
            if(duplicateDealRegistrationList.size()==0){
                    for(campaign cam:campaignList){
                            Deal_Registration__c businessUnitRecords = new Deal_Registration__c(name=opptyRT.Deal_Id__c+''+partnerAccountName.Name,Partner_Account__c=userPartnerAccount.Partner_account_ID__c,Business_Unit__c = cam.Business_Unit__c,Opportunity__c = oppId,Level_1_Approver_1__c = cam.Level_1_Approver_1__c,Partner_User_Location__c =userPartnerAccount.Location_Record_Id__c,Level_1_Approver_2__c = cam.Level_1_Approver_2__c,Level_1_Approver_3__c = cam.Level_1_Approver_3__c,Level_1_Approver_4__c = cam.Level_1_Approver_4__c,Level_1_Approver_5__c = cam.Level_1_Approver_5__c,Level_1_Approver_6__c = cam.Level_1_Approver_6__c,Level_1_Approver_7__c = cam.Level_1_Approver_7__c,Level_1_Approver_8__c = cam.Level_1_Approver_8__c,Level_1_Approver_9__c = cam.Level_1_Approver_9__c,Level_1_Approver_10__c = cam.Level_1_Approver_10__c,Level_1_Approver_11__c = cam.Level_1_Approver_11__c,Level_1_Approver_12__c = cam.Level_1_Approver_12__c,Customer_Account__c = CustId,Program__c =cam.Id,Status__c='Open');
                            businessUnitinsertRecords.add(businessUnitRecords);
                    }
            }else{
                for(campaign cam:campaignList){
                    if(newProgSet.contains(cam.Name)){
                        Deal_Registration__c businessUnitRecords = new Deal_Registration__c(name=opptyRT.Deal_Id__c+''+partnerAccountName.Name,Partner_Account__c=userPartnerAccount.Partner_account_ID__c,Business_Unit__c = cam.Business_Unit__c,Opportunity__c = oppId,Level_1_Approver_1__c = cam.Level_1_Approver_1__c,Partner_User_Location__c =userPartnerAccount.Location_Record_Id__c,Level_1_Approver_2__c = cam.Level_1_Approver_2__c,Level_1_Approver_3__c = cam.Level_1_Approver_3__c,Level_1_Approver_4__c = cam.Level_1_Approver_4__c,Level_1_Approver_5__c = cam.Level_1_Approver_5__c,Level_1_Approver_6__c = cam.Level_1_Approver_6__c,Level_1_Approver_7__c = cam.Level_1_Approver_7__c,Level_1_Approver_8__c = cam.Level_1_Approver_8__c,Level_1_Approver_9__c = cam.Level_1_Approver_9__c,Level_1_Approver_10__c = cam.Level_1_Approver_10__c,Level_1_Approver_11__c = cam.Level_1_Approver_11__c,Level_1_Approver_12__c = cam.Level_1_Approver_12__c,Customer_Account__c = CustId,Program__c =cam.Id,Status__c='Open');
                        businessUnitinsertRecords.add(businessUnitRecords);
                    }
                }
            }
            system.debug('n1b'+businessUnitinsertRecords);
            if(businessUnitinsertRecords != null){
                    if(businessUnitinsertRecords.size()>0){ 
                            insert businessUnitinsertRecords;            // insert new Deal Reg record.
                    }
            }
            //Creates set of Product Lines from the list of opportunity line items.
            if(opportunityBusinessUnit.size()>0){
                    for(OpportunityLineItem c: opportunityBusinessUnit){
                            if(c.Product_Line__c <> null && c.Product_Line__c <> '' && (c.Program_Code__c == null || c.Program_Code__c == '')){
                                    newProductLinesSet.add(c.Product_Line__c);     
                            }
                    }
            }
            system.debug('n1c'+newProductLinesSet);
            dealRegistrationList = [select Id,Status__c,Program__r.Name from Deal_Registration__c where opportunity__c=:oppid and Program__r.Name IN :selectedProgramList ];
            system.debug('y1b'+dealRegistrationList);
            if(newProductLinesSet.size()>0){
                prodRegList = [select Id,Deal_Registration__c,Program_Code__c,Product_Line__c from Product_Registration__c where Opportunity__c = :oppId and Product_Line__c IN :newProductLinesSet and Deal_Registration__r.Program__r.Name IN :selectedProgramList];
                system.debug('y1c'+prodRegList);
                if(prodRegList.size()>0){
                    for(Product_Registration__c prodRegListVar:prodRegList){
                        Product_Registration__c prodReg = new Product_Registration__c();
                        prodReg.id = prodRegListVar.id;
                        prodReg.Status__c = '';
                        updateProdRegList.add(prodReg);
                        if(progProdLinePRMap.containsKey(prodRegListVar.Program_Code__c)){
                            progProdLinePRMap.get(prodRegListVar.Program_Code__c).add(prodRegListVar.Product_Line__c);
                        }else{
                            progProdLinePRMap.put(prodRegListVar.Program_Code__c, new Set<String>());
                            progProdLinePRMap.get(prodRegListVar.Program_Code__c).add(prodRegListVar.Product_Line__c);
                        }
                    }
                    for(String selectedprogramListVar:selectedprogramList){
                        Set<String> progProdLineOLSet = new Set<String>();
                        Set<String> progProdLinePRSet = new Set<String>();
                        for(OpportunityLineItem OLVar:progOLMap.get(selectedprogramListVar)){
                            progProdLineOLSet.add(OLVar.Product_Line__c);
                        }   
                        system.debug('n1d'+progProdLineOLSet);
                        if(progProdLinePRMap.containsKey(selectedprogramListVar) && progOLMap.containsKey(selectedprogramListVar)){
                            progProdLinePRSet.addall(progProdLinePRMap.get(selectedprogramListVar));
                            progProdLineOLSet.removeAll(progProdLinePRSet);
                            system.debug('n1e'+progProdLineOLSet);
                        }
                        for(OpportunityLineItem finalOLVar:progOLMap.get(selectedprogramListVar)){
                            if(progProdLineOLSet.contains(finalOLVar.Product_Line__c)){
                                if(finalProgOLMap.containsKey(selectedprogramListVar)){
                                    finalProgOLMap.get(selectedprogramListVar).add(finalOLVar);
                                }else{
                                    finalProgOLMap.put(selectedprogramListVar, new List<OpportunityLineItem>());
                                    finalProgOLMap.get(selectedprogramListVar).add(finalOLVar);
                                }                                       
                            }
                            progProdLineOLSet.remove(finalOLVar.Product_Line__c);
                        }
                    }
                }else{
                    finalProgOLMap.putAll(progOLMap);
                }
                system.debug('y1d'+finalProgOLMap);
                for(Deal_Registration__c dealRegistrationListVar:dealRegistrationList){
                    system.debug('d1c'+dealRegistrationListVar.Program__r.Name);
                    if(finalProgOLMap.containsKey(dealRegistrationListVar.Program__r.Name)){
                        for(OpportunityLineItem OppLineVar:finalProgOLMap.get(dealRegistrationListVar.Program__r.Name)){
                            Product_Registration__c productRegistraionItem = new Product_Registration__c();
                            productRegistraionItem.Program_Code__c = dealRegistrationListVar.Program__r.Name;
                            productRegistraionItem.GBU__c = OppLineVar.GBU__c;
                            productRegistraionItem.Opportunity__c = OppLineVar.OpportunityId;
                            productRegistraionItem.Product_Line__c = OppLineVar.Product_Line__c;
                            productRegistraionItem.Business_Group__c = OppLineVar.Business_Group__c;
                            newProductRegistraionList.add(productRegistraionItem);                              
                        }
                    }
                }
            }
            
            system.debug('d1d'+newProductRegistraionList);   
            for(Deal_Registration__c dealRegistrationListVar:dealRegistrationList){                                 //Iterates on the newly added Deal Reg records
                for(Product_Registration__c newProductRegistraionListVar:newProductRegistraionList){                //Iterates on the newly added Product Reg records
                    system.debug('d1e'+newProductRegistraionListVar.Program_Code__c);
                    system.debug('d1f'+dealRegistrationListVar.Program__r.Name);
                    if(newProductRegistraionListVar.Program_Code__c == dealRegistrationListVar.Program__r.Name){
                        newProductRegistraionListVar.Deal_Registration__c = dealRegistrationListVar.Id;             //Relate Product Reg record with the appropriate Deal Reg record
                        newProdRegList.add(newProductRegistraionListVar);
                    }
                }
                dealRegistrationListVar.Status__c = 'Open';
                dealRegistrationListVar.Final_Approver__c = False;
                dealRegistrationListVar.Rejection_Reason__c = NULL;
                updateDRStatusList.add(dealRegistrationListVar);
            }
            system.debug('y1e'+newProdRegList);
            system.debug('y1f'+updateDRStatusList);
            update updateDRStatusList;
            if(newProdRegList.size()>0){
                insert newProdRegList;
            }
            update updateProdRegList;
                 
            //Initiate the approval process on Deal Registration record
            for(Deal_Registration__c d:updateDRStatusList){
                if(d.Status__c =='Open'){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setObjectId(d.id);
                    Approval.ProcessResult result = Approval.process(req1); 
                }
            }      
            PageReference Page=new PageReference('/apex/DealReg_Success_SubmissionPage?id='+oppId);
            page.setRedirect(true);
            allDealRegList = [select id,Program__r.Name,Program_Comments__c from Deal_Registration__c where Program__r.Name IN :selectedProgramList and Opportunity__c=:oppId];
            for(ProgramWrapper programWrapperVar : programList ){
                for(Deal_Registration__c allDealRegListVar:allDealRegList){
                    if(allDealRegListVar.Program__r.Name == programWrapperVar.selectedPrograms && programWrapperVar.programComments != NULL){
                        if(allDealRegListVar.Program_Comments__c == NULL){
                            allDealRegListVar.Program_Comments__c = programWrapperVar.programComments;
                        }else{
                            allDealRegListVar.Program_Comments__c = allDealRegListVar.Program_Comments__c + '-***-' + programWrapperVar.programComments;
                        }
                        updDRCommentList.add(allDealRegListVar);
                    }
                }
            }
            if(updDRCommentList.size()>0){
                update updDRCommentList;
            }
            
/*                boolean commentFlag=false;
            //update program comments   (Venkatesh Code)
            List<Deal_Registration__c> updateCommentList = new List<Deal_Registration__c>();

            for(ProgramWrapper programWrapper : programList ){
                if(programWrapper.isSelected){         
                    if(programWrapper.programComments!=null){
                        commentFlag=True;
                    }
                    List<Deal_Registration__c> updateComments =[select id,Program__r.Name,Program_Comments__c from Deal_Registration__c where Program__r.Name =:programWrapper.selectedPrograms and Opportunity__c=:oppId];
                    for(Deal_Registration__c comments: updateComments){
                        if(comments.Program__r.Name == programWrapper.selectedPrograms){
                            if(comments.Program_Comments__c == NULL){
                                comments.Program_Comments__c=programWrapper.programComments;
                            }else{
                                comments.Program_Comments__c=comments.Program_Comments__c + '-***-' + programWrapper.programComments;
                            }
                            updateCommentList.add(comments);                                
                        }
                    }
                }
            }

            try{
                    if(commentFlag){
                            update updateCommentList;
                    }
            }catch(Exception e){}
*/
        return Page;   
    }
        
        /*
         * This method is used to get the list of programs based on selected products.
         *@ return Programwrapper list
         */
        public List<Programwrapper> getProgram() {

                programList = new List<programwrapper>();
                List<Program_Product_Association__c> programProductMapList= new List<Program_Product_Association__c>();
                List<Program_Product_Association__c> programProduct= new List<Program_Product_Association__c>();
                List<Campaign> eligibleProgram=new list<Campaign>();
                List<String> programPartnerList = new List<String>();           
                Set<String> productLines = new set<String>();
                Set<String> programProductSet= new Set<String>();
                // Code for checking partner eligibility
                partnerUserIdValue = new User();

                partnerUserIdValue =[Select Partner_account_ID__c,Location_Record_Id__c from User where Id= :UserInfo.getUserId()]; 
                List<Program_Location_Association__c> programPartner =[Select Program__r.Name from Program_Location_Association__c where Location__c =:partnerUserIdValue.Location_Record_Id__c ];

                // check the partner eligibilty for a program
                for(Program_Location_Association__c pPartner:programPartner){
                        programPartnerList.add(pPartner.Program__r.Name);
                }

                opportunityLineItemList= [Select  GBU__c,ICOEM__c,Product_Line__c,ProductName__C,Program__c,FFYR_Margin_Amount__c,UnitPrice,Subtotal,Start_Date__c, OpportunityID__c, Business_Group__c, Product__c,ProductId__c ,Scope_Type__c   from OpportunityLineItem where OpportunityId= :oppId ];  


                for(OpportunityLineItem opportunityLineItem : opportunityLineItemList)
                {

                        productLines.add(opportunityLineItem.Product_Line__c);                
                }

                programProductMapList=[Select Program__r.Name, Product__r.Product_Line__c from Program_Product_Association__c where Product_Line__c in : productLines and Program__r.Name in:programPartnerList];   

                // Eliminating duplicate values from the program product list
                for(Program_Product_Association__c pList:programProductMapList){

                        if(!programProductSet.contains(pList.Program__r.Name)){
                                programProduct.add(pList);
                                programProductSet.add(pList.Program__r.Name);
                        }
                }
                // Check for allproducts eligible flag for eligible partner programs            
                List<Campaign> eligibleProgramList=[Select All_Products_Eligible__c,name,IsActive from Campaign where name in:programPartnerList];

                for(Campaign programForPartner:eligibleProgramList){
                        if(programForpartner.All_Products_Eligible__c=='Yes'){
                                programProductSet.add(programForPartner.name);
                        }
                }

                for(String programProductMapObj : programProductSet){
                        Set<String> productList =new Set<String>();
                        String productStatus;            
                        Campaign programId=[select id,isActive from Campaign where name=:programProductMapObj and isActive=True];
                        // code to check the program eligibilty based on the 'all product eligible' flag in campaign and program product association
                        eligibleProgram=[Select All_Products_Eligible__c,IsActive from Campaign where name =: programProductMapObj];

                        for(Campaign eligibility:eligibleProgram){
                                if(eligibility.IsActive){
                                        if(eligibility.All_Products_Eligible__c=='Yes') { 
                                                List<OpportunityLineItem>  productNameList=[select Product_Line__c from OpportunityLineItem where OpportunityId=:oppId];

                                                for(OpportunityLineItem productNames:productNameList){          
                                                        productList.add(productNames.Product_Line__c);  

                                                } 
                                                List<Product_Registration__c> productStatusList=[select Status__c from Product_Registration__c where opportunity__c=:oppId and Product_Line__c in:productList];

                                                if(productStatusList.size()!=productList.size()){
                                                        productStatus='New';
                                                }   

                                                programList.add(new ProgramWrapper(programId.id,programProductMapObj,productStatus,productList)); 
                                        }
                                        else
                                        {       
                                                List<Program_Product_Association__c> productListFromMAP=[Select Product__r.Product_Line__c from Program_Product_Association__c where Product_Line__c in :productLines and Program__r.Name=:programProductMapObj];
                                                for(Program_Product_Association__c productLineList:productListFromMAP ){       
                                                        productList.add(productLineList.Product__r.Product_Line__c); 

                                                } 
                                                List<Product_Registration__c> productStatusList=[select Status__c from Product_Registration__c where opportunity__c=:oppId and Product_Line__c in:productList];

                                                if(productStatusList.size()!=productList.size()){
                                                        productStatus='New';
                                                } 


                                                programList.add(new ProgramWrapper(programId.id,programProductMapObj,productStatus,productList));      

                                        }  // End of code venkatesh..
                                }
                        }
                }       
                return programList;

        }


        /*
         * This class used as a wrapper to consolidate the selected check box records as a helper
         */    
        public class ProgramWrapper
        {
                public Program_Product_Association__c program{get; set;}
                public String selectedPrograms{get;set;}
                public Boolean isSelected {get; set;}
                public Set<String> productList{get; set;}
                public String productStatus{get;set;}
                public String programComments {get; set;}
                public String selectedProgramId {get;set;}

                public ProgramWrapper(String id,String programMap,String status,Set<String> productLists)
                {
                        this.selectedPrograms = programMap;
                        this.productList=productLists;
                        this.productStatus=status;
                        this.selectedProgramId=id;
                }
        }
        // End of apply program code

        /**
         * @description used as wrapper class for storing data of each line
         */  
        public class wrapperLineItem {
                public OpportunityLineItem oli {get; set;}
                public String existingBusinessGroup {get; set;}
                public String existingGlobalBusinessUnit {get; set;}
                public String existingProductLine {get; set;}
                public String existingSubProductLine {get; set;}
                public Boolean selected {get; set;}
                public String productName {get; set;}
                public Boolean isNew {get; set;}
                public Boolean isService {get; set;}
                public String pricebookEntryId {get; set;}
                public Decimal RTSComponent {get;set;}
                public List<selectoption> gbupickvalues {get;set;}
                public List<selectoption> scopetypePickVals{get;set;}
                public Boolean isActive{set;get;}
                public String productlevel{set;get;}
                public List<ScopeType__c> scopetypepickvalues {get;set;}

                public wrapperLineItem (OpportunityLineItem c, String pName, String bg, String gbu, String pl, String spl, Boolean service,Map<String,List<String>> gbubgmap,Boolean active,String productlevel) {
                        gbuPickvalues=new List<SelectOption> ();
                        scopetypePickVals=new List<SelectOption> ();
                        oli = c;
                        selected = False;
                        productName = pName;
                        existingBusinessGroup = bg;
                        existingGlobalBusinessUnit = gbu;
                        if(gbubgmap!=null){
                                if(!gbubgmap.isEmpty()){
                                        List<String> gbuvallist=gbubgmap.get(bg);
                                        gbuvallist.sort();
                                        for(String gbuval: gbuvallist){
                                                gbuPickvalues.add(new SelectOption(gbuval, gbuval));
                                        }
                                }
                        }
                        // R6 code for Scope type functionality by Sudhakara reddy
                        try{
                            ScopeType__c sc=ScopeType__c.getInstance(existingBusinessGroup );
                            String sctype=String.valueOf(sc.List_of_Vales__c);
                            ScopetypePickVals.add(new selectoption('','None'));
                            for(String sct: sctype.split('\\,')){
                                scopetypePickVals.add(new selectoption(sct,sct));
                            }
                            
                        }catch(Exception e){}
                        //End R6 code for Scope type functionality 
                        existingProductLine = pl;
                        existingSubProductLine = spl;
                        isNew = false;
                        pricebookEntryId = '';
                        isService = service;
                        RTSComponent = c.RTS_Component__c;
                        isActive=active;
                        this.productlevel=productlevel;
                }
                
        } 
        /*******************************      
          Added for R4 
         ********************************/
        public void OnchangeofBG(){
                productlinename=null;
                subproductlinename=null;
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

                productlinename=null;
                subproductlinename=null;
                searchBusinessGroup=gbuandbgmap.get(searchGlobalBusinessUnit);          
        }
        public void Clearquickaddsection(){
                searchBusinessGroup=null;
                searchGlobalBusinessUnit=null;
                productlinename=null;
                subproductlinename=null;
                opplineitem.UnitPrice=null;
                quantity=1;
                opplineitem.ServiceDate=oppty.Closedate;

        }
        public PageReference changeGBUValues(){
                getGBUPicklistExist();
                newlyaddedlineitem=null;
                return null;
        }
        public void clearquickaddrecord(){
            newlyaddedlineitem=null;
        }
         /**
         * @description Used for ApplyProgram button visiblity
         */  
        
        public void ApplyProgramvisiblityForSave(set<Id> insertSuccessId){
                if(insertSuccessId.size()>0 && portalUser.isPortalEnabled){
                        insertedProduct= [Select product_line__c from OpportunityLineItem where Id in :insertSuccessId]; 
                        for(OpportunityLineItem opptyLineItem:insertedProduct){
                                insertedProductList.add(opptyLineItem.product_line__c);
                        }
                        programProductAssociation=[select program__r.name from Program_Product_Association__c where product__r.product_line__c IN :insertedProductList]; 
                        for(Program_Product_Association__c  P: programProductAssociation){
                                programName.add(P.program__r.name);
                        }      
                        // partnerUser =[Select Partner_account_ID__c,Location_Record_Id__c from User where Id= :UserInfo.getUserId()]; 
                        programLocationAssociation =[Select program__r.name,Program__r.isActive from Program_Location_Association__c where Location__C=:partnerUser.Location_Record_Id__c ];
                        eligibleProgramsList=new List<Campaign>();
                        allProductEligibleProgram=new List<string>();
                        for(Program_Location_Association__c progPatrner:programLocationAssociation){
                                allProductEligibleProgram.add(progPatrner.Program__r.name);
                        }
                        eligibleProgramsList=[Select All_Products_Eligible__c from Campaign where IsActive=True and All_Products_Eligible__c='Yes' and name in:allProductEligibleProgram];
                        if(eligibleProgramsList.size()>0){
                                programVisibilityFlag=True;
                        }else{

                                for(Program_Location_Association__c progPartnerMap: programLocationAssociation ){ 

                                        if(progPartnerMap.program__r.IsActive==true){
                                                programVisibilityFlag = programName.contains(progPartnerMap.program__r.name);
                                                if(programVisibilityFlag==True){
                                                        break;
                                                }
                                        }                         
                                }    
                        }
                }      
        }
}