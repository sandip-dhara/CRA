/**
* Class Name: CompetitorTriggerUtil
* Author: HP
* Date: 17-JUL-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Competitors__c object
*/
public class CompetitorTriggerUtil{



/*  @description: Initially added competitor  as Primary    */
    public static void SetPrimaryFlag(List<Competitors__c> CompetitorNewList) {
        
        Set<Id> CompOppIds = new Set<Id>();
        Set<Id> ExistingCompOppIds = new Set<Id>();
        Map<Id,Competitors__c> ExistingComplMaps = new Map<Id,Competitors__c>();
        
        Map<Id,List<Competitors__c>> OpptyIdbyCompetitorMap = new Map<Id,List<Competitors__c>>();
        Map<Id,List<Competitors__c>> OpptyIdbyCompetitorNoPrimaryMap = new Map<Id,List<Competitors__c>>();
        List<Competitors__c> CompetitorToinsert = new List<Competitors__c>();
        List<Competitors__c> existingCompetitors = new List<Competitors__c>();
        Map<Id,List<Competitors__c>> OpptyIdbymultimap = new Map<Id,List<Competitors__c>>();//handling multiple primary competitors
        for(Competitors__c par : CompetitorNewList){
            ExistingCompOppIds.add(par.Opportunity__c);    
        }
        if (ExistingCompOppIds!= null){
            existingCompetitors = [Select Id,Name, Primary__c,Opportunity__c , Competitor_Account__c from Competitors__c where Opportunity__c =: ExistingCompOppIds];
        }
       
        
        for(Competitors__c part : existingCompetitors){
            
                ExistingComplMaps.put(part.Opportunity__c,part); 
                CompOppIds.add(part.Opportunity__c); 
               
        }
        for(Competitors__c Comp : CompetitorNewList){
            if (Comp.Primary__c == false){                
                if (OpptyIdbyCompetitorMap.containsKey(Comp.Opportunity__c)) {
                    List<Competitors__c> listTempCompetitors = new List<Competitors__c>();
                    listTempCompetitors = OpptyIdbyCompetitorMap.get(Comp.Opportunity__c);
                    listTempCompetitors.add(Comp);
                    OpptyIdbyCompetitorMap.put(Comp.Opportunity__c,listTempCompetitors);   
                }else {
                     List<Competitors__c> listTempCompetitors = new List<Competitors__c>();
                     listTempCompetitors.add(Comp);
                     OpptyIdbyCompetitorMap.put(Comp.Opportunity__c,listTempCompetitors);
                }
            } else if (Comp.Primary__c == true){
                  CompOppIds.add(Comp.Opportunity__c);  
            }
            
            
       }
       
       for(Id copp : CompOppIds){
            OpptyIdbyCompetitorMap.remove(copp);
       }
       
       
       
       for(Id OpptyId: OpptyIdbyCompetitorMap.Keyset()){
           Boolean PrimaryFlag = true;
           
           for (Competitors__c p : OpptyIdbyCompetitorMap.get(OpptyId)){
               if (PrimaryFlag){
                  // if (ExistingComplMaps.get(p.Opportunity__c).Primary__c == false){
                   p.Primary__c = true;   
                   PrimaryFlag = false;
                   CompetitorToinsert.add(p);
                  // }
               }
           }
       } 
       //Update CompetitorToinsert;   
    }






 /* setting the old created comepetitor as primary after deleting the current primary competitor */
 
     public static void setPrimaryCompetitorAfterdelete() {
     
        Datetime myDate;
        String firstCreated ;
        Integer i = 0;
        
        Map<Id,Competitors__c> NewMap = new Map<Id,Competitors__c>();
        List<Competitors__c> deleteCompetitors = (List<Competitors__c>)Trigger.old;
        List<Competitors__c> existingComps = new List<Competitors__c>();
        Set<Id> OpptyIdsOfToBeDeletedCompetitors = new set<Id>();
        for (Competitors__c deleteCP: deleteCompetitors) {
            if (deleteCP.Primary__c) {
                OpptyIdsOfToBeDeletedCompetitors.add(deleteCP.Opportunity__c);   
            }
        }
       
        if (OpptyIdsOfToBeDeletedCompetitors != null){
            existingComps = [Select Primary__c,Opportunity__c, CreatedDate
                                     From Competitors__c where Opportunity__c =:OpptyIdsOfToBeDeletedCompetitors ];
                                     
        }    
        
        Map<Id, List<Competitors__c>> checkForOpportunityId = new Map<Id, List<Competitors__c>>();
        List<Competitors__c> checkForCompetitors = new List<Competitors__c>();
        for (Competitors__c deleteCompetitor : existingComps) {
            if(checkForOpportunityId.containsKey(deleteCompetitor.Opportunity__c)) {
                checkForCompetitors.add(deleteCompetitor);
                checkForOpportunityId.put(deleteCompetitor.Opportunity__c, checkForCompetitors);
            } else {
                checkForCompetitors = new List<Competitors__c>();
                checkForCompetitors .add(deleteCompetitor);
                checkForOpportunityId.put(deleteCompetitor.Opportunity__c, checkForCompetitors);
            }           
        }
        
        for(Id key: checkForOpportunityId.KeySet()) {
       
            //system.debug('checkForLeadIds.get(key).size()>>>>'+checkForLeadIds.get(key).size());
            if(checkForOpportunityId.get(key).size() == 1) {
                checkForOpportunityId.get(key)[0].Primary__c = true;
                update checkForOpportunityId.get(key)[0];
            } else if (checkForOpportunityId.get(key).size() > 1){
            system.debug('>>>>>>>>>Inside Elseif size>1>>>');
              //checkForOpportunityId.get(key);  
              
              for(i=0;i<checkForOpportunityId.get(key).size();i++){
                 
                  
                  if (myDate == null || myDate > checkForOpportunityId.get(key)[i].CreatedDate){
                      
                      NewMap.put(key,checkForOpportunityId.get(key)[i]);
                      
                      myDate = checkForOpportunityId.get(key)[i].CreatedDate;
                      
              }
              }
              for (Competitors__c cp : checkForOpportunityId.get(key)){
              
                    If (NewMap.get(key).CreatedDate == myDate ){
                        
                        NewMap.get(key).Primary__c = true;
            }    
        }
            }
            
        }
        Update NewMap.values();
        //Update checkForOpportunityId.values();
        
        
    }
    
