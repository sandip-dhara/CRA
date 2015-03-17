@isTest
public class ContactCenter_ConvertToLeadTest{

 static testMethod void ContactCenter_ConvertToLeadTestMethod(){
  Account a = new Account();
  a.Name = 'Test Account';
  a.Source_System_Account_ID__c = 'Test Sys Acct Id';
  insert a;
  
  Lead l= new Lead();
  l.LastName = 'test Last Name';
  l.Company = 'test company';
  l.Status = 'test status';
  l.CurrencyIsoCode = 'USD';
  l.Phone = '999999999';
  l.Email = 'test@gmail.com';
  l.Country = 'India';
  l.Account_Name__c = a.Id;
  insert l;
  
  ContactCenter_ConvertToLead.IsDuplicate('', '', 'l.Account_Name__c');
  ContactCenter_ConvertToLead.convertLead(l.Id);
  ContactCenter_ConvertToLead.convertLead(null);
 } //end of testMethod

} //end of test class