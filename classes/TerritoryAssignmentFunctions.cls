/***********************************************************
* Class Name: TerritoryAssignmentFunctions
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: This class contains method to search matching rules for Account against Confidential, Account Profile, 
*        Industry Type, Coverage Type, Geographic Type Rules.
***********************************************************/
public class TerritoryAssignmentFunctions {
    
    /**
    * @description: searches matching rule for accounts by MDCP Id
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByMDCP(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountMDCPId = new Set<String>();
            
            //collecting mdcp ids into a set
            for (Account account: accountsById.values()) {
                if (account.MDCP_Organization_ID__c != null) {
                    accountMDCPId.add(account.MDCP_Organization_ID__c);
                }
            }
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByMdcp = TerritoryAssignmentUtilities.getAccountProfileRulesByMdcp(accountMDCPId);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                if (account.MDCP_Organization_ID__c != null) {
                    //get matching rules by MDCP
                    List<Sales_Territory_Definition__c> rules = rulesByMdcp.get(account.MDCP_Organization_ID__c.toUpperCase());
                    //get exactly matched Rule
                    rules = findMultipleMatchingRules(account, rules);
                    
                    //capture these matched rules for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
                }
            }
        }
        return matchingRulesByAccId;
    }    
    /**
    * @description: searches matching rule for accounts by Source System Account ID
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchBySrcSysAccId(
                                        Map<Id, Account> accountsById,
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accSrcSysId = new Set<String>();
            
            //collecting source system ids into a set
            for (Account account: accountsById.values()) {
                if (account.Source_System_Account_ID__c != null) {
                    accSrcSysId.add(account.Source_System_Account_ID__c);
                }
            }
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesBySrcSysId = TerritoryAssignmentUtilities.getAccountProfileRulesBySourceSystemAccount(accSrcSysId);
            
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                if (account.Source_System_Account_ID__c != null) {
                    //get matching rules by source system id
                    List<Sales_Territory_Definition__c> rules = rulesBySrcSysId.get(account.Source_System_Account_ID__c.toUpperCase());
                    //get exactly matched Rule
                    Sales_Territory_Definition__c rule = findMatchingRule(account, rules);
                    
                    //capture this matched rule for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                }
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by AMId, Country & State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByAMIDCountryState(
                                        Map<Id, Account> accountsById,
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountAMID = new Set<String>();
            Set<String> accountCountry = new Set<String>();
            Set<String> accountState = new Set<String>();
            
            //collecting AMID, State & Country into a set
            for (Account account: accountsById.values()) {
                if (account.AMID_L2__c != null) {
                    accountAMID.add(account.AMID_L2__c);
                }
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
                if (account.ShippingState != null) {
                    accountState.add(account.ShippingState);
                }                               
            }
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByAMIDCountryState = TerritoryAssignmentUtilities.getAccountProfileRulesByAMIDCountryState(accountAMID, accountState, accountCountry);
            
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                String key = TerritoryAssignmentUtilities.generateKey(account.AMID_L2__c, account.ShippingCountry, account.ShippingState);
                if(key != null && key != '') {
                    //get matching rules by source system id
                    List<Sales_Territory_Definition__c> rules = rulesByAMIDCountryState.get(key);
                    //get exactly matched Rule
                    Sales_Territory_Definition__c rule = findMatchingRule(account, rules);
                    //capture this matched rule for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                }
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by AMID, BG Sales Coverage & Zip Code
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByAMIDBGCoverageCountryZip(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountAMID = new Set<String>();
            Set<String> accountBGCoverage = new Set<String>();
            transient Map<String,Set<String>> postalCodesByCountry = new Map<String,Set<String>>();
            
            //collecting AMID, BGSalesCoverage
            for (Account account: accountsById.values()) {
                if (account.AMID_L2__c != null) {
                    accountAMID.add(account.AMID_L2__c);
                }
                if (account.Coverage_Segmentation__c != null) {
                    accountBGCoverage.add(account.Coverage_Segmentation__c);
                }
                if(account.ShippingPostalCode != null && account.ShippingCountry != null) {
                    postalCodesByCountry = addPostalCodeToMap(account.ShippingPostalCode, account.ShippingCountry, postalCodesByCountry);
                }
            }
            //Splitting MultiBG values
            accountBGCoverage =  TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBGCoverage);
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByAMIDBGCoverageCountryZip = 
            TerritoryAssignmentUtilities.getAccountProfileRulesByAMIDBGCoverageCountryZip(accountAMID, accountBGCoverage, postalCodesByCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.Coverage_Segmentation__c != null) {
                    //Seperate bg coverage values for multiple BGs
                    set<String> bgCoverages =  TerritoryAssignmentUtilities.splitMultiBGData(account.Coverage_Segmentation__c);
                    
                    if(bgCoverages != null) {
                        for(String coverage : bgCoverages) {
                            String key =  TerritoryAssignmentUtilities.generateKey(account.AMID_L2__c, coverage, account.ShippingCountry);
                            List<Sales_Territory_Definition__c> ruleList = rulesByAMIDBGCoverageCountryZip.get(key);
                            if(ruleList != null) {
                                rules.addAll(ruleList);
                            }
                        }
                    }
                }
                
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRuleByZip(account, rules);*/
                rules = findMultipleMatchingRulesbyZip(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends
                //capture this matched rule for current account in map
                matchingRulesByAccId =  TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by AMId, Country & Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByAMIDCountryZip(
                                        Map<Id, Account> accountsById,
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountAMID = new Set<String>();
            transient Map<String,Set<String>> postalCodesByCountry = new Map<String,Set<String>>();
            
            //collecting AMID & Country into a set
            for (Account account: accountsById.values()) {
                if (account.AMID_L2__c != null) {
                    accountAMID.add(account.AMID_L2__c);
                }
                if(account.ShippingPostalCode != null && account.ShippingCountry != null) {
                    postalCodesByCountry = addPostalCodeToMap(account.ShippingPostalCode, account.ShippingCountry, postalCodesByCountry);
                }
            }
            
            //collecting queried rules into a map
            //Map<String, List<Sales_Territory_Definition__c>> rulesByAMIDCountryZip = TerritoryAssignmentUtilities.getAccountProfileRulesByAMIDCountryZip(accountAMID, accountCountry);
            Map<String, List<Sales_Territory_Definition__c>> rulesByAMIDCountryZip = TerritoryAssignmentUtilities.getAccountProfileRulesByAMIDCountryZip(accountAMID, postalCodesByCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                String key = TerritoryAssignmentUtilities.generateKey(account.AMID_L2__c, account.ShippingCountry, null);
                            
                if(key != null && key != '') {
                    //get matching rules by source system id
                    List<Sales_Territory_Definition__c> rules = rulesByAMIDCountryZip.get(key);
                    //get exactly matched Rule
                    Sales_Territory_Definition__c rule = findMatchingRule(account, rules);
                    //capture this matched rule for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                }
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by AMID, Industry Vertical, Geograhic Hierarchy(Sales Region)
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByAMIDIndustryVerticalGeo(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountAMID = new Set<String>();
            Set<String> accountIndustryVertical = new Set<String>();
            Set<String> accountGeo = new Set<String>();
            
            //collecting AMID, IndustryVertical and Geo in set
            for (Account account: accountsById.values()) {
                if (account.AMID_L2__c != null) {
                    accountAMID.add(account.AMID_L2__c);
                }
                if (account.Industry_Vertical__c != null) {
                    accountIndustryVertical.add(account.Industry_Vertical__c);
                }
                //TM:Debmalya: Req:3293:Replacing Old Field for Geographic Hierarchy with new field: Start
                //if (account.World_Region__c!= null) {
                //    accountGeo.add(account.World_Region__c);
                //}
                if (account.WorldRegion_Hierarchy__c!= null) {
                    List<String> splitWorldRegion = account.WorldRegion_Hierarchy__c.split(';');
                    for(String getEachRegion : splitWorldRegion){
                        accountGeo.add(account.WorldRegion_Hierarchy__c);
                    }
                }
                //TM:Debmalya: Req:3293:Replacing Old Field for Geographic Hierarchy with new field: End
            }
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByAMIDIndustryVerticalGeo = 
            TerritoryAssignmentUtilities.getAccountProfileRulesByAMIDIndustryVerticalGeo(accountAMID, accountIndustryVertical, accountGeo);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                //TM:Debmalya: Req:3293:Replacing Old Field for Geographic Hierarchy with new field: Start
                if (account.WorldRegion_Hierarchy__c!= null) {
                    List<String> splitWorldRegion = account.WorldRegion_Hierarchy__c.split(';');
                    for(String getEachRegion : splitWorldRegion){
                        //String key = TerritoryAssignmentUtilities.generateKey(account.AMID_L2__c, account.Industry_Vertical__c, account.World_Region__c);
                        String key = TerritoryAssignmentUtilities.generateKey(account.AMID_L2__c, account.Industry_Vertical__c, getEachRegion);
                    //TM:Debmalya: Req:3293:Replacing Old Field for Geographic Hierarchy with new field: End
                        if(key != null && key != '') {
                            //get matching rules by source system id
                            List<Sales_Territory_Definition__c> rules = rulesByAMIDIndustryVerticalGeo.get(key);
                            //get exactly matched Rule
                            Sales_Territory_Definition__c rule = findMatchingRule(account, rules);
                            
                            //capture this matched rule for current account in map
                            matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                        }
                    }
                }
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts exclusively by AMID only
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByAMIDOnly(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountAMID = new Set<String>();
            
            //collecting AMID, IndustryVertical and Geo in set
            for (Account account: accountsById.values()) {
                if (account.AMID_L2__c != null) {
                    accountAMID.add(account.AMID_L2__c);
                }
            }
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByAMID = 
            TerritoryAssignmentUtilities.getAccountProfileRulesByAMIDOnly(accountAMID);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                if (account.AMID_L2__c != null) {
                    //get matching rules by AMID
                    List<Sales_Territory_Definition__c> rules = rulesByAMID.get(account.AMID_L2__c.toUpperCase());
                    //get exactly matched Rules
                    rules = findMultipleMatchingRules(account, rules);
                    //capture these matched rules for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
                }
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Industry Vertical, Bg Sales Coverage, Country & Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByIndustryBGCoverageCountryZip(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountIndustryVertical = new Set<String>();
            Set<String> accountBGCoverage = new Set<String>();
            transient Map<String,Set<String>> postalCodesByCountry = new Map<String,Set<String>>();
           
            //collecting AMID, BGSalesCoverage and min & max Zipcodes
            for (Account account: accountsById.values()) {
                if (account.Industry_Vertical__c != null) {
                    accountIndustryVertical.add(account.Industry_Vertical__c);
                }
                if (account.Coverage_Segmentation__c != null) {
                    accountBGCoverage.add(account.Coverage_Segmentation__c);
                }
                if(account.ShippingPostalCode != null && account.ShippingCountry != null) {
                    postalCodesByCountry = addPostalCodeToMap(account.ShippingPostalCode, account.ShippingCountry, postalCodesByCountry);
                }
            }
            //Splitting MultiBG values
            accountBGCoverage =  TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBGCoverage);
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByIndustryBGCoverageCountryZip =  TerritoryAssignmentUtilities.getIndustryRulesByIndustryBGCoverageCountryZip(
                            accountIndustryVertical, accountBGCoverage, postalCodesByCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.Coverage_Segmentation__c != null) {
                    //Seperate bg coverage values for multiple BGs
                    set<String> bgCoverages =  TerritoryAssignmentUtilities.splitMultiBGData(account.Coverage_Segmentation__c);
                    
                    if(bgCoverages != null) {
                        for(String coverage : bgCoverages) {
                            String key =  TerritoryAssignmentUtilities.generateKey(account.Industry_Vertical__c, coverage, account.ShippingCountry);
                            List<Sales_Territory_Definition__c> ruleList = rulesByIndustryBGCoverageCountryZip.get(key);
                            if(ruleList != null) {
                                rules.addAll(ruleList);
                            }
                        }
                    }
                }
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRuleByZip(account, rules);*/
                rules = findMultipleMatchingRulesbyZip(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends                                
                
                //capture this matched rule for current account in map
                matchingRulesByAccId =  TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Industry Vertical, Country, State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/    
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByIndustryCountryState(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountIndustry = new Set<String>();
            Set<String> accountCountry = new Set<String>();
            Set<String> accountState = new Set<String>();
            
            //collecting industry, State & Country into a set
            for (Account account: accountsById.values()) {
                if (account.Industry_Vertical__c != null) {
                    accountIndustry.add(account.Industry_Vertical__c);
                }
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
                if (account.ShippingState != null) {
                    accountState.add(account.ShippingState);
                }                               
            }
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByIndustryCountryState = TerritoryAssignmentUtilities.getIndustryRulesByIndustryVerticalCountryState(accountIndustry, accountState, accountCountry);
            
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                String key = TerritoryAssignmentUtilities.generateKey(account.Industry_Vertical__c, account.ShippingCountry, account.ShippingState);
                if(key != null && key != '') {
                    //get matching rules by source system id
                    List<Sales_Territory_Definition__c> rules = rulesByIndustryCountryState.get(key);
                    //get exactly matched Rule
                    Sales_Territory_Definition__c rule = findMatchingRule(account, rules);
                    
                    //capture this matched rule for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                }
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Country, State, Coverage Segmentation
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/     
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByBgCoverageCountryState(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountBGCoverage = new Set<String>();
            Set<String> accountCountry = new Set<String>();
            Set<String> accountState = new Set<String>();
            
            //collecting industry, State & Country into a set
            for (Account account: accountsById.values()) {
                if (account.Coverage_Segmentation__c != null) {
                    accountBGCoverage.add(account.Coverage_Segmentation__c);
                }
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
                if (account.ShippingState != null) {
                    accountState.add(account.ShippingState);
                }                               
            }
            //Splitting MultiBG values
            accountBGCoverage = TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBGCoverage);
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByBGCoverageCountryState = TerritoryAssignmentUtilities.getCoverageRulesByBGCoverageCountryState(accountBGCoverage, accountState, accountCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.Coverage_Segmentation__c != null) {
                    //Seperate bg coverage values for multiple BGs
                    set<String> bgCoverages = TerritoryAssignmentUtilities.splitMultiBGData(account.Coverage_Segmentation__c);
                    if(bgCoverages != null) {
                        for(String coverage : bgCoverages) {
                            String key = TerritoryAssignmentUtilities.generateKey(coverage, account.ShippingCountry, account.ShippingState);
                            List<Sales_Territory_Definition__c> ruleList = rulesByBGCoverageCountryState.get(key);
                            if(ruleList != null) {
                                rules.addAll(ruleList);
                            }
                        }
                    }
                }
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRule(account, rules);*/
                rules = findMultipleMatchingRules(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends

                //capture this matched rule for current account in map
                matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by BGCoverage, Country & Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByBGCoverageCountryZip(
                                        Map<Id, Account> accountsById,
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountBGCoverage = new Set<String>();
            transient Map<String,Set<String>> postalCodesByCountry = new Map<String,Set<String>>();
            
            //collecting BGCoverage & Country into a set
            for (Account account: accountsById.values()) {
                if (account.Coverage_Segmentation__c != null) {
                    accountBGCoverage.add(account.Coverage_Segmentation__c);
                }
                if(account.ShippingPostalCode != null && account.ShippingCountry != null) {
                    postalCodesByCountry = addPostalCodeToMap(account.ShippingPostalCode, account.ShippingCountry, postalCodesByCountry);
                }
            }
            //Splitting MultiBG values
            accountBGCoverage =  TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBGCoverage);
            
            //collecting queried rules into a map
            //Map<String, List<Sales_Territory_Definition__c>> rulesByBGCoverageCountryZip = TerritoryAssignmentUtilities.getAccountProfileRulesByBGCoverageCountryZip(accountBGCoverage, accountCountry);
            Map<String, List<Sales_Territory_Definition__c>> rulesByBGCoverageCountryZip = TerritoryAssignmentUtilities.getCoverageRulesByBGCoverageCountryZip(accountBGCoverage, postalCodesByCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.Coverage_Segmentation__c != null) {
                    //Seperate bg coverage values for multiple BGs
                    set<String> bgCoverages =  TerritoryAssignmentUtilities.splitMultiBGData(account.Coverage_Segmentation__c);
                    if(bgCoverages != null) {
                        for(String coverage : bgCoverages) {
                            String key =  TerritoryAssignmentUtilities.generateKey(coverage, account.ShippingCountry, null);
                            List<Sales_Territory_Definition__c> ruleList = rulesByBGCoverageCountryZip.get(key);
                            if(ruleList != null) {
                                rules.addAll(ruleList);
                            }
                        }
                    }
                }
                
                //get exactly matched Rule
                
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRuleByZip(account, rules);*/
                rules = findMultipleMatchingRulesbyZip(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends                                        
                
                //capture this matched rule for current account in map
                matchingRulesByAccId =  TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Country, Coverage Segmentation
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/     
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByBgCoverageCountry(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
         system.debug('sreenath'+accountsById);
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountBGCoverage = new Set<String>();            
            Set<String> accountCountry = new Set<String>();
            
            
            
            //collecting BG Sales Coverage & Country into a set
            for (Account account: accountsById.values()) {
            system.debug('sreenath1'+account.Coverage_Segmentation__c);
                if (account.Coverage_Segmentation__c != null) {
                    accountBGCoverage.add(account.Coverage_Segmentation__c);
                    system.debug('sreenath2'+accountBGCoverage);
                }
                
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                    system.debug('sreenath3'+accountCountry);
                }
            }
            //Splitting MultiBG values
            accountBGCoverage = TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBGCoverage);
            system.debug('sreenath4'+accountBGCoverage);
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByBGCoverageCountry = 
                                        TerritoryAssignmentUtilities.getCoverageRulesByBGCoverageCountry(accountBGCoverage, accountCountry);
            system.debug('sreenath5'+rulesByBGCoverageCountry);
            //iterating through accounts
           
            for (Account account: accountsById.values()) {
                system.debug('sreenath10'+account);
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                
                if (account.Coverage_Segmentation__c != null) {
                system.debug('sreenath11'+account.Coverage_Segmentation__c);
                    //Seperate bg coverage values for multiple BGs
                    set<String> bgCoverages = TerritoryAssignmentUtilities.splitMultiBGData(account.Coverage_Segmentation__c);
                    system.debug('sreenath12'+bgCoverages);
                   
                    if(bgCoverages != null) {
                    system.debug('sreenath13'+bgCoverages);
                        for(String coverage : bgCoverages) {
                        system.debug('sreenath14'+coverage);
                            String key = TerritoryAssignmentUtilities.generateKey(coverage, account.ShippingCountry, null);
                            system.debug('sreenath15'+key);
                            List<Sales_Territory_Definition__c> ruleList = rulesByBGCoverageCountry.get(key);
                            system.debug('sreenath16'+ruleList);
                            if(ruleList != null) {
                            system.debug('sreenath17'+ruleList);
                                rules.addAll(ruleList);
                            }
                        }
                    }
                }
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRuleByZip(account, rules);*/
                rules = findMultipleMatchingRules(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends
                                               
                //capture this matched rule for current account in map
                matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
                system.debug('sreenath19'+matchingRulesByAccId );
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Country, State, Named Account
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/     
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByNamedAccCountryState(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountNamedAcc = new Set<String>();
            Set<String> accountCountry = new Set<String>();
            Set<String> accountState = new Set<String>();
            
            //collecting industry, State & Country into a set
            for (Account account: accountsById.values()) {
                if (account.Named_Account__c != null) {
                    accountNamedAcc.add(account.Named_Account__c);
                }
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
                if (account.ShippingState != null) {
                    accountState.add(account.ShippingState);
                }                               
            }
            //Splitting MultiBG values
            accountNamedAcc = TerritoryAssignmentUtilities.splitMultiBGDataSet(accountNamedAcc);
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByNamedAccCountryState = TerritoryAssignmentUtilities.getCoverageRulesByNamedAccCountryState(accountNamedAcc, accountState, accountCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.Named_Account__c != null) {
                    //Seperate Named Account values for multiple BGs
                    set<String> namedAccs = TerritoryAssignmentUtilities.splitMultiBGData(account.Named_Account__c);
                    if(namedAccs != null) {
                        for(String namedAcc : namedAccs) {
                            String key = TerritoryAssignmentUtilities.generateKey(namedAcc, account.ShippingCountry, account.ShippingState);
                            List<Sales_Territory_Definition__c> ruleList = rulesByNamedAccCountryState.get(key);
                            if(ruleList != null) {
                                rules.addAll(ruleList);
                            }
                        }
                    }
                }
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRuleByZip(account, rules);*/
                rules = findMultipleMatchingRules(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends

                //capture this matched rule for current account in map
                matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Country, Postal code, Named Account
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/      
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByNamedAccCountryZip(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountNamedAcc = new Set<String>();
            Set<String> accountPostalCode = new Set<String>();
            transient Map<String,Set<String>> postalCodesByCountry = new Map<String,Set<String>>();
            
            //collecting NamedAcc, country and min & max Zipcodes
            for (Account account: accountsById.values()) {
                if (account.Named_Account__c != null) {
                    accountNamedAcc.add(account.Named_Account__c);
                }
                if(account.ShippingPostalCode != null && account.ShippingCountry != null) {
                    postalCodesByCountry = addPostalCodeToMap(account.ShippingPostalCode, account.ShippingCountry, postalCodesByCountry);
                }
            }
            //Splitting MultiBG values
            accountNamedAcc = TerritoryAssignmentUtilities.splitMultiBGDataSet(accountNamedAcc);
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByNamedAccCountry = 
            TerritoryAssignmentUtilities.getCoverageRulesByNamedAccCountryZip(accountNamedAcc, postalCodesByCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.Named_Account__c != null) {
                    //Seperate bg coverage values for multiple BGs
                    set<String> namedAccounts = TerritoryAssignmentUtilities.splitMultiBGData(account.Named_Account__c);
                    
                    if(namedAccounts != null) {
                        for(String namedAcc : namedAccounts) {
                            String key = TerritoryAssignmentUtilities.generateKey(namedAcc, account.ShippingCountry, null);
                            
                            List<Sales_Territory_Definition__c> ruleList = rulesByNamedAccCountry.get(key);
                            
                            if(ruleList != null) {
                                rules.addAll(ruleList);
                            }
                        }
                    }
                    //get exactly matched Rule
                     //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                    /* Sales_Territory_Definition__c rule = findMatchingRuleByZip(account, rules);*/                    
                    rules = findMultipleMatchingRulesbyZip(account, rules);
                    //TM: Sreenath multiple definitions need to return ALM-7876 ends
                    //capture this matched rule for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
                }
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Country, RAD
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/      
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByRADCountry(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountRAD = new Set<String>();
            Set<String> accountCountry = new Set<String>();
            
            //collecting BG Sales Coverage & Country into a set
            for (Account account: accountsById.values()) {
                if (account.RAD__c != null) {
                    accountRAD.add(account.RAD__c);
                }
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
            }
            //Splitting MultiBG values
            accountRAD = TerritoryAssignmentUtilities.splitMultiBGDataSet(accountRAD);
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByRADCountry = TerritoryAssignmentUtilities.getCoverageRulesByRADCountry(accountRAD, accountCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.RAD__c != null) {
                    //Seperate bg coverage values for multiple BGs
                    set<String> rads = TerritoryAssignmentUtilities.splitMultiBGData(account.RAD__c);

                    if(rads != null) {
                        for(String rad : rads) {
                            String key = TerritoryAssignmentUtilities.generateKey(rad, account.ShippingCountry, null);
                            List<Sales_Territory_Definition__c> ruleList = rulesByRADCountry.get(key);
                            if(ruleList != null) {
                                rules.addAll(ruleList);
                            }
                        }
                    }
                }
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRule(account, rules);*/
                rules = findMultipleMatchingRules(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends              
                
                //capture this matched rule for current account in map
                matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Country, Postal Code
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/      
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByCountryZip(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            transient Map<String,Set<String>> postalCodesByCountry = new Map<String,Set<String>>();
            
            //collecting Zipcodes by country
            for (Account account: accountsById.values()) {
                 if(account.ShippingPostalCode != null && account.ShippingCountry != null) {
                    postalCodesByCountry = addPostalCodeToMap(account.ShippingPostalCode, account.ShippingCountry, postalCodesByCountry);
                 }
            }
            
            //collecting queried rules into a map
            transient Map<String, List<Sales_Territory_Definition__c>> rulesByCountryZip = 
            TerritoryAssignmentUtilities.getGeoRulesByCountryZip(postalCodesByCountry);

            //iterating through accounts 
            for (Account account: accountsById.values()) {
                if (account.ShippingCountry != null) {
                    //get matching rules by MDCP
                    transient List<Sales_Territory_Definition__c> rules = rulesByCountryZip.get(account.ShippingCountry.toUpperCase());
                    //get exactly matched Rule
                    Sales_Territory_Definition__c rule = findMatchingRuleByZip(account, rules);
                   
                    //capture this matched rule for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                }
            }
        }
        return matchingRulesByAccId;
    }
  
    /**
    * @description: searches matching rule for accounts by Country, State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/      
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByCountryState(
                                        Map<Id, Account> accountsById,
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountCountry = new Set<String>();
            Set<String> accountState = new Set<String>();
            
            //collecting State & Country into a set
            for (Account account: accountsById.values()) {
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
                if (account.ShippingState != null) {
                    accountState.add(account.ShippingState);
                }                               
            }
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByCountryState = TerritoryAssignmentUtilities.getGeoRulesByCountryState(accountCountry, accountState);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                String key = TerritoryAssignmentUtilities.generateKey(account.ShippingCountry, account.ShippingState, null);
                
                if(key != null && key != '') {
                    //get matching rules by State Country
                    List<Sales_Territory_Definition__c> rules = rulesByCountryState.get(key);
                    //get exactly matched Rule
                    Sales_Territory_Definition__c rule = findMatchingRule(account, rules);
                    
                    
                    //capture this matched rule for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                }
            }
        }

        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts exclusively by Country only
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/    
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByCountry(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountCountry = new Set<String>();
            
            //collecting mdcp ids into a set
            for (Account account: accountsById.values()) {
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
            }
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByCountry = TerritoryAssignmentUtilities.getGeoRulesByCountry(accountCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                if (account.ShippingCountry != null) {
                    //get matching rules by MDCP
                    List<Sales_Territory_Definition__c> rules = rulesByCountry.get(account.ShippingCountry.toUpperCase());
                    
                    //get exactly matched Rule
                    Sales_Territory_Definition__c rule = findMatchingRule(account, rules);
                    
                    //capture this matched rule for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                }
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts exclusively by Region only
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/     
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByRegion(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountRegion = new Set<String>();
            
            //collecting Sales Region ids into a set
            for (Account account: accountsById.values()) {
        //TM:Debmalya:Req-3293:Consider new Geographic Hierarchy Field:Start
                //if (account.World_Region__c != null) {
                //    accountRegion.add(account.World_Region__c);
                //}
                if (account.WorldRegion_Hierarchy__c != null) {
                    List<String> splitWorldRegion = account.WorldRegion_Hierarchy__c.split(';');
                    for(String getEachRegion : splitWorldRegion){
                        accountRegion.add(getEachRegion);
                    }
                }
        //TM:Debmalya:Req-3293:Consider new Geographic Hierarchy Field:End
            }
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByRegion = TerritoryAssignmentUtilities.getGeoRulesByRegion(accountRegion);

            //iterating through accounts 
            for (Account account: accountsById.values()) {
            //TM:Debmalya:Req-3293:Consider new Geographic Hierarchy Field:Start
                /*if (account.World_Region__c!= null) {
                    //get matching rules by Sales Region
                    List<Sales_Territory_Definition__c> rules = rulesByRegion.get(account.World_Region__c.toUpperCase());
                    //get exactly matched Rule
                    Sales_Territory_Definition__c rule = findMatchingRule(account, rules);
                   
                    //capture this matched rule for current account in map
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                }*/
                if (account.WorldRegion_Hierarchy__c!= null) {
                    //get matching rules by Sales Region
                    List<String> splitWorldRegion = account.WorldRegion_Hierarchy__c.split(';');
                    for(String getEachRegionRules : splitWorldRegion){
                        List<Sales_Territory_Definition__c> rules = rulesByRegion.get(getEachRegionRules.toUpperCase());
                        
                        //get exactly matched Rule
                        Sales_Territory_Definition__c rule = findMatchingRule(account, rules);
                       
                        //capture this matched rule for current account in map
                        matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRules(account.Id, rule, matchingRulesByAccId);
                    }
                }
            //TM:Debmalya:Req-3293:Consider new Geographic Hierarchy Field:End
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: Receives multiple matching rules for an account, checks confidentiality
    *               & return single matching rule that matched first 
    * @return: Sales_Territory_Definition__c record
    **/
    public static Sales_Territory_Definition__c findMatchingRule(Account account, List<Sales_Territory_Definition__c> rules) {
        if(rules != null && account != null) {
          system.debug('test0:'+ rules);
            for(Sales_Territory_Definition__c rule : rules) {
                system.debug('test10:'+ rule);
                //defining Entry criteria for matching logic :
                //confidential rules should be considered for confidential Accounts && vice versa 
                if((account.Confidential_Account__c && rule.Sales_Territory__r.IsConfidential__c) ||
                    (!account.Confidential_Account__c && !rule.Sales_Territory__r.IsConfidential__c)){
                    system.debug('test20:'+ rule);
                    return rule;
                }
            }                           
        }
        return null;
    }
    
     /**
    * @description: Receives multiple matching rules for an account, checks confidentiality & postal code
    *               & return single matching rule that matched first 
    * @return: Sales_Territory_Definition__c record
    **/
    public static Sales_Territory_Definition__c findMatchingRuleByZip(Account account, List<Sales_Territory_Definition__c> rules) {
    
        if(rules != null && account != null) {
            for(Sales_Territory_Definition__c rule : rules) {
                
                if(account.ShippingPostalCode != null) {
                    /*//Extract first 5 characters of Account postal code & compare
                    List<String> zipElements = account.ShippingPostalCode.split('-', 2);
                    if(zipElements != null && zipElements[0] != null && zipElements[0] != '') {
                        String postalCode = zipElements[0];
                        
                        //defining Entry criteria for matching logic :
                        //confidential rules should be considered for confidential Accounts && vice versa 
                        if(((account.Confidential_Account__c && rule.Sales_Territory__r.IsConfidential__c) ||
                            (!account.Confidential_Account__c && !rule.Sales_Territory__r.IsConfidential__c)) &&
                           (postalCode >= rule.Postal_Code_Start__c &&
                            postalCode <= rule.Postal_Code_End__c)){
                            return rule;
                        }
                    }*/
                    
                    /*if(account.ShippingCountry != null &&
                       (account.ShippingCountry.toUpperCase() == 'UNITED STATES' ||
                        account.ShippingCountry.toUpperCase() == 'US') &&
                       rule.Postal_Code_End__c != null) {
                        rule.Postal_Code_End__c += '9999';
                    }*/
                    
                    //confidential rules should be considered for confidential Accounts && vice versa 
                    if(((account.Confidential_Account__c && rule.Sales_Territory__r.IsConfidential__c) ||
                        (!account.Confidential_Account__c && !rule.Sales_Territory__r.IsConfidential__c)) &&
                       (account.ShippingPostalCode >= rule.Postal_Code_Start__c &&
                        account.ShippingPostalCode <= rule.Postal_Code_End__c)){

                        return rule;
                    }
                }
            }                           
        }
        return null;
    }
    
    /**
    * @description: checks if a postalCode set exists for a given account name,
    *               if yes, pulls the set else creates new set, 
    *               adds current postal code to set 
    *               and put the set back to map against that account name
    **/
    public static Map<String, Set<String>> addPostalCodeToMap(String postalCode, String country,
                                                              Map<String, Set<String>> postalCodesByCountry) {
        if(postalCodesByCountry == null) {
            postalCodesByCountry = new Map<String, Set<String>>();
        }
        if(country != null && country != '' && postalCode != null && postalCode != '') {
            Set<String> postalCodeSet = postalCodesByCountry.get(String.escapeSingleQuotes(country));
            if(postalCodeSet == null){
                postalCodeSet = new Set<String>();
            }
            postalCodeSet.add(String.escapeSingleQuotes(postalCode));
            postalCodesByCountry.put(String.escapeSingleQuotes(country), postalCodeSet);
        }
        return postalCodesByCountry;                                                                             
    }
    
    //************For CR#129  : Methods to Return more than 1 matching rule*****************************
    /**
    * @description: Receives multiple matching rules for an account, checks confidentiality
    *               & return list of matching rules 
    * @return: List of Sales_Territory_Definition__c Rules
    **/
    public static List<Sales_Territory_Definition__c> findMultipleMatchingRules(Account account, List<Sales_Territory_Definition__c> rules) {
        List<Sales_Territory_Definition__c> matchingRules = new List<Sales_Territory_Definition__c>();  
        if(rules != null && account != null) {
            for(Sales_Territory_Definition__c rule : rules) {
                //defining Entry criteria for matching logic :
                //confidential rules should be considered for confidential Accounts && vice versa 
                if((account.Confidential_Account__c && rule.Sales_Territory__r.IsConfidential__c) ||
                    (!account.Confidential_Account__c && !rule.Sales_Territory__r.IsConfidential__c)){
                    matchingRules.ADD(rule);
                }
            }                           
        }
        return matchingRules;
    }
    
    //TM: Sreenath Apr- 23rd 2013 fixing issue of multiple matching rules with zip starts
    
    /**
    * @description: Receives multiple matching rules for an account, checks confidentiality
    *               & return list of matching rules 
    * @return: List of Sales_Territory_Definition__c Rules
    **/
    public static List<Sales_Territory_Definition__c> findMultipleMatchingRulesbyZip(Account account, List<Sales_Territory_Definition__c> rules) {
        List<Sales_Territory_Definition__c> matchingRules = new List<Sales_Territory_Definition__c>();  
        if(rules != null && account != null) {
            for(Sales_Territory_Definition__c rule : rules) {
                //defining Entry criteria for matching logic :
                //confidential rules should be considered for confidential Accounts && vice versa 
                if(((account.Confidential_Account__c && rule.Sales_Territory__r.IsConfidential__c) ||
                        (!account.Confidential_Account__c && !rule.Sales_Territory__r.IsConfidential__c)) &&
                       (account.ShippingPostalCode >= rule.Postal_Code_Start__c &&
                        account.ShippingPostalCode <= rule.Postal_Code_End__c)){
                    matchingRules.ADD(rule);
                }
            }                           
        }
        return matchingRules;
    }
    //TM: Sreenath Apr- 23rd 2013 fixing issue of multiple matching rules with zip ends
    
    // TM: Debmalya: Req-2085 Sep 21, 2012:Creating Set of associated Sales Territories - Start
    public static Map<Id,List<Sales_Territory_Definition__c>> mapAssignedSalesTerritory(Map<Id, Account> accountsById,
                                                                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId){
        Set<String> associatedSalesTerritory = new Set<String>();
    // Extract all Sales Territories and retrieve their corresponding Exclusion Definitions
        for(Id accId : matchingRulesByAccId.keyset()){
            List<Sales_Territory_Definition__c> rules = matchingRulesByAccId.get(accId);
            if (rules != null) {
                for (Sales_Territory_Definition__c rule : rules){
                    associatedSalesTerritory.add(rule.Sales_Territory__c);
                }
            }
        }
        Map<Id,List<Sales_Territory_Definition__c>> excluRulesMap = TerritoryAssignmentUtilities.getExclusionRules(associatedSalesTerritory);
        for(Id accId: matchingRulesByAccId.keyset()){
            List<Sales_Territory_Definition__c> rulelist = matchingRulesByAccId.get(accId);
            if(rulelist != null){
                Integer i = 0;
                system.debug('rulelist exists');
                while(i < rulelist.size()){
                    Sales_Territory_Definition__c rule = rulelist.get(i);
                    Id salesTerritory = rule.Sales_Territory__c;
                    List<Sales_Territory_Definition__c> exrulelist = excluRulesMap.get(salesTerritory);
                    if(exrulelist != null){
                        if(checkforExDef(accountsById.get(accId),exrulelist)){system.debug('is true');rulelist.remove(i);i--;}
                    }
                    i++;
                }
                matchingRulesByAccId.put(accId,rulelist);
                system.debug(matchingRulesByAccId);
            }
        }
        
        return matchingRulesByAccId;
    }
    
    public static Boolean checkforExDef(Account acc, List<Sales_Territory_Definition__c> exDefs){
        Boolean flag = false;
        if(exDefs != null){
            for(Sales_Territory_Definition__c exDef : exDefs){
                If(acc.MDCP_Organization_ID__c != null && exDef.MDCP_ID__c != null){
                    If(acc.MDCP_Organization_ID__c == exDef.MDCP_ID__c){return true;}
                }
                If(acc.AMID_L2__c != null && exDef.AMID__c != null){
                    If(acc.AMID_L2__c == exDef.AMID__c){return true;}
                }
                If(acc.Industry_Vertical__c != null && exDef.Industry_Vertical__c != null){
                    system.debug(acc.Industry_Vertical__c);system.debug(exDef.Industry_Vertical__c);
                    If(acc.Industry_Vertical__c == exDef.Industry_Vertical__c){return true;}
                }
                If(acc.Coverage_Segmentation__c != null && exDef.BG_Sales_Coverage_Segment__c != null){
                    Set<String> accountBGCoverage = new Set<String>();
                    accountBGCoverage = TerritoryAssignmentUtilities.splitMultiBGData(acc.Coverage_Segmentation__c);
                    for(String accountBGCoveragevalues : accountBGCoverage){
                        If(accountBGCoveragevalues == exDef.BG_Sales_Coverage_Segment__c){return true;} 
                    }
                }
            }         
        }
        return false;
    }
    // TM: Debmalya: Req-2085 Sep 21, 2012:Creating Set of associated Sales Territories - End
    
    //TM:R4:CR3999:Debmalya:4th Jan,2013:check for new rule type BA Market Segment:Start
    /**
    * @description: searches matching rule for accounts by Country, State, Coverage Segmentation, BA Market Segments
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/     
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByBAMarketBGCoverageStateCountry(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountBAMarket = new Set<String>();
            Set<String> accountBGCoverage = new Set<String>();
            Set<String> accountCountry = new Set<String>();
            Set<String> accountState = new Set<String>();
            
            //collecting industry, State & Country into a set
            for (Account account: accountsById.values()) {
                if (account.BG_Target_Segments__c != null) {
                    accountBAMarket.add(account.BG_Target_Segments__c);
                }
                if (account.Coverage_Segmentation__c != null) {
                    accountBGCoverage.add(account.Coverage_Segmentation__c);
                }
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
                if (account.ShippingState != null) {
                    accountState.add(account.ShippingState);
                }                               
            }
            //Splitting MultiBG values
            accountBAMarket = TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBAMarket);
            
            //Splitting MultiBG values
            accountBGCoverage = TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBGCoverage);
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByBAMarketBGCoverageCountryState = TerritoryAssignmentUtilities.getCoverageRulesByBAMarketBGCoverageCountryState(accountBAMarket, accountBGCoverage, accountState, accountCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.Coverage_Segmentation__c != null && account.BG_Target_Segments__c != null) {
                    //Seperate bg coverage values for multiple Market Segments
                    set<String> baMarket = TerritoryAssignmentUtilities.splitMultiBGData(account.BG_Target_Segments__c);
                    if(baMarket != null){
                        for(String market : baMarket){
                            //Seperate bg coverage values for multiple BGs
                            set<String> bgCoverages = TerritoryAssignmentUtilities.splitMultiBGData(account.Coverage_Segmentation__c);
                            if(bgCoverages != null) {
                                for(String coverage : bgCoverages) {
                                    String key = TerritoryAssignmentUtilities.generateKey(market, coverage, account.ShippingCountry, account.ShippingState);
                                    List<Sales_Territory_Definition__c> ruleList = rulesByBAMarketBGCoverageCountryState.get(key);
                                    if(ruleList != null) {
                                        rules.addAll(ruleList);
                                    }
                                }
                            }
                        }
                    }
                }
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRule(account, rules);*/
                rules = findMultipleMatchingRules(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends                
                //capture this matched rule for current account in map
                matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by BGCoverage, Country & Zip, BA Market Segments
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByBAMarketBgCoverageCountryZip(
                                        Map<Id, Account> accountsById,
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountBAMarket = new Set<String>();
            Set<String> accountBGCoverage = new Set<String>();
            transient Map<String,Set<String>> postalCodesByCountry = new Map<String,Set<String>>();
            
            //collecting BGCoverage & Country into a set
            for (Account account: accountsById.values()) {
                if (account.BG_Target_Segments__c != null) {
                    accountBAMarket.add(account.BG_Target_Segments__c);
                }
                if (account.Coverage_Segmentation__c != null) {
                    accountBGCoverage.add(account.Coverage_Segmentation__c);
                }
                if(account.ShippingPostalCode != null && account.ShippingCountry != null) {
                    postalCodesByCountry = addPostalCodeToMap(account.ShippingPostalCode, account.ShippingCountry, postalCodesByCountry);
                }
            }
            //Splitting MultiBAMarket values
            accountBAMarket =  TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBAMarket);
            
            //Splitting MultiBG values
            accountBGCoverage =  TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBGCoverage);
            
            //collecting queried rules into a map
            //Map<String, List<Sales_Territory_Definition__c>> rulesByBGCoverageCountryZip = TerritoryAssignmentUtilities.getAccountProfileRulesByBGCoverageCountryZip(accountBGCoverage, accountCountry);
            Map<String, List<Sales_Territory_Definition__c>> rulesByBAMarketBGCoverageCountryZip = TerritoryAssignmentUtilities.getCoverageRulesByBAMarketBGCoverageCountryZip(accountBAMarket, accountBGCoverage, postalCodesByCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.BG_Target_Segments__c != null && account.Coverage_Segmentation__c != null) {
                    //Seperate bg coverage values for multiple BAMarket Segments
                    set<String> baMarket =  TerritoryAssignmentUtilities.splitMultiBGData(account.BG_Target_Segments__c);
                    if(baMarket != null) {
                        for(String market : baMarket) {
                            //Seperate bg coverage values for multiple BGs
                            set<String> bgCoverages =  TerritoryAssignmentUtilities.splitMultiBGData(account.Coverage_Segmentation__c);
                            if(bgCoverages != null) {
                                for(String coverage : bgCoverages) {
                                    String key =  TerritoryAssignmentUtilities.generateKey(market,coverage, account.ShippingCountry);
                                    List<Sales_Territory_Definition__c> ruleList = rulesByBAMarketBGCoverageCountryZip.get(key);
                                    if(ruleList != null) {
                                        rules.addAll(ruleList);
                                    }
                                }
                            }
                        }
                    }
                }
                
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRuleByZip(account, rules);*/
                rules = findMultipleMatchingRulesbyZip(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends                
                //capture this matched rule for current account in map
                matchingRulesByAccId =  TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Country, Coverage Segmentation
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/     
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByBAMarketBgCoverageCountry(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountBAMarket = new Set<String>();
            Set<String> accountBGCoverage = new Set<String>();
            Set<String> accountCountry = new Set<String>();
            
            
            //collecting BG Sales Coverage & Country into a set
            for (Account account: accountsById.values()) {
                if (account.BG_Target_Segments__c != null) {
                    accountBAMarket.add(account.BG_Target_Segments__c);
                }
                if (account.Coverage_Segmentation__c != null) {
                    accountBGCoverage.add(account.Coverage_Segmentation__c);
                }
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
            }
            //Splitting MultiBAMarket values
            accountBAMarket =  TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBAMarket);
            
            //Splitting MultiBG values
            accountBGCoverage = TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBGCoverage);
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByBAMarketBGCoverageCountry = 
                                        TerritoryAssignmentUtilities.getCoverageRulesByBAMarketBGCoverageCountry(accountBAMarket, accountBGCoverage, accountCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.BG_Target_Segments__c != null && account.Coverage_Segmentation__c != null) {
                    //Seperate bg coverage values for multiple BAMarket Segments
                    set<String> baMarket =  TerritoryAssignmentUtilities.splitMultiBGData(account.BG_Target_Segments__c);
                    if(baMarket != null) {
                        for(String market : baMarket) {
                            //Seperate bg coverage values for multiple BGs
                            set<String> bgCoverages = TerritoryAssignmentUtilities.splitMultiBGData(account.Coverage_Segmentation__c);
                           
                            if(bgCoverages != null) {
                                for(String coverage : bgCoverages) {
                                    String key = TerritoryAssignmentUtilities.generateKey(market, coverage, account.ShippingCountry);
                                    List<Sales_Territory_Definition__c> ruleList = rulesByBAMarketBGCoverageCountry.get(key);
                                    if(ruleList != null) {
                                        rules.addAll(ruleList);
                                    }
                                }
                            }
                        }
                    }
                }
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRule(account, rules);*/
                rules = findMultipleMatchingRules(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends
                
                //capture this matched rule for current account in map
                matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    
    /**
    * @description: searches matching rule for accounts by Country, Market Segment
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/     
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByBAMarketCountry(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountBAMarket = new Set<String>();
            Set<String> accountCountry = new Set<String>();
            
            
            //collecting BG Sales Coverage & Country into a set
            for (Account account: accountsById.values()) {
                if (account.BG_Target_Segments__c != null) {
                    accountBAMarket.add(account.BG_Target_Segments__c);
                }
                if (account.ShippingCountry != null) {
                    accountCountry.add(account.ShippingCountry);
                }
            }
            //Splitting MultiBG values
            accountBAMarket = TerritoryAssignmentUtilities.splitMultiBGDataSet(accountBAMarket);
            
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByBAMarketCountry = 
                                        TerritoryAssignmentUtilities.getCoverageRulesByBAMarketCountry(accountBAMarket, accountCountry);
            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                List<Sales_Territory_Definition__c> rules = new List<Sales_Territory_Definition__c>();  
                if (account.BG_Target_Segments__c != null) {
                    //Seperate bg coverage values for multiple BGs
                    set<String> baMarkets = TerritoryAssignmentUtilities.splitMultiBGData(account.BG_Target_Segments__c);
                   
                    if(baMarkets != null) {
                        for(String market : baMarkets) {
                            String key = TerritoryAssignmentUtilities.generateKey(market, account.ShippingCountry, null);
                            List<Sales_Territory_Definition__c> ruleList = rulesByBAMarketCountry.get(key);
                            if(ruleList != null) {
                                rules.addAll(ruleList);
                            }
                        }
                    }
                }
                //get exactly matched Rule
                //TM: Sreenath multiple definitions need to return ALM-7876 Starts
                /*Sales_Territory_Definition__c rule = findMatchingRule(account, rules);*/
                rules = findMultipleMatchingRules(account, rules);
                //TM: Sreenath multiple definitions need to return ALM-7876 ends
                
                //capture this matched rule for current account in map
                matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
            }
        }
        return matchingRulesByAccId;
    }
    //TM:R4:CR3999:Debmalya:4th Jan,2013:check for new rule type BA Market Segment:End  
    
    // TM:CRPR5:15th Mar,2013:new rule type Mdcp + BR Segment:Start  
 public static Map<Id,List<Sales_Territory_Definition__c>> searchByMDCPBR(
                                        Map<Id, Account> accountsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
                                        
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@Entering searchByMDCPBR');
        if(accountsById != null && accountsById.size() > 0) {
            Set<String> accountMDCPId = new Set<String>();
            Set<String> accountBR = new Set<String>();
            
            //collecting mdcp ids into a set
            for (Account account: accountsById.values()) {
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@Entering account.MDCP_Business_Relationship__c*****'+account.MDCP_Business_Relationship__c);
                if (account.MDCP_Organization_ID__c != null) {
                    accountMDCPId.add(account.MDCP_Organization_ID__c);
                }
                if (account.MDCP_Business_Relationship__c != null) {
                    accountBR.add(account.MDCP_Business_Relationship__c);
                }               
            }
             system.debug('*****$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*********accountMDCPId **'+accountMDCPId );
               system.debug('*****$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*********accountBR **'+accountBR );
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByMdcpBR = TerritoryAssignmentUtilities.getAccountProfileRulesByMdcpBR(accountMDCPId,accountBR);
            
            
            system.debug(rulesByMdcpBR);            
            //iterating through accounts 
            for (Account account: accountsById.values()) {
                
                String key = TerritoryAssignmentUtilities.generateKey(account.MDCP_Organization_ID__c, account.MDCP_Business_Relationship__c, null);
                system.debug(key);
                if(key != null && key != '') {
                    //get matching rules by source system id
                    List<Sales_Territory_Definition__c> rules = rulesByMdcpBR.get(key);
                    system.debug(rules);                   
                    rules = findMultipleMatchingRules(account, rules);                    
                    matchingRulesByAccId = TerritoryAssignmentUtilities.captureMatchingRuleList(account.Id, rules, matchingRulesByAccId);
                }
            }
        }
            system.debug('*****$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*********matchingRulesByAccId**'+matchingRulesByAccId);    
            return matchingRulesByAccId;
    }
        // TM:CRPR5:15th Mar,2013:new rule type Mdcp + BR Segment:End  
        
   /**
    * @description: searches matching rule for locations by Partner locator Id
    * @params: Map<Id,Location__c> locationsById,Map<Id,List<Sales_Territory_Definition__c>>matchingRulesByLocId
    * @return: a map containing List of Sales_Territory_Definition__c Rules against location Ids
    * 
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByPartnerLocation(
                                        Map<Id,Location__c> locationsById,
                                        Map<Id,List<Sales_Territory_Definition__c>>matchingRulesByLocId){
         
        if(locationsById != null && locationsById.size() > 0){
            Set<String> locationLocatorIdSet = new Set<String>();
            for(Location__c loc:locationsById.values()){
                if(loc.Name != null){
                    locationLocatorIdSet.add(loc.Name);
                }
            }
            
             Map<String,List<Sales_Territory_Definition__c>> rulesByLocatorMap = TerritoryAssignmentUtilities.getLocationRulesByLocator(locationLocatorIdSet);
            for(Location__c loc:locationsById.values()){
                if(loc.Name != null){
                    List<Sales_Territory_Definition__c> rules = rulesByLocatorMap.get(loc.Name.toUpperCase());
                    rules = findMultipleMatchingRulesForLocation(loc,rules);
                    matchingRulesByLocId = TerritoryAssignmentUtilities.captureMatchingRuleListForLocation(loc.Id, rules, matchingRulesByLocId);
                }
            }
 
        }
        
        return matchingRulesByLocId;
    }
    
    //TM:R5:Vinay Location rules MDCP Org Id+BR+Country
    /**
    * @description: searches matching rule for locations by MDCP Org Id, Business Relationship, Country
    * @params: Map<Id,Location__c> locationsById,Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocId
    * @return: a map containing List of Sales_Territory_Definition__c Rules against location Ids
    **/ 
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByMdcpBusinessRelationshipCountry(
                                        Map<Id,Location__c> locationsById,
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocId){
        if(locationsById != null && locationsById.size() > 0){
            Set<String> locationMdcpOrgIdSet = new Set<String>();
            Set<String> locationBRSet = new Set<String>();
            Set<String> locationCountrySet = new Set<String>();
            
            for(Location__c loc:locationsById.values()){
                if(loc.MDCP_Organization_ID__c != null && loc.MDCP_Organization_ID__c != ''){
                    locationMdcpOrgIdSet.add(loc.MDCP_Organization_ID__c);
                }
                if(loc.Business_Relationship__c != null && loc.Business_Relationship__c != ''){
                    locationBRSet.add(loc.Business_Relationship__c);
                }
                if(loc.Country__c != null && loc.Country__c != ''){
                    locationCountrySet.add(loc.Country__c);
                }
            }
            
            Map<String,List<Sales_Territory_Definition__c>> rulesByMdcpBusinessRelationshipCountryMap = TerritoryAssignmentUtilities.getLocationRulesByMdcpBusinessRelationshipCountry(locationMDCpOrgIdSet,locationBRSet,locationCountrySet);
            
            for(Location__c loc:locationsById.values()){
                String key = TerritoryAssignmentUtilities.generateKey(loc.MDCP_Organization_ID__c,loc.Business_Relationship__c,loc.Country__c);
                if(key != null && key != ''){
                    List<Sales_Territory_Definition__c> rules = rulesByMdcpBusinessRelationshipCountryMap.get(key);
                    rules = findMultipleMatchingRulesForLocation(loc,rules);
                    matchingRulesByLocId = TerritoryAssignmentUtilities.captureMatchingRuleListForLocation(loc.Id,rules,matchingRulesByLocId);
                }
            }
        }
        return matchingRulesByLocId;
    }
    
    //TM:R5:Vinay Location rules MDCP Org Id+BR+Country+State
    /**
    * @description: searches matching rule for locations by MDCP Org Id, Business Relationship, Country,State
    * @params: Map<Id,Location__c> locationsById,Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocId
    * @return: a map containing List of Sales_Territory_Definition__c Rules against location Ids
    **/ 
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByMdcpBusinessRelationshipStateCountry(
                                        Map<Id,Location__c> locationsById,Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocId){
        if(locationsById != null && locationsById.size() > 0){
            Set<String> locationMdcpOrgIdSet = new Set<String>();
            Set<String> locationBRSet = new Set<String>();
            Set<String> locationCountrySet = new Set<String>();
            Set<String> locationStateSet = new Set<String>();
            
            for(Location__c loc:locationsById.values()){
                if(loc.MDCP_Organization_ID__c != null && loc.MDCP_Organization_ID__c != ''){
                    locationMdcpOrgIdSet.add(loc.MDCP_Organization_ID__c);
                }
                if(loc.Business_Relationship__c != null && loc.Business_Relationship__c != ''){
                    locationBRSet.add(loc.Business_Relationship__c);
                }
                if(loc.Country__c != null && loc.Country__c != ''){
                    locationCountrySet.add(loc.Country__c);
                }
                if(loc.State__c != null && loc.State__c != ''){
                    locationStateSet.add(loc.State__c);
                }
            }
            
            Map<String,List<Sales_Territory_Definition__c>> rulesByMdcpBusinessRelationshipStateCountryMap = 
                        TerritoryAssignmentUtilities.getLocationRulesByMdcpBusinessRelationshipStateCountry(locationMdcpOrgIdSet,locationBRSet,locationCountrySet,locationStateSet);
                        
            for(Location__c loc:locationsById.values()){
                String key = TerritoryAssignmentUtilities.generateKey(loc.MDCP_Organization_ID__c,loc.Business_Relationship__c,loc.Country__c,loc.State__c);
                if(key != null && key !=''){
                    List<Sales_Territory_Definition__c> rules = rulesByMdcpBusinessRelationshipStateCountryMap.get(key);
                    rules = findMultipleMatchingRulesForLocation(loc,rules);
                    matchingRulesByLocId = TerritoryAssignmentUtilities.captureMatchingRuleListForLocation(loc.Id,rules,matchingRulesByLocId);
                }
            }
        }
        return matchingRulesByLocId;
    }
    
    //TM:R5:Vinay Location rules MDCP Org Id+BR+Country+Zip
    /**
    * @description: searches matching rule for locations by MDCP Org Id, Business Relationship, Country,Zip
    * @params: Map<Id,Location__c> locationsById,Map<Id,List<Sales_Territory_definition__c>> matchingRulesByLocId
    * @return: a map containing List of Sales_Territory_Definition__c Rules against location Ids
    **/ 
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByMdcpBusinessRelationshipZipCountry(
                                        Map<Id,Location__c> locationsById,Map<Id,List<Sales_Territory_definition__c>> matchingRulesByLocId){
        if(locationsById != null && locationsById.size() > 0){
            Set<String> locationMdcpOrgIdSet = new Set<String>();
            Set<String> locationBRSet = new Set<String>();
            transient Map<String,Set<String>> postalCodesByCountryMap = new Map<String,Set<String>>();
            for(Location__c loc: locationsById.values()){
                if(loc.MDCP_Organization_ID__c != null && loc.MDCP_Organization_ID__c != ''){
                    locationMdcpOrgIdSet.add(loc.MDCP_Organization_ID__c);
                }
                if(loc.Business_Relationship__c != null && loc.Business_Relationship__c != ''){
                    locationBRSet.add(loc.Business_Relationship__c);
                }
                if((loc.Country__c != null && loc.Country__c != '') &&(loc.Postal_Code__c != null && loc.Postal_Code__c !='') ){
                    postalCodesByCountryMap = addPostalCodeToMap(loc.Postal_Code__c,loc.Country__c,postalCodesByCountryMap);
                }
            }
            
            Map<String,List<Sales_Territory_Definition__c>> rulesByMdcpBusinessRelationshipZipCountryMap = 
                TerritoryAssignmentUtilities.getLocationRulesByMdcpBusinessRelationshipZipCountry(locationMdcpOrgIdSet,locationBRSet,postalCodesByCountryMap);
            
            for(Location__c loc: locationsById.values()){
                String key = TerritoryAssignmentUtilities.generateKey(loc.MDCP_Organization_ID__c,loc.Business_Relationship__c,loc.Country__c,null);
                if(key != null && key !=''){
                    List<Sales_Territory_Definition__c> rules = rulesByMdcpBusinessRelationshipZipCountryMap.get(key);
                    rules = findMultipleMatchingRulesForLocation(loc,rules);
                    matchingRulesByLocId = TerritoryAssignmentUtilities.captureMatchingRuleListForLocation(loc.Id,rules,matchingRulesByLocId);
                }
            }
        }
        return matchingRulesByLocId;
    }
    
    //TM:R5:Vinay
     /**
    * @description: Receives multiple matching rules for a location, checks non confidentiality
    *               & return list of matching rules 
    * @params: Location__c location,List<Sales_Territory_Definition__c> rules
    * @return: List of Sales_Territory_Definition__c Rules
    **/
    public static List<Sales_Territory_Definition__c> findMultipleMatchingRulesForLocation(Location__c location,List<Sales_Territory_Definition__c> rules){
        List<Sales_Territory_Definition__c> matchingRulesList = new List<Sales_Territory_Definition__c>();
        if(rules != null && location != null){
            for(Sales_Territory_Definition__c rule:rules){
                if(!rule.Sales_Territory__r.IsConfidential__c){
                    matchingRulesList.add(rule);
                }
            }
        }
        return matchingRulesList;
    }
    
    // TM:R5 Vinay:Creating Set of associated Sales Territories for Location - Start
    public static Map<Id,List<Sales_Territory_Definition__c>> mapAssignedSalesTerritoryForLocation(Map<Id, Location__c> locationsById,
                                                                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocId){
        Set<String> associatedSalesTerritory = new Set<String>();
    // Extract all Sales Territories and retrieve their corresponding Exclusion Definitions
        for(Id locId : matchingRulesByLocId.keyset()){
            List<Sales_Territory_Definition__c> rules = matchingRulesByLocId.get(locId);
            if (rules != null) {
                for (Sales_Territory_Definition__c rule : rules){
                    associatedSalesTerritory.add(rule.Sales_Territory__c);
                }
            }
        }
        Map<Id,List<Sales_Territory_Definition__c>> excluRulesMap = TerritoryAssignmentUtilities.getExclusionRules(associatedSalesTerritory);
        for(Id locId: matchingRulesByLocId.keyset()){
            List<Sales_Territory_Definition__c> rulelist = matchingRulesByLocId.get(locId);
            if(rulelist != null){
                Integer i = 0;
                while(i < rulelist.size()){
                    Sales_Territory_Definition__c rule = rulelist.get(i);
                    Id salesTerritory = rule.Sales_Territory__c;
                    List<Sales_Territory_Definition__c> exrulelist = excluRulesMap.get(salesTerritory);
                    if(exrulelist != null){
                        if(checkForExDefLocation(locationsById.get(locId),exrulelist)){rulelist.remove(i);i--;}
                    }
                    i++;
                }
                matchingRulesByLocId.put(locId,rulelist);
            }
        }
        
        return matchingRulesByLocId;
    }
    // TM:R5 Vinay:Creating Set of associated Sales Territories for Location - End
    
    // TM:R5 Vinay:Checking for excluded definitions for Location - Start
    public static Boolean checkForExDefLocation(Location__c loc,List<Sales_Territory_Definition__c> exDefs){
        Boolean flag = false;
        if(exDefs != null){
            for(Sales_Territory_Definition__c exDef: exDefs){
                if(loc.id !=null && exDef.Partner_Locator_Id__c != null){
                    if(loc.id == exDef.Partner_Locator_Id__c){return true;}
                }
            }
        }
        return false;
    }
    // TM:R5 Vinay:Checking for excluded definitions for Location - End
    
   // TM:CRPR5:27th Mar,2013:new rule type Geo Hierarchy Segment:Start  
    public static Map<Id,List<Sales_Territory_Definition__c>> searchByMDCPBRGeo(
                                        Map<Id, Location__c> locationsById, 
                                        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocId) {
        if(locationsById != null && locationsById.size() > 0) {
            Set<String> locationMDCP = new Set<String>();
            Set<String> locationBR = new Set<String>();
            Set<String> locationGeo = new Set<String>();
            
            //collecting MDCP, BR and Geo in set
            for (Location__c loction: locationsById.values()) {
                if (loction.MDCP_Organization_ID__c != null) {
                    locationMDCP.add(loction.MDCP_Organization_ID__c);
                }
                if (loction.Business_Relationship__c != null) {
                    locationBR.add(loction.Business_Relationship__c);
                }
                if (loction.WorldRegion_Hierarchy__c!= null) {
                    List<String> splitWorldRegion = loction.WorldRegion_Hierarchy__c.split(';');
                    for(String getEachRegion : splitWorldRegion){
                        locationGeo.add(getEachRegion);
                    }
                }                
            }
            //collecting queried rules into a map
            Map<String, List<Sales_Territory_Definition__c>> rulesByMDCPBRGeo = 
            TerritoryAssignmentUtilities.getLocationProfileRulesByMDCPBRGeo(locationMDCP, locationBR, locationGeo);                           
            //iterating through loctions 
            for (Location__c loction: locationsById.values()) {
                if (loction.WorldRegion_Hierarchy__c!= null) {
                List<String> splitWorldRegion = loction.WorldRegion_Hierarchy__c.split(';');
                    for(String getEachRegion : splitWorldRegion){
                        String key = TerritoryAssignmentUtilities.generateKey(loction.MDCP_Organization_ID__c , loction.Business_Relationship__c , getEachRegion );
                        if(key != null && key != '') {
                            List<Sales_Territory_Definition__c> rules = rulesByMDCPBRGeo.get(key);
                            rules = findMultipleMatchingRulesForLocation(loction, rules);
                            matchingRulesByLocId = TerritoryAssignmentUtilities.captureMatchingRuleListForLocation(loction.Id, rules, matchingRulesByLocId);
                        }
                }
                }
            }
        }
        return matchingRulesByLocId;
    }
    // TM:CRPR5:27th Mar,2013:new rule type Geo Hierarchy Segment:End  
        
}