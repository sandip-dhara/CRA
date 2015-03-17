/**********************************************************
* Class Name: SalesTerritoryUtil
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: Class contains method to populate index & filtercode field based on rule type : Account Profile, Coverage, Industry, Geo
***********************************************************/ 
public class SalesTerritoryUtil {
     
    /**
    * @description: Populate filter field based on rule type
    * @param: List of Sales Territory Definitions
    **/        
    public static void populateFilter(List<Sales_Territory_Definition__c> newDefinition) {
         
        Set<Id> territoryIds = new Set<Id>();
        Set<Id> confidentialTerritoryIds = new Set<Id>();
         
        for (Sales_Territory_Definition__c definition: newDefinition) {
            territoryIds.add(definition.Sales_Territory__c); 
        }
        if (territoryIds.size() > 0) {
            for (Sales_Territory__c territory : [Select Id, Name, IsConfidential__c
                                                From Sales_Territory__c 
                                                where Id in :territoryIds]) {
                if (territory.IsConfidential__c) {
                    confidentialTerritoryIds.add(territory.Id);
                }                                   
            }
        } 
              
        for (Sales_Territory_Definition__c definition: newDefinition) {
            
            String prefix = Label.NonConfidential;
            if (confidentialTerritoryIds.contains(definition.Sales_Territory__c)) {
                prefix = Label.Confidential;
            }
            // Check for Rule Type : Account Profile 
            if ( (definition.Country__c == null && definition.Postal_Code_Start__c == null && definition.Postal_Code_End__c == null &&
            definition.Geographic_Hierarchy__c == null) && (definition.AMID__c != null || definition.MDCP_ID__c != null || 
            definition.Source_System_ID__c != null || definition.Business_Relationship__c != null)) 
            {
                
                system.debug('Entered in account profiles');
                definition.Rule_Type__c = Label.Account_Profile;
                if (definition.AMID__c != null && definition.MDCP_ID__c == null && definition.Source_System_ID__c == null && 
                                                                                definition.Business_Relationship__c == null) 
                {
                    definition.filter__c = fetchFilterCodes(prefix + Label.AMIDOnly);
                }
                else if (definition.MDCP_ID__c != null && definition.AMID__c == null && definition.Source_System_ID__c == null 
                                                                                && definition.Business_Relationship__c == null) 
                {
                    definition.filter__c = fetchFilterCodes(prefix + Label.Mdcp);
                }
                else if (definition.Source_System_ID__c != null && definition.MDCP_ID__c == null && definition.AMID__c == null 
                                                                                && definition.Business_Relationship__c == null) 
                {
                    definition.filter__c = fetchFilterCodes(prefix + Label.SourceSystemId);
                }
                else if (definition.Source_System_ID__c == null && definition.MDCP_ID__c != null && definition.AMID__c == null && 
                   definition.Business_Relationship__c != null && definition.Country__c == null && definition.Postal_Code_Start__c == null && 
                   definition.Postal_Code_End__c == null && definition.Geographic_Hierarchy__c == null) 
                {
                    string s1= prefix + Label.MdcpBR;
                    system.debug('Value of prefix+label'+s1);
                    definition.filter__c = fetchFilterCodes(prefix + Label.MdcpBR);
                }
                else {
                    definition.filter__c = '';  
                }
            }   
            
            // Check for Rule Type : Industry Profile 
            else if (definition.Industry_Vertical__c != null) {
                definition.Rule_Type__c = Label.Industry;
                definition.filter__c = fetchFilterCodes(prefix + Label.IndustryVertical);               
            }   
            // Check for Rule Type : Coverage 
            else if (definition.BG_Sales_Coverage_Segment__c != null || definition.Named_Account__c != null || definition.RAD__c != null || 
            definition.BA_Market_Segment__c != null) {
                definition.Rule_Type__c = Label.Sales_Coverage;
                if (definition.BG_Sales_Coverage_Segment__c != null && definition.Named_Account__c == null && definition.RAD__c == null) {
            //TM:Debmalya:R4:CR3999:4th Jan,2013:check for new rule type BA Market Segment:Start
                    if(definition.BA_Market_Segment__c != null){
                        if(definition.State_Province__c != null && definition.Postal_Code_Start__c == null && definition.Postal_Code_End__c == null){
                            definition.filter__c = fetchFilterCodes(prefix + Label.BAMarketState);
                        }else if(definition.State_Province__c == null && definition.Postal_Code_Start__c != null && definition.Postal_Code_End__c != null){
                            definition.filter__c = fetchFilterCodes(prefix + Label.BAMarketPostalCode);
                        }else if(definition.State_Province__c == null && definition.Postal_Code_Start__c == null && definition.Postal_Code_End__c == null){
                            definition.filter__c = fetchFilterCodes(prefix + Label.BAMarket);
                        }
                    }else{
                        definition.filter__c = fetchFilterCodes(prefix + Label.BGCoverage);
                    }
            //TM:Debmalya:R4:CR3999:4th Jan,2013:check for new rule type BA Market Segment:End
                }
                else if (definition.Named_Account__c != null && definition.BG_Sales_Coverage_Segment__c == null && definition.RAD__c == null && definition.BA_Market_Segment__c == null) {
                    definition.filter__c = fetchFilterCodes(prefix + Label.NamedAccount);
                }               
                else if (definition.RAD__c != null && definition.BG_Sales_Coverage_Segment__c == null && definition.Named_Account__c == null && definition.BA_Market_Segment__c == null) {
                    definition.filter__c = fetchFilterCodes(prefix + Label.RAD);
                }
            //TM:debmalya:R4:CR3999:4th Jan,2013:check for new rule type BA Market Segment:Start
                else if (definition.RAD__c == null && definition.BG_Sales_Coverage_Segment__c == null && definition.Named_Account__c == null && definition.BA_Market_Segment__c != null) {
                    definition.filter__c = fetchFilterCodes(prefix + Label.BAMarketOnly);
                }
            //TM:Debmalya:R4:CR3999:4th Jan,2013:check for new rule type BA Market Segment:End
                else {
                    definition.filter__c = '';  
                }               
            }           
            // Check for Rule Type : Geographic  
            else if ((definition.MDCP_ID__c == null || definition.Business_Relationship__c == null)&&(definition.Geographic_Hierarchy__c != null || definition.Country__c != null || definition.State_Province__c != null 
                        || definition.Postal_Code_Start__c != null || definition.Postal_Code_End__c != null)) {
                definition.Rule_Type__c = Label.Geographic;                 
                    if (definition.Country__c != null && definition.Postal_Code_Start__c != null && definition.Postal_Code_End__c != null &&
                        definition.State_Province__c == null && definition.Geographic_Hierarchy__c == null) {
                        definition.filter__c = fetchFilterCodes(prefix + Label.CountryZip);
                            
                    }       
                    else if (definition.Country__c != null && definition.Postal_Code_Start__c == null && definition.Postal_Code_End__c == null &&
                        definition.State_Province__c != null && definition.Geographic_Hierarchy__c == null) {
                        definition.filter__c = fetchFilterCodes(prefix + Label.CountryState);
                        
                    }
                    else if (definition.Country__c != null && definition.Postal_Code_Start__c== null && definition.Postal_Code_End__c == null &&
                        definition.State_Province__c == null && definition.Geographic_Hierarchy__c == null) {
                        definition.filter__c = fetchFilterCodes(prefix + Label.Country);
                        
                    }
                    else if (definition.Country__c == null && definition.Postal_Code_Start__c == null && definition.Postal_Code_End__c == null &&
                        definition.State_Province__c == null && definition.Geographic_Hierarchy__c != null) {
                        definition.filter__c = fetchFilterCodes(prefix + Label.Geo);                                
                    }
                    else {
                        definition.filter__c = '';
                    }
            } 
            //Vinay:R5:check for new rule Location:Start
            else if(definition.Partner_Locator_Id__c != null || definition.MDCP_ID__c != null || definition.Business_Relationship__c != null ||
            definition.Country__c != null || definition.State_Province__c != null || definition.Postal_Code_Start__c != null || definition.Postal_Code_End__c != null ||
            definition.Geographic_Hierarchy__c != null){
                definition.Rule_Type__c = Label.Location;
                if(definition.Partner_Locator_Id__c != null){
                    definition.filter__c = fetchFilterCodes(prefix+Label.PartnerLocatorId);
                }
                else if(definition.MDCP_ID__c != null && definition.Business_Relationship__c != null && definition.Country__c != null && 
                            definition.State_Province__c == null && definition.Postal_Code_Start__c == null && definition.Postal_Code_End__c == null){
                    definition.filter__c = fetchFilterCodes(prefix+Label.LocationCountry);
                }
                else if(definition.MDCP_ID__c != null && definition.Business_Relationship__c != null && definition.Country__c != null && 
                            definition.State_Province__c != null){
                    definition.filter__c = fetchFilterCodes(prefix+Label.LocationState);
                }
                else if(definition.MDCP_ID__c != null && definition.Business_Relationship__c != null && definition.Country__c != null && 
                            definition.Postal_Code_Start__c != null && definition.Postal_Code_End__c != null){
                    definition.filter__c = fetchFilterCodes(prefix+Label.LocationPostalCode);
                }
                else if(definition.MDCP_ID__c != null && definition.Business_Relationship__c != null && definition.Geographic_Hierarchy__c != null){
                    definition.filter__c = fetchFilterCodes(prefix+Label.LocationGeo);
                }
                else{
                    definition.filter__c = '';
                }
            }
            //Vinay:R5:check for new rule Location:Start
            
            system.debug('*****definition.filter__c : ' + definition.filter__c);
        }
    }   
    