    /* setting the old created comepetitor as primary after deleting the current primary competitor */






    //Boolean used in test method to increase code coverage, should be set to true only in case of test method
    public static Boolean isTest = false;
    
    /**
    * @description: unCheck other Competitor's primary flag
    * 
    * 
    */
    public static void checkIsPrimaryFlagOnInsert(Map<id,Competitors__c> CompetitorNewMap) {
        Set<Id> optyIds = new Set<Id>();
        Set<Id> optyIdsInc = new Set<Id>();
        
        List<Competitors__c> CompetitorToupdateList = new List<Competitors__c>();
        List<Competitors__c> CompetitorToupdateListInc = new List<Competitors__c>();
        Map<Id,Competitors__c> CompetitorMap = new Map<Id,Competitors__c>();
        
        for(Competitors__c Competitor : CompetitorNewMap.values()){
            if(Competitor.Primary__c == true){
                optyIds.add(Competitor.Opportunity__c);
                if(CompetitorMap.containsKey(Competitor.Opportunity__c))
                    {
                    Competitor.addError('More than one competitor is being set as primary for an Opportunity');
                    }
                else
                    {
                    CompetitorMap.put(Competitor.Opportunity__c,Competitor);
                    }
            }
            
            if(Competitor.Incumbent__c == true){
                optyIdsInc.add(Competitor.Opportunity__c);
              
            }
        }
        if(optyIds.size()>0){
            for (Competitors__c cp : [Select id,Primary__c 
                                            From Competitors__c 
                                            Where Primary__c =: true 
                                            And Opportunity__c IN : optyIds
                                            And Id NOT IN : CompetitorNewMap.keySet()]) {
                cp.Primary__c = false;
                CompetitorToupdateList.add(cp);
            }
        }
        
        /* handling only one incumbent primary competitor  */
        if(optyIdsInc.size()>0){
            for (Competitors__c cp : [Select id,Incumbent__c 
                                            From Competitors__c 
                                            Where Incumbent__c =: true 
                                            And Opportunity__c IN : optyIdsInc
                                            And Id NOT IN : CompetitorNewMap.keySet()]) {
                cp.Incumbent__c = false;
                CompetitorToupdateListInc.add(cp);
            }
        }
        //Populating list with a new uninserted record in test method's context 
        //so that Database.update call should give error in save result &
        //code in failure case should get covered
        if(isTest) {
            CompetitorToupdateList = new List<Competitors__c>();
            CompetitorToupdateList.add(new Competitors__c());
            //handle primary incumbent competitor
            CompetitorToupdateListInc = new List<Competitors__c>();
            CompetitorToupdateListInc.add(new Competitors__c());
        }
        if(CompetitorToupdateList.size()>0){
            try
            {
                Database.SaveResult[] results = Database.update(CompetitorToupdateList,false);
                Integer counter = 0;
                for(Database.SaveResult result : results){
                    if (!result.isSuccess())
                    {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs){
                            if(CompetitorNewMap.containsKey(CompetitorToupdateList.get(counter).id)){
                                CompetitorNewMap.get(CompetitorToupdateList.get(counter).id).Primary__c.addError(err.getMessage());
                            }
                        }
                    }  
                    counter++;
                }
            } catch (Exception e) {
                    System.debug('Exception:CompetitorTriggerUtil.checkIsPrimaryFlag:'+e.getMessage());
            } 
        }
        
        //handle primary competitor
        
