@isTest(SeeAllData=True)
Public Class oppcontactroletest{
// public static User useroptyowner;
//  public static Profile SRProfile = [select Name, Id from Profile where Name ='Sales Rep'];
 /* public static void usercreation(){
    useroptyowner = new User(Lastname = 'TestUseroptyowner', Firstname= 'BG', Username = 'testingoptyowner0128@test.com', Alias='TesBG', CommunityNickname='TestUseroptyownerBG', Email='test0128@email.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyowner0128@test.com',EmployeeNumber='65348261',Legacy_Employee_Ref__c='65348261', ProfileId = SRProfile.id,Business_Group__c = 'ES', Region__c = 'AMS');
    Insert useroptyowner; 
    system.debug('useroptyowner'+useroptyowner);
   }   */
 static testMethod void testDecisionGridcontactrole() {
       //usercreation();
       List<Account> listAccount = new List<Account>();
       //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Customer');
        listAccount.add(account1);
        insert listAccount;
        
        
        //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account1.Id,'tarunOppty1',System.today().addMonths(1));
        //opty.OwnerId=useroptyowner.Id;
        insert opty;
        System.assertEquals(opty.Name,'tarunOppty1');
        
        //Create Opportunity plan record and get the Opty plan ID    
        id OptyplanId = CreateOpportunityPlan.CreateOpptyPlan(opty.Id);
        //PageReference pg = Page.closeplanpage;
        //Test.setCurrentPage(pg);
         
         Opportunity_Plan__c oppplan =new Opportunity_Plan__c ();
         oppplan.Opportunity__c=opty.Id;
         insert oppplan;
         Decision__c ds = new Decision__c();
         ds.Opportunity_Plan__c=oppplan.id;
         insert ds;
         
          test.startTest();
          //System.runAs(useroptyowner){
          ApexPages.StandardController mc = new Apexpages.Standardcontroller(ds);
          oppcontactrole dsncontactrole= new oppcontactrole(mc);
          dsncontactrole.getOppId();
          dsncontactrole.getOppPlanName();
          dsncontactrole.getOppPlanId();
          oppcontactrole.getContacts ('Test');
          dsncontactrole.saveAndGo();
          test.stopTest();
         // }
 }

}