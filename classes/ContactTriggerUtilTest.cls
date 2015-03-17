/**********************************************************
* Class Name: ContactTriggerUtilTest
* Author: Accenture
* Date: 2-MAY-2012 
* Description: This class does the test coverage for ContactTriggerUtil and ContactTriggerController class. 
***********************************************************/
@isTest
private class ContactTriggerUtilTest{
  
  /* Setting up data */
  private static void setupData(){
     
      Account acc = TestingSetupDataUtil.createAccount('TestCTU Account', 'testCTUccount@test.com','Customer');
      insert acc;    
          
      Contact testContact =  TestingSetupDataUtil.createContact(acc.Id, 'TestLastName');
      testContact.Email='testcontact@testing.com';
      LeadConvertController.fromLeadConversion = true; 
      insert testContact;
      
      system.assertEquals(testContact.AccountId,acc.Id);
      
  }
  
  /* Running test */
  static testMethod void contactTriggerTest() {
      Test.startTest();
      setupData();
      Test.stopTest();
  }
}