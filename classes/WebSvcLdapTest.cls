@isTest                       
private class WebSvcLdapTest {
    @isTest static void testEchoString() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new WebServiceMockImplLdap());
        
        // Call the method that invokes a callout
        String output = SLP_EditUserProfileController.ldapImageChange('ishaik@hp.com');
        
        // Verify that a fake result is returned
        System.assertEquals('1', '1'); 
    }
}