/***********************************************************
* Class Name: TerritoryAssignmentEngine
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: This class contains method to evaluate Account against Confidential, Account Profile, 
*        Industry Type, Coverage Type, Geographic Type Rules in Sales Territory.
***********************************************************/
public class TerritoryAssignmentEngine {
    
    /**
    * @description -  Method to match Account against Account Profile Rules
    */     
    public static void matchByAccountProfileRules(Map<Id, Account> accountsById) {

        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId = new Map <Id,List<Sales_Territory_Definition__c>>();
        if(accountsById != null && accountsById.size() > 0) {

            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByMDCP(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchBySrcSysAccId(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByAMIDCountryState(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByAMIDBGCoverageCountryZip(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByAMIDCountryZip(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByAMIDIndustryVerticalGeo(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByAMIDOnly(accountsById, matchingRulesByAccId);
            
            //PTM R5 Start:Added new Rule for MDCP and Business Relationship as a part of R5
            //Commented as part of R6 CR 11429
            /*matchingRulesByAccId = TerritoryAssignmentFunctions.searchByMDCPBR(accountsById,matchingRulesByAccId);*/
            //PTM R5 End:Added new Rule for MDCP and Business Relationship as a part of R5
            
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- Start
            matchingRulesByAccId = TerritoryAssignmentFunctions.mapAssignedSalesTerritory(accountsById,matchingRulesByAccId);           
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- End   
            TerritoryAssignmentOperations.createTerritoryAccAssignment(matchingRulesByAccId);
            TerritoryManagementPostAssignment.postAssignmentForTM(matchingRulesByAccId);
            // TM : Ritesh : Add To Account Team moved to batch class.
            //TerritoryManagementPostAssignment.addToAccountTeamforTM(matchingRulesByAccId);
        } 
    }
    
    /**
    * @description -  Method to match Account against Industry Rules
    */ 
    public static void matchByIndustryRules(Map<Id, Account> accountsById) {

        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId = new Map <Id,List<Sales_Territory_Definition__c>>();
        if(accountsById != null && accountsById.size() > 0) {
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByIndustryBGCoverageCountryZip(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByIndustryCountryState(accountsById, matchingRulesByAccId);
            
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- Start
            matchingRulesByAccId = TerritoryAssignmentFunctions.mapAssignedSalesTerritory(accountsById,matchingRulesByAccId);
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- End
            TerritoryAssignmentOperations.createTerritoryAccAssignment(matchingRulesByAccId);
            TerritoryManagementPostAssignment.postAssignmentForTM(matchingRulesByAccId); 
            // TM : Ritesh : Add To Account Team moved to batch class.
            //TerritoryManagementPostAssignment.addToAccountTeamforTM(matchingRulesByAccId);       
        }   
    
    }   
    
    /**
    * @description -  Method to match Account against Coverage Rules
    */  
    public static void matchByCoverageRules(Map<Id, Account> accountsById) {

        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId = new Map <Id,List<Sales_Territory_Definition__c>>();
        if(accountsById != null && accountsById.size() > 0) {
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByBgCoverageCountryState(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByBgCoverageCountryZip(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByBgCoverageCountry(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByNamedAccCountryState(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByNamedAccCountryZip(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByRADCountry(accountsById, matchingRulesByAccId);
            
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- Start
            matchingRulesByAccId = TerritoryAssignmentFunctions.mapAssignedSalesTerritory(accountsById,matchingRulesByAccId);
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- End
            TerritoryAssignmentOperations.createTerritoryAccAssignment(matchingRulesByAccId);
            TerritoryManagementPostAssignment.postAssignmentForTM(matchingRulesByAccId);
            // TM : Ritesh : Add To Account Team moved to batch class.
            //TerritoryManagementPostAssignment.addToAccountTeamforTM(matchingRulesByAccId);
         } 
    }
    
    //TM:R4:CR3999:Debmalya:4th Jan,2013:check for new rule type BA Market Segment:Start
    /**
    * @description -  Method to match Account against Coverage Rules
    */
    public static void matchByBAMarketRules(Map<Id, Account> accountsById) {
        
        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId = new Map <Id,List<Sales_Territory_Definition__c>>();
        if(accountsById != null && accountsById.size() > 0) {
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByBAMarketBGCoverageStateCountry(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByBAMarketBgCoverageCountryZip(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByBAMarketBgCoverageCountry(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByBAMarketCountry(accountsById, matchingRulesByAccId);
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- Start
            matchingRulesByAccId = TerritoryAssignmentFunctions.mapAssignedSalesTerritory(accountsById,matchingRulesByAccId);
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- End
            TerritoryAssignmentOperations.createTerritoryAccAssignment(matchingRulesByAccId);
            TerritoryManagementPostAssignment.postAssignmentForTM(matchingRulesByAccId);    
        }   
    }
    //TM:R4:CR3999:Debmalya:4th Jan,2013:check for new rule type BA Market Segment:End
    /**
    * @description -  Method to match Account against Geographic Rules
    */     
    public static void matchByGeoRules(Map<Id, Account> accountsById) {

        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId = new Map <Id,List<Sales_Territory_Definition__c>>();
        if(accountsById != null && accountsById.size() > 0) {
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByCountryZip(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByCountryState(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByCountry(accountsById, matchingRulesByAccId);
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByRegion(accountsById, matchingRulesByAccId);
            
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- Start
            matchingRulesByAccId = TerritoryAssignmentFunctions.mapAssignedSalesTerritory(accountsById,matchingRulesByAccId);
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- End
            TerritoryAssignmentOperations.createTerritoryAccAssignment(matchingRulesByAccId);
            TerritoryManagementPostAssignment.postAssignmentForTM(matchingRulesByAccId);
            // TM : Ritesh : Add To Account Team moved to batch class.
            //TerritoryManagementPostAssignment.addToAccountTeamforTM(matchingRulesByAccId);
        } 
    }
    
    //TM:R5:Vinay:14th Feb,2013:check for new rule type Location:Start
    /**
    * @description -  Method to match Location against Coverage Rules
    */
    public static Map<Id,List<Sales_Territory_Definition__c>> matchByLocationRules(Map<Id, Location__c> locationsById) {

        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocId = new Map <Id,List<Sales_Territory_Definition__c>>();
        
        if(locationsById != null && locationsById.size() > 0) {
            matchingRulesByLocId = TerritoryAssignmentFunctions.searchByPartnerLocation(locationsById, matchingRulesByLocId);
            matchingRulesByLocId = TerritoryAssignmentFunctions.searchByMdcpBusinessRelationshipCountry(locationsById,matchingRulesByLocId);
            matchingRulesByLocId = TerritoryAssignmentFunctions.searchByMdcpBusinessRelationshipStateCountry(locationsById,matchingRulesByLocId);
            matchingRulesByLocId = TerritoryAssignmentFunctions.searchByMdcpBusinessRelationshipZipCountry(locationsById,matchingRulesByLocId);
            matchingRulesByLocId = TerritoryAssignmentFunctions.searchByMDCPBRGeo(locationsById, matchingRulesByLocId);
            
            matchingRulesByLocId = TerritoryAssignmentFunctions.mapAssignedSalesTerritoryForLocation(locationsById,matchingRulesByLocId);
            
            TerritoryAssignmentOperations.createTerritoryLocAssignment(matchingRulesByLocId);
            /*TMPostLocationAssignment.postAssignmentforTM(matchingRulesByLocId);*/
            
        } 
        return matchingRulesByLocId;
    }
    
    //TM:R6:CR-ID:11429:Vinay:Start
    public static Map<Id,List<Sales_Territory_Definition__c>> matchByPartnerBRRules(Map<Id,Account> accountsById){
        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId = new Map<Id,List<Sales_Territory_Definition__c>>();
        if(null != accountsById && accountsById.size() > 0){
            //PTM R5 Start:Added new Rule for MDCP and Business Relationship as a part of R5
            matchingRulesByAccId = TerritoryAssignmentFunctions.searchByMDCPBR(accountsById,matchingRulesByAccId);
            //PTM R5 End:Added new Rule for MDCP and Business Relationship as a part of R5
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- Start
            matchingRulesByAccId = TerritoryAssignmentFunctions.mapAssignedSalesTerritory(accountsById,matchingRulesByAccId);           
            // TM: Debmalya: Req-2085 Sep 21, 2012:Create set of associated Sales Territory- End   
            TerritoryAssignmentOperations.createTerritoryAccAssignment(matchingRulesByAccId);
        }
        return matchingRulesByAccId;
    }
    //TM:R6:CR-ID:11429:Vinay:End
}