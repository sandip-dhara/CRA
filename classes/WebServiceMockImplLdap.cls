@isTest                       
global class WebServiceMockImplLdap implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
       CertificateLdapApex.GetLDAPPtofilePictureUrlResponse_element respElement = new CertificateLdapApex.GetLDAPPtofilePictureUrlResponse_element();
       respElement.GetLDAPPtofilePictureUrlResult = 'Mock response';
       response.put('response_x', respElement); 
   }
   global void heInvoke(Object stub1,
           Object request1,
           Map<String, Object> response1,
           String endpoint1,
           String soapAction1,
           String requestName1,
           String responseNS1,
           String responseName1,
           String responseType1){
       CertificateLdapApex.HelloWorldResponse_element respElement1 = new CertificateLdapApex.HelloWorldResponse_element();
       respElement1.HelloWorldResult = 'Hello';
       response1.put('response_x',respElement1);
   
   }
}