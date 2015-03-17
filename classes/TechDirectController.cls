global class TechDirectController {

    public static String testResponse = 'message';

    Webservice static void invokeTibcoServiceforUpdate(String sId) {
        String casetechid= sId ; 
        system.debug('@@@'+casetechid);
        String status = '';  //response; 
        string description ='';
        List<TibcoSecurity__c> lstPwd = [Select t.Name, t.TibcoPassword__c From TibcoSecurity__c t where t.TargetSystemName__c ='TechDirect' ];
        String passwordText = '';
        String usernameText = '';
        if(lstPwd.size()==1){
            passwordText = lstPwd[0].TibcoPassword__c;
            usernameText = lstPwd[0].Name;
        }
        else{
            System.debug('Unable to retrieve the password.');
        }

        DOM.Document doc = createRequestforUpdate(usernameText,passwordText,casetechid) ; 
        String clientCertificate = Label.SFDC_Certificate; 
        String serviceEndpoint = Label.TechDirect_EndpointURL; 
        System.debug('Debug'+serviceEndpoint);
        String xml = '';

        try{
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');           
            req.setEndpoint(serviceEndpoint);
            req.setClientCertificateName(clientCertificate); 
            req.setHeader('Content-Type','text/xml');
            req.setHeader('SOAPAction','/BusinessUseCases/Services/Case.serviceagent/TechDirect/Update');
            req.setTimeout(60000);
            req.setBodyDocument(doc);                    
            Http http = new Http();
            HttpResponse res = null;
            DOM.Document doc1 = new DOM.Document();
            if(Test.isRunningTest()){
                  xml ='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                       '<SOAP-ENV:Header/>'+
                       '<SOAP-ENV:Body>'+
                       '<ns0:Result xmlns:ns0="http://www.tibco.com/schemas/CaseCreation/SharedResources/Schemas/TechDirectResponse.xsd">'+
                       '<ns0:Success>Success</ns0:Success>'+
                       '<ns0:Data>'+
                       '<ns0:TicketStatus>New</ns0:TicketStatus>'+
                       '<ns0:TicketDescription>This is a Test Ticket, Please ignore</ns0:TicketDescription>'+
                       ' </ns0:Data>'+
                       ' </ns0:Result>'+
                       '</SOAP-ENV:Body>'+
                       '</SOAP-ENV:Envelope>';  
            }
            else{
            res = http.send(req);   
            doc1 = res.getBodyDocument();
            xml= doc1.toXmlString();  
            }       
            status = readResponseforStatus(xml);
            description = readResponseforDescription(xml);                    
        }
        catch(Exception e){

            System.debug('Error sending request to Tibco webservice..');
            System.debug(e.getMessage());
            status = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.';
            if(!(e.getMessage().equals('')))
                status = status + 'Error sending request to Tibco webservice: '+e.getMessage();
        }
        try{
            updateIntegrationStatus(status,sId,description);
        }
        catch(DMLException dmle){
            System.debug(status);
            System.debug('Error updating: '+dmle.getMessage());

        }
    }
    
    
    private static DOM.Document createRequestforUpdate(String tibcoUsername,String tibcoPassword,String salesforceId){
        DOM.Document docRequest = new DOM.Document();        
        String soapNS = Label.SOAP_HEADER_NS;   //'http://schemas.xmlsoap.org/soap/envelope/';
        String xsd = Label.XML_SCHEMA_NS; //'http://www.w3.org/2001/XMLSchema';
        String wsse = Label.WSSE_SECURITY_NS ; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
        String wsu = Label.WSSE_UTILITY_NS; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
        String type = Label.WSSE_PASSWORD_TYPE;   //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest';
        String encodingType = Label.WSSE_ENCODING_TYPE; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soapmessage-security-1.0#Base64Binary';
        String sfdc = Label.Exstream_TibcoSchema ; 
        String coin = Label.TechDirectSchema; //'http://www.tibco.com/schemas/CaseCreation/SharedResources/Schemas/COINPUT.xsd';         

        dom.XmlNode envelope= docRequest.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('coin',coin);   
        dom.XmlNode header= envelope.addChildElement('Header', soapNS, null);
        dom.XmlNode security = header.addChildElement('Security', wsse, 'wsse');
        security.setAttributeNs('soapenv:mustUnderstand','1',null,null);                   
        security.setNamespace('wsu',wsu);                    
        dom.XmlNode usernameToken = security.addChildElement('UsernameToken', wsse, 'wsse');  
        usernameToken.setAttributeNs('wsu:Id','UsernameToken-5',null,null);                
        DateTime d = System.now();
        String createdStr = d.formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');
        String nonceStr = String.valueOf(Crypto.getRandomInteger());                           
        Blob passBlob= Blob.valueOf(nonceStr+ createdStr+ tibcoPassword);
        String passwordStr = EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',passBlob));
        Blob nonceBlob = Blob.valueOf(nonceStr);
        nonceStr=EncodingUtil.base64Encode(nonceBlob);                
        dom.XmlNode userName = usernameToken.addChildElement('Username', wsse, 'wsse');
        userName.addTextNode(tibcoUsername);
        dom.XmlNode password= usernameToken.addChildElement('Password', wsse, 'wsse');
        password.setAttribute('Type',type);
        password.addTextNode(passwordStr);
        dom.XmlNode nonce= usernameToken.addChildElement('Nonce', wsse, 'wsse');
        nonce.setAttribute('EncodingType', encodingType);
        nonce.addTextNode(nonceStr);
        dom.XmlNode created = usernameToken.addChildElement('Created', wsu, 'wsu');
        created.addTextNode(createdStr);
        dom.XmlNode body= envelope.addChildElement('Body', soapNS, null);            
        dom.XmlNode eleInput= body.addChildElement('CaseCreation', coin, null); 
        dom.XmlNode applicationId = eleInput.addChildElement('Application', coin, null);
        applicationId .addTextNode('sfdc');
        dom.XmlNode request_Type = eleInput.addChildElement('RequestType',coin, null);
        request_Type.addTextNode('update');  

        dom.XmlNode elementInput= eleInput.addChildElement('ProvisionProperty', coin, null);
        dom.XmlNode name = elementInput.addChildElement('Name', coin, null);
        name.addTextNode('TicketNumber');
        dom.XmlNode value = elementInput.addChildElement('Value',coin, null);
        value.addTextNode(salesforceId);  


        System.debug('request ends'+docRequest);    

        return docRequest;   
    }


    private static String readResponseforStatus(String xml){
        String integrationStatus = ''; 
        XmlDom docResp = new XmlDom(xml);
        XmlDom.Element[] elements = docResp.getElementsByTagName('TicketStatus');
        system.debug('#######'+elements );
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
            integrationStatus = elements[0].getValue('TicketStatus').trim();
            System.debug('******'+integrationStatus);
        }
        return integrationStatus; 

    }
    
    private static String readResponseforDescription(String xml){
        String Description = '';
        XmlDom docResp = new XmlDom(xml);
        XmlDom.Element[] elements1 = docResp.getElementsByTagName('TicketDescription');
        system.debug('#######'+elements1);
        if(elements1.size()==0){
            XmlDom.Element[] elementsFault = docResp.getElementsByTagName('Fault');
            if(elementsFault.size()!=0){
                System.debug('SOAP Env. fault');
                Description = elementsFault[0].getValue('faultstring').trim();
                if(Description.startsWith('WS'))
                    Description = Description+'. WSSE Authentication failed. ';
            }
            else{   
                System.debug(' Invalid response received: '+xml);
                Description = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later. Response received: '+xml;
            }
        }
        else{
            Description = elements1[0].getValue('TicketDescription').trim();
            System.debug('%%%%%%'+Description );
        }
        return Description ; 

    }

    private static void updateIntegrationStatus(String status,String sId,string description){
        List<Case> caserec = [select id from Case where Techdirect_Case_ID__c = :sId];
        if(caserec.size()==1){
            caserec[0].Techdirect_Status__c = status;  
            caserec[0].Techdirect_Notes__c = description; 
            update caserec; 
        }
        else 
        {
            system.debug('More than one Case Match for this Tech Direct Case Id.');
        }
    }
}