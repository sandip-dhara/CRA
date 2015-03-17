public class OpptySummAMID2HPFSCtrller {
    public transient String employeeNumber {get; set;}
    public transient String soapActionHPFS {get; set;}
    public transient String respStringRepHPFS {get; set;}
    //public List<AMID2HPFSResults> amid2ResultsListHPFS {get; set;}
    
    // Constructor. Webservice callout is triggered from constructor.
    public OpptySummAMID2HPFSCtrller(ApexPages.StandardController controller) {        
        if(ApexPages.currentPage().getParameters().get('AMIDL2') != null) {
           employeeNumber = ApexPages.currentPage().getParameters().get('AMIDL2');
        }
    }

    /*public class AMID2HPFSResults {
        public String OPPORTUNITYIDENTIFIER {get; set;}
        public String CUSTOMERPROFILENAME {get; set;}
        public String PRIMARYSALESREP {get; set;}
        public String OPPORTUNITYDESCRIPTION {get; set;}
        public Decimal HPFSTOTALOPPORTUNITYVALUEUSD;
        public String PRIMARYGBU {get; set;}
        public String REASONWONORLOSTCODE {get; set;}
        public Integer TOTALDAYSINOPENSALESSTAGES {get; set;}
        public String CLOSEFISCALQUARTER {get; set;}
        public String LASTUPDATEDDATE {get; set;}
        public String OPPORTUNITYTYPECODE {get; set;}
        public String AMIDL2 {get; set;}
        public String AMIDL2ID {get; set;}
        public String FULFILLMENTCHANNEL {get; set;}
        public String UPSIDEINDICATORCODE {get; set;}
        public String FORECASTEDINDICATOR {get; set;}
        public String OPPORTUNITYSTATUSCODE {get; set;}
        public String CLOSEDATE {get; set;}
        public String CURRENTSALESSTAGECODE {get; set;}
        public String OPPORTUNITYNAME {get; set;}    
        public Integer getHPFSTOTALOPPORTUNITYVALUEUSD(){
            if(HPFSTOTALOPPORTUNITYVALUEUSD==null || HPFSTOTALOPPORTUNITYVALUEUSD==0){
                HPFSTOTALOPPORTUNITYVALUEUSD=0.0;
                //return '';
                return 0;
            } else {   
                //return  '$'+(HPFSTOTALOPPORTUNITYVALUEUSD.setScale(2)).toPlainString();
                //return  '$'+HPFSTOTALOPPORTUNITYVALUEUSD.setScale(0).toPlainString();
                return Integer.valueOf(HPFSTOTALOPPORTUNITYVALUEUSD.setScale(0));
            }
        }
    }
    
    public String getReportResultsHPFS(String soapActionHPFS) {
        // Obtain the password from Tibco Security Object.
        String passwordText = '';
        String usernameText = '';
        List<TibcoSecurity__c> lstPwd = [Select t.Name, t.TibcoPassword__c From TibcoSecurity__c t where t.TargetSystemName__c ='SALESOPPTYREPORTS' ];

        if(lstPwd.size()==1){
            passwordText = lstPwd[0].TibcoPassword__c;
            usernameText = lstPwd[0].Name;
        } else {
            passwordText = '';
            usernameText = '';
        }
        
        // Opportunity summary count operation
        Dom.document countReqOperation = new Dom.document();
        dom.XmlNode countReqEnvelope
            = countReqOperation.createRootElement('Envelope', Label.SOAP_HEADER_NS, 'soapenv');
        countReqEnvelope.setNamespace('xsd', Label.INFORMATICA_NS);
        dom.XmlNode countReqHeader
            = countReqEnvelope.addChildElement('Header', Label.SOAP_HEADER_NS, null);
        dom.XmlNode countReqSecurity
            = countReqHeader.addChildElement('Security', Label.WSSE_SECURITY_NS, 'wsse');
        countReqSecurity.setAttributeNs('soapenv:mustUnderstand','1',null,null);   
        countReqSecurity.setNamespace('wsu',Label.WSSE_UTILITY_NS);        
        dom.XmlNode countReqUsernameToken
            = countReqSecurity.addChildElement('UsernameToken', Label.WSSE_SECURITY_NS, 'wsse');  
        countReqUsernameToken.setAttributeNs('wsu:Id','UsernameToken-79',null,null);
        
        DateTime countOpDate = System.now();
        String countReqCreatedStr = countOpDate.formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');
        String countReqNonceStr = String.valueOf(Crypto.getRandomInteger());
        Blob countReqPassBlob = Blob.valueOf(countReqNonceStr+countReqCreatedStr+passwordText);
        String countReqPasswordStr = EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',countReqPassBlob));
        Blob countReqNonceBlob = Blob.valueOf(countReqNonceStr);
        countReqNonceStr = EncodingUtil.base64Encode(countReqNonceBlob);

        dom.XmlNode countReqUserName
            = countReqUsernameToken.addChildElement('Username', Label.WSSE_SECURITY_NS, 'wsse');
        countReqUserName.addTextNode(userNameText);
        dom.XmlNode countReqPassword
            = countReqUsernameToken.addChildElement('Password', Label.WSSE_SECURITY_NS, 'wsse');
        countReqPassword.setAttribute('Type',Label.WSSE_PASSWORD_TYPE);
        countReqPassword.addTextNode(countReqPasswordStr);
        dom.XmlNode countReqNonce
            = countReqUsernameToken.addChildElement('Nonce', Label.WSSE_SECURITY_NS, 'wsse');
        countReqNonce.setAttribute('EncodingType', Label.WSSE_ENCODING_TYPE);
        countReqNonce.addTextNode(countReqNonceStr);
        dom.XmlNode countReqCreated
            = countReqUsernameToken.addChildElement('Created', Label.WSSE_UTILITY_NS, null);
        countReqCreated.addTextNode(countReqCreatedStr);
        dom.XmlNode countReqBody
            = countReqEnvelope.addChildElement('Body', Label.SOAP_HEADER_NS, null);      
        dom.XmlNode count_Req_SFDC_EDW_POC_Manager_View_Operation
            = countReqBody.addChildElement('RecordCount_Input', Label.INFORMATICA_NS, null);  
        dom.XmlNode count_Req_RESP_WRKFRC_ID
            = count_Req_SFDC_EDW_POC_Manager_View_Operation.addChildElement('AMIDL2ID', Label.INFORMATICA_NS, null);

        if(employeeNumber == null) {
           employeeNumber = ' '; 
        }    
        count_Req_RESP_WRKFRC_ID.addTextNode(employeeNumber); 

        HttpRequest countReq = new HttpRequest();
        countReq.setMethod('POST');
        countReq.setEndpoint(Label.OPPTYSUMMARY_ENDPOINTURL);
        //countReq.setEndpoint('https://g5t1173g.atlanta.hp.com/Tibco/Dev/Services/OpportunitySummaryService.serviceagent/OpportunitySummaryEndpoint');
        countReq.setHeader('Content-Type', 'text/xml');

        countReq.setBodyDocument(countReqOperation);
        countReq.setHeader('SOAPAction', Label.OPPTYSUMMARY_HPFSCOUNT);
        //countReq.setHeader('SOAPAction', '/Services/OpportunitySummaryService.serviceagent/OpportunitySummaryEndpoint/OperationOpportunityHPFSSummaryCount');
        countReq.setClientCertificateName(Label.SFDC_Certificate);

        HttpResponse countRes = null;
        transient DOM.Document countOpRes = new DOM.Document();
        boolean isError = false;
        try {
            Http countOpHttp = new Http();
            countRes = countOpHttp.send(countReq);
            countOpRes = countRes.getBodyDocument();
        } catch (Exception ex) {
            String integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.'; 
            ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
            ApexPages.addMessage(newMessage);
            isError = true;
            countOpRes = null;
        }
        dom.XmlNode recordCountOutput = null;
        dom.XmlNode countResHeader = null;
        if (countOpRes != null) {
            dom.XmlNode countResEnv = countOpRes.getRootElement();
            countResHeader = countResEnv.getChildElement('Body', Label.SOAP_HEADER_NS);
            if(countResHeader != null) {
                recordCountOutput = countResHeader.getChildElement('RecordCount_Output', Label.INFORMATICA_NS);
            }
        }
        integer totalNoOfRecs = 0;
        
        if (recordCountOutput != null) {
            totalNoOfRecs = Integer.valueOf(recordCountOutput.getChildElement('RECORD_COUNT', Label.INFORMATICA_NS).getText());
        } else {
            dom.XmlNode fault = null;
            if (countResHeader != null) {
                fault = countResHeader.getChildElement('Fault', Label.SOAP_HEADER_NS);
            }
            totalNoOfRecs =0;       
            isError = true;
            if (fault != null) {    
                String faultCode = fault.getChildElement('faultcode', Label.SOAP_HEADER_NS).getText();
                String faultMessage = fault.getChildElement('faultstring', Label.SOAP_HEADER_NS).getText();
                ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, faultCode + ' '+ faultMessage);
                ApexPages.addMessage(newMessage);        
            } else {
                String integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.'; 
                ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
                ApexPages.addMessage(newMessage);
            }
        }
        
        if(totalNoOfRecs == 0 && !isError) {
            ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Info, 'No results to display');
            ApexPages.addMessage(newMessage);
            amid2ResultsListHPFS = new List<AMID2HPFSResults> ();
        }
    
        if (totalNoOfRecs != 0) {
            // Opportunity Summary Operation
            DOM.Document doc = new DOM.Document();
            dom.XmlNode envelope
                = doc.createRootElement('Envelope', Label.SOAP_HEADER_NS, 'soapenv');
            envelope.setNamespace('xsd', Label.INFORMATICA_NS);
            
            dom.XmlNode header
                = envelope.addChildElement('Header', Label.SOAP_HEADER_NS, null);
                
            dom.XmlNode security
                = header.addChildElement('Security', Label.WSSE_SECURITY_NS, 'wsse');
            security.setAttributeNs('soapenv:mustUnderstand','1',null,null);   
            security.setNamespace('wsu',Label.WSSE_UTILITY_NS);        

            dom.XmlNode usernameToken
                = security.addChildElement('UsernameToken', Label.WSSE_SECURITY_NS, 'wsse');  
            usernameToken.setAttributeNs('wsu:Id','UsernameToken-79',null,null);
           
            DateTime opDate = System.now();
            String createdStr = opDate.formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');
            String nonceStr = String.valueOf(Crypto.getRandomInteger());
            Blob passBlob= Blob.valueOf(nonceStr+ createdStr+ passwordText);
            String passwordStr = EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',passBlob));
            Blob nonceBlob = Blob.valueOf(nonceStr);
            nonceStr=EncodingUtil.base64Encode(nonceBlob);
            
            dom.XmlNode userName
                = usernameToken.addChildElement('Username', Label.WSSE_SECURITY_NS, 'wsse');
            userName.addTextNode(usernameText);
            dom.XmlNode password
                = usernameToken.addChildElement('Password', Label.WSSE_SECURITY_NS, 'wsse');
            password.setAttribute('Type',Label.WSSE_PASSWORD_TYPE);
            password.addTextNode(passwordStr);
            dom.XmlNode nonce
                = usernameToken.addChildElement('Nonce', Label.WSSE_SECURITY_NS, 'wsse');
            nonce.setAttribute('EncodingType', Label.WSSE_ENCODING_TYPE);
            nonce.addTextNode(nonceStr);
            dom.XmlNode created
                = usernameToken.addChildElement('Created', Label.WSSE_UTILITY_NS, null);
            created.addTextNode(createdStr);
            
            dom.XmlNode body
                = envelope.addChildElement('Body', Label.SOAP_HEADER_NS, null);
            dom.XmlNode ldo_SFDC_EDW_POC_Manager_View_Operation
                  = body.addChildElement('Oppty_Summ_Input', Label.INFORMATICA_NS, null);      
            dom.XmlNode RESP_WRKFRC_ID
                  = ldo_SFDC_EDW_POC_Manager_View_Operation.addChildElement('AMIDL2ID', Label.INFORMATICA_NS, null);
            if(employeeNumber == null) {
               employeeNumber = ' '; 
            }

            RESP_WRKFRC_ID.addTextNode(employeeNumber); 
            dom.XmlNode REC_NUM
                = ldo_SFDC_EDW_POC_Manager_View_Operation.addChildElement('START_ROW_NUMBER', Label.INFORMATICA_NS, null);     
            REC_NUM.addTextNode(String.valueOf(0));             
            dom.XmlNode NUMRECORDS
                = ldo_SFDC_EDW_POC_Manager_View_Operation.addChildElement('NO_OF_RECORDS', Label.INFORMATICA_NS, null);      
            NUMRECORDS.addTextNode(String.valueOf(totalNoOfRecs)); 
            
            // Send the request 
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(Label.OPPTYSUMMARY_ENDPOINTURL);
            //req.setEndpoint('https://g5t1173g.atlanta.hp.com/Tibco/Dev/Services/OpportunitySummaryService.serviceagent/OpportunitySummaryEndpoint');
            req.setHeader('Content-Type', 'text/xml');

            req.setBodyDocument(doc);
            req.setHeader('SOAPAction', soapActionHPFS);
            //req.setHeader('SOAPAction', '/Services/OpportunitySummaryService.serviceagent/OpportunitySummaryEndpoint/OpportunitySummaryHPFS');
            req.setClientCertificateName(Label.SFDC_Certificate);
            
            Http http = new Http();
            HttpResponse res = null;
            DOM.Document doc1 = new DOM.Document();
            try {
                res = http.send(req);
                doc1 = res.getBodyDocument();
                respStringRepHPFS = doc1.toXmlString();
            } catch (Exception ex) {
                String integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.'; 
                ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
                ApexPages.addMessage(newMessage);
            }
        }   
        return respStringRepHPFS ;
    }
    
    // Method used to parse the response xml
    public AMID2HPFSResults parseResponseXmlDomHPFS(dom.XmlNode node, String servNS){
        AMID2HPFSResults amid2XML = new AMID2HPFSResults();
        if (node.getChildElement('OPPORTUNITYIDENTIFIER',servNS) != null) {                         
            amid2XML.OPPORTUNITYIDENTIFIER = node.getChildElement('OPPORTUNITYIDENTIFIER',servNS).getText().trim();
        }
        if (node.getChildElement('CUSTOMERPROFILENAME',servNS) != null) {
            amid2XML.CUSTOMERPROFILENAME = node.getChildElement('CUSTOMERPROFILENAME',servNS).getText().trim();
        }
        if (node.getChildElement('PRIMARYSALESREP',servNS) != null) {
            amid2XML.PRIMARYSALESREP  = node.getChildElement('PRIMARYSALESREP',servNS).getText().trim();
        }
        if (node.getChildElement('OPPORTUNITYDESCRIPTION',servNS) != null) {
            amid2XML.OPPORTUNITYDESCRIPTION = node.getChildElement('OPPORTUNITYDESCRIPTION',servNS).getText().trim();
        }
        if (node.getChildElement('HPFSTOTALOPPORTUNITYVALUEUSD',servNS) != null) {
            amid2XML.HPFSTOTALOPPORTUNITYVALUEUSD = Decimal.valueOf(node.getChildElement('HPFSTOTALOPPORTUNITYVALUEUSD',servNS).getText().trim());
        }
        if (node.getChildElement('PRIMARYGBU',servNS) != null) {
            amid2XML.PRIMARYGBU = node.getChildElement('PRIMARYGBU',servNS).getText().trim();
        }
        if (node.getChildElement('REASONWONORLOSTCODE',servNS) != null) {
            amid2XML.REASONWONORLOSTCODE = node.getChildElement('REASONWONORLOSTCODE',servNS).getText().trim();
        }
        if (node.getChildElement('CLOSEFISCALQUARTER',servNS) != null) {
            amid2XML.CLOSEFISCALQUARTER = node.getChildElement('CLOSEFISCALQUARTER',servNS).getText().trim();
        }
        if (node.getChildElement('OPPORTUNITYTYPECODE',servNS) != null) {
            amid2XML.OPPORTUNITYTYPECODE = node.getChildElement('OPPORTUNITYTYPECODE',servNS).getText().trim();
        }
        if (node.getChildElement('AMIDL2',servNS) != null) {
            amid2XML.AMIDL2 = node.getChildElement('AMIDL2',servNS).getText().trim();
        }
        if (node.getChildElement('AMIDL2ID',servNS) != null) {
            amid2XML.AMIDL2ID = node.getChildElement('AMIDL2ID',servNS).getText().trim();
        }
        if (node.getChildElement('FULFILLMENTCHANNEL',servNS) != null) {
            amid2XML.FULFILLMENTCHANNEL = node.getChildElement('FULFILLMENTCHANNEL',servNS).getText().trim();
        }
        if (node.getChildElement('FORECASTEDINDICATOR',servNS) != null) {
            amid2XML.FORECASTEDINDICATOR = node.getChildElement('FORECASTEDINDICATOR',servNS).getText().trim();
        }
        if (node.getChildElement('OPPORTUNITYSTATUSCODE',servNS) != null) {
            amid2XML.OPPORTUNITYSTATUSCODE = node.getChildElement('OPPORTUNITYSTATUSCODE',servNS).getText().trim();
        }
        if (node.getChildElement('CLOSEDATE',servNS) != null) {
            amid2XML.CLOSEDATE = node.getChildElement('CLOSEDATE',servNS).getText().trim();
        }
        if (node.getChildElement('CURRENTSALESSTAGECODE',servNS) != null) {
            amid2XML.CURRENTSALESSTAGECODE = node.getChildElement('CURRENTSALESSTAGECODE',servNS).getText().trim();
        }
        if (node.getChildElement('OPPORTUNITYNAME',servNS) != null) {
            amid2XML.OPPORTUNITYNAME = node.getChildElement('OPPORTUNITYNAME',servNS).getText().trim();
        }
        return amid2XML;
    }
    
    // Method to get the HPFS report
    public PageReference getAMID2HPFSReport() {
        respStringRepHPFS = getReportResultsHPFS(Label.OPPTYSUMMARY_SOAPACTION_2);
        amid2ResultsListHPFS = new List<AMID2HPFSResults> ();   
        if (respStringRepHPFS != '' && respStringRepHPFS != null) {
            
            DOM.Document doc = new DOM.Document();
            doc.load(respStringRepHPFS );
            if (doc != null) {
                dom.XmlNode envelope = doc.getRootElement();
                dom.XmlNode header = envelope.getChildElement('Body', Label.SOAP_HEADER_NS);
                dom.XmlNode responseHd = null;
                transient dom.XmlNode[] childNodes = null;
                if (header != null) {
                    responseHd = header.getChildElement('Oppty_Summ_HPFS_Output', Label.INFORMATICA_NS);
                    if (responseHd != null) {
                        childNodes = responseHd.getChildren();  
                        
                        for (dom.XmlNode node: childNodes ){
                            amid2ResultsListHPFS.add(parseResponseXMLDomHPFS(node,Label.INFORMATICA_NS));                
                        }  
                    } else {
                        dom.XmlNode fault = header.getChildElement('Fault', Label.SOAP_HEADER_NS);
                        
                        if (fault != null) {
                            String faultCode = fault.getChildElement('faultcode', Label.SOAP_HEADER_NS).getText();
                            String faultMessage = fault.getChildElement('faultstring', Label.SOAP_HEADER_NS).getText();
                            ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, faultCode + ' '+ faultMessage);
                            ApexPages.addMessage(newMessage);        
                        } else {
                            String integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.'; 
                            ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
                            ApexPages.addMessage(newMessage);
                        }
                    }
                }
            }       
        }            
       return null;
    }
   
    // Method used to export HPFS report to Excel sheet
    public PageReference exportReportToExcelHPFS() {
        return Page.OppurtunitySummaryAMID2HPFSReportSheet;
    } */
}