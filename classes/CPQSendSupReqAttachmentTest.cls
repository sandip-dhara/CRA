/***********************************************************
* Class Name: CPQSendSupReqAttachmentTest
* Author: HP
* Date: 31-JAN-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for web service callout
***********************************************************/

@isTest(SeeAllData=true)
private class CPQSendSupReqAttachmentTest{
    //Test Method 
    public static testMethod void WebServiceCalloutTest() {
        Test.startTest();
        //Call Webservice for Email R4.0
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    CPQSendSupReqAttachment oSupReqAttach= new CPQSendSupReqAttachment();
    CPQSendSupReqAttachment.SupportRequestInput oSupInput=new CPQSendSupReqAttachment.SupportRequestInput();
    oSupInput.SupportRequestNumber='SR-0000000123';
    oSupInput.ExtractXML='N';
    oSupInput.ContentType='text/html';
    oSupInput.EmailBody='Test body';
    String SuccessMessage = oSupReqAttach.InvokeSRAttachmentWS(oSupInput);
        Test.stopTest();
    }
}