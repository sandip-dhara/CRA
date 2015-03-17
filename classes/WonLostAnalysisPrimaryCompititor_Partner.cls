Public Class WonLostAnalysisPrimaryCompititor_Partner
{


public static Set<id> setOptyIds(List<Won_Lost_Analysis__c> WonLostAnalysisNewList){
        Set<id> optyIdSet = new Set<id>();
         for(Won_Lost_Analysis__c Wonlost : WonLostAnalysisNewList){
            if(Wonlost.Opportunity__c!=null){
                optyIdSet.add(Wonlost.Opportunity__c);
            }
        }
        return optyIdSet;
    }
    
    public static void populateLookupFields(List<Won_Lost_Analysis__c> WonLostAnalysisNewList,Set<id> optyIdSet){
        Map<Id,Id> optyPrinaryPartnerMap = new Map<Id,Id>();
        Map<Id,Id> optyPrinaryCompetitorMap = new Map<Id,Id>();
        Map<Id,Id> optyIncumbentCompetitorMap = new Map<Id,Id>();
        
        if(optyIdSet!=null && optyIdSet.size()>0){
            List<Competitors__c> CompetitorsList = [select Id,Competitor_Account__c,Primary__c,Incumbent__c,Opportunity__c from Competitors__c where Opportunity__c In: optyIdSet];
            
            if(CompetitorsList!=null && CompetitorsList.size()>0){
                for(Competitors__c Competitor: CompetitorsList){
                    if(Competitor.Primary__c == true){
                        optyPrinaryCompetitorMap.put(Competitor.Opportunity__c,Competitor.Competitor_Account__c);
                    }
                    if(Competitor.Incumbent__c == true){
                        optyIncumbentCompetitorMap.put(Competitor.Opportunity__c,Competitor.Competitor_Account__c);
                    }
                }
            }
            
            List<Channel_Partner__c> PartnerList = [select Id,Channel_Partner__c,Primary__c,Opportunity__c from Channel_Partner__c where Opportunity__c In: optyIdSet and Primary__c=True];
            
            if(PartnerList!=null && PartnerList.size()>0){
                for(Channel_Partner__c primaryPartner: PartnerList){
                    optyPrinaryPartnerMap.put(primaryPartner.Opportunity__c,primaryPartner.Channel_Partner__c);
                }
            }
            for(Won_Lost_Analysis__c Wonlost : WonLostAnalysisNewList){
                if(optyPrinaryCompetitorMap.containsKey(Wonlost.Opportunity__c)){
                    Wonlost.Primary_Competitor__c=optyPrinaryCompetitorMap.get(Wonlost.Opportunity__c);
                }
                            
                Else{
                    Wonlost.Primary_Competitor__c = null;
                }
                if(optyIncumbentCompetitorMap.containsKey(Wonlost.Opportunity__c)){
                    Wonlost.Incumbent_Competitor__c = optyIncumbentCompetitorMap.get(Wonlost.Opportunity__c);
                }
                Else{
                    Wonlost.Incumbent_Competitor__c = null;
                }

                if(optyPrinaryPartnerMap.containsKey(Wonlost.Opportunity__c)){
                    Wonlost.Partner__c=optyPrinaryPartnerMap.get(Wonlost.Opportunity__c);
                }
                Else{
                    Wonlost.Partner__c = null;
                }


            }
        }
    }
    
   public static void wonlostcreationPrevent(List<Won_Lost_Analysis__c> WonLostlist){

        for (Won_Lost_Analysis__c Wonlost : wonlostlist) {
         
           List<Won_Lost_Analysis__c> WonLostId = new List<Won_Lost_Analysis__c>();
          //Returning WonLost Id WonLost Analysis Record
           try{
           WonLostId = [Select Id from Won_Lost_Analysis__c where Opportunity__c = :Wonlost.Opportunity__c];
           }
           catch(Exception e){
           wonlostid=null;
           }
           //Checking wheather Won/Lost Analysis Record Exist
           //If Exist,will not allow user to create one more
           if (WonLostId.size()  != 0)
           {
            Wonlost .addError('Can Not Create more than one WonLost Analysis Record');
           }
            
          }

    } 
    
}