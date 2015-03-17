/***********************************************************
* Class Name: TerritoryAssignmentUtilities
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: Class contains method to fetch rules based on rule types Account Profile, Coverage, Geo, Industry.
***********************************************************/
public class TerritoryAssignmentUtilities {

    /**
    * @description: Initialiases SOQL query string with fields set 
    *               & common where clause conditions 
    * @return: SOQL query String
    * 
    **/
    public static String baseQuery {
        set;
        get{
            // TM: Debmalya: Req-2091 Aug 28, 2012:Handling Recordtype Partner for Account - Start
            Boolean territoryIsPartner = false;
            TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
            String currentRecordType = obj1.AccountRecordType__c;
            If(currentRecordType == 'Partner'){
                territoryIsPartner = true;
                //TM:R6:Vinay
                    /*Filtering out all External Territories if territory is Partner*/
                    if(baseQuery == null || baseQuery == '') {
                    baseQuery = 'Select Name, RAD__c, Named_Account__c, Source_System_ID__c, Industry_Vertical__c, State_Province__c, '+ 
                                'Sales_Territory__c, Geographic_Hierarchy__c, Postal_Code_Start__c, Postal_Code_End__c, MDCP_ID__c, Business_Relationship__c,Partner_Locator_Id__c, '+ 
                                'Id, Filter__c, Country__c, BG_Sales_Coverage_Segment__c, BA_Market_Segment__c, '+ 
                                'AMID__c, Sales_Territory__r.IsActive__c, Sales_Territory__r.IsConfidential__c, Sales_Territory__r.GroupId__c, Sales_Territory__r.Opportunity_Access__c, '+ 
                                'Sales_Territory__r.Case_Access__c, Sales_Territory__r.Account_Access__c '+
                                'From Sales_Territory_Definition__c '+
                // TM: Debmalya: Req-2091 Aug 28, 2012:Handling Recordtype Partner for Account - Start
                // TM: Debmalya: Req-2085 Sep 21, 2012:dont pickup definitions with Exclude flag checked
                //                'Where Sales_Territory__r.IsActive__c = true AND Sales_Territory__r.IsPartner__c = false AND ';
                                'Where Sales_Territory__r.IsActive__c = true AND Exclude__c = false AND Sales_Territory__r.isExternal__c = false AND Sales_Territory__r.IsPartner__c = '+ territoryIsPartner + ' AND ';
                // TM: Debmalya: Req-2091 Aug 28, 2012:Handling Recordtype Partner for Account - End    
                }
            }
            // TM: Debmalya: Req-2091 Aug 28, 2012:Handling Recordtype Partner for Account - End
            else{
            if(baseQuery == null || baseQuery == '') {
                baseQuery = 'Select Name, RAD__c, Named_Account__c, Source_System_ID__c, Industry_Vertical__c, State_Province__c, '+ 
                            'Sales_Territory__c, Geographic_Hierarchy__c, Postal_Code_Start__c, Postal_Code_End__c, MDCP_ID__c, Business_Relationship__c,Partner_Locator_Id__c, '+ 
                            'Id, Filter__c, Country__c, BG_Sales_Coverage_Segment__c, BA_Market_Segment__c, '+ 
                            'AMID__c, Sales_Territory__r.IsActive__c, Sales_Territory__r.IsConfidential__c, Sales_Territory__r.GroupId__c, Sales_Territory__r.Opportunity_Access__c, '+ 
                            'Sales_Territory__r.Case_Access__c, Sales_Territory__r.Account_Access__c '+
                            'From Sales_Territory_Definition__c '+
            // TM: Debmalya: Req-2091 Aug 28, 2012:Handling Recordtype Partner for Account - Start
            // TM: Debmalya: Req-2085 Sep 21, 2012:dont pickup definitions with Exclude flag checked
            //                'Where Sales_Territory__r.IsActive__c = true AND Sales_Territory__r.IsPartner__c = false AND ';
                            'Where Sales_Territory__r.IsActive__c = true AND Exclude__c = false AND Sales_Territory__r.IsPartner__c = '+ territoryIsPartner + ' AND ';
            // TM: Debmalya: Req-2091 Aug 28, 2012:Handling Recordtype Partner for Account - End    
            }
          }  
             // TM: Sreenath: Req-2089 oct 10, 2012  
             TerritoryDeltaChanges__c TDC = TerritoryDeltaChanges__c.getValues(Label.RealignmentProcess);
             system.debug('*****' +Label.RealignmentProcess);
             boolean eTerrval = TDC.Territory_Evaluation__c;           
             If(eTerrval){
                 baseQuery += 'Sales_Territory__r.EvaluateTerritory_for_Realignment__c = true AND ';
             }
             // TM: Sreenath: Req-2089 oct 10, 2012
            return baseQuery;
        } 
    }
    
    // TM: Debmalya: Req-2085 Sep 21, 2012:Query associated Sales Territory for Exclusion Definition- Start
    public static String exDefBaseQuery {
        set;
        get{
            if(exDefBaseQuery == null || exDefBaseQuery == '') {
                exDefBaseQuery = 'Select Name, Industry_Vertical__c, Sales_Territory__c, MDCP_ID__c, Id, '+
                                 'BG_Sales_Coverage_Segment__c, AMID__c, Exclude__c,Partner_Locator_Id__c '+
                                 'From Sales_Territory_Definition__c '+
                                 'Where Exclude__c = true AND Sales_Territory__c IN ';                
            }
            return exDefBaseQuery;
        } 
    }
    // TM: Debmalya: Req-2085 Sep 21, 2012:Query associated Sales Territory for Exclusion Definition- End
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of MDCP Ids
    * @return: a map containing List of Sales_Territory_Definition__c Rules against mdcp Ids
    * 
    **/
    public static Map<String, List<Sales_Territory_Definition__c>> getAccountProfileRulesByMdcp(Set<String> accountMDCPId) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByMdcp = new Map<String, List<Sales_Territory_Definition__c>>();
        String mdcpIds = getCommaSeperatedStringList(accountMDCPId);
        
