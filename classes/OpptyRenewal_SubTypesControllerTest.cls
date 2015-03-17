/**********************************************************
 * Class Name: OpptyRenewal_SubTypesControllerTest
 * Author: HP
 * Date: 5-Nov-2012 
 * Requirement # 
 * Description: This is a Test Class to test OptyRenewal_SubbTypesController Class.
 ***********************************************************/

@isTest(SeeAllData=True)
public class OpptyRenewal_SubTypesControllerTest {

  /**
   * @description: Test Method to Test the Class
   * @param: No Parameter Passed
   * 
   */
  public static testMethod void TestOpptyRenewalSubType(){

    Profile p = [select id from Profile limit 1]; 
    User u1 = new user (Username = ' test11081987@hp.com', 
        alias='test', 
        LastName ='test',
        email='deepak.knmiet@hp.com',
        communityNickname='test342',
        TimeZoneSidKey='America/Los_Angeles',
        LocaleSidKey='en_US',
        EmailEncodingKey='ISO-8859-1',
        Region__c = 'U.S.',
        ProfileId=p.id,
        LanguageLocaleKey='en_US',
        Approver_Email_A__c='deepak.knmiet@hp.com',
        Email_Address__c = 'deepak.knmiet@hp.com',
        EmployeeNumber='1234',
        Legacy_Employee_Ref__c='3456',
        Adoption_Role_Type__c='Executive' );
    insert u1;

   // System.runAs(u1){
      Account a =  TestingSetupDataUtil.createAccount('testDemoAcc001','testDemoAcc@hp.com','Customer');
      Insert a;

      Opportunity opp= new Opportunity(Name='Demo Opp', CloseDate=date.parse('1/1/2020'), AccountId=a.id, StageName='01 - Understand Customer');
      Insert opp;
      
      Test.startTest();
      
      PageReference pr = Page.OpptyRenewal_SubTypes;
      pr.getParameters().put('id', opp.Id); 
      Test.setCurrentPage(pr);
      ApexPages.StandardController oppStandardController = new Apexpages.Standardcontroller(opp);
      OpptyRenewal_SubTypesController oppSubType = new OpptyRenewal_SubTypesController(oppStandardController);
      oppSubType.save();

      Test.StopTest();
    }
 // }
  
  public static testMethod void TestOpptyRenewalSubType2(){

    Profile p = [select id from Profile limit 1]; 
    User u1 = new user (Username = ' test11081987@hp.com', 
        alias='test', 
        LastName ='test',
        email='deepak.knmiet@hp.com',
        communityNickname='test342',
        TimeZoneSidKey='America/Los_Angeles',
        LocaleSidKey='en_US',
        EmailEncodingKey='ISO-8859-1',
        Region__c = 'U.S.',
        ProfileId=p.id,
        LanguageLocaleKey='en_US',
        Approver_Email_A__c='deepak.knmiet@hp.com',
        Email_Address__c = 'deepak.knmiet@hp.com',
        EmployeeNumber='1234',
        Legacy_Employee_Ref__c='3456',
        Adoption_Role_Type__c='Executive' );
    insert u1;

   // System.runAs(u1){
      Account a =  TestingSetupDataUtil.createAccount('testDemoAcc001','testDemoAcc@hp.com','Customer');

      Insert a;

      Opportunity opp= new Opportunity(Name='Demo Opp', CloseDate=date.parse('1/1/2020'), AccountId=a.id, StageName='01 - Understand Customer');

      Insert opp;
      
      Test.startTest();
      
      PageReference pr = Page.OpptyRenewal_SubTypes;
      pr.getParameters().put('id', opp.Id); 
      Test.setCurrentPage(pr);
      ApexPages.StandardController oppStandardController = new Apexpages.Standardcontroller(opp);
      OpptyRenewal_SubTypesController oppSubType = new OpptyRenewal_SubTypesController(oppStandardController);
      COTestClassUtility.OpptyRenewal_SubTypesControllerTestVar1 = true;
      oppSubType.save();

      Test.StopTest();
    //}
  }
}