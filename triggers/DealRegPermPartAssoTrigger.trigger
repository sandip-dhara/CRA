/**
 * Trigger Name:    DealRegPermPartAssoTrigger
 * Author:          HP
 * Date:            12-Dec-2012 
 * Requirement Id:  4086
 * Description:     On inserting/deleting 'Permission_Partner_Association__c' record, the permissionset
 *                  of the set of users(which are related to the partner of the inserted/deleted record) are also assigned/removed.
**/
trigger DealRegPermPartAssoTrigger on Permission_Partner_Association__c (before insert, after insert) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        /* Do nothing if mute triggers set to true */
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    /* Commented as Part of R6
    // Trigger for beforeInsert 
    if(trigger.isInsert && trigger.isBefore){
        DealReg_PermissionPartnerTrgController beforeInsert = new DealReg_PermissionPartnerTrgController();
        beforeInsert.checkduplicatePermissionPartner(Trigger.new);
    }
    // Trigger for afterInsert 
    if(trigger.isInsert && trigger.isAfter){
        DealReg_PermissionPartnerTrgController afterInsert = new DealReg_PermissionPartnerTrgController();
        afterInsert.assignPermissionSet(Trigger.new);
    }
    */
}