    /**
    * @description: Checks for duplicate rule before insert 
    * @param: List of new Sales Territory Definitions 
    **/    
    public static void duplicateCheckForDefInsert(List<Sales_Territory_Definition__c> newDefinition) {
        checkDuplicate(newDefinition, false);
    }

    /**
    * @description: Check for duplicate rule before update 
    * @param: List of new and old Sales Territory Definitions
    **/      
    public static void duplicateCheckForDefUpdate(List<Sales_Territory_Definition__c> newDefinition, List<Sales_Territory_Definition__c> oldDefinition) {
        checkDuplicate(newDefinition, true);
    }
    
    /**
    * @description: Checks for duplicate rule by comparing Index
    *         & throws error if duplicate rule found  
    * @param: List of new Sales Territory Definitions
    * @param: boolean indicating if its called from update trigger
    **/
    public static void checkDuplicate(List<Sales_Territory_Definition__c> newDefinition, boolean isUpdate) {
        
        Set<String> stdIndexSet = new Set<String>();
        Set<String> stdIds = new Set<String>();
        Set<String> existingIndexes = new Set<String>();
    //TM:Debmalya: Req:2091: Modify Duplicate check so that duplicate definitions can exist in Patner and Customer definitions:Start
        Set<String> existingIndexesCus = new Set<String>();
        Set<String> existingIndexesPar = new Set<String>();
        String stdType = null;
        Set<Id> stId = new Set<Id>();
        //Capture all Sales Territory Ids and their corresponding IsPartner Flags
        Map<Id, Boolean> stPartnerFlag = new Map<Id, Boolean>(); 
        for (Sales_Territory_Definition__c std_ST_Flag : newDefinition){
            stId.add(std_ST_Flag.Sales_Territory__c);
        }
        for(Sales_Territory__c stObj: [Select Id, IsPartner__c From Sales_Territory__c where Id in :stId]){
            stPartnerFlag.put(stObj.Id,stObj.IsPartner__c);
        }
    //TM:Debmalya: Req:2091: Modify Duplicate check so that duplicate definitions can exist in Patner and Customer definitions:End
        try{
                //TM:Debmalya: Req:2091:23rd Oct,2012: Duplicate now allowed across Customer and Partner Sales Territories
                Integer flag = 0;
                for (Sales_Territory_Definition__c std : newDefinition) {
                    
                    //Index will be used to identify unique rule & avoid duplication
                    //But as per CR#:129 duplicate rules can exists for 'AMID only' & 'MDCP Id only' criteria
                    //For these fields generate different index pattern
                    if((std.MDCP_ID__c != null || std.AMID__c != null || std.partner_locator_id__c != null ||
                             std.Business_Relationship__c != null) &&
                                (std.Industry_Vertical__c == null && std.BG_Sales_Coverage_Segment__c == null && 
                    std.Named_Account__c == null && std.RAD__c == null)) {
                   
                       //considering Sales Territory in index so that duplicate rules should not point to same territory
                       //Scenario to check for MDCP ID only rule
                       if(std.MDCP_ID__c != null && std.Business_Relationship__c == null)  {
                         std.Index__c = std.MDCP_ID__c.toUpperCase() + '*' + std.Sales_Territory__c;
                       } else if(std.AMID__c != null){
                         std.Index__c = '*' + std.AMID__c.toUpperCase() + std.Sales_Territory__c;
                       }/*else if(std.Source_System_ID__c != null){ //New Requirement to ensure Source System Id be duplicated across territories
                         std.Index__c = std.Source_System_ID__c.toUpperCase() + std.Sales_Territory__c+'*';
                       }*/else if(std.partner_locator_id__c != null){ //New Requirement to ensure Partner Locator Id be duplicated across territories
                         std.Index__c = std.partner_locator_id__c.toUpperCase() + std.Sales_Territory__c+'*';
                        //New Requirement:To ensure Location rules be duplicated across Territories
                       }else if(std.MDCP_ID__c != null && std.Business_Relationship__c != null &&
                                    std.Country__c == null && std.State_Province__c == null &&  std.Postal_Code_Start__c == null && 
                                std.Postal_Code_End__c == null && std.Geographic_Hierarchy__c == null){ //MDCP Id+BR
                         std.Index__c = std.MDCP_ID__c.toUpperCase() + '*' + std.Business_Relationship__c.toUpperCase() + '*' + std.Sales_Territory__c;
                       }else if(std.MDCP_ID__c != null && std.Business_Relationship__c != null && std.Country__c != null && 
                                    std.State_Province__c == null &&  std.Postal_Code_Start__c == null && std.Postal_Code_End__c == null ){//MDCP Id + BR + Country
                         std.Index__c = std.MDCP_ID__c.toUpperCase() + '*' + std.Business_Relationship__c.toUpperCase() + '*' +std.Country__c.toUpperCase() + 
                          '*' + std.Sales_Territory__c;
                       }else if(std.MDCP_ID__c != null && std.Business_Relationship__c != null && std.Country__c != null &&
                                    std.State_Province__c != null){//MDCP Id + BR + Country + State/Province
                         std.Index__c = std.MDCP_ID__c.toUpperCase() + '*' + std.Business_Relationship__c.toUpperCase() + '*' +std.Country__c.toUpperCase() + 
                          '*' + std.State_Province__c.toUpperCase() + '*' +std.Sales_Territory__c;
                       }else if(std.MDCP_ID__c != null && std.Business_Relationship__c != null && std.Country__c != null &&
                                    std.Postal_Code_Start__c != null && std.Postal_Code_End__c != null){//MDCP Id + BR + Country + Zip
                         std.Index__c = std.MDCP_ID__c.toUpperCase() + '*' + std.Business_Relationship__c.toUpperCase() + '*' +std.Country__c.toUpperCase() + 
                          '*' + std.Postal_Code_Start__c.toUpperCase() + '*' + std.Postal_Code_End__c.toUpperCase()+ '*' +std.Sales_Territory__c;
                       }else if(std.MDCP_ID__c != null && std.Business_Relationship__c != null && std.Geographic_Hierarchy__c != null){//MDCP Id + BR + Geo
                         std.Index__c = std.MDCP_ID__c.toUpperCase() + '*' + std.Business_Relationship__c.toUpperCase() + '*' +
                         '*' + std.Geographic_Hierarchy__c+ '*' +std.Sales_Territory__c;
                       }
                    } else {
                        //generate index for all rules accept of types 'AMID only' & 'MDCPID only' & Location Rules
                        std.Index__c = generateIndex(std);
                    }
                    stdIndexSet.add(std.Index__c);
            //TM:Debmalya: Req:2091:23rd Oct,2012: Duplicate now allowed across Customer and Partner Sales Territories: Start
                    if (flag == 0){
                        stdType = (stPartnerFlag.get(std.Sales_Territory__c)?'true' :'false');
                        system.debug(stdType);
                        flag = 1;    
                    }
                    if (flag == 1 && stdType != (stPartnerFlag.get(std.Sales_Territory__c)?'true' :'false')){
                        stdType = 'both';
                    }
            //TM:Debmalya: Req:2091:23rd Oct,2012: Duplicate now allowed across Customer and Partner Sales Territories: End
                    if(isUpdate){
                      stdIds.add(std.Id);
                    }
                }
                
            //TM:Debmalya: Req:2091:23rd Oct,2012: Duplicate now allowed across Customer and Partner Sales Territories: Start
                if (stdType != 'both'){
                    //fetching existing filters in database
                    system.debug(stdType + 'In single record type');
                    existingIndexes = fetchExistingIndexes(stdIndexSet, stdIds, stdType);
                    
                    //Check rule duplication by checking if new indexes already exists
                    if(existingIndexes != null) {
                        for (Sales_Territory_Definition__c stdO : newDefinition) {
                            if (existingIndexes.contains(stdO.Index__c)) {
                                stdO.addError(Label.STD_Error);
                            }   
                        }
                    }
                }else{
                    existingIndexesCus = fetchExistingIndexes(stdIndexSet, stdIds, 'false');
                    existingIndexesPar = fetchExistingIndexes(stdIndexSet, stdIds, 'true');
                    
                    //Check rule duplication by checking if new indexes already exists
                    for (Sales_Territory_Definition__c stdO : newDefinition) {
                        String stdOType = (stdO.Sales_Territory__r.IsPartner__c?'true' :'false');
                        if(stdOType == 'true' && existingIndexesPar != null){
                            if (existingIndexesPar.contains(stdO.Index__c)) {
                                stdO.addError(Label.STD_Error);
                            }
                        }
                        if(stdOType == 'false' && existingIndexesCus != null){
                            if (existingIndexesCus.contains(stdO.Index__c)){
                                stdO.addError(Label.STD_Error);
                            }
                        }
                        //Vinay:R5:check for new rule Location:Start
                        // Partner locator id rule should be unique across all territories
                        if(stdO.partner_locator_id__c !=null){ 
                             stdO.addError(Label.STD_Error);
                        }
                        //Vinay:R5:check for new rule Location:End
                    }
                    
                }
            //TM:Debmalya: Req:2091:23rd Oct,2012: Duplicate now allowed across Customer and Partner Sales Territories: End
        }  
        catch(Exception e) {
            system.debug('****Exception Occured in ValidationsForSalesTerrDefenition*****' + e.getMessage());  
        }
    }
    
