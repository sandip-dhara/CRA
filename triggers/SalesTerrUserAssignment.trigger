/*
* Name : SalesTerrUserAssignment
* Event : after insert, after delete
* Desc : Trigger to create & Delete Group Member On Sales Territory User Assignment create and Insert respectively.
*/

trigger SalesTerrUserAssignment on Sales_Territory_User_Assignment__c (before insert, after insert, after update, before delete,before update) {
   
    try{
        if(trigger.isInsert && trigger.isBefore){
                
            SalesTerrUserAUtil.userAssignmentBeforeInsert(trigger.New);
        }
    } catch(Exception e){
        system.debug('****SalesTerrUserAssignment Before Insert****' + e.getMessage());
    }
    //sreenath added below line code 11/27/2012 starts
    if(trigger.isUpdate && trigger.isBefore) {
          SalesTerrUserAUtil.userAssignmentbeforeUpdate(trigger.newMap, trigger.oldMap);                               
    }    
    //sreenath added above line code 11/27/2012 ends 
    //TM:Debmalya:Req:2090:Update flag on Sales Territory:Should work in irrespective of Mute triger settings:Start
    if(trigger.isAfter){
        if(trigger.isUpdate){
            SalesTerrUserAUtil.salesTerrFlagOnUpdate(Trigger.newMap,Trigger.oldMap);
        }else if(trigger.isInsert){
            SalesTerrUserAUtil.salesTerrFlagOnInsert(trigger.new);
        }
    }
    //TM:Debmalya:Req:2090:Update flag on Sales Territory:Should work in irrespective of Mute triger settings:End
    //TM:Nasir Jawed: Req:0594. Muting of trigger is removed : Start  
   /* Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return;
        }
    }*/
     //TM:Nasir Jawed: Req:0594. Muting of trigger is removed : End
     //NASIR JAWED for requirement 3299:Updating the owner field in sales territory user assignment
   
    
    if((trigger.isInsert && trigger.isBefore)|| (trigger.isUpdate && trigger.isBefore)) {
        for(Sales_Territory_User_Assignment__c objSalesTerUserAss:trigger.new){
            if(objSalesTerUserAss.User__c != null)
                objSalesTerUserAss.OwnerId = objSalesTerUserAss.User__c;
        }
    }
        
   
    //NASIR JAWED END
   
    try {
            
        if(trigger.isInsert && trigger.isAfter){
            
            SalesTerrUserAUtil.userAssignmentAfterInsert(trigger.New);
            //TM:R5:Nasir Jawed: CR-0712: Start
            SalesTerrUserAUtil.flagCheckOnSpecialtyAfterInsert(trigger.newmap);
            //TM:R5:Nasir Jawed: CR-0712: End
        }
        //TM:Debmalya:Req:2090:Add IsAfter condition 
        if(trigger.isUpdate && trigger.isAfter){
            
            SalesTerrUserAUtil.userAssignmentUpdate(trigger.New, trigger.Old);
            
        }
        
        if(trigger.isDelete){
            
            SalesTerrUserAUtil.userAssignmentDelete(trigger.Old);           
        }
    
    } catch (Exception e){
            system.debug('****SalesTerrUserAssignment****' + e.getMessage());
    }
}