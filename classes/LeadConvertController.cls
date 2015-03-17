/**********************************************************
* Class Name: LeadConvertController
* Author: Accenture
* Date: 2-APR-2012  
* Requirement # Request Id: 317/304/307
* Description: This class is used for Lead Convert customized functionality.
***********************************************************/
public class LeadConvertController {
    public Boolean FromConvertToContact = false;
    public Static Boolean bypassOpptyTrigger=false;  
    public Lead lead, leadInfo, leadState;            // R6: Added leadState variable 
    public Boolean isRender {get; set;}
    public Boolean isPartnerUser {get; set;}
    public Boolean sendNotificationEmail {get; set;}
    public String errorMessage {get; set;}
    public List<Account> accounts ;      
    public Boolean doNotCreateOpty = false;
    public String leadName=''; 
    public Id accountId, leadId;
    public Map<String, String> accountNameById ;
    public String leadCurrency;
    public Map<Id, Account> accountInfo;    
    public Boolean isaccount {get; set;}
    public Boolean isCase {get; set;}
    public Static Boolean fromLeadConversion=false;
    public List<CampaignMember> campmemberList = new List<CampaignMember>();
    private List<Campaign_Influence__c> CampaignInfluence;//Added
    Set<Id> campId = new Set<Id>();//Added
    List<Campaign> campList = new List<Campaign>();//Added
    //private OpportunityContactRole OCR;
    private List<OpportunityContactRole> OCRList = new List<OpportunityContactRole>();

    private List<Note> notes, leadNotes;
    private transient List<Attachment> attachments, leadAttachments;
    /* list to store lead products */
    private List<Product_Interest__c> leadProducts;
    private Set<Id> productIds;
    private String accountCurrencyCode;
    private Datetime leadCreationDate;
     
    public Map<String,Schema.RecordTypeInfo> rtMapByName{get;set;}
    public Id caseRecordTypeId{get;set;}
    public Boolean notPartner{set;get;}
    private string LeadCreatedBy;  //SFDC R6.0 By RS:Added Lead Created By variable.
    
     public String checkEmail;
   
