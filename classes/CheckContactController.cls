/**********************************************************
* Class Name: CheckContactController
* Author: Accenture
* Date: 30-MAR-2012 
* Requirement # Request Id :317/304/307 
* Description: Controller to check existing contact
*               before lead conversion  
***********************************************************/
public class CheckContactController {
public Static Boolean bypassOpptyTrigger=false;  
    public String leadName {get;set;}
    public Boolean doNotCreateOpty = false;
    public String leadId {get;set;}
    public String accountName {get;set;}
    public String accountId {get;set;}
    public Boolean isRender {get; set;}
    public String contactId {get;set;}
    public String ownerId;
    public String errorMessage {get; set;}
    public String oppFlag;
    public String emailFlag; 
    public String replaceLeadSource {get; set;}
    public Lead lead;
    public String leadCurrency = '';
    public Boolean iscontact {get; set; }
    public Map<Id, Account> accountInfo; 
    public String leadcompany;
    public String contactDescription ;
    public String FromConvertToContact;
     
    private List<Campaign_Influence__c> CampaignInfluence;//Added
    public List<CampaignMember> campmemberList = new List<CampaignMember>();
    List<Campaign> campList = new List<Campaign>();//Added
    Set<Id> campId = new Set<Id>();//Added
    private OpportunityContactRole OCR;
    private List<OpportunityContactRole> OCRList = new List<OpportunityContactRole>();
    
    /* R2 */
    private Datetime leadCreationDate;
    private List<Note> notes, leadNotes;
    private transient List<Attachment> attachments, leadAttachments;
    /**/
    
    /* list to store lead products */
    private List<Product_Interest__c> leadProducts;
    private Set<Id> productIds;
    
    /**
    * @description - Fetch current Lead information and selected acount information
    */
    public CheckContactController() {
        accountId = ApexPages.currentPage().getParameters().get('accId');
        FromConvertToContact = ApexPages.currentPage().getParameters().get('FromConvertToContact');
        
        leadId = ApexPages.currentPage().getParameters().get('leadId');
        if(leadId == null){
            leadId = ApexPages.currentPage().getParameters().get('Id');
        }
        ownerId = ApexPages.currentPage().getParameters().get('ownerId');
        oppFlag = ApexPages.currentPage().getParameters().get('oppFlag');
        emailFlag = ApexPages.currentPage().getParameters().get('emailFlag');
        leadcompany = ApexPages.currentPage().getParameters().get('leadcompany');
        leadProducts = new List<Product_Interest__c>(); 
        iscontact = true;
        Account account = new account(); 
        accountInfo = new Map<Id, Account>(); 
        if (accountId != null) {
            account = [Select Id,Name, CreatedDate, Fax, CurrencyIsoCode, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity
                        From Account 
                        Where Id =: accountId];
            accountInfo.put(account.Id, account);                              
        }
        lead = [Select Id, CreatedDate, Lead_State__c, List_Id__c, Tactic_Name__c, Name,Tactic_Code__c,
                List_Code__c, Company, Phone,Product_Service_Solution__c,  CurrencyIsoCode , 
                Purchaser_Role__c,description,Additional_Notes__c, Closed_Reason__c From Lead 
                Where Id =: leadId];
        if (account != null) {
            accountName = account.Name;
        }
        if (lead != null) {
            leadName = lead.Name;
            leadCurrency = String.valueOf(lead.CurrencyIsoCode);
            leadCreationDate = lead.CreatedDate;    
        }
        
        /* Fetching lead products before lead conversion*/
        productIds = new Set<Id>();
        for (Product_Interest__c leadProduct: [Select Id, Unit_Price__c, Quantity__c, Product__c, Lead__c, Book_Ship_Date__c 
                                            From Product_Interest__c
                                            Where Lead__c =: leadId]) {
            leadProducts.add(leadProduct);
            productIds.add(leadProduct.Product__c);
        }
    }
    
