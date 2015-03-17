@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method    
    global HTTPResponse respond(HTTPRequest req) {
        Map<String,CPQAttachmentWSConst__c> CPQConstantMap= CPQAttachmentWSConst__c.getAll();
        String sEndPointURL=CPQConstantMap.get('EndPointURL').WSConstants__c;
        // Optionally, only send a mock response for a specific endpoint        // and method.
        //System.assertEquals(sEndPointURL, req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
       // res.setStatus('OK');
        return res;
    }
}