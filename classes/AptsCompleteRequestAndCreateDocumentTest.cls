@isTest
public with sharing class AptsCompleteRequestAndCreateDocumentTest {
	public static testmethod void testAptsCompleteRequestAndCreateDocument(){
		
		Test.startTest();
		
		ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
		
		Account acc = new Account();
		acc.NAME = 'Test';
		insert acc;
		
		Apttus__APTS_Agreement__c agmtObj = new Apttus__APTS_Agreement__c();
	 	agmtObj.Name = 'Test Agreement';
	 	agmtObj.RecordTypeID = rtID;
	 	agmtObj.Number_of_times_SOAR_form_Generated__c = 12;
	 	agmtObj.Apttus__Account__c = acc.ID;
	 	insert agmtObj;
	 	
	 	
	 	PageReference pref = Page.Apts_Complete_Request;
		Test.setCurrentPageReference(pref); 
		System.currentPageReference().getParameters().put('Id', agmtObj.ID);
		System.currentPageReference().getParameters().put('action', 'CompleteRequest');
		
		AptsCompleteRequestAndCreateDocument aptsAgmt = new AptsCompleteRequestAndCreateDocument();
		
		pref = aptsAgmt.DoAction();
		System.assertEquals(pref.getUrl(),'/apex/AptsAgmtHome');
		aptsAgmt = null;
		
		pref = Page.Apts_Complete_Request;
		System.currentPageReference().getParameters().put('action', 'Create Document');
		aptsAgmt = new AptsCompleteRequestAndCreateDocument();
		pref = aptsAgmt.DoAction();
		System.assertEquals(pref,null);
		aptsAgmt = null;
		
		pref = Page.Apts_Complete_Request;
		System.currentPageReference().getParameters().put('action', 'active');
		aptsAgmt = new AptsCompleteRequestAndCreateDocument();
		pref = aptsAgmt.DoAction();
		System.assertEquals(pref,null);
				
		Test.stopTest();
	}
}