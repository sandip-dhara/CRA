/**********************************************************
* Class Name: JBPExtreamWebserviceStub 
* Author: HP
* Date: 07-MAY-2013 
* Description: This class does the test coverage for JBPExtreamWebserviceStub class. 
***********************************************************/

@isTest(SeeAllData=true)
private class JBPExtreamWebserviceStubTest {
private static TestMethod void test1(){ 
   
JBPExtreamWebserviceStub test = new JBPExtreamWebserviceStub (); 

 JBPExtreamWebserviceStub.HPExtreamJBP jbpextream= new JBPExtreamWebserviceStub.HPExtreamJBP(); 
          
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
      
 JBPExtreamWebserviceStub.Security_element obj=new JBPExtreamWebserviceStub.Security_element('','','','');
 JBPExtreamWebserviceStub.UsernameToken_element obj1=new JBPExtreamWebserviceStub.UsernameToken_element('','','','');
 }    
}