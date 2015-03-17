@isTest
private class SLP_JSONParseUtilTest {
    @isTest static void testCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SLP_FileUploadStaticResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        // Call the method that performs the callout
        Test.startTest();
        SLP_FileUploadClasses.FileRequest fsreq  = new SLP_FileUploadClasses.FileRequest();  
        fsreq.Name = 'DocumentTestRequestName.docx';
        SLP_FileUploadClasses.FileResponse res = SLP_JSONParserUtil.parseJSONResponse(fsreq);
        Test.stopTest();

        // Verify response received contains values returned by
        // the mock response.
        System.assertEquals('DummyTest1.docx', res.Name);
        System.assertEquals('Doc123', res.DocId);
    }
}