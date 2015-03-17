/**********************************************************
* Class Name: TestingSetupDataUtil
* Author: Accenture
* Date: 09-May-2012 
* Description: This class is used as a util class to create test data in test methods.
***********************************************************/
@isTest(SeeAllData=True)
public class TestingSetupDataUtil{
/* 
* Insert a Case record
* @param - String reason, String origin, String status, String ownerId
* @returns - Case 
*/
public static Case createCase(String reason, String origin, String status, String ownerId) {
    Case objCase = new Case();
    objCase.Reason = reason;
    objCase.Origin = origin;
    objCase.Status = status;
    objCase.OwnerId = ownerId;
    return objCase;
}

/* 
* 
 a TurnValidationOff__c record
* @param - String userName
* @returns - TurnValidationOff__c 
*/ /* 
public static TurnValidationOff__c createTurnValidationOff(String userName) {
    TurnValidationOff__c objTurnValidationOff = new TurnValidationOff__c(); 
    objTurnValidationOff.Username__c = userName;
    return objTurnValidationOff;
}
*/
    /* 
* Insert a Admin_Profiles__c record
* @param - String name, String module, Id profileId
* @returns - Admin_Profiles__c 
*/  
public static Admin_Profiles__c createAdminProfile(String name, String module, Id profileId) {
    Admin_Profiles__c objAdminProfiles = new Admin_Profiles__c(); 
    objAdminProfiles.Name = name;
    objAdminProfiles.Module__c = module;
    objAdminProfiles.Profile_ID__c = Userinfo.getProfileId();
    return objAdminProfiles;
}

/* 
* Insert a Related_Opportunities__c record
* @param - Id optyId, Id relatedOptyId
* @returns - Related_Opportunities__c 
*/      
public static Related_Opportunities__c createRelatedOpportunities(Id optyId, Id relatedOptyId) {
    Related_Opportunities__c objRelatedOpportunities = new Related_Opportunities__c();
    objRelatedOpportunities.Opportunity__c = optyId;
    objRelatedOpportunities.Related_Opportunity__c = relatedOptyId;
    return objRelatedOpportunities;
}

/* 
* Insert a Sales_Process_Linkage__c record
* @param - String optyId
* @returns - Sales_Process_Linkage__c 
*/  
public static Sales_Process_Linkage__c createSalesProcessLinkage(String optyId) {
    Sales_Process_Linkage__c objSalesProcessLinkage = new Sales_Process_Linkage__c();
    objSalesProcessLinkage.Opportunity__c = optyId;
    objSalesProcessLinkage.ID_Type__c = 'Eclipse';
    Double randomstr = Math.round(Math.random()*Math.pow(10, 7))+0.0100011;
    objSalesProcessLinkage.ID__c =string.valueOf(randomstr).substring(0,6);
    return objSalesProcessLinkage;
}
/**
* Create a queue
* @return - Queue Id
*/    
public static ID fetchQueue() {
    String queueId = '';
        User queue = [Select Id From User Where UserType  = 'Queue' Limit 1];
        if (queue != null ) {
            queueId = queue.Id;
            return queueId;
        }else{
        return null;
        }  
    }

/**
    * Insert a lead record
    * @param - String leadLastName, String leadCompany, String leadStatus, String leadState, String phone, String email
    * @returns - Lead 
    */
public static Lead createLead(String leadLastName, String leadCompany, String leadStatus, String leadState, String phone, String email) {
        Lead lead = new Lead();
        lead.LastName = leadLastName;
        lead.company = leadCompany;
        lead.Status = leadStatus;
        lead.Lead_State__c = leadState;
        lead.Phone = phone ;
        lead.email = email;
        lead.Budget__c = 'Yes';
        lead.Authorized_Buyer__c = 'No';
        lead.Timeframe_to_Buy_1__c = '< 1 Month';
        lead.Product_Service_Solution__c = 'PSS';
        //insert lead;
        return lead;
    } 

/**
* Insert a Account record
* @param - String accountName, String accountEmail,String recordType
* @returns - Account 
*/
public static Account createAccount(String accountName, String accountEmail,String recordType) {
    String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account',recordType);
    Account account = new Account();
    account.Account_E_mail__c = accountEmail;
    account.Name = accountName;
    account.RecordTypeId = RecordTypeId;
    account.CurrencyIsoCode='USD';
    // Karthik : Aug 06, 2013 : Providing Correct Shipping Country : Start
    account.ShippingCountry='United States';
    // Karthik : Aug 06, 2013 : Providing Correct Shipping Country : End
    return account;
    }
    
