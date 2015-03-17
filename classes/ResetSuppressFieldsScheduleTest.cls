/**********************************************************
* Class Name: ResetSuppressFieldsScheduleTest
* Author: HP
* Date: 23-NOV-2012 
* Description: This class does the test coverage
*              for ResetSuppressFieldsSchedule class. 
***********************************************************/

@IsTest
public Class ResetSuppressFieldsScheduleTest{

static testmethod void testResetSuppressFieldsSchedule(){

                 
       List<Contact> contList= new List<Contact>(); 
        Contact con;
        Account acc = TestingSetupDataUtil.createAccount('TestRCJ001','abc.def@gh.com','Customer');
        insert acc;
        for(Integer index = 0; index < 3; index++) {
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

       
            ResetSuppressFieldsSchedule suppressSch =new ResetSuppressFieldsSchedule();
           // oppscheduler.optyids=oppmap;
            Test.startTest();
            String sch = '0 20 9 * * ?';
            system.schedule('SuppressSchTest', sch, suppressSch );
            Test.stopTest();

     }
   
  }