/**********************************************************
* Class Name: CheckUserAccountTerritory
* Author: HP
* Date: 11-September-2012 
* Requirement # Request Id:
* Description: Controller class to check if account falls under territory of User while creating new Opportunities. 
*              Used in Related List in Account,Opportunity Page.
***********************************************************/

global class CheckUserAccountTerritory{

   Webservice static String userAccountTerritoryMatch(String AccountId, String UserId){
       String matchNotFound = 'true';
       Set<Id> setSalesTerforAccIds = new Set<Id>();
       List<Sales_Territory_Account_Assignment__c> salesTerrforAccIds = New List<Sales_Territory_Account_Assignment__c>([select Id,Sales_Territory__c from Sales_Territory_Account_Assignment__c where Account__c =: AccountId]);
       If(salesTerrforAccIds != null){
           for(Sales_Territory_Account_Assignment__c stAObj:salesTerrforAccIds){
               setSalesTerforAccIds.add(stAObj.Sales_Territory__c);
           }
           if(setSalesTerforAccIds != null){
               List<Sales_Territory_User_Assignment__c> salesTerrforUserIds = New List<Sales_Territory_User_Assignment__c>([select Id,Sales_Territory__c from Sales_Territory_User_Assignment__c where User__c =: UserId and Sales_Territory__c IN: setSalesTerforAccIds]);
               If(salesTerrforUserIds != null && salesTerrforUserIds.size()>0){
                   matchNotFound = 'false';
               }
           }
       }
       return matchNotFound;
   }
   
   public static Map<Id,Set<Id>> accSalesTerrMatches(Set<Id> accIds){
       Map<Id,Set<Id>> accStMap = new Map<Id,Set<Id>>();
       List<Sales_Territory_Account_Assignment__c> salesTerrforAccIds = New List<Sales_Territory_Account_Assignment__c>([select Id,Sales_Territory__c,Account__c from Sales_Territory_Account_Assignment__c where Account__c In: accIds]);
       
       If(salesTerrforAccIds.size() > 0){
           for(Sales_Territory_Account_Assignment__c stAcc: salesTerrforAccIds){
               Set<Id> stAccList = accStMap.get(stAcc.Account__c);
               if(stAccList == null){
                   stAccList = new Set<Id>();
               }
               stAccList.add(stAcc.Sales_Territory__c);
               accStMap.put(stAcc.Account__c,stAccList);
           }
       }
       return accStMap;
   }
   
   public static Map<Id,Set<Id>> userSalesTerrMatches(Set<Id> userIds,Set<Id> stIds){
       Map<Id,Set<Id>> userStMap = new Map<Id,Set<Id>>();
       List<Sales_Territory_User_Assignment__c> salesTerrforUserIds = New List<Sales_Territory_User_Assignment__c>([select Id,Sales_Territory__c,User__c from Sales_Territory_User_Assignment__c where User__c In: userIds and Sales_Territory__c IN: stIds]);
       
       If(salesTerrforUserIds.size() > 0){
           for(Sales_Territory_User_Assignment__c stUser: salesTerrforUserIds){
               Set<Id> stUserList = userStMap.get(stUser.User__c);
               if(stUserList == null){
                   stUserList = new Set<Id>();
               }
               stUserList.add(stUser.Sales_Territory__c);
               userStMap.put(stUser.User__c,stUserList);
           }
       }
       return userStMap;
   }
}