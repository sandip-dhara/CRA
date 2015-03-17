@isTest
public with sharing class AptsViewAttachmentIdsTest {
	public static testmethod void testAptsViewAttachmentIds(){
		
		ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
		
		Apttus__APTS_Agreement__c agmtObj = new Apttus__APTS_Agreement__c();
     	agmtObj.Name = 'Test Agreement';
     	agmtObj.RecordTypeID = rtID;
     	agmtObj.Number_of_times_SOAR_form_Generated__c = 12;
     	insert agmtObj;
		
		Attachment atchmnt = new Attachment();
		atchmnt.NAME = 'Test Attachment';
		atchmnt.ParentId = agmtObj.ID;
		atchmnt.Body = Blob.valueOf('Testing Apttus');
		insert atchmnt;
		
		PageReference pref = Page.Apts_View_AttachmentIds;
		Test.setCurrentPageReference(pref); 
    	System.currentPageReference().getParameters().put('Id', agmtObj.ID);
    	
    	AptsViewAttachmentIds aptsViewAtchmnt = new AptsViewAttachmentIds();
		
	}
}