/**
  * @author: rahul.kunal (Accenture)
  * HP_R2 Inhancements
  * New Class for retrieving User Ids for Account Ids associated to the Opportunity Ids
  */
  
public with sharing class OppAccntTerrUser {
    
    private static Set<Id> uniqueAccountSet = new Set<Id>();
    
    //TM Raghvendra :19/07/2013: Start
    private static Map<Id,set<Id>> partnrOppAccMap = new Map<Id,set<Id>>();
    //TM Raghvendra :19/07/2013: End
   
     /*
      * Method called for first time to drive the logic of User-Account retreival.
      * return type Map<Id,List<Id>>
      * Param: Set<Id> idSet, String objectType
      */
    public static Map<Id,Set<Id>> callFetchAccntUserLogic(Set<Id> idSet, String objectType){
         
         //system.debug('********class OppAccntTerrUser Method Enter callFetchAccntUserLogic*******');
         Map<Id,set<Id>> idAccountMap = new Map<Id,set<Id>>();
        
         if(objectType != null && objectType.equalsIgnoreCase('Opportunity')){
            idAccountMap = retrieveOppAccount(idSet);
            
         }else if(objectType != null && objectType.equalsIgnoreCase('Lead')){
            idAccountMap = retrieveLeadAccount(idSet);
         }
        //Retreive all the Account for the Opportunities
        
        
        //For all the above accounts find out the concerned groups 
        Set<Id> accountSet = new Set<Id>();
        //TM Nasir Jawed: R4 req:3906: 2/1/2013:
        for(Id tempoppId : idAccountMap.keyset()){
            accountSet.addAll(idAccountMap.get(tempoppId));
        }
        //TM Nasir Jawed:R4: End
        //accountSet.addAll(idAccountMap.values());
        Map<Id,List<Id>> accGrpMap = retrieveGrpforAccount(accountSet);
        
        //Find out all the Users Related to the Territory for the Account for the Opportunity and Return it
        Map<Id,Set<Id>> accntUserMap = retrieveUserForGrp(accGrpMap);
        
        //system.debug('********class OppAccntTerrUser Method Exit callFetchAccntUserLogic*******');
        //Map these Users to the corresponding Opportunity
        return mapIdToAccntTerrUser(idAccountMap,accntUserMap);
        
        
         
    }
    
     /*
      * Method for retrieving Account Ids as per the Opportunity Ids
      * return type Map<Id,List<Id>>
      * Param: Set<Id>
      */
    
    private static Map<Id,set<Id>> retrieveOppAccount(Set<Id> oppSet){
        
        //system.debug('********class OppAccntTerrUser Method retrieveOppAccount*******');
        //Store all the Account Ids Corresponding to the Oppo Ids in a Map
        Map<Id,set<Id>> oppAcntMap = new Map<Id,set<Id>>();
        
        for(Opportunity oppObj:[Select o.Id, o.AccountId From Opportunity o Where Id in: oppSet]){
            //TM Nasir Jawed: R4 req:3906: 2/1/2013:
            set<ID> accId= oppAcntMap.get(oppObj.Id);
            if(accId== null){               
                accId= new set<ID>();   
            }
            accId.add(oppObj.AccountId);
            //TM Nasir Jawed:R4:End
            oppAcntMap.put(oppObj.Id,accId);
            uniqueAccountSet.add(oppObj.AccountId);
            
        }
        //TM Nasir Jawed: R4 req:3906: 2/1/2013:  This query is to create a map of Opportunity Id and Account ID from channel partner object
        for(Channel_Partner__c cp:[select id,Opportunity__c,Channel_Partner__c from Channel_Partner__c where Opportunity__c IN:oppSet ]){
            set<ID> accId= oppAcntMap.get(cp.Opportunity__c);
            if(accId== null){               
                accId= new set<ID>();   
            }
            accId.add(cp.Channel_Partner__c);
            oppAcntMap.put(cp.Opportunity__c,accId);
            //TM:Raghvendra:ALM 10320 :Start
            partnrOppAccMap.put(cp.Opportunity__c, accId);
            //TM:Raghvendra:ALM 10320 :End
            uniqueAccountSet.add(cp.Channel_Partner__c);    
            
        }   
        //Nasir :End
        return oppAcntMap;
    }
    
    /*
      * Method for retrieving Account Ids as per the Opportunity Ids
      * return type Map<Id,List<Id>>
      * Param: Set<Id>
      */
    
    private static Map<Id,set<Id>> retrieveLeadAccount(Set<Id> leadSet){
        
        //system.debug('********class OppAccntTerrUser Method retrieveLeadAccount*******');
        //Store all the Account Ids Corresponding to the Oppo Ids in a Map
        Map<Id,set<Id>> leadAcntMap = new Map<Id,set<Id>>();
        for(Lead leadObj:[Select l.Id, l.Account_Name__c From Lead l where l.Id in: leadSet]){
            //TM Nasir Jawed: R4 req:3906: 2/1/2013: Changes was done for lead because we were
            // using map of IdMap<Id,Id>.Now we are using map of id and set(Map<Id,set<Id>>).Functionalities remains the same.
            
            set<ID> accId= leadAcntMap.get(leadObj.Id);
            if(accId== null){               
                accId= new set<ID>();   
            }
            accId.add(leadObj.Account_Name__c);
            //TM:Nasir Jawed:R4:End
            leadAcntMap.put(leadObj.Id,accId);
            uniqueAccountSet.add(leadObj.Account_Name__c);
        }
        //system.debug('leadAcntMap '+leadAcntMap);
        return leadAcntMap;
    }
    
     /*
      * Method for retrieving Group Ids as per the Account Ids
      * return type Map<Id,List<Id>>
      * Param: Set<Id>
      */
    private static Map<Id,List<Id>> retrieveGrpforAccount(Set<Id> accSet){
        
        //system.debug('********class OppAccntTerrUser Method retrieveGrpforAccount*******');
        //For the Account Ids found, find out the group Id associated hitting AccountShare object as it will have the mapping of account id and GroupId. 
        Map<Id,List<id>> accShareGrpMap = new Map<Id,List<Id>>();
        for(AccountShare accShareObj:[Select a.UserOrGroupId, a.AccountId, a.RowCause From AccountShare a where a.Accountid in : accSet And a.RowCause ='Manual']){
            //system.debug('Inside for accShareObj '+accShareObj);
            List<Id> grpList = accShareGrpMap.get(accShareObj.AccountId);
            if(null==grpList){
                grpList = new List<Id>();
            }
            grpList.add(accShareObj.UserOrGroupId);
            accShareGrpMap.put(accShareObj.AccountId,grpList);
        }
        //system.debug('Check1 '+accShareGrpMap);
        //TM:Raghvendra:ALM 10320 :Start
        //For the opty Ids found, find out the group Id associated hitting OpportunityShare object as it will have the mapping of account id and GroupId. 
        if((partnrOppAccMap.keySet() != null) && (partnrOppAccMap.size() >0)){
            for(OpportunityShare prtnrOppShare:[Select UserOrGroupId, OpportunityId From OpportunityShare where Opportunityid in : partnrOppAccMap.keySet() And RowCause ='Manual']){
                set<id> accIds = partnrOppAccMap.get(prtnrOppShare.OpportunityId);
                for(Id accId : accIds){
                    List<Id> usergrpList = accShareGrpMap.get(accId);
                    if(null==usergrpList){
                        usergrpList = new List<Id>();
                    }
                    usergrpList.add(prtnrOppShare.UserOrGroupId);
                    accShareGrpMap.put(accId, usergrpList); 
                }
            }
        }
        //TM:Raghvendra:ALM 10320 :End 
        return accShareGrpMap;
        
    }
    
     /*
      * Method for retrieving Users as per the Group Ids.
      * return type Map<Id,Set<Id>>.
      * Param: Map<Id,List<Id>>.
      */
    private static Map<Id,Set<Id>> retrieveUserForGrp(Map<Id,List<Id>> grpAccMap){
        
        //system.debug('********class OppAccntTerrUser Method retrieveUserForGrp******* '+grpAccMap);
        Set<Id> uniqueGrpSet = new Set<Id>();
        for(Id accId : grpAccMap.keySet()){
            uniqueGrpSet.addAll(grpAccMap.get(accId));
        }
        Map<Id,List<Id>> grpUserMap = new Map<Id,List<Id>>();
        //Find out the List of User for each group.
        for(GroupMember grpMemObj:[Select g.UserOrGroupId, g.GroupId From GroupMember g Where g.GroupId In : uniqueGrpSet]){
            //system.debug('Check inside for '+grpMemObj);
            List<Id> userList = grpUserMap.get(grpMemObj.GroupId);
            if(null == userList){
                userList = new List<Id>();
            }
            userList.add(grpMemObj.UserOrGroupId);
            grpUserMap.put(grpMemObj.GroupId,userList);
        }
        
        Map<Id,Set<Id>> finalAccUserMap = new Map<Id,Set<Id>>();
        //Iterate on Account Id to find out the Account to UserList Map
        for(Id idObj : grpAccMap.keySet())
        {
            //system.debug('Check null ');
            Set<Id> userSet = new Set<Id>();
            List<Id> grpIdList = grpAccMap.get(idObj);
            //system.debug('grpIdList  '+grpIdList);
            for(Id grpId:grpIdList){
                //system.debug('grpUserMap.get(grpId) '+grpUserMap.get(grpId));
                if(grpUserMap.get(grpId) != null){
                    userSet.addAll(grpUserMap.get(grpId));
                }
                
            }
            //Save Final Account USer Map   
            finalAccUserMap.put(idObj,userSet);
        }
        //system.debug('Check2 '+finalAccUserMap);
        //Return the Saved Map
        return finalAccUserMap;
    }
    
    /*
     * @Description: Method to create a seperate map for Opp Id and Set of Associates territory Users.
     * @Param: Map<Id,Id> idAccMap,Map<Id,Set<Id>> accUserMap
     */
    private static Map<Id,Set<Id>> mapIdToAccntTerrUser(Map<Id,set<Id>> idAccMap,Map<Id,Set<Id>> accUserMap){
        
        //system.debug('********class OppAccntTerrUser Method mapOppToAccntTerrUser Enter*******');
        //Now considering the users in account share object as well.
        for(AccountTeamMember acctTeamUserObj : [Select a.UserId, a.Id, a.AccountId From AccountTeamMember a Where a.AccountId In : uniqueAccountSet]){
            Set<Id> accntTeamUserSet = accUserMap.get(acctTeamUserObj.AccountId);
            if(null == accntTeamUserSet){
                accntTeamUserSet = new Set<Id>();
            }
            accntTeamUserSet.add(acctTeamUserObj.UserId);
            accUserMap.put(acctTeamUserObj.AccountId,accntTeamUserSet);
        }
        
        Map<Id,Set<Id>> finalIdTerrUsermap = new Map<Id,Set<Id>>();
        
        for(Id IdObj : idAccMap.keySet()){
            //finalIdTerrUsermap.put(IdObj,accUserMap.get(idAccMap.get(IdObj)));
            //TM Nasir Jawed: R4 req:3906: 2/1/2013:Start
            for(Id tempaccId : idAccMap.get(IdObj)){
                Set<Id> tempuserId = finalIdTerrUsermap.get(IdObj);
                if(tempuserId == null){
                    tempuserId = new Set<Id>();
                }
                if(accUserMap.get(tempaccId) != null){
                    tempuserId.addAll(accUserMap.get(tempaccId));
                    finalIdTerrUsermap.put(IdObj,tempuserId);
                }
            }
            //TM Nasir Jawed: End
        }
        //system.debug('********class OppAccntTerrUser Method mapOppToAccntTerrUser Exit*******');
        return finalIdTerrUsermap;
    }

}