/**********************************************************
* Class Name: SOMCreationController 
* Author: Raghvendra Jha
* Date: 19-JUL-20123
* Requirement # Req Id:10320 
* Description: This class performs processing of SOM assignment against opportunity.
***********************************************************/
public with sharing class SOMCreationController {
     public static void executeSomLogic(Map<Id,Set<Id>> oppLineProdSetMap){
        
        //inserting or updating SOM in related Opportunity.
        List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOptyAsgnList = executeSOMLogicForProdLineItem(oppLineProdSetMap);
        
       if(prodSpcltyOptyAsgnList != null && prodSpcltyOptyAsgnList.size()>0 ){
            try{
                //Then insert the new values.
                upsert prodSpcltyOptyAsgnList Product_Specialty_Oppty_Assignment__c.OpptyUserPSKey__c;
            }catch(Exception e){
                system.debug('**Exception in convertTo15DigitList ****' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
            }
        }
    }

     //retrieving Product Specialty for each Opportunity from OpportunityLineItem.    
    public static List<Product_Specialty_Oppty_Assignment__c> executeSOMLogicForProdLineItem(Map<Id,Set<Id>> oppLineItmMap)
    {
        //Create Set of RTM, OT and Products
        Set<String> rtmSet = new Set<String>();
        Set<String> oppTSet = new Set<String>();
        Set<Id> productSet = new Set<Id>(); 
       // Map<Id,String> rtmOtProdKeyMap = new Map<Id,String>();
        Map<Id,Set<String>> rtmOtProdKeyMap= new Map<Id,Set<String>>();
        //defect:14857:start
        set<ID> opptyId= new set<Id>();
        Map<Id,Set<ID>> oppIdPLSPLMap = new Map<Id,Set<ID>>();
        Set<String> productNameSet = new Set<String>();
        Set<String> productId = new Set<String>();
        Map<Id,Set<String>> oppIdProdNameMap = new Map<Id,Set<String>>();
        //defect:14857:End
        
        for(OpportunityLineItem oppObj: [Select Opportunity.Type, Opportunity.Route_To_Market__c,ProductName__c,Product__c,OpportunityId,id from OpportunityLineItem where OpportunityId IN:oppLineItmMap.keySet() AND Opportunity.RecordType.Name!='HPFS' AND Opportunity.Isclosed=False]){
           
            opptyId.add(oppObj.OpportunityId);
            if(oppObj.Opportunity.Route_To_Market__c != null && !('').equalsIgnoreCase(oppObj.Opportunity.Route_To_Market__c)){
                rtmSet.add(oppObj.Opportunity.Route_To_Market__c);
               
            }
            if(oppObj.Opportunity.Type != null && !('').equalsIgnoreCase(oppObj.Opportunity.Type)){
                oppTSet.add(oppObj.Opportunity.Type);
               
            }   
            if(oppObj.ProductName__c != null && !('').equalsIgnoreCase(oppObj.ProductName__c)){
                Set<string> tempProductNameSet= oppIdProdNameMap.get(oppObj.OpportunityId);
                if(null == tempProductNameSet){
                    tempProductNameSet = new Set<string>(); 
                } 
                tempProductNameSet.add(oppObj.ProductName__c);
                oppIdProdNameMap.put(oppObj.OpportunityId,tempProductNameSet);
                productNameSet.add(oppObj.ProductName__c);
                
            }   
            if(oppObj.Product__c != null && !('').equalsIgnoreCase(oppObj.Product__c)){
                productId.add(oppObj.Product__c);
               
            }
            Set<id> productIdSet = oppIdPLSPLMap.get(oppObj.OpportunityId);
            if(null == productIdSet){
                productIdSet = new Set<Id>(); 
            } 
            productIdSet.add(oppObj.Product__c);
            oppIdPLSPLMap.put(oppObj.OpportunityId,productIdSet);
            Set<string> spcltyDefSet = rtmOtProdKeyMap.get(oppObj.OpportunityId);
            if(null == spcltyDefSet){
                spcltyDefSet = new Set<string>(); 
            } 
            spcltyDefSet.add(('' + oppObj.Opportunity.Route_To_Market__c+oppObj.Opportunity.Type+oppObj.ProductName__c).toLowerCase());
            rtmOtProdKeyMap.put(oppObj.OpportunityId,spcltyDefSet);
            //rtmOtProdKeyMap.put(oppObj.OpportunityId, ('' + oppObj.Opportunity.Route_To_Market__c+oppObj.Opportunity.Type+oppObj.ProductName__c));
            
        }
        
        //retrieving User associated to territory for account of each opportunity from OpportunityLineItem Map.
        Map<Id,Set<Id>> oppTerrUserMap = callFetchAccntUserLogic(oppLineItmMap.keySet(),'Opportunity');
        Set<Id> terrUserSet = new Set<Id>();
        for(Id optId: oppTerrUserMap.keySet()){
            if(null != oppTerrUserMap.get(optId) && !oppTerrUserMap.get(optId).contains(null))
            terrUserSet.addAll(oppTerrUserMap.get(optId)); 
        }
        Set<String> psSet = new Set<String>();
        for(Product_Specialty_User_Assignment__c psUserObj : [Select p.User__c,p.To_Be_Deleted__c, p.Product_Specialty__c, p.Id From Product_Specialty_User_Assignment__c p 
                                                                     Where p.User__c in :terrUserSet AND p.Product_Specialty__r.New_Specialty_search__c= true
                                                                                                     AND P.New_User_Insert_Sales_Territory__c=True
                                                                                                     AND p.To_Be_Deleted__c=False AND p.Source__c!= 'Informative']){
                                                                     
            psSet.add('' + psUserObj.Product_Specialty__c);
            
        }
        
        Map<Id,Set<Id>> oppIdPSIdSetMap = new Map<Id,Set<Id>>();
        Set<Id> uniqueProdSpcltySet = new Set<Id>();
        
        
         String limitVal = '';
          if(Test.isRunningTest()){
                limitVal = limitVal+' Limit 10';
          }
        String specialtyQuery = 'Select p.Route__c, p.Product__r.Sub_Product_Line__c, p.Product__r.Product_Line__c, p.Product__c,p.Product__r.Name, ' 
                                    +'p.Product_Specialty__c, p.Opportunity_Type__c, p.Id From Product_Specialty_Definition__c p '
                                    +'Where (p.Product__r.Sub_Product_Line__c != NULL OR p.Product__r.Product_Line__c != NULL) AND ' 
                                    +'(p.Route__c In '+ getCommaSeperatedStringList(rtmSet) +' Or p.Route__c = \''+ 'ALL' +'\' '
                                    +') AND (p.Opportunity_Type__c In '+ getCommaSeperatedStringList(oppTSet) +' Or p.Opportunity_Type__c =\''+ 'ALL' +'\' '
                                    +') AND ((p.Product__c In '+ getCommaSeperatedStringList(productId) +' OR p.Product__r.Name IN '+ getCommaSeperatedStringList(productNameSet) +') AND p.Product_Specialty__c In '+ getCommaSeperatedStringList(psSet) +') '
                                    +limitVal;
          
          
          for(Product_Specialty_Definition__c prodSpcltyDefObj : Database.query(specialtyQuery)){                                                                                          
            for(Id oppIdObj : rtmOtProdKeyMap.keySet()){
                
                if((rtmOtProdKeyMap.get(oppIdObj).contains((prodSpcltyDefObj.Route__c+prodSpcltyDefObj.Opportunity_Type__c+prodSpcltyDefObj.Product__r.Name).toLowerCase()) 
                    || (prodSpcltyDefObj.Route__c != null && prodSpcltyDefObj.Route__c.equalsIgnoreCase('ALL')) 
                        || (prodSpcltyDefObj.Opportunity_Type__c != null && prodSpcltyDefObj.Opportunity_Type__c.equalsIgnoreCase('ALL'))) 
                            && oppIdPLSPLMap.get(oppIdObj) != null && oppIdProdNameMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Name)
                              //|| (oppLineItmMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__c)
                                //|| oppIdPLSPLMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Sub_Product_Line__c) 
                                    //|| oppIdPLSPLMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Product_Line__c))
                                    ){
                        Set<Id> prodSpcltySet = oppIdPSIdSetMap.get(oppIdObj);
                        if(prodSpcltySet == null){
                            prodSpcltySet = new Set<Id>();
                        }
                        prodSpcltySet.add(prodSpcltyDefObj.Product_Specialty__c);
                        oppIdPSIdSetMap.put(oppIdObj,prodSpcltySet);
                        uniqueProdSpcltySet.addAll(prodSpcltySet);
                       
                }
            }
        }  
         
    
        //retrieving User associated to territory for account of each opportunity from OpportunityLineItem Map.
       
        List<Product_Specialty_Oppty_Assignment__c> finalList = new List<Product_Specialty_Oppty_Assignment__c>();
        for(Product_Specialty_User_Assignment__c prodUserAsgnObj : [Select p.User__c,p.To_Be_Deleted__c, p.Product_Specialty__c, p.Id From Product_Specialty_User_Assignment__c p 
                                                                                                            Where p.Product_Specialty__c in :uniqueProdSpcltySet
                                                                                                             AND P.Product_Specialty__r.New_Specialty_search__c= true
                                                                                                              AND P.New_User_Insert_Sales_Territory__c=True
                                                                                                               AND p.To_Be_Deleted__c=False AND p.Source__c!= 'Informative'])
        {
            for(Id oppId : oppIdPSIdSetMap.keySet()){
                if(oppIdPSIdSetMap.get(oppId).contains(prodUserAsgnObj.Product_Specialty__c)){
                    //Now Check whether the fetched user is there or not in Opp-TerrUsermap
                    if(null != oppTerrUserMap.get(oppId) && oppTerrUserMap.get(oppId).contains(prodUserAsgnObj.User__c)){
                        
                        String key = ''+oppId+''+prodUserAsgnObj.Id+''+prodUserAsgnObj.User__c;
                        
                        Product_Specialty_Oppty_Assignment__c prodSpcltyOppAssnmntObj = 
                                                            new Product_Specialty_Oppty_Assignment__c(Product_Specialty_User_Assignment__c = prodUserAsgnObj.Id,
                                                                                                       Opportunity__c = oppId, OwnerId = prodUserAsgnObj.User__c, OpptyUserPSKey__c = key);
                                                                                                    
                        finalList.add(prodSpcltyOppAssnmntObj);                                                                                            
                    }
                }
            }
        }
        return finalList;
    }
    public static Map<Id,Set<Id>> callFetchAccntUserLogic(Set<Id> idSet, String objectType){
         
        Map<Id,List<Id>> oppGrpMap = retrieveGrpforOppty(idSet);
        
        //Find out all the Users Related to the Territory for the Account for the Opportunity and Return it
        return retrieveUserForGrp(oppGrpMap);  
         
    }
     /*
      * Method for retrieving Group Ids as per the Account Ids
      * return type Map<Id,List<Id>>
      * Param: Set<Id>
      */
    private static Map<Id,List<Id>> retrieveGrpforOppty(Set<Id> oppSet){
        
        //TM:Raghvendra:ALM 10320 :Start
        //For the opty Ids found, find out the group Id associated hitting OpportunityShare object as it will have the mapping of account id and GroupId. 
        Map<Id,List<id>> oppShareGrpMap = new Map<Id,List<Id>>();
        if((oppSet != null) && (oppSet.size() >0)){
            for(OpportunityShare prtnrOppShare:[Select UserOrGroupId, OpportunityId From OpportunityShare where Opportunityid in : oppSet And RowCause ='Manual']){
            List<Id> grpList = oppShareGrpMap.get(prtnrOppShare.OpportunityId );
            if(null==grpList){
                grpList = new List<Id>();
            }
            grpList.add(prtnrOppShare.UserOrGroupId);
            oppShareGrpMap.put(prtnrOppShare.OpportunityId,grpList);
            }
        }
        //TM:Raghvendra:ALM 10320 :End 
        return oppShareGrpMap;
    }
    /*
      * Method for retrieving Users as per the Group Ids.
      * return type Map<Id,Set<Id>>.
      * Param: Map<Id,List<Id>>.
      */
    private static Map<Id,Set<Id>> retrieveUserForGrp(Map<Id,List<Id>> grpOppMap){
        
        Set<Id> uniqueGrpSet = new Set<Id>();
        for(Id oppId : grpOppMap.keySet()){
            uniqueGrpSet.addAll(grpOppMap.get(oppId ));
        }
        Map<Id,List<Id>> grpUserMap = new Map<Id,List<Id>>();
        //Find out the List of User for each group.
        for(GroupMember grpMemObj:[Select g.UserOrGroupId, g.GroupId From GroupMember g Where g.GroupId In : uniqueGrpSet]){
            List<Id> userList = grpUserMap.get(grpMemObj.GroupId);
            if(null == userList){
                userList = new List<Id>();
            }
            userList.add(grpMemObj.UserOrGroupId);
            grpUserMap.put(grpMemObj.GroupId,userList);
        }
        
        Map<Id,Set<Id>> finalOppUserMap = new Map<Id,Set<Id>>();
        //Iterate on Account Id to find out the Account to UserList Map
        for(Id idObj : grpOppMap.keySet())
        {
            Set<Id> userSet = new Set<Id>();
            List<Id> grpIdList = grpOppMap.get(idObj);
            for(Id grpId:grpIdList){
                if(grpUserMap.get(grpId) != null){
                    userSet.addAll(grpUserMap.get(grpId));
                }
                
            }
            //Save Final Account USer Map   
            finalOppUserMap.put(idObj,userSet);
        }
        //Return the Saved Map
        return finalOppUserMap;
    }
    /*
      * @description: Generates comma separated string list enclosed in 
      *  circular brackets to be used in dynamic query string. 
      * @return: String
      */
    public static String getCommaSeperatedStringList(Set<String> stringSet) {
        String commaSeperatedString = '';
        if(stringSet != null) {
            commaSeperatedString += '(';
            Boolean isFirstValue = true;
            for (String value : stringSet) {
                
                if(isFirstValue) {
                    if(value != null){
                        commaSeperatedString += '\'' + String.escapeSingleQuotes(value) + '\'';
                        isFirstValue = false;
                    }
                } else {
                    if(value != null){
                        commaSeperatedString += ', \'' + String.escapeSingleQuotes(value) + '\'';
                    }
                }   
            }
            commaSeperatedString += ')';
        }
        if(commaSeperatedString.equalsIgnoreCase('()')){
            commaSeperatedString = '(\'\')';
        }
        return commaSeperatedString;
    }
        
}