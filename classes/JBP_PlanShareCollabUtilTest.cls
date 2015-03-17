/************************************************************************************
* Class Name: JBP_PlanShareCollabUtilTest
* Author: HP
* Date: 07-MAY-2013 
* Requirement # Request Id: 6249, 5429
* Description: This class does the test coverage for JBP_PlanShareCollabUtil class.
*************************************************************************************/

@isTest(seeAllData = True)
public class JBP_PlanShareCollabUtilTest{
    static Account accPartner1 = new Account();
    static Account accPartner2 = new Account();
    static User user1 = new User();
    static User user2 = new User();
    static Sales_Territory__c partSalesTerry;
    static Sales_Territory__c partSalesTerry1;
    static Sales_Territory_Account_Assignment__c SalesTrrtyAccAsgn;
    static Sales_Territory_Account_Assignment__c SalesTrrtyAccAsgn1;
    static Sales_Territory_User_Assignment__c stuassn;
    static Sales_Territory_User_Assignment__c stuassn1;
    
    //setup your test data in this method
    public static void setupDataJBP() {
        accPartner1 = TestingSetupDataUtil.createAccount('partnerAcc', 'partnerAccT1@hp.com', 'Partner');
        accPartner2 = TestingSetupDataUtil.createAccount('partnerAcc1', 'partnerAccT2@hp.com', 'Partner');
        insert accPartner1;
        insert accPartner2;
        accPartner1.isPartner = true;
        accPartner2.isPartner = true;
        update accPartner1;
        update accPartner2;
        
        partSalesTerry = new Sales_Territory__c();
        partSalesTerry.isPartner__c = true;
        partSalesTerry.OwnerId = userInfo.getUserId();
        partSalesTerry.Opportunity_Access__c = 'Read';
        partSalesTerry.Name = accPartner1.Name;
        partSalesTerry.IsPartner__c = true;
        partSalesTerry.IsActive__c = true;
        partSalesTerry.Case_Access__c = 'Read';
        partSalesTerry.Account_Access__c = 'Read';
        partSalesTerry.isExternal__c = False;
        partSalesTerry.MyComp_Sales_Territory_Name__c = 'test';
        insert partSalesTerry;
        
        partSalesTerry1 = new Sales_Territory__c();
        partSalesTerry1.isPartner__c = true;
        partSalesTerry1.OwnerId = userInfo.getUserId();
        partSalesTerry1.Opportunity_Access__c = 'Read';
        partSalesTerry1.Name = accPartner1.Name;
        partSalesTerry1.IsPartner__c = true;
        partSalesTerry1.IsActive__c = true;
        partSalesTerry1.Case_Access__c = 'Read';
        partSalesTerry1.Account_Access__c = 'Read';
        partSalesTerry1.isExternal__c = True;
        partSalesTerry1.MyComp_Sales_Territory_Name__c = 'test';
        insert partSalesTerry1;
        
        set<id> grpid = new set<id>();
        grpid.add(partSalesTerry.GroupID__c);
        SalesTrrtyAccAsgn = new Sales_Territory_Account_Assignment__c();
        SalesTrrtyAccAsgn.Account__c = accPartner1.ID;
        SalesTrrtyAccAsgn.Sales_Territory__c = partSalesTerry.Id;
        insert SalesTrrtyAccAsgn;
        
        set<id> grpids = new set<id>();
        grpids.add(partSalesTerry1.GroupID__c);
        SalesTrrtyAccAsgn1 = new Sales_Territory_Account_Assignment__c();
        SalesTrrtyAccAsgn1.Account__c = accPartner2.ID;
        SalesTrrtyAccAsgn1.Sales_Territory__c = partSalesTerry1.Id;
        insert SalesTrrtyAccAsgn1;
        
        user1 = TestingSetupDataUtil.createUser('sndjbp','standardjbpusr2@hp.com','usrjbpte@hp.com','UTF-8','jbplastname','en_US','en_US','America/Los_Angeles','produsjbp@hp.com','21869997',Userinfo.getProfileId());
        user2 = TestingSetupDataUtil.createUser('sndjbp1','standardjbpusr12@hp.com','usrjbp1te@hp.com','UTF-8','jbp1lastname','en_US','en_US','America/Los_Angeles','produsjbp1@hp.com','21899997',Userinfo.getProfileId());
        user1.Adoption_Role_Type__c = 'Executive';
        user2.Adoption_Role_Type__c = 'Executive';
        insert user1;
        insert user2;
        
        stuassn= new Sales_Territory_User_Assignment__c(Sales_Territory__c=partSalesTerry.id, User__c=user1.id,IsActive__c=true);
        insert stuassn;
        
        stuassn1= new Sales_Territory_User_Assignment__c(Sales_Territory__c=partSalesTerry1.id, User__c=user2.id,IsActive__c=true);
        insert stuassn1;
        
    }
   //Method for positive test case
    public static testMethod void PositiveTest() {
    
    Test.startTest();
    
    setupDataJBP();
    
    date dt = system.today()+20;
    jbp__c jbpshare = new jbp__c(Name = 'Acc JBP', Partner_Account__c = accPartner1.Id, PPT_Export_Language__c = 'English', PPT_Export_Currency__c = 'USD',BG__c = 'SW',Named_HP_Management_Approver__c = user1.Id, Plan_End_Date__c = dt);
    insert jbpshare;
    jbpshare.Named_HP_Management_Approver__c = user2.Id ;
    update jbpshare;
     
    Test.stoptest();
    }
    
