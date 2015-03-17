/**********************************************************
* Class Name: ContractAssociateController
* Author: HP
* Date: last revised 7/17/2013 - Laura castro 
* Requirement # 
* Description: Controller class to Associate contracts/quotes/sales metric codes to Existing Renewal opportunity page.
***********************************************************/

Public with sharing class ContractAssociateController {
    public contract_reference__c Oppty;
    Public String ContID;
    Private List<Contract_Reference__c> ContractList;
    Private List<OpportunityLineItem> LineItems;
    public String retURL {get;set;}
    public String opId;
    Public String opName;
    public String accId;
    Public String OppName; 
    public List<String> part;
    public List<String> salesdocs = new List<String>();
    Public Integer CountLineItem;
    Public OpportunityLineItem NewOppLineItem = null;
    Public List<OpportunityLineItem> NewOppLineItemList = new OpportunityLineItem[]{};
    
    public List<String> quoteIDs = new List<String>();
    Public OpportunityLineItem NewQuoteOppLineItem = null;
    Public List<OpportunityLineItem> NewQuoteOppLineItemList = new OpportunityLineItem[]{};
    List<contract_reference__c> selectedcontracts = new List<contract_reference__c>();
    Public List<hp_quote__c> syncedquotes = new List<hp_quote__c>();
    Public Opty_Sales_Metric_Code__c NewSMC = null; 
    Public List<Opty_Sales_Metric_Code__c> NewSMCList = new Opty_Sales_Metric_Code__c[]{};  

    /**
    * @description: Class Constructor method
    * @param StandardController Apex Page
    * 
    */
    public ContractAssociateController(ApexPages.StandardController controller){
        retURL = ApexPages.currentPage().getParameters().get('retURL'); 
        this.Oppty = (contract_reference__c)controller.getRecord();
        ContID = System.currentPagereference().getParameters().get('selectedcontractid');
        part = ContID.split(',');
        for( Contract_Reference__c sd : [select Name from Contract_Reference__c where id in :part]){  
            salesdocs.add(sd.Name);
        }
                
     } 
      
    
    /**
    * @description: method to display Selected contract list in vf page
    * 
    */
    Public List<Contract_Reference__c> getContractList(){
        list<Contract_Reference__c> ContractList1 = [select Id,original_opportunity__c, Name, Accounts__c, Contract_Start_Date__c, Contract_End_date__c, Sales_Doc_Nbr__c from Contract_Reference__c where id in :part];
        return ContractList1;
        }
           
     /**
    * @description: method to display Selected LineItems list in vf page
    * 
    */     
    Public List<OpportunityLineItem> getLineItems(){
        list<OpportunityLineitem> LineItems1 = [Select id,pricebookentry.product2.name,OpportunityId,GBU__c,Product__c,Business_Group__c,ProductId__c,QUANTITY,UNITPRICE,OPPORTUNITYID__C,CONTRACT__C,START_DATE__C,END_DATE__C from OpportunityLineitem where Contract__c in :part];
        return LineItems1;
        }
        
    /**
    * @description: method to display Quotes associated to Selected contracts in vf page
    *            
    */
    
    Public List<HP_Quote__c> getQuotesList(){ 
        list<HP_Quote__c> QuoteList1 = [select Id,Name, Quote_Start_Date__c, Quote_End_date__c, Opportunity_Name__c, Account_Name__c from HP_Quote__c where Expiring_Contract_Number__c in :salesdocs];
        for(HP_Quote__C qlist : QuoteList1){
                quoteIDs.add(qlist.Id);
        }
        return QuoteList1;
        }
        
    /**
    * @description: method to display Quote PLs associated to Selected quotes in vf page
    *            
    */
    
    Public List<OpportunityLineItem> getQuotePLlist(){
        
        list<OpportunityLineItem> QuotePLlist = [Select id,pricebookentry.product2.name,OpportunityId,GBU__c,Product__c,Business_Group__c,ProductId__c,QUANTITY,UNITPRICE,OPPORTUNITYID__C,CONTRACT__C,START_DATE__C,END_DATE__C,HP_Quote__c from OpportunityLineitem where HP_Quote__c in :quoteIDs];
        return QuotePLlist;
        }
      
     /**
    * @description: Method to get current opty Values
    * */   
    
    public contract_reference__c getOppty(){
    CountLineItem = [Select count() From OpportunityLineItem where OpportunityId = :oppty.original_opportunity__c];
         system.debug('CountLineItem'+CountLineItem); 
        return Oppty;
         
        }
        
   
     /**
    * @description: Method to provide cancel and return back to previous page
    * 
    */
    public pageReference cancel(){
        pageReference pr = new pageReference(retURL);
        pr.setRedirect(true);
        return pr;
        } 
    
     /**
    * @description: Method to Save and Associate Contracts and LineItems to Existing Renewal Opportunity
    * */ 
    Public PageReference Associate()
    {
        ApexPages.StandardController controller = new ApexPages.StandardController(Oppty);
        Savepoint sp = Database.setSavepoint();      
        opId = oppty.original_opportunity__c;
        
        Opportunity op=[select id,account.id ,name from opportunity where id = :opid];
        opName = op.name;
        system.debug(OpId);
        system.debug('***Name***'+opName);
        accId = op.account.id;
        system.debug(AccId);
        List<string> parts = ContID.split(',');
       
        
        list<contract_reference__c> Contract = [Select id,original_opportunity__c,accounts__c,original_opportunity__r.name  from contract_reference__c where id in :parts];
        list<hp_quote__c> Quote = [Select id,Opportunity_Name__c, Last_Synced_to_Opportunity__c from HP_Quote__c where expiring_contract_number__c in :salesdocs];
        //get SMCs from above quotes
        list<Opty_Sales_Metric_Code__c> SMC = [Select Name, OpportunityId__c, QuoteID__c, Total_Value__c from Opty_Sales_Metric_Code__c where QuoteID__c in :Quote];
        
        OppName = String.valueof(Contract[0].original_opportunity__r.name);
        for(Contract_reference__c c : Contract)
            {
            c.original_opportunity__c = opId;
            c.accounts__c = accId;
            }
        //moving over quotes and determining which of those quotes if any, need to be resynced to its new oppty
        for(HP_Quote__c q : Quote)
            {
            q.Opportunity_Name__c = opId;
            if(q.Last_Synced_to_Opportunity__c!=NULL){q.Last_Synced_to_Opportunity__c = datetime.now();syncedquotes.add(q);}
            }
        //preparing to move over SMCs to new oppty - delete and recreate at new oppty  
        for(Opty_Sales_Metric_Code__c opsmc : SMC)
             {
             NewSMC = opsmc.clone(false,false, true, false);
             NewSMC.OpportunityId__c = opId;
             NewSMCList.add(NewSMC);            
             }
          
        System.debug(contract);
        System.debug(quote);
        System.debug(SMC); 
        system.debug('##########NewSMCs'+NewSMCList);      
        try
        {
        if(contract != null && contract.size() > 0)
            {
            update contract;
            if(quote!=null && quote.size()>0){update quote;}
                       
            if(COTestClassUtility.ContractAssociateControllerTestVar1 == true){
                
                contract[0].CurrencyIsoCode = null;
                update contract;
                
            }
                
            }
        }
        catch(DmlException dmlEx)
        {
        CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'opportunity', 'ContractAssociateController', '');
        for(Integer i =0; i<dmlEx.getNumDml(); ++i)
            { 
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
        Database.rollback(sp);
        return null;
        }    
        list<OpportunityLineitem> OppLineItem = [Select id,pricebookentry.product2.name,OpportunityId,PRICEBOOKENTRYID,GBU__c,QUANTITY,UNITPRICE,SUBTOTAL,LISTPRICE,OPPORTUNITYID__C,CONTRACT__C,ServiceDate, START_DATE__C,END_DATE__C,FIRST_FISCAL_YEAR_VALUE__C,MARGIN_AMOUNT__C from OpportunityLineitem where Contract__c in :parts];
        list<OpportunityLineitem> olisyncedfromquote = [Select id,pricebookentry.product2.name,OpportunityId,PRICEBOOKENTRYID,GBU__c,QUANTITY,UNITPRICE,SUBTOTAL,LISTPRICE,OPPORTUNITYID__C,ServiceDate, HP_Quote__c, Quote_Number__c, START_DATE__C,END_DATE__C,FIRST_FISCAL_YEAR_VALUE__C,MARGIN_AMOUNT__C from OpportunityLineitem where HP_Quote__c in :syncedquotes];
        
        system.debug('##########OppLineItem'+OppLineItem);
        system.debug('##########OppLineItems from Synced Quotes'+olisyncedfromquote);
       
        for(OpportunityLineitem o : OppLineItem)
            {
            NewOppLineItem = o.clone(false,false,true,false);
            NewOppLineItem.OpportunityId=opId;
            NewOppLineItemList.add(NewOppLineItem);
            }
        system.debug('##########NewOppLineItem'+NewOppLineItemList);
        //resync quote items to new oppty
        //insert new condition here to check synced status on destination oppty
        for(OpportunityLineitem q : olisyncedfromquote)
            {
            NewQuoteOppLineItem = q.clone(false,false,true,false);
            NewQuoteOppLineItem.OpportunityId=opId;
            NewQuoteOppLineItemList.add(NewQuoteOppLineItem);
            }
        system.debug('##########NewOppLineItem from Quotes'+NewQuoteOppLineItemList);
        try
        { 
        if(opplineitem.size() > 0)
            {
            Insert NewOppLineItemList;
            if(COTestClassUtility.ContractAssociateControllerTestVar2 == true){
                
                NewOppLineItemList[0].UnitPrice = null;
                update NewOppLineItemList;
                
            }
           }
         if(olisyncedfromquote.size() > 0)
         {insert NewQuoteOppLineItemList;}
         if(SMC.size() >0){insert NewSMCList;}         
         }
        
         catch(DmlException dmlEx)
        {
        CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'opportunity', 'ContractAssociateController', '');
        for(Integer i =0; i<dmlEx.getNumDml(); ++i)
            { 
             system.debug('****NewItemCatch****');
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Validate Opportunity1: ' + opName));
            }
        Database.rollback(sp);
        return null;
        }
        try
        {          
        if(OppLineItem.size() >0 )
            {
            
            Delete OppLineItem;
            if(COTestClassUtility.ContractAssociateControllerTestVar3 == true){
                
                NewOppLineItemList[0].UnitPrice = null;
                update NewOppLineItemList;
                
            }
            }
         if(olisyncedfromquote.size()>0)
         {Delete olisyncedfromquote;}
         if(SMC.size()>0){delete SMC;}         
         }
         catch(DmlException dmlEx)
        {
        CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'opportunity', 'ContractAssociateController', '');
        for(Integer i =0; i<dmlEx.getNumDml(); ++i)
            { 
             system.debug('****DeleteItemCatch****');
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Validate Opportunity: ' + OppName ));
            }
        Database.rollback(sp);
        return null;
        }       
        return new PageReference('/'+opId);   
    }
   
}