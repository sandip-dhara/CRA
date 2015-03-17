/**
* Trigger Name: UniqueIMforOpp 
* Author: HP
* Date: 17-JAN-2013 
* Description: Prevent Creation of multiple IM for each Opportunity.
*/
trigger UniqueIMforOpp on Installation_Management__c (before Insert) {

    Set<Id> oppId = new Set<Id>(); 
    Set<Id> oppIdSet = new Set<Id>();   
    Map<Id,List<String>> OppIM = new Map<Id,List<String>>();
    List<String> stage = new List<String>();
    
    if(Trigger.New.size()>1){
    System.debug('Size is greater than 1');
        for(Installation_Management__c IM: Trigger.New){   
        if(OppIM.containsKey(IM.Opportunity__c))
        {
            OppIM.get(IM.Opportunity__c).add(IM.Installation_Stage__c);
            IM.addError('Only one Installation Management can be created per Opportunity');
        }
        else{
            stage.add(IM.Installation_Stage__c);
            OppIM.put(IM.Opportunity__c,stage);
        }

    }
 }
    
    else{
    System.debug('Size is 1');
    for(Installation_Management__c IM: Trigger.New){
        oppId.add(IM.opportunity__c);
    }
    }
    System.debug('**********oppId******************'+oppId);
    System.debug('**********OppIM******************'+OppIM);
    
    for(Installation_Management__c IM : [Select Id,Opportunity__c from Installation_Management__c where Opportunity__c IN:oppId OR Opportunity__c IN:OppIM.keySet()]){
        oppIdSet.add(IM.Opportunity__c);
    }
    
       System.debug('********oppIdSet******************'+oppIdSet);
     if(oppIdSet != null){
        for(Installation_Management__c IMT : Trigger.New){
            if(oppIdSet.contains(IMT.Opportunity__c)){
            IMT.addError('Only one Installation Management can be created per Opportunity');
            }
        }
    }
       


}