/**********************************************************
* Class Name: DealRegOpptyPartnerAfterInsertTest
* Author: HP 
* Date: 25-Oct-2012 
* Description: This class contains the test code coverage for the class "DealRegOpptyPartnerAfterInsert"
***********************************************************/
@isTest(seeAllData = true)
Private class DealRegOpptyPartnerAfterInsertTest{ 
static testMethod void testDealRegOpptyPartnerAfterInsert(){
               Id recordId=RecordTypeIdHelper.getRecordTypeId('Account','Partner');
               Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' Limit 1];
               Profile internalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%IT Administrator%' Limit 1];
               UserRole testRole=[SELECT id from UserRole where portalrole =null  limit 1];
               User testUser = new User(ProfileId = internalProfile.id,
                                        LastName = 'Test13', 
                                        FirstName = 'Test13', 
                                        Username = 'testing13@hp.com', 
                                        Alias='test13', 
                                        CommunityNickname='test Approve13', 
                                        Email='9test13@hp.com',
                                        TimeZoneSidKey='America/Chicago',
                                        EmailEncodingKey='ISO-8859-1', 
                                        LanguageLocaleKey='en_US', 
                                        LocaleSidKey='en_US',
                                        IsActive=True,
                                        Email_Address__c='9test13@hp.com',
                                        EmployeeNumber='653486625',
                                        Legacy_Employee_Ref__c='14875465',
                                        UserRoleId =testRole.id,
                                        Adoption_Role_Type__c = 'IT'
                                        );
                insert testUser;  
       Account newAccount=null;
       Contact newContact=null;
                System.RunAs(testUser){
                        newAccount=new Account(Name='TestAccountForTestClass',
                                                       RecordTypeId=recordId,
                                                       ShippingCountry='India',
                                                       ShippingPostalCode='2345645',
                                                       ShippingState='Karnataka',
                                                       ShippingStreet='Ecity',
                                                       ownerid=testUser.id);
                       insert newAccount;

                        newContact = new Contact(FirstName = 'Test',
                                                 Lastname = 'McTesty',
                                                 AccountId = newAccount.Id,
                                                 Email = System.now().millisecond() + '9test@hp.com'
                                                 );
                       insert newContact;
                }        
                User portalUser = new User(ProfileId = portalProfile.id,
                                               ContactId=newContact.Id,
                                               LastName = 'Test2', 
                                               FirstName = 'Test2', 
                                               Username = '2testing2@hp.com', 
                                               Alias='test2', 
                                               CommunityNickname='test Approve2', 
                                               Email='9test2@hp.com',
                                               TimeZoneSidKey='America/Chicago',
                                               EmailEncodingKey='ISO-8859-1', 
                                               LanguageLocaleKey='en_US', 
                                               LocaleSidKey='en_US',
                                               IsActive=True,
                                               Email_Address__c='9test2@hp.com',
                                               EmployeeNumber='65348662',
                                               Legacy_Employee_Ref__c='1487546'
                                               );
                insert portalUser;
               Id recordId1=RecordTypeIdHelper.getRecordTypeId('Account','Customer');
       System.runas(portalUser ){     
       Account testAccount=new Account(Name='TestAccountForTestClass',ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity',RecordTypeId=recordId1);                                    
       Insert testAccount;
       Opportunity newOppty=new Opportunity (AccountId = testAccount.Id,Name='Test Opty12',closedate=Date.today(),StageName='01 - Understand Customer');
       Insert newOppty;       
       }     
       Account  newAccount1 =null;
       Contact newContact1=null;
       System.RunAs(testUser){
         newAccount1=new Account(Name='TestAccountForTestClass1',Partner_Type__c='Channel Partner',RecordTypeId=recordId,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
       Insert newAccount1;          
        newContact1= new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccount1.Id,Email =  '9test1@hp.com');
       Insert newContact1;
       }
       User portalUser1 = new User(ProfileId = portalProfile.id,ContactId=newContact1.Id,LastName = 'Test2', FirstName = 'Test2', Username = 'testing456@hp.com', Alias='test2', CommunityNickname='testApprove1', Email='29test2@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='29test2@hp.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='1487542');
       Insert portalUser1 ;
           
       System.runas(portalUser1 ){     
       Account newAccount2=new Account(Name='TestAccountForTestClass',ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity',RecordTypeId=recordId1);
       Insert newAccount2;
    
      Opportunity newOppty1=new Opportunity (AccountId = newAccount2.Id,Name='Test Opty12',closedate=Date.today(),StageName='01 - Understand Customer');
      Insert newOppty1;
       }
       System.RunAs(testUser){
      Account newAccount3=new Account(Name='TestAccountForTestClass',ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');                                    
      Insert newAccount3;
    
      Opportunity newOppty2=new Opportunity (AccountId = newAccount3.Id,Name='Test Opty12',closedate=Date.today(),StageName='01 - Understand Customer');
      Insert newOppty2; 
       }   
       //Alliance partner coverage
       Account  newAccount11 =null;
       Contact newContact11=null;
       System.RunAs(testUser){
         newAccount11=new Account(Name='TestAccountForTestClass1',Partner_Type__c='Alliance Partner',RecordTypeId=recordId,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
       Insert newAccount11;
                    
        newContact11= new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccount11.Id,Email =  '9test1@hp.com');
       Insert newContact11;
       }
       User portalUser11 = new User(ProfileId = portalProfile.id,ContactId=newContact11.Id,LastName = '1Test2', FirstName = '1Test2', Username = '1testing456@hp.com', Alias='1test2', CommunityNickname='1testApprove1', Email='39test2@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='39test2@hp.com',EmployeeNumber='6534869',Legacy_Employee_Ref__c='1487556');
       Insert portalUser11 ;
           
       System.runas(portalUser11 ){     
       Account newAccount21=new Account(Name='TestAccountForTestClass',ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity',RecordTypeId=recordId1);
       Insert newAccount21;
    
      Opportunity newOppty11=new Opportunity (AccountId = newAccount21.Id,Name='Test Opty12',closedate=Date.today(),StageName='01 - Understand Customer');
      Insert newOppty11;
       }   
}
}