/**********************************************************
* Class Name: PartnerCollabNotesAttachmentsUtil
* Author: Accenture
* Date: 17-JULY-2012
* Requirement # Request Id:
* Description: Class with methods to update field - 'last modified by partner' on lead and opportunity 
  when a new note/attachment is added or an existing note/attachment is updated
***********************************************************/

public class PartnerCollabNotesAttachmentsUtil {
	
	/**
    * @description: Method to call internal method that updates lead/oppty fields
    * @param: list of new/updated notes 
    **/
	
	public static void updateLeadOrOpptyForNotes(list<note> newOrUpdatedNotesList){
		updateLeadOrOppty(newOrUpdatedNotesList);
		system.debug('call updateLeadOrOppty');
	}
	
	public static void updateLeadOrOpptyForAttachments(list<attachment> newOrUpdatedAttachmentList){
		updateLeadOrOppty(newOrUpdatedAttachmentList);
	}
	
	/**
    * @description: Method to obtain lead/oppty IDs
    * @param: list of SObject - notes/attachments
    **/
    
	public static void updateLeadOrOppty(list<Sobject> notesOrAttachmentsList){
		Set<Id> opptyIdsToBeUpdated = new Set<Id>();
		Set<Id> leadIdsToBeUpdated = new Set<Id>();
		list<opportunity> opptiesToBeUpdated = new list<opportunity>();
		list<lead> leadsToBeUpdated = new list<lead>();
		Database.SaveResult[] opptyUpdateResult;
		Database.SaveResult[] leadUpdateResult;
		
		for(Sobject noteOrAttachment: notesOrAttachmentsList){
			String parentId = string.valueof(noteOrAttachment.get('ParentId'));

			if(parentId.startsWith('006'))
			{
				opptyIdsToBeUpdated.add(parentId);
				system.debug('opptyIdsToBeUpdated'+opptyIdsToBeUpdated);
			}
			else if(parentId.startsWith('00Q'))
			{
				leadIdsToBeUpdated.add(parentId);
				system.debug('leadIdsToBeUpdated'+leadIdsToBeUpdated);
			}
		}
		
		if(opptyIdsToBeUpdated != null || opptyIdsToBeUpdated.size() > 0){
			opptiesToBeUpdated = [SELECT Last_Modified_by_Partner__c FROM opportunity WHERE Id IN :opptyIdsToBeUpdated];
			system.debug('opptiesToBeUpdated'+opptiesToBeUpdated);
			updateLeadOrOpptyLastModByPartner(opptiesToBeUpdated);
			try{
				opptyUpdateResult = database.update(opptiesToBeUpdated, false);
			}
			catch(exception ex){
				CreateApexErrorLog.insertHandledExceptions(ex, opptyUpdateResult, 'Opportunity', 'PartnerCollabNotesAttachmentsUtil', 'Class');
			}
			system.debug('opptiesToBeUpdated_final'+opptiesToBeUpdated);
		}
		
		if(leadIdsToBeUpdated != null || leadIdsToBeUpdated.size() > 0){
			leadsToBeUpdated = [SELECT Last_Modified_by_Partner__c FROM lead WHERE Id IN :leadIdsToBeUpdated];
			updateLeadOrOpptyLastModByPartner(leadsToBeUpdated);
			try{
				leadUpdateResult = database.update(leadsToBeUpdated, false);
			}
			catch(exception ex){
				CreateApexErrorLog.insertHandledExceptions(ex, leadUpdateResult, 'lead', 'PartnerCollabNotesAttachmentsUtil', 'Class');
			}
			system.debug('leadsToBeUpdated_final'+leadsToBeUpdated);
		}
	}
	
	/**
    * @description: Method to update 'Last modified date' on lead/oppty
    * @param: list of SObject - leads/opportunities
    **/
	public static list<Sobject> updateLeadOrOpptyLastModByPartner(list<Sobject> leadsOppties){
		system.debug('enter_updateLeadOrOpptyLastModByPartner');
		for(Sobject sobjLeadOrOppty: leadsOppties){
			String lastModifiedByPartner = 'Last_Modified_by_Partner__c';
			sobjLeadOrOppty.put(lastModifiedByPartner, system.now());
			system.debug('kkkkkkkkkkkks'+sobjLeadOrOppty);
		}
		system.debug('leadsOppties'+leadsOppties);
		return leadsOppties;
	}
}