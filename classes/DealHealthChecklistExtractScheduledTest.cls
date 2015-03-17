@IsTest(Seealldata=true)
public Class DealHealthChecklistExtractScheduledTest{

static testmethod void testDealHealthChecklistExtractScheduled(){

     Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testuser=new User();   
        testuser.FirstName = 'firstName';
        testuser.LastName = 'lastName';
        testuser.Email = 'Test@hp.com';
        testuser.Username = 'userName@hp.com';
        testuser.ProfileId = p.Id;
        testuser.Alias = 'aliasno';
        testuser.CommunityNickname ='nickmame';
        testuser.TimeZoneSidKey='America/Los_Angeles';
        testuser.LocaleSidKey='en_US';
        testuser.EmailEncodingKey='UTF-8';
        testuser.LanguageLocaleKey='en_US';
        testuser.Email_Address__c='Test@hp.com';    
        testuser.EmployeeNumber='0011223344';
        testuser.Legacy_Employee_Ref__c='0011223344';
        testuser.Business_Group__c='ES';
        testuser.Adoption_Role_Type__c='Account Executive';
        insert testuser;
        
        Account acc1=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
        insert acc1;
        Opportunity opp = new Opportunity(AccountId = acc1.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD',Route_To_Market__c='Direct');
        insert opp;
        Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id,Sales_Stage__c='Stage 1&2-Understand/Validate',DHC_last_updated__c='Pradeep Kumar LG, 2/19/2013 5:51 AM',DHC_Last_Updated_Lagacy_No__c='userName@hp.com');
        opplan.DHC_Comments_WTB__c='test';
        insert opplan;   
        
     System.runAs(testuser) {
        
        //update opplan;
 
        Map<Id,Opportunity> opptymap=new  Map<Id,Opportunity>();
        opptymap.put(opp.Id,opp);
        List<Opportunity_Plan__c> opptyplanlist=new List<Opportunity_Plan__c>();
        opptyplanlist.add(opplan);
        List<User> testuserlist=new List<User>();
        testuserlist.add(testuser);
      
      DealHealthChecklistExtractScheduled dhcscheduler=new DealHealthChecklistExtractScheduled();  
      DealHealthChecklistExtractScheduled.isTestrun=true;
      dhcscheduler.opportunityplanlist=opptyplanlist;   
      dhcscheduler.userlist=testuserlist;                
            
            Test.startTest();
            String sch = '0 20 9 * * ?';
            system.schedule('dhecxtracttest', sch, dhcscheduler);
            Test.stopTest();
            
        }
        }
        
     }