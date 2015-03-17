/**
* Class Name: PartnerCollabACPUtil
* Author: Accenture
* Date: 18-JULY-2012 
* Description: Contains helper methods for "Alliance and Channel Partners" object trigger
*/
/*public with sharing class PartnerCollabACPUtil {*/
    /*Commented out above with sharing line by Ember on 10.25 for Defect #3670*/
    public class PartnerCollabACPUtil {
    public static Set<Id> grpIds = new Set<Id>();
    
    private static boolean exeFromBatchFlag = false;
    
    public static boolean getExeFromBatchFlag(){
        return exeFromBatchFlag;
    }
    
    public static void setExeFromBatchFlag(){
        exeFromBatchFlag = true;
    }
    
    /**
    * @description: This method is called from trigger on Alliance & Channel partner records on after-insert event.
    *               Insert OpportunityShare record for corresponding parnter account territory group
    * @param: new Alliance & Channel partner records
    * 
    */
    public static void addOpptyShareToPartners(Map<id,Channel_Partner__c> acpNewMap){
    
        //Map<Id,List<String>> opptyWithTerritoryGroups = new Map<id,List<String>>();
        Map<Id,Set<String>> opptyWithTerritoryGroups = new Map<id,Set<String>>();
        List<OpportunityShare> newOpptySharing = new List<OpportunityShare>();
        opptyWithTerritoryGroups = getOpptyShareForPartners(acpNewMap);
        system.debug('nasirjawed18:'+ opptyWithTerritoryGroups);
        if(opptyWithTerritoryGroups == null || opptyWithTerritoryGroups.isEmpty()){ 
            return;
        }
        
        //Avoid oppty share when running ACP batch:Start
        if(exeFromBatchFlag == false){
        //TM:Vinay R6:Req 7525:Start
        Set<Opportunity> pvtOpptySet = new Set<Opportunity>([Select Id From Opportunity where (Confidential__c = true Or Account.Confidential_Account__c = true) And Id In :opptyWithTerritoryGroups.keySet()]);
            
        if(pvtOpptySet != null && pvtOpptySet.size() > 0){
            for(Opportunity pvtOpty:pvtOpptySet){
                if(opptyWithTerritoryGroups.containsKey(pvtOpty.Id)){
                    opptyWithTerritoryGroups.remove(pvtOpty.Id);
                }
            }
        }
        
        if(opptyWithTerritoryGroups == null || opptyWithTerritoryGroups.isEmpty()){ 
            return;
        }
        
        //TM:Vinay R6:Req 7525:End
        for(Id opptyId : opptyWithTerritoryGroups.keySet()){
            for(Id groupId : opptyWithTerritoryGroups.get(opptyId)){
                OpportunityShare newShareRec = new OpportunityShare(OpportunityAccessLevel = 'Read');
                newShareRec.OpportunityId = opptyId;
                newShareRec.UserOrGroupId = groupId;
                newOpptySharing.add(newShareRec);
            }
        }       
        
        if(newOpptySharing != null && newOpptySharing.size() >0 ){
            Database.SaveResult[] newShareResults;
            try{
                 system.debug('nasirjawed19:'+ newOpptySharing);
                newShareResults = database.insert(newOpptySharing,false);  
            }catch (Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, newShareResults, 'Channel_Partner__c', 'PartnerCollabACPUtil', 'Class');
            }
        }
      } 
      //Avoid oppty share when running ACP batch:End
         //TM:Nasir R4:Req:3908:Start
        
        set<id> stUserId= new set<id>();       
        set<id> psSet= new set<id>();
        set<id> specialtyUserId= new set<id>();
        set<id> prodSpecialtyUserId= new set<id>();
        Map<Id,Set<Id>> groupUsermap = new MAP<Id,Set<Id>>();
        Map<Id,Set<Id>> oppTerrUsermap = new MAP<Id,Set<Id>>();
        Set<Id> prodSpcltySet = new Set<Id>();
        Map<Id,Set<Id>> prodSpcltyUserIdProdSpcltyIdMap = new Map<Id,Set<Id>>();
        Map<Id,Id> productSpcltyUserIdMap = new Map<Id,Id>();
        Map<Id,Set<Id>> prodSpcltyOppMap = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> oppLineItmMap= new Map<Id,Set<Id>>();
        
         
        oppTerrUsermap = getOpptyUsersforGroups(opptyWithTerritoryGroups);
        system.debug('nasirjawed20:'+ oppTerrUsermap);
        
        for(Id opp : oppTerrUsermap.keySet()){
            stUserId.addAll(oppTerrUsermap.get(opp));
            system.debug('nasirjawedtest:'+ stUserId);
        }
        //TM: Nasir R4 EF:Req:6639 start 
        
        Set<String> rtmSet = new Set<String>();
        Set<String> oppTSet = new Set<String>();
        Set<Id> productSet = new Set<Id>(); 
        //Map<Id,String> rtmOtProdKeyMap = new Map<Id,String>();
        Map<Id,Set<String>> rtmOtProdKeyMap= new Map<Id,Set<String>>();
        //defect:14857:start
        set<ID> opptyId= new set<Id>();
        Map<Id,Set<ID>> oppIdPLSPLMap = new Map<Id,Set<ID>>();
        Set<String> productNameSet = new Set<String>();
        Set<String> productId = new Set<String>();
        Map<Id,Set<String>> oppIdProdNameMap = new Map<Id,Set<String>>();
        //defect:14857:End
        System.debug('Raghv test opty   '+oppLineItmMap.keySet());
        for(OpportunityLineItem oppObj: [Select Opportunity.Type, Opportunity.Route_To_Market__c,ProductName__c,Product__c,OpportunityId,id from OpportunityLineItem where OpportunityId IN :oppTerrUsermap.keySet() AND Opportunity.RecordType.Name!='HPFS' AND Opportunity.Isclosed=False]){
           
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
        
        for(Product_Specialty_User_Assignment__c psua:[select id,User__c,Product_Specialty__c from Product_Specialty_User_Assignment__c where User__c=:stUserId AND To_Be_Deleted__c=False AND Source__c!= 'Informative']){
            psSet.add(psua.Product_Specialty__c);
            system.debug('req6:'+psua);
            system.debug('req7:'+psSet);
            Set<Id> psuSet = prodSpcltyUserIdProdSpcltyIdMap.get(psua.Product_Specialty__c);
            if(psuSet == null){
                psuSet = new Set<Id>();
            }
            psuSet.add(psua.Id);
            prodSpcltyUserIdProdSpcltyIdMap.put(psua.Product_Specialty__c,psuSet);
            productSpcltyUserIdMap.put(psua.Id,psua.User__c);
           
        }
        
        Map<Id,Set<Id>> oppIdPSIdSetMap = new Map<Id,Set<Id>>();
        Set<Id> uniqueProdSpcltySet = new Set<Id>();
        for(Product_Specialty_Definition__c prodSpcltyDefObj : [Select p.Route__c, p.Product__r.Sub_Product_Line__c, p.Product__r.Product_Line__c, p.Product__c,p.Product__r.Name, 
                                                                p.Product_Specialty__c, p.Opportunity_Type__c, p.Id From Product_Specialty_Definition__c p Where
                                                                (p.Product__r.Sub_Product_Line__c != NULL OR p.Product__r.Product_Line__c != NULL) AND
                                                                (p.Route__c In :rtmSet  Or p.Route__c ='ALL') AND 
                                                                (p.Opportunity_Type__c In :oppTSet  Or p.Opportunity_Type__c = 'ALL') AND
                                                                //(p.Product__r.Sub_Product_Line__c In :subProdLineSet Or p.Product__r.Product_Line__c In :prodLineSet) AND
                                                                (p.Product__c In :productId OR p.Product__r.Name IN :productNameSet) AND
                                                                 p.Product_Specialty__c In :psSet]){
       system.debug('req8:'+prodSpcltyDefObj);
       for(Id oppIdObj : rtmOtProdKeyMap.keySet()){
                
                if((rtmOtProdKeyMap.get(oppIdObj).contains((prodSpcltyDefObj.Route__c+prodSpcltyDefObj.Opportunity_Type__c+prodSpcltyDefObj.Product__r.Name).toLowerCase()) 
                    || (prodSpcltyDefObj.Route__c != null && prodSpcltyDefObj.Route__c.equalsIgnoreCase('ALL')) 
                        || (prodSpcltyDefObj.Opportunity_Type__c != null && prodSpcltyDefObj.Opportunity_Type__c.equalsIgnoreCase('ALL'))) 
                            && oppIdPLSPLMap.get(oppIdObj) != null && oppIdProdNameMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Name) //|| (oppLineItmMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__c)
                                //|| oppIdPLSPLMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Sub_Product_Line__c) 
                                    //|| oppIdPLSPLMap.get(oppIdObj).contains(prodSpcltyDefObj.Product__r.Product_Line__c))
                                    ){
               
                        Set<Id> prodSpcltySet1 = oppIdPSIdSetMap.get(oppIdObj);
                        if(prodSpcltySet1 == null){
                            prodSpcltySet1 = new Set<Id>();
                        }
                        prodSpcltySet1.add(prodSpcltyDefObj.Product_Specialty__c);
                        system.debug('req9:'+prodSpcltySet1);
                        oppIdPSIdSetMap.put(oppIdObj,prodSpcltySet1);
                        system.debug('req10:'+oppIdPSIdSetMap);
                        uniqueProdSpcltySet.addAll(prodSpcltySet1);
                        system.debug('req11:'+uniqueProdSpcltySet);
                }
            }
            
         List<Product_Specialty_Oppty_Assignment__c> finalList = new List<Product_Specialty_Oppty_Assignment__c>();
         for(Product_Specialty_User_Assignment__c prodUserAsgnObj : [Select p.User__c, p.Product_Specialty__c, p.Id From Product_Specialty_User_Assignment__c p 
                                                                                                            Where p.Product_Specialty__c in :uniqueProdSpcltySet AND To_Be_Deleted__c=False AND Source__c!= 'Informative'])
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
                        system.debug('req12:'+finalList);                                                                                             
                    }
                }
            }
        }
       if(finalList != null && finalList.size()>0 ){
            try{
                upsert finalList Product_Specialty_Oppty_Assignment__c.OpptyUserPSKey__c;
            }catch(Exception excp){
                system.debug('Exception Found In Inserting Records for Opportunity Product Specialty Assgnment '+excp.getMessage());
            }
        }
       
       
        //TM: Nasir R4 EF:Req:6639 End
                                     }   
        /*
        Set<Id> uniqueOppSet = new Set<Id>();
        system.debug('debcheck1:'+oppTerrUsermap);
        system.debug('debcheck2:'+productSpcltyUserIdMap);
        //Stop Duplication of Specialty Opp Matches
        for(Product_Specialty_Oppty_Assignment__c prodspl : [Select Id, Product_Specialty_User_Assignment__c, Opportunity__c from Product_Specialty_Oppty_Assignment__c where Opportunity__c IN: oppTerrUsermap.keySet() AND Product_Specialty_User_Assignment__c IN: productSpcltyUserIdMap.keySet()]){
            if(oppTerrUsermap.get(prodspl.Opportunity__c).contains(productSpcltyUserIdMap.get(prodspl.Product_Specialty_User_Assignment__c))){
                system.debug('debcheck3:'+prodspl);
                Set<Id> userIds = oppTerrUsermap.get(prodspl.Opportunity__c);
                userIds.remove(productSpcltyUserIdMap.get(prodspl.Product_Specialty_User_Assignment__c));
                oppTerrUsermap.put(prodspl.Opportunity__c,userIds);
            }   
        }
        system.debug('debcheck4:'+oppTerrUsermap);
        for(Product_Specialty_Oppty_Assignment__c prodSpcltyOpty: [Select p.Product_Specialty_User_Assignment__r.Product_Specialty__c, p.Product_Specialty_User_Assignment__c, 
                                                                        p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p
                                                                            Where p.Product_Specialty_User_Assignment__r.Product_Specialty__c IN : psSet         
                                                                                AND p.Opportunity__c IN :opptyWithTerritoryGroups.keySet()]){
            uniqueOppSet.add(prodSpcltyOpty.Opportunity__c);
            system.debug('nasirjawed5:'+uniqueOppSet);
            Set<Id> oppSet = prodSpcltyOppMap.get(prodSpcltyOpty.Product_Specialty_User_Assignment__r.Product_Specialty__c);
            if(null == oppSet){
                oppSet = new Set<Id>();
            }                           
            oppSet.add(prodSpcltyOpty.Opportunity__c);
            system.debug('nasirjawed6:'+oppSet);
            prodSpcltyOppMap.put(prodSpcltyOpty.Product_Specialty_User_Assignment__r.Product_Specialty__c,oppSet); 
        }
        
       List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOppltList = new List<Product_Specialty_Oppty_Assignment__c>();
       
       for(Id prodSpcltyId : prodSpcltyOppMap.keySet()){
            for(Id oppId : prodSpcltyOppMap.get(prodSpcltyId)){
                system.debug('nasirjawed10:'+oppTerrUsermap.get(oppId));
                system.debug('nasirjawed15:'+prodSpcltyUserIdProdSpcltyIdMap.get(prodSpcltyId));
                for(Id psuaId : prodSpcltyUserIdProdSpcltyIdMap.get(prodSpcltyId)){
                    if(oppTerrUsermap != null && oppTerrUsermap.get(oppId) != null && oppTerrUsermap.get(oppId).contains(productSpcltyUserIdMap.get(psuaId))){
                        Product_Specialty_Oppty_Assignment__c newObject = new Product_Specialty_Oppty_Assignment__c(Product_Specialty_User_Assignment__c  
                                                                        = psuaId, Opportunity__c = oppId,
                                                                        OwnerId = productSpcltyUserIdMap.get(psuaId));                                                
                        prodSpcltyOppltList.add(newObject);                                                                             
                    }
                }
            }
        }
        if(null != prodSpcltyOppltList && prodSpcltyOppltList.size() > 0){
            try{
                system.debug('nasirjawed9:'+prodSpcltyOppltList);
                insert prodSpcltyOppltList;               
                
            }catch(Exception excp){
                system.debug('Exception found while inserting records for Opportunity Product Specialty Assgnment '+excp.getMessage());
            }
            
        }
        
       */
        //TM:Nasir:End
       
        
    }
    
    /**
    * @description: This method is called from trigger on Alliance & Channel partner records on before-delete event.
    *               delete OpportunityShare record for corresponding parnter account territory group
    * @param: Alliance & Channel partner records
    * 
    */
    public static void removeOpptyShareToPartners(Map<id,Channel_Partner__c> acpNewMap){        
        system.debug('Check3');
        //Map<Id,List<String>> opptyWithTerritoryGroups = new Map<id,List<String>>();
        Map<Id,Set<String>> opptyWithTerritoryGroups = new Map<id,Set<String>>();
        List<OpportunityShare> currentOpptySharing = new List<OpportunityShare>();
        List<OpportunityShare> deleteOpptySharing = new List<OpportunityShare>();
        Set<Id> opptyIds = new Set<Id>();
        
        opptyWithTerritoryGroups = getOpptyShareForPartners(acpNewMap);
        
        if(opptyWithTerritoryGroups == null || opptyWithTerritoryGroups.isEmpty()){
            return;
        }
        
        //TM:Debmalya:R4:3908:remove Opportunity share for related Users when Sales Territory Account Assignment is deleted:Start
        Map<Id,Set<String>> currentOpptyGroupMatch = new Map<Id,Set<String>>();
        Map<Id,Channel_Partner__c> currentOpptyChanelPartners = new Map<Id,Channel_Partner__c>([select id,Channel_Partner__c,Location__c,Opportunity__c from Channel_Partner__c where  Opportunity__c IN: opptyWithTerritoryGroups.keySet()]);
        for(Id channelId : currentOpptyChanelPartners.keySet()){
            if(acpNewMap.keySet().contains(channelId)){
                currentOpptyChanelPartners.remove(channelId);
            }
        }
        if(currentOpptyChanelPartners != null && !currentOpptyChanelPartners.isEmpty()){
            currentOpptyGroupMatch = getOpptyShareForPartners(currentOpptyChanelPartners);
            for(Id opptyId : opptyWithTerritoryGroups.keySet()){
                Set<String> grpSet = opptyWithTerritoryGroups.get(opptyId);
                if(grpSet != null){
                    if(currentOpptyGroupMatch !=null && currentOpptyGroupMatch.get(opptyId) != null){
                        grpSet.removeAll(currentOpptyGroupMatch.get(opptyId));
                    }
                    opptyWithTerritoryGroups.put(opptyId,grpSet);
                }
            }
        }
        //TM:Debmalya:R4:3908:remove Opportunity share for related Users when Sales Territory Account Assignment is deleted:End
        
        opptyIds = opptyWithTerritoryGroups.keySet();
        currentOpptySharing = [select OpportunityId, UserOrGroupId from OpportunityShare where OpportunityId in: opptyIds and UserOrGroupId in : grpIds];
        for(OpportunityShare opptyShare : currentOpptySharing){
            if(opptyWithTerritoryGroups.keySet().contains(opptyShare.OpportunityId)){
                for(Id groupId : opptyWithTerritoryGroups.get(opptyShare.OpportunityId)){
                    if(opptyShare.UserOrGroupId == groupId){
                        deleteOpptySharing.add(opptyShare);
                        System.debug('opp4:'+deleteOpptySharing);
                    }
                }
            }
        }
        
        try{        
            if(deleteOpptySharing != null && deleteOpptySharing.size() >0 ){
                Database.DeleteResult[] newShareResults = database.delete(deleteOpptySharing,false);  
            }
        }catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Channel_Partner__c', 'PartnerCollabACPUtil', 'Class');
        }
        
        //TM:Debmalya:R4:3908:remove Opportunity share for related Users when Sales Territory Account Assignment is deleted:Start
        Map<Id,Set<Id>> oppUserIdSettoDel = getOpptyUsersforGroups(opptyWithTerritoryGroups);
        Map<Id,Set<Id>> oppUsercurrent = new Map<Id,Set<Id>>();
        Map<Id,Id> specialtyUserMap = new Map<Id,Id>();
        Set<Id> userIdtoDel = new Set<Id>();
        List<Product_Specialty_Oppty_Assignment__c> psopptodel = new List<Product_Specialty_Oppty_Assignment__c>();
        if(currentOpptyGroupMatch != null && !currentOpptyGroupMatch.isEmpty()){
            oppUsercurrent = getOpptyUsersforGroups(currentOpptyGroupMatch);
            
            if(oppUserIdSettoDel == null || oppUserIdSettoDel.isEmpty()){
                return;
            }
            
            for(Id opp : oppUserIdSettoDel.keySet()){
                Set<Id> userId = oppUserIdSettoDel.get(opp);
                if(oppUsercurrent != null && oppUsercurrent.get(opp) != null){
                    userId.removeAll(oppUsercurrent.get(opp));  
                }
                oppUserIdSettoDel.put(opp,userId);
                userIdtoDel.addAll(userId);
            }
        }
        //TM:Raghvendra:ALM 10320 :Start
        else{
            if(oppUserIdSettoDel != null && !oppUserIdSettoDel.isEmpty()){
                for(Id oppId : oppUserIdSettoDel.keySet()){
                Set<Id> userId = oppUserIdSettoDel.get(oppId);
                userIdtoDel.addAll(userId);
              }
            }
        }
        //TM:Raghvendra:ALM 10320 :End
        for(Product_Specialty_User_Assignment__c psua : [select Id,User__c,Product_Specialty__c from Product_Specialty_User_Assignment__c where User__c IN : userIdtoDel]){
            specialtyUserMap.put(psua.Id,psua.User__c);
        }
        
        for(Product_Specialty_Oppty_Assignment__c psopp : [Select Id, Opportunity__c, Product_Specialty_User_Assignment__c  from Product_Specialty_Oppty_Assignment__c where Opportunity__c IN : oppUserIdSettoDel.keySet() and Product_Specialty_User_Assignment__c IN : specialtyUserMap.keySet()]){
            if(oppUserIdSettoDel.get(psopp.Opportunity__c).contains(specialtyUserMap.get(psopp.Product_Specialty_User_Assignment__c))){
                psopptodel.add(psopp);
            }
        }
        
        try{        
            if(psopptodel != null && psopptodel.size() >0 ){
                Database.DeleteResult[] newShareResults = database.delete(psopptodel,false);  
            }
        }catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Product_Specialty_Oppty_Assignment__c', 'PartnerCollabACPUtil', 'Class');
        }
        //TM:Debmalya:R4:3908:remove Opportunity share for related Users when Sales Territory Account Assignment is deleted:End
    }
    
    /**
    * TM:Debmalya:R4:3908:remove Opportunity share for related Users when Sales Territory Account Assignment is deleted:Start
    * @description: This method deletes Opportunity shares and Opportunity specialty for related Users when a Sales Territory
    *               Account Assignment is deleted.
    * @param: Alliance & Channel partner records
    * 
    */
    public static void removeOpptyShareToPartnersincremental(Map<id,Set<String>> opptyGroupIdSetMap){
        
        List<OpportunityShare> currentOpptySharing = new List<OpportunityShare>();
        List<OpportunityShare> deleteOpptySharing = new List<OpportunityShare>();
        Set<String> grpIdSet = new Set<String>();
        //Set<String> validgrpIdSet = new Set<String>();
        Map<Id,Set<String>> opptyWithTerritoryGroups = new Map<Id,Set<String>>();
        Map<Id,Channel_Partner__c> acpMap = new Map<Id,Channel_Partner__c>([select id,Channel_Partner__c,Location__c,Opportunity__c from Channel_Partner__c where  Opportunity__c IN: opptyGroupIdSetMap.keySet()]);
        
        opptyWithTerritoryGroups = getOpptyShareForPartners(acpMap);
        
        /*for(Id opp : opptyWithTerritoryGroups.keySet()){
            validgrpIdSet.addAll(opptyWithTerritoryGroups.get(opp));
        }*/
        
        for(Id opptyId : opptyGroupIdSetMap.keySet()){
            Set<String> grpSet = opptyGroupIdSetMap.get(opptyId);
            if(opptyWithTerritoryGroups != null && opptyWithTerritoryGroups.get(opptyId) != null){
                grpSet.removeAll(opptyWithTerritoryGroups.get(opptyId));    
            }
            opptyGroupIdSetMap.put(opptyId,grpSet);
            /*for(Id grpId : opptyGroupIdSetMap.get(opptyId)){
                Set<String> opptyGrpSet = new Set<String>();
                opptyGrpSet.addAll(opptyWithTerritoryGroups.get(opptyId));
                if(opptyGrpSet.contains(grpId)){
                    Set<String> grpSet = opptyGroupIdSetMap.get(opptyId);
                    grpSet.remove(grpId);
                    opptyGroupIdSetMap.put(opptyId,grpSet);
                }
            }*/
            grpIdSet.addAll(opptyGroupIdSetMap.get(opptyId));
        }
        currentOpptySharing = [select OpportunityId, UserOrGroupId from OpportunityShare where OpportunityId in: opptyGroupIdSetMap.keySet() and UserOrGroupId in : grpIdSet];
        for(OpportunityShare opptyShare : currentOpptySharing){
            if(opptyGroupIdSetMap.keySet().contains(opptyShare.OpportunityId)){
                for(Id groupId : opptyGroupIdSetMap.get(opptyShare.OpportunityId)){
                    if(opptyShare.UserOrGroupId == groupId){
                        deleteOpptySharing.add(opptyShare);
                        System.debug('opp4:'+deleteOpptySharing);
                    }
                }
            }
        }
        
        try{        
            if(deleteOpptySharing != null && deleteOpptySharing.size() >0 ){
                Database.DeleteResult[] newShareResults = database.delete(deleteOpptySharing,false);  
            }
        }catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Channel_Partner__c', 'PartnerCollabACPUtil', 'Class');
        }
       
        Map<Id,Set<Id>> oppUserIdSettoDel = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> oppUsercurrent = new Map<Id,Set<Id>>();
        Map<Id,Id> specialtyUserMap = new Map<Id,Id>();
        oppUserIdSettoDel = getOpptyUsersforGroups(opptyGroupIdSetMap);
        oppUsercurrent = getOpptyUsersforGroups(opptyWithTerritoryGroups);
        List<Product_Specialty_Oppty_Assignment__c> psopptodel = new List<Product_Specialty_Oppty_Assignment__c>();
        Set<Id> userIdtoDel = new Set<Id>();
        Set<Id> psUsertoDel = new Set<Id>();
        
        if(oppUserIdSettoDel == null || oppUserIdSettoDel.isEmpty()){
            return;
        }
        
        for(Id opp : oppUserIdSettoDel.keySet()){
            Set<Id> userId = oppUserIdSettoDel.get(opp);
            if(oppUsercurrent != null && oppUsercurrent.get(opp) != null){
                userId.removeAll(oppUsercurrent.get(opp));  
            }
            oppUserIdSettoDel.put(opp,userId);
            userIdtoDel.addAll(userId);
        }
        
        //Map<Id,Product_Specialty_User_Assignment__c> specialtyUserMap = new Map<Id,Product_Specialty_User_Assignment__c>([select Id,User__c,Product_Specialty__c from Product_Specialty_User_Assignment__c where User__c IN : userIdtoDel]);
        for(Product_Specialty_User_Assignment__c psua : [select Id,User__c,Product_Specialty__c from Product_Specialty_User_Assignment__c where User__c IN : userIdtoDel]){
            specialtyUserMap.put(psua.Id,psua.User__c);
        }
        
        for(Product_Specialty_Oppty_Assignment__c psopp : [Select Id, Opportunity__c, Product_Specialty_User_Assignment__c  from Product_Specialty_Oppty_Assignment__c where Opportunity__c IN : oppUserIdSettoDel.keySet() and Product_Specialty_User_Assignment__c IN : specialtyUserMap.keySet()]){
            if(oppUserIdSettoDel.get(psopp.Opportunity__c).contains(specialtyUserMap.get(psopp.Product_Specialty_User_Assignment__c))){
                psopptodel.add(psopp);
            }
        }
        
        try{        
            if(psopptodel != null && psopptodel.size() >0 ){
                Database.DeleteResult[] newShareResults = database.delete(psopptodel,false);  
            }
        }catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Product_Specialty_Oppty_Assignment__c', 'PartnerCollabACPUtil', 'Class');
        }
    }
    
    /**
    * @description: get parnter account territory users corresponding to Opportunities  
    * @param: Opportunities with their corresponding Territory Group
    * 
    */
    public static Map<Id,Set<Id>> getOpptyUsersforGroups(Map<Id,Set<String>> opptywithTerrGrps){
        Set<String> grpOfAllOpps = new Set<String>();
        Map<Id,Set<Id>> groupUsermap = new MAP<Id,Set<Id>>();
        Map<Id,Set<Id>> oppTerrUsermap = new MAP<Id,Set<Id>>();
        
        if(opptywithTerrGrps == null || opptywithTerrGrps.isEmpty()){
            return null;
        }
        for(Id oppty : opptywithTerrGrps.keySet()){
            grpOfAllOpps.addAll(opptywithTerrGrps.get(oppty));
        }
        
        for(GroupMember gm:[select id,GroupId,UserOrGroupId from GroupMember where GroupId=: grpOfAllOpps ]){
            system.debug('nasirjawed2:'+gm);
            //stUserId.add(gm.UserOrGroupId );
            //system.debug('nasirjawed1:'+stUserId);
            Set<Id> userIds = groupUsermap.get(gm.GroupId);
            if(userIds == null){
                userIds = new Set<Id>();
            }
            userIds.add(gm.UserOrGroupId);
            groupUsermap.put(gm.GroupId,userIds);
        }
        
        for(Id opptyId : opptywithTerrGrps.keySet()){
            for(Id groupId : opptywithTerrGrps.get(opptyId)){
                Set<Id> userIds = oppTerrUsermap.get(opptyId);
                if(userIds == null){
                    userIds = new Set<Id>();
                }
                if(groupUsermap.get(groupId) != null && groupUsermap.get(groupId).size() > 0){
                    userIds.addAll(groupUsermap.get(groupId));
                    oppTerrUsermap.put(opptyId,userIds);
                    system.debug('nasirjawed12:'+userIds);
                    system.debug('nasirjawed13:'+oppTerrUsermap);
                }
            }
        }
        return oppTerrUsermap;
    }
    //TM:Debmalya:R4:3908:remove Opportunity share for related Users when Sales Territory Account Assignment is deleted:End
    
    /**
    * @description: get parnter account territory group corresponding to Opportunities  
    * @param: new Alliance & Channel partner records
    * 
    */
    public static Map<Id,Set<String>> getOpptyShareForPartners(Map<id,Channel_Partner__c> acpNewMap){
        
        Set<Id> partnerAccIds = new Set<Id>();
        Set<Id> terrIdsOfPartners = new Set<Id>();      
        Map<Id,Sales_Territory_Account_Assignment__c> accWithTerritory;
        Map<Id,Sales_Territory__c> partnerTerritories;
        Map<Id,List<Id>> opptyWithTrritories = new Map<id,List<Id>>();
        //TM:R4:3908:14th Jan,2012Changing List to Set
        //Map<Id,List<String>> opptyWithTerritoryGroups = new Map<id,List<String>>();
        Map<Id,Set<String>> opptyWithTerritoryGroups = new Map<id,Set<String>>();
        
        //Vinay R5:6201:25th Apr,2013 Sharing to partner location's non external sales territories in addition to BR -Start
        Set<Id> locationIdSet = new Set<Id>();
        Map<Id,Sales_Territory_Location_Assignment__c> locWithTerritoryMap;
        //Vinay R5:6201-End
        
        for(Channel_Partner__c newAcpRec : acpNewMap.values()){
            if(newAcpRec.Channel_Partner__c != null && String.valueOf(newAcpRec.Channel_Partner__c) != ''){
                partnerAccIds.add(newAcpRec.Channel_Partner__c);
            }
        }
        //Vinay R5:6201-Start
        for(Channel_Partner__c newAcpRec: acpNewMap.values()){
            if(newAcpRec.Location__c != null && String.valueOf(newAcpRec.Location__c) != ''){
                locationIdSet.add(newAcpRec.Location__c);
            }
        }
        
        locWithTerritoryMap = new Map<Id,Sales_Territory_Location_Assignment__c>([Select Id,Location__c,Sales_Territory__c From Sales_Territory_Location_Assignment__c where Location__c IN: locationIdSet AND Sales_Territory__r.isPartner__c= true AND Sales_Territory__r.isExternal__c=false]);
       
        //Vinay R5:6201-End
        
        //Sameer R4:Req:4043:Start
        //added the following condition in the below SOQL : Sales_Territory__r.isPartner__c== true AND Sales_Territory__r.isExternal__c==false.
        accWithTerritory = new Map<Id,Sales_Territory_Account_Assignment__c>([Select Id, Account__c, Sales_Territory__c from Sales_Territory_Account_Assignment__c where Account__c in : partnerAccIds AND Sales_Territory__r.isPartner__c= true AND Sales_Territory__r.isExternal__c=false]);
        //Sameer R4:Req:4043:End
        System.debug('Partner:'+accWithTerritory );
         //Vinay R5:6201-Start
         //added conditions related to location
        if((accWithTerritory == null || accWithTerritory.isEmpty()) && (locWithTerritoryMap == null || locWithTerritoryMap.isEmpty())){
            return null;
        }
        //adding territories related to partners location in addition to BR
        for(Channel_Partner__c newAcpRec:acpNewMap.values()){
            for(Sales_Territory_Location_Assignment__c locWithTerritoryRec:locWithTerritoryMap.values()){
                if((newAcpRec.Location__c == locWithTerritoryRec.Location__c) && (locWithTerritoryRec.Sales_Territory__c != null)
                && String.valueOf(locWithTerritoryRec.Sales_Territory__c) !=''){
                    terrIdsOfPartners.add(locWithTerritoryRec.Sales_Territory__c);
                    if(!opptyWithTrritories.containsKey(newAcpRec.Opportunity__c)){
                        List<Id> retTerrIdList = new List<Id>();
                        retTerrIdList.add(locWithTerritoryRec.Sales_Territory__c);
                        opptyWithTrritories.put(newAcpRec.Opportunity__c,retTerrIdList);
                    }else{
                        opptyWithTrritories.get(newAcpRec.Opportunity__c).add(locWithTerritoryRec.Sales_Territory__c);
                    }
                }
            }
        }
         //Vinay R5:6201-End
        for(Channel_Partner__c newAcpRec : acpNewMap.values()){
            for(Sales_Territory_Account_Assignment__c accWithTerritoryRec : accWithTerritory.values()){
                if((newAcpRec.Channel_Partner__c == accWithTerritoryRec.Account__c) && (accWithTerritoryRec.Sales_Territory__c != null) 
                && (String.valueOf(accWithTerritoryRec.Sales_Territory__c) != '')){
                    terrIdsOfPartners.add(accWithTerritoryRec.Sales_Territory__c);
                    if(opptyWithTrritories.containsKey(newAcpRec.Opportunity__c)){
                        List<ID> relTerrIds = opptyWithTrritories.get(newAcpRec.Opportunity__c);
                        relTerrIds.add(accWithTerritoryRec.Sales_Territory__c);
                        opptyWithTrritories.put(newAcpRec.Opportunity__c,relTerrIds);
                    }else{
                        opptyWithTrritories.put(newAcpRec.Opportunity__c,new List<ID>{accWithTerritoryRec.Sales_Territory__c});
                    }
                }
            }           
        }
        
        partnerTerritories = new Map<Id,Sales_Territory__c>([select Id, GroupID__c from Sales_Territory__c where Id in: terrIdsOfPartners]);
        System.debug('Partner1:'+partnerTerritories );
        if(partnerTerritories == null || partnerTerritories.isEmpty()){
            return null;
        }
        
        for(Id opptyId : opptyWithTrritories.keySet()){
            //List<String> relGpIds = new List<String>();
            Set<String> relGpIds = new Set<String>();
            for(Id territoryId : opptyWithTrritories.get(opptyId)){
                if (partnerTerritories.get(territoryId).GroupID__c != null && String.valueOf(partnerTerritories.get(territoryId).GroupID__c) != ''){
                    relGpIds.add(partnerTerritories.get(territoryId).GroupID__c);
                    grpIds.add(partnerTerritories.get(territoryId).GroupID__c);
                }
            }
            opptyWithTerritoryGroups.put(opptyId,relGpIds);
            System.debug('Partner2:'+opptyWithTerritoryGroups);
        }
        
        if(opptyWithTerritoryGroups != null || opptyWithTerritoryGroups.size()>0 ){
            return opptyWithTerritoryGroups;
        }else {
            return null;
        }   
    
    }
    
}