 /**
* Insert a Contact record on an existing account
* @param - String accountId, String contactLastName
* @returns - Contact 
*/
public static Contact createContact(String accountId, String contactLastName) {
    Contact contact = new Contact();
    contact.AccountId = accountId;
    contact.LastName = contactLastName;
    contact.Phone = '55555';
    contact.Email = 'test@hp.com';
    return contact;
    }

/**
* Insert a Opportunity record
* @param - String opportunityAccountId, String OpportunityName, Date CloseDate
* @returns - opportunity 
*/    
public static Opportunity createOpportunity(String opportunityAccountId, String OpportunityName, Date CloseDate) {
        Opportunity opportunity = new Opportunity();
        opportunity.Name = OpportunityName;
        opportunity.CloseDate = CloseDate;      
        opportunity.AccountId = opportunityAccountId;
        opportunity.StageName = '01 - Understand Customer';
        opportunity.CurrencyIsoCode= 'USD';
        return opportunity;
    }  
    
/**
* Insert a OpportunityTeamMember record
* @param - ID UserId ,String TeamMemberRole,ID OpportunityId
* @returns - OpportunityTeamMember 
*/  
public static OpportunityTeamMember createOpportunityTeamMember(ID UserId ,String TeamMemberRole,ID OpportunityId ){
OpportunityTeamMember objOpportunityTeamMember  = new OpportunityTeamMember();
objOpportunityTeamMember.UserId = UserId ;
objOpportunityTeamMember.TeamMemberRole = TeamMemberRole;
objOpportunityTeamMember.OpportunityId = OpportunityId; 
return objOpportunityTeamMember ;
}
/**
* Insert a Campaign record
* @param - Boolean IsActive ,Integer ActualCost,Integer BudgetedCost,String Name,String OwnerId ,String Description ,
            Date EndDate,Integer ExpectedResponse ,Integer ExpectedRevenue,Integer  NumberSent,Date StartDate ,String Status ,String Type
* @returns - Campaign
*/
public static Campaign createCampaign(Boolean IsActive ,Integer ActualCost,Integer BudgetedCost,String Name,String OwnerId ,String Description ,
            Date EndDate,Integer ExpectedResponse ,Integer ExpectedRevenue,Integer  NumberSent,Date StartDate ,String Status ,String Type) {
       Campaign objCampaign = new Campaign();
       objCampaign.IsActive = IsActive;
       objCampaign.ActualCost = ActualCost;
       objCampaign.BudgetedCost = BudgetedCost;
       objCampaign.Name = Name;
       objCampaign.OwnerId = OwnerId;
       objCampaign.Description = Description;
       objCampaign.EndDate = EndDate;
       objCampaign.ExpectedResponse = ExpectedResponse;
       objCampaign.ExpectedRevenue = ExpectedRevenue;
       objCampaign.NumberSent = NumberSent;
       objCampaign.StartDate = StartDate;
       objCampaign.Status = Status;
       objCampaign.Type = Type;
       return objCampaign;
   }
/**
* Insert a CampaignMember record
* @param - String CampaignId,String ContactId,Boolean Primary,String LeadId
* @returns - CampaignMember 
*/   
   