    public static Set<String> fetchExistingIndexes(Set<String> stdIndexSet, Set<String> stdIds, String stdType) {
      Set<String> existingIndexes = new Set<String>();
      //TM:Debmalya: Req:2091:23rd Oct,2012: Duplicate now allowed across Customer and Partner Sales Territories
      Boolean isPartner = stdType.equals('true');
      if (stdIndexSet != null && stdIndexSet.size() > 0) {
        if(stdIds != null) {
      //TM:Debmalya: Req:2091:23rd Oct,2012: Modify query to allow duplicates across Customer and Partner Sales Territories
          for (Sales_Territory_Definition__c std : [Select Id, Name, Index__c, Sales_Territory__r.IsActive__c, Sales_Territory__r.IsPartner__c
                                                          from Sales_Territory_Definition__c
                                                          where Index__c In : stdIndexSet
                                                          AND Index__c != null
                                                          AND Sales_Territory__r.IsActive__c = true
                                                          AND Sales_Territory__r.IsPartner__c = :isPartner
                                                          AND Id not in :stdIds]) {
                    existingIndexes.add(std.Index__c);
                }
        } else {
                for (Sales_Territory_Definition__c std : [Select Id, Name, Index__c, Sales_Territory__r.IsActive__c
                                                          from Sales_Territory_Definition__c
                                                          where Index__c In : stdIndexSet
                                                          AND Index__c != null
                                                          AND Sales_Territory__r.IsPartner__c = :isPartner
                                                          AND Sales_Territory__r.IsActive__c = true]) {
                    existingIndexes.add(std.Index__c);
                }
        } 
      }
      return existingIndexes;
    }
    
