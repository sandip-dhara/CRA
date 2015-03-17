public class SalesManagerRepPos {
    //public List<SumByRespAndRepPosReport> salesManagerResults1 {get; set;}
    public transient String employeeNumber {get; set;}
    public String previousQuarter {get; set;}
    public String currentQuarter {get; set;}
    
    public SalesManagerRepPos(ApexPages.StandardController controller) {
        //getSumByRespAndRepPosReport();
    }
    
   /* public class SumByRespAndRepPosReport {
        public transient String RESP_WRKFRC_ID {get; set;}
        public transient String RESPONSIBLENAME{get; set;}
        public transient String REPORTINGNAME{get; set;}
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
   
   public List<SumByRespAndRepPosReport> parseResponseXmlDom(XmlDom.Element[] elements){
              transient List<SumByRespAndRepPosReport>    lstElements = new List<SumByRespAndRepPosReport>();
       if (elements != null) {
            for (XmlDom.Element element : elements) {
                transient SumByRespAndRepPosReport salesMgrXML = new SumByRespAndRepPosReport();    
                salesMgrXML.RESPONSIBLENAME=element.getValue('RESPONSIBLENAME').trim();
                salesMgrXML.REPORTINGNAME=element.getValue('REPORTINGNAME').trim();
                
                if(element.getValue('OPENREVENUE_P').trim()=='')
                    salesMgrXML.OPENREVENUE_P= 0.0; 
                else
                    salesMgrXML.OPENREVENUE_P=Decimal.valueOf(element.getValue('OPENREVENUE_P').trim());

                if(element.getValue('WONREVENUE_P').trim()=='')
                    salesMgrXML.WONREVENUE_P= 0.0; 
                else
                    salesMgrXML.WONREVENUE_P=Decimal.valueOf(element.getValue('WONREVENUE_P').trim());
                    
                if(element.getValue('OPENFORECASTREVENUE_P').trim()=='')
                    salesMgrXML.OPENFORECASTREVENUE_P= 0.0; 
                else
                    salesMgrXML.OPENFORECASTREVENUE_P=Decimal.valueOf(element.getValue('OPENFORECASTREVENUE_P').trim());

                if(element.getValue('UPSIDEREVENUE_P').trim()=='')
                    salesMgrXML.UPSIDEREVENUE_P= 0.0; 
                else
                    salesMgrXML.UPSIDEREVENUE_P=Decimal.valueOf(element.getValue('UPSIDEREVENUE_P').trim());                                                

                if(element.getValue('OPENREVENUE_C').trim()=='')
                    salesMgrXML.OPENREVENUE_C= 0.0; 
                else
                    salesMgrXML.OPENREVENUE_C=Decimal.valueOf(element.getValue('OPENREVENUE_C').trim());

                if(element.getValue('WONREVENUE_C').trim()=='')
                    salesMgrXML.WONREVENUE_C= 0.0; 
                else
                    salesMgrXML.WONREVENUE_C=Decimal.valueOf(element.getValue('WONREVENUE_C').trim());
                    
                if(element.getValue('OPENFORECASTREVENUE_C').trim()=='')
                    salesMgrXML.OPENFORECASTREVENUE_C= 0.0; 
                else
                    salesMgrXML.OPENFORECASTREVENUE_C=Decimal.valueOf(element.getValue('OPENFORECASTREVENUE_C').trim());

                if(element.getValue('UPSIDEREVENUE_C').trim()=='')
                    salesMgrXML.UPSIDEREVENUE_C= 0.0; 
                else
                    salesMgrXML.UPSIDEREVENUE_C=Decimal.valueOf(element.getValue('UPSIDEREVENUE_C').trim());                                                

                if(element.getValue('OPENREVENUE_T').trim()=='')
                    salesMgrXML.OPENREVENUE_T= 0.0; 
                else
                    salesMgrXML.OPENREVENUE_T=Decimal.valueOf(element.getValue('OPENREVENUE_T').trim());

                if(element.getValue('WONREVENUE_T').trim()=='')
                    salesMgrXML.WONREVENUE_T= 0.0; 
                else
                    salesMgrXML.WONREVENUE_T=Decimal.valueOf(element.getValue('WONREVENUE_T').trim());
                    
                if(element.getValue('OPENFORECASTREVENUE_T').trim()=='')
                    salesMgrXML.OPENFORECASTREVENUE_T= 0.0; 
                else
                    salesMgrXML.OPENFORECASTREVENUE_T=Decimal.valueOf(element.getValue('OPENFORECASTREVENUE_T').trim());

                if(element.getValue('UPSIDEREVENUE_T').trim()=='')
                    salesMgrXML.UPSIDEREVENUE_T= 0.0; 
                else
                    salesMgrXML.UPSIDEREVENUE_T=Decimal.valueOf(element.getValue('UPSIDEREVENUE_T').trim());                                                
                                            
                lstElements.add(salesMgrXML);
            }
        }
        return lstElements;
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
   
    public PageReference getSumByRespAndRepPosReport() {

       setCurrAndPrevQuarter();

       salesManagerResults1 = new List<SumByRespAndRepPosReport> ();
       String respStringRep1 = getReportResults(Label.SALESHRCHY_SOAPACTION_1);

       if (respStringRep1 != null && respStringRep1 != '') {
            // XML DOM class
            XmlDom doc = new XmlDom(respStringRep1);
            XmlDom.Element[] elements = doc.getElementsByTagName('Sales_Hierarchy_Summ_Rep_Posn');
       
            List<SumByRespAndRepPosReport> lstOfElements = parseResponseXmlDom(elements);
            if(lstOfElements.size() == 0) {
                XmlDom.Element[] elementsFault = doc.getElementsByTagName('Fault');
                String integrationStatus = 'No results to display';
                if(elementsFault.size()!=0){
                    integrationStatus = elementsFault[0].getValue('faultcode').trim()+ ' '+ elementsFault[0].getValue('faultstring').trim();
                    ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
                    ApexPages.addMessage(newMessage);
                } else if (respStringRep1.contains('html')) {
                    integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.';
                    ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
                    ApexPages.addMessage(newMessage);
                } else {    
                    ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Info, integrationStatus);
                    ApexPages.addMessage(newMessage);
                }
            }
            if(lstOfElements.size() != 0) {
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
                for(SumByRespAndRepPosReport record1: lstOfElements) {
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
                    salesManagerResults1.add(record1);        
                }
                SumByRespAndRepPosReport sumRecord = new SumByRespAndRepPosReport();
                sumRecord.RESPONSIBLENAME = 'Grand Total';
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
                salesManagerResults1.add(sumRecord);
            }
        } else {
            String integrationStatus = 'Callout failed. Proxy URL, or the Tibco URL could be down. Please re-submit your request again later.';
            ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, integrationStatus);
            ApexPages.addMessage(newMessage);
        }
        return null;
    }
   
    public PageReference exportReportToExcel() {
        getSumByRespAndRepPosReport();
        return Page.SalesManagerReportssheet;
    }*/
}