    /**
    * @description - Returns to Lead Page
    * @return - PageReference Redirects to lead detail page 
    */
    public PageReference Cancel() {
        PageReference returnToLead=new PageReference('/'+lead.Id);
        returnToLead.setRedirect(true);
        return returnToLead;
    }
    
    /** 
    * @description - Returns existing contact options which used on visual force page for attaching to existing contact
    * @return - List<SelectOption> - Option Attach to Existing 
    */
    public List<SelectOption> getContactOptions() {
        //ContactSearch contactSearch = new ContactSearch();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        for (Contact con : getContacts(accountId, leadName)) {      
            options.add(new SelectOption(con.Id,Label.LC_Attach_to_Existing+' '+con.Name));
        }
        return options;
    }
    
    /**
    * @description - To Search Contacts depending on sharing access
    * @return - List<Contact> List of contacts which are attached to the selected account.
    */
    public List<Contact> getContacts(String accountId, String leadName) {
      
        List<Contact> contactList = new List<Contact>();
        String leadNameToMatch = '%'+leadName+'%';
        for (Contact con : [Select Id, Name 
                            From Contact 
                            Where accountId =: accountId and Name like :leadNameToMatch]) {
            contactList.add(con);
        }
        
        return contactList;
    }   
    
    /**
    * @description - To convert Lead into Account, Contact, opportunity in system admin context. 
    */
    public PageReference leadConvert() {
    bypassOpptyTrigger = true;
        System.debug('>>>> In convert Method ');
        LeadConvertController.fromLeadConversion = true;
        
        /*Fetch Contact description before convert a lead */
        Contact contactData = new Contact();
        if (contactId != null) {
            contactData = [Select Id, Description From Contact Where Id = :contactId];
            contactDescription = contactData.Description;
            
        }
        //Convert lead in system context, as user doesnot have C/M/D access on Account.
        Database.LeadConvertResult lcr = doConversion(accountId, contactId, oppFlag, leadId, ownerId, 
                                                    lead.company, emailFlag, lead.Product_Service_Solution__c, 
                                                    replaceLeadSource, leadCurrency);  
        PageReference returnToPage;
        System.debug('>>>> '+lcr);
        if (lcr != null) {
            if (lcr.isSuccess()) {
                System.debug('>>>> isSuccess '+lcr.isSuccess());
                /* Update Contact description to its old value */
                Contact updateContact = new Contact(Id=contactId);
                if (contactDescription!=null && contactDescription!='') {
                    updateContact.Description = contactDescription;
                }
               
                //Made changes on 29-April-2012 to override Phone on Contact from Lead phone.
                if (lead.Phone != null) {
                    updateContact.phone=lead.Phone;
                } try {
                    update updateContact;
                } catch(Exception ex) {
                    CreateApexErrorLog.insertHandledExceptions(ex, null, 'Contact', 'CheckContactController', 'Class'); 
                }
                if(FromConvertToContact == 'True')
                    returnToPage=new PageReference('/'+ lcr.getContactId());
                else
                    returnToPage=new PageReference('/'+ lead.Id);
                returnToPage.setRedirect(true);
            }
            else {
                //errorMessage = Label.LC_Error+lcr.getErrors(); 
                errorMessage = ''+lcr.getErrors(); 
                System.debug('>>>> Error isSuccess  '+errorMessage);
                isRender = false;                                    
                returnToPage=new PageReference('/apex/LeadConvert');
                returnToPage.setRedirect(true);        
            }
        } else {
            errorMessage = Label.LC_Error;              
            isRender = false;                                 
            returnToPage=new PageReference('/apex/LeadConvert');
            returnToPage.setRedirect(true);        
        }
        return returnToPage;
    }
    
    /**
    * @description - Convert Lead in system context as as user doesnot have C/M/D access on Account.
    * @param - String accountId - Selected account id
    *          String contactId - Selcted contact id
    *          String doNotCreateOpty - True / False value to create opportunity or not
    *          Id leadId - Id of lead whcih will get converted
    *          Id ownerId - Lead owner id
    *          String Company - Lead company name
    *          String sendNotificationEmail - True/ False value for sending email notification
    *          String leadSourceFlag -  Lead source of current lead
    *          String leadCurrency - Lead currency
    * @return -  Database.LeadConvertResult - Success or Failure result     
    */
    public Database.LeadConvertResult doConversion(String accountId, String contactId, String doNotCreateOpty, Id leadId, 
                                                    Id ownerId, String Company, String sendNotificationEmail, 
                                                    String leadProductServiceSolution, String leadSourceFlag, String leadCurrency) {
        System.debug('>>>> In do conversion ');
        Database.LeadConvert lc = new database.LeadConvert();
        Boolean opptyFlag = Boolean.valueOf(doNotCreateOpty);
        lc.setLeadId(leadId);
        lc.setOwnerId(ownerId);
        lc.setAccountId(accountId);  
        lc.setDoNotCreateOpportunity(opptyFlag);
        lc.setContactId(contactId);
        lc.setOverwriteLeadSource(Boolean.valueOf(leadSourceFlag));
        //Set Opportunity name if doNotCreateOpty is false.
        if (!opptyFlag) {
            lc.setOpportunityName(lead.company);
        }
        
        if(FromConvertToContact == 'True')
            lc.setConvertedStatus('Closed');
        else
            lc.setConvertedStatus('Working');
        lc.setSendNotificationEmail(Boolean.valueOf(sendNotificationEmail)); 
        OCR = new OpportunityContactRole();
        CampaignInfluence= new List<Campaign_Influence__c>();
        /**
        * Author: Accenture
        * Date: 17-JULY-2012  
        * Requirement # Request Id: (R2.0)
        * @description - Initializing Notes and Attachments 
        */
        leadNotes = new List<Note>();
        leadAttachments = new List<Attachment>();
        
        /* Fetching Notes and Attachments before Lead Conversion*/
        
        for (Note leadNote : [Select Id, Title, ParentId, OwnerId, Body, IsPrivate 
                                From Note 
                                Where ParentId =: leadId]) {
            leadNotes.add(leadNote);                        
        }
        
        for (Attachment leadAttachment : [Select Id, ParentId, OwnerId, Name,
                                                Body, Description, IsPrivate, ContentType 
                                            From Attachment 
                                            Where ParentId =: leadId]) {
            leadAttachments.add(leadAttachment);                        
        }
        
        
         /* Fetching Campaign before Lead Conversion*/
          for(CampaignMember campMember :[Select Id,CampaignId,Primary__c from CampaignMember where LeadId =: leadId]){
            campmemberList.add(campMember);
            campId.add(campMember.CampaignId);
        }
        for(Campaign camp : [Select Id,Name,Type from Campaign where Id IN: campId]){
           campList.add(camp);
        }

        Database.LeadConvertResult lcr ; 
        try {
            if(lead.Lead_state__c!=null)
                if(lead.Lead_state__c == 'New'){
                    lead.Lead_state__c = 'Accepted'; 
                }
            Savepoint sp = Database.setSavePoint();
            if(FromConvertToContact == 'True')
                lead.Closed_Reason__c = 'Created Contact';
                
            update lead;
            
            lcr = Database.convertLead(lc);  
            
            if(!lcr.isSuccess())
                Database.rollback(sp);
                
            if (lcr.isSuccess() && doNotCreateOpty == 'false') {
                Id optyId = lcr.getOpportunityId();
                if(contactId == null){
                    contactId = lcr.getContactId();
                }
                updateOptyAfterLeadConversion(contactId ,accountId, optyId, leadCurrency);
            }
        } catch (DMLException e) {
            System.debug('>>>> In do conversion '+ e);
            CreateApexErrorLog.insertHandledExceptionsForLeadConversion(e, lcr, 'Lead', 'CheckContactController', 'Class');   
        }
        return lcr;
    } 
        
    /**
    * @descripiton - Update converted opportunity. Update opportunity currency by lead account currency
    * @param - String accountId - Selected account id , Id optyId - converted opty id, String leadCurrency - Lead currency  
    */
    public void updateOptyAfterLeadConversion(Id contactId,String accountId, Id optyId, String leadCurrency ){
        Opportunity optyAmountUpdate = new Opportunity();
        Account account = new Account();
        notes = new List<Note>();
        attachments = new List<Attachment>();
        if (accountId != null) {    
            account = [Select Id, CurrencyIsoCode From Account Where Id = :accountId]; 
        }
 
        for(OpportunityContactRole ocrTemp : [Select contactId,OpportunityId,Role from OpportunityContactRole where contactId=: contactId AND OpportunityId =:optyId]){
            if(lead.Purchaser_Role__c == 'Business Sponsor' || lead.Purchaser_Role__c == 'Business Sponsor / Banker' ||
               lead.Purchaser_Role__c == 'Buyer'|| lead.Purchaser_Role__c == 'Decision Maker' ||lead.Purchaser_Role__c == 'Secondary Decision Maker'){
                    ocrTemp.Role = 'Decision Maker';
             }
              else if(lead.Purchaser_Role__c == 'Evaluator/Recommender'|| lead.Purchaser_Role__c =='Key Contact'){
                 ocrTemp.Role = 'Subject Matter Expert';
             } 
             else if(lead.Purchaser_Role__c == 'Influencer'){
                 ocrTemp.Role = 'Political Influencer';
             }
             else if(lead.Purchaser_Role__c == 'VIP / Key Contact'){
                 ocrTemp.Role = 'Executive';
             }
             else{
                ocrTemp.Role = null; 
             }
              OCRlist.add(ocrTemp);
         }
         /*****************Campaign of Lead migerated to CI of Opportunity*********/
          for(Campaign cam : campList){
            for(CampaignMember cammem : campmemberList){
                if(cammem.CampaignId == cam.Id){
                                     CampaignInfluence.add(new Campaign_Influence__c(Opportunity__c = optyId,Campaign__c = cam.Id,Contact__c = contactId,
                                         Primary_Campaign_Source__c =cammem.Primary__c));  
                 }
            }
        }
        /* @description - Adding Notes And Attachments for new Opportunity */
        Id id;
        if(FromConvertToContact == 'True'){
            id = contactId;
            List<Task> taskList = [Select Id, WhoId From Task Where WhoId = :leadId];
            
            for(Task t : taskList)
                t.WhoId = id;
                
            update taskList;
            
            List<Event> eventList = [Select Id, WhoId From Event Where WhoId = :leadId];
            
            for(Event e : eventList)
                e.WhoId = id;
                
            update eventList;
        }
        else
            id = optyId;
            
        for (Note note: leadNotes) {
            
            notes.add(new Note( Title = note.Title, ParentId = id, 
                                Body = note.Body, OwnerId = note.OwnerId,
                                IsPrivate = note.IsPrivate));
        }
        
         /***************CR-0249**************/
         if(lead.description != null){
             notes.add(new Note(Title = 'Lead Notes', ParentId = id,
                            Body = lead.description ));
        }
        if(lead.Additional_Notes__c!= null){
            notes.add(new Note(Title = 'Lead Additional Notes', ParentId = id,
                            Body = lead.Additional_Notes__c));
        }
        for (Attachment attachment: leadAttachments) {           
            attachments.add(new Attachment( Name = attachment.Name, ParentId = id,
                                            OwnerId = attachment.OwnerId,
                                            Body = attachment.Body, 
                                            Description = attachment.Description,
                                            ContentType = attachment.ContentType,
                                            IsPrivate = attachment.IsPrivate));
        }
        try {
             if(!OCRList.isEmpty()){
                update OCRList;
            }
            if (!notes.isEmpty()) {
                insert notes;
            }
            if (!attachments.isEmpty()) {
                insert attachments;
            }
            if (!CampaignInfluence.isEmpty()){
                System.debug('*****CampaignInfluence'+CampaignInfluence);
                insert CampaignInfluence;
            }
        } 
        catch (DMLException ex) {
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'Opportunity', 'LeadConvertController', 'Class');
        }
        
        if (optyId != null) {
            Opportunity opty = new Opportunity( id = optyId,
                                                Converted_From_Lead__c = 1,Lead_Created_Date__c = leadCreationDate);                                    
            //if (leadCurrency != account.CurrencyIsoCode) {
                opty.CurrencyIsoCode = leadCurrency;
           // }

            String optyDescription = '';
           /* if (lead.description != null) {
                optyDescription = Label.LC_Lead_Description +' '+ lead.description ;
            }*/
            
            if (lead.Product_Service_Solution__c != null) {
                optyDescription += ' ' + Label.LC_Product_Service_Solution +': '+lead.Product_Service_Solution__c;
            }
            opty.description = optyDescription; 
            opty.List_Id__c = lead.List_ID__c;
            opty.Tactic_Name__c = lead.Tactic_Name__c;
            opty.Tactic_ID__c = lead.Tactic_Code__c;
            opty.List_Name__c = lead.List_Code__c;             
            try {
                update opty;
                optyAmountUpdate = [Select Id, Amount, Opportunity_Total_Amount__c, CloseDate,
                                            Converted_From_Lead__c, Lead_Created_Date__c
                                        From Opportunity
                                        Where Id = :optyId]; 
                optyAmountUpdate.Amount = optyAmountUpdate.Opportunity_Total_Amount__c;
                update optyAmountUpdate;
            } catch (DMLException ex) {
                CreateApexErrorLog.insertHandledExceptions(ex, null, 'Contact', 'CheckContactController', 'Class');
            }
            
            /* @description - to transfer lead products into opportunity line items */
            List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
            
            Pricebook2 pricebook = [SELECT Id, Name, IsActive 
                                    From Pricebook2 
                                    WHERE Name = 'Products & Services' AND IsActive = true];
            System.debug('>>>> pricebook: '+pricebook);
            
            for(PricebookEntry pbEntry: [Select Product2Id, Id 
                                            From PricebookEntry 
                                            Where Pricebook2Id =: pricebook.Id 
                                            And Product2Id in : productIds 
                                            And CurrencyIsoCode =: leadCurrency]){
                
                OpportunityLineItems.add(new OpportunityLineItem(
                                               opportunityid = optyId,
                                               quantity = 1, 
                                               UnitPrice = 1,
                                               ServiceDate = optyAmountUpdate.CloseDate,
                                               PricebookEntryId = pbEntry.Id));
    
            }
            System.debug('>>>> OpportunityLineItems: '+OpportunityLineItems);
            try {
                if (!OpportunityLineItems.isEmpty()) {
                    insert OpportunityLineItems;
                }
            } 
            catch (DMLException ex) {
                System.debug('R2 >>>> In Exception: '+ex);
                CreateApexErrorLog.insertHandledExceptions(ex, null, 'Opportunity', 'LeadConvertController', 'Class');
            }
        }
        
        Account updateAccount;
       
        if (accountId != null) {
            updateAccount = new Account(Id = accountId);
        } 
        // Update accounts previuos values of BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity             
        if (accountInfo.containsKey(accountId)) {
            updateAccount.BillingStreet = accountInfo.get(accountId).BillingStreet;
            updateAccount.BillingState = accountInfo.get(accountId).BillingState;
            updateAccount.BillingPostalCode = accountInfo.get(accountId).BillingPostalCode;
            updateAccount.BillingCountry = accountInfo.get(accountId).BillingCountry;
            updateAccount.BillingCity = accountInfo.get(accountId).BillingCity;
            updateAccount.Fax= accountInfo.get(accountId).Fax;
               
            try {
                update updateAccount;
            }
            catch(Exception e) {
                CreateApexErrorLog.insertHandledExceptions(e, null, 'Account', 'LeadConvertcontroller', 'Class');           
            }           
        }
        //Check if account and lead has same currency or not.If not then update opportunity with Account currency.
 
    }  
    
    /**
    *  @description - Check for contact selected or not
    */           
    public void checkForContact() {
        if (contactid == null || contactid == '') {
            iscontact = true;
        } else {
          iscontact = false;
        }
    }
}