    /**
    * @description: Populate Index field based on information present in definition.
    * @param: Sales Territory Definition record
    * @param: String Index value
    **/        
    public static String generateIndex(Sales_Territory_Definition__c std) {
        String index;
        if(std != null) {
            index = '' +(std.AMID__c==null?'*' :std.AMID__c)
                 +(std.MDCP_ID__c==null?'*' :std.MDCP_ID__c)  
                     +(std.BG_Sales_Coverage_Segment__c==null?'*' :std.BG_Sales_Coverage_Segment__c)
                     +(std.Country__c==null?'*' :std.Country__c)
                     +(std.Named_Account__c==null?'*' :std.Named_Account__c)
                     +(std.Postal_Code_End__c==null?'*' :std.Postal_Code_End__c)
                     +(std.Postal_Code_Start__c==null?'*' :std.Postal_Code_Start__c)
                     +(std.RAD__c==null?'*' :std.RAD__c)
                     +(std.State_Province__c==null?'*' :std.State_Province__c)
                     +(std.Industry_Vertical__c==null?'*' :std.Industry_Vertical__c) 
                     +(std.Geographic_Hierarchy__c==null?'*' :std.Geographic_Hierarchy__c)
         //TM:Debmalya:R4:CR3999:4th Jan,2013:check for new rule type BA Market Segment:Start
                     //+(std.Source_System_ID__c==null?'*' :std.Source_System_ID__c);
                     +(std.Source_System_ID__c==null?'*' :std.Source_System_ID__c) 
                     +(std.BA_Market_Segment__c==null?'*' :std.BA_Market_Segment__c)
         //TM:Debmalya:R4:CR3999:4th Jan,2013:check for new rule type BA Market Segment:End 
         //Vinay:R5:check for new rule Location:Start
                     +(std.Partner_Locator_Id__c==null?'*' :std.Partner_Locator_Id__c);
         //Vinay:R5:check for new rule Location:End
        
                    
        }
        return index.toUpperCase();
    }
    
