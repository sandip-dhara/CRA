/**
* Class Name: DealRegProgPermTrigger
* Author: HP
* Date: 19-Dec-2012 
* Requirement # Request Id: 4086
* Description: If program is associated to Permission Set in Programs_and_permissions__c add 
*              permission Set to all users of the associated location of the program.
*/
 
trigger DealRegProgPermTrigger on Programs_and_permissions__c (before insert, after insert) {
    //Mute trigger logic
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    /*Commented as part of R6
    // trigger for beforeInsert 
    if(trigger.isInsert && trigger.isBefore){
        DealReg_ProgPermController beforeInsert = new DealReg_ProgPermController();
        beforeInsert.checkduplicateRecord(Trigger.new);
    }
    // trigger for afterInsert 
    if(trigger.isInsert && trigger.isAfter){
        DealReg_ProgPermController afterInsert = new DealReg_ProgPermController();
        afterInsert.progPermAfterInsert(Trigger.new);
    }
    */
}