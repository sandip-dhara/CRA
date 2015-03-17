/**
  * @author: rahul.kunal (Accenture)
  * HP Release 2
  * This Class drives the logic for Product Specialty Functionality
  * Date:
  */
public with sharing class ProductSpecialtyOpptyAsgnMnt {
    
    /**
      * This is the method called from trigger controlling class.
      * This drives the logic for finding out the Product Specialty for the Opportunity records
      * and then implementing the Opportunity_ProductSpecialty Assignment Logic.
      */
     
    public static List<Product_Specialty_Oppty_Assignment__c> callProdSpecailtyLogic(Map<Id,Set<Id>> oppLineItmMap)
    {
       
        //Create Set of RTM, OT and Products
        set<ID> opptyId= new set<Id>();
        Set<String> rtmSet = new Set<String>();
        Set<String> oppTSet = new Set<String>();
        Set<Id> productSet = new Set<Id>(); 
        Map<Id,String> rtmOtProdKeyMap = new Map<Id,String>();
        Map<Id,Set<ID>> oppIdPLSPLMap = new Map<Id,Set<ID>>(); 
        //TM : Nasir JAwed R5 EF2 CR-10366 .Start       
        Set<String> productNameSet = new Set<String>();
        Set<String> productId = new Set<String>();
        //TM : Nasir JAwed R5 EF2 CR-10366 .End
        
       
       
       //TM : Nasir JAwed Initially there were 2 SOQL to get which is reduced to 1 SOQL by querying into OLI and making set for RTM,OT,Product,Product Name.Start 
        for(OpportunityLineItem oppObj: [Select Opportunity.Type, Opportunity.Route_To_Market__c,ProductName__c,Product__c,OpportunityId,id from OpportunityLineItem where OpportunityId IN:oppLineItmMap.keySet() AND Opportunity.RecordType.Name!='HPFS' AND Opportunity.Isclosed=False ]){
            
            opptyId.add(oppObj.OpportunityId);
            if(oppObj.Opportunity.Route_To_Market__c != null && !('').equalsIgnoreCase(oppObj.Opportunity.Route_To_Market__c)){
                rtmSet.add(oppObj.Opportunity.Route_To_Market__c);
                
            }
            if(oppObj.Opportunity.Type != null && !('').equalsIgnoreCase(oppObj.Opportunity.Type)){
                oppTSet.add(oppObj.Opportunity.Type);
               
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
        //TM : Nasir JAwed Initially there were 2 SOQL to get which is reduced to 1 SOQL by querying into OLI and making set for RTM,OT,Product,Product Name.END
        
        //retrieving User associated to territory for account of each opportunity from OpportunityLineItem Map.
        Map<Id,Set<Id>> oppTerrUserMap = OppAccntTerrUser.callFetchAccntUserLogic(oppLineItmMap.keySet(),'Opportunity');
        Set<Id> terrUserSet = new Set<Id>();
        for(Id optId: oppTerrUserMap.keySet()){
            if(null != oppTerrUserMap.get(optId) && !oppTerrUserMap.get(optId).contains(null))
            terrUserSet.addAll(oppTerrUserMap.get(optId));
        }
        Set<String> psSet = new Set<String>();
        for(Product_Specialty_User_Assignment__c psUserObj : [Select p.User__c, p.Product_Specialty__c, p.Id From Product_Specialty_User_Assignment__c p 
                                                                     Where p.User__c in :terrUserSet AND p.Source__c!= 'Informative' AND p.To_Be_Deleted__c=False]){
            psSet.add('' + psUserObj.Product_Specialty__c);
        }
        
        Map<Id,Set<Id>> oppIdPSIdSetMap = new Map<Id,Set<Id>>();
        Set<Id> uniqueProdSpcltySet = new Set<Id>();
        
        /*
         * Start: Changes for CR-0133: Rahul Kunal
         * Date: 8/8/2012
         * Description: Adding 'All' Condition for RTM and OT
         */
         /*for(Product_Specialty_Definition__c prodSpcltyDefObj:[Select p.Route__c, p.Product__r.Sub_Product_Line__c, p.Product__r.Product_Line__c, p.Product__c, 
                                                                    p.Product_Specialty__c, p.Opportunity_Type__c, p.Id From Product_Specialty_Definition__c p 
                                                                        Where (p.Route__c In : rtmSet Or p.Route__c =: 'ALL') 
                                                                            AND  (p.Opportunity_Type__c In : oppTSet Or p.Opportunity_Type__c =: 'ALL')
                                                                                AND (p.Product__r.Sub_Product_Line__c In : subProdLineSet 
                                                                                    Or p.Product__r.Product_Line__c In : prodLineSet) ])*/
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
           
          //TM : Nasir JAwed R5 EF2 CR-10366. PL and SBP issue .Start 
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
            //TM : Nasir JAwed R5 EF2 CR-10366. PL and SBP issue .End
             /*
              * End: Changes for CR-0133
              */    
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
        
        system.debug('######Check Script Limit Used######: '+Limits.getScriptStatements());  
    
        //retrieving User associated to territory for account of each opportunity from OpportunityLineItem Map.
        //Map<Id,Set<Id>> oppTerrUserMap = OppAccntTerrUser.callFetchAccntUserLogic(oppLineItmMap.keySet(),'Opportunity');
             
        //system.debug('Check for fetched USers '+oppTerrUserMap);
        List<Product_Specialty_Oppty_Assignment__c> finalList = new List<Product_Specialty_Oppty_Assignment__c>();
        for(Product_Specialty_User_Assignment__c prodUserAsgnObj : [Select p.User__c, p.Product_Specialty__c, p.Id From Product_Specialty_User_Assignment__c p 
                                                                                                            Where p.Product_Specialty__c in :uniqueProdSpcltySet AND p.Source__c!= 'Informative' AND p.To_Be_Deleted__c=False])
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
    
     //TM Nasir Jawed: R5 CR-0712: 22/04/2013: Start
     public static List<Product_Specialty_Oppty_Assignment__c> executeSOMLogicForProdLineItem(Map<Id,Set<Id>> oppLineItmMap)
    {
       
        //Create Set of RTM, OT and Products
        set<ID> opptyId= new set<Id>();
        Set<String> rtmSet = new Set<String>();
        Set<String> oppTSet = new Set<String>();
        Set<Id> productSet = new Set<Id>(); 
        Map<Id,String> rtmOtProdKeyMap = new Map<Id,String>();
        Map<Id,Set<ID>> oppIdPLSPLMap = new Map<Id,Set<ID>>();
         //TM : Nasir JAwed R5 EF2 CR-10366 .Start 
        Set<String> productNameSet = new Set<String>();
        Set<String> productId = new Set<String>();
         //TM : Nasir JAwed R5 EF2 CR-10366 .Start
       
       
        //TM : Nasir JAwed Initially there were 2 SOQL to get which is reduced to 1 SOQL by querying into OLI and making set for RTM,OT,Product,Product Name.Start
        for(OpportunityLineItem oppObj: [Select Opportunity.Type, Opportunity.Route_To_Market__c,ProductName__c,Product__c,OpportunityId,id from OpportunityLineItem where OpportunityId IN:oppLineItmMap.keySet() AND Opportunity.RecordType.Name!='HPFS' ]){
           
            opptyId.add(oppObj.OpportunityId);
            if(oppObj.Opportunity.Route_To_Market__c != null && !('').equalsIgnoreCase(oppObj.Opportunity.Route_To_Market__c)){
                rtmSet.add(oppObj.Opportunity.Route_To_Market__c);
               
            }
            if(oppObj.Opportunity.Type != null && !('').equalsIgnoreCase(oppObj.Opportunity.Type)){
                oppTSet.add(oppObj.Opportunity.Type);
               
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
                  system.debug('testn5:'+t1);                   
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
        //TM : Nasir JAwed Initially there were 2 SOQL to get which is reduced to 1 SOQL by querying into OLI and making set for RTM,OT,Product,Product Name.End

        //retrieving User associated to territory for account of each opportunity from OpportunityLineItem Map.
        Map<Id,Set<Id>> oppTerrUserMap = OppAccntTerrUser.callFetchAccntUserLogic(oppLineItmMap.keySet(),'Opportunity');
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
          
          
         //TM : Nasir JAwed R5 EF2 CR-10366. PL and SBP issue .Start
          for(Product_Specialty_Definition__c prodSpcltyDefObj : Database.query(specialtyQuery)){ 
                                                                                            
            for(Id oppIdObj : rtmOtProdKeyMap.keySet()){
                system.debug('testn7n:'+oppIdObj);
                if((rtmOtProdKeyMap.get(oppIdObj).equalsIgnoreCase(prodSpcltyDefObj.Route__c+prodSpcltyDefObj.Opportunity_Type__c+prodSpcltyDefObj.Product__r.Name) 
                    || (prodSpcltyDefObj.Route__c != null && prodSpcltyDefObj.Route__c.equalsIgnoreCase('ALL')) 
                        || (prodSpcltyDefObj.Opportunity_Type__c != null && prodSpcltyDefObj.Opportunity_Type__c.equalsIgnoreCase('ALL'))) 
                            && oppIdPLSPLMap.get(oppIdObj) != null //&& (oppLineItmMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__c)
                                //|| oppIdPLSPLMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Sub_Product_Line__c) 
                                   // || oppIdPLSPLMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Product_Line__c)
                                   // )
                                    ){
          //TM : Nasir JAwed R5 EF2 CR-10366 PL and SBP issue  .Start      
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
        
        system.debug('######Check Script Limit Used######: '+Limits.getScriptStatements());  
    
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
    // TM Nasir Jawed: R5 CR-0712: End
    /*
     * @Description: This method retrives the records of Prdocut Specialty Opportunity Assignment
     *  used for Deleting records generally or checking whether the specic record is present or not.
     *
     */
    public static List<Product_Specialty_Oppty_Assignment__c> fetchRecordsFromPSD(Set<Id> oppIdSet){
        
        List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOppAsgmntRecord = 
                                                [Select p.Opportunity__c, p.Id,p.Product_Specialty_User_Assignment__c From Product_Specialty_Oppty_Assignment__c p Where p.Opportunity__c In : oppIdSet];
        
        
        return prodSpcltyOppAsgmntRecord;
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