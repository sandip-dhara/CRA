/**********************************************************
 * Class Name: CSIF_SRT_EmailServiceTest
 * Author: HP
 * Date: 23-Oct-2012 
 * Requirement # 
 * Description: This is a Test Class to test CSIF_SRT_EmailService Class.
 ***********************************************************/

@isTest(SeeAllData=true)

public class CSIF_SRT_EmailServiceTest {

  /**
   * @description: Test Method to Test the Class
   * @param: No Parameter Passed
   * 
   */
  public static testMethod void TestSupport_Request(){
      Profile p = [SELECT Id FROM profile WHERE name='IT Administrator']; 
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
                Business_Group__c='SW',
                Adoption_Role_Type__c='Executive');
      insert u1;
      
      System.runAs(u1){
     
          Messaging.InboundEmail email = new Messaging.InboundEmail();
          Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
          
          Messaging.InboundEmail email1 = new Messaging.InboundEmail();
          Messaging.InboundEnvelope envelope1 = new Messaging.InboundEnvelope();
          
          Messaging.InboundEmail email2 = new Messaging.InboundEmail();
          Messaging.InboundEnvelope envelope2 = new Messaging.InboundEnvelope();
          
          Messaging.InboundEmail email3 = new Messaging.InboundEmail();
          Messaging.InboundEnvelope envelope3 = new Messaging.InboundEnvelope();
          
          Messaging.InboundEmail email4 = new Messaging.InboundEmail();
          Messaging.InboundEnvelope envelope4 = new Messaging.InboundEnvelope();
          
          Messaging.InboundEmail email5 = new Messaging.InboundEmail();
          Messaging.InboundEnvelope envelope5 = new Messaging.InboundEnvelope();
          
          //Creating Test Data
          
          Id CSIFRecordTypeId=null;
          CSIFRecordTypeId = RecordTypeIdHelper.getRecordTypeId ('support_request__c','Quote-to-Order-CSIF');
          
          Id SRTRecordTypeId=null;
          SRTRecordTypeId = RecordTypeIdHelper.getRecordTypeId ('support_request__c','Quote-to-Order-SRT');
          
          Id EnggResRecordTypeId=null;
          EnggResRecordTypeId = RecordTypeIdHelper.getRecordTypeId ('support_request__c','Functional Support-Engineer Resource');

          //Creating Test Account
          Account a =  new Account(Name='Demo Account');
          {
          a.ShippingCountry = 'India';  
          a.Regions__c = 'Asia Pacific';
          }
          Insert a;
          
          //Creating Test Opportunity 
          opportunity opp = TestingSetupDataUtil.createOpportunity(a.Id,'Opty99ZZ_952PM',System.Today()+30);  
          Insert opp;
          
          //creating CSIF Support Request  
          support_Request__c CSIF_SR= new support_request__c(RecordTypeId = CSIFRecordTypeId, Support_Type__c ='Quote-to-Order', Opportunity__c=opp.Id,Sub_Type__c ='CSIF');
          Insert CSIF_SR;
          CSIF_SR = [select id, Support_Sub_Type__c,RecordTypeId,Support_Type__c,Opportunity__c,Sub_Type__c,Name  from support_request__c where id = :CSIF_SR.Id];

          //String query = [select id, Support_Sub_Type__c from support_request__c where id = :CSIF_SR.Id].Support_Sub_Type__c;

          //creating SRT Support Request
          support_Request__c SRT_SR= new support_request__c(RecordTypeId=SRTRecordTypeId, Opportunity__c=opp.Id, Support_Type__c ='Quote-to-Order', Sub_Type__c ='SRT');
          Insert SRT_SR;
          SRT_SR = [select id, Support_Sub_Type__c,RecordTypeId,Support_Type__c,Opportunity__c,Sub_Type__c,Name  from support_request__c where id = :SRT_SR.Id];
          
          //Creating Premier Resource Support Request
          support_Request__c EnggRes_SR= new support_request__c(RecordTypeId=EnggResRecordTypeId, Opportunity__c=opp.Id, Routing_Region__c='EMEA', Routing_Sub_Region__c='UK & I',BG__c='SW', Routing_Country__c='United Kingdom', Support_Type__c ='Functional Support', Sub_Type__c ='Premier Resource');
          Insert EnggRes_SR;
          EnggRes_SR = [select id, Support_Sub_Type__c,RecordTypeId,Support_Type__c,Opportunity__c,Sub_Type__c,Name  from support_request__c where id = :EnggRes_SR.Id]; 
    
          //Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
          //attachment.body = blob.valueOf('my attachment text');
          //attachment.fileName = 'textfile.txt';
          //attachment.mimeTypeSubType = 'text/plain';
    
          //email.binaryAttachments =
           // new Messaging.inboundEmail.BinaryAttachment[] { attachment };
    
          email.subject = 'test';
          email.plainTextBody = 'SFDC HP Opportunity Id: '+opp.id+ 
          'SFDC Support Request Number: '+CSIF_SR.name+
          'Status: '+'Submitted'+
          'CSIF Id: 12345678912'+
          '/*-----------------------------------------------*/'+
          'Notes to Sales Rep: test'+
          '/*------------------------------------------------*/';
          envelope.fromAddress = 'deepak.knmiet@hp.com';
          
                  
          email2.subject = 'test';
          email2.plainTextBody = 'SFDC HP Opportunity Id: '+opp.id+ 
          'SFDC Support Request Number: '+CSIF_SR.name+
          'Status: '+'Submitted'+
          '/*-----------------------------------------------*/'+
          'Notes to Sales Rep: test'+
          '/*------------------------------------------------*/';
          envelope2.fromAddress = 'deepak.knmiet@hp.com';
          
          email1.subject = 'test';
          email1.plainTextBody = 'SFDC HP Opportunity Id: '+opp.id+ 
          'SFDC Support Request Number: '+SRT_SR.name+
          'Status: '+'Submitted'+
          'SRT Id: 1234567891'+
          '/*-----------------------------------------------*/'+
          'Notes to Sales Rep: test'+
          '/*------------------------------------------------*/';
          envelope1.fromAddress = 'deepak.knmiet@hp.com';

          
          email3.subject = 'test';
          email3.plainTextBody = 'SFDC HP Opportunity Id: '+opp.id+ 
          'SFDC Support Request Number: '+SRT_SR.name+
          'Status: '+'Submitted'+
          '/*-----------------------------------------------*/'+
          'Notes to Sales Rep: test'+
          '/*------------------------------------------------*/';
          envelope3.fromAddress = 'deepak.knmiet@hp.com';
          
          email4.subject = 'test';
          email4.plainTextBody = 'SFDC HP Opportunity Id: '+opp.id+ 
          'SFDC Support Request Number: '+EnggRes_SR.name+
          'Status: '+'Submitted'+
          '/*-----------------------------------------------*/'+
          'Delivery Manager: Deepak'+ 'Type of Resource Assigned: ELM'+ 'Comments: Good'+
          '/*------------------------------------------------*/'+
          '/*-----------------------------------------------*/'+
          'Resource Assigned Date: 12 October'+ 'Premier Routing Setup: Yes'+ 'ESM Assigned: Yes'+ 'TAM Assigned: Yes'+ 'NCRE Assigned: Yes'+ 'NASE Assigned: Yes'+
          '/*------------------------------------------------*/';
          envelope4.fromAddress = 'deepak.knmiet@hp.com';
    
    
          // setup controller object
          Test.startTest();
          CSIF_SRT_EmailService catcher = new CSIF_SRT_EmailService();
          catcher.handleInboundEmail(email, envelope);
          catcher.handleInboundEmail(email1, envelope1);
          catcher.handleInboundEmail(email2, envelope2);
          catcher.handleInboundEmail(email3, envelope3);
          catcher.handleInboundEmail(email4, envelope4);
          Test.StopTest();
      }
    
  }
}