    /**
    * @description -  This constructor will fetch lead information and does the validations.
    * @param: ApexPages.StandardController controller Lead standard controller
    */    
    public LeadConvertController (ApexPages.StandardController controller) {   
        lead = (Lead)controller.getRecord();
        isRender = true;
        errorMessage = '';
        isaccount = true;
        leadProducts = new List<Product_Interest__c>();
        leadInfo = new Lead();
        productIds = new Set<Id>();
        isPartnerUser = PartnerCollabUtil.isLoggedInPartnerUser();
        if(isPartnerUser == True){
            sendNotificationEmail = False;
        }
        if (leadId == null && lead != null) {
            leadId = lead.id;       
        }
        //Query Lead Information.This will be used during Lead conversion process.
        if (leadId != null) {
            leadInfo = [Select Id, Name, Status, List_Id__c, Tactic_Name__c,Tactic_Code__c,List_Code__c, Lead_state__c, Company, Account_Name__c, Conv_Account__c, Conv_Lead_Owner__c, 
                          OwnerID, Owner.Type, Product_Service_Solution__c, Phone, Email,Purchaser_Role__c, Description,Additional_Notes__c, CurrencyIsoCode, CreatedDate, CreatedBy.Name
                        From Lead
                        Where Id = :leadId];
        }
        if (leadInfo != null) {
            leadName = leadInfo.Name;
            leadCurrency = leadInfo.CurrencyIsoCode;
            accountId = leadInfo.Account_Name__c;
            lead.Conv_Lead_Owner__c = leadInfo.ownerId;
            leadCreationDate = leadInfo.CreatedDate;
            LeadCreatedBy= leadInfo.CreatedBy.Name;
            accounts = getAccounts(leadInfo.company);
            
            
            /* Fetching lead products before lead conversion*/
            // Karthik : Aug 12, 2013 : Testing Purpose : Start
            //system.debug('Lead ID : ' + leadId);
            //system.debug('No.of Products : ' + [Select COUNT() FROM Product_Interest__c WHERE Lead__c =: leadId]);
            // Karthik : Aug 12, 2013 : Testing Purpose : End
            for (Product_Interest__c leadProduct: [Select Id, Unit_Price__c, Quantity__c, Product__c, Lead__c, Book_Ship_Date__c 
                                                From Product_Interest__c
                                                Where Lead__c =: leadId]) {
                leadProducts.add(leadProduct);
                productIds.add(leadProduct.Product__c);
            }
            System.debug('>>> productIds '+productIds);
        }  
                                
               
            if (leadInfo.Account_Name__c == null && (!FromConvertToContact)) {
            errorMessage += '\n '+ Label.LC_Error_Account_Not_Found +'\n'; 
            isRender = false; 
            isCase = true;                                 
        }
        if (leadInfo.Owner.Type == 'Queue') {
            //If lead owner is queue, then show error message as after lead conversion when Account ,Contact gets created, its owner cannot be a queue.
            errorMessage += '\n '+ Label.LC_Error_Owner +'\n';              
            System.debug('/////////2');
            isRender = false;                                 
        } 
               
        if (leadInfo.phone == null && leadinfo.Email == null && (!FromConvertToContact)) {
            //If lead owner is queue, then show error message as after lead conversion when Account ,Contact gets created, its owner cannot be a queue.
            errorMessage += '\n '+ Label.LC_Error_Phone +'\n';              
            System.debug('/////////3');
            isRender = false;                                 
        }
        
        
        /* R6 - Vinaykumar M
         * @description - The Lead shouldn't get converted if the Lead Email contains @amplified.com   
        */
        //start
         if (leadInfo.Email != null){
            checkEmail = leadInfo.Email;
            Boolean b1 = checkEmail.containsIgnoreCase('@amplified.com');
            
            if(b1){
                errorMessage +='\n '+ Label.LM_Error_Email+'\n';
                isRender = false;
            }
        }
        //end
        
        /** Author: HP
        * Date: 3-AUG-2012  
        * Requirement # Defect Id-1602(R2.0)
        * @description -  This checks Lead Acceptance as Accepted before Lead Conversion. 
        */ 
      //  if (leadInfo.Lead_State__c != 'Accepted') {    : Commented and modified for R6 Req. : Allow lead conversion of states "Accepted" and "New"
         if (leadInfo.Lead_State__c != 'Accepted' && leadInfo.Lead_State__c != 'New' && (!FromConvertToContact)) {
           //Lead State should be Accepted , then only user can convert the lead.
            errorMessage += '\n '+ Label.LC_Error_State_And_Status +'\n';              
            System.debug('/////////4');
            isRender = false;                                 
        }
        
        Profile p=[select name from Profile where id = :userinfo.getProfileId()];
        if(p.name.contains('Partner'))
        notPartner=false;
        else notPartner=true;
    }
    
    /**
    * Author: HP
    * Date: 27-JUNE-2012  
    * Requirement # Request Id: 1787(R2.0)
    * @description -  This method will Create a new Case, whenever user clicks on 'Create New Case' custom buttton. 
    */ 
    public PageReference createCase() 
    {
        rtMapByName = Case.SObjectType.getDescribe().getRecordTypeInfosByName();
        caseRecordTypeId = rtMapByName.get(Label.Account_Request).getRecordTypeId();
        PageReference pgref = new PageReference('/500/e?retURL='+caseRecordTypeId);
        return pgref;
    }
    
