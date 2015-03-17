@isTest
private class  BUQualityScoreCardControllerTest{
static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(LastName = 'test', Email = 'test@test.com',Title='abc');
        insert con;
        Contact con2 = new Contact(LastName = 'test2', Email = 'test2@test.com');
        insert con2;
        
        
      Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
      insert acp;
      
      Business_Unit_Plan__c bup = new Business_Unit_Plan__c (Account_Plan__c = acp.id);
       insert bup;
       
       Business_Unit_Plan__c bup1 = new Business_Unit_Plan__c (Account_Plan__c = acp.id);
       insert bup1;
       
         
       Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
       Profile p1 = [SELECT Id FROM Profile WHERE Name='Sales Rep']; 
       User u = new User(Alias = 'standt', Email='standarduser@hp.com', 
       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
       LocaleSidKey='en_US', ProfileId = p.Id,Legacy_Employee_Ref__c='********',Email_Address__c ='qwert@hp.com',Business_Group__c ='IPG',
       TimeZoneSidKey='America/Los_Angeles', UserName='standarduser01a@testorg.com',Adoption_Role_Type__c='Account Executive'); 
       insert u; 
       
       
         
        User u1 = new User(Alias = 'standtt', Email='standardusers@hp.com', 
       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
       LocaleSidKey='en_US', ProfileId = p.Id,Legacy_Employee_Ref__c='*********',Email_Address__c ='qwerty@hp.com',Business_Group__c ='IPG',
       TimeZoneSidKey='America/Los_Angeles', UserName='standarduser01ab@testorg.com',Adoption_Role_Type__c='Account Executive'); 
       insert u1;   
       
       
       
       system.runas(u){
       
       BU_Plan_Approval__c apr  = new BU_Plan_Approval__c(Approver__c = u.id, Business_Unit_Plan__c = bup.id,Plan_Status__c ='In Progress');
         insert apr;
       
       BU_plan_Scorecard__c bsc = new BU_plan_Scorecard__c (Business_Unit_Plan__c =bup.id);
       insert bsc;

        ApexPages.StandardController sc = new ApexPages.StandardController(bsc);
         BUQualityScoreCardController ars = new  BUQualityScoreCardController(sc);
         ars.apprecords = [Select id,Approver__c,Plan_Status__c From BU_Plan_Approval__c where  Business_Unit_Plan__c=:bup.id ORDER BY Name DESC limit 1  ];
        ars.getRelSuite();
        ars.getAns2();
        ars.getAns3();
        ars.getAns4();   
          ars.getAns5();           
           ars.getTypes();
           ars.getSummaryScore();
           ars.cancel();  
           ars.Save();
           String ans = ars.getSummaryScore();
           ars.cancel(); 
           ars.setSummaryScore(ans);
           
            PageReference pageRef = Page.BUQualityScoreCard;
           // String nextPage = sc.save().geturl();
           pageRef.setRedirect(true);
        Test.setCurrentPage(pageRef);
          
          }  
          
          
           system.runas(u1){
       
       BU_Plan_Approval__c apr  = new BU_Plan_Approval__c(Approver__c = u.id, Business_Unit_Plan__c = bup.id,Plan_Status__c ='In Progress');
         insert apr;
       
       BU_plan_Scorecard__c bsc = new BU_plan_Scorecard__c (Business_Unit_Plan__c =bup.id);
       insert bsc;

        ApexPages.StandardController sc = new ApexPages.StandardController(bsc);
         BUQualityScoreCardController ars = new  BUQualityScoreCardController(sc);
         ars.apprecords = [Select id,Approver__c,Plan_Status__c From BU_Plan_Approval__c where  Business_Unit_Plan__c=:bup.id ORDER BY Name DESC limit 1  ];
        ars.getRelSuite();
        ars.getAns2();
        ars.getAns3();
        ars.getAns4();   
          ars.getAns5();           
           ars.getTypes();
           ars.getSummaryScore();
           ars.cancel();  
           ars.Save();
           String ans = ars.getSummaryScore();
           ars.cancel(); 
           ars.setSummaryScore(ans);
           
            PageReference pageRef = Page.BUQualityScoreCard;
           // String nextPage = sc.save().geturl();
           pageRef.setRedirect(true);
        Test.setCurrentPage(pageRef);
          
          }  
            
         
        
       }   
}