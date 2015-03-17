@isTest
global class SFSoapImplSR implements WebServiceMock {
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

        presearchSR.RetrieveOpportunityMatchesResponse_element elem = new presearchSR.RetrieveOpportunityMatchesResponse_element();
        elem.RetrieveOpportunityMatchesResult = 'Mock Response';
        response.put('response_x', elem); 
   }
}