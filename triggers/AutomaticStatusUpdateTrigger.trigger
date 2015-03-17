/*
* NAME : AutomaticStatusUpdateTrigger
* NOTE : Trigger to Update Status Progress of Parent Agreement if its all Child Agreements are Finished
		 Agreement is considered as finished when status/status progress is having following conditions
		 Cancelled/Cancelled,In Signature/Fully Signed,In Effect/Activated
		 set the status progress of parent agreement to 'Completed' if their all childs are finished
* Author : Apttus (Axay Varu) 19-04-2013 some one modified from HP - Akash Garg 4/26 
* 
*/
trigger AutomaticStatusUpdateTrigger on Apttus__APTS_Agreement__c (after update) {

    
    Boolean flag = false;
    List<Apttus__APTS_Agreement__c> updateParent = new List<Apttus__APTS_Agreement__c>();
    Set<Id> lstParentId = new Set<Id>();
    
    List<RecordType> lstRecordType = [Select Id,Name From RecordType where Name = 'Not Yet Selected'
                                        and SobjectType = 'Apttus__APTS_Agreement__c'];
                                        
    if(lstRecordType.size() > 0){
        for(Apttus__APTS_Agreement__c agmt : trigger.new){
            if(agmt.Apttus__Parent_Agreement__c != null)
            {
                lstParentId.add(agmt.Apttus__Parent_Agreement__c); //get all the parent Agreements from currently updated Agreement
                
            }
        } 
    }                                    
    
    if(lstParentId.size() > 0){
    List<Apttus__APTS_Agreement__c> lstChildAgreement = [SELECT ID,NAME,Apttus__Status_Category__c,Apttus__Status__c,Apttus__Parent_Agreement__c
    													 FROM Apttus__APTS_Agreement__c WHERE Apttus__Parent_Agreement__c = :lstParentId];
    													//This is list of child agreements for the Parent Agreement
    
        for(Apttus__APTS_Agreement__c agmt : lstChildAgreement ){
            
            updateParent = [SELECT ID,Apttus__Status__c,Apttus__Parent_Agreement__c   FROM Apttus__APTS_Agreement__c WHERE ID = :agmt.Apttus__Parent_Agreement__c AND RecordType.Name = :lstRecordType[0].Name LIMIT 1];
            //get list of parent to update
            
    if(agmt.Apttus__Status_Category__c == 'Cancelled' || (agmt.Apttus__Status_Category__c == 'In Signatures' && agmt.Apttus__Status__c == 'Fully Signed')  || (agmt.Apttus__Status_Category__c == 'In Effect' && agmt.Apttus__Status__c == 'Activated'))
    {
                flag = true;
        }
   else
  {
        flag = false;
        break;
       }
  }
        if(flag == TRUE && updateParent.size() > 0)
        {
            
            updateParent[0].Apttus__Status__c  = 'Completed';
            update updateParent[0];
        }
        
    }
        
}