   public static CampaignMember createCampaignMember(String CampaignId,String ContactId,Boolean Primary,String LeadId){
        CampaignMember objCampaignMember = new CampaignMember();
        objCampaignMember.CampaignId = CampaignId;
        objCampaignMember.ContactId = ContactId;
        objCampaignMember.Primary__c = Primary;
        objCampaignMember.LeadId = LeadId;
        return objCampaignMember;
    }
/**
* Insert a User record
* @param - String alias,String email,String EmailAddress,String emailencodingkey,String lastname,String languagelocalekey,String localesidkey,String timezonesidkey,String username,String EmployeeNumber,ID profileId
* @returns - User 
*/    
    public static User createUser(String alias,String email,String EmailAddress,String emailencodingkey,String lastname,String languagelocalekey,String localesidkey,String timezonesidkey,String username,String EmployeeNumber,ID profileId){
        User internalUser = new User();
        internalUser.alias = alias ;
        internalUser.email=email; 
        internalUser.Email_Address__c=EmailAddress;
        internalUser.emailencodingkey=emailencodingkey;
        internalUser.lastname=lastname;  
        internalUser.languagelocalekey=languagelocalekey; 
        internalUser.localesidkey=localesidkey;
        internalUser.timezonesidkey=timezonesidkey;
        internalUser.username=username;
        internalUser.EmployeeNumber = EmployeeNumber ;
        internalUser.Legacy_Employee_Ref__c = EmployeeNumber ;
        internalUser.ProfileId = profileId ;
        internalUser.Adoption_Role_Type__c='Account Executive';
        return internalUser;
    }

/**
* Insert a User record
* @param - String userId, String mangerId
* @returns - User 
*/    
    public static User updateUserWithManager(Id userId, Id mangerId){
        User updateUser = new User(Id = userId); 
        updateUser.ManagerId = mangerId;
        return updateUser;
    }     
/**
* Insert a AccountTeamMember record
* @param - ID UserId,String TeamMemberRole ,ID AccountId
* @returns - AccountTeamMember 
*/    
    public static AccountTeamMember createAccTeamMembers(ID UserId,String TeamMemberRole ,ID AccountId){
    AccountTeamMember objAccTeamMembers = new AccountTeamMember();
    objAccTeamMembers.UserId = UserId;
    objAccTeamMembers.TeamMemberRole = TeamMemberRole ;
    objAccTeamMembers.AccountId = AccountId ;
    return objAccTeamMembers;
    }
    
/* 
* Insert a UserAccountTeamMember record
* @param - ID UserId,String TeamMemberRole ,ID OwnerId, String OpportunityAccessLevel, String CaseAccessLevel, String AccountAccessLevel
* @returns - UserAccountTeamMember 
*/    
    public static UserAccountTeamMember createUserAccTeamMembers(ID UserId,String TeamMemberRole ,ID OwnerId, String OpportunityAccessLevel, String CaseAccessLevel, String AccountAccessLevel ){
    UserAccountTeamMember objUserAccTeamMembers = new UserAccountTeamMember();
    objUserAccTeamMembers.UserId = UserId;
    objUserAccTeamMembers.TeamMemberRole = TeamMemberRole ;
    objUserAccTeamMembers.OwnerId = OwnerId;
    objUserAccTeamMembers.OpportunityAccessLevel= OpportunityAccessLevel;
    objUserAccTeamMembers.CaseAccessLevel= CaseAccessLevel;
    objUserAccTeamMembers.AccountAccessLevel = AccountAccessLevel ;
    return objUserAccTeamMembers;
    }

/* 
* Insert a UserTeamMember record
* @param - ID UserId,String TeamMemberRole ,ID OwnerId, String OpportunityAccessLevel 
* @returns - UserTeamMember 
*/ 
public static UserTeamMember createTeamMembers(ID UserId,String TeamMemberRole ,ID OwnerId, String OpportunityAccessLevel ){
    UserTeamMember objTeamMembers = new UserTeamMember();
    objTeamMembers.UserId = UserId;
    objTeamMembers.TeamMemberRole = TeamMemberRole ;
    objTeamMembers .OwnerId = OwnerId;
    objTeamMembers .OpportunityAccessLevel= OpportunityAccessLevel;
    return objTeamMembers;
    }   
    
/* 
* Insert a Chanel Partner
* @param - ID Opportunity ,String PartnerType ,ID ChannelPartner
* @returns - Channel Partner 
*/ 
public static Channel_Partner__c createChannelPartner(ID Opportunity ,String PartnerType ,ID ChannelPartner){
    Channel_Partner__c objChannelPartner = new Channel_Partner__c();
    objChannelPartner.Opportunity__c = Opportunity ;
    objChannelPartner.Partner_Type__c= PartnerType ;
    objChannelPartner.Channel_Partner__c= ChannelPartner;
    return objChannelPartner;
    }   
    
