/**********************************************************
* Class Name: TerritoryManagementPostAssignment
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: Creates sharing entry in Account Share for Account matching to Sales T Definition with access level defined on Territory for Account, 
* Opportunity & Case.
***********************************************************/
public class TerritoryManagementPostAssignment {
    
    // Param - Map<Key : AccountId, Value : Set<Sales Territory Definition Object>>
    public static void postAssignmentforTM (Map<Id, List<Sales_Territory_Definition__c>> acntIdSTDMap){
        
        try
        {   
               
            Map<String, AccountShare> createAccShareMap = new Map<String, AccountShare>();
            Map<String, OpportunityShare> createOptyShareMap = new Map<String, OpportunityShare>();            
            Map<Id,List<Location__c>> accAssign = new   Map<Id,List<Location__c>>(); 
            Map<Id,List<Channel_Partner__c>> optyAssign = new   Map<Id,List<Channel_Partner__c>>();               
            RecordType rec = [select id,name from RecordType where name = 'Partner']; 
            Set<Id> accId = acntIdSTDMap.keyset();            
            Account tempAcc = [SELECT RecordTypeId FROM Account where id in :acntIdSTDMap.keyset() Limit 1];
            boolean isPartner = false;
            if(tempAcc.RecordTypeId == rec.id)
            {
                isPartner = true;                       
                List<Location__c> locAcc = [select id,Account__c from location__c where Account__c in :acntIdSTDMap.keySet()];
                //TM:CR-7525:Raghvendra:start
                List<Channel_Partner__c> optyList = [Select Id,Opportunity__c,Location__c From Channel_Partner__c where Location__c in :locAcc and opportunity__r.Account.Confidential_Account__c = false and opportunity__r.Confidential__c = false];
                //TM:CR-7525:Raghvendra:end
                
                for(Id aId : acntIdSTDMap.keySet())
                {
                    List<Location__c> tempLoc = new List<Location__c>();
                    for(integer i = 0 ; i<locAcc.size(); i++)
                    {
                        if(aid == locAcc[i].Account__c)
                        {
                            tempLoc.add(locAcc[i]);
                        }
                    }
                    accAssign.put(aid,tempLoc);
                }                   
                for(Location__c lId : locAcc)
                {
                    List<Channel_Partner__c> tempOpty = new List<Channel_Partner__c>();
                    for(integer i = 0 ; i<optyList.size(); i++)
                    {
                        if(lId.Id == optyList[i].Location__c)
                        {
                            tempOpty.add(optyList[i]);
                        }
                    }
                    optyAssign.put(lId.Id,tempOpty);
                }
            }                  
            for(Id aId : acntIdSTDMap.keySet())
            {                   
                for(Sales_Territory_Definition__c stdObj : acntIdSTDMap.get(aId))
                {
                    if(isPartner)
                    {                 
                        List<Location__c> locAcc = accAssign.get(aId);
                        if(locAcc !=null && locAcc.size()>0 )
                        {
                            for(Location__c locObj : locAcc)
                            {
                                List<Channel_Partner__c> optyList = optyAssign.get(locObj.Id);
                                if(optyList != null && optyList.size() > 0)
                                {
                                    for(Channel_Partner__c opty : optyList)
                                    {                                    
                                        if(opty != null)
                                        {                                        
                                            OpportunityShare optyShare = new OpportunityShare (OpportunityId = opty.Opportunity__c, 
                                                                            UserOrGroupId = stdObj.Sales_Territory__r.GroupId__c, 
                                                                            OpportunityAccessLevel = stdObj.Sales_Territory__r.Opportunity_Access__c);
    
                                            createOptyShareMap.put(''+opty.Id+'-' + stdObj.Sales_Territory__r.GroupId__c, optyShare);
                                          
                                         }
                                     }
                                  }                        
                               }
                            }     
                        }                    
                        if(isPartner == false && null !=stdObj.Sales_Territory__r.GroupId__c && stdObj.Sales_Territory__r.GroupId__c !='')
                        {
                            AccountShare accSh = new AccountShare (AccountId = aId, UserOrGroupId = stdObj.Sales_Territory__r.GroupId__c, 
                                                OpportunityAccessLevel = stdObj.Sales_Territory__r.Opportunity_Access__c, 
                                                CaseAccessLevel = stdObj.Sales_Territory__r.Case_Access__c, 
                                                AccountAccessLevel = stdObj.Sales_Territory__r.Account_Access__c);
                                                
                            createAccShareMap.put('' + aId + '-' + stdObj.Sales_Territory__r.GroupId__c, accSh);
                        }
                    }                
            }
            system.debug('****Check for Share List****' + createAccShareMap.size());
            
            if(!createAccShareMap.isEmpty()){
                database.insert(createAccShareMap.values(), false);
 
            } 
            
            system.debug('****Check for opty Share List****' + createOptyShareMap.size());
            if(!createOptyShareMap.isEmpty())
            {
                database.insert(createOptyShareMap.values(),false);
            }
            
            //Call for Add to Account team logic.
            //addToAccountTeamforTM(acntIdSTDMap);
            
        }catch(Exception e){
            system.debug('*****Exception in TerritoryManagementPostAssignment****' + e.getMessage());
        }
    }
    
