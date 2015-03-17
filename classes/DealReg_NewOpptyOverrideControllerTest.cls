/**********************************************************
* Class Name: DealRegNewOpptyOverideTest
* Author: HP
* Date: 05-OCT-2012 
* Description: This class does the test coverage for DealRegNewOpptyOveride class. 
***********************************************************/
    
@isTest
private class DealReg_NewOpptyOverrideControllerTest{
    
    
       /*
        * @Description: Test Method to test methods of DealRegNewOpptyOveride class.
        * 
        */
        public static testMethod void testOpptyOverride() {
               //Creating object
               ApexPages.StandardController controller;
               DealReg_NewOpptyOverrideController dealRegNewOpptyObj=new DealReg_NewOpptyOverrideController(controller);
               Contact testContact=null;
    
               dealRegNewOpptyObj.doCancel();
     
               ApexPages.currentPage().getParameters().put('sfdc.override','1');
               ApexPages.currentPage().getParameters().put('save_new','1');
               dealRegNewOpptyObj.redirect();  
               Id recordId=RecordTypeIdHelper.getRecordTypeId('Account','Partner');
               Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' Limit 1];
               Profile internalProfile = [SELECT Id FROM Profile  Limit 1];
               UserRole testRole=[SELECT id from UserRole where portalrole =null  limit 1];
               User testUser = new User(ProfileId = internalProfile.id,
                                        LastName = 'Test13', 
                                        FirstName = 'Test13', 
                                        Username = 'testing13@test.com', 
                                        Alias='test13', 
                                        CommunityNickname='test Approve13', 
                                        Email='10test13@hp.com',
                                        TimeZoneSidKey='America/Chicago',
                                        EmailEncodingKey='ISO-8859-1', 
                                        LanguageLocaleKey='en_US', 
                                        LocaleSidKey='en_US',
                                        IsActive=True,
                                        Email_Address__c='10test13@hp.com',
                                        EmployeeNumber='653486625',
                                        Legacy_Employee_Ref__c='14875465',
                                        Adoption_Role_Type__c= 'IT',
                                        UserRoleId =testRole.id
                                        );
                insert testUser;  
       
                System.RunAs(testUser){
                       Account testAccount=new Account(Name='TestAccountForTestClass',
                                                       RecordTypeId=recordId,
                                                       ShippingCountry='India',
                                                       ShippingPostalCode='2345645',
                                                       ShippingState='Karnataka',
                                                       ShippingStreet='Ecity',
                                                       ownerid=testUser.id);
                       insert testAccount;

                       testContact = new Contact(FirstName = 'Test',
                                                 Lastname = 'McTesty',
                                                 AccountId = testAccount.Id,
                                                 Email = System.now().millisecond() + '10test@hp.com'
                                                 );
                       insert testContact;
                }        
                User testPortalUser = new User(ProfileId = portalProfile.id,
                                               ContactId=testContact.Id,
                                               LastName = 'Test2', 
                                               FirstName = 'Test2', 
                                               Username = '2testing2@test.com', 
                                               Alias='test2', 
                                               CommunityNickname='test Approve2', 
                                               Email='10test2@hp.com',
                                               TimeZoneSidKey='America/Chicago',
                                               EmailEncodingKey='ISO-8859-1', 
                                               LanguageLocaleKey='en_US', 
                                               LocaleSidKey='en_US',
                                               IsActive=True,
                                               Email_Address__c='10test2@hp.com',
                                               EmployeeNumber='65348662',
                                               Legacy_Employee_Ref__c='1487546'
                                               );
                insert testPortalUser ;
                system.debug('++++++'+testPortalUser.Partner_account_ID__c);
                dealRegNewOpptyObj.partnerUser=testPortalUser;  
                System.RunAs(dealRegNewOpptyObj.partnerUser){
                       dealRegNewOpptyObj.redirect();
                }  
        }

}