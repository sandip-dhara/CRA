// TM :Nasir Jawed. 7-31-2013 This class returns the list to previous class and created SOM. Start
public class OpportunityShareAndSomCreation{

    public static List<Product_Specialty_Oppty_Assignment__c> OpptyShareUser(Map<Id,Set<Id>> oppLineItmMap){
        
        set<ID> opptyId= new set<Id>();
        Set<String> rtmSet = new Set<String>();
        Set<String> oppTSet = new Set<String>();
        Map<Id,String> rtmOtProdKeyMap = new Map<Id,String>();
        Map<Id,Set<ID>> oppIdPLSPLMap = new Map<Id,Set<ID>>();       
        Set<String> productNameSet = new Set<String>();
        Set<String> productId = new Set<String>();       
       
        // Querying the Opportunity line item object to get the RTM,OT,Product Name and Product ID and making set.
        for(OpportunityLineItem oppObj: [Select Opportunity.Type, Opportunity.Route_To_Market__c,ProductName__c,Product__c,OpportunityId,id from OpportunityLineItem where OpportunityId IN:oppLineItmMap.keySet() ]){
           
            opptyId.add(oppObj.OpportunityId);
            if(oppObj.Opportunity.Route_To_Market__c != null && !('').equalsIgnoreCase(oppObj.Opportunity.Route_To_Market__c)){
                rtmSet.add(oppObj.Opportunity.Route_To_Market__c);
                
            }
            if(oppObj.Opportunity.Type != null && !('').equalsIgnoreCase(oppObj.Opportunity.Type)){
                oppTSet.add(oppObj.Opportunity.Type);
                system.debug('testn2:'+oppTSet);
            }   
            if(oppObj.ProductName__c != null && !('').equalsIgnoreCase(oppObj.ProductName__c)){
                productNameSet.add(oppObj.ProductName__c);
               
            }   
            if(oppObj.Product__c != null && !('').equalsIgnoreCase(oppObj.Product__c)){
                productId.add(oppObj.Product__c);
               
            }
            for(Id oppId : oppLineItmMap.KeySet()){
               if(oppLineItmMap.get(oppId).contains(oppObj.Product__c)){
                  Set<ID> t1 = oppIdPLSPLMap.get(oppId);
                                    
                  if(t1 == null){
                        t1= new Set<ID>();
                  }                    
                  t1.add(oppObj.Product__c); 
                 
                  if(!t1.isEmpty())
                  oppIdPLSPLMap.put(oppId, t1);
                    
               }
            }
            rtmOtProdKeyMap.put(oppObj.OpportunityId, ('' + oppObj.Opportunity.Route_To_Market__c+oppObj.Opportunity.Type+oppObj.ProductName__c));
            
        }
       
        // Getting the user form the opportunity share by using a method "retrieveOppUser" which returns a map of opportunity and user set.
        Map<Id,Set<Id>> groupMemUserMap=retrieveOppUser(opptyId);
        Set<Id> terrUserSet = new Set<Id>();
        for(Id optId: groupMemUserMap.keySet()){
            if(null != groupMemUserMap.get(optId) && !groupMemUserMap.get(optId).contains(null))
            terrUserSet.addAll(groupMemUserMap.get(optId));
            
        }
       
        
        Set<String> psSet = new Set<String>();
        for(Product_Specialty_User_Assignment__c psUserObj : [Select p.User__c, p.Product_Specialty__c, p.Id From Product_Specialty_User_Assignment__c p 
                                                                     Where p.User__c in :terrUserSet AND p.Source__c!= 'Informative' AND p.To_Be_Deleted__c=False]){
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
                 
                if((rtmOtProdKeyMap.get(oppIdObj).equalsIgnoreCase(prodSpcltyDefObj.Route__c+prodSpcltyDefObj.Opportunity_Type__c+prodSpcltyDefObj.Product__r.Name) 
                    || (prodSpcltyDefObj.Route__c != null && prodSpcltyDefObj.Route__c.equalsIgnoreCase('ALL')) 
                        || (prodSpcltyDefObj.Opportunity_Type__c != null && prodSpcltyDefObj.Opportunity_Type__c.equalsIgnoreCase('ALL'))) 
                            && oppIdPLSPLMap.get(oppIdObj) != null //&& (oppLineItmMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__c)
                                //|| oppIdPLSPLMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Sub_Product_Line__c) 
                                   // || oppIdPLSPLMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Product_Line__c)
                                    //)
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
        List<Product_Specialty_Oppty_Assignment__c> finalList = new List<Product_Specialty_Oppty_Assignment__c>();
        for(Product_Specialty_User_Assignment__c prodUserAsgnObj : [Select p.User__c, p.Product_Specialty__c, p.Id From Product_Specialty_User_Assignment__c p 
                                                                                                            Where p.Product_Specialty__c in :uniqueProdSpcltySet AND p.Source__c!= 'Informative' AND p.To_Be_Deleted__c=False ])
        //AND User__c IN: terrUserSet
        {
           
            for(Id oppId : oppIdPSIdSetMap.keySet()){
               
                if(oppIdPSIdSetMap.get(oppId).contains(prodUserAsgnObj.Product_Specialty__c)){
                    //Now Check whether the fetched user is there or not in Opp-TerrUsermap
                   
                    if(null != groupMemUserMap.get(oppId) && groupMemUserMap.get(oppId).contains(prodUserAsgnObj.User__c)){
                        
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
   
    
    public static Map<Id,Set<Id>> retrieveOppUser(Set<Id> oppSet){
        set<id> groupId= new set<Id>();
        Map<Id,List<Id>> oppShareGrpMap = new Map<Id,List<Id>>();
        
        
        for(OpportunityShare os:[select OpportunityId,UserOrGroupId,RowCause from OpportunityShare where OpportunityId IN:oppSet AND (RowCause='Manual' OR RowCause='ImplicitChild') ]){
            List<Id> grpList = oppShareGrpMap.get(os.OpportunityId);
            if(null==grpList){
                grpList = new List<Id>();
            }
            grpList.add(os.UserOrGroupId);
            oppShareGrpMap.put(os.OpportunityId,grpList);            
        } 
        
        Set<Id> uniqueGrpSet = new Set<Id>();
        for(Id oppId : oppShareGrpMap.keySet()){
            uniqueGrpSet.addAll(oppShareGrpMap.get(oppId));
        }
        Map<Id,List<Id>> grpUserMap = new Map<Id,List<Id>>();  
        for(GroupMember grpMemObj:[Select g.UserOrGroupId, g.GroupId From GroupMember g Where g.GroupId In : uniqueGrpSet]){
           
            List<Id> userList = grpUserMap.get(grpMemObj.GroupId);
            if(null == userList){
                userList = new List<Id>();
            }
            userList.add(grpMemObj.UserOrGroupId);
            grpUserMap.put(grpMemObj.GroupId,userList);
        }
        Map<Id,Set<Id>> finalOppUserMap = new Map<Id,Set<Id>>();
        //Iterate on opportunity Id to find out the opportunity to UserList Map
        for(Id idObj : oppShareGrpMap.keySet())
        {
            
            Set<Id> userSet = new Set<Id>();
            List<Id> grpIdList = oppShareGrpMap.get(idObj);
            //system.debug('grpIdList  '+grpIdList);
            for(Id grpId:grpIdList){
                //system.debug('grpUserMap.get(grpId) '+grpUserMap.get(grpId));
                if(grpUserMap.get(grpId) != null){
                    userSet.addAll(grpUserMap.get(grpId));
                }                
            }
            //Save Final Account USer Map   
            finalOppUserMap.put(idObj,userSet);
            system.debug('nasir done na:'+ finalOppUserMap);
        }            
    return finalOppUserMap;
    }
    
    
    
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

// TM :Nasir Jawed 7-31-2013: End