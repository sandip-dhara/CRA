public with sharing class OpportunityTriggerHandler {
 
  // update the primary country when new records are inserted from trigger
  public void OnAfterInsert(List<Competitors__c> newRecords){
    updatePrimaryCompetitor(newRecords); 
    //updateIncumbentCompetitor(newRecords); 
  }
 
  // update the primary country when records are updated from trigger  
  public void OnAfterUpdate(List<Competitors__c> oldRecords, 
      List<Competitors__c> updatedRecords,  Map<ID, Competitors__c> oldMap, 
      Map<ID, Competitors__c> newMap){
    updatePrimaryCompetitor(updatedRecords); 
  }
 public void OnAfterDelete(List<Competitors__c> oldRecords, 
      List<Competitors__c> updatedRecords,  Map<ID, Competitors__c> oldMap, 
      Map<ID, Competitors__c> newMap){
    updatePrimaryCompetitor(oldRecords); 
  }

 
 
  // updates the Opportunity with the primary competitors
  private void updatePrimaryCompetitor(List<Competitors__c> CompetitorNewList) {
 
        //public static void populateLookupFields(List<Competitors__c> CompetitorNewList){
        //pulic Map<id,opportunity> opmap =new Map<id,opportunity>();
        Map<Id,competitors__c> optyPrinaryCompetitorMap = new Map<Id,competitors__c>();
        Map<Id,competitors__c> optyIncumbentCompetitorMap = new Map<Id,competitors__c>();
        
        Set<id> optyIdSet = new Set<id>();
         for(Competitors__c Comp : CompetitorNewList){
            if(Comp.Opportunity__c!=null){
                optyIdSet.add(Comp.Opportunity__c);
            }
        }
        
        system.debug('oppty id set ='+optyidset);
        
        if(optyIdSet!=null && optyIdSet.size()>0){
            List<Competitors__c> CompetitorsList = [select Id,Competitor_Account__c,Primary__c,Incumbent__c,Opportunity__c from Competitors__c where Opportunity__c In: optyIdSet];
            system.debug('competitor list'+competitorslist);
            if(CompetitorsList!=null && CompetitorsList.size()>0){
                for(Competitors__c Competitor: CompetitorsList){
                    if(Competitor.Primary__c == true){
                        optyPrinaryCompetitorMap.put(Competitor.Opportunity__c,Competitor);//Competitor.Competitor_Account__c
                    }
                    if(Competitor.Incumbent__c == true){
                        optyIncumbentCompetitorMap.put(Competitor.Opportunity__c,Competitor);
                    }
                }
            }
            
                        
            Map<id,opportunity> opplistmap=new Map<id,opportunity>();
            List<opportunity> opplist=[select id,name,Primary_Competitor__c,Incumbent_Competitor__c,primary_Partner__c from opportunity where id in :optyIdSet];
            system.debug('second opportunitu list:opplist'+opplist);


            for(opportunity op:opplist){
            opplistmap.put(op.id,op);  
            system.debug('Opportunity object list map'+opplistmap);         
            }
            
                 for(Competitors__c Comp : CompetitorNewList){
                if(optyPrinaryCompetitorMap.containsKey(Comp.Opportunity__c)){
                    System.debug('assigning primary competitor to opportunity');
                    system.debug('opportunity object data:'+opplistmap.get(comp.opportunity__c));
                    system.debug('Competitor object data: '+optyPrinaryCompetitorMap.get(Comp.Opportunity__c).id);
                    opplistmap.get(comp.opportunity__c).Primary_Competitor__c=optyPrinaryCompetitorMap.get(Comp.Opportunity__c).Competitor_Account__c;
                }
                            
                Else{
                    opplistmap.get(comp.opportunity__c).Primary_Competitor__c = null;
                }
                if(optyIncumbentCompetitorMap.containsKey(Comp.Opportunity__c)){
                    opplistmap.get(comp.opportunity__c).Incumbent_Competitor__c = optyIncumbentCompetitorMap.get(Comp.Opportunity__c).Competitor_Account__c;
                }
                Else{
                    opplistmap.get(comp.opportunity__c).Incumbent_Competitor__c = null;
                }

                
            }
            try{
            update opplist;}
            catch(Exception e)
            {}
            
        }
    }
 
}