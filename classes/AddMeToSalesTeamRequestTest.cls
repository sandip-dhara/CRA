@isTest(seeAllData=true)
public class AddMeToSalesTeamRequestTest{

   private static opportunity newOpp = new Opportunity();
   private static Profile SRProfile = [select Name, Id from Profile where Name ='IT Administrator'];  
   public static User SRuseroptyowner;
   public static User SRuseroptyRequestor;
   public static Add_to_Sales_Team__c ST = new  Add_to_Sales_Team__c();
     
   /* User Creation for Opportunity Owner and Requestor */
   public static void usercreation(){
          SRuseroptyowner = new User(Lastname = 'TestUseroptyowner', Firstname= 'BG', Username = 'testingoptyowner0128@hp.com', Alias='TesBG1', CommunityNickname='TestUseroptyownerBG123', Adoption_Role_Type__c = 'Account Executive', Email='test0128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyowner0128@hp.com',EmployeeNumber='.',Legacy_Employee_Ref__c='65348261', ProfileId = SRProfile.id,Business_Group__c = 'ES', Region__c = 'AMS');
          Insert SRuseroptyowner; 
          SRuseroptyRequestor= new User(Lastname = 'TestUseroptyRequestor', Firstname= 'BG', Username = 'testingoptyowner0128req@hp.com', Alias='TesBG2', CommunityNickname='TestUseroptyreqBG123', Adoption_Role_Type__c = 'Account Executive', Email='test0128req@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyReq0128@hp.com',EmployeeNumber='.',Legacy_Employee_Ref__c='653482612', ProfileId = SRProfile.id,Business_Group__c = 'ES', Region__c = 'AMS');
          Insert SRuseroptyRequestor; 
    
   }     
  
  /* Account and Opportunty Data setup */
   public static void dataSetup1(){
        
        Account newAcc=TestingSetupDataUtil.createAccount('TestAccountforOptyST','test_22@hp.com','Customer');
        insert newAcc;
       // TestingSetupDataUtil.createUserAccTeamMembers();
        newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'TestOptyforOptyST', system.today()+ 30);
        newOpp.owner__c=SRuseroptyowner.id; 
        newOpp.stageName=  '01 - Understand Customer';
        //opplist.add(newOpp);  
        insert newOpp;
        system.debug('@@@Abrar Opty'+newOpp);
              
       }
       
   /* Sales Team request record creation  */  
   public static void salesteamreqsetup(){
        ST = new Add_to_Sales_Team__c();
        ST.Opportunity_Team_role__c = 'Account Executive';
        ST.Permission__c = 'Read Only';
        ST.Opportunity__c = newOpp.Id;
        ST.Comments__c = 'This is TEST record';
        //insert ST;
    }
    
    public static void salesteamreqsetup1(){
        ST = new Add_to_Sales_Team__c();
        ST.Opportunity_Team_role__c = 'Account Executive';
        ST.Permission__c = 'Edit';
        ST.Opportunity__c = newOpp.Id;
        ST.Comments__c = 'This is TEST record';
        //insert ST;
    }
   /* Test method for requesting the Add me to Sales Team */
   public static testMethod void PositiveTest(){
     usercreation();
     Test.startTest();
     
     //Created Opty with SRuseroptyowner
     System.RunAs(SRuseroptyowner){
      dataSetup1();
       }
       
     //Created Add me to Sales Team record with SRuseroptyRequestor
     System.RunAs(SRuseroptyRequestor){
      salesteamreqsetup();
      ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(newOpp);
      AddRequestortoSalesTeamController AddReq =new AddRequestortoSalesTeamController(stdcontroller);  
      AddReq.OpId = newOpp.Id;
      AddReq.save();
      ST = AddReq.salesteam;
      system.debug('@@@@AbrarST'+ST);
       }
           
    System.RunAs(SRuseroptyowner){
       ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(newOpp);
       //ApexPages.StandardSetController stdsetcontroller = new ApexPages.StandardSetController();
       NotificationtoSalesTeamController Notify = new NotificationtoSalesTeamController(stdcontroller);
       Notify.STRecordId = ST.Id;
       Notify.LoggedinUserId = SRuseroptyowner.Id;
       Notify.getListSalesTeam();
       system.debug('@@@@Abrar'+Notify.getListSalesTeam());
       Notify.SaveAccept();
     }   
     
     System.RunAs(SRuseroptyRequestor){
      salesteamreqsetup1();
      ApexPages.Standardcontroller stdcontroller1 = new ApexPages.StandardController(newOpp);
      AddRequestortoSalesTeamController AddReq1 =new AddRequestortoSalesTeamController(stdcontroller1);  
      AddReq1.OpId = newOpp.Id;
      AddReq1.save();
      ST = AddReq1.salesteam;
      system.debug('@@@@AbrarST'+ST);
       } 
     System.RunAs(SRuseroptyowner){
       ApexPages.Standardcontroller stdcontroller2 = new ApexPages.StandardController(newOpp);
       //ApexPages.StandardSetController stdsetcontroller = new ApexPages.StandardSetController();
       NotificationtoSalesTeamController Notify1 = new NotificationtoSalesTeamController(stdcontroller2);
       Notify1.STRecordId = ST.Id;
       Notify1.LoggedinUserId = SRuseroptyowner.Id;
       Notify1.getListSalesTeam();
       system.debug('@@@@Abrar'+Notify1.getListSalesTeam());
       Notify1.SaveReject();
       Notify1.getPendingRequestCount();
     } 
     
   }     
}