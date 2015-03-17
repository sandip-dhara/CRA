/**********************************************************
 * Class Name: SRTDataFromSFDCControllerTest
 * Author: HP
 * Date: 5-Nov-2012 
 * Requirement # 
 * Description: This is a Test Class to test SRTDataFromSFDCController Class.
 ***********************************************************/

@isTest(SeeAllData=true)
public class SRTDataFromSFDCControllerTest{

  /**
   * @description: Test Method to Test the Class
   * @param: No Parameter Passed
   * 
   */
  public static testMethod void TestOpptyRenewalSubType(){

    Profile p = [SELECT Id FROM profile WHERE name='Sales Rep']; 
    User u1 = new user (Username = ' test@key.net', 
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

    //System.runAs(u1){
      Account a =  new Account(Name='Demo Account');

      Insert a;

      Opportunity opp= new Opportunity(Name='Demo Opp', CloseDate=date.parse('1/1/2020'), AccountId=a.id, StageName='01 - Understand Customer');

      Insert opp;
      
      /* Id SRTRecordTypeId=null;
      SRTRecordTypeId = RecordTypeIdHelper.getRecordTypeId ('support_request__c','Quote-to-Order-SRT');
      support_Request__c SRT_SR= new support_request__c(RecordTypeId=SRTRecordTypeId, Opportunity__c=opp.Id, Support_Type__c ='Quote-to-Order', Sub_Type__c ='SRT');
      Insert SRT_SR;
      SRT_SR = [select id, Support_Sub_Type__c,RecordTypeId,Support_Type__c,Opportunity__c,Sub_Type__c,Name  from support_request__c where id = :SRT_SR.Id];
      */
      
       Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('Event-Demo');
        Id recordTypeId = null;
        if(csRecord!=null){
            recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
        }
        Support_Request__c sRequest = TestingSetupDataUtil.createSupportRequest(opp.id,'Request description');
        if(recordTypeId !=null)
            sRequest.recordTypeId = recordTypeId;
        insert sRequest;
        
      Test.startTest();
      
      PageReference pr = Page.SRT_Data_From_SFDC;
      pr.getParameters().put('id', opp.Id); 
      Test.setCurrentPage(pr);
      ApexPages.StandardController supportRequestController= new Apexpages.Standardcontroller(sRequest);
      SRTDataFromSFDCController srtData = new SRTDataFromSFDCController(supportRequestController);

      Test.StopTest();
    //}
  }
}