@isTest
public with sharing class ApttusExportSearchControllerTest {
	public static testmethod void testApttusExportSearchController(){
		Test.startTest();
		
		Account acc = new Account();
		acc.NAME = 'Test Account';
		insert acc;
		
		ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
		
		Apttus__APTS_Agreement__c agmt = new Apttus__APTS_Agreement__c();
		agmt.NAME = 'Apttus';
		agmt.RecordTypeID = rtID;
		agmt.Apttus__Agreement_Number__c = '1';
		agmt.Apttus__Version_Number__c = 1;
		agmt.Axiom_Record_Type__c = 'Test Apttus';
		agmt.Axiom_Refresh__c = FALSE;
		agmt.Contract_Type_Abbreviation__c = 'CO';
		agmt.Apttus__Account__c = acc.ID;
		insert agmt;
		
		Apttus__APTS_Agreement__c agmt1 = new Apttus__APTS_Agreement__c();
		agmt1.NAME = 'test Apttus1';
		agmt1.RecordTypeID = rtID;
		agmt1.Apttus__Agreement_Number__c = '2';
		agmt1.Apttus__Version_Number__c = 2;
		agmt1.Axiom_Record_Type__c = 'test Apttus';
		agmt1.Axiom_Refresh__c = FALSE;
		agmt1.Contract_Type_Abbreviation__c = 'CO';
		agmt1.Apttus__Account__c = acc.ID;
		insert agmt1;
		
		System.assertEquals(agmt.RecordTypeID,rtID);
		
		PageReference pr = Page.ApttusExportSearch;
		Test.setCurrentPage(pr);
		System.currentPageReference().getParameters().put('id',agmt.ID);
		System.currentPageReference().getParameters().put('retURL','/'+agmt.ID);
		System.currentPageReference().getParameters().put('searchQuery',agmt.Apttus__FF_Agreement_Number__c);
		System.currentPageReference().getParameters().put('resultFieldsString','avaru;axay');
		System.currentPageReference().getParameters().put('advSearchWhereClauseExp','axay');
		System.currentPageReference().getParameters().put('queryFieldsStrExp','name,Apttus__Status__c,');
		System.currentPageReference().getParameters().put('searchStringExp','Apttus*');
		
		
		list<String> sosl = new List<String>();
		sosl.add(agmt.ID);
		//sosl.add('axay2');
		
		Test.setFixedSearchResults(sosl);
		
		ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(agmt);
		ApttusExportSearchController esc = new ApttusExportSearchController();
		
		esc = new ApttusExportSearchController(sc);
		esc.agmtTxtSrchCriteria = 'Apttus';
		ApttusExportSearchController.cwAgreementList cwel = new ApttusExportSearchController.cwAgreementList();
		esc.isSOSL = TRUE;
		esc.getAgreementList();
		esc.isSOSL = FALSE;
		esc.getAgreementList();
		esc.isSOSL = TRUE;
		
		Test.stopTest();
		
	}

public static testmethod void testApttusExportSearchController_2(){
		Test.startTest();
		
		
		Account acc = new Account();
		acc.NAME = 'Test Account';
		insert acc;
		
		ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
		
		Apttus__APTS_Agreement__c agmt = new Apttus__APTS_Agreement__c();
		agmt.NAME = 'test Apttus';
		agmt.RecordTypeID = rtID;
		agmt.Apttus__Agreement_Number__c = '1';
		agmt.Apttus__Version_Number__c = 1;
		agmt.Axiom_Record_Type__c = 'Test Apttus';
		agmt.Axiom_Refresh__c = FALSE;
		agmt.Contract_Type_Abbreviation__c = 'CO';
		agmt.Apttus__Account__c = acc.ID;
		insert agmt;
		
		Apttus__APTS_Agreement__c agmt1 = new Apttus__APTS_Agreement__c();
		agmt1.NAME = 'test Apttus1';
		agmt1.RecordTypeID = rtID;
		agmt1.Apttus__Agreement_Number__c = '2';
		agmt1.Apttus__Version_Number__c = 2;
		agmt1.Axiom_Record_Type__c = 'test Apttus';
		agmt1.Axiom_Refresh__c = FALSE;
		agmt1.Contract_Type_Abbreviation__c = 'CO';
		agmt1.Apttus__Account__c = acc.ID;
		insert agmt1;
		
		System.assertEquals(agmt.RecordTypeID,rtID);
				
		PageReference pr = Page.ApttusExportSearch;
		Test.setCurrentPage(pr);
		System.currentPageReference().getParameters().put('id',agmt.ID);
		System.currentPageReference().getParameters().put('retURL','/'+agmt.ID);
		System.currentPageReference().getParameters().put('searchQuery',agmt.Apttus__FF_Agreement_Number__c);
		System.currentPageReference().getParameters().put('resultFieldsString','avaru;axay');
		System.currentPageReference().getParameters().put('advSearchWhereClauseExp','');
		System.currentPageReference().getParameters().put('queryFieldsStrExp','name,Apttus__Status__c,');
		System.currentPageReference().getParameters().put('searchStringExp','test');
		
		list<String> sosl = new List<String>();
		sosl.add(agmt.ID);
		//sosl.add('axay2');
		
		Test.setFixedSearchResults(sosl);
		
		ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(agmt);
		ApttusExportSearchController esc = new ApttusExportSearchController();
		esc = new ApttusExportSearchController(sc);
		//esc.agmtTxtSrchCriteria = 'test*';
		ApttusExportSearchController.cwAgreementList cwel = new ApttusExportSearchController.cwAgreementList();
		esc.isSOSL = TRUE;
		esc.getAgreementList();
		esc.isSOSL = FALSE;
		esc.getAgreementList();
		esc.isSOSL = TRUE;
		esc.getAgreementListUpdated();
		esc.isSOSL = FALSE;
		System.currentPageReference().getParameters().put('advSearchWhereClauseExp','XXXXXXtest');
		ApttusExportSearchController esc2 = new ApttusExportSearchController();
		
		esc2.getAgreementListUpdated();
		Test.stopTest();
		
	}
}