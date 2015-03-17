@isTest
public with sharing class ApttusParsXMLDomClassUtilTest {
	public static testmethod void testApttusParsXMLDomClassUtil(){
		Test.startTest();
		
		ApttusParsXMLDomClassUtil aptsxml = new ApttusParsXMLDomClassUtil();
		String toParse = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                                '<SOAP-ENV:Body>'+
                                    '<ns0:EDResponse xmlns:ns0="http://www.tibco.com/schemas/EDInterface/BusinessUseCases/SharedResources/Schemas/EDOutPut">'+
                                        '<ns0:Message>apttus1 || 12345678 || apttus1@apttus.com || 12365487</ns0:Message>'+
                                        '<ns0:Message>apttus2 || 87654321 || apttus2@apttus.com || 12345678</ns0:Message>'+
                         				'<ns0:Message>apttus3 || 74185236 || apttus3@apttus.com || 12345678</ns0:Message>'+
                                    '</ns0:EDResponse>'+
                                '</SOAP-ENV:Body>'+
                            '</SOAP-ENV:Envelope>';
                            
		List<EmployeeBean> eb = aptsxml.parse(toParse);
		System.assert(eb.size() > 0);
		
		toParse = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+'<SOAP-ENV:Body>';
        eb = aptsxml.parse(toParse);
		System.assert(eb == null);
		Test.stopTest();
	}
}