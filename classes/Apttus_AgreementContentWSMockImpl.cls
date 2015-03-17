@isTest  
global class Apttus_AgreementContentWSMockImpl implements WebServiceMock {  
   
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
  


    soapSforceComSchemasApttusContentStub.publishToContentRepositoryResponse_element conResponse = new soapSforceComSchemasApttusContentStub.publishToContentRepositoryResponse_element(); 
    conResponse.result = true; 
    response.put('response_x', conResponse);
    
    

   }
   

}