    /**
    * @description -  This method will convert the lead, whenever user clicks on Convert custom buttton.
    * @return: PageReference-Page refernece CheckContactBeforeConvert for existing contact or to Lead details page 
    */      
    public PageReference leadConvert() {
      // R 5.0 By RS: Added below code as per CR 6908.
      
       bypassOpptyTrigger = true;
      try{
       if(userinfo.getUserType() == 'Standard'){
           if(lead.Conv_Lead_Owner__c != null){
               User objUser = [select id,IsPortalEnabled from User where Id=:lead.Conv_Lead_Owner__c];
               if(objUser != null){
                   if(objUser.IsPortalEnabled){
                       Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.LeadConvertPartnerUserError));
                       //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, );
                       return null;
                   }    
               }
               
           }
           
       }
       }catch(Exception e){
        System.debug('+++++Exception in LeadConvertController:leadConvert() when checking for Standard UserType'+e);
       }
       Boolean performLeadConversion = false;
       fromLeadConversion=true;
       PageReference returnToPage = null;
       List<Contact> matchingContacts = new List<Contact>();
      try{
       leadInfo.OwnerId = lead.OwnerId;
       leadInfo.Account_Name__c = lead.Account_Name__c;
       if (leadName!= '' && leadName!= null) {
            matchingContacts = getContacts(leadInfo.Account_Name__c,leadName);
            if (matchingContacts.size() > 0) {
                PageReference redirectToContactPage = 
                    new PageReference('/apex/CheckContactBeforeConvert?accId='+leadInfo.Account_Name__c+'&leadId='+leadId+'&ownerId='+lead.Conv_Lead_Owner__c+'&oppFlag='+doNotCreateOpty+'&emailFlag='+sendNotificationEmail+'&leadcompany='+lead.company.remove('&'));
                redirectToContactPage.setRedirect(true);

                return redirectToContactPage;
            } 
            else {
                performLeadConversion=true;                
            }
        } 
        else {
            performLeadConversion=true;
        }
      }catch(Exception e){
        System.debug('+++++Exception in LeadConvertController:leadConvert()-while checking for LeadName'+e);
      }   
      try{
        if (performLeadConversion) {          
            //Convert lead in system context, as user doesnot have C/M/D access on Account.
            Database.LeadConvertResult lcr = null;
            if (leadInfo.Account_Name__c != null && leadId != null) {
                isaccount = false;
                //lcr = doConversion(opp.AccountId, doNotCreateOpty, leadId, opp.ownerId, lead.company, sendNotificationEmail, leadInfo, leadCurrency);
                lcr = doConversion(leadInfo.Account_Name__c, doNotCreateOpty, lead.Conv_Lead_Owner__c, sendNotificationEmail, leadInfo);
            }  
            if (lcr != null) {
                if (lcr.isSuccess()) {
                    if(FromConvertToContact)
                        returnToPage = new PageReference('/'+ lcr.getContactId());
                    
                    else
                        returnToPage = new PageReference('/'+ leadId);
                    returnToPage.setRedirect(true);
                } 
                else {
                    errorMessage = Label.LC_Error +' '+lcr.getErrors();              
                    isRender = false;                                           
                }
            } 
            else {
                errorMessage = Label.LC_Error;  
                if (leadInfo.Account_Name__c == null) {                       
                    errorMessage = Label.LC_Error_Account;    
                } 
                else {           
                    isRender = false;
                }                                   
            }
        } 
       }catch(Exception e){
         System.debug('+++++Exception in LeadConvertController:leadConvert()@@@if(performLeadConversion) loop'+e); 
       }
        return returnToPage;
        
    }    

    /**
    * @description -  Get the list of accounts whose name matches with the lead company.
    * @param String leadCompany - Company name on lead
    * @return List<Account> - List of account
    */
    public List<Account> getAccounts(String leadCompany) {
        List<Account> accountList = new List<Account>();
        String company = '';
        if (leadCompany != null && leadCompany != '') {
            Id RecordTypeId=null;
            try {
                RecordTypeId = RecordTypeIdHelper.getRecordTypeId ('Account','Customer');
            }
            catch(Exception ex) {
                CreateApexErrorLog.insertHandledExceptions(ex, null, 'Account', 'LeadConvertController', 'Class');
            }
            //company = '%'+leadCompany+'%';
            company = leadCompany+'%';
            accountInfo = new Map<Id, Account>(); 
            for (Account acc : [Select Id, Name, Fax, CurrencyIsoCode, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity
                                    From Account 
                                    Where Name like :company
                                    And RecordTypeId = :RecordTypeId limit 5]) {
                                                        
                accountList.add(acc);
                accountInfo.put(acc.Id, acc);
            }
        }
        return accountList;
    }
    
    /**
    * @description -  Get the list of contacts accessible to User.
    * @param String selectedAccountId - Selected Account Id, String LeadName - Name of Lead
    * @return List<Contact> - List of Contact
    */        
    public List<Contact> getContacts(String selectedAccountId,String LeadName) {
        List<Contact> contactList = new List<Contact>();
        String leadNameToMatch = '';
        if (leadName != null && leadName != '' && selectedAccountId != null && selectedAccountId != '') {
            leadNameToMatch = '%'+leadName;
            for (Contact con : [Select Id, Name 
                                    From Contact 
                                    Where accountId = :selectedAccountId 
                                    And Name like :leadNameToMatch limit 500]) {
                contactList.add(con);
            }
        }
        return contactList;
    }
    
     
    // R6 : To convert Leads in "New" state: Update lead status as 'Accepted' - START
        public void updateLeadState(Id ldId){
            leadState =   [Select Id, Name, Lead_state__c  FROM Lead WHERE Id = :ldId];
            if(leadState!=null){
                System.debug('Lead state: '+leadState.Lead_state__c);
                if(leadState.Lead_state__c == 'New'){
                    System.debug('******** Updating lead state to Accepted...');
                    leadState.Lead_state__c = 'Accepted'; 
                    update leadState; 
                    System.debug('********  Updated lead state to Accepted.');
                }
            }
        }
    // R6 : To convert Leads in "New" state : Update lead status as 'Accepted' - END  


    /**
    * @description -  Convert a lead to Account, Contact, Opportunity.
    * @param accountId - Selected Account Id, doNotCreateOpty - Create or do not create opty, ownerId - Lead owner id, 
    *                       sendNotificationEmail - To send email or not, leadInfo - Current lead information
    * @return Database.LeadConvertResult - Success or Failure
    */  
     public Database.LeadConvertResult doConversion(Id accountId, Boolean doNotCreateOpty, Id ownerId, Boolean sendNotificationEmail, Lead leadInfo) {
        
           // R6 - If lead state is "New", update  as 'Accepted' to continue with lead conversion - START
        if(leadInfo.Lead_State__c == 'New')
               updateLeadState(leadInfo.Id);
        // R6 - update lead state as 'Accepted' - END
     
        Database.LeadConvert lc = new database.LeadConvert();
        Id contatId = lc.getContactId();
        System.debug('************contactId'+contatId);
        lc.setLeadId(leadInfo.Id);
        lc.setOwnerId(ownerId);
        lc.setAccountId(accountId);  
        lc.setDoNotCreateOpportunity(doNotCreateOpty);
        //Set Opportunity name if doNotCreateOpty is false.
        if(!doNotCreateOpty) {
            lc.setOpportunityName(lead.company);
        }
        
        if(FromConvertToContact){
            lc.setConvertedStatus('Closed');
            
        }
        else 
            lc.setConvertedStatus('Working');
            
        lc.setSendNotificationEmail(sendNotificationEmail); 
        
        if(!FromConvertToContact){
        
        //OCR = new OpportunityContactRole();//Added
        
         CampaignInfluence= new List<Campaign_Influence__c>();//Added        
        /* Initializing Notes and Attachments */
        notes = new List<Note>();
        attachments = new List<Attachment>();
        leadNotes = new List<Note>();
        leadAttachments = new List<Attachment>();
           /* Fetching Campaign before Lead Conversion*/
          for(CampaignMember campMember :[Select Id,CampaignId,Primary__c from CampaignMember where LeadId =: leadId]){
            System.debug('************campMember'+campMember);
            System.debug('************campmemberList'+campmemberList);
            campmemberList.add(campMember);
            campId.add(campMember.CampaignId);
            System.debug('************campId*****'+campId);
           // campmemberList.add(campMember);
            System.debug('************campmemberList'+campmemberList);

        }
        System.debug('*****campId'+campId);
        for(Campaign camp : [Select Id,Name,Type from Campaign where Id IN: campId]){
           campList.add(camp);
           System.debug('*****campList'+campList); 
        }
        System.debug('*****campList'+campList);
        }
        
        /* Initializing Notes and Attachments */
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
        
        Database.LeadConvertResult lcr = null; 
        try {
            bypassOpptyTrigger = true;
            lcr = Database.convertLead(lc);
            system.debug('!!!@@@@LCR'+lcr);            
            //If Account has different currency than Lead, then Opportunity currency should be copied from Account and not from Lead.
            If (lcr.isSuccess()) {
                Id optyId;
                Id contactId = lcr.getContactId();
                 System.debug('*****contactId - '+contactId);
              if(doNotCreateOpty == false)
                    optyId = lcr.getOpportunityId();
                updateOptyAfterLeadConversion(contactId, accountId, optyId, leadInfo, leadInfo.CurrencyIsoCode);
            }
        } 
        catch (Exception e) {
            System.debug('??????'+e);
            CreateApexErrorLog.insertHandledExceptionsForLeadConversion(e, lcr, 'Lead', 'LeadConvertController', 'Class');
        }
        return lcr;
    }   
    
    /**
    * @description -  Update currency as per the account currency. Convert opty amount as per the opty currency. 
    *                   Update Description on the converted opty to lead's Product Service Solution
    * @param - Id accountId - Selcted account id, Id optyId - Converted opportunuty id, Lead - Current lead infomormation, String leadCurrency - Current lead currency 
    */          
    public void updateOptyAfterLeadConversion(Id contactId,Id accountId, Id optyId, Lead leadInfo, String leadCurrency) {
        Opportunity optyAmountUpdate = new Opportunity();        
        Account account = new Account();
        notes = new List<Note>();
        attachments = new List<Attachment>();
        if (accountId != null) {    
            account = [Select Id, CurrencyIsoCode 
                            From Account
                            Where Id = :accountId]; 
        }
        System.debug('*****contactId 2 - '+contactId); 
        for(OpportunityContactRole ocrTemp : [Select contactId,OpportunityId,Role from OpportunityContactRole where contactId=: contactId AND OpportunityId =:optyId]){
                
            if(leadInfo.Purchaser_Role__c == 'Business Sponsor' || leadInfo.Purchaser_Role__c == 'Business Sponsor / Banker' ||
               leadInfo.Purchaser_Role__c == 'Buyer'|| leadInfo.Purchaser_Role__c == 'Decision Maker' ||leadInfo.Purchaser_Role__c == 'Secondary Decision Maker'){
                    ocrTemp.Role = 'Decision Maker';
             }
             else if(leadInfo.Purchaser_Role__c == 'Evaluator/Recommender'|| leadInfo.Purchaser_Role__c =='Key Contact'){
                 ocrTemp.Role = 'Subject Matter Expert';
             } 
             else if(leadInfo.Purchaser_Role__c == 'Influencer'){
                 ocrTemp.Role = 'Political Influencer';
             }
             else if(leadInfo.Purchaser_Role__c == 'VIP / Key Contact'){
                 ocrTemp.Role = 'Executive';
             }
             else{
                ocrTemp.Role = null; 
             }
             OCRlist.add(ocrTemp);
        }
        for(Campaign cam : campList){
            for(CampaignMember cammem : campmemberList){
                if(cammem.CampaignId == cam.Id){
                                     CampaignInfluence.add(new Campaign_Influence__c(Opportunity__c = optyId,Campaign__c = cam.Id,Contact__c = contactId,
                                         Primary_Campaign_Source__c =cammem.Primary__c));  
                 }
               system.debug('Contact in CampaignInfluence@@@'+ContactId);
              system.debug('CampaignInfluence@@@'+CampaignInfluence);   
            }
        }
        /* @description - Adding Notes And Attachments for new Opportunity */
        Id id;
        if(FromConvertToContact){
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
        System.debug('///////2'+leadNotes.size());
        if(!FromConvertToContact){
            for (Note note: leadNotes) {
                //note.ParentId = id;
                //notes.add(new Note( Title = note.Title, ParentId = id, Body = note.Body, OwnerId = note.OwnerId, IsPrivate = note.IsPrivate));
                // R6 : EF-01 : Removed 'OwnerId" in Notes to fix the case:00220029.
                notes.add(new Note( Title = note.Title, ParentId = id, Body = note.Body, IsPrivate = note.IsPrivate));
            }
        }
        /***************CR-249**************/
        if(leadInfo.description != null){
            notes.add(new Note(Title = 'Lead Sales Notes', ParentId = id,
                            Body = leadInfo.description ));
        }
        if(leadInfo.Additional_Notes__c != null){
            notes.add(new Note(Title = 'Lead Marketing Notes', ParentId = id,
                            Body = leadInfo.Additional_Notes__c));
        }
        if(!FromConvertToContact){
            for (Attachment attachment: leadAttachments) {
                
                //attachment.ParentId = id;
                 attachments.add(new Attachment( Name = attachment.Name, ParentId = id,
                                                OwnerId = attachment.OwnerId,
                                                Body = attachment.Body, 
                                                Description = attachment.Description,
                                                ContentType = attachment.ContentType,
                                                IsPrivate = attachment.IsPrivate));
            }
        }
        try {
        System.debug('*******OCRlist.sze()**'+OCRlist.size());
            update leadNotes;
            update leadAttachments;
            if(!OCRList.isEmpty()){
                update OCRList;
            }
            if (!notes.isEmpty()) {
                System.debug('//////3NotesSize'+notes.size());
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
        /**/
        
        
        //Check if account and lead has same currency or not.If not then update opportunity with Account currency.
        if (optyId != null) {
            Opportunity opty = new Opportunity( id = optyId,
                                                Converted_From_Lead__c = 1,Lead_Created_Date__c = leadCreationDate,Lead_Creator__c = leadCreatedBy);
                                               
                                                                                    
            /* Partner Collab */
            opty = PartnerCollabOpportunityUtil.PartnerleadConversion(opty);
            /*if (leadCurrency != account.CurrencyIsoCode) {
                opty.CurrencyIsoCode = leadCurrency;
            }*/
            String optyDescription = '';
                       
            if (leadInfo.Product_Service_Solution__c != null){
                optyDescription = Label.LC_Product_Service_Solution +' '+leadInfo.Product_Service_Solution__c;
            }
            
            opty.description = optyDescription;
            opty.CurrencyIsoCode = leadCurrency;
            opty.List_Id__c = leadInfo.List_ID__c;
            opty.Tactic_Name__c = leadInfo.Tactic_Name__c; 
            opty.Tactic_ID__c = leadInfo.Tactic_Code__c;
            opty.List_Name__c = leadInfo.List_Code__c;            
            /* R6 - Vinaykumar M 
             * @description - Auto population of the 'Lead ID' Field with the ID of the Lead when Converted. 
            */
            //start
            opty.Lead_ID__c=leadInfo.Id;
            //end
            try {
                System.debug('???????updateOpty1');
                update opty;
                System.debug('???????updateOpty2');
            } 
            catch (DMLException ex) {
                System.debug('R2 >>>> In Exception: '+ex);
                CreateApexErrorLog.insertHandledExceptions(ex, null, 'Opportunity', 'LeadConvertController', 'Class');
            }
                            
           optyAmountUpdate = [Select Id, Amount, Opportunity_Total_Amount__c, CloseDate, 
                                    Converted_From_Lead__c, Lead_Created_Date__c
                                From Opportunity
                                Where Id = :optyId]; 
            optyAmountUpdate.Amount = optyAmountUpdate.Opportunity_Total_Amount__c;
            try {    
                update optyAmountUpdate;
            } 
            catch (DMLException ex) {
                System.debug('R2 >>>> In Exception: '+ex);
                CreateApexErrorLog.insertHandledExceptions(ex, null, 'Opportunity', 'LeadConvertController', 'Class');
            }
            /** 
            * @description - to transfer lead products into opportunity line items 
            */
            List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
            
            Pricebook2 pricebook = [SELECT Id, Name, IsActive From Pricebook2 WHERE Name = 'Products & Services' AND IsActive = true];
            System.debug('>>>> pricebook: '+pricebook);
            
            for(PricebookEntry pbEntry: [Select Product2Id, Id 
                                            From PricebookEntry 
                                            Where Pricebook2Id =: pricebook.Id 
                                            And Product2Id in : productIds 
                                            And CurrencyIsoCode =: leadCurrency]){
                /*
                    SFDC R6.0 By RS:- Putting unit price value 0 as per R6.0 requirement.
                */
                OpportunityLineItems.add(new OpportunityLineItem(
                                               opportunityid = optyId,
                                               quantity = 1, 
                                               UnitPrice = 0,
                                               ServiceDate = optyAmountUpdate.CloseDate,
                                               PricebookEntryId = pbEntry.Id));
    
            }
            System.debug('>>>> OpportunityLineItems: '+OpportunityLineItems);
            try {
                if (!OpportunityLineItems.isEmpty()) {
                    insert OpportunityLineItems;
                    System.debug('******OpportunityLineItems*'+OpportunityLineItems);
                }
            } 
            catch (DMLException ex) {
                System.debug('R2 >>>> In Exception: '+ex);
                CreateApexErrorLog.insertHandledExceptions(ex, null, 'Opportunity', 'LeadConvertController', 'Class');
            }
            /* End of lead product addition */
        } 
        
        /* Updating Account Information */
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
    }
    
    /**
    *   @description - Check for valid account id 
    */
    public void checkForValidAccount() {
        
        if (lead.Account_Name__c == null) {
            isaccount = true;
        } else {
            isaccount = false;
        }
    }

   }