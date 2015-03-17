public class CPQSendSupReqAttachment
{

    public Map<String,CPQAttachmentWSConst__c> CPQConstantMap= CPQAttachmentWSConst__c.getAll();
    public class SupportRequestInput
    {
        public String SupportRequestNumber;
        public String ExtractXML;
        public  String ContentType;
        public String EmailBody;

    }

    public class SupportRequestWSOutput
    {
        CPQSendSupReqAttachment.FaultClass Fault;
        CPQSendSupReqAttachment.SupportRequestOutput Message;

        public SupportRequestWSOutput()
        {
            this.Fault= new CPQSendSupReqAttachment.FaultClass();
            this.Message = new CPQSendSupReqAttachment.SupportRequestOutput();
        }
    }

    public class SupportRequestOutput
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
            this.CreatedDateTime = DateTime.Now().formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');

            Blob sPasswordBlob= Blob.valueOf(this.sNonceStr+ this.CreatedDateTime+ this.Password);
            this.enCryptedPassword=EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',sPasswordBlob));
            this.Nonce= EncodingUtil.base64Encode(Blob.valueOf(this.sNonceStr));
        }
    }
    public CPQSendSupReqAttachment()
    {
    }

    public Dom.Document CreateSuppReqWS(WSESecurity oWSESecurity ,SupportRequestInput oSupportRequestInput)
    {
        Dom.Document SupportRequestInputDom= new Dom.Document();

        Dom.XmlNode SOAPEnvelope= SupportRequestInputDom.createRootElement('Envelope',CPQConstantMap.get('SOAPENVNameSpc').WSConstants__c,'soapenv');
        SOAPEnvelope.setNamespace('sch',CPQConstantMap.get('SupportRequestNameSpc').WSConstants__c);

        Dom.XmlNode SOAPHeader=SOAPEnvelope.addChildElement('Header',CPQConstantMap.get('SOAPENVNameSpc').WSConstants__c,null);

        Dom.XmlNode SecurityHeader=SOAPHeader.addChildElement('Security',CPQConstantMap.get('WSENAMESPC').WSConstants__c,'wsse');
        SecurityHeader.setAttributeNs('soapenv:mustUnderstand','1',null,null);    

        Dom.XmlNode UserToken=SecurityHeader.addChildElement('UsernameToken',CPQConstantMap.get('WSENAMESPC').WSConstants__c,'wsse');       
        UserToken.setNamespace('wsu',CPQConstantMap.get('WSEUserTokenNameSpc').WSConstants__c);
        UserToken.setAttributeNs('Id',CPQConstantMap.get('UserTokenId').WSConstants__c,null,null);  

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

        Dom.XMLNode SendAttachment= SOAPBody.addChildElement('SendAttachment',CPQConstantMap.get('SupportRequestNameSpc').WSConstants__c,'sch');

        Dom.XMLNode ExtractXML = SendAttachment.addChildElement('ExtractXML',CPQConstantMap.get('SupportRequestNameSpc').WSConstants__c,'sch');
        ExtractXML.addTextNode(oSupportRequestInput.ExtractXML);

        Dom.XMLNode EmailBody = SendAttachment.addChildElement('EmailBody',CPQConstantMap.get('SupportRequestNameSpc').WSConstants__c,'sch');
        EmailBody.addTextNode(oSupportRequestInput.EmailBody);

        Dom.XMLNode SupportRequestNumber = SendAttachment.addChildElement('SupportRequestNumber',CPQConstantMap.get('SupportRequestNameSpc').WSConstants__c,'sch');
        SupportRequestNumber.addTextNode(oSupportRequestInput.SupportRequestNumber);

        Dom.XMLNode ContentType = SendAttachment.addChildElement('ContentType',CPQConstantMap.get('SupportRequestNameSpc').WSConstants__c,'sch');
        ContentType.addTextNode(oSupportRequestInput.ContentType);

        System.debug('***********SOAP Message**********'+SupportRequestInputDom.toXmlString());

        return(SupportRequestInputDom);
    }

    public CPQSendSupReqAttachment.SupportRequestWSOutput readCPQAttachmentWSOutput(HTTPResponse resp)
    {
        CPQSendSupReqAttachment.SupportRequestWSOutput oSupportReqOut= new CPQSendSupReqAttachment.SupportRequestWSOutput();
        oSupportReqOut.Fault.FaultCode=String.valueOf(resp.getStatusCode());
        oSupportReqOut.Fault.FaultString=resp.getStatus();
        Dom.Document oOutputDom=resp.getBodyDocument();
        system.debug('########SOAP Response#########:'+oOutputDom.toXMLString());
        Dom.XMLNode SOAPEnvelope= oOutputDom.getRootElement();
        if(SOAPEnvelope!=null&& SOAPEnvelope.getName().toUpperCase()=='Envelope'.toUpperCase())
        {
            for(Dom.XMLNode oSoapBody:SOAPEnvelope.getChildren())
            {
                if(oSoapBody.getName()=='Body')
                {
                    for(Dom.XMLNode oOutput:oSoapBody.getChildren())
                    {
                        if(oOutput.getName()=='Output'||oOutput.getName()=='Fault')
                        {
                            for(Dom.XMLNode oResult:oOutput.getChildren())
                            {
                                if(oResult.getName().toUpperCase()=='Result'.toUpperCase())
                                {
                                    oSupportReqOut.Message.Message=oResult.getText();

                                }
                                if(oResult.getName().toUpperCase()=='ResultCode'.toUpperCase())
                                {
                                    oSupportReqOut.Message.MessageCode=oResult.getText();
                                }
                                if(oResult.getName().toUpperCase()=='faultstring'.toUpperCase())
                                {
                                    oSupportReqOut.Fault.FaultString=oResult.getText();
                                }
                                if(oResult.getName().toUpperCase()=='faultcode'.toUpperCase())
                                {
                                    oSupportReqOut.Fault.FaultCode= oResult.getText();
                                }
                            }
                        }
                    }
                }
            }


        }
        else
        {
            oSupportReqOut.Message.Message=oSupportReqOut.Fault.FaultString;
            oSupportReqOut.Message.MessageCode=oSupportReqOut.Fault.FaultCode;
        }

        return(oSupportReqOut);

    }


    public String InvokeSRAttachmentWS(CPQSendSupReqAttachment.SupportRequestInput Input)
    {
        /***** Fetch Tibco Password********************/
        TibcoSecurity__c TibSecObj= [Select t.Name, t.TibcoPassword__c From TibcoSecurity__c t where t.TargetSystemName__c ='Q2C' limit 1];
        String SuccessMessage='';
        String ClientCertificate= Label.SFDC_Certificate; 
        String sEndPointURL=CPQConstantMap.get('EndPointURL').WSConstants__c;

        if(TibSecObj!=null)
        {
            try{
                Dom.Document SoapRequest= this.CreateSuppReqWS(new WSESecurity(TibSecObj.Name,TibSecObj.TibcoPassword__c),Input);
                HTTP oHTTP= new HTTP();
                HTTPRequest oHTTPReq= new HTTPRequest();
                HTTPResponse oHTTPRes;
                oHTTPReq.setMethod('POST');
                oHTTPReq.setEndpoint(sEndPointURL);
                oHTTPReq.setHeader('Content-Type', 'text/xml');
                oHTTPReq.setHeader('SOAPAction',CPQConstantMap.get('EndPointAction').WSConstants__c);
                oHTTPReq.setTimeout(Integer.valueof(CPQConstantMap.get('RequestTimeOut').WSConstants__c));
                oHTTPReq.setClientCertificateName(ClientCertificate);
                oHTTPReq.setBodyDocument(SoapRequest);
                oHTTPRes=oHTTP.send(oHTTPReq);
                CPQSendSupReqAttachment.SupportRequestWSOutput Output=readCPQAttachmentWSOutput(oHTTPRes);

                System.debug('********Output Message*******'+Output);
                if(Output.Message.MessageCode=='0')
                {
                    SuccessMessage='SUCCESS';
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
                        SuccessMessage=CPQConstantMap.get(Output.Fault.FaultCode).WSConstants__c;

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