public class CPQCallSQService{
    public Map<String,CPQAttachmentWSConst__c> CPQConstantMap= CPQAttachmentWSConst__c.getAll();
    public class ServiceRequestInput{
        public String Countrycode;
        public String CountryName;
        public String CustOrgId;
        public String DealRegId;
        public String FirstName;
        public String LastName;
        public String HPPUserId;
        public String LanguageCode;
        public String OptyId;
        public String PartnerProId;
        public String mdcpOpsId;
        public String mdcpOpsiId;
        public List<String> ListofCompetitorOrgIds;
        public Map<String,String> PriceDescriptor;
    }
    public class SQWSOutput{
        CPQCallSQService.FaultClass Fault;
        CPQCallSQService.SQOutput Message;

        public SQWSOutput()
        {
            this.Fault= new CPQCallSQService.FaultClass();
            this.Message = new CPQCallSQService.SQOutput();
        }
    }

    public class SQOutput
    {
        public String MessageCode;
        public String Message;
    }
    public class FaultClass
    {
        public String FaultCode;
        public String  FaultString;
    }
    public class WSESecurity
    {
        public String UserName;
        private String Password;
        public String enCryptedPassword;
        private String sNonceStr;
        public String Nonce;
        public String CreatedDateTime;

        public WSESecurity(String UserName, String Password)
        {
            this.UserName=UserName;
            this.Password=Password;
            this.sNonceStr= String.ValueOf(Crypto.getRanDomLong());
            this.CreatedDateTime = DateTime.Now().formatGmt('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            Blob sPasswordBlob= Blob.valueOf(this.sNonceStr+ this.CreatedDateTime+ this.Password);
            this.enCryptedPassword=EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',sPasswordBlob));
            this.Nonce= EncodingUtil.base64Encode(Blob.valueOf(this.sNonceStr));
        }
    }