    //Add to Account Team call for post TM.
    public static void addToAccountTeamforTM (Map<Id, List<Sales_Territory_Definition__c>> accIdSTDMap){
        
        try{
            Set<Id> salesTIdSet = new Set<Id>();
            
            Map<Id, Set<Id>> aIdSalesTIdMap = new Map<Id, Set<Id>>();
            Map<Id, Set<Sales_Territory_User_Assignment__c>> stIdUserAMap = new Map<Id, Set<Sales_Territory_User_Assignment__c>>();
            Map<Id, Set<Sales_Territory_User_Assignment__c>> accIdSTUserAObjMap = new Map<Id, Set<Sales_Territory_User_Assignment__c>>();
            
            // To create Map for Account Id & Sales Terr Set
            for(Id aId : accIdSTDMap.keySet()){
                
                Set<Id> tempIdSet = new Set<Id>();
                for(Sales_Territory_Definition__c stdObj : accIdSTDMap.get(aId)){
                    tempIdSet.add(stdObj.Sales_Territory__c);
                    salesTIdSet.add(stdObj.Sales_Territory__c);
                }
                aIdSalesTIdMap.put(aId, tempIdSet);
            }
            
            // To create Map for Sales Terr Id & Sales Terr User Assignment Set
            if(!salesTIdSet.isEmpty()){
                for(Sales_Territory_User_Assignment__c stuaObj : [Select User__c, User__r.IsActive, Sales_Territory__r.Case_Access__c, Sales_Territory__r.Opportunity_Access__c, 
                                                                    Sales_Territory__r.Account_Access__c, Sales_Territory__c, Account_Team_Role__c, Add_to_Account_Team__c From Sales_Territory_User_Assignment__c 
                                                                    where Sales_Territory__c IN : salesTIdSet AND Add_to_Account_Team__c = true AND IsActive__c = true ]){
                                                                        
                    Set<Sales_Territory_User_Assignment__c> tempSet = stIdUserAMap.get(stuaObj.Sales_Territory__c);
                    if(null == tempSet){
                        tempSet =  new Set<Sales_Territory_User_Assignment__c>();
                    }
                    tempSet.add(stuaObj);
                    stIdUserAMap.put(stuaObj.Sales_Territory__c, tempSet);
                }
            }
            
            // To create Map for Account Id & Sales Terr User Assignmnt Set                                                 
            for(Id accId : aIdSalesTIdMap.keySet()){
                Set<Sales_Territory_User_Assignment__c> tempSet = new Set<Sales_Territory_User_Assignment__c>();
                
                for(Id stId : aIdSalesTIdMap.get(accId)){
                    if(null != stIdUserAMap && null != stIdUserAMap.get(stId)){
                        tempSet.addAll(stIdUserAMap.get(stId));
                    }
                }
                if(!tempSet.isEmpty()){
                    accIdSTUserAObjMap.put(accId, tempSet);
                }
            }
            
            // To create Account Team Entry for User Assignment record having Add to Account Team Checked.
            List<AccountTeamMember> accountTeamList = new List<AccountTeamMember>();
            
            for(Id accId : accIdSTUserAObjMap.keySet()){
                
                for(Sales_Territory_User_Assignment__c stuaObj : accIdSTUserAObjMap.get(accId)){
                    
                    if(stuaObj.Add_to_Account_Team__c && stuaObj.User__r.IsActive){
                        accountTeamList.add(new AccountTeamMember (UserId = stuaObj.User__c, TeamMemberRole= stuaObj.Account_Team_Role__c , AccountId = accId));
                    }
                }
            }
            
            if(!accountTeamList.isEmpty()){
                database.insert(accountTeamList, false);
            } 
        }catch(Exception e){
            system.debug('*****Exception in addToAccountTeamforTM****' + e.getMessage());
        }
        
    }
    
    
    /**
    * ------To Delete Records except Manualy Assigned to Territory --------
    * ST Account Assignment (Account Id, Group ID)
    * Account Team (Account Id, ST User)
    * Account Share (Accnt Id & Group Id AND AccountId & User Id)
    **/
    
