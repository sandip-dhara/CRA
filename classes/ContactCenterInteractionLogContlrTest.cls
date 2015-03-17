@isTest
public class ContactCenterInteractionLogContlrTest{
 
 /*static testMethod void ContactCenterInteractionLogContlrTestMethod()
 {
  Task t1 = new Task();
  t1.Subject = 'Call';
  t1.Status = 'Not Started';
  t1.Type = 'Outbound Call';
  
  Lead l1= new Lead();
  l1.LastName = 'test Last Name';
  l1.Company = 'test company';
  l1.Status = 'test status';
  l1.CurrencyIsoCode = 'USD';
  l1.Phone ='888888888';
  insert l1;
  
  ContactCenterInteractionLogController contCenIntLog1 = new ContactCenterInteractionLogController(new ApexPages.StandardController(t1));
  contCenIntLog1.objectId = l1.Id;

  //contCenIntLog1.save();
  //  System.debug('contCenIntLog test method1 end');
  } //end of test method1 */
  
  static testMethod void ContactCenterInteractionLogContlrTestMethod2()
  {
   Task t2 = new Task();
   t2.Subject = 'Call';
   t2.Status = 'Not Started';
   t2.Type = 'Outbound Call';
  
   Lead l2= new Lead();
   l2.LastName = 'test Last Name';
   l2.Company = 'test company';
   l2.Status = 'test status';
   l2.CurrencyIsoCode = 'USD';
   l2.Phone ='888888888';
   insert l2;
  
   ContactCenterInteractionLogController contCenIntLog2 = new ContactCenterInteractionLogController(new ApexPages.StandardController(t2));
   contCenIntLog2.objectId = l2.Id;
  
   contCenIntLog2.saveAndNew();
     System.debug('contCenIntLog test method2 end');
  } //end of test method2

 /*static testMethod void ContactCenterInteractionLogContlrTestMethod3()
 {
  Task t3 = new Task();
  t3.Subject = 'Call';
  t3.Status = 'Not Started';
  t3.Type = 'Outbound Call';

  Account a3 = new Account();
  a3.Name = 'Test Account';
  a3.Source_System_Account_ID__c = 'Test SSA Id';
  insert a3;
  
  ContactCenterInteractionLogController contCenIntLog3 = new ContactCenterInteractionLogController(new ApexPages.StandardController(t3));
  contCenIntLog3.objectId = a3.Id;

  contCenIntLog3.save();
    System.debug('contCenIntLog test method3 end');
 } //end of test method3 
 */

 static testMethod void ContactCenterInteractionLogContlrTestMethod4()
 {
  Task t4 = new Task();
  t4.Subject = 'Call';
  t4.Status = 'Not Started';
  t4.Type = 'Outbound Call';

  Account a4 = new Account();
  a4.Name = 'Test Account';
  a4.Source_System_Account_ID__c = 'Test SSA Id';
  insert a4;
  
  ContactCenterInteractionLogController contCenIntLog4 = new ContactCenterInteractionLogController(new ApexPages.StandardController(t4));
  contCenIntLog4.objectId = a4.Id;
  
  contCenIntLog4.saveAndNew();
  System.debug('contCenIntLog test method4 end');
 } //end of test method4
}//end of test class