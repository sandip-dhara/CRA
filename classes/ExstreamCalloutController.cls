global class ExstreamCalloutController {

     
    public static String testResponse = 'message';
   


     Webservice static void invokeTibcoService(String sId, String pptType) {
   
    //  System.debug(sId);
    //  System.debug(pptType);
      String accPlanId = sId ; 
      String status = '';  //response; 
     
     
     // If PPT type is Customer, check if records exist = START
        List<Customer_Business_Priority__c> lstCustBuPriority = [Select Timing__c, Short_Description__c,Priority__c, Name,Detailed_Description__c,Account_Plan__r.name  From Customer_Business_Priority__c where Account_Plan__c =:sId];

        //System.debug(lstCustBuPriority.size());
        List<Customer_Relationship_Map__c> lstCRM= [Select Title__c, Scope_of_the_contact__c, Role__c, EG_ESSN__c, Contact__r.name, Aligned_HP_Exec__r.name, Account_Plan__r.name From Customer_Relationship_Map__c  where Account_Plan__c=:sId];

      
        if(pptType.toUpperCase().equals('CUSTOMER') && lstCustBuPriority.size()==0 && lstCRM.size()==0){
            System.debug('No data to fetch');
            status = 'Associate records not found for the customer report';
        }

    else{     
        // If PPT type is Customer, check if records exist - END     
        // Fetch user email Id - START
            String userEmail='';
            String userId =  UserInfo.getUserId();
            List<User> userDetails = [SELECT Id, Name, email, Username FROM User  where  Id =:userId];
            
            if(userDetails.size()==1)
                userEmail = userDetails[0].email ; 
            else
                System.debug('More than one user details record was returned for this User');  
      //      System.debug(userEmail);
           
            // Fetch user email Id - END 
            
            // Fetch userName and password for Exstream from TibcoSecurity__c - START
                List<TibcoSecurity__c> lstPwd = [Select t.Name, t.TibcoPassword__c From TibcoSecurity__c t where t.TargetSystemName__c ='Exstream' ];
        //        System.debug(lstPwd.size());
                String passwordText = '';
                String usernameText = '';
                if(lstPwd.size()==1){
                    passwordText = lstPwd[0].TibcoPassword__c;
                    usernameText = lstPwd[0].Name;
                }
                else
                    System.debug('Unable to retrieve the password.');
          //      System.debug(passwordText);
          //      System.debug(usernameText);
            // Fetch userName and password for Exstream from TibcoSecurity__c - END
            
            // create request 
            
                DOM.Document doc = createRequest(usernameText, passwordText, sId, userEmail, pptType) ; 
            
             
              // Read client certificate name from Custom Labels. 
                String clientCertificate = Label.SFDC_Certificate; 
                // Read Proxy (SRP) endpoint URL from Custom labels. 
                String serviceEndpoint = Label.Exstream_EndpointURL; 
                String xml = '';
               
             
             // HTTP Request to WS - START 
                        
                try{
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST');
                 //   req.setEndpoint('http://postbin.defensio.com/6c153f0');
               //    req.setEndpoint('https://g5t1173g.atlanta.hp.com/Tibco/Services/ServiceAgent.serviceagent/SFDC');  // ITG

                //    req.setEndpoint('https://g5t1173g.atlanta.hp.com/BusinessProcesses/ProcessStarters/Server');   //https://g5t1173g.atlanta.hp.com/hpit/sfdc/itg/exstream');
                
                    req.setEndpoint(serviceEndpoint);
                   
                    req.setHeader('Content-Type', 'text/xml');
                    req.setHeader('SOAPAction','/BusinessUseCases/Services/ServiceAgent.serviceagent/PortTypeEndpoint1/Operation');
                    req.setTimeout(60000);
             
                    req.setClientCertificateName(clientCertificate);

                    req.setBodyDocument(doc);
                    Http http = new Http();
                    HttpResponse res = null;
                     DOM.Document doc1 = new DOM.Document();
                    
                    if(Test.isRunningTest()){
                    
                    
                        if(testResponse.equals('message')){
                    
                                xml = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                                       '<SOAP-ENV:Header/>'+
                                        '<SOAP-ENV:Body>'+
                                          '<ns0:root xmlns:ns0="http://www.tibco.com/schemas/Policy/SharedResources/Schemas/Public/SFDC_OUTPUT.xsd">'+
                                             '<ns0:Message>PPT report will be emailed to you in an attachment</ns0:Message>'+
                                              '</ns0:root>'+
                                               '</SOAP-ENV:Fault>'+
                                                   '</SOAP-ENV:Body>'+
                                                    '</SOAP-ENV:Envelope>';
                    
                        }
                    
                            else if (testResponse.equals('SOAPFault')){
                    
                                        xml = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                                       '<SOAP-ENV:Header/>'+
                                        '<SOAP-ENV:Body>'+
                                              '<SOAP-ENV:Fault>'+
                                                 '<faultcode>SOAP-ENV:Server</faultcode>'+
                                                     '<faultstring>WS Security Error : 5</faultstring>'+
                                                 '<faultactor/>'+
                                                  '</SOAP-ENV:Fault>'+
                                                   '</SOAP-ENV:Body>'+
                                                    '</SOAP-ENV:Envelope>';
                    
                            }
                    
                            else{
                    
                    
                                        xml = '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">'+
                                                    '<html><head>'+
                                                        '<title>502 Bad Gateway</title>'+
                                                        '</head><body>'+
                                                        '<h1>Bad Gateway</h1>'+
                                                        '<p>The proxy server received an invalid'+
                                                           'response from an upstream server.<br />'+
                                                            '</p>'+
                                                                '</body></html>';

                    
                            }
                    
                    
                    
                         System.debug('Response for Test: '+xml);
                         
                        // doc1.load(xml);
                    
                    }
                    
                    else{
                    
                    res = http.send(req);   
                    doc1 = res.getBodyDocument();
                    xml= doc1.toXmlString();
                    System.debug(xml);
                    
                    
                    }
                  
                               
            // Handle response - sTARt
            
                    status = readResponse(xml);
            
            // Handle response - END     
                
                
             }
             catch(Exception e){
             
                 System.debug('Error sending request to Tibco webservice..');
                 System.debug(e.getMessage());
        //         status= 'Error sending request to Tibco webservice: '+e.getMessage(); 
                    status = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.';
                    if(!(e.getMessage().equals('')))
                        status = status + 'Error sending request to Tibco webservice: '+e.getMessage();
                 
             }
             
             
            // HTTP Request to WS - END 
            
     } // end else     
     
     
    // Update field - START
    
        try{
                updateIntegrationStatus(status,sId,pptType );
            }
        catch(DMLException dmle){
                System.debug(status);
                System.debug('Error updating: '+dmle.getMessage());
    
        }
            
          
            
    // Update field - END

    }
    
    private static DOM.Document createRequest(String usernameText, String passwordText,String salesforceId, String userEmail, String pptType){
    
                DOM.Document docRequest = new DOM.Document();
                
                String soapNS = Label.SOAP_HEADER_NS;   //'http://schemas.xmlsoap.org/soap/envelope/';
                String xsd = Label.XML_SCHEMA_NS; //'http://www.w3.org/2001/XMLSchema';
                String wsse = Label.WSSE_SECURITY_NS ; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
                String wsu = Label.WSSE_UTILITY_NS; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
                String type = Label.WSSE_PASSWORD_TYPE;   //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest';
                String encodingType = Label.WSSE_ENCODING_TYPE; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soapmessage-security-1.0#Base64Binary';
                String sfdc = Label.Exstream_TibcoSchema ; 
                
               
                dom.XmlNode envelope
                    = docRequest.createRootElement('Envelope', soapNS, 'soapenv');
                envelope.setNamespace('sfdc',sfdc);
            
                dom.XmlNode header
                    = envelope.addChildElement('Header', soapNS, null);
                    
                dom.XmlNode security
                    = header.addChildElement('Security', wsse, 'wsse');
                security.setAttributeNs('soapenv:mustUnderstand','1',null,null);   
                
                security.setNamespace('wsu',wsu);
                    
                dom.XmlNode usernameToken
                    = security.addChildElement('UsernameToken', wsse, 'wsse');  

                usernameToken.setAttributeNs('wsu:Id','UsernameToken-5',null,null);
                
                DateTime d = System.now();
                String createdStr = d.formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');
                //String created1 = d.formatGmt('yyyy-MM-dd');
                //String created2 = d.formatGmt('HH:mm:ss.SSS');
                //String createdAttr = created1 +'T'+ created2 +'Z';
                //System.debug(createdAttr);

                String nonceStr = String.valueOf(Crypto.getRandomInteger());
                            
                Blob passBlob= Blob.valueOf(nonceStr+ createdStr+ passwordText);
                String passwordStr = EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',passBlob));
                Blob nonceBlob = Blob.valueOf(nonceStr);
                nonceStr=EncodingUtil.base64Encode(nonceBlob);
                
                dom.XmlNode userName
                    = usernameToken.addChildElement('Username', wsse, 'wsse');
        //        userName.addTextNode('tibadmin');
                userName.addTextNode(usernameText);
                dom.XmlNode password
                    = usernameToken.addChildElement('Password', wsse, 'wsse');
                password.setAttribute('Type',type);
                password.addTextNode(passwordStr);
                dom.XmlNode nonce
                    = usernameToken.addChildElement('Nonce', wsse, 'wsse');
                nonce.setAttribute('EncodingType', encodingType);
                nonce.addTextNode(nonceStr);
                dom.XmlNode created
                    = usernameToken.addChildElement('Created', wsu, 'wsu');
                created.addTextNode(createdStr);

                
                dom.XmlNode body
                    = envelope.addChildElement('Body', soapNS, null);
                    
                       dom.XmlNode eleInput
                    = body.addChildElement('root', sfdc, 'sfdc');
                
                dom.XmlNode Salesforce_id
                    = eleInput.addChildElement('SalesForceId', sfdc, 'sfdc');
                Salesforce_id.addTextNode(salesforceId); 
                
                
                dom.XmlNode Email_Id
                    = eleInput.addChildElement('Email_Id', sfdc, 'sfdc');
                Email_Id.addTextNode(userEmail); 
                
                dom.XmlNode PPT_Type
                    = eleInput.addChildElement('PPT_Type', sfdc, 'sfdc');
                PPT_Type.addTextNode(pptType); 
                
                return docRequest; 
    
    }
    
    
    private static String readResponse(String xml){
                    
                    String integrationStatus = ''; 
      
                    XmlDom docResp = new XmlDom(xml);
            //        System.debug(xml);
                    XmlDom.Element[] elements = docResp.getElementsByTagName('root');
                    if(elements.size()==0){
                    
                        XmlDom.Element[] elementsFault = docResp.getElementsByTagName('Fault');
                            if(elementsFault.size()!=0){
                                System.debug('SOAP Env. fault');
                                integrationStatus = elementsFault[0].getValue('faultstring').trim();
                                if(integrationStatus.startsWith('WS'))
                                    integrationStatus = integrationStatus +'. WSSE Authentication failed. ';
                                
                            }
                            else{   
                                     System.debug(' Invalid response received: '+xml);
                                    integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later. Response received: '+xml;
                            }
                    
                    
                    }
                    else{
                        integrationStatus = elements[0].getValue('Message').trim();
                        System.debug(integrationStatus);
                    }
            
            
            return integrationStatus; 
    
    }
    
    
    private static void updateIntegrationStatus(String status,String sId, String pptType ){
    
    
    if(pptType.equals('Exec')){
            List<Account_Plan__c> ac = [select id  from Account_Plan__c where id = :sId];
            if(ac.size()==1){
            ac[0].Integration_status_execSummaryReport__c = status;  
            update ac; 
            }
            else 
            {
            system.debug('More than one Account plan for this Id.');
            }
            
        }
        
        else if(pptType.equals('Customer')) {
           

            List<Account_Plan__c> ac = [select id  from Account_Plan__c where id = :sId];
            try{
              
                if(ac.size()==1){
                ac[0].Integration_status_customerReport__c = status;  
               
                update ac; 
               
                }
                else 
                {
                    System.debug('More than one Account plan for this Id.');
                }
            }
            catch(DMLException dmle){
                System.debug(status);
                System.debug('Error updating: '+dmle.getMessage());
    
        }
    
        }
        else{
            List<Business_Unit_Plan__c> bu = [select id  from Business_Unit_Plan__c where id = :sId];
                if(bu.size()==1){
            bu[0].Integration_status_buPlanReport__c = status;  
            update bu; 
            }
            else 
            {
            system.debug('More than one BU plan for this Id.');
            }
        
        }
     
   
    
    }
    
    public static void testSOAPFault(String sId, String type){
    
        invokeTibcoService(sId, type);
        testResponse = 'SOAPFault'; 
    }
    
    public static void testException(String sId, String type){
        invokeTibcoService(sId, type);
        testResponse = 'Exception'; 
    }
    
}