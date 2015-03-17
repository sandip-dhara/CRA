public class SalesManagerRepBussGrp {
   // public List<SumByBussRepReport > salesManagerResults3 {get; set;}
    public transient String employeeNumber {get; set;}
    public String previousQuarter {get; set;}
    public String currentQuarter {get; set;}

    public SalesManagerRepBussGrp(ApexPages.StandardController controller) {

    }
    
    /*public class SumByBussRepReport {
        public transient String REPORTINGNAME {get; set;}
        public transient String BUSINESS_GROUP {get; set;}
        public transient String GLOBAL_BUSINESS_UNIT {get; set;}
        public transient Decimal OPENREVENUE_P;
        public transient Decimal WONREVENUE_P;
        public transient Decimal OPENFORECASTREVENUE_P;
        public transient Decimal UPSIDEREVENUE_P;
        public transient Decimal OPENREVENUE_C;
        public transient Decimal WONREVENUE_C;
        public transient Decimal OPENFORECASTREVENUE_C;
        public transient Decimal UPSIDEREVENUE_C;
        public transient Decimal OPENREVENUE_T;
        public transient Decimal WONREVENUE_T;
        public transient Decimal OPENFORECASTREVENUE_T;
        public transient Decimal UPSIDEREVENUE_T;
    
        public Double getOPENREVENUE_P(){
                
            if(OPENREVENUE_P==null || OPENREVENUE_P==0){
               OPENREVENUE_P=0.0;
               return 0.0;
            } else {   
                //return  '$'+(OPENREVENUE_P.setScale(2)).toPlainString();
                return  OPENREVENUE_P.setScale(2);
            }
        }
       
        public Double getWONREVENUE_P(){
                
            if(WONREVENUE_P==null || WONREVENUE_P==0){
               WONREVENUE_P=0.0;
               return 0.0;
            } else {   
                //return  '$'+(WONREVENUE_P.setScale(2)).toPlainString();
                return  WONREVENUE_P.setScale(2);
            }
        }
       
        public Double getOPENFORECASTREVENUE_P(){
                
            if(OPENFORECASTREVENUE_P==null || OPENFORECASTREVENUE_P==0){
               OPENFORECASTREVENUE_P=0.0;
               return 0.0;
            } else {   
               //return  '$'+(OPENFORECASTREVENUE_P.setScale(2)).toPlainString();
               return  OPENFORECASTREVENUE_P.setScale(2); 
            }
        }
       
        public Double getUPSIDEREVENUE_P(){
                
            if(UPSIDEREVENUE_P==null || UPSIDEREVENUE_P==0){
               UPSIDEREVENUE_P=0.0;
               return 0.0;
            } else {   
               //return  '$'+(UPSIDEREVENUE_P.setScale(2)).toPlainString();
               return  UPSIDEREVENUE_P.setScale(2);
            }
        }
       
        public Double getOPENREVENUE_C(){
                
            if(OPENREVENUE_C==null || OPENREVENUE_C==0){
               OPENREVENUE_C=0.0;
               return 0.0;
            } else {   
               //return  '$'+(OPENREVENUE_C.setScale(2)).toPlainString();
               return  OPENREVENUE_C.setScale(2);
            }
        }
       
        public Double getWONREVENUE_C(){
                
            if(WONREVENUE_C==null || WONREVENUE_C==0){
               WONREVENUE_C=0.0;
               return 0.0;
            } else {   
               //return  '$'+(WONREVENUE_C.setScale(2)).toPlainString();
               return  WONREVENUE_C.setScale(2);
            }
        }
       
        public Double getOPENFORECASTREVENUE_C(){
                
            if(OPENFORECASTREVENUE_C==null || OPENFORECASTREVENUE_C==0){
               OPENFORECASTREVENUE_C=0.0;
               return 0.0;
            } else {   
               //return  '$'+(OPENFORECASTREVENUE_C.setScale(2)).toPlainString();
               return  OPENFORECASTREVENUE_C.setScale(2);
            }
        }
    
        public Double getUPSIDEREVENUE_C(){
                
            if(UPSIDEREVENUE_C==null || UPSIDEREVENUE_C==0){
               UPSIDEREVENUE_C=0.0;
               return 0.0;
            } else {   
               //return  '$'+(UPSIDEREVENUE_C.setScale(2)).toPlainString();
               return  UPSIDEREVENUE_C.setScale(2);
            }
        }     
    
        public Double getOPENREVENUE_T(){
                
            if(OPENREVENUE_T==null || OPENREVENUE_T==0){
               OPENREVENUE_T=0.0;
               return 0.0;
            } else {   
               //return  '$'+(OPENREVENUE_T.setScale(2)).toPlainString();
               return OPENREVENUE_T.setScale(2);
            }
        }
       
        public Double getWONREVENUE_T(){
                
            if(WONREVENUE_T==null || WONREVENUE_T==0){
               WONREVENUE_T=0.0;
               return 0.0;
            } else {   
               //return  '$'+(WONREVENUE_T.setScale(2)).toPlainString();
               return WONREVENUE_T.setScale(2);
            }
        }
       
        public Double getOPENFORECASTREVENUE_T(){
                
            if(OPENFORECASTREVENUE_T==null || OPENFORECASTREVENUE_T==0){
               OPENFORECASTREVENUE_T=0.0;
               return 0.0;
            } else {   
               //return  '$'+(OPENFORECASTREVENUE_T.setScale(2)).toPlainString();
               return OPENFORECASTREVENUE_T.setScale(2);
            }
        }
       
        public Double getUPSIDEREVENUE_T(){
                
            if(UPSIDEREVENUE_T==null || UPSIDEREVENUE_T==0){
               UPSIDEREVENUE_T=0.0;
               return 0.0;
            } else {   
               // return  '$'+(UPSIDEREVENUE_T.setScale(2)).toPlainString();
               return UPSIDEREVENUE_T.setScale(2);
            }
        }
    }
    
    public SumByBussRepReport parseResponseXmlDom(dom.XmlNode node, String serviceNS){
        transient SumByBussRepReport record = new SumByBussRepReport ();
        if(node.getChildElement('REPORTINGNAME',serviceNS )!= null){
            record.REPORTINGNAME=node.getChildElement('REPORTINGNAME',serviceNS ).getText().trim();
        }
       
        if(node.getChildElement('BUSINESS_GROUP',serviceNS)!= null){
            record.BUSINESS_GROUP=node.getChildElement('BUSINESS_GROUP',serviceNS).getText().trim();
        }
        if(node.getChildElement('GLOBAL_BUSINESS_UNIT',serviceNS)!= null){
            record.GLOBAL_BUSINESS_UNIT=node.getChildElement('GLOBAL_BUSINESS_UNIT',serviceNS).getText().trim();
        }
       
        if(node.getChildElement('OPENREVENUE_P',serviceNS)!= null){
            record.OPENREVENUE_P=Decimal.ValueOf(node.getChildElement('OPENREVENUE_P',serviceNS).getText());
        }
       
        if(node.getChildElement('WONREVENUE_P',serviceNS)!= null){
            record.WONREVENUE_P=Decimal.ValueOf(node.getChildElement('WONREVENUE_P',serviceNS).getText());
        }
       
        if(node.getChildElement('OPENFORECASTREVENUE_P',serviceNS)!= null){
            record.OPENFORECASTREVENUE_P=Decimal.ValueOf(node.getChildElement('OPENFORECASTREVENUE_P',serviceNS).getText());
        }
       
        if(node.getChildElement('UPSIDEREVENUE_P',serviceNS)!= null){
            record.UPSIDEREVENUE_P=Decimal.ValueOf(node.getChildElement('UPSIDEREVENUE_P',serviceNS).getText());
        }
       
        if(node.getChildElement('OPENREVENUE_C',serviceNS)!= null){
            record.OPENREVENUE_C=Decimal.ValueOf(node.getChildElement('OPENREVENUE_C',serviceNS).getText());
        }
       
        if(node.getChildElement('WONREVENUE_C',serviceNS)!= null){
            record.WONREVENUE_C=Decimal.ValueOf(node.getChildElement('WONREVENUE_C',serviceNS).getText());
        }
       
        if(node.getChildElement('OPENFORECASTREVENUE_C',serviceNS)!= null){
            record.OPENFORECASTREVENUE_C=Decimal.ValueOf(node.getChildElement('OPENFORECASTREVENUE_C',serviceNS).getText());
        }
       
        if(node.getChildElement('UPSIDEREVENUE_C',serviceNS)!= null){
            record.UPSIDEREVENUE_C=Decimal.ValueOf(node.getChildElement('UPSIDEREVENUE_C',serviceNS).getText());
        }
       
        if(node.getChildElement('OPENREVENUE_T',serviceNS)!= null){
            record.OPENREVENUE_T=Decimal.ValueOf(node.getChildElement('OPENREVENUE_T',serviceNS).getText());
        }
       
        if(node.getChildElement('WONREVENUE_T',serviceNS)!= null){
            record.WONREVENUE_T=Decimal.ValueOf(node.getChildElement('WONREVENUE_T',serviceNS).getText());
        }
       
        if(node.getChildElement('OPENFORECASTREVENUE_T',serviceNS)!= null){
            record.OPENFORECASTREVENUE_T=Decimal.ValueOf(node.getChildElement('OPENFORECASTREVENUE_T',serviceNS).getText());
        }
       
        if(node.getChildElement('UPSIDEREVENUE_T',serviceNS)!= null){
            record.UPSIDEREVENUE_T=Decimal.ValueOf(node.getChildElement('UPSIDEREVENUE_T',serviceNS).getText());
        }
        
        return record;
    }
   
    public String getReportResults(String soapAction) {
        DOM.Document doc = new DOM.Document();
        
        dom.XmlNode envelope
            = doc.createRootElement('Envelope', Label.SOAP_HEADER_NS, 'soapenv');
        envelope.setNamespace('xsd', Label.INFORMATICA_NS);
        
        dom.XmlNode header
            = envelope.addChildElement('Header', Label.SOAP_HEADER_NS, null);
            
        dom.XmlNode security
            = header.addChildElement('Security', Label.WSSE_SECURITY_NS , 'wsse');
        security.setAttributeNs('soapenv:mustUnderstand','1',null,null);   
        security.setNamespace('wsu',Label.WSSE_UTILITY_NS);        

        dom.XmlNode usernameToken
            = security.addChildElement('UsernameToken', Label.WSSE_SECURITY_NS , 'wsse');  
        usernameToken.setAttributeNs('wsu:Id','UsernameToken-79',null,null);
        
        
        List<TibcoSecurity__c> lstPwd = [Select t.Name, t.TibcoPassword__c From TibcoSecurity__c t where t.TargetSystemName__c ='SALESOPPTYREPORTS' ];

        String passwordText = '';
        String usernameText = '';
        if(lstPwd.size()==1){
            passwordText = lstPwd[0].TibcoPassword__c;
            usernameText = lstPwd[0].Name;
        }
        else {
            passwordText = '';
            usernameText = '';
        }    
        
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
        password.setAttribute('Type',Label.WSSE_PASSWORD_TYPE );
        password.addTextNode(passwordStr);
        dom.XmlNode nonce
            = usernameToken.addChildElement('Nonce', Label.WSSE_SECURITY_NS, 'wsse');
        nonce.setAttribute('EncodingType', Label.WSSE_ENCODING_TYPE );
        nonce.addTextNode(nonceStr);
        dom.XmlNode created
            = usernameToken.addChildElement('Created', Label.WSSE_UTILITY_NS , null);
        created.addTextNode(createdStr);
        
        dom.XmlNode body
            = envelope.addChildElement('Body', Label.SOAP_HEADER_NS , null);
        
        dom.XmlNode ldo_SFDC_EDW_POC_Manager_View_Operation
            = body.addChildElement('Responsible_WorkForce_Id_Input', Label.INFORMATICA_NS, null);
        
        dom.XmlNode RESP_WRKFRC_ID
            = ldo_SFDC_EDW_POC_Manager_View_Operation.addChildElement('RESP_WRKFRC_ID', Label.INFORMATICA_NS, null);

        employeenumber = [Select Legacy_Employee_Ref__c from User Where id =: UserInfo.getUserId()].Legacy_Employee_Ref__c;
        RESP_WRKFRC_ID.addTextNode(employeeNumber); 
        
        // Send the request 
    
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(Label.SALESHRCHY_ENDPOINT_URL);
        req.setHeader('Content-Type', 'text/xml');

        req.setBodyDocument(doc);
        req.setHeader('SOAPAction', soapAction);
        req.setClientCertificateName(Label.SFDC_Certificate);
        
        Http http = new Http();
        HttpResponse res = null;
        String respStringRep1 = null;
        try {
            res = http.send(req);
            DOM.Document doc1 = new DOM.Document();
            doc1 = res.getBodyDocument();
            respStringRep1 = doc1.toXmlString();
        } catch(Exception ex) {
            String integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.';
            if(!(ex.getMessage().equals(''))) {
                integrationStatus = ex.getMessage();
            }
            ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
            ApexPages.addMessage(newMessage);
            respStringRep1  = '';
        }
        return respStringRep1 ;
    }
   
    public void setCurrAndPrevQuarter() {
        DateTime d = System.now();        
        // Current and Previous Quarter logic modified  - QC 5214
        if (d.month() == 11 || d.month() == 12 || d.month() == 1) {
            //previousQuarter = 'FY'+d.year()+' Q4';
            //currentQuarter = 'FY'+(d.year()+1)+' Q1';
            previousQuarter = 'FY'+(d.year()+1)+' Q1';
            currentQuarter = 'FY'+(d.year()+1)+' Q2';
        } else if (d.month() == 2 || d.month() == 3 || d.month() == 4) {
            previousQuarter = 'FY'+d.year()+' Q2';
            currentQuarter = 'FY'+d.year()+' Q3';
        } else if (d.month() == 5 || d.month() == 6 || d.month() == 7) {
            previousQuarter = 'FY'+d.year()+' Q3';
            currentQuarter = 'FY'+d.year()+' Q4';
        } else if (d.month() == 8 || d.month() == 9 || d.month() == 10) {
            previousQuarter = 'FY'+d.year()+' Q4';
            currentQuarter = 'FY'+(d.year()+1)+' Q1';
        }
    }
   
    public PageReference getSumByBusinessRepReport() {
        setCurrAndPrevQuarter();
        salesManagerResults3 = new List<SumByBussRepReport> ();
        String respStringRep = getReportResults(Label.SALESHRCHY_SOAPACTION_3);
   
        if (respStringRep != null && respStringRep != '') {
            DOM.Document doc = new DOM.Document();     
            doc.load(respStringRep);    
            dom.XmlNode envelope = doc.getRootElement();
            dom.XmlNode header = envelope.getChildElement('Body', Label.SOAP_HEADER_NS);
            dom.XmlNode responseHd = null;
            if (header != null){
                responseHd = header.getChildElement('Sales_Hierarchy_Summ_BG_Rep_Output', Label.INFORMATICA_NS);
            }

            List<SumByBussRepReport > lstOfElements = new List<SumByBussRepReport > ();
            if(responseHd != null) {      
                for(dom.XmlNode node : responseHd.getChildren()) {
                    SumByBussRepReport result = parseResponseXmlDom(node,Label.INFORMATICA_NS);
                    lstOfElements.add(result);
                }
            }
            if(lstOfElements.size() == 0) {
                dom.XmlNode fault = null;
                if (header != null) {
                    header.getChildElement('Fault', Label.SOAP_HEADER_NS);
                }        
                if (fault != null) {
                    String faultCode = fault.getChildElement('faultcode', Label.SOAP_HEADER_NS).getText();
                    String faultMessage = fault.getChildElement('faultstring', Label.SOAP_HEADER_NS).getText();
                    ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, faultCode + ' '+ faultMessage);
                    ApexPages.addMessage(newMessage);        
                } else if (respStringRep.contains('html')) {
                    String integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.';
                    ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
                    ApexPages.addMessage(newMessage);        
                } else {
                    String integrationStatus = 'No results to display'; 
                    ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Info, integrationStatus);
                    ApexPages.addMessage(newMessage);
                }
            }
            if(lstOfElements.size() != 0) {
                Map<String, List<SumByBussRepReport >> repMap = new Map<String, List<SumByBussRepReport >> ();
                List<String> repNames = new List<String>();
                for(SumByBussRepReport record1: lstOfElements){
                    if(repMap.containsKey(record1.REPORTINGNAME)){
                        List<SumByBussRepReport> lstsalesRepExisting = repMap.get(record1.REPORTINGNAME);
                        lstsalesRepExisting.add(record1);
                        repMap.put(record1.REPORTINGNAME, lstsalesRepExisting);
                    } else{  
                        List<SumByBussRepReport> lstsalesRepExisting = new List<SumByBussRepReport>();
                        lstsalesRepExisting.add(record1);
                        repNames.add(record1.REPORTINGNAME);
                        repMap.put(record1.REPORTINGNAME, lstsalesRepExisting);
                    }
                }
                Decimal GRANDSUM_OPENREVENUE_P =0.0;
                Decimal GRANDSUM_WONREVENUE_P=0.0;
                Decimal GRANDSUM_OPENFORECASTREVENUE_P=0.0;
                Decimal GRANDSUM_UPSIDEREVENUE_P=0.0;
                Decimal GRANDSUM_OPENREVENUE_C=0.0;
                Decimal GRANDSUM_WONREVENUE_C=0.0;
                Decimal GRANDSUM_OPENFORECASTREVENUE_C=0.0;
                Decimal GRANDSUM_UPSIDEREVENUE_C=0.0;
                Decimal GRANDSUM_OPENREVENUE_T=0.0;
                Decimal GRANDSUM_WONREVENUE_T=0.0;
                Decimal GRANDSUM_OPENFORECASTREVENUE_T=0.0;
                Decimal GRANDSUM_UPSIDEREVENUE_T=0.0;
                for(integer i=0 ; i<repNames.size(); i++) {
                    Map<String, List<SumByBussRepReport>> buMap = new Map<String, List<SumByBussRepReport>> ();
                    List<String> buNames = new List<String>();      
                    List<SumByBussRepReport> lstOfElements1 = repMap.get(repNames.get(i));
                    for(SumByBussRepReport record1: lstOfElements1){
                        if(buMap.containsKey(record1.BUSINESS_GROUP)){
                            List<SumByBussRepReport> lstsalesBuExisting = buMap.get(record1.BUSINESS_GROUP);
                            lstsalesBuExisting.add(record1);
                            buMap.put(record1.BUSINESS_GROUP, lstsalesBuExisting);
                        } else{  
                            List<SumByBussRepReport> lstsalesBuExisting = new List<SumByBussRepReport>();
                            lstsalesBuExisting.add(record1);
                            buNames.add(record1.BUSINESS_GROUP);
                            buMap.put(record1.BUSINESS_GROUP, lstsalesBuExisting);
                        }
                    }
                    Decimal BU_SUM_OPENREVENUE_P =0.0;
                    Decimal BU_SUM_WONREVENUE_P=0.0;
                    Decimal BU_SUM_OPENFORECASTREVENUE_P=0.0;
                    Decimal BU_SUM_UPSIDEREVENUE_P=0.0;
                    Decimal BU_SUM_OPENREVENUE_C=0.0;
                    Decimal BU_SUM_WONREVENUE_C=0.0;
                    Decimal BU_SUM_OPENFORECASTREVENUE_C=0.0;
                    Decimal BU_SUM_UPSIDEREVENUE_C=0.0;
                    Decimal BU_SUM_OPENREVENUE_T=0.0;
                    Decimal BU_SUM_WONREVENUE_T=0.0;
                    Decimal BU_SUM_OPENFORECASTREVENUE_T=0.0;
                    Decimal BU_SUM_UPSIDEREVENUE_T=0.0;
                    for(integer j =0; j<buNames.size(); j++ ) {
                        List<SumByBussRepReport> lstOfElements2 = buMap.get(buNames.get(j));
                        Decimal SUM_OPENREVENUE_P =0.0;
                        Decimal SUM_WONREVENUE_P=0.0;
                        Decimal SUM_OPENFORECASTREVENUE_P=0.0;
                        Decimal SUM_UPSIDEREVENUE_P=0.0;
                        Decimal SUM_OPENREVENUE_C=0.0;
                        Decimal SUM_WONREVENUE_C=0.0;
                        Decimal SUM_OPENFORECASTREVENUE_C=0.0;
                        Decimal SUM_UPSIDEREVENUE_C=0.0;
                        Decimal SUM_OPENREVENUE_T=0.0;
                        Decimal SUM_WONREVENUE_T=0.0;
                        Decimal SUM_OPENFORECASTREVENUE_T=0.0;
                        Decimal SUM_UPSIDEREVENUE_T=0.0;
                        for(SumByBussRepReport record1: lstOfElements2){
                            SUM_OPENREVENUE_P += record1.OPENREVENUE_P;
                            SUM_WONREVENUE_P += record1.WONREVENUE_P;
                            SUM_OPENFORECASTREVENUE_P += record1.OPENFORECASTREVENUE_P;
                            SUM_UPSIDEREVENUE_P += record1.UPSIDEREVENUE_P;
                            SUM_OPENREVENUE_C += record1.OPENREVENUE_C;
                            SUM_WONREVENUE_C += record1.WONREVENUE_C;
                            SUM_OPENFORECASTREVENUE_C += record1.OPENFORECASTREVENUE_C;
                            SUM_UPSIDEREVENUE_C += record1.UPSIDEREVENUE_C;
                            SUM_OPENREVENUE_T += record1.OPENREVENUE_T;
                            SUM_WONREVENUE_T += record1.WONREVENUE_T;
                            SUM_OPENFORECASTREVENUE_T += record1.OPENFORECASTREVENUE_T;
                            SUM_UPSIDEREVENUE_T += record1.UPSIDEREVENUE_T;
                            salesManagerResults3.add(record1);           
                        }   
                        SumByBussRepReport sumRecord = new SumByBussRepReport();
                        sumRecord.GLOBAL_BUSINESS_UNIT = 'Total';
                        sumRecord.OPENREVENUE_P =SUM_OPENREVENUE_P ;
                        sumRecord.WONREVENUE_P = SUM_WONREVENUE_P;
                        sumRecord.OPENFORECASTREVENUE_P =SUM_OPENFORECASTREVENUE_P;
                        sumRecord.UPSIDEREVENUE_P =SUM_UPSIDEREVENUE_P;
                        sumRecord.OPENREVENUE_C=SUM_OPENREVENUE_C;
                        sumRecord.WONREVENUE_C=SUM_WONREVENUE_C;
                        sumRecord.OPENFORECASTREVENUE_C=SUM_OPENFORECASTREVENUE_C;
                        sumRecord.UPSIDEREVENUE_C=SUM_UPSIDEREVENUE_C;
                        sumRecord.OPENREVENUE_T=SUM_OPENREVENUE_T;
                        sumRecord.WONREVENUE_T=SUM_WONREVENUE_T;
                        sumRecord.OPENFORECASTREVENUE_T=SUM_OPENFORECASTREVENUE_T;
                        sumRecord.UPSIDEREVENUE_T=SUM_UPSIDEREVENUE_T;           
                        BU_SUM_OPENREVENUE_P += SUM_OPENREVENUE_P;
                        BU_SUM_WONREVENUE_P += SUM_WONREVENUE_P;
                        BU_SUM_OPENFORECASTREVENUE_P += SUM_OPENFORECASTREVENUE_P;
                        BU_SUM_UPSIDEREVENUE_P += SUM_UPSIDEREVENUE_P;
                        BU_SUM_OPENREVENUE_C += SUM_OPENREVENUE_C;
                        BU_SUM_WONREVENUE_C += SUM_WONREVENUE_C;
                        BU_SUM_OPENFORECASTREVENUE_C += SUM_OPENFORECASTREVENUE_C;
                        BU_SUM_UPSIDEREVENUE_C += SUM_UPSIDEREVENUE_C;
                        BU_SUM_OPENREVENUE_T += SUM_OPENREVENUE_T;
                        BU_SUM_WONREVENUE_T += SUM_WONREVENUE_T;
                        BU_SUM_OPENFORECASTREVENUE_T += SUM_OPENFORECASTREVENUE_T;
                        BU_SUM_UPSIDEREVENUE_T += SUM_UPSIDEREVENUE_T;
                        salesManagerResults3.add(sumRecord);
                    }
                    GRANDSUM_OPENREVENUE_P += BU_SUM_OPENREVENUE_P;
                    GRANDSUM_WONREVENUE_P += BU_SUM_WONREVENUE_P;
                    GRANDSUM_OPENFORECASTREVENUE_P += BU_SUM_OPENFORECASTREVENUE_P;
                    GRANDSUM_UPSIDEREVENUE_P += BU_SUM_UPSIDEREVENUE_P;
                    GRANDSUM_OPENREVENUE_C += BU_SUM_OPENREVENUE_C;
                    GRANDSUM_WONREVENUE_C += BU_SUM_WONREVENUE_C;
                    GRANDSUM_OPENFORECASTREVENUE_C += BU_SUM_OPENFORECASTREVENUE_C;
                    GRANDSUM_UPSIDEREVENUE_C += BU_SUM_UPSIDEREVENUE_C;
                    GRANDSUM_OPENREVENUE_T += BU_SUM_OPENREVENUE_T;
                    GRANDSUM_WONREVENUE_T += BU_SUM_WONREVENUE_T;
                    GRANDSUM_OPENFORECASTREVENUE_T += BU_SUM_OPENFORECASTREVENUE_T;
                    GRANDSUM_UPSIDEREVENUE_T += BU_SUM_UPSIDEREVENUE_T;
                    SumByBussRepReport buSumRecord = new SumByBussRepReport ();
                    buSumRecord.BUSINESS_GROUP = 'Total';
                    buSumRecord.OPENREVENUE_P =BU_SUM_OPENREVENUE_P ;
                    buSumRecord.WONREVENUE_P = BU_SUM_WONREVENUE_P;
                    buSumRecord.OPENFORECASTREVENUE_P =BU_SUM_OPENFORECASTREVENUE_P;
                    buSumRecord.UPSIDEREVENUE_P =BU_SUM_UPSIDEREVENUE_P;
                    buSumRecord.OPENREVENUE_C=BU_SUM_OPENREVENUE_C;
                    buSumRecord.WONREVENUE_C=BU_SUM_WONREVENUE_C;
                    buSumRecord.OPENFORECASTREVENUE_C=BU_SUM_OPENFORECASTREVENUE_C;
                    buSumRecord.UPSIDEREVENUE_C=BU_SUM_UPSIDEREVENUE_C;
                    buSumRecord.OPENREVENUE_T=BU_SUM_OPENREVENUE_T;
                    buSumRecord.WONREVENUE_T=BU_SUM_WONREVENUE_T;
                    buSumRecord.OPENFORECASTREVENUE_T=BU_SUM_OPENFORECASTREVENUE_T;
                    buSumRecord.UPSIDEREVENUE_T=BU_SUM_UPSIDEREVENUE_T;
                    salesManagerResults3.add(buSumRecord);
                }
                SumByBussRepReport GrandSumRecord = new SumByBussRepReport ();
                GrandSumRecord.REPORTINGNAME = 'Grand Total';
                GrandSumRecord.OPENREVENUE_P =GRANDSUM_OPENREVENUE_P ;
                GrandSumRecord.WONREVENUE_P = GRANDSUM_WONREVENUE_P;
                GrandSumRecord.OPENFORECASTREVENUE_P =GRANDSUM_OPENFORECASTREVENUE_P;
                GrandSumRecord.UPSIDEREVENUE_P =GRANDSUM_UPSIDEREVENUE_P;
                GrandSumRecord.OPENREVENUE_C=GRANDSUM_OPENREVENUE_C;
                GrandSumRecord.WONREVENUE_C=GRANDSUM_WONREVENUE_C;
                GrandSumRecord.OPENFORECASTREVENUE_C=GRANDSUM_OPENFORECASTREVENUE_C;
                GrandSumRecord.UPSIDEREVENUE_C=GRANDSUM_UPSIDEREVENUE_C;
                GrandSumRecord.OPENREVENUE_T=GRANDSUM_OPENREVENUE_T;
                GrandSumRecord.WONREVENUE_T=GRANDSUM_WONREVENUE_T;
                GrandSumRecord.OPENFORECASTREVENUE_T=GRANDSUM_OPENFORECASTREVENUE_T;
                GrandSumRecord.UPSIDEREVENUE_T=GRANDSUM_UPSIDEREVENUE_T;
                salesManagerResults3.add(GrandSumRecord);
            }
        } else {
            String integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.';
            ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
            ApexPages.addMessage(newMessage);
        }
        return null;
    }
   
    public PageReference exportReportToExcel3() {
        getSumByBusinessRepReport();
        return Page.SalesManagerReportssheet;
    }*/
}