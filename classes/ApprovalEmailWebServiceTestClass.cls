/**********************************************************
 * Class Name: ApprovalEmailWebServiceTestClass
 * Author: HP
 * Date: 10-Oct-2012 
 * Requirement # 
 * Description: This is a Test Class to test ApprovalEmailServices Class.
 ***********************************************************/

@isTest(seeAllData = true)
public class ApprovalEmailWebServiceTestClass {

    /**
     * @description: Test Method to Test the Class
     * @param: No Parameter Passed
     * 
     */
    public static testMethod void TestApproval(){

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
                Adoption_Role_Type__c='Executive');
        insert u1;
                
            System.runAs(u1){
            Messaging.InboundEmail email = new Messaging.InboundEmail();
            Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
            Account a =  new Account(Name='Demo Account');

            Insert a;
        
            //Opportunity opp= new Opportunity(Name='Demo Opp', CloseDate=date.parse('1/1/2020'), AccountId=a.id, StageName='01 - Understand Customer');
            Opportunity opp = TestingSetupDataUtil.createOpportunity(a.Id, a.Name, Date.today());
            
            Insert opp;
        
            Approval__c approval= new Approval__c(Opportunity__c=opp.Id, OwnerId=u1.id, Approval_Type__C='Outlier Discount Approval');
            Insert approval;

            Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf('my attachment text');
            attachment.fileName = 'textfile.txt';
            attachment.mimeTypeSubType = 'text/plain';

            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };

            email.subject = 'test';
            email.plainTextBody = 'Approval Id: '+approval.id+ 
            'Status: Approved Approver\'s Comments: Great';
            envelope.fromAddress = 'deepak.knmiet@hp.com';

            // setup controller object
            Test.startTest();
            ApprovalEmailWebService catcher = new ApprovalEmailWebService();
            catcher.handleInboundEmail(email, envelope);
            Test.StopTest();
       }
    }
}