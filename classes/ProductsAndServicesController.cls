/**
* Class Name: ProductsAndServicesController 
* Author: HP
* Date: 18-Sep-2012 
* Requirement # Request Id: 
* Description: Controller for Add,Search,View,Edit, Delete Products/Services and appply program for selected product and send for an approval
* Last Modified :Modified for Deal Registration 
*/
public class ProductsAndServicesController {  
    
    public string test{get;set;}
    /*List<Product_Registration__c> test = new List<Product_Registration__c>();
    public Opportunity oppty {get; set;}
    public Opportunity opp {get; set;}
    public user activeUser {get;set;}
    public OpportunityLineItem testOpptyProduct {get;set;}
    public string existingProductsQuery;
    public string oppId;
    private String sortExp = '';
    public String sortFullExp = '';
    private String sortDirection = Label.ASC;
    public string opptyCloseDate  {get;set;}
    public string action {get;set;}
    public String action0{get;set;}
    public integer tableWidth {get;set;}
    public Set<Id> restrictedSet;
    
    /* Added for Quote Functionality */
    /*public Boolean showSyncButton{get;set;}
    public opportunity objOpportunity;
    public User objUser{get;set;}
    public Boolean showRetain{get;set;}

    /* Created for CR-0139 - Stop SAP Functionality for RENEWALS  - 10th Aug 2012   */    
    /*public Id RecordTypeId {get; set;}
    public boolean IsRecordType {get;set;}
    
    /*Search Strings to search existing Line items*/
    //public string searchExistingBusinessGroup {get;set;}
  /*  public string searchExistingGlobalBusinessUnit {get;set;}*/
    /*public string searchExistingProductLine {get;set;}
    public string searchExistingSubProductLine {get;set;}
    
    /*Lists of Product Names for Success & Error Messages : Bulk Operation*/
    /*public list<string> listEditSuccess {get;set;}
    public list<string> listEditFailure {get;set;}
    public list<string> listDeleteSuccess {get;set;}
    public list<string> listDeleteFailure {get;set;}
    public list<string> listInsertSuccess {get;set;}
    public list<string> listInsertFailure {get;set;}
    public list<string> listDisassociateSuccess {get;set;}
    public list<string> listDisassociateFailure {get;set;}
    public list<string> listAssociationSuccess {get;set;}
    public list<string> listAssociationFailure {get;set;}
    
    /*Flags used on Page*/
    /*public boolean navigationFlag {get; set;}
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
    
    /*Line Item Lists & Wrapper Lists */
    /*public List<wrapperLineItem> existingLineItemList {get; set;}
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
    /*public Integer noOfRecordPerPage {get;set;}
    public Integer selectedPage {get;set;}
    public Map<Integer, List<wrapperLineItem>> mapOpportunityLineItems{get;set;}
    public List<selectoption> pagesOptions {get;set;}
        
    String searchExistingGlobalBusinessUnit;
    
   // Starting the Deal Registration code
    Public boolean isPartner{get;set;}
    public List<programwrapper> programList {get;set;}
    public List<OpportunityLineItem> selectedPrograms = new List<OpportunityLineItem>();
    public Boolean hasSelectedPrograms {get;set;}
    public Set<String> selProgramName {get;set;}
    public List<OpportunityLineItem> opportunityLineItemList = new List<OpportunityLineItem>(); 
    public User partnerUserIdValue{get;set;}   
   // End of the Deal Registration code
    

    public String getsearchExistingGlobalBusinessUnit () { return this.searchExistingGlobalBusinessUnit ; }
    public void setsearchExistingGlobalBusinessUnit (String s) { this.searchExistingGlobalBusinessUnit = s; }
  
  
     Public boolean ApplyProgramFlag{get;set;}
     list<OpportunityLineItem> insertedProduct= new list<OpportunityLineItem>();
     public Opportunity opty=new Opportunity();
     
     
     public List<String> programProductAssociationIds{get;set;}
     User partnerUser = new User();
     List<Program_Partner_Association__c> programPatnerAssociation=  new List<Program_Partner_Association__c>();
     list<Program_Product_Association__c> programProductAssociation=new list<Program_Product_Association__c>();
     public boolean programVisibilityFlag{get;set;}
     
     List<Campaign> eligibleProgramsList=new List<Campaign>();
     List<Campaign> eligibleProgramsList1=new List<Campaign>();
     List<string> allProductEligibleProgram=new List<string>();
   

    public void nextPage(){
        
    }
    /**
    * @description: fetches restricted profiles from custom setting
    * 
    */
    /*private Static Set<Id> getRestrictedProfileSet(){
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
    /*private Static String convertTo15Digit(String paramID){
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
    /*public void opptyAccess(){
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
    /*public void viewData(){
        sortFullExp = sortExpression  + ' ' + sortDirection;
        generateQuery();
        //String qry = Label.Existing_Line_Items_Query + '\'' + oppId + '\' order by '+ sortFullExp;
    }
        
    /**
    * @description: sort Expression from VF Page
    * @return: expression on which sorting is to be done
    * 
    */
    /*public String sortExpression{
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
    /*public String getSortDirection(){
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
    /*public void setSortDirection(String value){  
        sortDirection = value;
    }
    
     public ProductsAndServicesController() {
      
         oppId = ApexPages.currentPage().getParameters().get('id');
      }
    
    
    /**
    * @description: Class Constructor method
    * @param StandardController Apex Page
    * 
    */
    /*public ProductsAndServicesController(ApexPages.StandardController controller) {
        
        showRetain = true;
        objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
        if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.Restrict_Sync_Functionality).contains(objUser.Business_Group__c+':'+objUser.Region__c)){
            showRetain=false;
            
        }
        
        oppId = ApexPages.currentPage().getParameters().get('oppId');
        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId(); 
        partnerUser =[Select id,Partner_account_ID__c,IsportalEnabled from User where Id= :UserInfo.getUserId()]; 
        opty = [select CloseDate,ownerid from Opportunity where id=:oppId];       
        convertCurrencyFlag = false;
        tableWidth = 1450;
        oppty = fetchOpptyStatistics();
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
        cancelUpdate();
        recordTypeFlag();
        applyProgramVisibility();
        RTSSpecificFlag=false;
        
        List<Opportunity> o=[Select id, Renewal_Type__C From Opportunity Where id=:oppId];
        
        if(o[0].Renewal_Type__c== 'SW Renewal'){
            collapsibleFlag0 = true;
        }
            
        else{
            collapsibleFlag0 = false;
        }
    }
    
    /**
    * @description: Applying programs for the selected products if the user is eligible. 
    * @return: page is returned to DealReg_AddPromotionForProduct
    * 
    */
    /*public PageReference applyPrograms(){  
    
           
           
           if(opty.CloseDate < System.today()){
          
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Opportunity Close date in the past, program cannot be applied'));
          
           return null;
           }else{     
           Opportunity optylists = new Opportunity();      
           optylists= [select Deal_Registration_Status__c from Opportunity where id=:oppId];
           opportunityLineItemList= [Select UnitPrice from OpportunityLineItem where OpportunityId= :oppId ];  
           List<Decimal> unitPriceList=new List<Decimal>();
           for(OpportunityLineItem opportunityLineItem : opportunityLineItemList){
               if(opportunityLineItem.UnitPrice<=0.00){
                  unitPriceList.add(opportunityLineItem.UnitPrice);
               }
           }
           if(optylists.Deal_Registration_Status__c =='Submitted' || optylists.Deal_Registration_Status__c =='Review Initiated'){
              Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.DEAL_UNDER_PROGRESS)); 
              return null;
           }else if(unitPriceList.size()>0){             
                  Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.UNITPRICE_REQUIRED)); 
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
        /*public void applyProgramVisibility(){ 
        //opty = [select CloseDate,ownerid from Opportunity where id=:oppId];
         
         
          partnerUser = new User();
          programPatnerAssociation=  new List<Program_Partner_Association__c>();
          programProductAssociationIds=new List<String>();
          programProductAssociation=new list<Program_Product_Association__c>();
          Profile profileName = [SELECT Name FROM Profile WHERE Id = :Userinfo.getProfileId()];
          partnerUser =[Select Partner_account_ID__c,IsportalEnabled from User where Id= :UserInfo.getUserId()];   
          if(partnerUser.isPortalEnabled==true && opty.ownerId==partnerUser.Id){          
             programPatnerAssociation=[Select  Program__c, Program__r.name,Program__r.isActive  from Program_Partner_Association__c where Partner__c=:partnerUser.Partner_account_ID__c ];               
             try{           
                 for(OpportunityLineItem opptyProduct:[Select product_line__c from OpportunityLineItem where OpportunityId=:oppId]){
                     programProductAssociationIds.add(opptyProduct.product_line__c );        
                 }
                 programProductAssociation=[select program__r.name from Program_Product_Association__c where Product__r.product_line__c IN :programProductAssociationIds]; 
                 Set<string> programName = new Set<string>();
                 for(Program_Product_Association__c  programProduct: programProductAssociation){
                     programName.add(programProduct.program__r.name);
                 }  
                 
                 for(Program_Partner_Association__c programPartner: programPatnerAssociation ){
                   if(programPartner.program__r.isActive==true){
                     programVisibilityFlag = programName.contains(programPartner.program__r.name);          
                     if(programVisibilityFlag==true){
                        break;                   
                     }
                   }
                 }
                 if(programProductAssociationIds.size()!=0){
                    eligibleProgramsList=new List<Campaign>();
                    eligibleProgramsList1=new List<Campaign>();
                    allProductEligibleProgram=new List<string>();
                    for(Program_Partner_Association__c pPatrner:programPatnerAssociation){
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
    /*public List<SelectOption> getBGPicklist() {
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
    /*public List<SelectOption> getGBUPicklist() {
        List<SelectOption> optionsGBU = new List<SelectOption>();
        optionsGBU.add(new SelectOption('None','--None--'));
        List<OpportunityLineItem> allLineItems = new List<OpportunityLineItem>();
        Set<String> allGBU = new Set<String>();
        allLineItems = [Select Id, PricebookEntry.Product2.Business_Group__c, PricebookEntry.Product2.GBU__c from OpportunityLineItem where OpportunityId =: oppId]; 
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
    /*public void recordTypeFlag(){
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
    /*public Opportunity fetchOpptyStatistics() {
        
        Opportunity op;
        op = [Select Name, Id, SW_Premier__c, CloseDate, StageName, Total_First_12_Month_Value__c,  CurrencyIsoCode, Total_First_Fiscal_Yr_Value__c, Total_Margin_Amount__c,Total_Margin_Percentage__c, Amount, RecordtypeId, SAP_Feed__c from Opportunity where id =: oppId];
        activeUser = [Select Name, Id, CurrencyIsoCode,Global_Business_Unit__c, DefaultCurrencyIsoCode from User where Id=: userinfo.getuserid()];
        if (activeUser.DefaultCurrencyIsoCode != op.CurrencyIsoCode){
            opp = [Select Name, Id, CloseDate, StageName, ConvertCurrency(Total_First_12_Month_Value__c),  CurrencyIsoCode, ConvertCurrency(Total_First_Fiscal_Yr_Value__c), ConvertCurrency(Total_Margin_Amount__c), Total_Margin_Percentage__c, ConvertCurrency(Amount), RecordtypeId, SAP_Feed__c from Opportunity where id =: oppId];
            convertCurrencyFlag = true;
        }
        return op;   
    }
    /**
    * @description:  To get new statistics on Opportunity after Line Items Delete
    * @return: Opportunity
    * 
    */
    /*public PageReference newOpptyStatistics() {
        oppty = fetchOpptyStatistics();
        return null;
    }
    /**
    * @description:  To generate Query for displaying only seached line items on the Page
    * @return: String
    * 
    */
    /*public void generateQuery() {
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
    /*public Map<Integer, List<wrapperLineItem>> getOpportunityLineItems() {
        navigationFlag = true;
        largeResultFlag = false;
        masterCheckboxFlag = false;
        existingLineItemList = new List<wrapperLineItem>();
        List<wrapperLineItem> blankLineItemList = new List<wrapperLineItem>();
        existingProductsQuery ='';
        generateQuery();  
        mapOpportunityLineItems =new Map<Integer, List<wrapperLineItem>> ();
        noOfRecordPerPage = 15;
        
        /*Append Blank row above*/    
        /*if(newLineItemList != null){
            existingLineItemList.addAll(newLineItemList);
        }
        system.debug('>>>>>>>EXISTINGLIST'+newLineItemList);
        /*Display Line Items*/    
        /*try{
            for(OpportunityLineItem li : Database.query(existingProductsQuery)) {
            existingLineItemList.add(new wrapperLineItem(li,li.PricebookEntry.Product2.Name,li.PricebookEntry.Product2.Business_Group__c,li.PricebookEntry.Product2.GBU__c,
                                                     li.PricebookEntry.Product2.Product_Line__c,li.PricebookEntry.Product2.Sub_Product_Line__c,li.PricebookEntry.Product2.Service__c));
            }
        }Catch(Exception exp){
            system.debug('Exception Occured while fetching Line Items: '+exp.getMessage());
        }                    
        
        if (existingLineItemList.size() == 0){
            selectedPage = 1;
            mapOpportunityLineItems.put(1, blankLineItemList);
            noResultsFlag = true;
        }else{
            noResultsFlag = false;
        }
        /*keep Unprocessed line items checked*/
        /*for (wrapperLineItem w: existingLineItemList){
            if(lineitemIds.contains(w.oli.Id)|| edittedLineitemIds.contains(w.oli.Id) || pendingLineitemIds.contains(w.oli.Id)){
            w.Selected = true;
            }
        }
        /*Paginating all the Opportunity Line Items*/
        /*if(existingLineItemList.size()>0){
            pagesOptions = new List<SelectOption>();
            integer total_no_of_pages = existingLineItemList.size()/noOfRecordPerPage;                 
            if(math.mod(existingLineItemList.size(),noOfRecordPerPage) > 0){
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
            integer pageEndValue = noOfRecordPerPage;
            for(integer i = 0; i<total_no_of_pages ; i++){
                integer counter = i+1;
                pagesOptions.add(new SelectOption(counter+'',counter +''));
                List<wrapperLineItem> OpportunityLineItemList = new List<wrapperLineItem>();
                for(integer j = pageStartValue ; j< pageEndValue; j++){
                    try{
                        OpportunityLineItemList.add(existingLineItemList[j]);
                    }catch(Exception e) {
                    }
                }
                pageStartValue = pageEndValue;
                pageEndValue = noOfRecordPerPage*(i+2);
                mapOpportunityLineItems.put(counter,OpportunityLineItemList);
                if(mapOpportunityLineItems.get(selectedPage)!= null){
                    if ((mapOpportunityLineItems.get(selectedPage).size() >= noOfRecordPerPage) && (newLineItemList.size()== 0) && (existingLineItemList.size() != noOfRecordPerPage)){
                        largeResultFlag = true;
                    }
                }
            }
        }
        return mapOpportunityLineItems;
    }
    /**
    * @description:  To clear all Search values on Page
    * @return: Null
    * 
    */
    /*public pagereference clearAllSearch() {
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
    /*public PageReference cancelUpdate() {
        deletedLineitemIds = new Set<Id>();
        edittedLineitemIds = new Set<Id>();
        pendingLineitemIds = new Set<Id>();
        lineitemIds = new Set<Id>();
        testOpptyProduct.ServiceDate = null;
        collapsibleFlag = true;
        newLineItemList = new List<wrapperLineItem>();
        clearAllFlags();
        return null;
    }
    
    /**
    * @description:  To display RTS Specific Info as per OMPM Renewal R3.o
    * @Owner: Deepak Saxena
    * @return: Null
    * 
    */
   /* public PageReference displayRTSInfo() {
        if (RTSSpecificFlag == false){
            RTSSpecificFlag = true;
            EsSpecificFlag = false;
            tableWidth = 1800;
            action0 = 'Collapse';
            action='View';
        } else if(RTSSpecificFlag == true){
            RTSSpecificFlag = false;
            tableWidth = 1450;
            action0 = 'View';
        }    
        return null;
    }
    
    /**
    * @description:  To display ES Specific Info
    * @return: Null
    * 
    */
    /*public PageReference displayEsInfo() {
        if (EsSpecificFlag == false){
            EsSpecificFlag = true;
            RTSSpecificFlag = false;
            tableWidth = 1800;
            action = 'Collapse';
            action0='View';
        } else if(EsSpecificFlag == true){
            EsSpecificFlag = false;
            tableWidth = 1450;
            action = 'View';
        }    
        return null;
    }
    /**
    * @description:  To clear all Messages on Page
    * @return: Null
    * 
    */
    /*public PageReference clearAllFlags() {
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
        return null;
    }
    /**
    * @description:  To add a new row inorder to associate New Product/Service
    * @return: Null
    * 
    */
    /*public PageReference addRow() {
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
        newLineItemList.add(new wrapperLineItem(newOpptLineItem,'','','','','',false));   
        for (wrapperLineItem lil : newLineItemList){
            lil.selected=true; 
            lil.isNew = true;
        }
        /*for (wrapperLineItem oliItm : existingLineItemList){
             if (oliItm.selected==true){
                 pendingLineitemIds.add(oliItm.oli.Id); 
             } 
            
        }*/
        /*}
        return null;    
    }
    /**
    * @description:  To associate a New Product on Page & Disassociate
    * @return: Null
    * 
    */
    /*public PageReference associateAndDelete() {
        System.Savepoint sp1 = null;
        listDisassociateSuccess = new list<string>();
        listDisassociateFailure = new list<string>();
        listAssociationSuccess = new list<string>();
        listAssociationFailure = new list<string>();
        set<String> deleteInsertErrorMessage = new set<String>();
        set<String> insertDeleteErrorMessage = new set<String>();
        set<Id> deleteInsertSuccessId = new set<Id>();
        set<Id> insertDeleteSuccessId = new set<Id>();
        list<PricebookEntry> tempPbSuccess = new List<PricebookEntry>();
        list<PricebookEntry> tempPbFailure = new List<PricebookEntry>();
        Set<String> tempPbSuccessId = new Set<String>();
        Set<String> tempPbFailureId = new Set<String>();
        
        /*Try association of new product only if disassociation Successful*/
        /*if(deletedLineItemList.size()>0){
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
        return null;
    }
    /**
    * @description:  To disassociate existing Product on Page & Add new
    * @return: Null
    * 
    */
    /*public PageReference deleteAndAssociate() {
        System.Savepoint sp = null;
        listDisassociateSuccess = new list<string>();
        listDisassociateFailure = new list<string>();
        listAssociationSuccess = new list<string>();
        listAssociationFailure = new list<string>();
        set<String> deleteInsertErrorMessage = new set<String>();
        set<String> insertDeleteErrorMessage = new set<String>();
        set<Id> deleteInsertSuccessId = new set<Id>();
        set<Id> insertDeleteSuccessId = new set<Id>();
        list<PricebookEntry> tempPbSuccess = new List<PricebookEntry>();
        list<PricebookEntry> tempPbFailure = new List<PricebookEntry>();
        Set<String> tempPbSuccessId = new Set<String>();
        Set<String> tempPbFailureId = new Set<String>();
        sp = Database.setSavepoint();
        if (deleteAndInsertLineItems.size()>0){
            try{
     /***************Commented by Deepak Saxena OMPM Renewal R3.0********************/
     /***************This commented statement has been put above the if block********/
                //sp = Database.setSavepoint();
                /*Database.DeleteResult[] delResults = database.delete(deleteAndInsertLineItems,false);
                for (Database.DeleteResult delResult : delResults) {
                    if (delResult.isSuccess()) {
                        insertDeleteSuccessId.add(delResult.getId()); 
                        isDeleteBeforeInsertFlag = true;
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
        /*if(deletedLineItemList.size()>0 && listDisassociateFailure.size()==0){
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
        return null;
    }
    /**
    * @description:  To save the new Product/Service added on New Row.And checking products and partner having eligiblity for programs.
    * @return: Null
    * 
    */
    /*public PageReference saveNewProducts() {
        
        list<PricebookEntry> tempPbEntrySuccess = new List<PricebookEntry>();
        list<PricebookEntry> tempPbEntryFailure = new List<PricebookEntry>();
        Set<String> tempPbEntrySuccessId = new Set<String>();
        Set<String> tempPbEntryFailureId = new Set<String>();
        listInsertSuccess = new List<string>();
        listInsertFailure = new List<string>();
        set<String> insertErrorMessage = new set<String>();
        set<Id> insertSuccessId = new set<Id>();
        
        programProductAssociation=new list<Program_Product_Association__c>();
        programPatnerAssociation =new List<Program_Partner_Association__c>();
        partnerUser = new User();
        insertedProduct= new list<OpportunityLineItem>();  
        set<string> programName = new set<string>();              
        list<String> insertedProductList= new list<String>();                
        
        if (newLineItems.size()>0){
            try{
                Database.SaveResult[] results = database.insert(newLineItems,false);
                for (Database.SaveResult result : results) {
                    if (result.isSuccess()) {
                        insertSuccessId.add(result.getId()); 
                        isInsertedFlag = true;
                    } 
                    if (!result.isSuccess()) {
                        isInsertFailureFlag = true;
                        Database.Error[] insErrors = result.getErrors();
                        for(Database.Error er : insErrors){
                            insertErrorMessage.add(er.getMessage());
                        }
                    }    
                }
                if(insertSuccessId.size()>0 && opty.ownerId==partnerUser.Id){
                insertedProduct= [Select product_line__c from OpportunityLineItem where Id in :insertSuccessId]; 
                for(OpportunityLineItem opptyLineItem:insertedProduct){
                insertedProductList.add(opptyLineItem.product_line__c);
                }
                programProductAssociation=[select program__r.name from Program_Product_Association__c where product__r.product_line__c IN :insertedProductList]; 
                for(Program_Product_Association__c  P: programProductAssociation){
                        programName.add(P.program__r.name);
                }      
                partnerUser =[Select Partner_account_ID__c from User where Id= :UserInfo.getUserId()]; 
                programPatnerAssociation =[Select program__r.name,Program__r.isActive from Program_Partner_Association__c where partner__c=:partnerUser.Partner_account_ID__c ];
                eligibleProgramsList=new List<Campaign>();
                eligibleProgramsList1=new List<Campaign>();
                allProductEligibleProgram=new List<string>();
                for(Program_Partner_Association__c progPatrner:programPatnerAssociation){
                        allProductEligibleProgram.add(progPatrner.Program__r.name);
                }
                eligibleProgramsList=[Select All_Products_Eligible__c from Campaign where IsActive=True and All_Products_Eligible__c='Yes' and name in:allProductEligibleProgram];
                if(eligibleProgramsList.size()>0){
                programVisibilityFlag=True;
                }else{
                      
                      for(Program_Partner_Association__c progPartnerMap: programPatnerAssociation ){ 
                     
                         if(progPartnerMap.program__r.IsActive==true){
                         programVisibilityFlag = programName.contains(progPartnerMap.program__r.name);
                         if(programVisibilityFlag==True){
                         break;
                         }
                       }                         
                     }    
                 }
                }                   
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
                /*Integer i;
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
                    system.debug('***');
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
    /*public PageReference saveInline() {
    Opportunity optylists = new Opportunity();
      
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
        /*for(wrapperLineItem wItem : existingLineItemList) {
            
            /****** OMPM Renewal R3.0******* Owner: Deepak Saxena********Open*********/
            /*if(wItem.oli.RTS_Component__c==null){
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
            /*system.debug('ITEMTOEDIT'+wItem);
            if(wItem.Selected == true && wItem.isNew == false) {
                system.debug('** insdie for before edit lineitem');
                edittedLineItems.add(wItem.oli);
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
                        system.debug('** before deleteAndInsertLineItems ');
                        deleteAndInsertLineItems.add(wItem.oli);
                        OpportunityLineItem ol = new OpportunityLineItem();
                        ol.OpportunityId = oppty.Id;
                        ol.Quantity = wItem.oli.Quantity;
                        ol.UnitPrice =  wItem.oli.UnitPrice;
                        ol.First_Fiscal_Year_Value__c = wItem.oli.First_Fiscal_Year_Value__c;
                        ol.Margin_Amount__c = wItem.oli.Margin_Amount__c;
                        ol.PricebookEntryId = wItem.pricebookEntryId;
                        ol.serviceDate = wItem.oli.serviceDate;
                        if (wItem.isService == true){
                            ol.Start_Date__c = wItem.oli.Start_Date__c;
                            ol.End_Date__c = wItem.oli.End_Date__c;
                            ol.Attach__c = wItem.oli.Attach__c;
                            ol.First_12_Month_Value__c = wItem.oli.First_12_Month_Value__c;
                        }
                        deletedLineItemList.add(new wrapperLineItem(ol,'',wItem.existingBusinessGroup,wItem.existingGlobalBusinessUnit,wItem.existingProductLine,wItem.existingSubProductLine,wItem.isService));
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
        /*Integer j;
        Integer listSize = newLineItemList.size();
        for (j=listSize; j > 0 ; j--) {
            if (newLineItemList[j-1].Selected == false && newLineItemList[j-1].isNew == true){
                newLineItemList.remove(j-1);
            } 
        }
        /* Inserting Editted Line Items*/
        /*if(edittedLineItems.size()> 0) {
            try{
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
        /*Calling Method to Save New Products*/
        /*if (newLineItems.size()>0){
            saveNewProducts();
        }
        /*Calling Method to Associate New & Delete Existing*/
        /*if (deleteAndInsertLineItems.size()>0 && totalAssociationValue == 0){
            associateAndDelete();
        /*Calling Method to Delete Existing & Associate New*/
        /*}else if (deleteAndInsertLineItems.size()>0){
            deleteAndAssociate();
        }
        }
        return null;
    } 
    /**
    * @description:  To delete the existing Product/Service associated
    * @return: Null
    * 
    */
    /*public PageReference DeleteSelected() {
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
        for(wrapperLineItem wLine : existingLineItemList) {
            if(wLine.selected == true && wLine.oli.Id != null) {
                if(wLine.isNew == false){
                    lineItemsToDelete.add(wLine.oli);
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
        /*if (lineItemsToDelete.size() > 0) {
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
                /*for (OpportunityLineItem oplin : lineItemsToDelete){
                     if(successDeleteId.contains(oplin.Id)){
                         listDeleteSuccess.add(oplin.PricebookEntry.Product2.Name);
                         //isDeletedFlag = true;
                     }else {
                         lineitemIds.add(oplin.Id);
                         listDeleteFailure.add(oplin.PricebookEntry.Product2.Name);
                     }
                }
                /*Displaying error messages*/
                /*for (String delErrMsg : deleteErrorMessage){
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
            applyProgramVisibility();
            }
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
  /*public PageReference doCancel() {
 
     pagereference ref=new pagereference('/apex/ProductsAndServices?oppId='+oppId);
        ref.setredirect(true);
        return ref;  
    }
     
      
  /*
  * This method used to submit the deal for an approval
  */
  /*public PageReference doSubmitBusinessUnit()
        {           
        User userPartnerAccount = new User();
        Account partnerAccountName = new Account();
        Opportunity dealId = new Opportunity();       
        Set<String> ProgramIds = new Set<String>();
        Set<String> newProductLinesSet = new Set<String>();
        Set<String> businessUnitName = new Set<String>();
        Set<ID> L1AppId;
        List<String> productId= new List<String>(); 
        List<Deal_Registration__c> duplicateDealRegistrationList = new List<Deal_Registration__c>();
        List<Product_Registration__c> newProductRegistraionList = new List<Product_Registration__c>();
        List<String> newProductLinesList = new List<String>();
        List<Product_Registration__c> duplicateProductRegistrationList = new List<Product_Registration__c>();
        List<Deal_Registration__c> dealRegistraionItem = new List<Deal_Registration__c>();
        List<Deal_Registration__c> forUpdateDealRegistrationStatus = new List<Deal_Registration__c>();
        List<Product_Registration__c> forUpdateProductRegistraionList = new List<Product_Registration__c>();
        List<Deal_Registration__c> businessUnitinsertRecords = new List<Deal_Registration__c >();
        List<OpportunityLineItem> opportunityBusinessUnit = new List<OpportunityLineItem>();
        List<String> businessUnitList = new List<String>();
        Map<String, ID> businessUnitApproverMap = new Map<String, ID>();
        List<Campaign> campaignList = new List<Campaign>(); 
        Id CustId; // Initiated this variable to store Customer Account Id selected at Oppty Level
       // code starts from here
       hasSelectedPrograms = false;
       Opportunity oppItem = [select Deal_Registration_Status__c from Opportunity where id=:oppId];
        if(oppItem.Deal_Registration_Status__c == 'Submitted'){           
            ApexPages.Message errorMsg= new ApexPages.Message(ApexPages.Severity.INFO,'Cannot resubmit the deal');
            return null;
          }
         List<String> selectedProgramList= new List<String>();
        
         for(ProgramWrapper programWrapper : programList ){
           
          if(programWrapper.isSelected){

           Set<String> productLineSelected=programWrapper.productList;
           selectedProgramList.add(programWrapper.selectedPrograms);

        try{
           List<OpportunityLineItem> selectedPrograms = [SELECT OpportunityId,Product__c,Program_Code__c FROM OpportunityLineItem WHERE Product_Line__c IN:productLineSelected AND OpportunityId=:oppId];
           List<OpportunityLineItem> updateOpty = new List<OpportunityLineItem>();
                    
                    for(OpportunityLineItem selectedOptyLineIteam:selectedPrograms)
                       {
                          selectedOptyLineIteam.Program_Code__c = programWrapper.selectedPrograms;   
                           updateOpty.add(selectedOptyLineIteam);
                       }
           }
         catch(Exception e){
                    System.debug(e);
                  }
                  
      if(programWrapper.isSelected){
            hasSelectedPrograms = true;        
                  }
           }     //End of Venkatesh code  
     }
        
   // Below lines of code updates the Opportunity Record Type and auto generates Deal Id
        try{
            Opportunity opptyRT = [select Opportunity_ID__c,RecordType.Name,AccountId from Opportunity where Id=: oppId];
            string oppIDNumber = OpptyRT.Opportunity_ID__c;
            CustId = opptyRT.AccountId;
            RecordType DealRT = [select Id from RecordType where Name ='Partner Deal' and SobjectType = 'Opportunity'];
            opptyRT.RecordTypeId = DealRT.Id; 
            opptyRT.Deal_Id__c = 'REG-' + oppIDNumber.substringAfter('-');
            Update opptyRT;
         }
         catch(Exception e){
             System.debug(e);
         }
           
    /* Start---Lines below are used to create records in Deal_Registration and Product_Registration objects and 
     * initiate the approval process on Deal_Registration object  
     */ 
      
