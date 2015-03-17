@isTest
private class JBPWebSvcCalloutTest{
    @isTest static void testEchoString() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new JBPExstreamControllerImpl());   
               
       String sId='1234';
       String userEmail='test@hp.com';
       String pptLanguage='English';
       String country='India';
       String pptLanguageCode ='en';
       String loggedInUserLanguageCode='en';
       String currencyCode='USD';
       
       try{
       String testing=JBPWebSvcCallout.callWebservice(sId,userEmail,pptLanguage,pptLanguageCode,loggedInUserLanguageCode,country,currencyCode,'$',1,1,'True','True','True','True','True','True');       
       }catch(Exception e){}
    }
}