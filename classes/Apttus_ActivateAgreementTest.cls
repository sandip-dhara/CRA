/*
Test class for Apttus_ActivateAgreement.cls

*/

@isTest  
private class Apttus_ActivateAgreementTest {  

//private static Profile profile1 = [Select Id,Name from Profile where Name = 'Apttus Legal' LIMIT 1];
//private static User usr = [Select Id  from User where ProfileId =:profile1.Id Limit 1];

     private static Account acc; 
     private static Apttus__APTS_Agreement__c agreement ; 
     private static Attachment attachment ; 
     

static void createTestData(){
 
     
/*   Create test account and agreement */
// Create an Account   
       acc = new Account(); 
       acc.name='Apttus-TestAcc';
       acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       acc.ShippingCountry='India';
          insert acc;


     // Creating Agreement
        agreement  = new Apttus__APTS_Agreement__c();
        agreement.name='ApttusTestAgrName';
     //  agreement.Apttus__Related_Opportunity__c=newOpp.id;
        agreement.Apttus__Account__c=acc.id;
        agreement.ownerId=[Select id,QueueId from QueueSobject where SobjectType = 'Apttus__APTS_Agreement__c' AND Queue.Name = 'Axiom'].QueueId;
        agreement.RecordTypeId=Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Letter Agreement').getRecordTypeId();
        insert agreement;

// Create an attachment
        attachment = new Attachment(); 
        attachment.Name='Test Attachment.txt';
        Blob bodyBlob=Blob.valueOf('Test Agreement Attachment Body');
        attachment.body=bodyBlob;
        attachment.parentId=agreement.id;
        insert attachment ;
        

}


   // @isTest 
    static testmethod void testActivateAgreement() {                
        
        createTestData();
        String sessionID = UserInfo.getSessionId();
         
//        test.startTest();
        Test.setMock(WebServiceMock.class, new Apttus_AgreementWebServiceMockImpl());  
          
      //  System.runAs(usr){
       
        System.debug(UserInfo.getName()); 
        Apttus_ActivateAgreement.activate(agreement.Id,sessionID);  
     //   }
  
    
    
    
    /*
//    test.startTest(); 
    Test.setMock(WebServiceMock.class, new Apttus_AgreementContentWSMockImpl());  
    //String sessionID = UserInfo.getSessionId();
    System.debug(UserInfo.getName()); 
    Apttus_ActivateAgreement.publish(agreement.Id,sessionID, attachment.Id);
    test.stopTest();
    */
    }
    
    static testmethod void testPublishAgreement() {                
        
        createTestData();
        String sessionID = UserInfo.getSessionId();
   
        test.startTest();

        Test.setMock(WebServiceMock.class, new Apttus_AgreementContentWSMockImpl());  
        //String sessionID = UserInfo.getSessionId();
        System.debug(UserInfo.getName()); 
        Apttus_ActivateAgreement.publish(agreement.Id,sessionID, attachment.Id);
        test.stopTest();
     }
    
    
}