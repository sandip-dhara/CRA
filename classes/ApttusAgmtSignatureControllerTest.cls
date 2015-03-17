@isTest
public with sharing class ApttusAgmtSignatureControllerTest {
	public static testmethod void testApttusAgmtSignatureController(){
		
		ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
		
		Apttus__APTS_Agreement__c agmt = new Apttus__APTS_Agreement__c();
		agmt.NAME = 'Test Axay';
		agmt.RecordTypeID = rtID;
		agmt.Apttus__Status__c = 'Pending Assignment';
		agmt.Sent_for_eSignature_Date__c = System.now() - 30;
		insert agmt;
		
		System.assertEquals(agmt.Apttus__Status__c,'Pending Assignment');
		
		Attachment atchmnt = new Attachment();
		atchmnt.NAME = 'Test_Attachment.doc';
		atchmnt.BODY = BLOB.valueOf('Test String');
		atchmnt.ParentId = agmt.ID;
		atchmnt.ContentType = 'doc';
		insert atchmnt;
		System.assertEquals(atchmnt.ParentId,agmt.ID);
		
		ApttusAgmtSignatureController.AttachmentInfo attInfo = new ApttusAgmtSignatureController.AttachmentInfo(atchmnt);
		attInfo.selected = TRUE;
		
		List<ApttusAgmtSignatureController.AttachmentInfo> att = new List<ApttusAgmtSignatureController.AttachmentInfo>();
		att.add(attInfo);
		
		PageReference pageRef = Page.ApttusAgmtSignature;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.standardController(agmt);
        
        ApttusAgmtSignatureController agmtsc = new ApttusAgmtSignatureController(sc);
        agmtsc.attColl = att;
        agmtsc.goDocuSignold();
        agmtsc.goDocuSign();
        agmtsc.sendForEsginatureold();
        agmtsc.sendForEsginature();
        agmtsc.sendForWetSignature();
        String str = agmtsc.getName();
        agmtsc.onLoad();
        agmtsc.getHasAttachments();
        agmtsc.getSelectedAttachmentIdsCsv();
        agmtsc.getSelectedAttachmentId();
        agmtsc.getHasSelectedAttachmentIds();
        agmtsc.getHasErrors();
        agmtsc.doSelect();
        agmtsc.doCancel();
        
        
        ApttusAgmtSignatureController agmtsc2 = new ApttusAgmtSignatureController(sc);
        agmtsc2.getAttachments();
        
        delete atchmnt;
        Attachment atchmnt2 = new Attachment();
		atchmnt2.NAME = 'Test_Attachment.doc';
		atchmnt2.BODY = BLOB.valueOf('Test String');
		atchmnt2.ParentId = agmt.ID;
		atchmnt2.ContentType = 'pdf';
		insert atchmnt2;
		
		ApttusAgmtSignatureController.AttachmentInfo attInfo2 = new ApttusAgmtSignatureController.AttachmentInfo(atchmnt2);
		attInfo2.selected = TRUE;
		
		List<ApttusAgmtSignatureController.AttachmentInfo> att2 = new List<ApttusAgmtSignatureController.AttachmentInfo>();
		att2.add(attInfo);
		
		ApttusAgmtSignatureController agmtsc3 = new ApttusAgmtSignatureController(sc);
		agmtsc3.attColl = att2;
        agmtsc3.getAttachments();
		agmtsc3.sendForEsginature();
		
	}
public static testmethod void testApttusAgmtSignatureController2(){
		
		ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
		
		Apttus__APTS_Agreement__c agmt = new Apttus__APTS_Agreement__c();
		agmt.NAME = 'Test Axay';
		agmt.RecordTypeID = rtID;
		agmt.Apttus__Status__c = 'Pending Assignment';
		agmt.Sent_for_eSignature_Date__c = System.now() - 30;
		insert agmt;
		
		System.assertEquals(agmt.Apttus__Status__c,'Pending Assignment');
		
		
		
		PageReference pageRef = Page.ApttusAgmtSignature;
        Test.setCurrentPage(pageRef);
        
        
        
        
        Attachment atchmnt2 = new Attachment();
		atchmnt2.NAME = 'Test_Attachment.doc';
		atchmnt2.BODY = BLOB.valueOf('Test String');
		atchmnt2.ParentId = agmt.ID;
		atchmnt2.ContentType = 'pdf';
		insert atchmnt2;
		System.assertEquals(atchmnt2.ParentId,agmt.ID);
		
		ApexPages.StandardController sc = new ApexPages.standardController(agmt);
		
		ApttusAgmtSignatureController.AttachmentInfo attInfo2 = new ApttusAgmtSignatureController.AttachmentInfo(atchmnt2);
		attInfo2.selected = TRUE;
		
		List<ApttusAgmtSignatureController.AttachmentInfo> att2 = new List<ApttusAgmtSignatureController.AttachmentInfo>();
		att2.add(attInfo2);
		
		ApttusAgmtSignatureController agmtsc3 = new ApttusAgmtSignatureController(sc);
		agmtsc3.attColl = att2;
        agmtsc3.getAttachments();
		agmtsc3.sendForEsginature();
		
	}
}