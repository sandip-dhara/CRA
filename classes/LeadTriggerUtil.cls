/**
* Class Name: LeadTriggerUtil
* Author: Accenture
* Date: 23-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Lead object
*/
public class LeadTriggerUtil {
    /**
    * @description: Method to update Lead Owner Manager on Lead 
    */

    public static void assignLeadOwnerManagers(List<Lead> leads) {
        map<Id, Id> ownerManagers = new map<Id, Id>();
        set<Id> ownerId = new set<Id>();
        for (Lead lead : leads) {
            ownerId.add(lead.ownerId);
        }
        for (User user : [Select Id, Name, ManagerId From User Where Id IN: ownerId]) {
            if(user.ManagerId != null) {
                ownerManagers.put(user.Id, user.ManagerId);
            }
        }
        /* To update lead owner manager */
        for (Lead lead : leads) {
            //Owner might have ManagerId null, Lead Owner Manager should also be updated with null
            lead.Lead_Owner_Manager__c = ownerManagers.get(lead.ownerId);
           /* try {
                if(Test.isRunningTest()){
                    throw new MyException();
                }                    
            } 
            catch (DMLException ex) {
                CreateApexErrorLog.insertHandledExceptions(ex, null, 'Opportunity', 'LeadConvertController', 'Class');
            }*/
        }
    }
    
