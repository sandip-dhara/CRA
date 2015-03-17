@isTest  
global class Apttus_AgreementWebServiceMockImpl implements WebServiceMock {  
   global void doInvoke(  
           Object stub,  
           Object request,  
           Map<string, object> response,  
           String endpoint,  
           String soapAction,  
           String requestName,  
           String responseNS,  
           String responseName,  
           String responseType) {
  

soapSforceComSchemasClassApttusAgr.activateAgreementResponse_element actResponse = new soapSforceComSchemasClassApttusAgr.activateAgreementResponse_element(); 

    actResponse.result = true; 
    response.put('response_x', actResponse);

   }  
}