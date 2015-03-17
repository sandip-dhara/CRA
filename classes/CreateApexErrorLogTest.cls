/**********************************************************
* Class Name: CreateApexErrorLogTest
* Author: Accenture
* Date: 2-MAY-2012 
* Description: This class does the test coverage for CreateApexErrorLog
***********************************************************/

@isTest
private class CreateApexErrorLogTest{
    CreateApexErrorLog createApexErrorLog = new CreateApexErrorLog();
    public static Account newAccount;
    //Create Lead for insertHandledExceptionsTest
    private static void setupData1(){
     
        Lead lead = TestingSetupDataUtil.createLead('TestLead21', 'TestLComp', null, null, null, null);
        List<Account> account = new List<Account>();
        newAccount = new Account();
        newAccount = TestingSetupDataUtil.createAccount('testAccount15', 'testAccount1@accenture.com', 'Customer');
        account.add(newAccount);
        
        Database.SaveResult[] lsr;
        try{
            lsr= Database.Insert(account,false);
            System.assertEquals(account[0].Id != null, true);
            insert lead;
            System.assertNotEquals(null, lead.Id);
        }catch(Exception e){
             CreateApexErrorLog.insertHandledExceptions(e,lsr,'Testobj','TestClass','ApexClass');        
        } 
     
    }
    //Create Lead for insertHandledExceptionsTest
    private static void setupData2(){
     
        Lead lead1 = TestingSetupDataUtil.createLead('TestLead21','TestComp1',null, null,'123123', null);
        Lead lead2 = TestingSetupDataUtil.createLead('','TestComp2',null, null,'1231234', null);
        
        List<Lead> leads =new List<Lead>();
        leads.add(lead1);
        leads.add(lead2);
        
        Database.Saveresult[] arrSaveRes;
        arrSaveRes = Database.insert(leads, false);       
        CreateApexErrorLog.insertHandledExceptions(null,arrSaveRes ,'Testobj','TestClass','ApexClass');   
    }
    //Create Lead for insertHandledExceptionsForLeadConversionTest1
    private static void setupData3(){     
        
        Database.LeadConvertResult lcr;        
        newAccount = new Account();
        newAccount = TestingSetupDataUtil.createAccount('testAccount1', 'testAccount1@accenture.com', 'Customer');
        insert newAccount;
        System.assertEquals(newAccount.Id != null, true);
        
        Database.LeadConvert lc = new database.LeadConvert();

        Lead tlead1= TestingSetupDataUtil.createLead('Test123', 'testAccount1', 'Qualified', 'Accepted','123456789', null);
        tlead1.Conv_Account__c = newAccount.Id;
        
        try{ 
            insert tlead1;
            System.assertNotEquals(null, tlead1.Id);
            lc.setLeadId(tlead1.id);
            //lc.setAccountId(newAccount.Id); 
            lcr = Database.convertLead(lc);
        }catch(Exception e) {
             CreateApexErrorLog.insertHandledExceptionsForLeadConversion(e,lcr,'Testobj','TestClass','ApexClass');         
        }  
            
    }   
    
    //Create Lead for insertHandledExceptionsForLeadConversionTest2
   private static void setupData4(){   
        Database.LeadConvertResult lcr;
         newAccount = new Account();       
        newAccount = TestingSetupDataUtil.createAccount('testAccount2', 'testAccount@accenture.com', 'Customer');
        insert newAccount;
        System.assertEquals(newAccount.Id != null, true);
        
        Database.LeadConvert lc = new database.LeadConvert();  

        Lead tlead2=TestingSetupDataUtil.createLead('TestLeadName23', 'testAccount2', 'Qualified', 'Accepted','123456789', null);
        tlead2.Conv_Account__c = newAccount.Id;
        try{
            insert tlead2;
            System.assertNotEquals(null, tlead2.Id);
            LeadStatus convStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convStatus.MasterLabel);
            lc.setLeadId(tlead2.id); 
            
            lcr = Database.convertLead(lc);
        }catch(Exception e) {
             CreateApexErrorLog.insertHandledExceptionsForLeadConversion(e,lcr,'Testobj','TestClass','ApexClass');         
        }
        CreateApexErrorLog.insertHandledExceptionsForLeadConversion(null,lcr,'Testobj','TestClass','ApexClass');         
          
  
    }    
    
    static testMethod void insertHandledExceptionsTest(){
        Test.startTest();       
        setupData1();   
        setupData2();
        Test.stopTest();    
    }
    
    
    static testMethod void insertHandledExceptionsForLeadConversionTest1(){
        Test.startTest();       
        setupData3();   
        Test.stopTest();
    
    }
    
   static testMethod void insertHandledExceptionsForLeadConversionTest2(){
        Test.startTest();       
        setupData4();
        Test.stopTest();
    
    }
    
 }