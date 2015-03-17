public class OpportunityTriggerHandlerPartner {
 
  // update the primary partner when new records are inserted from trigger
  public void OnAfterInsert(List<Channel_Partner__c> newRecords){
    updatePrimarypartner(newRecords); 
    //updateIncumbentCompetitor(newRecords); 
  }
 
  // update the primary partner when records are updated from trigger  
  public void OnAfterUpdate(List<Channel_Partner__c> oldRecords, 
      List<Channel_Partner__c> updatedRecords,  Map<ID, Channel_Partner__c> oldMap, 
      Map<ID, Channel_Partner__c> newMap){
    updatePrimarypartner(updatedRecords); 
  }
 public void OnAfterDelete(List<Channel_Partner__c> oldRecords, 
      List<Channel_Partner__c> updatedRecords,  Map<ID, Channel_Partner__c> oldMap, 
      Map<ID, Channel_Partner__c> newMap){
    updatePrimarypartner(oldRecords); 
  }

 
 
  // updates the Opportunity with the primary partner
  private void updatePrimarypartner(List<Channel_Partner__c> PartnerNewList) {
 
      Map<Id,Channel_Partner__c> optyPrinaryPartnerMap = new Map<Id,Channel_Partner__c>();
        
        
        Set<id> optyIdSet = new Set<id>();
         for(Channel_Partner__c part : partnerNewList){
            if(part.Opportunity__c!=null){
                optyIdSet.add(part.Opportunity__c);
            }
        }
        
        system.debug('oppty id set ='+optyidset);
        
        if(optyIdSet!=null && optyIdSet.size()>0){
            
            List<Channel_Partner__c> PartnerList = [select Id,Channel_Partner__c,Primary__c,Opportunity__c from Channel_Partner__c where Opportunity__c In: optyIdSet and Primary__c=True];
            
            if(PartnerList!=null && PartnerList.size()>0){
                for(Channel_Partner__c primaryPartner: PartnerList){
                    optyPrinaryPartnerMap.put(primaryPartner.Opportunity__c,primaryPartner);
                    
                 }
            }

            
                        
            Map<id,opportunity> opplistmap=new Map<id,opportunity>();
            List<opportunity> opplist=[select id,name,primary_Partner__c from opportunity where id in :optyIdSet];
            system.debug('second opportunitu list:opplist'+opplist);


            for(opportunity op:opplist){
            opplistmap.put(op.id,op);  
            system.debug('Opportunity object list map'+opplistmap);         
            }
            
                 for(Channel_Partner__c Part : PartnerNewList){
                if(optyPrinaryPartnerMap.containsKey(Part.Opportunity__c)){
                    
                    opplistmap.get(Part.opportunity__c).Primary_Partner__c=optyPrinaryPartnerMap.get(Part.Opportunity__c).Channel_Partner__c;
                }
                            
                Else{
                    opplistmap.get(Part.opportunity__c).Primary_Partner__c = null;
                }
                
            }
            try{
            update opplist;}
            catch(Exception e)
            {}
            
        }
    }
 
}