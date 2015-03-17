@isTest(SeeAllData=true)
global class JBPExstreamControllerImpl implements WebServiceMock {
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
           JBPExtreamOutput.HPExtreamRes_element test=new JBPExtreamOutput.HPExtreamRes_element();

           test.Message='PPT is generated';

           
                    response.put('response_x', test);
              }
}