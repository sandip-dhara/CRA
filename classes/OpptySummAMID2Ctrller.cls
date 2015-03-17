public class OpptySummAMID2Ctrller {
    public String employeeNumber {get; set;}
    public transient String respStringRep {get; set;}

    //public transient List<AMID2Results> amid2ResultsList {get; set;}
    //public List<AMID2Results> amid2ResultsListHd {get; set;}
    //public List<List<AMID2Results>> amid2ResultsListRep {get; set;}
    public integer pageNo {get; set;}
    public integer jsPageNo {get; set;}

    public integer numFromCtrl {get; set;}
    public integer totalNoOfRecs {get; set;}
    public integer noOfPages {get; set;}    
    public integer startlimit {get; set;}
    public integer endlimit {get; set;}
    //public List<PageNumRecords> pageNumList {get;set;}
    
    // Constructor. Webservice callout is triggered from constructor.
    public OpptySummAMID2Ctrller(ApexPages.StandardController controller) {
        if(ApexPages.currentPage().getParameters().get('AMIDL2') != null) {
          employeeNumber = ApexPages.currentPage().getParameters().get('AMIDL2');
        }
        //getAMID2Report();
    }
    
    // Class to hold the pagenumber links
    /*public class PageNumRecords{ 
        public transient integer pageNumber {get; set;}
        public transient string pageName {get; set;}
        
        public PageNumRecords(integer pageNum, String pgName) {
            this.pageNumber = pageNum;
            this.pageName = pgName;
        }
    }
    
    public class AMID2Results {       
        public transient String AMIDL2ID {get; set;}
        public transient String AMIDL2Name {get; set;}
        public transient String OPPORTUNITYIDENTIFIER {get; set;}
        public transient String OPPORTUNITYSTATUSCODE {get; set;}
        public transient String CURRENTSALESSTAGECODE {get; set;}
        public transient String CUSTOMERPROFILENAME {get; set;}
        public transient Integer TOTALDAYSINOPENSALESSTAGES {get; set;}
        public transient String PRIMARYGBU {get; set;}
        public transient Decimal PRIMARYGBUUSDVALUE; //{get; set;}
        public transient Decimal TOTALOPPORTUNITYVALUEUSD; //{get; set;}
        public transient String OPPORTUNITYNAME {get; set;}
        public transient String CLOSEDATE {get; set;}
        public transient String CLOSEFISCALQUARTER {get; set;}
        public transient String OPPORTUNITYTYPECODE {get; set;}
        public transient String FORECASTEDINDICATOR {get; set;}
        public transient String UPSIDEINDICATORCODE {get; set;}
        public transient String FULFILLMENTCHANNEL {get; set;}
        public transient String PRIMARYSALESREP {get; set;}
        public transient String PRIMARYCOMPETITOR {get; set;}
        public transient String PRIMARYALLIANCEPARTNER {get; set;}
        public transient String PRIMARYCHANNELPARTNER {get; set;}
        public transient String LASTUPDATEDDATE {get; set;}
        public transient String REASONWONORLOSTCODE {get; set;}
        public transient String OPPORTUNITYDESCRIPTION {get; set;}
        
        public Integer getPRIMARYGBUUSDVALUE(){
            if(PRIMARYGBUUSDVALUE==null || PRIMARYGBUUSDVALUE==0){
                PRIMARYGBUUSDVALUE=0.0;
                //return '0';
                return 0;
            } else {   
                //return  '$'+(PRIMARYGBUUSDVALUE.setScale(0).toPlainString());
                return  Integer.valueOf(PRIMARYGBUUSDVALUE.setScale(0));
            }
        }
        
        public Integer getTOTALOPPORTUNITYVALUEUSD(){
            if(TOTALOPPORTUNITYVALUEUSD==null || TOTALOPPORTUNITYVALUEUSD==0){
                TOTALOPPORTUNITYVALUEUSD=0.0;
                //return '';
                return 0;
            } else {   
                //return  '$'+(TOTALOPPORTUNITYVALUEUSD.setScale(0).toPlainString());
                return  Integer.valueOf(TOTALOPPORTUNITYVALUEUSD.setScale(0));
            }
        }
    }
    
    public DOM.Document getReportResults(String soapAction, integer rowNum, integer numOfRecords) {
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
        //count_Req_RESP_WRKFRC_ID.addTextNode('US107212169'); 

        HttpRequest countReq = new HttpRequest();
        countReq.setMethod('POST');
        countReq.setEndpoint(Label.OPPTYSUMMARY_ENDPOINTURL);
        //countReq.setEndpoint('https://g5t1173g.atlanta.hp.com/Tibco/Dev/Services/OpportunitySummaryService.serviceagent/OpportunitySummaryEndpoint');
        countReq.setHeader('Content-Type', 'text/xml');

        countReq.setBodyDocument(countReqOperation);
        countReq.setHeader('SOAPAction', Label.OPPTYSUMMARY_AMIDCOUNT);
        
        //countReq.setHeader('SOAPAction', '/Services/OpportunitySummaryService.serviceagent/OpportunitySummaryEndpoint/OpportunitySummaryCount');
        countReq.setClientCertificateName(Label.SFDC_Certificate);

        HttpResponse countRes = null;
        transient DOM.Document countOpRes = new DOM.Document();
        boolean isError = false;
        //totalNoOfRecs = 0;
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
            if (countResHeader != null) {     
                recordCountOutput = countResHeader.getChildElement('RecordCount_Output', Label.INFORMATICA_NS);
            }
        }
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
                amid2ResultsList = new List<AMID2Results> ();
        }

        transient DOM.Document doc1 = null;
        if (totalNoOfRecs != 0 && totalNoOfRecs != null) {
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
            DateTime d = System.now();
            String createdStr = d.formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');
            String nonceStr = String.valueOf(Crypto.getRandomInteger());
            Blob passBlob= Blob.valueOf(nonceStr+ createdStr+ passwordText);
            String passwordStr = EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',passBlob));
            Blob nonceBlob = Blob.valueOf(nonceStr);
            nonceStr=EncodingUtil.base64Encode(nonceBlob);
            dom.XmlNode userName
                = usernameToken.addChildElement('Username', Label.WSSE_SECURITY_NS, 'wsse');
            userName.addTextNode(userNameText);
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
            //RESP_WRKFRC_ID.addTextNode('US107212169'); 
            // Send the request             
            dom.XmlNode REC_NUM
                = ldo_SFDC_EDW_POC_Manager_View_Operation.addChildElement('START_ROW_NUMBER', Label.INFORMATICA_NS, null);     
            REC_NUM.addTextNode(String.valueOf(rowNum));             
            dom.XmlNode NUMRECORDS
                = ldo_SFDC_EDW_POC_Manager_View_Operation.addChildElement('NO_OF_RECORDS', Label.INFORMATICA_NS, null);      
            NUMRECORDS.addTextNode(String.valueOf(numOfRecords)); 
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(Label.OPPTYSUMMARY_ENDPOINTURL);
            //req.setEndpoint('https://g5t1173g.atlanta.hp.com/Tibco/Dev/Services/OpportunitySummaryService.serviceagent/OpportunitySummaryEndpoint');
            req.setHeader('Content-Type', 'text/xml');
            req.setBodyDocument(doc);
            req.setHeader('SOAPAction', soapAction);
            //req.setHeader('SOAPAction','/Services/OpportunitySummaryService.serviceagent/OpportunitySummaryEndpoint/OpportunitySummary');
            req.setClientCertificateName(Label.SFDC_Certificate);

            HttpResponse res = null;
            doc1 = new DOM.Document();
            try {
                Http http = new Http();
                res = http.send(req);
                doc1 = res.getBodyDocument();
            } catch (Exception ex) {
                String integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.'; 
                ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
                ApexPages.addMessage(newMessage);
                doc1 = null;
            }
        }   
        return doc1;
    }

    // Method used to parse the response xml
    public AMID2Results parseResponseXmlDom(dom.XmlNode node, String servNS){
        transient AMID2Results amid2XML = new AMID2Results ();
        if (node.getChildElement('AMIDL2ID',servNS) != null) {
            amid2XML.AMIDL2ID = node.getChildElement('AMIDL2ID',servNS).getText().trim();
        }
        if (node.getChildElement('AMIDL2NAME',servNS) != null) {
            amid2XML.AMIDL2NAME = node.getChildElement('AMIDL2NAME',servNS).getText().trim();
        }
        if (node.getChildElement('OPPORTUNITYIDENTIFIER',servNS) != null) { 
            //amid2XML.OPPORTUNITYIDENTIFIER = node.getChildElement('OPPORTUNITYIDENTIFIER',servNS).getText().trim();
            amid2XML.OPPORTUNITYIDENTIFIER = node.getChildElement('OPPORTUNITYIDENTIFIER',servNS).getText().trim();
        }
        if (node.getChildElement('OPPORTUNITYSTATUS',servNS) != null) {
            //amid2XML.OPPORTUNITYSTATUSCODE =node.getChildElement('OPPORTUNITYSTATUSCODE',servNS).getText().trim();
            amid2XML.OPPORTUNITYSTATUSCODE =node.getChildElement('OPPORTUNITYSTATUS',servNS).getText().trim();
        }
        if (node.getChildElement('CURRENTSALESSTAGE',servNS) != null) {
            //amid2XML.CURRENTSALESSTAGECODE = node.getChildElement('CURRENTSALESSTAGECODE',servNS).getText().trim();
            amid2XML.CURRENTSALESSTAGECODE = node.getChildElement('CURRENTSALESSTAGE',servNS).getText().trim();
        }
        if (node.getChildElement('CUSTOMERPROFILENAME',servNS) != null) {
            amid2XML.CUSTOMERPROFILENAME = node.getChildElement('CUSTOMERPROFILENAME',servNS).getText().trim();
        }
        if (node.getChildElement('TOTALDAYSINOPENSALESSTAGES',servNS) != null) {
            amid2XML.TOTALDAYSINOPENSALESSTAGES = Integer.valueOf(node.getChildElement('TOTALDAYSINOPENSALESSTAGES',servNS).getText());
        }
        if (node.getChildElement('PRIMARYGBU',servNS) != null) {
            amid2XML.PRIMARYGBU = node.getChildElement('PRIMARYGBU',servNS).getText().trim();
        }
        if (node.getChildElement('PRIMARYGBUUSDVALUE',servNS) != null) {
            amid2XML.PRIMARYGBUUSDVALUE = Decimal.valueOf(node.getChildElement('PRIMARYGBUUSDVALUE',servNS).getText());
        }
        if (node.getChildElement('TOTALOPPORTUNITYVALUEUSD',servNS) != null) {
            amid2XML.TOTALOPPORTUNITYVALUEUSD = Decimal.valueOf(node.getChildElement('TOTALOPPORTUNITYVALUEUSD',servNS).getText());
        }
        if (node.getChildElement('OPPOTUNITYNAME',servNS) != null) {
            //amid2XML.OPPORTUNITYNAME= node.getChildElement('OPPORTUNITYNAME',servNS).getText().trim();
            amid2XML.OPPORTUNITYNAME= node.getChildElement('OPPOTUNITYNAME',servNS).getText().trim();
        }
        if (node.getChildElement('CLOSEDATE',servNS) != null) {
            amid2XML.CLOSEDATE= node.getChildElement('CLOSEDATE',servNS).getText().trim();
        }
        if (node.getChildElement('CLOSEFISCALQUARTER',servNS) != null) {
            amid2XML.CLOSEFISCALQUARTER = node.getChildElement('CLOSEFISCALQUARTER',servNS).getText().trim();
        }
        if (node.getChildElement('OPPORTUNITYTYPECODE',servNS) != null) {
            amid2XML.OPPORTUNITYTYPECODE = node.getChildElement('OPPORTUNITYTYPECODE',servNS).getText().trim();
        }
        if (node.getChildElement('FORECASTEDINDICATOR',servNS) != null) {
            amid2XML.FORECASTEDINDICATOR = node.getChildElement('FORECASTEDINDICATOR',servNS).getText().trim();
        }
        if (node.getChildElement('UPSIDEINDICATORCODE',servNS) != null) {
            amid2XML.UPSIDEINDICATORCODE = node.getChildElement('UPSIDEINDICATORCODE',servNS).getText().trim();
        }
        if (node.getChildElement('FULFILLMENTCHANNEL',servNS) != null) {
            amid2XML.FULFILLMENTCHANNEL= node.getChildElement('FULFILLMENTCHANNEL',servNS).getText().trim();
        }
        if (node.getChildElement('PRIMARYSALESREP',servNS) != null) {
            //amid2XML.PRIMARYSALESREP=node.getChildElement('PRIMARYSALESREP',servNS).getText().trim();
            amid2XML.PRIMARYSALESREP=node.getChildElement('PRIMARYSALESREP',servNS).getText().trim();
        }
        if (node.getChildElement('PRIMARYCOMPETITOR',servNS) != null) {
            //amid2XML.PRIMARYCOMPETITOR=node.getChildElement('PRIMARYCOMPETITOR',servNS).getText().trim();
            amid2XML.PRIMARYCOMPETITOR=node.getChildElement('PRIMARYCOMPETITOR',servNS).getText().trim();
        }
        if (node.getChildElement('PRIMARYALLIANCEPARTNER',servNS) != null) {
            amid2XML.PRIMARYALLIANCEPARTNER = node.getChildElement('PRIMARYALLIANCEPARTNER',servNS).getText().trim();
        }
        if (node.getChildElement('PRIMARYCHANNELPARTNER',servNS) != null) {
            //amid2XML.PRIMARYCHANNELPARTNER = node.getChildElement('PRIMARYCHANNELPARTNER',servNS).getText().trim();
            amid2XML.PRIMARYCHANNELPARTNER= node.getChildElement('PRIMARYCHANNELPARTNER',servNS).getText().trim();
        }
        if (node.getChildElement('LASTUPDATEDDATE',servNS) != null) {
            amid2XML.LASTUPDATEDDATE = node.getChildElement('LASTUPDATEDDATE',servNS).getText().trim();
        }
        if (node.getChildElement('REASONWONORLOSTCODE',servNS) != null) {
            //amid2XML.REASONWONORLOSTCODE = node.getChildElement('REASONWONORLOSTCODE',servNS).getText().trim();
            amid2XML.REASONWONORLOSTCODE = node.getChildElement('REASONWONORLOSTCODE',servNS).getText().trim();
        }
        if (node.getChildElement('OPPORTUNITYDESCRIPTION',servNS) != null) {
            amid2XML.OPPORTUNITYDESCRIPTION = node.getChildElement('OPPORTUNITYDESCRIPTION',servNS).getText().trim();
        }
        return amid2XML;
    }

    // Method to get the AMID report
    public PageReference getAMID2Report() {

        DOM.Document doc = getReportResults(Label.OPPTYSUMMARY_SOAPACTION_1, 0,100);
        amid2ResultsList = new List<AMID2Results> ();
        pageNumList = new List<PageNumRecords> ();
        if (doc != null) {
            dom.XmlNode envelope = doc.getRootElement();
            dom.XmlNode header = envelope.getChildElement('Body', Label.SOAP_HEADER_NS);
            dom.XmlNode responseHd = null;
            transient dom.XmlNode[] childNodes = null;
            if (header != null) {
                responseHd = header.getChildElement('Oppty_Summ_Output', Label.INFORMATICA_NS);
                
                if (responseHd != null) {
                    childNodes = responseHd.getChildren();    
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
            integer pageSize = 100;
            noOfPages = totalNoOfRecs /pageSize;
            integer pageNumber = 1;
            if (Math.mod(totalNoOfRecs, pageSize) > 0)
                noOfPages++;
            for(integer j=1; j<=noOfPages;j++ ){
                pageNumList.add(new PageNumRecords(j, String.valueOf(j))); 
            }
            respStringRep='';    
            pageNo = 1;
            startlimit = 0;
            endlimit = 100;
            if(totalNoOfRecs < endlimit){
                endlimit = totalNoOfRecs;
            }

            if(childNodes != null) {      
                for (integer i=startlimit; i<endlimit; i++) {
                    transient AMID2Results result = parseResponseXmlDom(childNodes[i], Label.INFORMATICA_NS);
                    amid2ResultsList.add(result); 
                }
            }
            startlimit = 1; 
        }
        return null;
    }

    // Method used to get successive records.
    public PageReference nextOperation() {
        amid2ResultsList = new List<AMID2Results> ();
        if (numFromCtrl <= noOfPages) {
            pageNo = numFromCtrl;
        } else {
            pageNo = 1; 
        }
        startlimit = ((pageNo-1)*100);
        endlimit = ((pageNo-1)*100)+100;
        DOM.Document doc = getReportResults(Label.OPPTYSUMMARY_SOAPACTION_1, (startlimit), 100);
        
        if (doc != null) {
            dom.XmlNode envelope = doc.getRootElement();
            dom.XmlNode header = envelope.getChildElement('Body', Label.SOAP_HEADER_NS);
            dom.XmlNode responseHd = header.getChildElement('Oppty_Summ_Output', Label.INFORMATICA_NS);
            dom.XmlNode[] childNodes = null;
            
            if (responseHd != null) {
                childNodes = responseHd.getChildren();    
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
    
            if (childNodes != null) {
                if(totalNoOfRecs < endlimit){
                    endlimit = Math.mod(totalNoOfRecs, 100);
                } else {
                    endlimit = 100;
                }
                for (integer i=0 ; i<endlimit ; i++) {
                    AMID2Results result = parseResponseXmlDom(childNodes[i], Label.INFORMATICA_NS);
                    amid2ResultsList.add(result); 
                }
                doc = null;
                startlimit = ((pageNo-1)*100)+1;
                endlimit = ((pageNo-1)*100)+100;
                if(totalNoOfRecs < endlimit){
                    endlimit = totalNoOfRecs;
                } 
            }
        }
        return null;
    }

    // Method used to export AMID report to Excel sheet
    public PageReference exportReportToExcel() {
        amid2ResultsListRep = new List<List<AMID2Results>> ();
        amid2ResultsListHd  = new List<AMID2Results> ();
        integer totalPagesRep = 0;
        if (totalNoOfRecs != null) {
            totalPagesRep = totalNoOfRecs/1000;
            if (Math.mod(totalNoOfRecs, 1000) > 0)
               totalPagesRep++;
        }
        
        integer limitStr = 0;
        //for(integer i=0; i<totalPagesRep; i++ ) {
        for(integer i=0; i<3; i++ ) {
            DOM.Document doc = getReportResults(Label.OPPTYSUMMARY_SOAPACTION_1,limitStr,1000);
            if (doc != null) {
                dom.XmlNode envelope = doc.getRootElement();
                dom.XmlNode header = envelope.getChildElement('Body', Label.SOAP_HEADER_NS);
                dom.XmlNode responseHd = header.getChildElement('Oppty_Summ_Output', Label.INFORMATICA_NS);   
                dom.XmlNode[] childNodes = null;
                
                if (responseHd != null) {
                    childNodes = responseHd.getChildren();    
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
                
                if (childNodes != null) {
                    List<AMID2Results> tempList = new List<AMID2Results> ();
                    for (integer j=0; j< childNodes.size(); j++) {
                        tempList.add(parseResponseXmlDom(childNodes[j], Label.INFORMATICA_NS));
                    }
                    amid2ResultsListRep.add(tempList);
                    limitStr = limitStr+1000;
                }
            }
        }
        return Page.OppurtunitySummaryAMID2ReportSheet;
    }*/
}