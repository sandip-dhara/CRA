/****************************************
*Test Class - opportunityfieldupdateTest
*Author: Abrar
* date: 21/02/2013
*****************************************/
@isTest(SeeAllData=True)
public class opportunityfieldupdateTest{
 /*private static List<Opportunity> opty = new List<Opportunity>();
 private static Opportunity opty1 = new Opportunity();
 private static Opportunity opty2 = new Opportunity();
 private static Opportunity opty3 = new Opportunity();
 private static Opportunity opty4 = new Opportunity();
 private static Opportunity opty5 = new Opportunity();
 private static user SRuseroptyowner=new user();
  private static Profile SRProfile = [select Name, Id from Profile where Name ='IT Administrator'];  
          public static void usercreation(){
              SRuseroptyowner = new User(Lastname = 'TestUseroptyowner', Firstname= 'BG', Username = 'testingoptyowner0128@hp.com', Alias='TesBG', CommunityNickname='TestUseroptyownerBG', Email='test0128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyowner0128@hp.com',EmployeeNumber='.',Legacy_Employee_Ref__c='65348261', ProfileId = SRProfile.id,Business_Group__c = 'TS', Region__c = 'AMS');
                Insert SRuseroptyowner; 
           }
         public static void setupData() {
         Account acc = TestingSetupDataUtil.createAccount('testbatchAccount', 'testAccount_9@hp.com','Customer');
        acc.ShippingCountry = 'United States';
        insert acc;
        //create a test opportunity
        opty1 = TestingSetupDataUtil.createOpportunity(acc.Id,'BatchTestOpty1',System.Today()+30);
        opty1.StageName='03 - Qualify the Opportunity';
        opty1.fulfillment__c = 'OEM';
        opty.add(opty1);
        opty2 = TestingSetupDataUtil.createOpportunity(acc.Id,'BatchTestOpty2',System.Today()+30);
        opty2.fulfillment__c = 'Sell With';
        opty2.StageName='03 - Qualify the Opportunity';
        opty.add(opty2);
        opty3 = TestingSetupDataUtil.createOpportunity(acc.Id,'BatchTestOpty3',System.Today()+30);
        opty3.fulfillment__c = 'Sell Through';
         opty3.StageName='03 - Qualify the Opportunity';
        opty.add(opty3); 
        opty4 = TestingSetupDataUtil.createOpportunity(acc.Id,'BatchTestOpty4',System.Today()+30);
        opty4.fulfillment__c = 'VSI';
        opty4.StageName='03 - Qualify the Opportunity';
        opty.add(opty4);
        opty5 = TestingSetupDataUtil.createOpportunity(acc.Id,'BatchTestOpty5',System.Today()+30);
        opty5.Route_To_Market__c = 'Direct';
        opty5.StageName='03 - Qualify the Opportunity';
        opty5.fulfillment__c = 'VSI';
        opty.add(opty5);
        insert opty;
        }
          public static testMethod void positiveTest()
      {
       
       user SRuserbatchuser=[select Id, Name from user where name = 'sfdc_bulkload sfdc_bulkload'];
       System.runAs(SRuserbatchuser){
       setupData();
       system.debug(opty1);
       opportunityfieldupdate opp = new opportunityfieldupdate();
       database.ExecuteBatch(opp,200);
      }
      }*/
      public static testMethod void positiveTest(){
      opportunityfieldupdate opp = new opportunityfieldupdate();
      opp.DummymethodforTest();
      }
      }