    public static void processCleanUp(Set<Id> accountId){
        try{        
            //TM:Debmalya: Req:2089: 24th Oct, 2012: Account association deletion moved to separate batch:Start
            /*List<Sales_Territory_Account_Assignment__c> stuaDelList = new List <Sales_Territory_Account_Assignment__c>();
            List<AccountTeamMember> accTeamToDel = new List<AccountTeamMember>();
            List<AccountShare> accShareToDel = new List<AccountShare>();
            Set<Id> accountToDel = new Set<Id>();
            Set<String> accIdGrpIdConSet = new Set<String>();
            Set<Id> grpRefrSet = new Set<Id>();
            
            //To Delete records in Sales_Territory_Account_Assignment__c.
            //TM:Sreenath: Req:2089: 15th Oct, 2012: Account association deletion moved to separate batch
            TerritoryDeltaChanges__c Terrchanges = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
            if(Terrchanges.Territory_Evaluation__c){
                for(Sales_Territory_Account_Assignment__c stua : [Select Id, Account__c, Sales_Territory__c, Sales_Territory__r.GroupId__c from Sales_Territory_Account_Assignment__c where Account__c in : accountId AND Assignment_Type__c = 'Territory Engine' and Sales_Territory__r.EvaluateTerritory_for_Realignment__c = true]){
                    stuaDelList.add(stua);
                    accountToDel.add(stua.Account__c);
                    grpRefrSet.add(stua.Sales_Territory__r.GroupId__c);
                    accIdGrpIdConSet.add('' + stua.Account__c + stua.Sales_Territory__r.GroupId__c);
                }
            }else{ 
            //TM:Sreenath: Req:2089: 15th Oct, 2012: End
            
                for(Sales_Territory_Account_Assignment__c stua : [Select Id, Account__c, Sales_Territory__c, Sales_Territory__r.GroupId__c from Sales_Territory_Account_Assignment__c where Account__c in : accountId AND Assignment_Type__c = 'Territory Engine']){
                    stuaDelList.add(stua);
                    accountToDel.add(stua.Account__c);
                    grpRefrSet.add(stua.Sales_Territory__r.GroupId__c);
                    accIdGrpIdConSet.add('' + stua.Account__c + stua.Sales_Territory__r.GroupId__c);
                }
            //TM:Sreenath: Req:2089: 15th Oct, 2012:adding closing braces.
            }
            if(!stuaDelList.isEmpty()){
                delete stuaDelList;
            }
            
            //To Delete records in AccountTeamMember.
            if(!accountToDel.isEmpty()){    
                for(AccountTeamMember accTeam : [Select Id from AccountTeamMember where AccountId in : accountToDel]){
                    accTeamToDel.add(accTeam);
                }
                if(!accTeamToDel.isEmpty()){
                    delete accTeamToDel;
                }
                
                //To Delete records in AccountShare.
                for(AccountShare accSh : [Select Id, AccountId, UserOrGroupId from AccountShare where AccountId IN : accountToDel AND UserOrGroupId IN : grpRefrSet AND (RowCause = 'Team' OR RowCause = 'Manual')]){
                    if(accIdGrpIdConSet.contains('' + accSh.AccountId + accSh.UserOrGroupId)){
                        accShareToDel.add(accSh);   
                    }       
                }
                if(!accShareToDel.isEmpty()){
                    delete accShareToDel;
                }
            }*/
            List<Sales_Territory_Account_Assignment__c> stuaUpdList = new List <Sales_Territory_Account_Assignment__c>();
            TerritoryDeltaChanges__c Terrchanges = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
            if(Terrchanges.Territory_Evaluation__c){
                for(Sales_Territory_Account_Assignment__c stua : [Select Id, TrackAssociationToDelete__c from Sales_Territory_Account_Assignment__c where Account__c in : accountId AND Assignment_Type__c = 'Territory Engine' and Sales_Territory__r.EvaluateTerritory_for_Realignment__c = true]){
                    stua.TrackAssociationToDelete__c = true;
                    stuaUpdList.add(stua);
                }
            }else{
                for(Sales_Territory_Account_Assignment__c stua : [Select Id, TrackAssociationToDelete__c from Sales_Territory_Account_Assignment__c where Account__c in : accountId AND Assignment_Type__c = 'Territory Engine']){
                    stua.TrackAssociationToDelete__c = true;
                    stuaUpdList.add(stua);
                }
            }
            if(!stuaUpdList.isEmpty()){
                database.update(stuaUpdList,true);
            }
            //TM:Debmalya: Req:2089: 24th Oct, 2012: Account association deletion moved to separate batch:End
        }catch(exception e){
            system.debug('*****Exception in cleanUpforUpdatedAccounts ***' + e.getMessage());
        }
    }
    
