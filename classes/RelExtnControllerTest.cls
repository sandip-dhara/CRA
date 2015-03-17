@isTest(seealldata=true)
public class RelExtnControllerTest {
//public static User useroptyowner;
//public static Profile SRProfile = [select Name, Id from Profile where Name ='Sales Rep'];
  
  /* public static void usercreation(){
      useroptyowner = new User(Lastname = 'TestUseroptyowner', Firstname= 'BG', Username = 'testingoptyowner0128@test.com', Alias='TesBG', CommunityNickname='TestUseroptyownerBG', Email='test0128@email.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyowner0128@test.com',EmployeeNumber='65348261',Legacy_Employee_Ref__c='65348261', ProfileId = SRProfile.id,Business_Group__c = 'ES', Region__c = 'AMS');
      Insert useroptyowner; 
      system.debug('useroptyowner'+useroptyowner);
   } */

    static testMethod void testRelSuite() {
       // usercreation();
        List<Account> listAccount = new List<Account>();
        
        //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Customer');
        listAccount.add(account1);
        insert listAccount;
        
        
        //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account1.Id,'tarunOppty1',System.today().addMonths(1));
       // opty.OwnerId=useroptyowner.Id;
        insert opty;
        System.assertEquals(opty.Name,'tarunOppty1');
        
        //Create Opportunity plan record and get the Opty plan ID    
        id OptyplanId = CreateOpportunityPlan.CreateOpptyPlan(opty.Id);
        //PageReference pg = Page.closeplanpage;
        //Test.setCurrentPage(pg);
         
         Opportunity_Plan__c oppplan =new Opportunity_Plan__c ();
         oppplan.Opportunity__c=opty.Id;
         insert oppplan;
          Relationship_Suite__c rs =new Relationship_Suite__c ();
          rs.Opportunity_Plan__c=oppplan.Id;
          insert rs;
         system.currentPageReference().getParameters().put('retURL','/apex/');  
        system.currentPageReference().getParameters().put('OppId',rs.Id);  
          test.startTest();
         //System.runAs(useroptyowner){ 
          //PageReference pref = Page.ClosePlanEdit;
          //pref.getParameters().put('delrowindex', '2'); 
          //test.setCurrentPage(pref);
          List<SelectOption> so= new List<SelectOption>();
          ApexPages.StandardController mc = new Apexpages.Standardcontroller(rs);
          RelExtnController rsext = new RelExtnController(mc);
          rsext.getRelSuite();
          //rsext.initialize();
          rsext.Save();
          rsext.cancel();
          rsext.OppContacts=so;
          List<SelectOption> getOppContacts=rsext.OppContacts;
          rsext.OppContactRole = 'test3';
          String getOppContactRole= rsext.OppContactRole;
          test.stopTest();
         
     // }   
      }
}