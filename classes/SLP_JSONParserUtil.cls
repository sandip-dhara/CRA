public class SLP_JSONParserUtil {
    //@future(callout=true)
   
    public static SLP_FileUploadClasses.FileResponse parseJSONResponse(SLP_FileUploadClasses.FileRequest fsr) {    
        SLP_FileUploadClasses.FileResponse fsresp  = new SLP_FileUploadClasses.FileResponse(); 
        string statusResult = 'none';
        string respBody = '';
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        String endpoint = 'https://it-services-gw-csc-itg.external.hp.com/gw/esit/sl/file/api/files';   // make sure the SF Security -> Remote Site settings are set for thie usl
        request.setEndPoint(endpoint);
        //
        // POST
        //
        request.setMethod('POST');
        request.setHeader('Content-type', 'application/json');
        // The Gateway (Secure Reverse Proxy) to our IDOL instance requires its clients to 
        // present a system Digital Badge (certificate issued by the HP Level 2 CA).
        try 
        {
            request.setClientCertificateName('SFDC_Certificate'); 
        }
        catch (System.CalloutException e)
        {
            System.debug('Unable to find or set SFDC_Certificate.');
        }   
        
        try
        {
            String JSONString = JSON.serialize(fsr);  
                system.debug('fsrName '+ fsr.Name);
                system.debug('JSONString '  + JSONString);
            request.setBody(JSONString);
            //request.setBodyDocument(document);
            Http http = new Http();
                request.setTimeout(60000);      // milliseconds
                HTTPResponse response = http.send(request);
            respBody = response.getBody();
            System.debug('request getbody ' + respBody);
    
            // Parse JSON response to get all the field values.
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                system.debug('Parsetext ' + parser.getText());
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'Name')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.Name = parser.getText();
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'DocId')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.DocId = parser.getText();
                }
                 else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'InternalUrl')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.InternalUrl = parser.getText();
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'ExternalUrl')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.ExternalUrl = parser.getText();
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'Success')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.Success = Boolean.valueOf(parser.getText());
                }
                 else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'status')) {
                   // Get the value.
                   parser.nextToken();
                        
                        if (parser.getText() == 'error') {
                            fsresp.Success = false;
                        }
                        else {
                            fsresp.Success = true;
                        }
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'Error')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.Error = parser.getText();
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'reason')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.Error = respBody;
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'target')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.Error = respBody;
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'MimeType')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.MimeType = parser.getText();
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'Version')) {
                   // Get the value.
                   parser.nextToken();
                    fsresp.Version = parser.getText();
                }
            }
        }
             catch (Exception e)
        {
            System.debug('send exception ' + e.getMessage());
        }
        return fsresp;
    }     
}