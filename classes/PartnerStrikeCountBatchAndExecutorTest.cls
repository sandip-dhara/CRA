/***********************************************************
* Class Name: PartnerStrikeCountBatchAndExecutorTest
* Author: Accenture
* Date: 26-JULY-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for PartnerStrikeCountBatch And PartnerStrikeCountBatchExecutor classes
**********************************************************/

@isTest
private class PartnerStrikeCountBatchAndExecutorTest {
        
    //setup your test data in this method
    private static void setupData() {
        
        //Insert Lead
        Lead newLead = TestingSetupDataUtil.createLead('testClassLead', 'qqq123', 'Open', 'Accepted', '123', 't12est1@test.com');
      //  newLead.Account_Name__c = acc.Id;
        newLead.Budget__c = '121' ;
        newLead.Authorized_Buyer__c = 'No';
        newLead.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead.Estimated_Budget__c = 123.0;
        newLead.Last_Modified_by_Partner__c = system.today().addDays(-30);
        insert newLead;
        
        Lead newLead1 = TestingSetupDataUtil.createLead('testClassLead', 'qqq123', 'open', 'Accepted', '123', 't12est1@test.com');
      //  newLead.Account_Name__c = acc.Id;
        newLead1.Budget__c = '121' ;
        newLead1.Authorized_Buyer__c = 'No';
        newLead1.Timeframe_to_Buy_1__c = '< 1 Week';
        newLead1.Estimated_Budget__c = 123.0;
        newLead1.Last_Modified_by_Partner__c = system.today().addDays(-35);
        insert newLead1;
        
        //creating a strike count instance
        Strike_Count_Track__c strikeCntTest = new Strike_Count_Track__c();
        strikeCntTest.User_Assignment_Date__c = system.today() -2;
        strikeCntTest.Two_Day_SLA_Date__c = system.today();
        strikeCntTest.Lead__c = newLead.id;
        insert strikeCntTest;        
       
        Strike_Count_Track__c strikeCntTest1 = new Strike_Count_Track__c();
        strikeCntTest1.User_Assignment_Date__c = system.today() -3;
        strikeCntTest1.Two_Day_SLA_Date__c = system.today();
        insert strikeCntTest1;
        
        Strike_Count_Track__c strikeCntTest2 = new Strike_Count_Track__c();
        strikeCntTest2.User_Assignment_Date__c = system.today() -4;
        strikeCntTest2.Lead__c = newLead.id;
        insert strikeCntTest2; 
        system.debug('the 30 day date is '+strikeCntTest2.Thirty_Day_SLA_Date__c ) ;    
        
        Strike_Count_Track__c strikeCntTest3 = new Strike_Count_Track__c();
        strikeCntTest3.User_Assignment_Date__c = system.today() -5;
        //strikeCntTest3.Thirty_Day_SLA_Date__c = system.today();
        insert strikeCntTest3;
        
         Strike_Count_Track__c strikeCntTest4 = new Strike_Count_Track__c();
        strikeCntTest4.User_Assignment_Date__c = system.today() -6;
        //strikeCntTest4.Thirty_Day_SLA_Date__c = system.today().addDays(5);
        insert strikeCntTest4;
        
         Strike_Count_Track__c strikeCntTest5 = new Strike_Count_Track__c();
        strikeCntTest5.User_Assignment_Date__c = system.today() -7;
        strikeCntTest5.lead__c = newLead1.id;
        insert strikeCntTest5;
        system.debug('the 30 + 5 days date is '+strikeCntTest5.Thirty_Day_SLA_Date__c);
     }
     
    //Method for Positive test
    private static testMethod void PositiveTest() {
        Test.startTest();        
        setupData();
        
        database.executeBatch(new PartnerStrikeCountBatch());
       
        //Creating an instance of the executor
        PartnerStrikeCountBatchExecutor SCTExecutorInstance = new PartnerStrikeCountBatchExecutor();
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('Strike Schedular Test:'+datetime.now(), schExp, SCTExecutorInstance);
     
                
        Test.stopTest();
    }  
   
}