@isTest
public with sharing class AptsTibcoWebServiceUtilClassTest {
	public static testmethod void testAptsTibcoWebServiceUtilClass(){
		
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('ApttusTibcoWebServiceCalloutMockResponse');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/xml');

		Test.setMock(HttpCalloutMock.class, mock);
		
		Apttus__APTS_Admin__c adminEntry = new Apttus__APTS_Admin__c();
    	adminEntry.NAME = 'APTS_TibcoWebServiceEndPoint';
    	adminEntry.Apttus__Value__c = 'https://it-services-gw-csc-itg.external.hp.com/gw/hpit/sfdc/ed.dev';
    	adminEntry.Apttus__Code__c = 'https://it-services-gw-csc-itg.external.hp.com/gw/hpit/sfdc/ed.dev';
    	insert adminEntry;
    	
    	Test.startTest();
		List<EmployeeBean> eb = AptsTibcoWebServiceUtilClass.getEmpHierarchyData('12345678');
		Test.stopTest();
		
		DOM.Document xmlDom1 = AptsTibcoWebServiceUtilClass.createRequest('12345678','Single','apttus','apttuscrm');
		System.assert(xmlDom1 != null);
		
		DOM.Document xmlDom2 = AptsTibcoWebServiceUtilClass.createRequest('12345678','Search','apttus','apttuscrm');
		System.assert(xmlDom2 != null);
		
		System.assert(eb.size() > 0);
		
		
	}
}