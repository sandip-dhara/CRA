@isTest(seeAllData=true)
public class DGOpportunityExtensionControllerTest{

   private static opportunity newOpp = new Opportunity();
   private static opportunity newOpp1 = new Opportunity();
   private static Profile SRProfile = [select Name, Id from Profile where Name ='Sales Rep'];  
   public static User userTest ;
   public static Account newAcc = new Account();
   public static Account newAcc1 = new Account();
   public static Regional_Profile__c listRP2 = new Regional_Profile__c();
   public static Global_Business_Forum__c listGBF = new Global_Business_Forum__c();
   
     
   /* User Creation for Opportunity Owner and Requestor */
   public static void usercreation(){
       //generate Random String 
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
       userTest = TestingSetupDataUtil.createUser('DA_'+randomstr.substring(0,4),randomstr+'DGOptyExt@hp.com',randomstr+'DGOptyExt@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','DGOptyExt@hp.com','5521235615',Userinfo.getProfileId());
       insert userTest ;               
   }     
  
  /* Account and Opportunty Data setup */
   public static void dataSetup1(){
        
        
        newAcc=TestingSetupDataUtil.createAccount('TestAccountforOptyST','test_22@hp.com','Customer');
        insert newAcc;
       // TestingSetupDataUtil.createUserAccTeamMembers();
        newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'TestOptyforOptyST', system.today()+ 30);
        newOpp.owner__c=userTest.id; 
        newOpp.stageName=  '01 - Understand Customer';
        //opplist.add(newOpp);  
        insert newOpp;
        system.debug('@@@Abrar Opty'+newOpp);
             
       }
       
       
        public static void dataSetup2(){
        
        newAcc1=TestingSetupDataUtil.createAccount('TestAccountforOptyST1','test_22@hp.com','Customer');
        insert newAcc1;
       // TestingSetupDataUtil.createUserAccTeamMembers();
        newOpp1=TestingSetupDataUtil.createOpportunity(newAcc1.Id, 'TestOptyforOptyST1', system.today()+ 30);
        newOpp1.owner__c=userTest.id; 
        newOpp1.stageName=  '01 - Understand Customer';
        //opplist.add(newOpp);  
        insert newOpp1;
        system.debug('@@@Abrar Opty'+newOpp);
        listGBF.Opportunity__c = newOpp.Id;
        insert listGBF;
        listRP2.Global_Business_Forum__c = listGBF.Id;
        insert listRP2;
            
       }
    
    public static testMethod void PositiveTest(){  
    usercreation();
    dataSetup1();
    Test.StartTest();
     System.RunAs(userTest){
    ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(newOpp);
    DGOpportunityExtensionController DGPage = new DGOpportunityExtensionController(stdcontroller); 
    DGPage.oOptyId = newOpp.Id;
    DGPage.SaveOpty();
    DGPage.SaveGBF(); 
    DGPage.getRegionalPro();
    DGPage.ApprovalRequest();
    DGPage.EditGBF();
    DGPage.CancelGBF();
    DGPage.addRow();
    Regional_Profile__c listRP = new Regional_Profile__c();
    insert listRP;
    DGPage.sRPId = listRP.Id;
    DGPage.DeleteRow();
    } 
   
    }
     
    public static testMethod void PositiveTest1(){  
    usercreation();
    dataSetup2();
    Test.StartTest();
     System.RunAs(userTest){
     
    ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(newOpp1);
    DGOpportunityExtensionController DGPage1 = new DGOpportunityExtensionController(stdcontroller); 
    newOpp1.CloseDate = system.today()- 30;
    DGPage1.SaveOpty();
    DGPage1.SaveGBF(); 
    DGPage1.getRegionalPro();
    
    }    
   }
   
   }