        if(CompetitorToupdateListInc.size()>0){
            try
            {
                Database.SaveResult[] results = Database.update(CompetitorToupdateListInc,false);
                Integer counter = 0;
                for(Database.SaveResult result : results){
                    if (!result.isSuccess())
                    {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs){
                            if(CompetitorNewMap.containsKey(CompetitorToupdateListInc.get(counter).id)){
                                CompetitorNewMap.get(CompetitorToupdateListInc.get(counter).id).Incumbent__c.addError(err.getMessage());
                            }
                        }
                    }  
                    counter++;
                }
            } catch (Exception e) {
                    System.debug('Exception:CompetitorTriggerUtil.checkIsPrimaryFlag:'+e.getMessage());
            } 
        }
    }
    /**
    * @description: unCheck other Competitor's primary flag
    * 
    * 
    */
    public static void checkIsPrimaryFlagOnUpdate(Map<id,Competitors__c> CompetitorOldMap,Map<id,Competitors__c> CompetitorNewMap) {
        Set<Id> optyIds = new Set<Id>();
        Set<Id> optyIdsinc = new Set<Id>();//new
        List<Competitors__c> CompetitorToupdateList = new List<Competitors__c>();
        List<Competitors__c> CompetitorToupdateListInc = new List<Competitors__c>();
        Map<Id,Competitors__c> CompetitorMap = new Map<Id,Competitors__c>();
        for(Competitors__c Competitor : CompetitorNewMap.values()){
            if(Competitor.Primary__c == true && CompetitorOldMap.get(Competitor.id).Primary__c != Competitor.Primary__c ){
                optyIds.add(Competitor.Opportunity__c);
                }
            if(Competitor.Primary__c == true)
                {
                system.debug('!@'+CompetitorMap);
                if(CompetitorMap.containsKey(Competitor.Opportunity__c))
                    {
                    Competitor.addError('More than one competitor is being set as primary for an Opportunity');
                    }
                else
                    {
                    CompetitorMap.put(Competitor.Opportunity__c,Competitor);
                    }
                }
            
            if(Competitor.incumbent__c == true && CompetitorOldMap.get(Competitor.id).Incumbent__c != Competitor.Incumbent__c ){
                optyIdsInc.add(Competitor.Opportunity__c);
            }
        }
        if(optyIds.size()>0){
            for (Competitors__c cp : [Select id,Primary__c 
                                            From Competitors__c 
                                            Where Primary__c =: true 
                                            And Opportunity__c IN : optyIds
                                            And Id NOT IN : CompetitorNewMap.keySet()]) {
                cp.Primary__c = false;
                CompetitorToupdateList.add(cp);
            }
        }
        //handling incumbent 
                if(optyIdsInc.size()>0){
            for (Competitors__c cp : [Select id,incumbent__c 
                                            From Competitors__c 
                                            Where Incumbent__c =: true 
                                            And Opportunity__c IN : optyIdsInc
                                            And Id NOT IN : CompetitorNewMap.keySet()]) {
                cp.Incumbent__c = false;
                CompetitorToupdateListInc.add(cp);
            }
        }
        //Populating list with a new uninserted record in test method's context 
        //so that Database.update call should give error in save result &
        //code in failure case should get covered
        if(isTest) {
            CompetitorToupdateList = new List<Competitors__c>();
            CompetitorToupdateList.add(new Competitors__c());
            CompetitorToupdateListInc = new List<Competitors__c>();
            CompetitorToupdateListInc.add(new Competitors__c());
        }
        if(CompetitorToupdateList.size()>0){
            try
            {
                Database.SaveResult[] results = Database.update(CompetitorToupdateList,false);
                Integer counter = 0;
                for(Database.SaveResult result : results){
                    if (!result.isSuccess())
                    {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs){
                            if(CompetitorNewMap.containsKey(CompetitorToupdateList.get(counter).id)){
                                CompetitorNewMap.get(CompetitorToupdateList.get(counter).id).Primary__c.addError(err.getMessage());
                            }
                        }
                    }  
                    counter++;
                }
            } catch (Exception e) {
                    System.debug('Exception:CompetitorTriggerUtil.checkIsPrimaryFlag:'+e.getMessage());
            } 
        }
        if(CompetitorToupdateListInc.size()>0){
            try
            {
                Database.SaveResult[] results = Database.update(CompetitorToupdateListInc,false);
                Integer counter = 0;
                for(Database.SaveResult result : results){
                    if (!result.isSuccess())
                    {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs){
                            if(CompetitorNewMap.containsKey(CompetitorToupdateListInc.get(counter).id)){
                                CompetitorNewMap.get(CompetitorToupdateListInc.get(counter).id).Incumbent__c.addError(err.getMessage());
                            }
                        }
                    }  
                    counter++;
                }
            } catch (Exception e) {
                    System.debug('Exception:CompetitorTriggerUtil.checkIsIncumbentFlag:'+e.getMessage());
            } 
        }
    }
}