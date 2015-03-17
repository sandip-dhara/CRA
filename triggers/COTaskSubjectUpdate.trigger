/**
* Trigger Name: COTaskSubjectUpdate 
* Author: hp
* Date: 3/22/2013 
* Requirement # Request Id: 
* Description: Trigger to update or Insert Task "Subject" based on "Task Type"
*/
trigger COTaskSubjectUpdate on Task (before insert,before update) {

Global_Config__c globalConfig = Global_Config__c.getInstance(); 
 if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    for(Task t: Trigger.new)
    {
        Id RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CO Task').getRecordTypeId();
        if(t.Task_Type__c!=null && t.RecordTypeId == RecordTypeId)    
        {
            t.Subject = t.Task_Type__c;
        }
        else if((t.Task_Type__c =='' || t.Task_Type__c == null) && t.RecordTypeId == RecordTypeId)
        {
            t.Subject= 'CO Task';
        }
    }

}