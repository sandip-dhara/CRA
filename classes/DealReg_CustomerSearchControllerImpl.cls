@isTest(SeeAllData=true)
global class DealReg_CustomerSearchControllerImpl implements WebServiceMock {
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



SearchAccountMDCPLookUpService.documents_element  responseDoc=new SearchAccountMDCPLookUpService.documents_element();

SearchAccountMDCPLookUpService.organizationAccountSearchResult_element responseElm= new SearchAccountMDCPLookUpService.organizationAccountSearchResult_element();

List<SearchAccountMDCPLookUpService.organizationAccountSearchResult_element> list1=new List<SearchAccountMDCPLookUpService.organizationAccountSearchResult_element>();

responseElm.countryName='us';

responseElm.organizationId=12345;

responseElm.siteId=123;

list1.add(responseElm);

responseDoc.organizationAccountSearchResult=list1;


SearchAccountMDCPLookUpService.organizationAccountSearchDocuments_element accountdocuments= new SearchAccountMDCPLookUpService.organizationAccountSearchDocuments_element();

accountdocuments.documents=responseDoc;

SearchAccountMDCPLookUpService.organizationAccountSearchResponse_element responseFinal=new SearchAccountMDCPLookUpService.organizationAccountSearchResponse_element();
responseFinal.organizationAccountSearchDocuments=accountdocuments;
       response.put('response_x', responseFinal); 
   }
}