global class TechDirectControllerforCreateNewTicket {

    public static String testResponse = 'message';

    Webservice static void invokeTibcoServiceforCreateNewTicket(Id sId,String casenumber,String descrip,String CaseOwner,String CaseReason,String casescenario,String BG,String AccName,String NewAccName,String Street,String City,String State,String Zip,String Country,String subject,String region,String priority,String submitter,String casecomments, String TDQueueName) {
        Id caseid= sId ; 
        String status = '';  //response; 
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

        DOM.Document doc = createRequestforCreateNewTicket(usernameText,passwordText,sid,casenumber,descrip,CaseOwner,CaseReason,casescenario,BG,AccName,NewAccName,Street,City,State,Zip,Country,subject,region,priority,submitter,casecomments) ; 
        String clientCertificate = Label.SFDC_Certificate; 
        String serviceEndpoint = Label.TechDirect_EndpointURLforNewTicket; 
        System.debug('Debug'+serviceEndpoint);
        String xml = '';

        try{
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');           
            req.setEndpoint(serviceEndpoint);
            req.setClientCertificateName(clientCertificate); 
            req.setHeader('Content-Type','text/xml');
            req.setHeader('SOAPAction','/BusinessUseCases/Services/Case.serviceagent/TechDirect/CreateNewTicket');
            req.setTimeout(60000);
            req.setBodyDocument(doc);                    
            Http http = new Http();
            HttpResponse res = null;
            DOM.Document doc1 = new DOM.Document();
             if(Test.isRunningTest()){
                  xml =    '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                           '<SOAP-ENV:Header/>'+
                           '<SOAP-ENV:Body>'+
                           '<ns0:TechDirectNewTicket xmlns:ns0="http://www.tibco.com/schemas/CaseCreation/SharedResources/Schemas/TechDirectNewTicket.xsd">'+
                           '<ns0:Logmessage>'+
                           '<ns0:status>Success</ns0:status>'+
                           '<ns0:TicketNo>293016</ns0:TicketNo>'+
                           '<ns0:ErrorMessage/>'+
                           '</ns0:Logmessage>'+
                           '</ns0:TechDirectNewTicket>'+
                           '</SOAP-ENV:Body>'+
                           '</SOAP-ENV:Envelope>';  
            }
            else{          
            res = http.send(req);
            doc1 = res.getBodyDocument();
            xml= doc1.toXmlString();
            }           
            status = readResponse(xml);
        }
        catch(Exception e){

            System.debug('Error sending request to Tibco webservice..');
            System.debug(e.getMessage());
            status = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.';
            if(!(e.getMessage().equals('')))
                status = status + 'Error sending request to Tibco webservice: '+e.getMessage();
        }
        try{
            updateIntegrationStatus(status,caseid);
        }
        catch(DMLException dmle){
            System.debug(status);
            System.debug('Error updating: '+dmle.getMessage());

        }
    }
    
    
    private static DOM.Document createRequestforCreateNewTicket(String tibcoUsername,String tibcoPassword,String sid,String casenumber,String descrip,String CaseOwner,String CaseReason,String casescenario,String BG,String AccName,String NewAccName,String Street,String City,String State,String Zip,String Country,String subject,String region,String priority,String submitter,String casecomments){

        DOM.Document docRequest = new DOM.Document();        
        String soapNS = Label.SOAP_HEADER_NS;   //'http://schemas.xmlsoap.org/soap/envelope/';
        String xsd = Label.XML_SCHEMA_NS; //'http://www.w3.org/2001/XMLSchema';
        String wsse = Label.WSSE_SECURITY_NS ; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
        String wsu = Label.WSSE_UTILITY_NS; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
        String type = Label.WSSE_PASSWORD_TYPE;   //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest';
        String encodingType = Label.WSSE_ENCODING_TYPE; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soapmessage-security-1.0#Base64Binary';
        String sfdc = Label.Exstream_TibcoSchema ; 
        String coin = Label.TechDirectSchema; //'http://www.tibco.com/schemas/CaseCreation/SharedResources/Schemas/COINPUT.xsd';         
        List<User> u = [select Email from User where Name =: submitter LIMIT 1];
        String result = '';
        String StringIn = casecomments;
        if ((StringIn != null) && (StringIn != '')){    
          List<String> StringLines = StringIn.split('\\(',0);
          System.debug('$$$$$'+StringLines);
          for (String StringLine : StringLines) {
              if ((result != '') && (StringLine != null)) {result += '\n';}
                result += StringLine;
             }
          }  
        System.debug('#####'+result);
        string Description =    'Case Number:'+' '+ casenumber+'\n'+
                                'Description:'+' '+ descrip+'\n'+
                                'Case Owner:'+' ' +CaseOwner+'\n'+
                                'Case Reason:'+' '+ CaseReason+'\n'+
                                'Case Scenario:'+' '+casescenario+'\n'+
                                'Case Submiter:'+' '+submitter+'\n'+
                                'Case Submitter Email Id:'+' '+u[0].Email+'\n'+
                                'BG:'+BG+'\n'+
                                'Account Name:'+' '+AccName+'\n'+
                                'New Account Name:'+' '+ NewAccName+'\n'+
                                'Street:'+' '+Street+'\n'+
                                'City:'+' '+City+'\n'+
                                'State/Province:'+' '+State+'\n'+
                                'Zip/Postal Code:'+' '+Zip+'\n'+
                                'Country:'+' '+Country+'\n'+
                                'Case Comments:'+'\n'+result+'\n'+
                                'SFDC Case ID:'+' '+sId+'\n'+
                                'SFDC Case URL:'+' '+Label.SFDC_URL+sId;
        
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

        dom.XmlNode elementInput1= eleInput.addChildElement('ProvisionProperty', coin, null);
        dom.XmlNode name1 = elementInput1.addChildElement('Name', coin, null);
        name1.addTextNode('TicketTitle');
        dom.XmlNode value1 = elementInput1.addChildElement('Value',coin, null);
        value1.addTextNode(subject);
        
        dom.XmlNode elementInput2= eleInput.addChildElement('ProvisionProperty', coin, null);
        dom.XmlNode name2 = elementInput2.addChildElement('Name', coin, null);
        name2.addTextNode('Description');
        dom.XmlNode value2 = elementInput2.addChildElement('Value',coin, null);
        value2.addTextNode(Description);
        
        dom.XmlNode elementInput3= eleInput.addChildElement('ProvisionProperty', coin, null);
        dom.XmlNode name3 = elementInput3.addChildElement('Name', coin, null);
        name3.addTextNode('Categories');
        dom.XmlNode value3 = elementInput3.addChildElement('Value',coin, null);
        value3.addTextNode('SFDC Related Issues');
        
        dom.XmlNode elementInput4= eleInput.addChildElement('ProvisionProperty', coin, null);
        dom.XmlNode name4 = elementInput4.addChildElement('Name', coin, null);
        name4.addTextNode('subCategories');
        dom.XmlNode value4 = elementInput4.addChildElement('Value',coin, null);
        value4.addTextNode('SFDC Related Issues');
        
        dom.XmlNode elementInput5= eleInput.addChildElement('ProvisionProperty', coin, null);
        dom.XmlNode name5 = elementInput5.addChildElement('Name', coin, null);
        name5.addTextNode('Region');
        dom.XmlNode value5 = elementInput5.addChildElement('Value',coin, null);
        value5.addTextNode(region);
        
        dom.XmlNode elementInput6= eleInput.addChildElement('ProvisionProperty', coin, null);
        dom.XmlNode name6 = elementInput6.addChildElement('Name', coin, null);
        name6.addTextNode('Priority');
        dom.XmlNode value6 = elementInput6.addChildElement('Value',coin, null);
        value6.addTextNode(priority);
        
        System.debug('request ends'+docRequest.toXmlString());    

        return docRequest;   
    }


    private static String readResponse(String xml){
        String integrationStatus = ''; 
        XmlDom docResp = new XmlDom(xml);
        XmlDom.Element[] elements = docResp.getElementsByTagName('TicketNo');
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
            integrationStatus = elements[0].getValue('TicketNo').trim();
            System.debug('status@@@'+integrationStatus);
        }
        return integrationStatus; 

    }

    private static void updateIntegrationStatus(String status,Id sId){
        List<Case> caserec = [select id from Case where Id= :sId];
        if(caserec.size()==1){
            caserec[0].Techdirect_Case_ID__c= status;  
            update caserec; 
        }
        else 
        {
            system.debug('More than one Case Match for this Tech Direct Case Id.');
        }
    }
}