    /**
    * @description - fetch filter code for given filter name
    * @param- String filter name
    * @return - returns a String of filter code
    **/     
    public static String fetchFilterCodes(String filterName) {
        String codeValue = '';
        if (filterName != null && filterName != '') {
            Filter_Code__c filterCode = filterCodes.get(filterName);
            if (filterCode != null) {
                codeValue = filterCode.Code__c;
            }
        }
        return codeValue;
    }
    
    public static Map<String, Filter_Code__c> filterCodes {
        set;
        get{
            if (filterCodes == null) {
                filterCodes = Filter_Code__c.getAll();
                system.debug('filterCodes>>'+filterCodes);
            }
            return filterCodes;
        } 
    }
     /* @description evaluate territory flag, insertion new defintion
    sreenath 9/25/2012 Req no. 2089
    */
    public static void evaluateTerritory(List<Sales_Territory_Definition__c> newDefinition){
        Set<Id> territoryIds = new Set<Id>();
        //Set<Id> confidentialTerritoryIds = new Set<Id>();
         
        for (Sales_Territory_Definition__c definition: newDefinition) {
            territoryIds.add(definition.Sales_Territory__c); 
        }
        if (territoryIds.size() > 0) {
            List<Sales_Territory__c> terrlist = [Select Id, Name, IsConfidential__c,EvaluateTerritory_for_Realignment__c 
                                                From Sales_Territory__c 
                                                where Id in :territoryIds];
            for (Integer i =0;i<terrlist.size();i++) {
                if(!terrlist[i].EvaluateTerritory_for_Realignment__c){
                system.debug('%%%%%%%' + terrlist[i].EvaluateTerritory_for_Realignment__c );
                terrlist[i].EvaluateTerritory_for_Realignment__c = true;
                system.debug('******' +terrlist[i].EvaluateTerritory_for_Realignment__c );
                }
           }
           update terrlist;
        }
    
    
    }
    
    
     public static void evaluateTerritory(Map<Id, Sales_Territory_Definition__c> TerritoryDefNewMap, Map<Id, Sales_Territory_Definition__c> TerritoryDefOldMap) {
        List<Sales_Territory_Definition__c> Salesterrdef = new List<Sales_Territory_Definition__c>();  
        Set<Id> TerritoryDefIDs = new Set<Id>();
        if (TerritoryDefNewMap != null && TerritoryDefOldMap != null) {
            
            for (Id TerritoryDefID: TerritoryDefNewMap.keySet()) {
                if (TerritoryDefOldMap.get(TerritoryDefID).MDCP_ID__c != TerritoryDefNewMap.get(TerritoryDefID).MDCP_ID__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).Source_System_ID__c != TerritoryDefNewMap.get(TerritoryDefID).Source_System_ID__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).AMID__c != TerritoryDefNewMap.get(TerritoryDefID).AMID__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).Named_Account__c != TerritoryDefNewMap.get(TerritoryDefID).Named_Account__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).Industry_Vertical__c != TerritoryDefNewMap.get(TerritoryDefID).Industry_Vertical__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).BG_Sales_Coverage_Segment__c != TerritoryDefNewMap.get(TerritoryDefID).BG_Sales_Coverage_Segment__c   ||
                    TerritoryDefOldMap.get(TerritoryDefID).Geographic_Hierarchy__c != TerritoryDefNewMap.get(TerritoryDefID).Geographic_Hierarchy__c     ||
                    TerritoryDefOldMap.get(TerritoryDefID).RAD__c != TerritoryDefNewMap.get(TerritoryDefID).RAD__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).Postal_Code_Start__c != TerritoryDefNewMap.get(TerritoryDefID).Postal_Code_Start__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).Postal_Code_End__c != TerritoryDefNewMap.get(TerritoryDefID).Postal_Code_End__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).State_Province__c != TerritoryDefNewMap.get(TerritoryDefID).State_Province__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).Country__c != TerritoryDefNewMap.get(TerritoryDefID).Country__c ||
                    //R5:TM:Req-6021:Vinay M:Check including fields related to Location rules
                    TerritoryDefOldMap.get(TerritoryDefID).Partner_Locator_Id__c != TerritoryDefNewMap.get(TerritoryDefID).Partner_Locator_Id__c ||
                    TerritoryDefOldMap.get(TerritoryDefID).Business_Relationship__c != TerritoryDefNewMap.get(TerritoryDefID).Business_Relationship__c) {
                        
                    Salesterrdef.add(TerritoryDefNewMap.get(TerritoryDefID)); 
                }
            }
        }
            
        if (Salesterrdef.size() > 0) {
        Set<Id> territoryIds = new Set<Id>();
            for (Sales_Territory_Definition__c definition: Salesterrdef) {
            territoryIds.add(definition.Sales_Territory__c); 
        }
        if (territoryIds.size() > 0) {
            List<Sales_Territory__c> terrlist = [Select Id, Name, IsConfidential__c,EvaluateTerritory_for_Realignment__c 
                                                From Sales_Territory__c 
                                                where Id in :territoryIds];
            for (Integer i =0;i<terrlist.size();i++) {
                if(!terrlist[i].EvaluateTerritory_for_Realignment__c){
                system.debug('%%%%%%%' + terrlist[i].EvaluateTerritory_for_Realignment__c );
                terrlist[i].EvaluateTerritory_for_Realignment__c = true;
                system.debug('******' +terrlist[i].EvaluateTerritory_for_Realignment__c );
                }
           }
           update terrlist;
        }
            
        }
    }
}