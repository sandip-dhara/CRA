@isTest
public class PlanStatusChange_Test
{
    static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
        ABP_Scorecard__c  score = new ABP_Scorecard__c (Account_Plan__c =acp.id );
         insert score;
         
           Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
       Profile p1 = [SELECT Id FROM Profile WHERE Name='Sales Rep']; 
       User u = new User(Alias = 'standt', Email='standarduser@hp.com', 
       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
       LocaleSidKey='en_US', ProfileId = p.Id,Legacy_Employee_Ref__c='********',Email_Address__c ='qwert@hp.com',Business_Group__c ='IPG',
       TimeZoneSidKey='America/Los_Angeles', UserName='standarduser01a@testorg.com',Adoption_Role_Type__c='Account Executive'); 
       insert u;  
       
     //   List<User> u = [Select id, Email from User where Email = 'kavin.arasu@hp.com' limit 1];
        ABP_Approval__c apr  = new ABP_Approval__c(Approver__c = u.id, Account_Plan__c = acp.id,Plan_Status__c = 'Approved');
       try{

    insert apr;
            }
           catch (Exception e){
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                              }
    }
}