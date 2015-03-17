/**********************************************************
* Class Name: ContractExtensionController
* Author: HP
* Date: last revised 7/17/2013 - Laura Castro 
* Requirement # 
* Description: Controller class to Associate contracts/quotes/Sales metric Codes to New Renewal Opportunity page.
***********************************************************/
Public class ContractExtensionController {
    public Opportunity Oppty{get;set;}
    Public string Contractid {get;set;}
    Public String ContID;
    Public Id OppId;
    public boolean result{get;set;}
    public List<integer> contrList{get;set;}
    public Opportunity OptyRec {get;set;}
    Public String retURL{get;set;}
    List<string> parts;
    List<string> salesdocs = new List<string>();    
    Public String OppName;
    Public OpportunityLineItem NewOppLineItem = null;
    Public List<OpportunityLineItem> NewOppLineItemList = new OpportunityLineItem[]{};
    Double contractSum;
    List<Contract_Reference__c> contractsToUpdate = new List<Contract_Reference__c>();
    Public List<hp_quote__c> syncedquote = new List<hp_quote__c>(); 
    Public Opty_Sales_Metric_Code__c newSMC = null;     
    Public List<Opty_Sales_Metric_Code__c> newSMClist = new Opty_Sales_Metric_Code__c[]{}; 
    Public OpportunityLineItem NewQuoteOppLineItem = null;    
    Public List<OpportunityLineItem> NewQuoteOppLineItemList = new OpportunityLineItem[]{};

   /**
    * @description: Class Constructor method
    * @param StandardController Apex Page
    * 
    */
    public ContractExtensionController(ApexPages.StandardController controller){
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        this.Oppty = (Opportunity)controller.getRecord();
        ContID = System.currentPagereference().getParameters().get('selectedcontractid');
        parts = ContID.split(',');
        //get sds in order to associate quotes        
        for( Contract_Reference__c sd : [select Name from Contract_Reference__c where id in :parts])
        {salesdocs.add(sd.Name);}        
        //OppName = oppty.name;        
    }
    
    /**
    * @description: Method To get oportunity details
    * */
    public Opportunity getOppty(){
        return Oppty;
    }
             
    /**
    * @description: Initialize page to create new opportunity
    * */
    Public PageReference initialize(){
        pageReference pageRef = null;
         Id RecordTypeId;
         Opportunity originalopty=[select id, CurrencyIsoCode,account.id, CloseDate, StageName, ForecastCategoryName,Route_To_Market__c, Renewal_Type__c, Renewal_Sub_Type__c, SAP_Feed__c  from opportunity where id = :System.currentPageReference().getParameters().get('oppId')];
         RecordTypeId = RecordTypeIdHelper.getRecordTypeId ('opportunity','Renewal');
         system.debug('***RecordType***'+RecordTypeId);
       this.oppty.StageName = originalopty.StageName;
            this.oppty.ForecastCategoryName = originalopty.ForecastCategoryName;
            this.oppty.ownerid=UserInfo.getUserId();
            this.oppty.Type = 'Renewal';
            this.oppty.AccountID=originalopty.account.id;
            this.oppty.CloseDate=originalopty.CloseDate;
            this.oppty.Renewal_Type__c=originalopty.Renewal_Type__c;
            this.oppty.CurrencyIsoCode=originalopty.CurrencyIsoCode;
            this.oppty.RecordTypeId=RecordTypeId;
            //this.oppty.Renewal_Sub_Type__c=originalopty.Renewal_Sub_Type__C;
            this.oppty.Route_To_Market__c=originalopty.Route_To_Market__c;  
            result=originalopty.SAP_Feed__c;
            System.debug('????????'+originalopty.SAP_Feed__c);
            System.debug('********'+this.oppty.SAP_Feed__c);
            List<contract_reference__c> ar= [Select Total_Contract_Value__c from contract_reference__c where id in :parts ];
            this.oppty.Amount =0;
            for(contract_reference__c con : ar){
            if(con.Total_Contract_Value__c!= Null)
                this.oppty.Amount += (Decimal)con.Total_Contract_Value__c;
            }
            system.debug(ContID);
        return pageRef;     
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
    * @description: Method to Save and Associate Contracts and LineItems with New Renewal Opportunity
    * 
    */
    Public PageReference mysave(){    
        ApexPages.StandardController controller = new ApexPages.StandardController(Oppty);
        Savepoint sp = Database.setSavepoint();
            parts = ContID.split(',');
            system.debug(parts);
            Contractid = parts[0];
            list<contract_reference__c> Contract = [Select id, CurrencyIsoCode, original_opportunity__c,original_opportunity__r.name,accounts__c from contract_reference__c where id in :parts];
            list<hp_quote__c> Quote = [Select id,Opportunity_Name__c, Last_Synced_to_Opportunity__c from HP_Quote__c where expiring_contract_number__c in :salesdocs];
            list<Opty_Sales_Metric_Code__c> SMC = [Select Name, OpportunityId__c, QuoteID__c, Total_Value__c from Opty_Sales_Metric_Code__c where QuoteID__c in :Quote];
            
            OppName = String.valueof(Contract[0].original_opportunity__r.name);
            
            try
            { 
             Insert this.oppty;
             if(COTestClassUtility.ContractExtensionControllerTestVar1 == true){
                
                oppty.CurrencyIsoCode = null;
                update oppty;
                
            }
             system.debug('*&^&*%*%*%*' + oppty.renewal_sub_type__C);
            }
            catch(DmlException dmlEx)
            {
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'opportunity', 'ContractExtesionController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i)
                { 
                 Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Validate Opportunity: ' + Oppty.name));
                }
            Database.rollback(sp);
            return null;
            } 
            Opportunity opp = (opportunity)controller.getRecord();
            Opportunity op= [select id,account.id from opportunity where id = :opp.id];
            system.debug(op);
            
            for(Contract_reference__c c : Contract)
                {
                c.original_opportunity__c = opp.id;
                c.accounts__c = op.account.id;
                }
            for(hp_quote__c q : Quote)
            {
            q.Opportunity_Name__c = opp.id;
            if(q.Last_Synced_to_Opportunity__c!=NULL){q.Last_Synced_to_Opportunity__c = datetime.now();syncedquote.add(q);}           
            }  
            //preparing to move over SMCs to new oppty - delete and recreate at new oppty          
            for(Opty_Sales_Metric_Code__c opsmc : SMC)             
            {             
            newSMC = opsmc.clone(false,false, true, false);             
            newSMC.OpportunityId__c = opp.Id;             
            newSMClist.add(newSMC);                         
            }              
            system.debug(contract);
            system.debug(quote);
            system.debug(SMC);            
            try
            {
             if(contract.size() > 0)
                {
                    update contract;
                    if(quote.size()>0){
                        update quote;
                        if(SMC.size()>0){update SMC;}                        
                    }                    
                    if(COTestClassUtility.ContractExtensionControllerTestVar2 == true){
                
                        contract[0].CurrencyIsoCode = null;
                        update contract;
                
                    }
                }
            }
            catch(DmlException dmlEx)
            {
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'opportunity', 'ContractExtesionController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i)
                { 
                 Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Validate Opportunity: ' + Oppty.name));
                }
            Database.rollback(sp);
            return null;
            } 
            list<OpportunityLineitem> OppLineItem = [Select id, OpportunityId,PRICEBOOKENTRYID, CURRENCYISOCODE,QUANTITY,UNITPRICE,SUBTOTAL,LISTPRICE,OPPORTUNITYID__C,CONTRACT__C,ServiceDate, START_DATE__C,END_DATE__C,FIRST_FISCAL_YEAR_VALUE__C,MARGIN_AMOUNT__C from OpportunityLineitem where Contract__c in :parts];
            for(OpportunityLineitem o : OppLineItem)
                {
                NewOppLineItem = o.clone(false,false,true,false);
                NewOppLineItem.OpportunityId=Opp.id;
                NewOppLineItemList.add(NewOppLineItem);
                }
            list<OpportunityLineitem> olisyncedfromquote = [Select id,pricebookentry.product2.name,OpportunityId,PRICEBOOKENTRYID,GBU__c,QUANTITY,UNITPRICE,SUBTOTAL,LISTPRICE,OPPORTUNITYID__C,ServiceDate, HP_Quote__c, Quote_Number__c, START_DATE__C,END_DATE__C,FIRST_FISCAL_YEAR_VALUE__C,MARGIN_AMOUNT__C from OpportunityLineitem where HP_Quote__c in :syncedquote];                
            system.debug('##########OppLineItems from Synced Quotes'+olisyncedfromquote);
            for(OpportunityLineitem q : olisyncedfromquote)            
            {            
            NewQuoteOppLineItem = q.clone(false,false,true,false);            
            NewQuoteOppLineItem.OpportunityId=opp.Id;            
            NewQuoteOppLineItemList.add(NewQuoteOppLineItem);            
            }        
            system.debug('##########NewOppLineItem from Quotes'+NewQuoteOppLineItemList);            
            try
            {    
            if(NewopplineitemList.size() > 0)
               {
               Insert NewOppLineItemList;
               if(COTestClassUtility.ContractExtensionControllerTestVar3 == true){
                
                    NewOppLineItemList[0].UnitPrice = null;
                    update NewOppLineItemList;
                
                }
               }
            if(olisyncedfromquote.size() > 0)         
            {insert NewQuoteOppLineItemList;}         
            if(SMC.size() >0){insert newSMClist;}         
            }
            catch(DmlException dmlEx)
            {
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'opportunity', 'ContractExtesionController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i)
                { 
                 Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Validate Opportunity: ' + Oppty.name));
                }
            Database.rollback(sp);
            return null;
            }   
            Try
            {  
            if(OppLineItem.size() > 0)
                {
                   Delete OppLineItem;
                   if(COTestClassUtility.ContractExtensionControllerTestVar4 == true){
                
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
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'opportunity', 'ContractExtesionController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i)
                { 
                 Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Validate Opportunity: ' + OppName));
                }
            Database.rollback(sp);
            return null;
            }    
            //return controller.view();
            return new PageReference('/'+opp.id);         
          }
          
          
        
}