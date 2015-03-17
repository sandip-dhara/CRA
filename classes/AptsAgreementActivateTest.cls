@isTest
public with sharing class AptsAgreementActivateTest {
	public static testmethod void testAptsAgreementActivate(){
		
		Test.startTest();
		/*
		RecordType rt = new RecordType();
		rt.Name = 'Apttus';
		rt.DeveloperName = 'tApttus';
		rt.IsActive = TRUE;
		rt.SobjectType = 'Apttus__APTS_Agreement__c';
		insert rt;//DML not Allowed on Record Typr
		
		--OR--
		Schema.DescribeSObjectResult rtSchema = Schema.SObjectType.Apttus__APTS_Agreement__c;
	 	Map<String,Schema.RecordTypeInfo> AgreementRecordTypeInfo = rtSchema.getRecordTypeInfosByName();
	 	ID rtID = AgreementRecordTypeInfo.get('Not yet selected').getRecordTypeId();//OR Create like below
	 	*/
	 	ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
	 
		Apttus__APTS_Agreement__c agmtObj = new Apttus__APTS_Agreement__c();
	 	agmtObj.RecordTypeId = rtID;
	 	agmtObj.Name = 'Test Agreement';
	 	agmtObj.Number_of_times_SOAR_form_Generated__c = 12;
	 	insert agmtObj;
	 	
	 	Legal_Issue__c li = new Legal_Issue__c();
	 	li.Initial_Content__c = 'test initail content';
	 	li.Paragraph__c = 'test paragraph';
	 	li.Sequence__c = 1;
	 	insert li;
	 	
	 	Legal_Issue__c li1 = new Legal_Issue__c();
	 	li1.Agreement__c = agmtObj.ID;
	 	li1.Initial_Content__c = 'test initail content';
	 	li1.Paragraph__c = 'test paragraph';
	 	li1.Sequence__c = 2;
	 	insert li1;
	 	
	 	Legal_Issue_Sample_Data__c lisd = new Legal_Issue_Sample_Data__c();
	 	lisd.Risk_Category__c = 'Testing Apttus Sample Data';
	 	lisd.Sequence__c = 1;
	 	insert lisd;
	 	
	 	PageReference pref = Page.Apts_Agreement_Activate;
		Test.setCurrentPageReference(pref); 
		System.currentPageReference().getParameters().put('Id', agmtObj.ID);
		
		AptsAgreementActivate aptsAgmt = new AptsAgreementActivate();
		aptsAgmt.InsertLegalIssues();
		PageReference pr = aptsAgmt.SaveAndContinue();
		
		System.assertEquals(pr.getParameters().get('id'),agmtObj.ID);
		
		pr = aptsAgmt.returnAgreement();
		System.assertEquals(pr.getUrl(),'/apex/AptsAgmtHome');
		
		aptsAgmt.disableInlineEdit();
		
		aptsAgmt.Cancel();
		
		Test.stopTest();
	}
	public static testmethod void testAptsAgreementActivate_2(){
		
		Test.startTest();
		
		Schema.DescribeSObjectResult rtSchema = Schema.SObjectType.Apttus__APTS_Agreement__c;
	 	Map<String,Schema.RecordTypeInfo> AgreementRecordTypeInfo = rtSchema.getRecordTypeInfosByName();
	 	ID rtID = AgreementRecordTypeInfo.get('Not yet selected').getRecordTypeId();
	 	
		Apttus__APTS_Agreement__c agmtObj = new Apttus__APTS_Agreement__c();
	 	
	 	agmtObj.Name = 'Test Agreement';
	 	agmtObj.RecordTypeId = rtID;
	 	agmtObj.Number_of_times_SOAR_form_Generated__c = 12;
	 	insert agmtObj;
	 	
	 	Legal_Issue__c li = new Legal_Issue__c();
	 	li.Initial_Content__c = 'test initail content';
	 	li.Paragraph__c = 'test paragraph';
	 	li.Sequence__c = 1;
	 	insert li;
	 	
	 	Legal_Issue_Sample_Data__c lisd = new Legal_Issue_Sample_Data__c();
	 	lisd.Risk_Category__c = 'Testing Apttus Sample Data';
	 	lisd.Sequence__c = 1;
	 	insert lisd;
	 	
	 	PageReference pref = Page.Apts_Agreement_Activate;
		Test.setCurrentPageReference(pref); 
		System.currentPageReference().getParameters().put('Id', agmtObj.ID);
		
		AptsAgreementActivate aptsAgmt = new AptsAgreementActivate();
		aptsAgmt.InsertLegalIssues();
		PageReference pr = aptsAgmt.SaveAndContinue();
		
		System.assertEquals(pr.getParameters().get('id'),agmtObj.ID);
		
		pr = aptsAgmt.returnAgreement();
		System.assertEquals(pr.getUrl(),'/apex/AptsAgmtHome');
		
		aptsAgmt.disableInlineEdit();
		
		aptsAgmt.Cancel();
		
		System.currentPageReference().getParameters().put('id', '');
		System.currentPageReference().getParameters().put('isActive', 'true');
		AptsAgreementActivate aaa = new AptsAgreementActivate();
		
		agmtObj.Number_of_times_SOAR_form_Generated__c = 0;
		update agmtObj;
		PageReference pref2 = Page.Apts_Agreement_Activate;
		Test.setCurrentPageReference(pref2);
		System.currentPageReference().getParameters().put('id',agmtObj.ID);
		System.currentPageReference().getParameters().put('isActive', 'true');
		AptsAgreementActivate aaa2 = new AptsAgreementActivate();
		aaa2.InsertLegalIssues();
		aaa2.SaveAndContinue();
		aaa2.lstLegalIssue = new List<Legal_Issue__c>();
		
		aaa2.cancel();
		
		Test.stopTest();
	}
	
}