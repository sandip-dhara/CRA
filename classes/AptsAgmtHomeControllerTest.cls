@isTest(SeeAllData = TRUE)
public with sharing class AptsAgmtHomeControllerTest {

public static testmethod void AgmtHomeTest() {
	 Test.startTest();
	 List<Apttus__APTS_Agreement__c> agmtList = new List<Apttus__APTS_Agreement__c>();
	 
	 AptsAgmtHomeController agmt = new AptsAgmtHomeController();
	 
	 //RecordType rt = [SELECT ID,Name FROM RecordType WHERE SobjectType = 'Apttus__APTS_Agreement__c' AND Name='Search Agreements' Limit 1];
	 ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
	 
	 Apttus__APTS_Agreement__c agmtObj = new Apttus__APTS_Agreement__c();
	 agmtObj.RecordTypeId = rtID;
	 agmtObj.Name = 'Test Agreement axay';
	 insert agmtObj;
	 
	 System.assert(agmtObj != null);
	
	 Attachment atmt = new Attachment();
	 atmt.NAME = 'Test Apttus axay';
	 atmt.BODY = BLOB.valueOf('Test');
	 atmt.ParentID = agmtObj.ID;
	 insert atmt;
	 System.assertEquals(agmtObj.ID,atmt.ParentID);
	 
	 PageReference pref = Page.AptsAgmtHome;
     pref.getParameters().put('id',agmtObj.id);
     Test.setCurrentPage(pref);
     
     agmtList.add(agmtObj);
     ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(agmtList);
     agmt = new AptsAgmtHomeController(ssc);
     
     AptsAgmtHomeController.AgmtDocWrapper agmtwrp1 = new AptsAgmtHomeController.AgmtDocWrapper(agmtObj,atmt.ID);
     agmtwrp1.agmt = agmtObj;
     agmtwrp1.docId = atmt.ID;
     
     ApexPages.StandardController con1 = new ApexPages.StandardController(agmtObj);
     AptsAgmtHomeController agmtt = new AptsAgmtHomeController(con1);
     agmtt.docTxtSrchCriteria = 'Axay';
     agmt.agmtTxtSrchCriteria = '';
     
     agmtt.doSearch();
     agmt.docTxtSrchCriteria = '';
     agmt.agmtTxtSrchCriteria = '';
     agmt.doSearch();
     List<String> strng = new List<String>();
     strng.add('Test1');
     strng.add('Test2');
     strng.add('Test3');
     
     agmt.leftSelectedResultFields = strng;
     agmt.rightSelectedResultFields = strng;
     agmt.rightSelectedSearchFields = strng;
     
     agmt.docTxtSrchCriteria = 'Agreement';
     
     agmt.agmtTxtSrchCriteria = 'test';
     agmt.doClearSearchCriteria();
     agmt.buildQueryFieldsStr();
     agmt.buildAdvSearchWhereClause();
     agmt.doSearch();
     agmt.setCurrentPageNumber(1);
     agmt.setPageSize(1);
     agmt.getExpReqDocMapStr();
     //agmt.getTotalCount();
     //agmt.doSearchInternal();
     agmt.testPrivateMethods();
     //agmt.buildResultList();
     agmt.loadCurrentPage();
     agmt.getHasResults();
     agmt.getHasNextPage();
     agmt.getHasNextPage();
     agmt.getHasPreviousPage();
     agmt.getCurrentPageNumber();
     //agmt.setCurrentPageNumber();
     agmt.getPageStartIndex();
     agmt.getPageEndIndex();
     agmt.getPageSize();
     //agmt.setPageSize();
     agmt.firstPage();
     agmt.lastPage();
     //agmt.previousPage();
     //agmt.nextPage();
     agmt.doShowFilters();
     agmt.doHideFilters();
     agmt.refreshSearchResult();
     agmt.newRecord();
     
     agmt.doshowHideSelectionFilter();
     agmt.doshowHideSelectionColumns();
     agmt.isFieldSelectedSearch();
     agmt.doShowRecent();
     
     list<Schema.FieldSetMember> getFields = new list<Schema.FieldSetMember>();
	 getFields = Schema.SObjectType.Apttus__APTS_Agreement__c.fieldSets.getMap().get('Search_Fields').getFields();
     
     agmt.isFieldSelectedSearch(getFields[0]);
     Set<String> apts = new Set<String>();
     apts.add('Agreement');
     agmt.saveUpdateSelectedValues(apts,'Search');
     agmt.selectSearchClick();
     agmt.unSelectSearchClick();
     agmt.selectResultClick();
     agmt.unSelectResultClick();
     agmt.changeRt();
     agmt.getRecentAgreementsList();
     
     AptsAgmtHomeController.AgmtDocWrapper agmtwrp = new AptsAgmtHomeController.AgmtDocWrapper(agmtObj,atmt.ID);
     
     //AptsAgmtHomeController.cwSelectedFields aptscws = new AptsAgmtHomeController.cwSelectedFields('Request_Date__c');
     //AptsAgmtHomeController.cwSelectedFields apts2 = new AptsAgmtHomeController.cwSelectedFields ('Request_Date__c', true);
	 ApexPages.StandardController con = new ApexPages.StandardController(agmtObj);
     agmt = new AptsAgmtHomeController(con);
     
     
     
	 Test.stopTest();
}

public static testmethod void AgmtHomeTest_2() {
	Test.startTest();
	 
	 List<Apttus__APTS_Agreement__c> agmtList = new List<Apttus__APTS_Agreement__c>();
	 Folder fold = [SELECT ID,NAME FROM FOLDER WHERE NAME = 'Apttus Documents' LIMIT 1];
	 
	 AptsAgmtHomeController agmt = new AptsAgmtHomeController();
	 
	 //RecordType rt = [SELECT ID,Name FROM RecordType WHERE SobjectType = 'Apttus__APTS_Agreement__c' AND Name='Search Agreements' Limit 1];
	 ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
	 
	 Apttus__APTS_Agreement__c agmtObj = new Apttus__APTS_Agreement__c();
	 agmtObj.RecordTypeId = rtID;
	 agmtObj.Name = 'axay Test Agreement';
	 agmtObj.Legal_Owner__c = UserInfo.getUserID();
	 agmtObj.Apttus__Perpetual__c = FALSE;
	 insert agmtObj;
	 System.assert(agmtObj != null);
	
	 Attachment atmt = new Attachment();
	 atmt.NAME = 'Test Apttus axay';
	 atmt.BODY = BLOB.valueOf('Test');
	 atmt.ParentID = agmtObj.ID;
	 insert atmt;
	 System.assertEquals(atmt.ParentID, agmtObj.ID);
	 
	 Document doc = new Document();
	 doc.AuthorId = UserInfo.getUserID();
	 doc.Body = BLOB.valueOf('Test');
	 doc.ContentType = 'doc';
	 doc.DeveloperName = 'apttus_testing';
	 doc.FolderId = fold.ID;
	 doc.Name = 'Testing Apttus';
	 insert doc;
	 System.assert(doc != null);
	 
	 ContentDocument cd = [SELECT ID,OwnerId FROM ContentDocument LIMIT 1];
	 
	 ContentVersion cv = new ContentVersion();
	 cv.ContentDocumentId = cd.ID;
	 //cv.ContentModifiedById = UserInfo.getUserID();
	 //cv.ContentModifiedDate = '';
	 cv.OwnerId = cd.OwnerID;
	 cv.ReasonForChange = 'good';
	 cv.pathOnClient = URL.getCurrentRequestUrl().toExternalForm()+'/'+cd.ID;
	 cv.VersionData = BLOB.valueOf('Test');
	 insert cv;
	 
	 System.assertEquals(cv.OwnerId, cd.OwnerID);
	 
	 PageReference pref = Page.AptsAgmtHome;
     pref.getParameters().put('id',agmtObj.id);
     Test.setCurrentPage(pref);
     
     agmtList.add(agmtObj);
     ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(agmtList);
     agmt = new AptsAgmtHomeController(ssc);
     
     AptsAgmtHomeController.AgmtDocWrapper agmtwrp1 = new AptsAgmtHomeController.AgmtDocWrapper(agmtObj,atmt.ID);
     agmtwrp1.agmt = agmtObj;
     agmtwrp1.docId = atmt.ID;
     
     List<Schema.FieldSetMember> fields = agmt.getFields();
     AptsAgmtHomeController.cwSearchFields wrpper1 = new AptsAgmtHomeController.cwSearchFields(fields[0]);
     AptsAgmtHomeController.cwSearchFields wrpper2 = new AptsAgmtHomeController.cwSearchFields(fields[1]);
     
     List<AptsAgmtHomeController.cwSearchFields> cwList = new List<AptsAgmtHomeController.cwSearchFields>();
     cwList.add(wrpper1);
     cwList.add(wrpper2);
     
     ApexPages.StandardController con1 = new ApexPages.StandardController(agmtObj);
     AptsAgmtHomeController agmtt = new AptsAgmtHomeController(con1);
     agmtt.docTxtSrchCriteria = 'axay';
     agmt.agmtTxtSrchCriteria = '';
     
     
     List<String> strng = new List<String>();
     strng.add('Test1');
     strng.add('Test2');
     strng.add('Test3');
     
     agmt.leftSelectedResultFields = strng;
     agmt.rightSelectedResultFields = strng;
     agmt.rightSelectedSearchFields = strng;
     //agmtt.refreshSearchFields();
     //agmtt.refreshSearchResultFields();
     
     agmtt.agmtTxtSrchCriteria = '';
     agmtt.agreementFromDate = agmtObj;
     agmtt.agreementToDate = agmtObj;
     agmtt.doSearch();
     
     Map<ID,ID> mapid = new Map<ID,ID>();
     mapid.put(agmtObj.ID,agmtObj.ID);
     
     agmtt.agmtIdDocIdMap = mapid;
     agmtt.doSearchInternal();
     agmtt.cwSearchFieldsList = cwList;
     agmtt.buildAdvSearchWhereClause();
     agmtt.selectSearchClick();
}
}