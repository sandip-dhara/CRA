/**
* Class Name: UserAfterInsert
* Author: Accenture
* Date: 24-JULY-2012 
* Requirement # Request Id: 
* Description: Contains After Insert support action methods for trigger on user object
*/
trigger UserAfterInsert on User (after insert) {  
    
    UserTriggerController.afterInsert(trigger.newMap, trigger.oldMap);
    
    /* @description: The below class will assign permission sets to users based on the user rights triggered from Siebel.
    *  It has to be executed even if Mute Trigger is Set to True.
    *  Added as part of R6 by PRM Team
    *  Requirement # : 
    */
    UserTriggerControllerForPermissionSet.afterInsert(trigger.newMap, trigger.oldMap);
    
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
    List<PermissionSet> ps = [Select Id From PermissionSet where Name ='Single_Sign_On_for_Free_Chatter_Users' Limit 1];

    List<PermissionSetAssignment> PerSetList = New List<PermissionSetAssignment>();
    
    Profile p = [Select Id From Profile Where Name = 'Chatter Free User'];
    
    For(User cfu: trigger.new){
    
        if(cfu.ProfileId == p.Id){ 
            
            if(ps.size()>0){
                PerSetList.add( New PermissionSetAssignment(AssigneeId = cfu.id,PermissionSetId = ps[0].ID ) ); 
            }
        } 
    }
    Insert PerSetList;

}