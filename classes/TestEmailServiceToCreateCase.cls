/**********************************************************
 * Class Name: TestEmailServiceToCreateCase
 * Author: HP
 * Date:  
 * Requirement # 
 * Description: This is a Test Class to test EmailServiceToCreateCase class.
 ***********************************************************/

@isTest(seeAllData = true)
public class TestEmailServiceToCreateCase{

public static testMethod void TestEmailService() {
 
  // create a new email and envelope object
  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
  Messaging.InboundEmail email1 = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
  List<String> ccAdress = New List<String>();
  
  // setup the data for the case
  email.subject = 'Test class case';
  email.fromname = 'FirstName LastName';
  env.fromAddress = 'vinay.kumar2@email.com';
  email1.subject = 'Test class case1';
  email1.fromname = 'FirstName LastName';
  env1.fromAddress = 'vinay.kumar2@email.com';
  //List<CaseExternalSystemMapper__c> cm = [Select Id,Assign_to_Team__c, Classification__c, ExternalValue__c, Origin__c, Request_Type__c, SystemValue__c, BG__c, Country__c, Program_Type__c, Route_to_Market__c, Region__c, Time_zone__c, Work_Location__c FROM CaseExternalSystemMapper__c where Classification__c = 'CO EmailToCase']; 
  List<CaseExternalSystemMapper__c> cm = new List<CaseExternalSystemMapper__c>();
 //cm.Assign_to_Team__c = "Standard Assignment";
  //cm.Classification__c = "CO EmailToCase";
  cm.add(new CaseExternalSystemMapper__c(ExternalValue__c = 'cc-japan@28d30bf9mg2ptrox0k8oq7561p08al4nuu50orkuw1gah08b9u.j-2ihdqmay.j.apex.sandbox.salesforce.com', SystemValue__c = 'CO Case', Assign_to_Team__c = 'Standard Assignment', Classification__c = 'CO EmailToCase', Origin__c = 'Email', Request_Type__c = 'Customer Research', BG__c = 'TS', Country__c = 'United States', Route_to_Market__c = 'Direct', Region__c = 'AMS', Time_zone__c = '(GMT-08:00) Pacific Standard Time (America/Los_Angeles)', Work_Location__c = 'In Country'));
  cm.add(new CaseExternalSystemMapper__c(ExternalValue__c = 'cc-us-fo@8-32c12sphke2of7syshvl0okpzlkvg33qxwbbccnqhr2r0y6tdn.j-2ihdqmay.j.apex.sandbox.salesforce.com', SystemValue__c = 'CO Case',Assign_to_Team__c = 'Standard Assignment', Classification__c = 'CO EmailToCase', Origin__c = 'Email', Request_Type__c = 'Customer Research', BG__c = 'TS', Country__c = 'United States', Route_to_Market__c = 'Direct', Region__c = 'AMS', Time_zone__c = '(GMT-08:00) Pacific Standard Time (America/Los_Angeles)', Work_Location__c = 'In Country'));
  cm.add(new CaseExternalSystemMapper__c(ExternalValue__c = 'apj-crr-australia@iuw5llif9uyl02o3oib2393ek552r1qn715g2gz073ics7x0w.j-2ihdqmay.j.apex.sandbox.salesforce.com', SystemValue__c = 'CO Case', Assign_to_Team__c = 'Standard Assignment', Classification__c = 'CO EmailToCase', Origin__c = 'Email', Request_Type__c = 'Customer Research', BG__c = 'TS', Country__c = 'United States', Route_to_Market__c = 'Direct', Region__c = 'AMS', Time_zone__c = '(GMT-08:00) Pacific Standard Time (America/Los_Angeles)', Work_Location__c = 'In Country'));
  cm.add(new CaseExternalSystemMapper__c(ExternalValue__c = 'apj-crr-japan@7xb5rz80368dfmk55c9br9q45tcw56oy04fwlp2n0an7khgsz.j-2ihdqmay.j.apex.sandbox.salesforce.com', SystemValue__c = 'CO Case', Assign_to_Team__c = 'Standard Assignment', Classification__c = 'CO EmailToCase', Origin__c = 'Email', Request_Type__c = 'Customer Research', BG__c = 'TS', Country__c = 'United States', Route_to_Market__c = 'Direct', Region__c = 'AMS', Time_zone__c = '(GMT-08:00) Pacific Standard Time (America/Los_Angeles)', Work_Location__c = 'In Country'));
 
  //cm.Origin__c = "Email";
  //cm.Request_Type__c = " Orders";
  //cm.BG__c = "TS";
 // cm.Country__c = "United States";
  //cm.Route_to_Market__c = "Direct";
  //cm.Region__c = "AMS";
  //cm.Time_zone__c = "(GMT-08:00) Pacific Standard Time (America/Los_Angeles)";
  //cm.Work_Location__c = "In Country";
    Insert cm;
  env.toAddress = cm[0].ExternalValue__c;
  ccAdress.add(cm[2].ExternalValue__c);
  ccAdress.add(cm[3].ExternalValue__c);
  email.ccAddresses = ccAdress;
  env1.toAddress = cm[1].ExternalValue__c;
 
  // add an attachment
  Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
  attachment.body = blob.valueOf('my attachment text');
  attachment.fileName = 'textfile.eml';
  Messaging.InboundEmail.BinaryAttachment attachment2 = new Messaging.InboundEmail.BinaryAttachment();
  attachment2.body = blob.valueOf('my attachment text');
  attachment2.fileName = 'textfile2.eml';
  Messaging.InboundEmail.TextAttachment attachment1 = new Messaging.InboundEmail.TextAttachment();
  attachment1.body = 'my attachment text';
  attachment1.fileName = 'textfile';
  attachment.mimeTypeSubType = 'message/rfc822';
  
  email.binaryAttachments =
    new Messaging.inboundEmail.BinaryAttachment[] { attachment };
    email1.binaryAttachments =
    new Messaging.inboundEmail.BinaryAttachment[] { attachment2 };
  email.textAttachments =
    new Messaging.inboundEmail.textAttachment[] { attachment1 };  
 
  // call the email service class and test it with the data in the testMethod
   EmailServiceToCreateCase emailProcess = new  EmailServiceToCreateCase();
  emailProcess.handleInboundEmail(email, env);
  EmailServiceToCreateCase emailProcess1 = new  EmailServiceToCreateCase();
  emailProcess.handleInboundEmail(email1, env1);
 
  // query for the case the email service created
  Case testcase = [select id, Subject, status from case
    where subject = 'Test class case'];
 
  System.assertEquals(testcase.subject,'Test class case');
  System.assertEquals(testcase.status,'New');
   
  // find the attachment
  //List<Attachment> a = [select name from attachment where parentId = :testcase.id];
 
  //System.assertEquals(a[0].name,'textfile.eml');
 
}
}