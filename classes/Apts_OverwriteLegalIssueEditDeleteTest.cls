@isTest
public with sharing class Apts_OverwriteLegalIssueEditDeleteTest {
	public static testmethod void testAptsOverwriteLegalIssueEditDelete(){
		
		ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
		
		Apttus__APTS_Agreement__c agmtObj = new Apttus__APTS_Agreement__c();
     	agmtObj.Name = 'Test Agreement';
     	agmtObj.RecordTypeID = rtID;
     	agmtObj.Number_of_times_SOAR_form_Generated__c = 12;
     	insert agmtObj;
		
		Legal_Issue__c li = new Legal_Issue__c();
     	li.Agreement__c = agmtObj.ID;
     	li.Initial_Content__c = 'test initail content';
     	li.Paragraph__c = 'test paragraph';
     	li.Sequence__c = 2;
     	insert li;
     	
		ApexPages.StandardController con = new ApexPages.StandardController(li);
     	Apts_OverwriteLegalIssueEditDelete aptLegalIssue = new Apts_OverwriteLegalIssueEditDelete(con);
     	
     	PageReference pref = aptLegalIssue.forwardToAgreement();
     	System.assertEquals(pref.getUrl(), '/'+li.Agreement__c);
	}
}