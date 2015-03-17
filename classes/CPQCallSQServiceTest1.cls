@isTest(SeeAllData=true)
private class CPQCallSQServiceTest1{
    //Test Method 
    public static testMethod void WebServiceCalloutTest() {
        Test.startTest();
        //Call Webservice for Email R4.0
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    CPQCallSQService CallSQService= new CPQCallSQService();
    CPQCallSQService.ServiceRequestInput oSupInput =new CPQCallSQService.ServiceRequestInput();
    
    //oSupInput.ExtractXML='N';
    //oSupInput.ContentType='text/html';
    //oSupInput.EmailBody='Test body';
    String SuccessMessage = CallSQService.InvokeSQWS(oSupInput);
    //String SuccessMessage = oSupReqAttach.InvokeSRAttachmentWS(oSupInput);
        Test.stopTest();
    }
}