//Generated by wsdl2apex

public class JBPExtreamWebserviceStub {
    public class HPExtreamJBP {
        public String endpoint_x = Label.JBP_SRP_Proxy_Url;
        //public String endpoint_x = 'http://requestb.in/1f96yxo1';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
       //Below code is hand crafted not generated from WSDL.To construct the SOAP header to pass the webservice security credentials.
        public JBPExtreamWebserviceStub.Security_element Security;
        private String Security_hns = 'Security=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
      //End of code
        private String[] ns_map_type_info = new String[]{'http://www.tibco.com/schemas/HP_Extream_JointAccount/SharedResources/Schemas/Public/SFDC_Input.xsd', 'JBPExtreamWsService', 'http://www.tibco.com/schemas/HP_Extream_JointAccount/SharedResources/Schemas/Public/SFDC_Output.xsd', 'JBPExtreamOutput', 'http://xmlns.example.com/1362479409325', 'JBPExtreamWebserviceStub'};
        public String HPExtream_JBP(String SalesForceId,String Email_Id,String PPT_Language,String LanguageCode,String EmailLanguageCode,String Country,String CurrencyCode,String CurrencySymbol,Double ConversionCode1,Double ConversionCode2,String isFieldDefinitionsExport,String isStrategicInitiativesSummarySelectedForExport,String isCompetitiveLandscapeSelectedForExport,String isMetricsSelectedForExport,String IsPartnerEnabled,String isStrategicInitiativesDetailSelectedForExport,String userName, String password,String nonce,String dateVal) {
            JBPExtreamWsService.HPExtream_element request_x = new JBPExtreamWsService.HPExtream_element();
            JBPExtreamOutput.HPExtreamRes_element response_x;
            //Below code is hand crafted not generated from WSDL.To construct the SOAP header to pass the webservice security credentials.
            Security = new JBPExtreamWebserviceStub.Security_element(userName,password,nonce,dateVal);
           //End of code
            request_x.SalesForceId = SalesForceId;
            request_x.Email_Id = Email_Id;
            request_x.PPT_Language = PPT_Language;
            request_x.LanguageCode = LanguageCode;
            request_x.EmailLanguageCode = EmailLanguageCode;
            request_x.Country = Country;
            request_x.CurrencyCode = CurrencyCode;
            request_x.CurrencySymbol = CurrencySymbol;
            request_x.ConversionCode1 = ConversionCode1;
            request_x.ConversionCode2 = ConversionCode2;
            request_x.isFieldDefinitionsExport = isFieldDefinitionsExport;
            request_x.isStrategicInitiativesSummarySelectedForExport = isStrategicInitiativesSummarySelectedForExport;
            request_x.isCompetitiveLandscapeSelectedForExport = isCompetitiveLandscapeSelectedForExport;
            request_x.isMetricsSelectedForExport = isMetricsSelectedForExport;
            request_x.IsPartnerEnabled = IsPartnerEnabled;
            request_x.isStrategicInitiativesDetailSelectedForExport = isStrategicInitiativesDetailSelectedForExport;
            Map<String, JBPExtreamOutput.HPExtreamRes_element> response_map_x = new Map<String, JBPExtreamOutput.HPExtreamRes_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '/BusinessProcess/Services/WSDL-service.serviceagent/HPExtreamEndpoint/HPExtream_JBP',
              'http://www.tibco.com/schemas/HP_Extream_JointAccount/SharedResources/Schemas/Public/SFDC_Input.xsd',
              'HPExtream',
              'http://www.tibco.com/schemas/HP_Extream_JointAccount/SharedResources/Schemas/Public/SFDC_Output.xsd',
              'HPExtreamRes',
              'JBPExtreamOutput.HPExtreamRes_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Message;
        }
    }
    
     /*
      * Below Inner classes used to constuct the Soap header to pass the username and password for Secure Tibco webservice
      * Below code is hand crafted not generated from WSDL.
      */
      public class Security_element{
             
              public Security_element(String username, String password,String nonce,String dateVal ) {             
                     usernameToken = new UsernameToken_element(username,password,nonce,dateVal);                    
              }
        public UsernameToken_element usernameToken;
        private String[] usernameToken_type_info = new String[]{'n1:UsernameToken','http://www.w3.org/2001/XMLSchema','element','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://docs.oasis-open.org/wss/oasis-wss-wssecurity-secext-1.1.xsd','true','false'};
        private String[] field_order_type_info = new String[]{'usernameToken'};
       }

      public class UsernameToken_element {
             
              public UsernameToken_element(String username, String password,string nonce,string dateVal) {
                     this.username = username;
                     this.password = password;
                     this.nonce= nonce;
                     this.created= dateVal;                
                  }
             
        public String username;
        public String password;
        public String nonce;
        public String created;
        private String[] username_type_info = new String[]{'n1:Username','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] nonce_type_info = new String[]{'n1:Nonce','http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary','string','1','1','false'};
        private String[] created_type_info = new String[]{'n1:Created','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] password_type_info = new String[]{'n1:Password','http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://docs.oasis-open.org/wss/oasis-wss-wssecurity-secext-1.1.xsd','true','false'};
        private String[] field_order_type_info = new String[]{'username','password','nonce','created'};
    }

}