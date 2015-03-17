/**
* Trigger Name: RenewalUpdateAutoSync 
* Author: Accenture
* Date: 08-AUG-2012 
* Description: To update the Auto Sync flag to "False", for update/delete operation on line item.
*/

trigger RenewalUpdateAutoSync on OpportunityLineItem (after update, after delete) {
    // This condition will not allow Interface user to update the Auot Sync flag.
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
    Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
    List<Opportunity> opptyList = new List<Opportunity>();
    Set<Opportunity> updateoppty = new set<Opportunity>();
    Map<Id,Opportunity> opps = new Map<id,opportunity>();
    
    try{
        if (Trigger.isUpdate){     
           for(OpportunityLineItem oli: Trigger.New){
            if(oli.Contract__c != null){
                  opps.put(oli.opportunityid,new opportunity(id=oli.opportunityid));              
                  opps.get(oli.opportunityid).SAP_Feed__c = False;
                  updateoppty.add(opps.get(oli.opportunityid));
            }             
           }
        }
        
        if (Trigger.isDelete){     
           for(OpportunityLineItem oli: Trigger.old){
              if(oli.Contract__c != null){
                  opps.put(oli.opportunityid,new opportunity(id=oli.opportunityid));        
                  opps.get(oli.opportunityid).SAP_Feed__c = False;
                  updateoppty.add(opps.get(oli.opportunityid));
              }           
           }
        }
                      
      
        if(updateoppty.size()>0){
            opptyList.addall(updateoppty);    
            update opptyList;
        }
    
    } catch(Exception ex) {
            System.debug(' Exception Occured' + ex);
    }
}