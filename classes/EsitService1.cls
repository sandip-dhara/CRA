//Generated by wsdl2apex

public class EsitService1 {
    public class HelloWorld_element {
        public String name;
        private String[] name_type_info = new String[]{'name','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'name'};
    }
    public class GetLDAPPtofilePictureUrlResponse_element {
        public String GetLDAPPtofilePictureUrlResult;
        private String[] GetLDAPPtofilePictureUrlResult_type_info = new String[]{'GetLDAPPtofilePictureUrlResult','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetLDAPPtofilePictureUrlResult'};
    }
    public class HelloWorldResponse_element {
        public String HelloWorldResult;
        private String[] HelloWorldResult_type_info = new String[]{'HelloWorldResult','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'HelloWorldResult'};
    }
    public class GetLDAPPtofilePictureUrl_element {
        public String emailAddress;
        private String[] emailAddress_type_info = new String[]{'emailAddress','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'emailAddress'};
    }
    public class Service1Soap {
        public String endpoint_x = 'http://c0043648.itcs.hp.com:8010/service1.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/', 'EsitService1'};
        public String HelloWorld(String name) {
            EsitService1.HelloWorld_element request_x = new EsitService1.HelloWorld_element();
            request_x.name = name;
            EsitService1.HelloWorldResponse_element response_x;
            Map<String, EsitService1.HelloWorldResponse_element> response_map_x = new Map<String, EsitService1.HelloWorldResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/HelloWorld',
              'http://tempuri.org/',
              'HelloWorld',
              'http://tempuri.org/',
              'HelloWorldResponse',
              'EsitService1.HelloWorldResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.HelloWorldResult;
        }
        public String GetLDAPPtofilePictureUrl(String emailAddress) {
            EsitService1.GetLDAPPtofilePictureUrl_element request_x = new EsitService1.GetLDAPPtofilePictureUrl_element();
            request_x.emailAddress = emailAddress;
            EsitService1.GetLDAPPtofilePictureUrlResponse_element response_x;
            Map<String, EsitService1.GetLDAPPtofilePictureUrlResponse_element> response_map_x = new Map<String, EsitService1.GetLDAPPtofilePictureUrlResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/GetLDAPPtofilePictureUrl',
              'http://tempuri.org/',
              'GetLDAPPtofilePictureUrl',
              'http://tempuri.org/',
              'GetLDAPPtofilePictureUrlResponse',
              'EsitService1.GetLDAPPtofilePictureUrlResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetLDAPPtofilePictureUrlResult;
        }
    }
}