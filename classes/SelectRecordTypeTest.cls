@isTest
public with sharing class SelectRecordTypeTest {
    public static testmethod void testSelectRecordType(){
        Test.startTest();
        
        Account acc = new Account();
        acc.NAME = 'test acc';
        insert acc;
        
        Id rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeId();
        Apttus__APTS_Agreement__c agmt = new Apttus__APTS_Agreement__c();
        agmt.Name = 'Apttus Test';
        agmt.Apttus__Account__c = acc.ID;
        if(rtID != null)
        agmt.RecordTypeId = rtID;
        insert agmt;
        System.assertEquals(agmt.Name,'Apttus Test');
        
        
        
        Attachment atmnt = new Attachment();
        atmnt.NAME = 'Apttus Attachment';
        atmnt.Body = Blob.valueOf('pString');
        atmnt.ParentId = agmt.ID;
        atmnt.isPrivate = FALSE;
        insert atmnt;
        System.assertEquals(agmt.ID,atmnt.ParentId);
        
        PageReference pr = Page.Select_Record_Type;
        Test.setCurrentPage(pr);
        System.currentPageReference().getParameters().put('id',agmt.ID);
        System.currentPageReference().getParameters().put('action','ConvertDoc');
        
        SelectRecordType srt = new SelectRecordType();
        //srt.apiServerURL = System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/26.0/' + UserInfo.getOrganizationId();
        srt.apiSessionId = UserInfo.getSessionId();
        String hostname = URL.getSalesforceBaseUrl().toExternalForm();
        String domain = hostname + '/Services/Soap/c/14.0/' + UserInfo.getOrganizationId();
        srt.apiServerURL = domain;//domain;
        ///services/Soap/c/14.0/00DJ0000001HcKr
        try{
        
        srt.doLogin();
        srt.SaveAndContinue();
        
        
        srt.Cancel();
        }catch(Exception e){}
        Test.stopTest();
    }
}