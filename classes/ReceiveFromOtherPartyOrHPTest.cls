@isTest
public with sharing class ReceiveFromOtherPartyOrHPTest {
	public static testmethod void testReceiveFromOtherPartyOrHP(){
		
		Test.startTest();
		
		ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
		
		Apttus__APTS_Agreement__c agmt = new Apttus__APTS_Agreement__c();
		agmt.Name = 'Testing Apttus';
		agmt.RecordTypeID = rtID;
		insert agmt;
		
		PageReference pr = Page.ReceiveFromOtherPartyOrHP;
		Test.setCurrentPage(pr);
		System.currentPageReference().getParameters().put('id',agmt.ID);
		System.currentPageReference().getParameters().put('action','receiveOther');
		
		ReceiveFromOtherPartyOrHP recv = new ReceiveFromOtherPartyOrHP();
		recv.changeAgreementStatus();
		agmt.Number_of_times_Other_Party_Review__c = null;
		update agmt;
		recv.changeAgreementStatus();
		
		System.currentPageReference().getParameters().put('action','receiveHP');
		recv.changeAgreementStatus();
		agmt.Number_of_times_HP_Review__c = null;
		update agmt;
		
		recv.changeAgreementStatus();
		
		Test.stopTest();
	}
}