        /*opportunityBusinessUnit= [Select  Id,Product_Line__c,GBU__c,Program_Code__c, OpportunityId,Business_Group__c, Product__c from OpportunityLineItem where OpportunityId= :oppId ]; 
        userPartnerAccount=[select Partner_account_ID__c from user where id=:UserInfo.getUserId()]; 
        partnerAccountName = [select Name from Account where Id =:userPartnerAccount.Partner_account_ID__c];
    
        for(Integer i=0;i<opportunityBusinessUnit.size();i++){       
            productId.add(opportunityBusinessUnit[i].id );                    
        }
       
        campaignList = [Select Level_1_Approver_1__c,Level_1_Approver_2__c,Level_1_Approver_3__c,Level_1_Approver_4__c,Level_1_Approver_5__c,Level_1_Approver_6__c,Level_1_Approver_7__c,Level_1_Approver_8__c,Level_1_Approver_9__c,Level_1_Approver_10__c,Level_1_Approver_11__c,Level_1_Approver_12__c,Business_Unit__c from Campaign where Name In:selectedProgramList];                     
        duplicateDealRegistrationList = [select Id from Deal_Registration__c where Opportunity__c = :oppId and Program__r.Name IN :selectedProgramList];            
        dealId=[select Deal_Id__c from Opportunity where id=:oppId];
        
        //Creates a new deal reg record if there is no existing one.
        if(duplicateDealRegistrationList.size()==0){
            for(campaign cam:campaignList){
                Deal_Registration__c businessUnitRecords = new Deal_Registration__c(name=dealId.Deal_Id__c+''+partnerAccountName.Name,Partner_Account__c=userPartnerAccount.Partner_account_ID__c,Business_Unit__c = cam.Business_Unit__c,Opportunity__c = oppId,Level_1_Approver_1__c = cam.Level_1_Approver_1__c,Level_1_Approver_2__c = cam.Level_1_Approver_2__c,Level_1_Approver_3__c = cam.Level_1_Approver_3__c,Level_1_Approver_4__c = cam.Level_1_Approver_4__c,Level_1_Approver_5__c = cam.Level_1_Approver_5__c,Level_1_Approver_6__c = cam.Level_1_Approver_6__c,Level_1_Approver_7__c = cam.Level_1_Approver_7__c,Level_1_Approver_8__c = cam.Level_1_Approver_8__c,Level_1_Approver_9__c = cam.Level_1_Approver_9__c,Level_1_Approver_10__c = cam.Level_1_Approver_10__c,Level_1_Approver_11__c = cam.Level_1_Approver_11__c,Level_1_Approver_12__c = cam.Level_1_Approver_12__c,Customer_Account__c = CustId,Program__c =cam.Id,Status__c='Open');
                businessUnitinsertRecords.add(businessUnitRecords);
            }
        }

        if(businessUnitinsertRecords != null){
            if(businessUnitinsertRecords.size()>0){ 
                insert businessUnitinsertRecords;            // insert new Deal Reg record.
            }
        }
        
        //Creates set of Product Lines from the list of Opportunity line items.
        if(opportunityBusinessUnit.size()>0){
            for(OpportunityLineItem c: opportunityBusinessUnit){
                if(c.Product_Line__c <> null && c.Product_Line__c <> '' && (c.Program_Code__c == null || c.Program_Code__c == '')){
                    newProductLinesSet.add(c.Product_Line__c);     
                }
            }
        }

        if(newProductLinesSet.size()>0){
            newProductLinesList.addall(newProductLinesSet);
            duplicateProductRegistrationList = [select Id from Product_Registration__c where Opportunity__c = :oppId and Product_Line__c IN :newProductLinesList];
            
            //Creates a new Product Reg record if there is no existing one for a given Deal Reg record.
            if(duplicateProductRegistrationList.size()==0){
                for(OpportunityLineItem lineItem:opportunityBusinessUnit){
                    for(integer i=0;i<newProductLinesList.size();i++){
                        if(lineItem.Product_Line__c == newProductLinesList[i]){
                            for(String selectedProgramsforProductRegistration : selectedprogramList){                           //Iterates on the list of selected programs
                                for(ProgramWrapper programWrapperItem: programList){                                            //Iterates on the complete program-product wrapper list
                                    if(programWrapperItem.selectedPrograms == selectedProgramsforProductRegistration){          
                                        for(String productLineforProductReg :programWrapperItem.productList){                   //Iterates on the list of products of the selected program from the program-product wrapper
                                            Product_Registration__c productRegistraionItem = new Product_Registration__c();
                                            if (productLineforProductReg == lineItem.Product_Line__c){
                                                productRegistraionItem.Program_Code__c = programWrapperItem.selectedPrograms;
                                                productRegistraionItem.GBU__c = lineItem.GBU__c;
                                                productRegistraionItem.Opportunity__c = lineItem.OpportunityId;
                                                productRegistraionItem.Product_Line__c = lineItem.Product_Line__c;
                                                productRegistraionItem.Business_Group__c = lineItem.Business_Group__c;
                                                newProductRegistraionList.add(productRegistraionItem);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
            
        dealRegistraionItem=[select Status__c,Business_Unit__c,opportunity__c,Program__r.Name from Deal_Registration__c where opportunity__c=:oppid];

        if(newProductRegistraionList.size()!=0){
            for(Deal_Registration__c d:dealRegistraionItem){                    //Iterates on the newly added Deal Reg records
                for(Product_Registration__c p:newProductRegistraionList){       //Iterates on the newly added Product Reg records
                    if(p.Program_Code__c == d.Program__r.Name){
                        p.Deal_Registration__c = d.Id;                          //Relate Product Reg record with the appropriate Deal Reg record
                       forUpdateProductRegistraionList.add(p);
                    }
                }
            }
            insert forUpdateProductRegistraionList;
        }
                
      //Initiate the approval process on Deal Registration record
        for(Deal_Registration__c d:businessUnitinsertRecords){
            if(d.Status__c =='Open'){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setObjectId(d.id);
                Approval.ProcessResult result = Approval.process(req1); 
            }
        }      
        
        PageReference Page=new PageReference('/apex/DealReg_Success_SubmissionPage?id='+oppId);
        page.setRedirect(true);
 
       boolean commentFlag=false;
       //update program comments
       List<Deal_Registration__c> updateCommentList = new List<Deal_Registration__c>();

       for(ProgramWrapper programWrapper : programList ){
           
         if(programWrapper.isSelected){         
             if(programWrapper.programComments!=null){
              commentFlag=True;
             }
          List<Deal_Registration__c> updateComments =[select id,Program__r.Name,Program_Comments__c from Deal_Registration__c where Program__r.Name =:programWrapper.selectedPrograms and Opportunity__c=:oppId];
          
          for(Deal_Registration__c comments: updateComments){
              comments.Program__r.Name=programWrapper.selectedPrograms;
              comments.Program_Comments__c=programWrapper.programComments;
              updateCommentList.add(comments);
          }
       }
    }

  try{
  if(commentFlag){
       update updateCommentList;
      }
  }catch(Exception e){}
        return Page;   
 }  

  /*
   * This method is used to get the list of programs based on selected products.
   *@ return Programwrapper list
  */
  /*public List<Programwrapper> getProgram() {
         
           programList = new List<programwrapper>();
           List<Program_Product_Association__c> programProductMapList= new List<Program_Product_Association__c>();
           List<Program_Product_Association__c> programProduct= new List<Program_Product_Association__c>();
           List<Campaign> eligibleProgram=new list<Campaign>();
           List<String> programPartnerList = new List<String>();           
           Set<String> productLines = new set<String>();
           Set<String> programProductSet= new Set<String>();
          // Code for checking partner eligibility
           partnerUserIdValue = new User();
          
           partnerUserIdValue =[Select Partner_account_ID__c from User where Id= :UserInfo.getUserId()]; 
           List<Program_Partner_Association__c> programPartner =[Select Program__r.Name from Program_Partner_Association__c where Partner__C =:partnerUserIdValue.Partner_account_ID__c ];
 
           // check the partner eligibilty for a program
           for(Program_Partner_Association__c pPartner:programPartner){
                 programPartnerList.add(pPartner.Program__r.Name);
            }
        
          opportunityLineItemList= [Select  GBU__c,Product_Line__c,ProductName__C,Program__c,UnitPrice,Subtotal,Start_Date__c, OpportunityID__c, Business_Group__c, Product__c,  ProductId__c from OpportunityLineItem where OpportunityId= :oppId ];  
 
           
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
               Campaign programId=[select id from Campaign where name=:programProductMapObj];
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
   /*public class ProgramWrapper
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
    /*public class wrapperLineItem {
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
        
        public wrapperLineItem (OpportunityLineItem c, String pName, String bg, String gbu, String pl, String spl, Boolean service) {
            oli = c;
            selected = false;
            productName = pName;
            existingBusinessGroup = bg;
            existingGlobalBusinessUnit = gbu;
            existingProductLine = pl;
            existingSubProductLine = spl;
            isNew = false;
            pricebookEntryId = '';
            isService = service;
            RTSComponent = c.RTS_Component__c;
        }
      } */
 }