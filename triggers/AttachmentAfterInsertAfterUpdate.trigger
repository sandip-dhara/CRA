/*
* Class Name: AttachmentAfterInsertAfterUpdate
* Author: Accenture
* Date: 17-JULY-2012
* Requirement # Request Id: 
* Description: Trigger to update 'last modified by partner' date when a new attachment is added or an existing attachment is updated on a lead or an oppty by a PARTNER
*/

trigger AttachmentAfterInsertAfterUpdate on Attachment (after insert, after update) {
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
    if(PartnerCollabUtil.isLoggedInPartnerUser()){
        PartnerCollabNotesAttachmentsUtil.updateLeadOrOpptyForAttachments(system.trigger.new);
    }
}