/***********************************************************
* Class Name: CCTaskAfterInsertUpdate
* Author: HP (Sreedhar Jagannath)
* Date: 15-JUL-2013 
* Requirement # Request Id: 
* Description: Update Last Successful Call based on the Task Fields (Type and Outcome)
***********************************************************/
trigger CCTaskAfterInsertUpdate on Task (after update, after insert){
    list<Lead> leads = new list<Lead>();
    list<id> liIDs = new list<id>();
    datetime myDateTime = datetime.now();
    Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Contact Center Task Record Type').getRecordTypeId();
    Schema.DescribeSObjectResult dsr = Lead.SObjectType.getDescribe();
    String objPrefix = dsr.getKeyPrefix();
    
    for(Task sTask : trigger.new)
    {
        if (sTask.WhoId <> NULL && sTask.RecordTypeid == taskRecordTypeId && string.valueOf(sTask.WhoId).startsWith(objPrefix)) 
        {
            liIDs.add(sTask.Whoid);
        }
    }

    Map<Id,Lead> leadmap = new Map<Id, Lead>([select Id,BU__c,Last_Successful_Call__c,CreatedDate,LeadSource,Country,Status,DonotCall,C_Mobile_Opt_in1__c ,Phone_Opt_in__c from Lead where Id in : liIDS]);
    Map<Id,Lead> idCreatedDateMap = new Map<Id, Lead>();

    for(Lead lead : leadmap.Values()){
        idCreatedDateMap.put(lead.Id,lead);
    }

    for(Task t :Trigger.new){ 
        if (t.WhoId <> NULL && t.RecordTypeid == taskRecordTypeId && string.valueOf(t.WhoId).startsWith('00Q')){ 
                   if(idCreatedDateMap.get(t.WhoId).CreatedDate.Date().daysBetween(myDateTime.Date())>7 && idCreatedDateMap.get(t.WhoId).Last_Successful_Call__c == NULL && idCreatedDateMap.get(t.WhoId).Status <> 'Closed'  && t.Type == 'Outbound Call' && idCreatedDateMap.get(t.WhoId).LeadSource == 'List Import' ){
                        idCreatedDateMap.get(t.WhoId).Last_Successful_Call__c = NULL;   
                    }
                    else if(t.Outcome__c <> NULL && idCreatedDateMap.get(t.WhoId).CreatedDate.Date().daysBetween(myDateTime.Date())<=7 && idCreatedDateMap.get(t.WhoId).Status <> 'Closed' && idCreatedDateMap.get(t.WhoId).LeadSource == 'List Import' && (t.Outcome__c.startswith('Requested') || (t.Outcome__c == 'No Interest' || t.Outcome__c == 'Created Contact')) && t.Type == 'Outbound Call'){
                        idCreatedDateMap.get(t.WhoId).Last_Successful_Call__c  = datetime.now();   
                    }
                    else if(t.Outcome__c <> NULL && idCreatedDateMap.get(t.WhoId).CreatedDate.Date().daysBetween(myDateTime.Date())<=7 && (idCreatedDateMap.get(t.WhoId).Last_Successful_Call__c == NULL) && idCreatedDateMap.get(t.WhoId).Status <> 'Closed' && idCreatedDateMap.get(t.WhoId).LeadSource == 'List Import' && (!t.Outcome__c.startswith('Requested') || (t.Outcome__c <> 'No Interest' || t.Outcome__c <> 'Created Contact')) && t.Type == 'Outbound Call'){
                        idCreatedDateMap.get(t.WhoId).Last_Successful_Call__c = NULL;   
                    }
                    leads.add(idCreatedDateMap.get(t.WhoId)); 
        }
    }
    
    if(leads.size() > 0){
        try{
            Database.update (leads,false);
        }
        catch(Exception e){
            System.debug('Exception'+e);
        }
    }
}