        if(mdcpIds != null && mdcpIds != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.Mdcp) + '\'';
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.Mdcp) + '\''; 
            String otherconditions = ' AND MDCP_ID__c IN ' + mdcpIds;
            
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                                            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.MDCP_ID__c != null) {
                    rulesByMdcp = addRuleToMap(rule.MDCP_ID__c.toUpperCase(), rule, rulesByMdcp);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.MDCP_ID__c != null) {
                    rulesByMdcp = addRuleToMap(rule.MDCP_ID__c.toUpperCase(), rule, rulesByMdcp);
                }
            }
        }
   
        return rulesByMdcp;
    }

    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of Source System Account Ids
    * @return: a map containing List of Sales_Territory_Definition__c Rules against Source System Account Ids
    **/    
    public static Map<String, List<Sales_Territory_Definition__c>>  getAccountProfileRulesBySourceSystemAccount(Set<String> accountSourceSystemId) {
        Map<String, List<Sales_Territory_Definition__c>> rulesBySourceSystemId = new Map<String, List<Sales_Territory_Definition__c>>();
        String srcSysIds = getCommaSeperatedStringList(accountSourceSystemId);
        if(srcSysIds != null && srcSysIds != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.SourceSystemId) + '\'';
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.SourceSystemId) + '\''; 
            String otherconditions = ' AND Source_System_ID__c IN ' + srcSysIds;
            
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                  
                                                            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.Source_System_ID__c != null) {
                    rulesBySourceSystemId = addRuleToMap(rule.Source_System_ID__c.toUpperCase(), rule, rulesBySourceSystemId);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.Source_System_ID__c != null) {
                    rulesBySourceSystemId = addRuleToMap(rule.Source_System_ID__c.toUpperCase(), rule, rulesBySourceSystemId);
                }
            }
        }
      
        return rulesBySourceSystemId;
    }
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of AMID, Country, State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against AMID, Country, State
    **/    
    public static Map<String, List<Sales_Territory_Definition__c>> getAccountProfileRulesByAMIDCountryState(Set<String> accountAMID, Set<String> accountState,
                                                                Set<String> accountCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByAMIDCountryState = new Map<String, List<Sales_Territory_Definition__c>>();
        String amids = getCommaSeperatedStringList(accountAMID);
        String states = getCommaSeperatedStringList(accountState);
        String countries = getCommaSeperatedStringList(accountCountry);
        if(amids != null && amids != '' && 
           states != null && states != '' && countries != null && countries != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.AMIDOnly) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.AMIDOnly) + '\'';
            String otherconditions = ' AND AMID__c IN ' + amids + 
                                     ' AND State_Province__c IN ' + states +
                                     ' AND Country__C IN ' + countries +
                                     ' AND Postal_Code_Start__c = null ' +
                                     ' AND Postal_Code_End__c = null';         
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                           
                                                            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.AMID__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByAMIDCountryState = addRuleToMap(key, rule, rulesByAMIDCountryState);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.AMID__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByAMIDCountryState = addRuleToMap(key, rule, rulesByAMIDCountryState);
                }
            }
        }
    
        return rulesByAMIDCountryState;
    }
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of AMID, BGSalesCoverage , Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against AMID, BGSalesCoverage , Zip
    **/   
    public static Map<String, List<Sales_Territory_Definition__c>> getAccountProfileRulesByAMIDBGCoverageCountryZip(Set<String> accountAMID, Set<String> accountBGSalesCoverage,
                                                                                Map<String,Set<String>> postalCodesByCountry) {
                
        Map<String, List<Sales_Territory_Definition__c>> rulesByAMIDBGCoverageCountryZip = new Map<String, List<Sales_Territory_Definition__c>>();
        String amids = getCommaSeperatedStringList(accountAMID);
        String bgCoverages = getCommaSeperatedStringList(accountBGSalesCoverage);
        if(amids != null && amids != '' && bgCoverages != null && bgCoverages != '' && 
           postalCodesByCountry != null && postalCodesByCountry.size() > 0) {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.AMIDOnly) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.AMIDOnly) + '\'';
            String otherconditions = ' AND AMID__c IN ' + amids +
                                     ' AND BG_Sales_Coverage_Segment__c IN ' + bgCoverages +
                                     ' AND Postal_Code_Start__c != null AND Postal_Code_End__c != null';
            String zipFilterCondition = generateFilterCondition(postalCodesByCountry);
            if(zipFilterCondition != null && zipFilterCondition != '') {
                otherconditions += zipFilterCondition;
            }
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                                       
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.AMID__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c);
                if(key != null && key != '') {
                    rulesByAMIDBGCoverageCountryZip = addRuleToMap(key, rule, rulesByAMIDBGCoverageCountryZip);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.AMID__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c);
                if(key != null && key != '') {
                    rulesByAMIDBGCoverageCountryZip = addRuleToMap(key, rule, rulesByAMIDBGCoverageCountryZip);
                }
            }
        }
        
        return rulesByAMIDBGCoverageCountryZip;
    }
    
    /**d
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of AMID, Country, Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against AMID, Country, State
    **/    
    public static Map<String, List<Sales_Territory_Definition__c>> getAccountProfileRulesByAMIDCountryZip(Set<String> accountAMID, Map<String,Set<String>> postalCodesByCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByAMIDCountryZip = new Map<String, List<Sales_Territory_Definition__c>>();
        String amids = getCommaSeperatedStringList(accountAMID);
        if(amids != null && amids != '' && postalCodesByCountry != null && postalCodesByCountry.size() > 0) {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.AMIDOnly) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.AMIDOnly) + '\'';
            String otherconditions = ' AND AMID__c IN ' + amids +
                                     ' AND Postal_Code_Start__c != null AND Postal_Code_End__c != null' + 
                                     ' AND State_Province__c = null' +
                                     ' AND BG_Sales_Coverage_Segment__c = null';         
            String zipFilterCondition = generateFilterCondition(postalCodesByCountry);
            if(zipFilterCondition != null && zipFilterCondition != '') {
                otherconditions += zipFilterCondition;
            }
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                          
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.AMID__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByAMIDCountryZip = addRuleToMap(key, rule, rulesByAMIDCountryZip);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.AMID__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByAMIDCountryZip = addRuleToMap(key, rule, rulesByAMIDCountryZip);
                }
            }
        }
       
        return rulesByAMIDCountryZip;
    }
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of AMID, IndustryVertical, Geo
    * @return: a map containing List of Sales_Territory_Definition__c Rules against AMID, IndustryVertical, Geo
    * 
    **/
    public static Map<String, List<Sales_Territory_Definition__c>> getAccountProfileRulesByAMIDIndustryVerticalGeo(Set<String> accountAMID, Set<String> accountIndustry,
                                                                Set<String> accountGeo) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByAMIDIndustryGeo = new Map<String, List<Sales_Territory_Definition__c>>();
        String amids = getCommaSeperatedStringList(accountAMID);
        String industries = getCommaSeperatedStringList(accountIndustry);
        String geos = getCommaSeperatedStringList(accountGeo);
        if(amids != null && amids != '' && 
           industries != null && industries != '' && geos != null && geos != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.AMIDOnly) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.AMIDOnly) + '\'';
            String otherconditions = ' AND AMID__c IN ' + amids +
                                     ' AND Industry_Vertical__c IN ' + industries +
                                     ' AND Geographic_Hierarchy__c IN ' + geos; 
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                                           
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.AMID__c, rule.Industry_Vertical__c, rule.Geographic_Hierarchy__c);
                if(key != null && key != '') {
                    rulesByAMIDIndustryGeo = addRuleToMap(key, rule, rulesByAMIDIndustryGeo);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.AMID__c, rule.Industry_Vertical__c, rule.Geographic_Hierarchy__c);
                if(key != null && key != '') {
                    rulesByAMIDIndustryGeo = addRuleToMap(key, rule, rulesByAMIDIndustryGeo);
                }
            }
        }
       
        return rulesByAMIDIndustryGeo;
    }   
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching exclusively against received set of AMID Ids
    * @return: a map containing List of Sales_Territory_Definition__c Rules against AMID Ids
    * 
    **/
    public static Map<String, List<Sales_Territory_Definition__c>> getAccountProfileRulesByAMIDOnly(Set<String> accountAMID) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByAMID = new Map<String, List<Sales_Territory_Definition__c>>();
        String amids = getCommaSeperatedStringList(accountAMID);
        if(amids != null && amids != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.AMIDOnly) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.AMIDOnly) + '\'';
            String otherconditions = ' AND AMID__c IN ' + amids +  
                                     ' AND State_Province__c = null ' + 
                                     ' AND Country__C = null ' +
                                     ' AND Postal_Code_Start__c = null ' +
                                     ' AND Postal_Code_End__c = null ' +
                                     ' AND Industry_Vertical__c = null ' +
                                     ' AND Geographic_Hierarchy__c = null ';            
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
            
                                                            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.AMID__c != null) {
                    rulesByAMID = addRuleToMap(rule.AMID__c.toUpperCase(), rule, rulesByAMID);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.AMID__c != null) {
                    rulesByAMID = addRuleToMap(rule.AMID__c.toUpperCase(), rule, rulesByAMID);
                }
            }
        }
       
        return rulesByAMID;
    }   
    
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of Industry Vertical, BG Sales Coverage, Country & Zip
    *               and where postal code is populated
    * @return: a map containing List of Sales_Territory_Definition__c Rules against Industry Vertical, BG Sales Coverage & Country key
    * 
    **/
    public static Map<String, List<Sales_Territory_Definition__c>> getIndustryRulesByIndustryBGCoverageCountryZip(
            Set<String> accountIndustryVertical, Set<String> accountBGSalesCoverage, Map<String,Set<String>> postalCodesByCountry) {
                
        Map<String, List<Sales_Territory_Definition__c>> rulesByIndustryVerticalBGZip = new Map<String, List<Sales_Territory_Definition__c>>();
        String industries = getCommaSeperatedStringList(accountIndustryVertical);
        String bgCoverages = getCommaSeperatedStringList(accountBGSalesCoverage);
        if(industries != null && industries != '' && bgCoverages != null && bgCoverages != '' &&
           postalCodesByCountry != null && postalCodesByCountry.size() > 0) {
            String otherconditions = ' AND Industry_Vertical__c IN ' + industries +
                                     ' AND BG_Sales_Coverage_Segment__c IN ' + bgCoverages +
                                     ' AND Postal_Code_Start__c != null AND Postal_Code_End__c != null';
                                
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.IndustryVertical) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.IndustryVertical) + '\'';
            
            String zipFilterCondition = generateFilterCondition(postalCodesByCountry);
            if(zipFilterCondition != null && zipFilterCondition != '') {
                otherconditions += zipFilterCondition;
            }            
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Industry_Vertical__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c);
                if(key != null && key != '') {
                    rulesByIndustryVerticalBGZip = addRuleToMap(key, rule, rulesByIndustryVerticalBGZip);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Industry_Vertical__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c);
                if(key != null && key != '') {
                    rulesByIndustryVerticalBGZip = addRuleToMap(key, rule, rulesByIndustryVerticalBGZip);
                }
            }
        }
        
        return rulesByIndustryVerticalBGZip;
    }   

    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of IndustryVertical, Country, State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against IndustryVertical, Country, State
    **/    
    public static Map<String, List<Sales_Territory_Definition__c>> getIndustryRulesByIndustryVerticalCountryState(
            Set<String> accountIndustryVertical, Set<String> accountState, Set<String> accountCountry) {
                
        Map<String, List<Sales_Territory_Definition__c>> rulesByIndustryVerticalCountryState = new Map<String, List<Sales_Territory_Definition__c>>();
        String industries = getCommaSeperatedStringList(accountIndustryVertical);
        String states = getCommaSeperatedStringList(accountState);
        String countries = getCommaSeperatedStringList(accountCountry);
        if(industries != null && industries != '' && 
           states != null && states != '' && countries != null && countries != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.IndustryVertical) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.IndustryVertical) + '\'';
            String otherconditions = ' AND Industry_Vertical__c IN ' + industries + 
                                     ' AND State_Province__c IN ' + states +
                                     ' AND Country__C IN ' + countries +
                                     ' AND Postal_Code_Start__c = null ' +
                                     ' AND Postal_Code_End__c = null';         
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                         
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Industry_Vertical__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByIndustryVerticalCountryState = addRuleToMap(key, rule, rulesByIndustryVerticalCountryState);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Industry_Vertical__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByIndustryVerticalCountryState = addRuleToMap(key, rule, rulesByIndustryVerticalCountryState);
                }
            }
        }
        
        return rulesByIndustryVerticalCountryState;
    }
        
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of BGCoverage, Country, State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against BGCoverage, Country, State
    **/    
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByBGCoverageCountryState(Set<String> accountBGCoverage, Set<String> accountState, Set<String> accountCountry) {
        
        Map<String, List<Sales_Territory_Definition__c>> rulesByBGCoverageCountryState = new Map<String, List<Sales_Territory_Definition__c>>();
        String bgCoverages = getCommaSeperatedStringList(accountBGCoverage);
        String states = getCommaSeperatedStringList(accountState);
        String countries = getCommaSeperatedStringList(accountCountry);
        if(bgCoverages != null && bgCoverages != '' && 
           states != null && states != '' && countries != null && countries != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.BGCoverage) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.BGCoverage) + '\'';
            String otherconditions = ' AND BG_Sales_Coverage_Segment__c IN ' + bgCoverages +
                                     ' AND State_Province__c IN ' + states +
                                     ' AND Country__C IN ' + countries;         
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                               
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BG_Sales_Coverage_Segment__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByBGCoverageCountryState = addRuleToMap(key, rule, rulesByBGCoverageCountryState);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BG_Sales_Coverage_Segment__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByBGCoverageCountryState = addRuleToMap(key, rule, rulesByBGCoverageCountryState);
                }
            }
        }
        
        return rulesByBGCoverageCountryState;
    }
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of BGCoverage, Country, Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against BGCoverage, Country, Zip
    **/    
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByBGCoverageCountryZip(Set<String> accountBGCoverage,
                                                                                     Map<String,Set<String>> postalCodesByCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByBGCoverageCountryZip = new Map<String, List<Sales_Territory_Definition__c>>();
        String bgCoverages = getCommaSeperatedStringList(accountBGCoverage);
        if(bgCoverages != null && bgCoverages != '' && postalCodesByCountry != null && postalCodesByCountry.size() > 0) {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.BGCoverage) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.BGCoverage) + '\'';
            String otherconditions = ' AND BG_Sales_Coverage_Segment__c IN ' + bgCoverages +
                                     ' AND Postal_Code_Start__c != null AND Postal_Code_End__c != null';         
            
            String zipFilterCondition = generateFilterCondition(postalCodesByCountry);
            if(zipFilterCondition != null && zipFilterCondition != '') {
                otherconditions += zipFilterCondition;
            }
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                                   
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BG_Sales_Coverage_Segment__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByBGCoverageCountryZip = addRuleToMap(key, rule, rulesByBGCoverageCountryZip);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BG_Sales_Coverage_Segment__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByBGCoverageCountryZip = addRuleToMap(key, rule, rulesByBGCoverageCountryZip);
                }
            }
        }
    
        return rulesByBGCoverageCountryZip;
    }
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of BGCoverage, Country
    * @return: a map containing List of Sales_Territory_Definition__c Rules against BGCoverage, Country
    **/     
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByBGCoverageCountry(Set<String> accountBGCoverage, Set<String> accountCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByBGCoverageCountry = new Map<String, List<Sales_Territory_Definition__c>>();
        String bgCoverages = getCommaSeperatedStringList(accountBGCoverage);
        String countries = getCommaSeperatedStringList(accountCountry);
        if(bgCoverages != null && bgCoverages != '' && countries != null && countries != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.BGCoverage) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.BGCoverage) + '\'';
            String otherconditions = ' AND BG_Sales_Coverage_Segment__c IN ' + bgCoverages + 
                                     ' AND Country__C IN ' + countries +
                                     ' AND State_Province__c = null' +
                                     ' AND Postal_Code_Start__c = null ' +
                                     ' AND Postal_Code_End__c = null ';         
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BG_Sales_Coverage_Segment__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByBGCoverageCountry = addRuleToMap(key, rule, rulesByBGCoverageCountry);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BG_Sales_Coverage_Segment__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByBGCoverageCountry = addRuleToMap(key, rule, rulesByBGCoverageCountry);
                }
            }
        }
        
        return rulesByBGCoverageCountry;
    }

    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of NamedAcc, Country, State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against NamedAccount, Country, State
    **/    
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByNamedAccCountryState(Set<String> accountNamedAcc, Set<String> accountState, Set<String> accountCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByNamedAccCountryState = new Map<String, List<Sales_Territory_Definition__c>>();
        
        String namedAccs = getCommaSeperatedStringList(accountNamedAcc);
        String states = getCommaSeperatedStringList(accountState);
        String countries = getCommaSeperatedStringList(accountCountry);
        if(namedAccs != null && namedAccs != '' && 
           states != null && states != '' && countries != null && countries != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.NamedAccount) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.NamedAccount) + '\'';
            String otherconditions = ' AND Named_Account__c IN ' + NamedAccs +
                                     ' AND State_Province__c IN ' + states +
                                     ' AND Country__C IN ' + countries;         
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
            
                                                            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Named_Account__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByNamedAccCountryState = addRuleToMap(key, rule, rulesByNamedAccCountryState);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Named_Account__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByNamedAccCountryState = addRuleToMap(key, rule, rulesByNamedAccCountryState);
                }
            }
        }
    
        return rulesByNamedAccCountryState;
    }

    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of Named Account, Country, Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against Named Account, Country, Zip
    **/      
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByNamedAccCountryZip(
                                        Set<String> accountNamedAcc, Map<String,Set<String>> postalCodesByCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByNamedAccCountryZip = new Map<String, List<Sales_Territory_Definition__c>>();
        String namedAccounts = getCommaSeperatedStringList(accountNamedAcc);
        if(namedAccounts != null && namedAccounts != '' && postalCodesByCountry != null && postalCodesByCountry.size() > 0) {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.NamedAccount) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.NamedAccount) + '\'';
            String otherconditions = ' AND Named_Account__c IN ' + namedAccounts +
                                     ' AND Postal_Code_Start__c != null AND Postal_Code_End__c != null';
            
            String zipFilterCondition = generateFilterCondition(postalCodesByCountry);
            if(zipFilterCondition != null && zipFilterCondition != '') {
                otherconditions += zipFilterCondition;
            }
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Named_Account__c, rule.Country__C, null);
                if(key != null && key != '') {
                    rulesByNamedAccCountryZip = addRuleToMap(key, rule, rulesByNamedAccCountryZip);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Named_Account__c, rule.Country__C, null);
                if(key != null && key != '') {
                    rulesByNamedAccCountryZip = addRuleToMap(key, rule, rulesByNamedAccCountryZip);
                }
            }
        } 
        
        return rulesByNamedAccCountryZip;
    }

    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of Named RAD, Country
    * @return: a map containing List of Sales_Territory_Definition__c Rules against  RAD, Country
    **/         
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByRADCountry(Set<String> accountRAD, Set<String> accountCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByRADCountry = new Map<String, List<Sales_Territory_Definition__c>>();
        String rads = getCommaSeperatedStringList(accountRAD);
        String countries = getCommaSeperatedStringList(accountCountry);
        if(rads != null && rads != '' && countries != null && countries != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.RAD) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.RAD) + '\'';
            String otherconditions = ' AND RAD__c IN ' + rads + 
                                     ' AND Country__C IN ' + countries;          
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                                          
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.RAD__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByRADCountry = addRuleToMap(key, rule, rulesByRADCountry);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.RAD__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByRADCountry = addRuleToMap(key, rule, rulesByRADCountry);
                }
            }
        }
   
        return rulesByRADCountry;
    }

    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of Country, Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against Country, Zip
    **/          
    public static Map<String, List<Sales_Territory_Definition__c>> getGeoRulesByCountryZip(Map<String,Set<String>> postalCodesByCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByCountryZip = new Map<String, List<Sales_Territory_Definition__c>>();
        
        if(postalCodesByCountry != null && postalCodesByCountry.size() > 0) {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.CountryZip) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.CountryZip) + '\'';
            String otherconditions = ' AND Postal_Code_Start__c != null AND Postal_Code_End__c != null';
            String zipFilterCondition = generateFilterCondition(postalCodesByCountry);
            if(zipFilterCondition != null && zipFilterCondition != '') {
                otherconditions += zipFilterCondition;
            }
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
           
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.Country__c != null) {
                    rulesByCountryZip = addRuleToMap(rule.Country__c.toUpperCase(), rule, rulesByCountryZip);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.Country__c != null) {
                    rulesByCountryZip = addRuleToMap(rule.Country__c.toUpperCase(), rule, rulesByCountryZip);
                }
            }
        }
        
        return rulesByCountryZip;
    }

    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of Country, State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against Country, State
    **/      
    public static Map<String, List<Sales_Territory_Definition__c>> getGeoRulesByCountryState(Set<String> accountCountry, Set<String> accountState) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByCountryState = new Map<String, List<Sales_Territory_Definition__c>>();
        String states = getCommaSeperatedStringList(accountState);
        String countries = getCommaSeperatedStringList(accountCountry);
        if(states != null && states != '' && countries != null && countries != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.CountryState) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.CountryState) + '\'';
            String otherconditions = ' AND State_Province__c IN ' + states +
                                     ' AND Country__C IN ' + countries;         
            
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Country__c, rule.State_Province__c, null);
                if(key != null && key != '') {
                    rulesByCountryState = addRuleToMap(key, rule, rulesByCountryState);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.Country__c, rule.State_Province__c, null);
                if(key != null && key != '') {
                    rulesByCountryState = addRuleToMap(key, rule, rulesByCountryState);
                }
            }               
        }
    
        return rulesByCountryState;
    }

    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching exclusively against received set of Country Ids
    * @return: a map containing List of Sales_Territory_Definition__c Rules against Country 
    **/      
    public static Map<String, List<Sales_Territory_Definition__c>> getGeoRulesByCountry(Set<String> accountCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByCountry = new Map<String, List<Sales_Territory_Definition__c>>();
        String countries = getCommaSeperatedStringList(accountCountry);
        if(countries != null && countries != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.Country) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.Country) + '\'';
            String otherconditions = ' AND Country__C IN ' + countries +
                                     ' AND State_Province__c = null' + 
                                     ' AND BG_Sales_Coverage_Segment__c = null' +  
                                     ' AND Postal_Code_Start__c = null' + 
                                     ' AND Postal_Code_End__c = null'; 
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
        
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.Country__c != null) {
                    rulesByCountry = addRuleToMap(rule.Country__c.toUpperCase(), rule, rulesByCountry);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.Country__c != null) {
                    rulesByCountry = addRuleToMap(rule.Country__c.toUpperCase(), rule, rulesByCountry);
                }
            }               
        } 
    
        return rulesByCountry;
    }

    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching exclusively against received set of Region Ids
    * @return: a map containing List of Sales_Territory_Definition__c Rules against Country 
    **/     
    public static Map<String, List<Sales_Territory_Definition__c>> getGeoRulesByRegion(Set<String> accountRegion) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByRegion = new Map<String, List<Sales_Territory_Definition__c>>();
        String regions = getCommaSeperatedStringList(accountRegion);
        if(regions != null && regions != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.Geo) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.Geo) + '\'';
            String otherconditions = ' AND Geographic_Hierarchy__c IN ' + regions;
                                     
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                                         
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.Geographic_Hierarchy__c != null) {
                    rulesByRegion = addRuleToMap(rule.Geographic_Hierarchy__c.toUpperCase(), rule, rulesByRegion);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                if(rule.Geographic_Hierarchy__c != null) {
                    rulesByRegion = addRuleToMap(rule.Geographic_Hierarchy__c.toUpperCase(), rule, rulesByRegion);
                }
            }
        }
    
        return rulesByRegion;
    }
    
    
    /**
    * @description: checks if a rule list exists for a given keyString,
    *               if yes, pulls the list else creates new list, 
    *               adds current rule to list 
    *               and put the list back to map against that keyString
    **/
    public static Map<String, List<Sales_Territory_Definition__c>> addRuleToMap(String key, Sales_Territory_Definition__c rule,
                                                                                Map<String, List<Sales_Territory_Definition__c>> ruleMap) {
        if(ruleMap == null) {
            ruleMap = new Map<String,List<Sales_Territory_Definition__c>>();
        }
        if(rule != null && key != null && key != '') {
            List<Sales_Territory_Definition__c> ruleList = ruleMap.get(key);
            if(ruleList == null){
                ruleList = new List<Sales_Territory_Definition__c>();
            }
            ruleList.add(rule);
            ruleMap.put(key, ruleList);
        }
        return ruleMap;                                                                             
    }
    
    /**
    * @description: Checks if rule list exists in recieved map for received account id,
    *               if not found creates a new list & adds received rule to RuleList 
    *               then adds the RuleList to map against received account id
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> captureMatchingRules(Id accId,Sales_Territory_Definition__c rule,
                                                                                     Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId)
    {
        if(matchingRulesByAccId == null) 
        {
            matchingRulesByAccId = new Map<Id,List<Sales_Territory_Definition__c>>();
        }
        if(accId != null && rule != null) 
        {
            List<Sales_Territory_Definition__c> ruleList = matchingRulesByAccId.get(accId);
            if(ruleList == null)
            {
                ruleList = new List<Sales_Territory_Definition__c>();
            }
            ruleList.add(rule);
            matchingRulesByAccId.put(accId, ruleList);
        }
        return matchingRulesByAccId;                                                                                
    }
    
    //New method for CR:129
    /**
    * @description: Checks if rule list exists in recieved map for received account id,
    *               if not found creates a new list & adds received rulelist to RuleList 
    *               then adds the RuleList to map against received account id
    * @return: a map containing List of Sales_Territory_Definition__c Rules against account Ids
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> captureMatchingRuleList(Id accId,List<Sales_Territory_Definition__c> rules,
                                                                                     Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
        if(matchingRulesByAccId == null) {
            matchingRulesByAccId = new Map<Id,List<Sales_Territory_Definition__c>>();
        }
        if(accId != null && rules != null && rules.size() > 0) 
        {
            List<Sales_Territory_Definition__c> ruleList = matchingRulesByAccId.get(accId);
            if(ruleList == null)
            {
                ruleList = new List<Sales_Territory_Definition__c>();
            }
            ruleList.addAll(rules);
            matchingRulesByAccId.put(accId, ruleList);
        }
        return matchingRulesByAccId;                                                                                
    }
    
    /**
    * @description: Generates comma separated string list enclosed in 
    *               circular brackets to be used in dynamic query string. 
    * @return: String
    **/
    public static String getCommaSeperatedStringList(Set<String> stringSet) {
        String commaSeperatedString = '';
        if(stringSet != null && stringSet.size() > 0) {
            commaSeperatedString += '(';
            Boolean isFirstValue = true;
            for (String value : stringSet) {
                
                if(isFirstValue) {
                    commaSeperatedString += '\'' + String.escapeSingleQuotes(value) + '\'';
                    isFirstValue = false;
                } else {
                    commaSeperatedString += ', \'' + String.escapeSingleQuotes(value) + '\'';
                }   
            }
            commaSeperatedString += ')';
        }
        return commaSeperatedString;
    }
    
    /**
    * @description: Method to generate & return key as concatenation 
    *               of 2 or 3 fields in received parameters 
    * @return: String
    **/
    public static String generateKey(String value1, String value2, String value3) {
        String key = '';
        key+= (value1==null?'':value1.toUpperCase()) + (value2==null?'':value2.toUpperCase()) + (value3==null?'':value3.toUpperCase());
        return key;
    }
    
    //TM:R4:CR3999:Debmalya:4th Jan,2013:check for new rule type BA Market Segment:Start
    /**
    * @description: Method to generate & return key as concatenation 
    *               of 4 fields in received parameters 
    * @return: String
    **/
    public static String generateKey(String value1, String value2, String value3, String value4) {
        String key = '';
        key+= (value1==null?'':value1.toUpperCase()) + (value2==null?'':value2.toUpperCase()) + (value3==null?'':value3.toUpperCase()) + (value4==null?'':value4.toUpperCase());
        return key;
    }
    //TM:R4:CR3999:Debmalya:4th Jan,2013:check for new rule type BA Market Segment:End
    
    /**
    * @description: Method to generate filter condition to be used in query 
    *               by considering postal code and country 
    * @return: String
    **/
    public static String generateFilterCondition(Map<String,Set<String>> postalCodesByCountry) {
        String filterCondition = '';
        if(postalCodesByCountry != null) {
            
            Boolean isFirstCountry = true;
            for (String country : postalCodesByCountry.keySet()) {
                Set<String> postalCodeSet = postalCodesByCountry.get(country);
                if(postalCodeSet != null && postalCodeSet.size() > 0) {
                    
                    if(isFirstCountry) {
                        //opening Brace for All Countries and opening brace for specific country
                        filterCondition += ' AND (( Country__c = \'' + country + '\' AND (';
                        isFirstCountry = false;
                    } else {
                        //closing breace for previous country & opening brace for specific country and opening brace for all zipcodes
                        filterCondition += ') OR ( Country__c = \'' + country + '\' AND (';
                    }
                   
                    
                    Boolean isFirstCode = true;
                    for(String postalCode : postalCodeSet) {
                        if(isFirstCode) {
                            //opening & closing braces for specific zipcode range
                            filterCondition += '(Postal_Code_Start__c <= \'' + postalCode + '\' AND Postal_Code_End__c >= \''
                                               + postalCode + '\')';
                            isFirstCode = false;                   
                        } else {
                            //opening & closing braces for specific zipcode range
                            filterCondition += ' OR (Postal_Code_Start__c <= \'' + postalCode + '\' AND Postal_Code_End__c >= \''
                                               + postalCode + '\')';
                        }

                    }
                    //closing brace for all zipcodes
                    filterCondition += ')';
                }       
            }
            //closing brace for last country and All countries
            if(filterCondition != '') {
                filterCondition += '))';
            }
        }
        
        return filterCondition;
    }
    
    /**
    * @description: Method to split data contained in set of Strings 
    *               where each single string contains data for multiple BG
    *               & return data in a string set 
    * @return: set<String>
    **/ 
    public static Set<String> splitMultiBGDataSet(Set<String> multiBgDataSet){
    
        Set<String> bgValues = new Set<String>();
        if(multiBgDataSet != null) {
            for(String multiBgData : multiBgDataSet){
                Set<String> values = splitMultiBGData(multiBgData);
                if(values != null && values.size()>0) {
                    bgValues.addAll(values);
                }
            }
        }
    
        return bgValues;
    }
    
    /**
    * @description: Split data contained in single string for multiple BG 
    *               & return data in a string set 
    * @return: set<String>
    **/
    public static Set<String> splitMultiBGData(String multiBgData){
    
        Set<String> values = new Set<String>();
        if(multiBgData != null && multiBgData != '') {
            
            for (String bgdata : multiBgData.split('\\|') ){
                values.add(bgdata);
            }
        }
    
        return values;
    }
    
    // TM: Debmalya: Req-2085 Sep 21, 2012:Get Exclusion Definitions- Start
    /**
    * @description: Return all Exclusion definitions for a set of Sales Territories 
    *               & return List of Sales Territory Definitions 
    * @return: list<Sales Territory Definitions>
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> getExclusionRules(Set<String> salesTerrId){
        Map<Id,List<Sales_Territory_Definition__c>> excluRulesByST = new Map<Id,List<Sales_Territory_Definition__c>>();
        String stIds = getCommaSeperatedStringList(salesTerrId);
        
        if(stIds != null && stIds != ''){
            String finalQuery = exDefBaseQuery + stIds;
            for(Sales_Territory_Definition__c exRule: Database.query(finalQuery)){
                List<Sales_Territory_Definition__c> exRuleList = excluRulesByST.get(exRule.Sales_Territory__c);
                If(exRuleList == null){
                    exRuleList = new List<Sales_Territory_Definition__c>();
                }
                exRuleList.add(exRule);
                excluRulesByST.put(exRule.Sales_Territory__c, exRuleList);
            }
        }
        return excluRulesByST;
    }
    // TM: Debmalya: Req-2085 Sep 21, 2012:Get Exclusion Definitions- End
    
    //TM:R4:CR3999:Debmalya:4th Jan,2013:check for new rule type BA Market Segment:Start
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of BGCoverage, Country, State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against BGCoverage, Country, State
    **/    
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByBAMarketBGCoverageCountryState(Set<String> accountBAMarket, Set<String> accountBGCoverage, Set<String> accountState, Set<String> accountCountry) {
        
        Map<String, List<Sales_Territory_Definition__c>> rulesByBAMarketBGCoverageCountryState = new Map<String, List<Sales_Territory_Definition__c>>();
        String baMarket = getCommaSeperatedStringList(accountBAMarket);
        String bgCoverages = getCommaSeperatedStringList(accountBGCoverage);
        String states = getCommaSeperatedStringList(accountState);
        String countries = getCommaSeperatedStringList(accountCountry);
        //Debmalya--Test:Start
        system.debug('Deb001' + baMarket);
        system.debug('Deb002' + bgCoverages);
        system.debug('Deb003' + states);
        system.debug('Deb004' + countries);
        //Debmalya--Test:End
        if(bgCoverages != null && bgCoverages != '' && 
           states != null && states != '' && countries != null && countries != '' && baMarket != null && baMarket != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.BAMarketState) + '\''; 
            system.debug(confRuleQuery);
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.BAMarketState) + '\'';
            system.debug(nonConfRuleQuery);
            String otherconditions = ' AND BA_Market_Segment__c IN ' + baMarket +
                                     ' AND BG_Sales_Coverage_Segment__c IN ' + bgCoverages +
                                     ' AND State_Province__c IN ' + states +
                                     ' AND Country__C IN ' + countries;         
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                               
            //querying confidential rules
            system.debug('Deb005' + confRuleQuery);
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BA_Market_Segment__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByBAMarketBGCoverageCountryState = addRuleToMap(key, rule, rulesByBAMarketBGCoverageCountryState);
                }
            }
            //querying non-confidential rules
            system.debug('Deb006' + nonConfRuleQuery);
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BA_Market_Segment__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c, rule.State_Province__c);
                if(key != null && key != '') {
                    rulesByBAMarketBGCoverageCountryState = addRuleToMap(key, rule, rulesByBAMarketBGCoverageCountryState);
                }
            }
        }
        
        return rulesByBAMarketBGCoverageCountryState;
    }
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of BGCoverage, Country, Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against BGCoverage, Country, Zip
    **/    
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByBAMarketBGCoverageCountryZip(Set<String> accountBAMarket,Set<String> accountBGCoverage,
                                                                                     Map<String,Set<String>> postalCodesByCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByBAMarketBGCoverageCountryZip = new Map<String, List<Sales_Territory_Definition__c>>();
        String baMarket = getCommaSeperatedStringList(accountBAMarket);
        String bgCoverages = getCommaSeperatedStringList(accountBGCoverage);
        if(bgCoverages != null && bgCoverages != '' && postalCodesByCountry != null && postalCodesByCountry.size() > 0 && baMarket != null && baMarket != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.BAMarketPostalCode) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.BAMarketPostalCode) + '\'';
            String otherconditions = ' AND BA_Market_Segment__c IN ' + baMarket +
                                     ' AND BG_Sales_Coverage_Segment__c IN ' + bgCoverages +
                                     ' AND Postal_Code_Start__c != null AND Postal_Code_End__c != null';         
            
            String zipFilterCondition = generateFilterCondition(postalCodesByCountry);
            if(zipFilterCondition != null && zipFilterCondition != '') {
                otherconditions += zipFilterCondition;
            }
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                                   
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BA_Market_Segment__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c);
                if(key != null && key != '') {
                    rulesByBAMarketBGCoverageCountryZip = addRuleToMap(key, rule, rulesByBAMarketBGCoverageCountryZip);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BA_Market_Segment__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c);
                if(key != null && key != '') {
                    rulesByBAMarketBGCoverageCountryZip = addRuleToMap(key, rule, rulesByBAMarketBGCoverageCountryZip);
                }
            }
        }
    
        return rulesByBAMarketBGCoverageCountryZip;
    }
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of BGCoverage, Country
    * @return: a map containing List of Sales_Territory_Definition__c Rules against BGCoverage, Country, BAMarket Segment
    **/     
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByBAMarketBGCoverageCountry(Set<String> accountBAMarket, Set<String> accountBGCoverage, Set<String> accountCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByBAMarketBGCoverageCountry = new Map<String, List<Sales_Territory_Definition__c>>();
        String baMarket = getCommaSeperatedStringList(accountBAMarket);
        String bgCoverages = getCommaSeperatedStringList(accountBGCoverage);
        String countries = getCommaSeperatedStringList(accountCountry);
        if(bgCoverages != null && bgCoverages != '' && countries != null && countries != '' && baMarket != null && baMarket != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.BAMarket) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.BAMarket) + '\'';
            String otherconditions = ' AND BA_Market_Segment__c IN ' + baMarket +
                                     ' AND BG_Sales_Coverage_Segment__c IN ' + bgCoverages + 
                                     ' AND Country__C IN ' + countries +
                                     ' AND State_Province__c = null' +
                                     ' AND Postal_Code_Start__c = null ' +
                                     ' AND Postal_Code_End__c = null ';         
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BA_Market_Segment__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c);
                if(key != null && key != '') {
                    rulesByBAMarketBGCoverageCountry = addRuleToMap(key, rule, rulesByBAMarketBGCoverageCountry);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BA_Market_Segment__c, rule.BG_Sales_Coverage_Segment__c, rule.Country__c);
                if(key != null && key != '') {
                    rulesByBAMarketBGCoverageCountry = addRuleToMap(key, rule, rulesByBAMarketBGCoverageCountry);
                }
            }
        }
        
        return rulesByBAMarketBGCoverageCountry;
    }
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of BGCoverage, Country
    * @return: a map containing List of Sales_Territory_Definition__c Rules against BGCoverage, Country
    **/     
    public static Map<String, List<Sales_Territory_Definition__c>> getCoverageRulesByBAMarketCountry(Set<String> accountBAMarket, Set<String> accountCountry) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByBAMarketCountry = new Map<String, List<Sales_Territory_Definition__c>>();
        String baMarket = getCommaSeperatedStringList(accountBAMarket);
        String countries = getCommaSeperatedStringList(accountCountry);
        if(baMarket != null && baMarket != '' && countries != null && countries != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.BAMarketOnly) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.BAMarketOnly) + '\'';
            String otherconditions = ' AND BA_Market_Segment__c IN ' + baMarket + 
                                     ' AND Country__C IN ' + countries +
                                     ' AND State_Province__c = null' +
                                     ' AND Postal_Code_Start__c = null ' +
                                     ' AND Postal_Code_End__c = null ';         
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
            
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BA_Market_Segment__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByBAMarketCountry = addRuleToMap(key, rule, rulesByBAMarketCountry);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.BA_Market_Segment__c, rule.Country__c, null);
                if(key != null && key != '') {
                    rulesByBAMarketCountry = addRuleToMap(key, rule, rulesByBAMarketCountry);
                }
            }
        }
        
        return rulesByBAMarketCountry;
    }
    //TM:R4:CR3999:Debmalya:4th Jan,2013:check for new rule type BA Market Segment:End
    
    // TM:CRPR5:15th Mar,2013:new rule type Mdcp + BR Segment:Start  
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of MDCP, Business relationship
    * @return: a map containing List of Sales_Territory_Definition__c Rules against MDCP, Business relationship
    **/ 
    
     public static Map<String, List<Sales_Territory_Definition__c>> getAccountProfileRulesByMdcpBR(Set<String> accountMDCPId,Set<String> accountBR) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByMdcpBR = new Map<String, List<Sales_Territory_Definition__c>>();
        String mdcpIds = getCommaSeperatedStringList(accountMDCPId);
        String brs = getCommaSeperatedStringList(accountBR);
               
        if(mdcpIds != null && mdcpIds != '' && brs != null && brs != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.MdcpBR) + '\'';
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.MdcpBR) + '\''; 
            String otherconditions = ' AND MDCP_ID__c IN ' + mdcpIds+ 'AND Business_Relationship__c IN'+ brs;
            
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;      
        
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.MDCP_ID__c, rule.Business_Relationship__c, null);
                if(key != null && key != '') {
                    rulesByMdcpBR = addRuleToMap(key, rule, rulesByMdcpBR);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.MDCP_ID__c, rule.Business_Relationship__c, null);
                if(key != null && key != '') {
                    rulesByMdcpBR = addRuleToMap(key, rule, rulesByMdcpBR);
                }
            }
        }
        system.debug('*****$$$$$$$$$$$$$$$$$$$$$$$$$$$$$***********rulesByMdcpBR  ' +rulesByMdcpBR);
       
        return rulesByMdcpBR;
    }
    // TM:CRPR5:15th Mar,2013:new rule type Mdcp + BR Segment:End  
    
    /**
    * @description: queries rules for both confidential & non confidential territories 
    *               matching against received set of PartnerLocatorId
    * @return: a map containing List of Sales_Territory_Definition__c Rules against PartnerLocatorId
    **/ 
    
    public static Map<String,List<Sales_Territory_Definition__c>> getLocationRulesByLocator(Set<String>locationLocatorId){
        Map<String,List<Sales_Territory_Definition__c>> rulesByPartnerLocator = new Map<String,List<Sales_Territory_Definition__c>>();
        system.debug('Inside Territory assignment utilities locator ids size>>>>'+''+locationLocatorId.size());
        String partnerLocatorIds = getCommaSeperatedStringList(locationLocatorId);
        system.debug('Inside Territory assignment utilities locator ids string>>>>'+' '+partnerLocatorIds);
        if(partnerLocatorIds !=null && partnerLocatorIds != ''){
            //Locations dont have a confidential concept
 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.PartnerLocatorId) +'\'';
            String otherConditions = 'AND Partner_Locator_Id__c IN' + partnerLocatorIds;
            
            nonConfRuleQuery += otherConditions;
            
            system.debug('Inside Territory assignment utilities>>>>>'+' '+nonConfRuleQuery);
            for(Sales_Territory_Definition__c rule: Database.Query(nonConfRuleQuery)){
            system.debug('Inside Territory assignment utilities>>>>> partner locator id'+' '+rule.Partner_Locator_Id__c);
                if(rule.Partner_Locator_Id__c != null){
                    rulesByPartnerLocator = addRuleToMap(rule.Partner_Locator_Id__c.toUpperCase(),rule,rulesByPartnerLocator);
                }
            }
        }
        system.debug('Inside Territory assignment utilities ret list size>>>>>'+''+rulesByPartnerLocator.size());
        return rulesByPartnerLocator;
    }
    //TM:R5:Vinay:15th Mar,2013:check for new rule type Location:End
    
    //TM:R5:Vinay:27th Mar,2013:Location Rule MDCP Org Id+BR+Country
    /**
    * @description: queries rules for  non confidential territories 
    *               matching against received set of MDCP Org Id, Business Relationship, Country
    * @return: a map containing List of Sales_Territory_Definition__c Rules against MDCP Org Id, Business Relationship, Country
    **/    
    public static Map<String,List<Sales_Territory_Definition__c>> getLocationRulesByMdcpBusinessRelationshipCountry(
                                        Set<String> locationMDCpOrgIdSet,Set<String> locationBRSet,Set<String>locationCountrySet){
        Map<String,List<Sales_Territory_Definition__c>> rulesByMdcpBusinessRelationshipCountryMap = new Map<String,List<Sales_Territory_Definition__c>>();
        String locationMdcpOrgIds = getCommaSeperatedStringList(locationMDCpOrgIdSet);
        system.debug('locationMdcpOrgIds '+locationMdcpOrgIds );
        String locationBRs = getCommaSeperatedStringList(locationBRSet);
        system.debug('locationBRs '+locationBRs );
        String locationCountries = getCommaSeperatedStringList(locationCountrySet);
        system.debug('locationCountries '+locationCountries );
        
        if(locationMdcpOrgIds != null && locationMdcpOrgIds != '' && 
        locationBRs != null && locationBRs !='' && locationCountries != null && locationCountries!=''){
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.LocationCountry) + '\'';
            String otherConditions = 'AND MDCP_ID__c IN' + locationMdcpOrgIds +
                                     'AND Business_Relationship__c IN' + locationBRs +
                                     'AND Country__c IN' + locationCountries;
            nonConfRuleQuery += otherConditions;
            system.debug('Inside Territory assignment utilities location country>>>>>'+' '+nonConfRuleQuery);
            for(Sales_Territory_Definition__c rule:Database.query(nonConfRuleQuery)){
                String key = generateKey(rule.MDCP_ID__c,rule.Business_Relationship__c,rule.Country__c);
                if(key != null && key !=''){
                    rulesByMdcpBusinessRelationshipCountryMap = addRuleToMap(key,rule,rulesByMdcpBusinessRelationshipCountryMap);
                }
            }
        }
        system.debug('Inside Territory assignment utilities rulesByMdcpBusinessRelationshipCountryMap list size>>>>>'+''+rulesByMdcpBusinessRelationshipCountryMap.size());
        return rulesByMdcpBusinessRelationshipCountryMap;
    }
    
    //TM:R5:Vinay:27th Mar,2013:Location Rule MDCP Org Id+BR+Country+State
    /**
    * @description: queries rules for  non confidential territories 
    *               matching against received set of MDCP Org Id, Business Relationship, Country, State
    * @return: a map containing List of Sales_Territory_Definition__c Rules against MDCP Org Id, Business Relationship, Country, State
    **/   
    public static Map<String,List<Sales_Territory_Definition__c>> getLocationRulesByMdcpBusinessRelationshipStateCountry(
                                        Set<String> locationMdcpOrgIdSet,Set<String> locationBRSet,Set<String>locationCountrySet,Set<String>locationStateSet){
        Map<String,List<Sales_Territory_Definition__c>> rulesByMdcpBusinessRelationshipStateCountryMap = new Map<String,List<Sales_Territory_Definition__c>>();
        String locationMdcpOrgIds = getCommaSeperatedStringList(locationMdcpOrgIdSet);
        String locationBRs = getCommaSeperatedStringList(locationBRSet);
        String locationCountries = getCommaSeperatedStringList(locationCountrySet);
        String locationStates = getCommaSeperatedStringList(locationStateSet);
        
        if(locationMdcpOrgIds != null && locationMdcpOrgIds != '' &&
        locationBRs !=null && locationBRs != '' && locationCountries != null && locationCountries !='' && locationStates != null && locationStates !=''){
            String nonConfQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.LocationState) + '\'';
            String otherConditions = 'AND MDCP_ID__c IN' + locationMdcpOrgIds +
                                     'AND Business_Relationship__c IN' + locationBRs +
                                     'AND Country__c IN' + locationCountries +
                                     'AND State_Province__c IN' + locationStates;
            nonConfQuery += otherConditions;
            for(Sales_Territory_Definition__c rule: Database.query(nonConfQuery)){
                String key = generateKey(rule.MDCP_ID__c,rule.Business_Relationship__c,rule.Country__c,rule.State_Province__c);
                if(key != null && key !=''){
                    rulesByMdcpBusinessRelationshipStateCountryMap = addRuleToMap(key,rule,rulesByMdcpBusinessRelationshipStateCountryMap);
                }
            }
        }
        return rulesByMdcpBusinessRelationshipStateCountryMap; 
    }
    
    //TM:R5:Vinay:27th Mar,2013:Location Rule MDCP Org Id+BR+Country+Zip
    /**
    * @description: queries rules for  non confidential territories 
    *               matching against received set of MDCP Org Id, Business Relationship, Country, Zip
    * @return: a map containing List of Sales_Territory_Definition__c Rules against MDCP Org Id, Business Relationship, Country, Zip
    **/   
    public static Map<String,List<Sales_Territory_Definition__c>> getLocationRulesByMdcpBusinessRelationshipZipCountry(
                                            Set<String> locationMdcpOrgIdSet,Set<String> locationBRSet,Map<String,Set<String>> postalCodesByCountryMap){
        Map<String,List<Sales_Territory_Definition__c>> rulesByMdcpBusinessRelationshipZipCountryMap = new Map<String,List<Sales_Territory_Definition__c>>();
        String locationMdcpOrgIds = getCommaSeperatedStringList(locationMdcpOrgIdSet);
        String locationBRs = getCommaSeperatedStringList(locationBRSet);
        
        if(locationMdcpOrgIds != null && locationBRs != '' && postalCodesByCountryMap != null && postalCodesByCountryMap.size() > 0){
            String nonConfQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.LocationPostalCode) + '\'';
            String otherConditions = 'AND MDCP_ID__c IN' + locationMdcpOrgIds +
                                     'AND Business_Relationship__c IN' + locationBRs +
                                     'AND Postal_Code_Start__c != null AND Postal_Code_End__c != null';
            String zipFilterCondition = generateFilterCondition(postalCodesByCountryMap);
            if(zipFilterCondition != null && zipFilterCondition != ''){
                otherConditions += zipFilterCondition;
            }
            nonConfQuery += otherConditions;
            
            for(Sales_Territory_Definition__c rule: Database.query(nonConfQuery)){
                String key = generateKey(rule.MDCP_ID__c,rule.Business_Relationship__c,rule.Country__c,null);
                if(key != null && key != ''){
                    rulesByMdcpBusinessRelationshipZipCountryMap = addRuleToMap(key,rule,rulesByMdcpBusinessRelationshipZipCountryMap);
                }
            }
        }
        return rulesByMdcpBusinessRelationshipZipCountryMap;
    }
     
    //TM:R5 Vinay
    /**
    * @description: Checks if rule list exists in recieved map for received location id,
    *               if not found creates a new list & adds received rulelist to RuleList 
    *               then adds the RuleList to map against received location id
    * @return: a map containing List of Sales_Territory_Definition__c Rules against location Ids
    **/
    public static Map<Id,List<Sales_Territory_Definition__c>> captureMatchingRuleListForLocation(Id locId,List<Sales_Territory_Definition__c> rules,
                                                                                                Map<Id,List<Sales_Territory_Definition__c>> matchingRulesBylocId) {
          if(matchingRulesBylocId == null){
              matchingRulesBylocId = new Map<Id,List<Sales_Territory_Definition__c>>();
          }
          if(locId != null && rules != null && rules.size() > 0){
              List<Sales_Territory_Definition__c> ruleList = matchingRulesBylocId.get(locId);
              if(ruleList == null){
                  ruleList = new List<Sales_Territory_Definition__c>();
              }
              ruleList.addAll(rules);
              matchingRulesBylocId.put(locId,ruleList);
          }   
          return matchingRulesBylocId;                                                                           
     }
    
    // TM:CRPR5:27th Mar,2013:new rule type Geo Hierarchy Segment:Start
    public static Map<String, List<Sales_Territory_Definition__c>> getLocationProfileRulesByMDCPBRGeo(Set<String> locationMDCP, Set<String> locationBR,
                                                                Set<String> locationGeo) {
        Map<String, List<Sales_Territory_Definition__c>> rulesByMDCPBRGeo = new Map<String, List<Sales_Territory_Definition__c>>();
        String mdcps = getCommaSeperatedStringList(locationMDCP);
        String brs = getCommaSeperatedStringList(locationBR);
        String geos = getCommaSeperatedStringList(locationGeo);
        if(mdcps != null && mdcps != '' && 
           brs != null && brs != '' && geos != null && geos != '') {
            String confRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.Confidential+Label.LocationGeo) + '\''; 
            String nonConfRuleQuery = baseQuery + 'Filter__c = \'' + SalesTerritoryUtil.fetchFilterCodes(Label.NonConfidential+Label.LocationGeo) + '\'';
            String otherconditions = ' AND MDCP_ID__c IN ' + mdcps +
                                     ' AND Business_Relationship__c IN ' + brs +
                                     ' AND Geographic_Hierarchy__c IN ' + geos; 
            confRuleQuery += otherconditions; 
            nonConfRuleQuery += otherconditions;
                                                           
            //querying confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(confRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.MDCP_ID__c, rule.Business_Relationship__c, rule.Geographic_Hierarchy__c);
                if(key != null && key != '') {
                    rulesByMDCPBRGeo = addRuleToMap(key, rule, rulesByMDCPBRGeo);
                }
            }
            //querying non-confidential rules
            for(Sales_Territory_Definition__c rule: Database.query(nonConfRuleQuery)) {
                //add rule to map of ruleList against key
                String key = generateKey(rule.MDCP_ID__c, rule.Business_Relationship__c, rule.Geographic_Hierarchy__c);
                if(key != null && key != '') {
                    rulesByMDCPBRGeo = addRuleToMap(key, rule, rulesByMDCPBRGeo);
                }
            }
        }
       
        return rulesByMDCPBRGeo;
    }   
    // TM:CRPR5:27th Mar,2013:new rule type Geo Hierarchy Segment:End
    
}