/**********************************************************
* Class Name: DealTestDataUtil
* Author: HP
* Date: 10-October-2012 
* Description: This class is used as a util class to create test data in test methods for all Deal related classes.
***********************************************************/
@isTest
public class DealTestDataUtil{


public static Pricebook2 getStdPriceBookId(){
Pricebook2 stdPriceBook =  [select id from Pricebook2 where IsStandard = true limit 1];
return stdPriceBook;
}
/* 
* Insert a Product2 
* @param - Boolean isactive ,String Name,String CurrencyIsoCode,String BusinessGroup, String GBU, String ProductLine
* @returns - Product2  
*/        
public static Product2 createProduct(Boolean isactive ,String Name,String CurrencyIsoCode,String BusinessGroup, String GBU, String ProductLine){
       Product2 prod = new Product2();
       prod.isActive = isactive;
       prod.Name=Name;
       prod.CurrencyIsoCode = CurrencyIsoCode;
       prod.Business_Group__c = BusinessGroup;
       prod.GBU__c = GBU;
       prod.Product_Line__c = ProductLine;
       return prod;
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
       
       
/* 
* Insert a PricebookEntry 
* @param - ID prodId,Boolean isActive,ID standardPriceBook2Id,Integer UnitPrice
* @returns - PricebookEntry 
*/        
       public static PricebookEntry createPricebookEntry(ID prodId,Boolean isActive,ID standardPriceBook2Id,Integer UnitPrice){
       PricebookEntry objPricebookEntry = new PricebookEntry();
       objPricebookEntry.Product2Id = prodId;
       objPricebookEntry.isActive = isActive ;
       objPricebookEntry.priceBook2Id = standardPriceBook2Id  ;
       objPricebookEntry.UnitPrice=UnitPrice;
       objPricebookEntry.CurrencyIsoCode = 'USD' ;
       return objPricebookEntry;
       }
       
/**
* Insert a Account record
* @param - String accountName
* @returns - Account 
*/
public static Account createAccount(String accountName) {
    Account account = new Account();
    account.Name = accountName;
    account.ShippingCountry= 'India';
    return account;
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
        opportunity.Managed_By__c= 'HP';
        return opportunity;
    }  
/* 
* Insert a OpportunityLineItem 
* @param - Integer Quantity,Integer UnitPrice,ID opportunityid,ID pricebookentryid, Date ServiceDate
* @returns - OpportunityLineItem 
*/       
       public static OpportunityLineItem createOpportunityLineItem(Integer Quantity,Integer UnitPrice,ID opportunityid,ID pricebookentryid,Date ServiceDate){
       OpportunityLineItem objOpportunityLineItem = new OpportunityLineItem();
       objOpportunityLineItem.Quantity =Quantity ;
       objOpportunityLineItem.UnitPrice =UnitPrice ;
       objOpportunityLineItem.opportunityid=opportunityid;
       objOpportunityLineItem.pricebookentryid=pricebookentryid;
       objOpportunityLineItem.ServiceDate = ServiceDate;
       return objOpportunityLineItem;       
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
        internalUser.Adoption_Role_Type__c= 'IT';
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
* Insert a Campaign record
* @param - String Name
* @returns - Campaign
*/
public static Campaign createCampaign(String Name) {
       Campaign objCampaign = new Campaign();
       objCampaign.Name = Name;
       return objCampaign;
   }
   
/**
* Insert a Deal Registration record
* @param - String Name,Id campaignId,Id opportunityId,Id accountId
* @returns - Deal Registration
*/
public static Deal_Registration__c createDealRegistration(String Name,Id campaignId,Id opportunityId,Id accountId) {
       Deal_Registration__c objDealReg = new Deal_Registration__c ();
       objDealReg.Name = Name;
       objDealReg.Status__c='Open';
       objDealReg.Hidden_Auto_Approve__c=False;
       objDealReg.Program__c= campaignId;
       objDealReg.Opportunity__c=opportunityId;
       objDealReg.Customer_Account__c=accountId;
       objDealReg.Program_Comments__c= 'Testing Deal Registration';
       return objDealReg;
   }
   
/**
* Insert a Product Registration record
* @param - Id dealRegId,String Productline,Id opportunityId
* @returns - Product Registration
*/
public static Product_Registration__c createProductRegistration(Id dealRegId,String Productline,Id opportunityId) {
       Product_Registration__c objProdReg = new Product_Registration__c ();
       objProdReg.Deal_Registration__c = dealRegId;
       objProdReg.Status__c='Approved';
       objProdReg.Product_Line__c=Productline;
       objProdReg.Opportunity__c=opportunityId;
       return objProdReg;
   }
   
   
    
}