    public Dom.Document CreateSQWS(WSESecurity oWSESecurity ,ServiceRequestInput oSQInput)
    {
        Dom.Document SQInputDom= new Dom.Document();

        Dom.XmlNode SOAPEnvelope= SQInputDom.createRootElement('Envelope',CPQConstantMap.get('SOAPENVNameSpc').WSConstants__c,'soapenv');
        SOAPEnvelope.setNamespace('sqin',CPQConstantMap.get('SQNameSpc').WSConstants__c);

        Dom.XmlNode SOAPHeader=SOAPEnvelope.addChildElement('Header',CPQConstantMap.get('SOAPENVNameSpc').WSConstants__c,null);

        Dom.XmlNode SecurityHeader=SOAPHeader.addChildElement('Security',CPQConstantMap.get('WSENAMESPC').WSConstants__c,'wsse');
        SecurityHeader.setAttributeNs('soapenv:mustUnderstand','1',null,null);    

        Dom.XmlNode UserToken=SecurityHeader.addChildElement('UsernameToken',CPQConstantMap.get('WSENAMESPC').WSConstants__c,'wsse');       
        UserToken.setNamespace('wsu',CPQConstantMap.get('WSEUserTokenNameSpc').WSConstants__c);
        UserToken.setAttributeNs('wsu:Id',CPQConstantMap.get('UserTokenId').WSConstants__c,null,null);  

        Dom.XmlNode UserName=UserToken.addChildElement('Username',CPQConstantMap.get('WSENAMESPC').WSConstants__c,'wsse');
        UserName.addTextNode(oWSESecurity.UserName);

        Dom.XmlNode Password=UserToken.addChildElement('Password',CPQConstantMap.get('WSENAMESPC').WSConstants__c,'wsse');
        Password.setAttributeNs('Type',CPQConstantMap.get('PasswordType').WSConstants__c,null,null);  
        Password.addTextNode(oWSESecurity.enCryptedPassword);

        Dom.XmlNode Nonce=UserToken.addChildElement('Nonce',CPQConstantMap.get('WSENAMESPC').WSConstants__c,'wsse');
        Nonce.setAttributeNs('EncodingType',CPQConstantMap.get('EncodingType').WSConstants__c,null,null);
        Nonce.addTextNode(oWSESecurity.Nonce);

        Dom.XmlNode Created=UserToken.addChildElement('Created',CPQConstantMap.get('WSEUserTokenNameSpc').WSConstants__c,'wsu');
        Created.addTextNode(oWSESecurity.CreatedDateTime);

        Dom.XmlNode SOAPBody=SOAPEnvelope.addChildElement('Body',CPQConstantMap.get('SOAPENVNameSpc').WSConstants__c,null);

        Dom.XMLNode SmartQuoteInput = SOAPBody.addChildElement('SmartQuoteInput',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
        
        Dom.XMLNode SQInput = SmartQuoteInput.addChildElement('SQInput',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
        
        if(oSQInput.Countrycode != null && oSQInput.Countrycode != ''){
            Dom.XMLNode Countrycode = SQInput.addChildElement('Countrycode',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            Countrycode.addTextNode(oSQInput.Countrycode);
        }
        if(oSQInput.CountryName != null && oSQInput.CountryName != ''){
            Dom.XMLNode CountryName = SQInput.addChildElement('CountryName',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            CountryName.addTextNode(oSQInput.CountryName);
        }
        
        if(oSQInput.CustOrgId != null && oSQInput.CustOrgId != ''){
            Dom.XMLNode CustOrgId = SQInput.addChildElement('CustOrgId',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            CustOrgId.addTextNode(oSQInput.CustOrgId);
        }
        
        if(oSQInput.DealRegId != null && oSQInput.DealRegId != ''){
            Dom.XMLNode DealRegId = SQInput.addChildElement('DealRegId',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            DealRegId.addTextNode(oSQInput.DealRegId);
        }
        
        if(oSQInput.FirstName != null && oSQInput.FirstName != ''){
            Dom.XMLNode FirstName = SQInput.addChildElement('FirstName',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            FirstName.addTextNode(oSQInput.FirstName);
        }
        
        if(oSQInput.HPPUserId != null && oSQInput.HPPUserId != ''){
            Dom.XMLNode HPPUserId = SQInput.addChildElement('HPPUserId',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            HPPUserId.addTextNode(oSQInput.HPPUserId);
        }
        
        if(oSQInput.LanguageCode != null && oSQInput.LanguageCode != ''){
            Dom.XMLNode LanguageCode = SQInput.addChildElement('LanguageCode',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            LanguageCode.addTextNode(oSQInput.LanguageCode);
        }
                
        if(oSQInput.LastName != null && oSQInput.LastName != ''){
            Dom.XMLNode LastName = SQInput.addChildElement('LastName',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            LastName.addTextNode(oSQInput.LastName);
        }
        
        if(oSQInput.OptyId != null && oSQInput.OptyId != ''){
            Dom.XMLNode OptyId = SQInput.addChildElement('OptyId',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            OptyId.addTextNode(oSQInput.OptyId);
        }
        
        if(oSQInput.PartnerProId != null && oSQInput.PartnerProId != ''){
            Dom.XMLNode PartnerProId = SQInput.addChildElement('PartnerProId',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            PartnerProId.addTextNode(oSQInput.PartnerProId);
        }
        
        if(oSQInput.mdcpOpsId != null && oSQInput.mdcpOpsId != ''){
            Dom.XMLNode mdcpOpsId = SQInput.addChildElement('mdcpOpsId',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            mdcpOpsId.addTextNode(oSQInput.mdcpOpsId);
        }
        
        if(oSQInput.mdcpOpsiId != null && oSQInput.mdcpOpsiId != ''){
            Dom.XMLNode mdcpOpsiId = SQInput.addChildElement('mdcpOpsiId',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
            mdcpOpsiId.addTextNode(oSQInput.mdcpOpsiId);
        }
        
        if(oSQInput.ListofCompetitorOrgIds != null){
            if(!oSQInput.ListofCompetitorOrgIds.isEmpty()){
                Dom.XMLNode CompetitorOrgIds = SQInput.addChildElement('ListofCompetitorOrgIds',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
                for(string CompetitorID : oSQInput.ListofCompetitorOrgIds){
                    Dom.XMLNode compId = CompetitorOrgIds.addChildElement('Id',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
                    compId.addTextNode(CompetitorID);
                }
            }
        }
        
        if(oSQInput.PriceDescriptor != null){
            if(!oSQInput.PriceDescriptor.isEmpty()){
                Dom.XMLNode PriceDescriptor = SQInput.addChildElement('PriceDescriptor',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
                for(string CurrencyCode : oSQInput.PriceDescriptor.keyset()){
                    Dom.XMLNode CurrencyNode = PriceDescriptor.addChildElement('Currency',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
                    CurrencyNode.addTextNode(CurrencyCode);
                    
                    Dom.XMLNode GeoCode = PriceDescriptor.addChildElement('GeoCode',CPQConstantMap.get('SQNameSpc').WSConstants__c,'sqin');
                    GeoCode.addTextNode(oSQInput.PriceDescriptor.get(CurrencyCode));
                }
            }
        }

        System.debug('***********SOAP Message**********'+SQInputDom.toXmlString());

        return(SQInputDom);
    }

    public CPQCallSQService.SQWSOutput readCPQSQWSOutput(HTTPResponse resp)
    {
        CPQCallSQService.SQWSOutput oSQOut= new CPQCallSQService.SQWSOutput();
        oSQOut.Fault.FaultCode=String.valueOf(resp.getStatusCode());
        oSQOut.Fault.FaultString=resp.getStatus();
        Dom.Document oOutputDom=resp.getBodyDocument();
        system.debug('########SOAP Response#########:'+oOutputDom.toXMLString());
        Dom.XMLNode SOAPEnvelope= oOutputDom.getRootElement();
        if(SOAPEnvelope!=null&& SOAPEnvelope.getName().toUpperCase()=='Envelope'.toUpperCase())
        {
            system.debug('********SOAPEnvelope.getName()******'+SOAPEnvelope.getName());
            for(Dom.XMLNode oSoapBody:SOAPEnvelope.getChildren())
            {
                system.debug('*******oSoapBody*******'+oSoapBody);
                if(oSoapBody.getName()=='Body')
                {
                    for(Dom.XMLNode SQOutput : oSoapBody.getChildren()){
                        if(SQOutput.getName() == 'SQOutput'){
                            for(Dom.XMLNode oOutput:SQOutput.getChildren())
                            {
                                system.debug('*******oOutput.getName()*******'+oOutput.getName());
                                if(oOutput.getName()=='Output'||oOutput.getName()=='Fault' || oOutput.getName()=='ErrorMessage' || oOutput.getName()=='QuoteId' || oOutput.getName()=='Status')
                                {
                                    if(oOutput.getName().toUpperCase()=='Result'.toUpperCase())
                                    {
                                        oSQOut.Message.Message=oOutput.getText();

                                    }
                                    if(oOutput.getName().toUpperCase()=='ResultCode'.toUpperCase())
                                    {
                                        oSQOut.Message.MessageCode=oOutput.getText();
                                    }
                                    if(oOutput.getName().toUpperCase()=='faultstring'.toUpperCase())
                                    {
                                        oSQOut.Fault.FaultString=oOutput.getText();
                                    }
                                    if(oOutput.getName().toUpperCase()=='faultcode'.toUpperCase())
                                    {
                                        oSQOut.Fault.FaultCode= oOutput.getText();
                                    }
                                    if(oOutput.getName().toUpperCase()=='quoteId'.toUpperCase())
                                    {
                                        if(oOutput.getText() != '' && oOutput.getText() != null){
                                            oSQOut.Message.MessageCode = '0';
                                            oSQOut.Message.Message = oOutput.getText();
                                        }
                                        /*else{
                                            oSQOut.Fault.FaultString = 'SQ Service is not responding';
                                            oSQOut.Fault.FaultCode = 'Response Error';
                                        }*/
                                    }
                                    if(oOutput.getName().toUpperCase()=='ErrorMessage'.toUpperCase())
                                    {
                                        system.debug('*******oOutput******'+oOutput);
                                        if(oOutput.getText() != '' && oOutput.getText() != null){
                                            oSQOut.Fault.FaultString = oOutput.getText();
                                            oSQOut.Fault.FaultCode = 'Response Error';
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }


        }
        else
        {
            oSQOut.Message.Message=oSQOut.Fault.FaultString;
            oSQOut.Message.MessageCode=oSQOut.Fault.FaultCode;
        }

        return(oSQOut);

    }


    public String InvokeSQWS(CPQCallSQService.ServiceRequestInput Input)
    {
        /***** Fetch Tibco Password********************/
        TibcoSecurity__c TibSecObj= [Select t.Name, t.TibcoPassword__c From TibcoSecurity__c t where t.TargetSystemName__c ='Q2C' limit 1];
        String SuccessMessage='';
        String ClientCertificate= Label.SFDC_Certificate; 
        String sEndPointURL=CPQConstantMap.get('ENDPointURLForSQ').WSConstants__c;

        if(TibSecObj!=null)
        {
            try{
                Dom.Document SoapRequest= this.CreateSQWS(new WSESecurity(TibSecObj.Name,TibSecObj.TibcoPassword__c),Input);
                system.debug('******SoapRequest*****'+SoapRequest);
                HTTP oHTTP= new HTTP();
                HTTPRequest oHTTPReq= new HTTPRequest();
                HTTPResponse oHTTPRes;
                oHTTPReq.setMethod('POST');
                oHTTPReq.setEndpoint(sEndPointURL);
                oHTTPReq.setHeader('Content-Type', 'text/xml');
                oHTTPReq.setHeader('SOAPAction',CPQConstantMap.get('EndPointActionSQ').WSConstants__c);
                oHTTPReq.setTimeout(Integer.valueof(CPQConstantMap.get('RequestTimeOut').WSConstants__c));
                oHTTPReq.setClientCertificateName(ClientCertificate);
                oHTTPReq.setBodyDocument(SoapRequest);
                system.debug('*******oHTTPReq******'+oHTTPReq);
                oHTTPRes=oHTTP.send(oHTTPReq);
                CPQCallSQService.SQWSOutput Output=readCPQSQWSOutput(oHTTPRes);

                System.debug('********Output Message*******'+Output);
                if(Output.Message.MessageCode=='0')
                {
                    SuccessMessage='Success';
                }
                else
                {
                    if(Output.Message.MessageCode!=null &&Output.Message.MessageCode!='' && Output.Message.MessageCode!='0')
                    {
                        System.debug('Output Message Code***'+Output.Message.MessageCode);
                        SuccessMessage=CPQConstantMap.get(Output.Message.MessageCode).WSConstants__c;
                    }
                    else
                    {
                        System.debug('Fault Message Code***'+Output.Fault.FaultCode);
                        if(CPQConstantMap.containskey(Output.Fault.FaultCode))
                            SuccessMessage=CPQConstantMap.get(Output.Fault.FaultCode).WSConstants__c;
                        else
                            SuccessMessage=Output.Fault.FaultString;

                    }

                }            
            }
            catch (Exception e) {
                SuccessMessage = e.getMessage();
            }
        }
        else
        {
            SuccessMessage='Error Invoking the WebService. Login Credentials are not available';
        }

        if(SuccessMessage=='')
        {
            SuccessMessage='Unknown Error. Please check the System Logs';
        }
        return(SuccessMessage);
    }
}