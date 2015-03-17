/**
* NAME : AptsTibcoWebServiceUtilClass
* NOTE : This is Utility class to call Tibco Employee ED Hierarchy WebService 
* Author : Apttus (Shabbir & Axay)
*/
public class AptsTibcoWebServiceUtilClass
{
	public static List<EmployeeBean> getEmpHierarchyData(String empNo){
        
        
        List<EmployeeBean> listEmp = new List<EmployeeBean>();
        // Fetch userName and password for Exstream from TibcoSecurity__c - START
        List<TibcoSecurity__c> lstPwd = [Select t.Name, t.TibcoPassword__c From TibcoSecurity__c t where t.TargetSystemName__c = 'ApttusToEd' ];
        String passwordText = '';
        String usernameText = '';
		
		if(lstPwd.size()==1){
            passwordText = lstPwd[0].TibcoPassword__c;
            usernameText = lstPwd[0].Name;
            
        } else {
        	System.debug('Unable to retrieve the password.');
        }
                
        DOM.Document doc = createRequest(empNo,'Hierarchy',usernameText, passwordText) ; //empNo = 20048910
        
        Apttus__APTS_Admin__c adminEntry = new Apttus__APTS_Admin__c();
		adminEntry = [SELECT ID,NAME,Apttus__Value__c FROM Apttus__APTS_Admin__c WHERE NAME = 'APTS_TibcoWebServiceEndPoint' LIMIT 1];
		
		HttpRequest req = new HttpRequest();
        req.setMethod('POST'); 
        req.setBodyDocument(doc);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction','/BusinessUseCases/Services/ED');
        req.setEndpoint(adminEntry.Apttus__Value__c);
        req.setTimeout(60000);
        req.setClientCertificateName('SFDC_Certificate');
        
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        res = http.send(req);
        
        if(res.getStatus() == 'OK' || res.getStatus() == 'Created'){
        	DOM.Document myXmldoc = new DOM.Document();
        	myXmldoc = res.getBodyDocument();
        	String xml = myXmldoc.toXmlString();
        	ApttusParsXMLDomClassUtil apts = new ApttusParsXMLDomClassUtil(); // send for Parsing
			listEmp = apts.parse(xml); 
        }
        else {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'SORRY...NO Response from Webservice.'));
        }
          
        return listEmp;   
    }
	//Create XML DOME for HTTP Request
	public static DOM.Document createRequest(String empNo, String reqType, String tibcoUsername, String tibcoPassword){    
        DOM.Document docRequest = new DOM.Document();        
        String soapNS = Label.SOAP_HEADER_NS;   //'http://schemas.xmlsoap.org/soap/envelope/';
        String xsd = Label.XML_SCHEMA_NS; //'http://www.w3.org/2001/XMLSchema';
        String wsse = Label.WSSE_SECURITY_NS ; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
        String wsu = Label.WSSE_UTILITY_NS; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
        String type = Label.WSSE_PASSWORD_TYPE;   //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest';
        String encodingType = Label.WSSE_ENCODING_TYPE; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soapmessage-security-1.0#Base64Binary';
        String sfdc = Label.Exstream_TibcoSchema ; 
        String ed = Label.ApttusToEdSchema; //'http://www.tibco.com/schemas/EDInterface/BusinessUseCases/SharedResources/Schemas/ED';       
        
        dom.XmlNode envelope= docRequest.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('ed',ed);    
        
        dom.XmlNode header= envelope.addChildElement('Header', soapNS, null);
        dom.XmlNode security = header.addChildElement('Security', wsse, 'wsse');
        
        security.setAttributeNs('soapenv:mustUnderstand','1',null,null);                   
        security.setNamespace('wsu',wsu);                    
        
        dom.XmlNode usernameToken = security.addChildElement('UsernameToken', wsse, 'wsse');  
        usernameToken.setAttributeNs('wsu:Id','UsernameToken-5',null,null);                
        
        DateTime d = System.now();
        String createdStr = d.formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');
        String nonceStr = String.valueOf(Crypto.getRandomInteger());                           
        Blob passBlob = Blob.valueOf(nonceStr+ createdStr+ tibcoPassword);
        String passwordStr = EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',passBlob));
        Blob nonceBlob = Blob.valueOf(nonceStr);
        nonceStr = EncodingUtil.base64Encode(nonceBlob);                
        
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
        dom.XmlNode eleInput= body.addChildElement('ED', ed, null);                                      
        
        if(reqType.equals('Single')){
            dom.XmlNode request_Type = eleInput.addChildElement('RequestType',ed, null);
            request_Type.addTextNode('Single');        
            dom.XmlNode Salesforce_id= eleInput.addChildElement('EMPID', ed, null);
            Salesforce_id.addTextNode(empNo);//00647066(suresh) //20094479
        
        }else if(reqType.equals('Search')){
            dom.XmlNode Salesforce_id = eleInput.addChildElement('EMPID', ed, null);
            Salesforce_id.addTextNode(empNo);
            dom.XmlNode request_Type = eleInput.addChildElement('RequestType',ed, null);
            request_Type.addTextNode('Search');
        
        }else{
            dom.XmlNode Salesforce_id = eleInput.addChildElement('EMPID', ed, null);
            Salesforce_id.addTextNode(empNo);//00647066 
            dom.XmlNode request_Type = eleInput.addChildElement('RequestType',ed, null);
            request_Type.addTextNode('Hierarchy');
        }                              
        return docRequest;  
    }
}