    public static testmethod void NegativeTest(){
    test.startTest();
    
    setupDataJBP();
    date dt = system.today()+20;
    jbp__c jbpshare1 = new jbp__c(Name = 'Acc JBP1', Partner_Account__c = accPartner2.Id, PPT_Export_Language__c = 'English', PPT_Export_Currency__c = 'USD',BG__c = 'SW',Named_HP_Management_Approver__c = user2.Id, Plan_End_Date__c = dt);
    insert jbpshare1;
    
    
    test.StopTest();
    }
    public static testmethod void testPlanShareAccess(){
    User currentUser = [select Id from user where Id =: UserInfo.getUserId()];
    String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
    Profile userProfile = [select id from profile where name='Gold Partner User'];
    test.startTest();
    
    /* Create a test Account */
    Account accRec = new Account();
    accRec = TestingSetupDataUtil.createAccount('Testing Account','testing@test.com','Partner');
    insert accRec;
    
    /* Create a test Contacts */
    List<Contact> contactList = new List<Contact>();
    Contact testContactRecOne = new Contact();
    testContactRecOne = TestingSetupDataUtil.createContact(accRec.id,'testingContactOne');
    contactList.add(testContactRecOne); 
    Contact testContactRecTwo = new Contact();
    testContactRecTwo = TestingSetupDataUtil.createContact(accRec.id,'testingContactTwo');
    contactList.add(testContactRecTwo); 
    insert contactList;
    
    /*creating a test portal user */
    List<User> usrList = new List<User>();
    User testingUserOne = new User();
    User testingUserTwo = new User();
    testingUserOne = TestingSetupDataUtil.createUser('U1_'+randomstr.substring(0,4),randomstr+'portalUserTestOne@hp.com',randomstr+'portalUserTestOne@hp.com','UTF-8','PortalTestUserOne','en_US','en_US','America/Los_Angeles','userTestOne@hp.com','55239990',userProfile.id);
    testingUserOne.contactid = contactList[0].id;
    testingUserOne.Adoption_Role_Type__c = 'Field Sales Rep';
    testingUserOne.portal_Tab_Access__c = 'JBP';
    testingUserTwo = TestingSetupDataUtil.createUser('U2_'+randomstr.substring(0,4),randomstr+'portalUserTestTwo@hp.com',randomstr+'portalUserTestTwo@hp.com','UTF-8','PortalTestUserTwo','en_US','en_US','America/Los_Angeles','userTestTwo@hp.com','55239991',userProfile.id);
    testingUserTwo.contactid = contactList[1].id;
    testingUserTwo.Adoption_Role_Type__c = 'Field Sales Rep';
    testingUserTwo.portal_Tab_Access__c = 'JBP';
    user1 = TestingSetupDataUtil.createUser('sndjbp','standardjbpusr2@hp.com','usrjbpte@hp.com','UTF-8','jbplastname','en_US','en_US','America/Los_Angeles','produsjbp@hp.com','21869997',Userinfo.getProfileId());
    user1.Adoption_Role_Type__c = 'Executive';
    usrList.add(testingUserOne);
    usrList.add(testingUserTwo);
    usrList.add(user1);
    System.runAs(currentUser){
        insert usrList;
    }       
    /*Create a JBP */
    JBP__c jbp = new JBP__c();
    jbp.Name = 'Test_JBP_PortalUserNotification';
    jbp.BG__c = 'PPS';
    jbp.Partner_Account__c = accRec.id;
    jbp.Plan_End_Date__c = system.today()+20;
    jbp.Partner_Approver__c = contactList[0].id;
    jbp.Partner_Approver_2__c = contactList[1].id;
    jbp.Named_HP_Management_Approver__c = user1.id;
    insert jbp;
    jbp.Partner_Approver__c = contactList[1].id;
    jbp.Partner_Approver_2__c = contactList[0].id;
    jbp.Named_HP_Management_Approver__c =Null;
    update jbp;
    
    test.StopTest();
    }
}