/**
  * @author: rahul.kunal (Accenture)
  * HP Release 2
  * This Class drives the logic for Product Specialty Functionality for User Assignment
  * Date:
  */
public with sharing class ProdSpcltyUserAsgnmtTriggerController {
    
    /*
     * Method to control the update logic for Specialty User Assignment. 
     * Called from trigger.
     */
    public static void controlProdSpcltyUserAsgnmntUpdate(Map<Id,Product_Specialty_User_Assignment__c> oldTriggerMap,Map<Id,Product_Specialty_User_Assignment__c> newTriggerMap){
        
        Map<Id,Product_Specialty_User_Assignment__c> prodSpcltyUserMapToUpdate = new Map<Id,Product_Specialty_User_Assignment__c>();
        if(null != oldTriggerMap && null != newTriggerMap){
            for(Id prodSpcltyUserIdObj : newTriggerMap.keySet()){
                //Product_Specialty_User_Assignment__c newObj = newTriggerMap.get(prodSpcltyUserIdObj);
                //Product_Specialty_User_Assignment__c oldObj = oldTriggerMap.get(prodSpcltyUserIdObj);
                
                if(oldTriggerMap.get(prodSpcltyUserIdObj) != null && newTriggerMap.get(prodSpcltyUserIdObj) != null 
                    && oldTriggerMap.get(prodSpcltyUserIdObj).User__c != newTriggerMap.get(prodSpcltyUserIdObj).User__c 
                    || oldTriggerMap.get(prodSpcltyUserIdObj).Product_Specialty__c != newTriggerMap.get(prodSpcltyUserIdObj).Product_Specialty__c){
                        
                    prodSpcltyUserMapToUpdate.put(prodSpcltyUserIdObj,newTriggerMap.get(prodSpcltyUserIdObj));
                }
            }
        }
        
        if(null != prodSpcltyUserMapToUpdate && prodSpcltyUserMapToUpdate.size() > 0){
            executeUpdateProdSpcltyUserLogic(prodSpcltyUserMapToUpdate);
        }
        
    }
    
    /*
     * Method to control Delete logic for Specialty User Assignment.
     * Called from Trigger.
     */
     public static void controlProdSpcltyUserAsgnmntDelete(Map<Id,Product_Specialty_User_Assignment__c> oldTriggerMap){
         //SREENATH Req- 5909 THIS CODE IS HANDLING IN A BATCH starts
       /* List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOpptyListToDel = new List<Product_Specialty_Oppty_Assignment__c>();
        //TM:Test-----Test
        Set<Id> idval = oldTriggerMap.keySet();
        String strqu = 'Select count() From Product_Specialty_Oppty_Assignment__c p Where p.Product_Specialty_User_Assignment__c = :idval';
        //TM:Test-----Test
        for(Product_Specialty_Oppty_Assignment__c prodSpcltyOpptyObj : [Select p.Product_Specialty_User_Assignment__c, p.Id From Product_Specialty_Oppty_Assignment__c p
                                                                                                        Where p.Product_Specialty_User_Assignment__c In : oldTriggerMap.keySet()])
        {
            prodSpcltyOpptyListToDel.add(prodSpcltyOpptyObj);
        }
        
        if(null != prodSpcltyOpptyListToDel && prodSpcltyOpptyListToDel.size() > 0){
            try{
                delete prodSpcltyOpptyListToDel;
            }catch(Exception excp){
                system.debug('Exception found while deleting records for Opportunity Product Specialty Assgnment on Deleting Product Specialty User Asgnmnt Record '+excp.getMessage());
            }
        }*/
         //SREENATH Req- 5909 THIS CODE IS HANDLING IN A BATCH ends
        //Remove the Product speciality from User if value is deleted from Product speciality User Assignement
        Set<Id> userIdsSet=new Set<Id>();
        Set<Id> specialtyUserSet = new Set<Id>();
        //List<User> userPSList= new List<User>();
        List<User> userPSList1= new List<User>();
        //TM: Sreenath 5909 adding specialty users in a set where "to be deleted" flag is false. After deleting few users from this object where this flag is true. starts
        for(Product_Specialty_User_Assignment__c psUsers:[select id,User__c from Product_Specialty_User_Assignment__c where To_be_deleted__c=false] ){
        specialtyUserSet.add(psUsers.User__c);
        }
        //TM: Sreenath 5909 adding specialty users in a set where "to be deleted" flag is false. After deleting few users from this object where this flag is true. ends
        for( Product_Specialty_User_Assignment__c psuaObj: oldTriggerMap.Values()){
            userIdsSet.add(psuaObj.User__c);
        }
        //userPSList=[Select Proudct_speciality__c from User where Id IN : userIdsSet];
        //TM SREENATH 5909: specialty check of the user. If user is not existing under any specialty we are making NULL in user detail specialty value starts.
       // for(User userObj: [Select Proudct_speciality__c from User where Id IN : userIdsSet{
       for(User userObj: [Select Proudct_speciality__c from User where Id IN : userIdsSet and Id NOT IN : specialtyUserSet]){
       //TM SREENATH 5909: specialty check of the user. If user is not existing under any specialty we are making NULL in user detail specialty value ENDS.
            userObj.Proudct_speciality__c='';
            userPSList1.add(userObj);
        }
        if(!userPSList1.isEmpty()){
            try{
                update userPSList1;
            }catch(Exception excp){
                system.debug('Exception found while updating records for User on Updating Product Specialty User Asgnmnt Record '+excp.getMessage());
            }
        }
    }
    
    /*
     * Method to handle User Object update on Specialty User Assignment Update
     */
    public static void controlInsertUpdateUserMappingLogic(Map<Id,Product_Specialty_User_Assignment__c> newTriggerMap){
        
        try{

            Map<Id,String> userToProductSpecMap = new Map<Id,String>();
            //Map<Id, Id> psIdUserIdMap = new Map<Id, Id>();
            //Extract all records for Product speciality Oppty Assignment object.
            for(Product_Specialty_User_Assignment__c prodSpecialityObj : [Select User__c,Product_Specialty__r.Name from 
                                                                            Product_Specialty_User_Assignment__c where Id IN :newTriggerMap.KeySet()])
            {
                //Creata a MAP between Users Id and Product Speciality name
                userToProductSpecMap.put(prodSpecialityObj.User__c,prodSpecialityObj.Product_Specialty__r.Name);
                system.debug('testuser:'+userToProductSpecMap);
                //psIdUserIdMap.put(prodSpecialityObj.Product_Specialty__c,prodSpecialityObj.User__c);
            
            }
        
            List<User> updatePSforUserList=new List<User>();
            for( User userPSObj: [Select Proudct_speciality__c from User where Id IN :userToProductSpecMap.keySet()])
            {
                //Assiging Product speciality to users at User Object
                userPSObj.Proudct_speciality__c = userToProductSpecMap.get(userPSObj.Id);
                system.debug('testuser1:'+userPSObj.Proudct_speciality__c);
                updatePSforUserList.add(userPSObj);
                system.debug('testuser2:'+updatePSforUserList);
            }
     
            update updatePSforUserList;
            system.debug('testuser3:'+updatePSforUserList);
        }catch(Exception e){
            system.debug('While Processing' + e.getMessage());
        }
    }
    
    /*
     * Method to handle Insert Logic for Specialty User Assignment.
     * It checks for the User in Opportunity Territory and then generates the new record for Specialty Opportunity Assignemnt.
     *
     */
    public static void controlInsertProdSpecltyUser(Map<Id,Product_Specialty_User_Assignment__c> newTriggerMap){
        
        Map<Id,Id> prodSpcltyUserIdProdSpcltyIdMap = new Map<Id,Id>();
        Map<Id,Id> productSpcltyUserIdMap = new Map<Id,Id>();
        Set<Id> prodSpcltySet = new Set<Id>();
        //TM:R5: NAsir Jawed: CR-0712: Start
        set<ID> userInSTandSpecialty= new set<ID>();
        set<ID> psSet= new set<ID>();
        List<Product_Specialty_User_Assignment__c> psuaList= new List<Product_Specialty_User_Assignment__c>();
        List<Product_Specialty__c> psList= new List<Product_Specialty__c>();
        //TM:R5 NAsir Jawed: CR-0712: End
        for(Id prodSpcltyUserId : newTriggerMap.keySet()){
            
            prodSpcltySet.add(newTriggerMap.get(prodSpcltyUserId).Product_Specialty__c);
            prodSpcltyUserIdProdSpcltyIdMap.put(newTriggerMap.get(prodSpcltyUserId).Product_Specialty__c,prodSpcltyUserId);
            productSpcltyUserIdMap.put(prodSpcltyUserId,newTriggerMap.get(prodSpcltyUserId).User__c);
        }
        
        // TM tickets fix..  
        //Set<Id> accSet = new Set<Id>();
        Set<Id> stSet = new Set<Id>();
        
        for(Sales_Territory_User_Assignment__c stua : [Select Id,User__c, t.Sales_Territory__c From Sales_Territory_User_Assignment__c t 
                                                        where t.User__c IN :productSpcltyUserIdMap.values() AND t.Sales_Territory__r.IsActive__c= true and IsActive__c = true]){
            stSet.add(stua.Sales_Territory__c); 
            //TM:R5 NAsir Jawed: CR-0712: Start
            userInSTandSpecialty.add(stua.User__c); 
            system.debug('test1:'+userInSTandSpecialty);           
            //TM:R5 NAsir Jawed: CR-0712: End                                      
         }
        
        //TM:Debmalya:ALM5362:Commenting out code as logic has been implemented in Batch:Start
        /*for(Sales_Territory_Account_Assignment__c accountAssignment : [SELECT Id, Account__c  FROM Sales_Territory_Account_Assignment__c 
                                                                        where Sales_Territory__c IN : stSet AND Sales_Territory__r.IsActive__c= true]){
            accSet.add(accountAssignment.Account__c);
        }*/
        //end TM Ticket Fix
        //TM:Debmalya:ALM5362:Commenting out code as logic has been implemented in Batch:END
        // TM Sreenath:ALM:5362:Territory level field updation starts
        List<Sales_Territory__c> sTerrupdate = new List<Sales_Territory__c>();
        if(stSet!=null){
            for(Sales_Territory__c sTerr : [Select Id,New_User_Alert__c,DateTime_User_Insert__c from Sales_Territory__c where Id IN: stSet]){
                /*TM:R5 NAsir Jawed: CR-0712 Commenting this field as this fiels was used in batch "ProductSpecialityUserBatch" which have been removed because of production Error.
                sTerr.Related_User_Speciality_Updation__c = true;
                */
                //TM:R5 NAsir Jawed: CR-0712: Start
                sTerr.New_User_Alert__c= true;
                sTerr.DateTime_User_Insert__c=System.Now();
                //TM:R5 NAsir Jawed: CR-0712: End
                sTerrupdate.add(sTerr);
            }
            update sTerrupdate;
        }
         //TM:R5 NAsir Jawed: CR-0712: Start
         if(userInSTandSpecialty!=null){
               for(Product_Specialty_User_Assignment__c psua:[select id,New_User_Insert_Sales_Territory__c,To_Be_Deleted__c,Product_Specialty__c from Product_Specialty_User_Assignment__c where User__c IN:userInSTandSpecialty AND To_Be_Deleted__c=False ]){
                   system.debug('test2:'+psua);
                   psua.New_User_Insert_Sales_Territory__c=true;
                   psSet.add(psua.Product_Specialty__c);
                   psuaList.add(psua);                   
                   system.debug('test3:'+psuaList);
                   }
            } 
          if(psSet!=null){
              for(Product_Specialty__c ps:[Select id,New_Specialty_search__c from Product_Specialty__c where id IN:psSet]){
                  system.debug('test4:'+ps);
                  ps.New_Specialty_search__c=true;
                  psList.add(ps);
              }
          }   
         update psuaList;
         update psList;      
         //TM:R5 NAsir Jawed: CR-0712: End
        // TM Sreenath:ALM:5362:Territory level field updation ends
        //TM:Debmalya:ALM5362:Commenting out code as logic has been implemented in Batch:Start
        /*Map<Id,Set<Id>> prodSpcltyOppMap = new Map<Id,Set<Id>>();
        Set<Id> uniqueOppSet = new Set<Id>();
        for(Product_Specialty_Oppty_Assignment__c prodSpcltyOpty: [Select p.Product_Specialty_User_Assignment__r.Product_Specialty__c, p.Product_Specialty_User_Assignment__c, 
                                                                        p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p
                                                                            Where p.Product_Specialty_User_Assignment__r.Product_Specialty__c IN : prodSpcltySet
                                                                                AND p.Opportunity__c IN : [Select Id, AccountId from Opportunity where AccountId IN : accSet]]){
            uniqueOppSet.add(prodSpcltyOpty.Opportunity__c);
            Set<Id> oppSet = prodSpcltyOppMap.get(prodSpcltyOpty.Product_Specialty_User_Assignment__r.Product_Specialty__c);
            if(null == oppSet){
                oppSet = new Set<Id>();
            }                           
            oppSet.add(prodSpcltyOpty.Opportunity__c);
            prodSpcltyOppMap.put(prodSpcltyOpty.Product_Specialty_User_Assignment__r.Product_Specialty__c,oppSet);                                      
        }
        
        Map<Id,Set<Id>> oppTerrUsermap = OppAccntTerrUser.callFetchAccntUserLogic(uniqueOppSet, 'Opportunity');
        List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOppltList = new List<Product_Specialty_Oppty_Assignment__c>();
        for(Id prodSpcltyId : prodSpcltyOppMap.keySet()){
            for(Id oppId : prodSpcltyOppMap.get(prodSpcltyId)){
                if(oppTerrUsermap != null && oppTerrUsermap.get(oppId) != null && oppTerrUsermap.get(oppId).contains(productSpcltyUserIdMap.get(prodSpcltyUserIdProdSpcltyIdMap.get(prodSpcltyId)))){
                    Product_Specialty_Oppty_Assignment__c newObject = new Product_Specialty_Oppty_Assignment__c(Product_Specialty_User_Assignment__c  
                                                                                = prodSpcltyUserIdProdSpcltyIdMap.get(prodSpcltyId), Opportunity__c = oppId,
                                                                                    OwnerId = productSpcltyUserIdMap.get(prodSpcltyUserIdProdSpcltyIdMap.get(prodSpcltyId)));
                    prodSpcltyOppltList.add(newObject);                                                                             
                }
            }
        }
        
        if(null != prodSpcltyOppltList && prodSpcltyOppltList.size() > 0){
            try{
                insert prodSpcltyOppltList;
            }catch(Exception excp){
                system.debug('Exception found while inserting records for Opportunity Product Specialty Assgnment '+excp.getMessage());
            }
            
        }*/
        //TM:Debmalya:ALM5362:Commenting out code as logic has been implemented in Batch:END
    }
    
    /*
     * @Description: Called to handle the update logic for updating the Specialty Opportunity Assignment record.
     * Specially in both the case if Specialty is getting chmaged or User and if both are getting changed.
     */
    private static void executeUpdateProdSpcltyUserLogic(Map<Id,Product_Specialty_User_Assignment__c> prodSpcltyUserMap){
        
        
        // Make one unique set of Specialty to query its availability in Specialty Opportunity Assignment 
        // so that if present then only update for user change or specialty change any one of them.
         
        Set<Id> specialtySet = new Set<Id>();
        Set<Id> productSpcltyUserId = new Set<Id>();
        Map<Id,Id> specialtyUserIdSpcltyIdMap = new Map<Id,Id>();
        
        for(Product_Specialty_User_Assignment__c obj : prodSpcltyUserMap.values()){
            specialtySet.add(obj.Product_Specialty__c);
            specialtyUserIdSpcltyIdMap.put(obj.Id,obj.Product_Specialty__c);
            productSpcltyUserId.add(obj.User__c);
        }
        Set<Id> specialtyToUpdateSet = new Set<Id>();
        Set<Id> specialtyToDeleteSet = new Set<Id>();
        
        // TM tickets fix..  
        Set<Id> accSet = new Set<Id>();
        Set<Id> stSet = new Set<Id>();
        
        for(Sales_Territory_User_Assignment__c stua : [Select Id, t.Sales_Territory__c From Sales_Territory_User_Assignment__c t 
                                                        where t.User__c IN :productSpcltyUserId AND t.Sales_Territory__r.IsActive__c= true]){
            stSet.add(stua.Sales_Territory__c);                                     
         }
        for(Sales_Territory_Account_Assignment__c accountAssignment : [SELECT Id, Account__c  FROM Sales_Territory_Account_Assignment__c 
                                                                        where Sales_Territory__c IN : stSet AND Sales_Territory__r.IsActive__c= true]){
            accSet.add(accountAssignment.Account__c);
        }
        //end TM Ticket Fix
        
        for(Product_Specialty_Oppty_Assignment__c prodSpcltyOpptyAsgnmtObj : [Select p.Product_Specialty_User_Assignment__r.Product_Specialty__c, 
                                                                                p.Product_Specialty_User_Assignment__c, p.Id From Product_Specialty_Oppty_Assignment__c p 
                                                                                    Where p.Product_Specialty_User_Assignment__r.Product_Specialty__c In : specialtySet
                                                                                        AND p.Opportunity__c IN : [Select Id, AccountId from Opportunity where AccountId IN : accSet]]){
            //If the specialty is present then add it to unique update set of specialty.
            if(specialtySet != null && specialtySet.contains(prodSpcltyOpptyAsgnmtObj.Product_Specialty_User_Assignment__r.Product_Specialty__c)){
                specialtyToUpdateSet.add(prodSpcltyOpptyAsgnmtObj.Product_Specialty_User_Assignment__r.Product_Specialty__c);
            }                                                                           
        }
        
        // from update set of specialty now exempt the specialty which are not present on Specialty Opportunity Assignment for which we have to delete records from Specialty Opportunity Assignment Object
        for(Id spcltyId : specialtySet){
            if(specialtyToUpdateSet !=  null && !specialtyToUpdateSet.contains(spcltyId)){
                specialtyToDeleteSet.add(spcltyId);
            }
        }
        // make one set for UserAsignemnt object to be updated.
        Set<Id> finalUpdateSpcltyUserAsnmtSet = new Set<Id>();
        if(specialtyToUpdateSet != null && specialtyToUpdateSet.size() > 0){
            for(Id specltyUserIdObj : specialtyUserIdSpcltyIdMap.keySet()){
                if(specialtyToUpdateSet.contains(specialtyUserIdSpcltyIdMap.get(specltyUserIdObj))){
                    finalUpdateSpcltyUserAsnmtSet.add(specltyUserIdObj);
                }
            }
        }
        
        // make one set for UserAsignemnt object to be deleted.
        Set<Id> finalDeleteSpcltyUserAsnmtSet = new Set<Id>();
        if(specialtyToDeleteSet != null && specialtyToDeleteSet.size() > 0){
            for(Id specltyUserIdObj : specialtyUserIdSpcltyIdMap.keySet()){
                if(specialtyToDeleteSet.contains(specialtyUserIdSpcltyIdMap.get(specltyUserIdObj))){
                    finalDeleteSpcltyUserAsnmtSet.add(specltyUserIdObj);
                }
            }
        }
        
        //Update the record for Specialty Opportunity Assignment if any.
        if(finalUpdateSpcltyUserAsnmtSet != null && finalUpdateSpcltyUserAsnmtSet.size() > 0){
            //so for the available specialty now check whether the user is there in territory or not for the Opportunity related to these specialty if present on Specialty Opportunity Assignment
            Set<Id> oppIdSet = new Set<Id>();
            Map<Id,Id> prodUserOppIdMap = new Map<Id,Id>();
            Map<Id,Product_Specialty_Oppty_Assignment__c> prodUserIdProdOpptyObjMap = new Map<Id,Product_Specialty_Oppty_Assignment__c>();
            for(Product_Specialty_Oppty_Assignment__c prodSpcltyOpptyAsgnmtObj : [Select p.Product_Specialty_User_Assignment__c, p.Opportunity__c, p.Id 
                                                                                                From Product_Specialty_Oppty_Assignment__c p 
                                                                                                    Where p.Product_Specialty_User_Assignment__c In : finalUpdateSpcltyUserAsnmtSet]){
                oppIdSet.add(prodSpcltyOpptyAsgnmtObj.Opportunity__c);
                prodUserOppIdMap.put(prodSpcltyOpptyAsgnmtObj.Product_Specialty_User_Assignment__c,prodSpcltyOpptyAsgnmtObj.Opportunity__c);
                prodUserIdProdOpptyObjMap.put(prodSpcltyOpptyAsgnmtObj.Product_Specialty_User_Assignment__c,prodSpcltyOpptyAsgnmtObj);
            }
            
            //Fetch set of users from territory for the opportunities, to check whether the new user to be added is present or not in territiru user assignment.
            Map<Id,Set<Id>> fetcheOppIdUserIdSetmap = OppAccntTerrUser.callFetchAccntUserLogic(oppIdSet,'Opportunity');
             
            List<Product_Specialty_Oppty_Assignment__c> prodOpptyList = new List<Product_Specialty_Oppty_Assignment__c>();
            for(Id prodUserAsnmtId : prodUserOppIdMap.keySet()){
                if(fetcheOppIdUserIdSetmap != null && fetcheOppIdUserIdSetmap.get(prodUserOppIdMap.get(prodUserAsnmtId)).contains(prodSpcltyUserMap.get(prodUserAsnmtId).User__c)){
                    prodUserIdProdOpptyObjMap.get(prodUserAsnmtId).Product_Specialty_User_Assignment__c = prodUserAsnmtId;
                    prodOpptyList.add(prodUserIdProdOpptyObjMap.get(prodUserAsnmtId));
                }
            }
            
            if(null != prodOpptyList && prodOpptyList.size() > 0){
                try{
                    update prodOpptyList;
                }catch(Exception excp){
                    system.debug('Exception found while updating records for Opportunity Product Specialty Assgnment on Updating Product Specialty User Asgnmnt Record '+excp.getMessage());
                }
            }
        }
        
        //Delete the records from Specialty Opportunity Assignement. of any.
        if(finalDeleteSpcltyUserAsnmtSet != null && finalDeleteSpcltyUserAsnmtSet.size() >0){
            List<Product_Specialty_Oppty_Assignment__c> prodOpptyToDelList = new List<Product_Specialty_Oppty_Assignment__c>();
            for(Product_Specialty_Oppty_Assignment__c spcltyOptyObj : [Select p.Product_Specialty_User_Assignment__c, p.Id 
                                                                            From Product_Specialty_Oppty_Assignment__c p 
                                                                                Where p.Product_Specialty_User_Assignment__c In : finalDeleteSpcltyUserAsnmtSet]){
                prodOpptyToDelList.add(spcltyOptyObj);
            }
            
            if(prodOpptyToDelList != null && prodOpptyToDelList.size() > 0){
                try{
                    delete prodOpptyToDelList;
                }catch(Exception excp){
                    system.debug('Exception found while Deleting records before updating for Opportunity Product Specialty Assgnment on Updating Product Specialty User Asgnmnt Record '+excp.getMessage());
                }
            }
        }
    }
    
    /*
     * @Description: Called to handle the update logic for updating the Product Speciality at User level.
     * Specially when name of Product Speciality is changed.
     */
    public static void executeUpdateProdSpcltyOnUser(List<Product_Specialty__c> triggerNewList,List<Product_Specialty__c> triggerOldList){
        
        List<Id> UpdatedPSIdsList=new List<Id>();
        Map<Id,String> userToProductSpecMap = new Map<Id,String>();
        //Map<Id, Id> psIdUserIdMap = new Map<Id, Id>();  
        List<Product_Specialty_User_Assignment__c > updatePSUAList = new List<Product_Specialty_User_Assignment__c >();
        Set<Id> PSUIdSet= new Set <Id>();
         for (Integer i=0;i<triggerNewList.size();i++){
             if (triggerNewList[i].Name!= triggerOldList[i].Name){
             UpdatedPSIdsList.add(triggerNewList[i].Id);
            }
        } 
        
        updatePSUAList = [Select User__c,Product_Specialty__r.Name from Product_Specialty_User_Assignment__c where Product_Specialty__c IN :UpdatedPSIdsList ];
        
        for (Product_Specialty_User_Assignment__c prodSpecialityObj : updatePSUAList ){
            userToProductSpecMap.put(prodSpecialityObj.User__c,prodSpecialityObj.Product_Specialty__r.Name);
            //psIdUserIdMap.put(prodSpecialityObj.Product_Specialty__c,prodSpecialityObj.User__c);
        }
        List<User> updatePSforUserList=new List<User>();
        for( User userPSObj: [Select Proudct_speciality__c from User where Id IN :userToProductSpecMap.keySet()]){
            //Assiging Product speciality to users at User Object
            userPSObj.Proudct_speciality__c = userToProductSpecMap.get(userPSObj.Id);
            updatePSforUserList.add(userPSObj);
        }
        try{
             update updatePSforUserList;
        }catch(Exception excp){
            system.debug('Exception found while updating records for User Specialty text field Updating Specialty Record '+excp.getMessage());
        }
       
    }
    
    /*
     * @Description: Mehthod for validating whether the User is having single specialty or not.
     *
     */
     public static void executeUniqueUserCheck(List<Product_Specialty_User_Assignment__c> spcltyUserList){
        
        Map<Product_Specialty_User_Assignment__c,Set<Id>> spcltyObjUserIdSetMap = new Map<Product_Specialty_User_Assignment__c,Set<Id>>();
        Set<Id> userIdSet = new Set<Id>();
        for(Product_Specialty_User_Assignment__c spcltyUserObj : spcltyUserList){
            userIdSet.add(spcltyUserObj.User__c);
            
            Set<Id> userSet = spcltyObjUserIdSetMap.get(spcltyUserObj);
            if(userSet == null){
                userSet = new Set<Id>();
            }
            userSet.add(spcltyUserObj.User__c);
            
            spcltyObjUserIdSetMap.put(spcltyUserObj,userSet);
        }
        
        Set<Id> fetchedUserIdSet = new Set<Id>();
        Map<Id,String> userSpecialtyNameMap = new Map<Id,String>();
        for(Product_Specialty_User_Assignment__c obj : [Select p.User__c, p.Product_Specialty__c, p.Product_Specialty__r.Name, p.Id From Product_Specialty_User_Assignment__c p 
                                                            Where p.User__c In : userIdSet and To_Be_Deleted__C = false]){
            fetchedUserIdSet.add(obj.User__c);
            userSpecialtyNameMap.put(obj.User__c,obj.Product_Specialty__r.Name);
        }
        
        for(Product_Specialty_User_Assignment__c obj : spcltyObjUserIdSetMap.keySet()){
            if(spcltyObjUserIdSetMap.get(obj) != null){
                for(Id userId : spcltyObjUserIdSetMap.get(obj)){
                    if(fetchedUserIdSet != null && fetchedUserIdSet.contains(userId)){
                        obj.User__c.addError('Record can not be saved. User already associated to Specialty: ' +userSpecialtyNameMap.get(userId));
                    }
                }
            }
        }
     }
     
     //TM:ALM5362:Sreenath:fixing error of modifing speciality user on update starts
     /*
     * @Description: Mehthod for validating whether the User is having single specialty or not in case of Updation
     *
     */
     public static void executeUniqueUserCheckupdate(Map<Id,Product_Specialty_User_Assignment__c> psuaNewMap, Map<Id,Product_Specialty_User_Assignment__c> psuaOldMap){
        Map<Product_Specialty_User_Assignment__c,Set<Id>> spcltyObjUserIdSetMap = new Map<Product_Specialty_User_Assignment__c,Set<Id>>();
        Set<Id> userIdSet = new Set<Id>();
        for(Id psuaId: psuaNewMap.keyset()){
        userIdSet.add(psuaNewMap.get(psuaId).User__c);
            if(psuaNewMap.get(psuaId).User__c != psuaOldMap.get(psuaId).User__c){                  
                Set<Id> Userset = spcltyObjUserIdSetMap.get(psuaNewMap.get(psuaId));
                if(Userset == null){
                    Userset = new SET<Id>();
                }
                Userset.add(psuaNewMap.get(psuaId).User__c);
                spcltyObjUserIdSetMap.put(psuaNewMap.get(psuaId),Userset);
            }
        }  
        Set<Id> fetchedUserIdSet = new Set<Id>();
        Map<Id,String> userSpecialtyNameMap = new Map<Id,String>();
        for(Product_Specialty_User_Assignment__c obj : [Select p.User__c, p.Product_Specialty__c, p.Product_Specialty__r.Name, p.Id From Product_Specialty_User_Assignment__c p 
                                                            Where p.User__c In : userIdSet and To_Be_Deleted__C = false]){
            fetchedUserIdSet.add(obj.User__c);
            userSpecialtyNameMap.put(obj.User__c,obj.Product_Specialty__r.Name);
        }
        
        for(Product_Specialty_User_Assignment__c obj : spcltyObjUserIdSetMap.keySet()){
            if(spcltyObjUserIdSetMap.get(obj) != null){
                for(Id userId : spcltyObjUserIdSetMap.get(obj)){
                    if(fetchedUserIdSet != null && fetchedUserIdSet.contains(userId)){
                        obj.User__c.addError('Record can not be saved. User already associated to Specialty: ' +userSpecialtyNameMap.get(userId));
                    }
                }
            }
        }
    }
     //TM:ALM5362:Sreenath:fixing error of modifing speciality user on update ends
     
     /*
      * @Description: Method for Validating Specialty Definition Uniquenes
      *  It checks for 'ALL' values of RTM and OT Also.
      */
    public static void controlSpecialtyDefinitionUniqueness(List<Product_Specialty_Definition__c> triggerList){
        
        Set<Id> productSet = new Set<Id>();
        Set<Id> specialtySet = new Set<Id>();
        for(Product_Specialty_Definition__c defObj : triggerList){
            productSet.add(defObj.Product__c);
            specialtySet.add(defObj.Product_Specialty__c);
        }
    
        for(Product_Specialty_Definition__c defObj : [Select p.Route__c, p.Product__c, p.Product_Specialty__c, p.Opportunity_Type__c 
                                                            From Product_Specialty_Definition__c p Where p.Product__c In : productSet And p.Product_Specialty__c In : specialtySet]){
            
            for(Product_Specialty_Definition__c defTrigger : triggerList){
                
                if(defTrigger.Product_Specialty__c == defObj.Product_Specialty__c && (defTrigger.Product__c != null && defTrigger.Product__c == defObj.Product__c)){
                    if((defObj.Route__c != null && ('ALL').equalsIgnoreCase(defObj.Route__c)) &&
                            (defObj.Opportunity_Type__c != null && ('ALL').equalsIgnoreCase(defObj.Opportunity_Type__c))){
                        defTrigger.addError('Definition for this Product is already present with Opportunity Type as ALL and Route To Market as ALL');
                    }else if((defObj.Route__c != null && ('ALL').equalsIgnoreCase(defObj.Route__c)) &&
                                (defObj.Opportunity_Type__c != null && defObj.Opportunity_Type__c.equalsIgnoreCase(defTrigger.Opportunity_Type__c))){
                        defTrigger.addError('Definition for this Product is already present with Route To Market as ALL');
                    }else if((defObj.Opportunity_Type__c != null && ('ALL').equalsIgnoreCase(defObj.Opportunity_Type__c)) &&
                                (defObj.Route__c != null && defObj.Route__c.equalsIgnoreCase(defTrigger.Route__c))){
                        defTrigger.addError('Definition for this Product is already present with Opportunity Type as ALL'); 
                    }else if((defObj.Route__c != null && defObj.Route__c == defTrigger.Route__c) && 
                                (defObj.Opportunity_Type__c != null && defObj.Opportunity_Type__c == defTrigger.Opportunity_Type__c)){
                        defTrigger.addError('The Similar definition is already present for the same Product'); 
                    }
                }
            }                                               
        }
    }

}