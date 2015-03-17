public class presearchSR {
    public class RetrieveOpportunityMatches_element {
        public String input;
        private String[] input_type_info = new String[]{'input','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.roinnovation.com/','true','false'};
        private String[] field_order_type_info = new String[]{'input'};
    }
    public class SFSoap {
        public String endpoint_x = 'TBD';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.roinnovation.com/', 'presearchSR'};
        public String RetrieveOpportunityMatches(String input) {
            roi__RVWebservice__c st = roi__RVWebservice__c.getValues('Settings');
            if(st == null) {
                endpoint_x = 'https://rv.roinnovation.com/rvsand/sf.asmx';
            } else {
                endpoint_x = st.roi__ASMX_Location__c;
            }
            presearchSR.RetrieveOpportunityMatches_element request_x = new presearchSR.RetrieveOpportunityMatches_element();
            presearchSR.RetrieveOpportunityMatchesResponse_element response_x;
            request_x.input = input;
            Map<String, presearchSR.RetrieveOpportunityMatchesResponse_element> response_map_x = new Map<String, presearchSR.RetrieveOpportunityMatchesResponse_element>();
            response_map_x.put('response_x', response_x);

            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.roinnovation.com/RetrieveOpportunityMatches',
              'http://www.roinnovation.com/',
              'RetrieveOpportunityMatches',
              'http://www.roinnovation.com/',
              'RetrieveOpportunityMatchesResponse',
              'presearchSR.RetrieveOpportunityMatchesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RetrieveOpportunityMatchesResult;
        }
    }
    public class RetrieveOpportunityMatchesResponse_element {
        public String RetrieveOpportunityMatchesResult;
        private String[] RetrieveOpportunityMatchesResult_type_info = new String[]{'RetrieveOpportunityMatchesResult','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.roinnovation.com/','true','false'};
        private String[] field_order_type_info = new String[]{'RetrieveOpportunityMatchesResult'};
    }

    /*
    static testMethod void myUnitTest() {
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new SFSoapImplSR());
        
        // Call the method that invokes a callout
        presearchSR.SFSoap stub = new presearchSR.SFSoap();
        String output = stub.RetrieveOpportunityMatches('Hello World!');
        
        // Verify that a fake result is returned
        System.assertEquals('Mock Response', output); 
    }
    */

}