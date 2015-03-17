@isTest
public with sharing class ApttusButtonIntermediateTest {
    public static testmethod void testApttusButtonIntermediate(){
        
        Test.startTest();
        
        ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
        
        Apttus__APTS_Agreement__c agmt = new Apttus__APTS_Agreement__c();
        agmt.NAME = 'Testing Apttus';
        agmt.RecordTypeID = rtID;
        insert agmt;
        System.assertEquals(agmt.NAME,'Testing Apttus');
        
        PageReference pr = Page.ApttusSendforeSignatureIntermediate;
        Test.setCurrentPage(pr);
        System.currentPageReference().getParameters().put('id',agmt.ID);
        System.currentPageReference().getParameters().put('action','eSignature');
        
        ApexPages.Standardcontroller stdcon = new ApexPages.standardController(agmt);
        ApttusButtonIntermediate abi = new ApttusButtonIntermediate(stdcon);
        abi.navigateTo();
        
        System.currentPageReference().getParameters().put('action','wetSignature');
        abi.navigateTo();
        
        System.currentPageReference().getParameters().put('action','signedSignature');
        abi.navigateTo();
        
        System.currentPageReference().getParameters().put('action','');
        abi.navigateTo();
        
        Test.stopTest();
    }
}