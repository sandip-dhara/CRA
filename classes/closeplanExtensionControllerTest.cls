@isTest(seealldata=true)
public class closeplanExtensionControllerTest {
/*  public static User useroptyowner;
  public static Profile SRProfile = [select Name, Id from Profile where Name ='Sales Rep'];
  
   public static void usercreation(){
      useroptyowner = new User(Lastname = 'TestUseroptyowner', Firstname= 'BG', Username = 'testingoptyowner0128@test.com', Alias='TesBG', CommunityNickname='TestUseroptyownerBG', Email='test0128@email.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyowner0128@test.com',EmployeeNumber='65348261',Legacy_Employee_Ref__c='65348261', ProfileId = SRProfile.id,Business_Group__c = 'ES', Region__c = 'AMS');
        Insert useroptyowner; 
system.debug('useroptyowner'+useroptyowner);
   } */
       
   
   
   
    static testMethod void testCloseplan() {
         //usercreation();
        List<Account> listAccount = new List<Account>();
        
        //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Customer');
        listAccount.add(account1);
        insert listAccount;
        
        
        //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account1.Id,'tarunOppty1',System.today().addMonths(1));
        //opty.OwnerId= useroptyowner.Id;
        insert opty;
        System.assertEquals(opty.Name,'tarunOppty1');
        
        //Create Opportunity plan record and get the Opty plan ID    
        id OptyplanId = CreateOpportunityPlan.CreateOpptyPlan(opty.Id);
         system.debug('OptyplanId*****'+OptyplanId);
        //PageReference pg = Page.closeplanpage;
        //Test.setCurrentPage(pg);
       
         id OptyplanId1 = CreateOpportunityPlan.CreateOpptyPlan(opty.Id);
         id OptyplanId2 = CreateOpportunityPlan.CreateOpptyPlan('006800090809QTuIAM');
         system.debug('OptyplanId1*****'+OptyplanId1);
         Opportunity_Plan__c oppplan =new Opportunity_Plan__c ();
         oppplan.Opportunity__c=opty.Id;
         insert oppplan;
            system.debug('oppplan.id*****'+oppplan.id);
          test.startTest();
         
         
           //System.runAs(useroptyowner){
          PageReference pref = Page.ClosePlanEdit;
          pref.getParameters().put('delrowindex', '2'); 
          test.setCurrentPage(pref);
          
          ApexPages.StandardController mc = new Apexpages.Standardcontroller(oppplan);
          closeplanExtensionController clsplnext = new closeplanExtensionController(mc);
          clsplnext.getCloseplanItemWrapper();
          
          List<Close_Plan__c> listcloseplan = new List<Close_Plan__c>();
          Close_Plan__c cplt =new Close_Plan__c(Opportunity_Plan__c = oppplan.Id,DESCRIPTION__c = 'Test Close Plan',Status1__c = 'New');
          listcloseplan .add(cplt );
          insert listcloseplan;
          system.debug('listcloseplan:::::::::::'+listcloseplan);
          
          clsplnext.getCloseplanItemWrapper();  
          clsplnext.getBuyingCriteria();
          clsplnext.getDecisionMakers(); 
          clsplnext.addRow();
          clsplnext.removeOffRowcallplan();
          clsplnext.customSave();
          clsplnext.customCancel();
          test.stopTest();
         
        
     // }
      }
}