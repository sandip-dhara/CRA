@isTest
private class DealReg_WebSvcCalloutTest {
    @isTest static void testEchoString() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new DealReg_CustomerSearchControllerImpl());        
        // Call the method that invokes a callout
        Account obj=null;
        List<Account> aList=new List<Account>();
        try{
        DealReg_WebSvcCallout.callWebservice(obj,aList,'us');
        }catch(Exception e){}
        // Verify that a fake result is returned
        //System.assertEquals('Mock response', output); 
    }
}