    // Method call to manually add Account To Territory.
    public static void manualAccountAssignment(List<Sales_Territory_Account_Assignment__c> TriggerNew){
        
        Set<String> tempSet = new Set<String>();    
        Set<String> tSet2 = new Set<String>();
        List<AccountShare> accShareList =new List<AccountShare>();
        Map<Id, ID> sTerrAccIdMap =  new Map<Id, Id>();
        try{
            for (Sales_Territory_Account_Assignment__c stuaObj: TriggerNew) {
                
                if(stuaObj.Assignment_Type__c != 'Territory Engine'){ 
                    stuaObj.Account_To_Territory_Id__c = '' + stuaObj.Account__c + '-' + stuaObj.Sales_Territory__c;
                    stuaObj.Assignment_Type__c = 'Manual';
                    tempSet.add(stuaObj.Account_To_Territory_Id__c);
                }
            }
            
            if(!tempSet.isEmpty()){
                for (Sales_Territory_Account_Assignment__c staaObj: [Select Id, Account_To_Territory_Id__c from Sales_Territory_Account_Assignment__c where Account_To_Territory_Id__c IN : tempSet]){
                    
                    tSet2.add(staaObj.Account_To_Territory_Id__c);
                }
         
                for (Sales_Territory_Account_Assignment__c  staaObj1: TriggerNew){
                    
                     if(!tSet2.isEmpty() && tSet2.contains(staaObj1.Account_To_Territory_Id__c)){
                        staaObj1.addError(' Cannot Save record : This Account already exists in this Territory.');
                     }
                     sTerrAccIdMap.put(staaObj1.Sales_Territory__c, staaObj1.Account__c);
                }
                        
                if(!sTerrAccIdMap.isEmpty()){               
                    for (Sales_Territory__c staaObj2: [Select Id, Account_Access__c, Case_Access__c, Opportunity_Access__c, GroupId__c from Sales_Territory__c where Id IN :sTerrAccIdMap.KeySet()]){
                            
                            AccountShare accShareObj=new AccountShare(AccountId = sTerrAccIdMap.get(staaObj2.Id),UserOrGroupId=staaObj2.GroupId__c, 
                                            OpportunityAccessLevel = staaObj2.Opportunity_Access__c, 
                                            CaseAccessLevel = staaObj2.Case_Access__c, 
                                            AccountAccessLevel = staaObj2.Account_Access__c) ;
                            accShareList.add(accShareObj);
                    }
            
                    if (!(accShareList.isEmpty()))  {
                        insert accShareList;
                    }   
                } 
            }
        } catch(Exception e){
            system.debug('****Exception in manualAccountAssignment Insert ****' + e.getMessage());
        }
    }
    
    // Method call to delete manually added Account To Territory.
    public static void manualAccountAssignmentDelete(List<Sales_Territory_Account_Assignment__c> TriggerOld){
        
        try{
            if(null != TriggerOld[0].Assignment_Type__c && TriggerOld[0].Assignment_Type__c == 'Manual'){
                Sales_Territory__c st = [Select Id, GroupId__c from Sales_Territory__c where Id =: TriggerOld[0].Sales_Territory__c limit 1];
                
                AccountShare aShareToDel = null;
                if(st !=null){
                    aShareToDel = [Select Id from AccountShare where AccountId =: TriggerOld[0].Account__c AND UserOrGroupId =: st.GroupId__c limit 1];
                }
                if(aShareToDel !=null){
                    delete aShareToDel;     
                }
            }
            
        } catch(Exception e){
            system.debug('****Exception in manualAccountAssignmentDelete ****' + e.getMessage());
        }
    }
}