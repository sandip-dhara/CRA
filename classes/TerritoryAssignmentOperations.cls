/**********************************************************
* Class Name: TerritoryAssignmentOperations
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: Class contains method to create Junction Object as Post Assignment Logic.
***********************************************************/
public class TerritoryAssignmentOperations {
    
    /**
    * @description: creates a junction object between account & Sales Territory
    **/
    public static void createTerritoryAccAssignment(Map <Id,List<Sales_Territory_Definition__c>> matchingRulesByAccId) {
    System.debug('Print in createTerritoryAccAssignment.matchingRulesByAccId>>>>'+matchingRulesByAccId);
        if(matchingRulesByAccId != null) {
          
            Map<String, Sales_Territory_Account_Assignment__c> updateTAMap = new Map<String, Sales_Territory_Account_Assignment__c>();
            for(Id accId : matchingRulesByAccId.keyset()) {
                List<Sales_Territory_Definition__c> rules = matchingRulesByAccId.get(accId);
                if (rules != null) {
                    for (Sales_Territory_Definition__c rule : rules) {
                        Sales_Territory_Account_Assignment__c territoryAccAssign = new Sales_Territory_Account_Assignment__c();
                        territoryAccAssign.Account__c = accId;
                        territoryAccAssign.Sales_Territory__c = rule.Sales_Territory__c;
                        territoryAccAssign.Account_To_Territory_Id__c = '' + accId + '-' + rule.Sales_Territory__c;
                        territoryAccAssign.Assignment_Type__c = Label.Territory_Engine;
                        territoryAccAssign.Sales_Territory_Definition__c = rule.Id;
                        // TM : Ritesh --. change for Add to Account records flagging...(AddToAccountProcess__c-->default value = true)
                        //territoryAccAssign.AddToAccountProcess__c = true;
                        //TM:Debmalya: Req:2089: 24th Oct, 2012: Account association deletion moved to separate batch:Update Tracker
                        territoryAccAssign.TrackAssociationToDelete__c = false;
                        updateTAMap.put(territoryAccAssign.Account_To_Territory_Id__c, territoryAccAssign);
                    }
                }
            }
            if (updateTAMap.size() > 0) {
                try{
                   System.debug('Print in createTerritoryAccAssignment>>>>'+updateTAMap);
                   Database.Upsertresult[] upsertResults= Database.upsert(updateTAMap.values(), Sales_Territory_Account_Assignment__c.Account_To_Territory_Id__c, true);
                }
                catch(Exception e) {
                    system.debug('Exception>>>'+e);
                }
            }
        }
    }
    
    /**
    * @description: creates a junction object between account & Sales Territory
    * TM:R5:Vinay -Req:6021:Handling Location rules for Location object
    **/
    public static void createTerritoryLocAssignment(Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocId){
        if(matchingRulesByLocId != null){
            Map<String,Sales_Territory_Location_Assignment__c> updateTerritoryAssignmentMap =  
                                                            new Map<String,Sales_Territory_Location_Assignment__c>();
            for(Id locId:matchingRulesByLocId.keyset()){
                List<Sales_Territory_Definition__c> ruleList = matchingRulesByLocId.get(locId);
                if(ruleList != null && ruleList.size() > 0){
                    for(Sales_Territory_Definition__c rule:ruleList){
                        Sales_Territory_Location_Assignment__c territoryLocationAssignment = 
                                                                                new Sales_Territory_Location_Assignment__c();
                        territoryLocationAssignment.Location__c = locId;
                        territoryLocationAssignment.Sales_Territory__c = rule.Sales_Territory__c;
                        territoryLocationAssignment.AssignmentType__c = Label.Territory_Engine;
                        territoryLocationAssignment.Location_To_Territory_Id__c = ''+locId+'-'+rule.Sales_Territory__c;
                        territoryLocationAssignment.TrackAssociationToDelete__c = false;
                        updateTerritoryAssignmentMap.put(territoryLocationAssignment.Location_To_Territory_Id__c,territoryLocationAssignment);
                    }
                }
            }
            if(updateTerritoryAssignmentMap.size() > 0){
                try{
                    Database.Upsertresult[] upsertResultArray = Database.upsert(updateTerritoryAssignmentMap.values(),Sales_Territory_Location_Assignment__c.Location_To_Territory_Id__c , true);
                }catch(Exception e){
                    System.debug('Exception in createTerritoryLocAssignment >>>>'+e);
                }
            }
        }
    }
    
}