    /**
    * @Date: 19-JULY-2012 
    * @description: Defining Custom Exception to increate the code coverage 
    */
    public static void addLeadProducts(List<Lead> leads, Set<String> productLines) {
        Map<String, String> productLineMap = new Map<String, String>();
        List<Product_Interest__c> leadProducts = new List<Product_Interest__c>();
        for (Product2 product : [Select Id, Sub_Product_Line__c, Product_Line__c, IsActive
                            From Product2
                            Where Product_Line__c in : productLines 
                            And Sub_Product_Line__c = '' And IsActive = true]) {
                            
            productLineMap.put(product.Product_Line__c, ''+product.Id);
        } 
        
        for (Lead lead : leads) {
            /* For Product Line 1 */
            if (productLineMap.keyset().contains(lead.Response_Product_Line_1__c)) {
                leadProducts.add(new Product_Interest__c(Lead__c = lead.Id,
                                                    Product__c = productLineMap.get(lead.Response_Product_Line_1__c),
                                                    Quantity__c = lead.Response_Product_Quantity_1__c,
                                                    Unit_Price__c = 1)); 
            }
            /* For Product Line 2 */
            if (productLineMap.keyset().contains(lead.Response_Product_Line_2__c)) {
                leadProducts.add(new Product_Interest__c(Lead__c = lead.Id,
                                                    Product__c = productLineMap.get(lead.Response_Product_Line_2__c),
                                                    Quantity__c = lead.Response_Product_Quantity_2__c,
                                                    Unit_Price__c = 1)); 
            }
            /* For Product Line 3 */
            if (productLineMap.keyset().contains(lead.Response_Product_Line_3__c)) {
                leadProducts.add(new Product_Interest__c(Lead__c = lead.Id,
                                                    Product__c = productLineMap.get(lead.Response_Product_Line_3__c),
                                                    Quantity__c = lead.Response_Product_Quantity_3__c,
                                                    Unit_Price__c = 1)); 
            }
            /* For Product Line 4 */
            if (productLineMap.keyset().contains(lead.Response_Product_Line_4__c)) {
                leadProducts.add(new Product_Interest__c(Lead__c = lead.Id,
                                                    Product__c = productLineMap.get(lead.Response_Product_Line_4__c),
                                                    Quantity__c = lead.Response_Product_Quantity_4__c,
                                                    Unit_Price__c = 1)); 
            }
            /* For Product Line 5 */
            if (productLineMap.keyset().contains(lead.Response_Product_Line_5__c)) {
                leadProducts.add(new Product_Interest__c(Lead__c = lead.Id,
                                                    Product__c = productLineMap.get(lead.Response_Product_Line_5__c),
                                                    Quantity__c = lead.Response_Product_Quantity_5__c,
                                                    Unit_Price__c = 1)); 
            }
        }
        
        
        
        try {
            insert leadProducts;
        } catch (DMLException ex) {
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'Lead', 'LeadTriggerUtil', 'Class');
        }
    }
    
    /**
    * @description: Updating BU and GBU of owner on lead record 
    */
    public static void updateLeadBUandGBU(Map<Id, Lead> newLeads, Map<Id, Lead> oldLeads) {
        Set<Id> leadOwnerIds = new Set<Id>();
        if (newLeads != null && newLeads.size() > 0 && oldLeads != null && oldLeads.size() > 0) {
        
            for (Lead lead: newLeads.values()) {
                if (lead.OwnerId != oldLeads.get(lead.Id).OwnerId) {
                        leadOwnerIds.add(lead.OwnerId);
                }
            }
            
        } 
        Map<Id, User> userById ;
        if (leadOwnerIds != null && leadOwnerIds.size() > 0) {
             userById = new Map<Id, User>([Select Id, Business_Group__c, Global_Business_Unit__c
                                                        From User
                                                        Where Id IN :leadOwnerIds]);                                          
            
        }
        if (leadOwnerIds.size() > 0) {
            for (Lead lead: newLeads.values()) {
                if (userById.get(lead.OwnerId) != null) {
                    lead.Lead_BU__c = userById.get(lead.OwnerId).Business_Group__c ;
                    lead.Lead_GBU__c = userById.get(lead.OwnerId).Global_Business_Unit__c ;
                }
            }
        }
        
        /*try {
            if(Test.isRunningTest()){
                throw new MyException();
            }                    
        } 
        catch (DMLException ex) {
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'Lead', 'LeadTriggerUtil', 'Class');
        }*/
    }
            
    /**
    * @description: To updated account name using company name
    */
    public static void updateAccountOnLead(List<Lead> newLeads) {
        /* To get Record Type Id of Account */
        Schema.DescribeSObjectResult describeResult = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = describeResult.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Customer');
        /* Initializing Collections */
       /* Map<Id, String> leadCompany = new Map<Id, String>();
        Set<String> companyNames = new Set<String>();
        if (newLeads != null && newLeads.size() > 0) {
            for (Lead lead: newLeads) {
                if (lead.Company != null) {
                    leadCompany.put(lead.Id, lead.Company);
                    companyNames.add(lead.Company);
                }
            }
        }
        List<Id> accountIds;
        Map<String, List<Id>> accountIdbyName = new Map<String, List<Id>>();
        
        if (companyNames != null && companyNames.size() > 0 && rtByName != null) {
            for (Account account : [Select Id, Name, RecordTypeId 
                                    From Account 
                                    Where Name IN : companyNames And RecordTypeId =: rtByName.getRecordTypeId()]) {
                accountIds = accountIdbyName.get(account.Name);
                if (accountIds == null) {
                    accountIds = new List<Id>();
                }
                accountIds.add(account.Id);                              
                accountIdbyName.put(account.Name, accountIds);
            }   
        }   
        try {
            for (Lead lead: newLeads) {
                if (accountIds != null && accountIdbyName.size() > 0) {
                    List<Id> matchingAccounts = accountIdbyName.get(lead.company);
                    if (matchingAccounts.size() == 1) {
                        lead.Account_Name__c = matchingAccounts[0];
                    }
                }
            }
        } catch(Exception ex){
            CreateApexErrorLog.insertHandledExceptionsForLeadConversion(ex, null, 'Lead', 'LeadtriggerUtil', 'Class');
        }*/
    }
    /**
    * @Date: 13-AUG-2012
    * @CR#: CR-0125
    * @Author: Accenture 
    * @description: Updating product info on leads with 1st two product interests 
    */
    public static void updateProductInfoOnLead(List<Product_Interest__c> newLeadProducts) {
        Set<Id> productInterestIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();
        for (Product_Interest__c prodInterest : newLeadProducts) {
            //productInterestIds.add(prodInterest.Id);
            if(prodInterest.Lead__c != null)
            {
              productInterestIds.add(prodInterest.Id);
              leadIds.add(prodInterest.Lead__c);
            }
        }
        
        Map<Id, String> leadProductInfoMap = new Map<Id, String>();
        for (Product_Interest__c leadProduct : [Select Id, Lead__c, Lead__r.Product_Service_Solution__c, Product__c, Product__r.Name, CreatedDate 
                                                From Product_Interest__c 
                                                Where Lead__c IN : leadIds 
                                                Order By CreatedDate]) {
            String productInfo = leadProductInfoMap.get(leadProduct.Lead__c); 
            if (productInfo == null) {
                productInfo = 'Product Interest 1: '+leadProduct.Product__r.Name+'\n';
                
            } else {
                String prdInfoCheck = productInfo.replaceFirst(':', '@@');
                if (!prdInfoCheck.contains(':')) {
                    productInfo += 'Product Interest 2: '+leadProduct.Product__r.Name+'\n'; 
                }
            }
            Boolean infoFlag = false;
            /*String oldProductInfo = leadProduct.Lead__r.Product_Service_Solution__c;
            if (oldProductInfo != null && oldProductInfo != '') {
                oldProductInfo = oldProductInfo.replaceFirst(':', '@@');
                if (!oldProductInfo.contains(':')) {
                    infoFlag = true;            
                }
            }*/
            
            if (!infoFlag) { 
                leadProductInfoMap.put(leadProduct.Lead__c, productInfo);
            }   
        }
        List<Lead> leads = new List<Lead>();    
        for (Lead lead : [Select Id, Product_Service_Solution__c From Lead Where Id IN: leadProductInfoMap.keySet()]) {
            lead.Product_Service_Solution__c = leadProductInfoMap.get(lead.Id);
            leads.add(lead);
        }
        try {
            update leads;
        } catch(Exception ex){
            CreateApexErrorLog.insertHandledExceptionsForLeadConversion(ex, null, 'Lead', 'LeadtriggerUtil', 'Class');
        }
    }
    
    /**
    * @description: Update Region feild on Lead according to Country values 
    *               using custom setting Lead_Country_Region_Mapping__c 
    */
    public static void updateLeadRegion(Map<Id,Lead> newLeads){
    
        System.debug('******In updateLeadRegion method****');
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,String> accIdCountryMap = new Map<Id,String>();
        Map<String, Lead_Country_Region_Mapping__c> leadCountryRegionMap = new  Map<String, Lead_Country_Region_Mapping__c>();

            for(Lead leadacc :newLeads.values()){
                accIdSet.add(leadacc.Account_Name__c);
            }
            for(Account acc : [Select Id,ShippingCountry from Account where Id  IN: accIdSet]){
                accIdCountryMap.put(acc.Id,acc.ShippingCountry);
            }
            /* Fetching all the values for Lead_Country_Region_Mapping__c custom setting */
            for(Lead_Country_Region_Mapping__c leadCountryRegion : Lead_Country_Region_Mapping__c.getAll().values()){
               leadCountryRegionMap.put(leadCountryRegion.Country__c,leadCountryRegion );
           }       
            /* Setting the Region value according to the Country on the Lead */
            for (Lead lead : newLeads.values()) { 
                Lead_Country_Region_Mapping__c regionMapping;
                if(lead.Account_Name__c == null){
                     regionMapping = leadCountryRegionMap.get(lead.Country);
                }
                else{
                    regionMapping = leadCountryRegionMap.get(accIdCountryMap.get(lead.Account_Name__c));
                }
                if (regionMapping != null) {
                    lead.Region__c = regionMapping.Region__c;
                } 
                else
                lead.Region__c = null;
             }   
    }
    
    /**
    * @description: Insert Region feild on Lead according to Country values 
    *               using custom setting Lead_Country_Region_Mapping__c 
    */
    public static void InsertLeadRegion(List<Lead> newLeads){
    
        System.debug('******In InsertLeadRegion method****');
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,String> accIdCountryMap = new Map<Id,String>();
        Map<String, Lead_Country_Region_Mapping__c> leadCountryRegionMap = new  Map<String, Lead_Country_Region_Mapping__c>();

            for(Lead leadacc :newLeads){
                accIdSet.add(leadacc.Account_Name__c);
            }
            for(Account acc : [Select Id,ShippingCountry from Account where Id  IN: accIdSet]){
                accIdCountryMap.put(acc.Id,acc.ShippingCountry);
            }
            /* Fetching all the values for Lead_Country_Region_Mapping__c custom setting */
            for(Lead_Country_Region_Mapping__c leadCountryRegion : Lead_Country_Region_Mapping__c.getAll().values()){
               leadCountryRegionMap.put(leadCountryRegion.Country__c,leadCountryRegion );
           }       
            /* Setting the Region value according to the Country on the Lead */
            for (Lead lead : newLeads) { 
                Lead_Country_Region_Mapping__c regionMapping;
                if(lead.Account_Name__c == null){
                     System.debug('*************In Lead');
                     regionMapping = leadCountryRegionMap.get(lead.Country);
                }
                else{
                    System.debug('*************In Account');
                    regionMapping = leadCountryRegionMap.get(accIdCountryMap.get(lead.Account_Name__c));
                }
                if (regionMapping != null) {
                    lead.Region__c = regionMapping.Region__c;
                } 
                else
                lead.Region__c = null;
             }   
    }
     
    /* @description: Defining Custom Exception to increate the code coverage 
    * 
    * IsActive
    */
    public class MyException extends Exception{}    
   
}