    public static User testUser {
        get {
            if(testUser == null) {
                //generate Random String 
                String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        
                //Create user with unique alias,email,username from current running context user’s list.
                testUser = new User(Alias = 'DA_' + randomstr.substring(0,4),
                                        Email = randomstr + 'userTestSampleclassTest@hp.com',
                                        Email_Address__c=randomstr + 'userTestSampleclassTest@hp.com',
                                        LastName='Testing',
                                        EmailEncodingKey='UTF-8', 
                                        LanguageLocaleKey='en_US', 
                                        LocaleSidKey='en_US', 
                                        TimeZoneSidKey='America/Los_Angeles',
                                        ProfileId = userInfo.getProfileId(),
                                        Username = 'userTest' + randomstr + 'SampleclassTest@hp.com',
                                        EmployeeNumber = 'Emp' + randomstr.substring(0,4),
                                        Legacy_Employee_Ref__c = 'Emp' + randomstr.substring(0,4),
                                        Business_Group__c = 'PSG', 
                                        Region__c = 'EMEA');
                /* Karthik : Aug 05, 2013 : Start : Providing User Role Type Data which is Mandatory : Start */
                testUser.Adoption_Role_Type__c = 'IT';
                /* Karthik : Aug 05, 2013 : End */
                insert testUser;
            }
            return testUser;
        }
        set;}
/* 
* Insert a Product2 
* @param - Boolean isactive ,String Name,String CurrencyIsoCode,String ProductCode 
* @returns - Product2  
*/        
public static Product2 createProduct(Boolean isactive ,String Name,String CurrencyIsoCode,String ProductCode  ){
       Product2 prod = new Product2();
       prod.isActive = isactive;
       prod.Name=Name;
       prod.CurrencyIsoCode = CurrencyIsoCode;
       prod.ProductCode =ProductCode;
       return prod;
       }
/* 
* Insert a PricebookEntry 
* @param - ID prodId,Boolean isActive,ID standardPriceBook2Id,Integer UnitPrice,String CurrencyIsoCode
* @returns - PricebookEntry 
*/        
       public static PricebookEntry createPricebookEntry(ID prodId,Boolean isActive,ID standardPriceBook2Id,Integer UnitPrice,String CurrencyIsoCode){
       PricebookEntry objPricebookEntry = new PricebookEntry();
       objPricebookEntry.Product2Id = prodId;
       objPricebookEntry.isActive = isActive ;
       objPricebookEntry.priceBook2Id = standardPriceBook2Id;
       objPricebookEntry.UnitPrice=UnitPrice;
       objPricebookEntry.CurrencyIsoCode = CurrencyIsoCode ;
       insert objPricebookEntry;
       /********************** Pricebook entry with Products & Services Pricebook*******/
       
       PricebookEntry HPPricebookEntry = new PricebookEntry();
       Pricebook2 HPPricebook = [select id from Pricebook2 where Name = 'Products & Services' limit 1];
       HPPricebookEntry.Product2Id = prodId;
       HPPricebookEntry.isActive = isActive ;
       HPPricebookEntry.UseStandardPrice = false;
       HPPricebookEntry.priceBook2Id = HPPricebook.Id;
       HPPricebookEntry.UnitPrice=UnitPrice;
       HPPricebookEntry.CurrencyIsoCode = CurrencyIsoCode ;
       return HPPricebookEntry;
       }
/* 
* Insert a OpportunityLineItem 
* @param - Decimal Discount,Integer Quantity,Integer UnitPrice,ID opportunityid,ID pricebookentryid,Date ServiceDate
* @returns - OpportunityLineItem 
*/       
       public static OpportunityLineItem createOpportunityLineItem(Decimal Discount,Integer Quantity,Integer UnitPrice,ID opportunityid,ID pricebookentryid,Date ServiceDate){
       OpportunityLineItem objOpportunityLineItem = new OpportunityLineItem();
       objOpportunityLineItem.Discount=Discount;
       objOpportunityLineItem.Quantity =Quantity ;
       objOpportunityLineItem.UnitPrice =UnitPrice ;
       objOpportunityLineItem.opportunityid=opportunityid;
       objOpportunityLineItem.pricebookentryid=pricebookentryid;
       objOpportunityLineItem.ServiceDate = ServiceDate;
       return objOpportunityLineItem;       
       }
       
       
       /* 
* Insert a OpportunityLineItemSchedule 
* @param - ID OpportunityLineItemid,Double Quantity,Date ScheduleDate
* @returns - OpportunityLineItemSchedule 
*/       
       public static OpportunityLineItemSchedule createOpportunityLineItemSchedule(ID OpportunityLineItemid,Double Quantity,Date ScheduleDate){
       OpportunityLineItemSchedule objOpportunityLineItemSchedule = new OpportunityLineItemSchedule();
       objOpportunityLineItemSchedule.opportunityLineItemid=opportunityLineItemid;
       objOpportunityLineItemSchedule.Quantity =Quantity ;
       objOpportunityLineItemSchedule.ScheduleDate = ScheduleDate;
       return objOpportunityLineItemSchedule;       
       }
       
          
       /* 
* Insert a Pricebook2 
* @param - String Name,Boolean isactive
* @returns - Pricebook2 
*/        
public static Pricebook2 createPriceBook(String Name,Boolean isactive){
       Pricebook2 newBook = new Pricebook2 ();
       newBook.isActive = isactive;
       newBook.Name=Name;
       return newBook ;
       }
/* Insert a OpportunityShare 
* @param - String OpportunityAccessLevel,ID UserOrGroupId , ID OpportunityId
* @returns - OpportunityShare 
*/          
public static OpportunityShare createOpportunityShare(String OpportunityAccessLevel,ID UserOrGroupId , ID OpportunityId ){
       OpportunityShare objOpportunityShare  = new OpportunityShare();
       objOpportunityShare.OpportunityAccessLevel =OpportunityAccessLevel ;
       objOpportunityShare.UserOrGroupId =UserOrGroupId ;
       objOpportunityShare.OpportunityId =OpportunityId ;
       return objOpportunityShare ;
       }

/* Insert a Support Request 
* @param - ID OpportunityID
* @returns - Support_Request__c 
*/          
public static Support_Request__c createSupportRequest(ID OpportunityID,String RequestDescription){
       Support_Request__c objSupportRequest = new Support_Request__c();
       objSupportRequest.Opportunity__c = OpportunityId ;
       objSupportRequest.Request_Description__c = RequestDescription;
       return objSupportRequest;
       }
/* Insert a Support Request 
* @param - ID OpportunityID
* @returns - Support_Request__c 
*/          
public static Product_Interest__c createProductInterest(ID leadId, ID productId){
       Product_Interest__c objProdInterest = new Product_Interest__c();
       objProdInterest.Lead__c = leadId ;
       objProdInterest.Product__c = productId;
       return objProdInterest;
       }
       
 /* Insert a Campaign Influence 
* @param - ID OpportunityID, CampaignID Id
* @returns - Campaign Influence 
*/          
public static Campaign_Influence__c createCI(ID OpportunityId, ID CampaignId){
       Campaign_Influence__c objCI = new Campaign_Influence__c();
       objCI.Opportunity__c = OpportunityId;
       objCI.Campaign__c = CampaignId;
       return objCI;
       }
       
       /* 
* Insert a InstallationManagemnet record
* @param - String opp, String stage, String status
* @returns - Installation Managemnet
*/
public static Installation_Management__c createIM(String opp, String stage, String status) {
    Installation_Management__c objIM = new Installation_Management__c();
    objIM.Opportunity__c= opp;
    objIM.Installation_Stage__c = stage;
    objIM.Order_Status__c = status;

    return objIM;
}
     
}