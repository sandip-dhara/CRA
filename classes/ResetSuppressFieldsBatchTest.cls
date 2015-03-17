/**********************************************************
* Class Name: ResetSuppressFieldsBatchTest
* Author: Vijay Ranjan
* Date: 28-May-2013 
* Description: This class does the test coverage
*              for ResetSuppressFieldsBatch class. 
***********************************************************/
@isTest
private class ResetSuppressFieldsBatchTest{

    static testMethod void testResetSuppressFieldsBatch() {
        List<Contact> contList= new List<Contact>(); 
        Contact con;
        Account acc = TestingSetupDataUtil.createAccount('TestRCJ001','abc.def@gh.com','Customer');
        insert acc;
        for(Integer index = 0; index < 5; index++) {
            con = new Contact();
            con.FirstName = 'Test ContactFN' + index;
            con.LastName = 'Test ContactLN' + index;
            con.AccountId = acc.Id;
            con.Email='g@gmail.com';
            con.HomePhone='0987654321';
            con.Suppress_Marketing__c = TRUE;
            con.Suppression_End_Date__c = System.Today()-1;
            con.Suppression_Start_Date__c = System.Today()-10;
            contList.add(con);
        }
        insert contList;
        system.debug('--->contList: ' + contList);
        Test.startTest();
        ResetSuppressFieldsBatch batchtest = new ResetSuppressFieldsBatch();
      //  ID batchprocessid = Database.executeBatch(batch,200);
          batchtest.execute(null,contList);
        Test.stopTest();

    }
}