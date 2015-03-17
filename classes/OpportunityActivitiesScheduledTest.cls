@IsTest(seealldata=true)
public Class OpportunityActivitiesScheduledTest{

static testmethod void testOpportunityActivitiesScheduled(){

     /* Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'testAct', Email='testAct012@hp.com', 
      EmailEncodingKey='UTF-8', LastName='tAct', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='testAct0123@hp.com',
      Legacy_Employee_Ref__c='00112234',Email_Address__c='testAct0124@hp.com',Business_Group__c='ES');


      System.runAs(u) {
      IsFirstGripExtract__c gripex=new IsFirstGripExtract__c();
      gripex.name='test';
      insert gripex;
      
       Account acc1=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
        insert acc1;
        Opportunity opp = new Opportunity(AccountId = acc1.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD',Route_To_Market__c='Direct',Amount=100);
        insert opp;
       
               
            Task newtask=new Task();
            newtask.WhatId=opp.Id;
            newtask.Subject='Call';
            Insert newtask;
            Map<id,Opportunity> oppmap=new Map<id,Opportunity>();
            oppmap.put(opp.Id,opp);
            OpportunityActivitiesScheduled oppscheduler=new OpportunityActivitiesScheduled();
            oppscheduler.optyids=oppmap;
            Test.startTest();
            String sch = '0 20 9 * * ?';
            system.schedule('opptasktest', sch, oppscheduler);
            Test.stopTest();

     }*/
           OpportunityActivitiesScheduled oppscheduler=new OpportunityActivitiesScheduled();
           oppscheduler.subject='test';
           Test.startTest();
            String sch = '0 20 9 * * ?';
            system.schedule('opptasktest', sch, oppscheduler);
            Test.stopTest();
        }  
        
   }