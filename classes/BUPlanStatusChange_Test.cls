@isTest
public class BUPlanStatusChange_Test
{
    static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
        Business_Unit_Plan__c bup = new Business_Unit_Plan__c (Account_Plan__c = acp.id , Name ='Test',Plan_Status__c = 'In Progress');
        insert bup;
        BU_plan_Scorecard__c  score = new BU_plan_Scorecard__c (Business_Unit_Plan__c =bup.id );
         insert score;
      
       // bup.Plan_Status__c = 'Submitted – Pending Review';
       // Update bup;
         Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
       Profile p1 = [SELECT Id FROM Profile WHERE Name='Sales Rep']; 
       User u = new User(Alias = 'standt', Email='standarduser@hp.com', 
       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
       LocaleSidKey='en_US', ProfileId = p.Id,Legacy_Employee_Ref__c='********',Email_Address__c ='qwert@hp.com',Business_Group__c ='IPG',
       TimeZoneSidKey='America/Los_Angeles', UserName='standarduser01a@testorg.com',Adoption_Role_Type__c='Account Executive'); 
       insert u; 
        
        BU_Plan_Approval__c bpr  = new BU_Plan_Approval__c( Approver__c = u.id , Plan_Status__c = 'Approved', Business_Unit_Plan__c = bup.id);
         try{

    insert bpr;

} catch (Exception e){
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
       } 
    }
}