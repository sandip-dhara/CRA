@isTest
private class FlagContactByBUTest{
Public static Account acc;
private static TestMethod void FlagContactByBUtesting(){

 /* Setting up data */
     
  acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;   
        
      Contact testContact =  TestingSetupDataUtil.createContact(acc.Id, 'TestLastName');
      testContact.Email='testcontact@testing.com';  
       User u1 = [Select id from User where Global_Business_Unit__c ='BPO' limit 1];
      testContact.Ownerid = u1.id; 
      insert testContact;
      
     User u2 = [Select id from User where Global_Business_Unit__c = 'HPFS' limit 1];  
     testContact.Ownerid = u2.id;  
      Update testContact;
      
      system.assertEquals(testContact.AccountId,acc.Id);
  
  }
  }