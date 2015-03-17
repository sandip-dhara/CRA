/**********************************************************
* Class Name: DealReg_CustomerSearchControllerTest
* Author: HP
* Date: 05-OCT-2012 
* Description: This class does the test coverage for DealReg_CustomerSearchController class. 
***********************************************************/

@isTest(SeeAllData=true)
private class DealReg_CustomerSearchControllerTest{
     public String mdcpId='12345';
     
     /*
     * @Description: Test Method to test search method of DealReg_CustomerSearchController class.
     * 
     */
    @isTest static void testSearch() {
    
      Profile internalProfile = [SELECT Id FROM Profile Limit 1];    
       UserRole testRole=[SELECT id from UserRole where portalrole =null  limit 1];
    User testUser = new User(ProfileId = internalProfile.id,
                             LastName = 'Test13', 
                             FirstName = 'Test13', 
                             Username = '090testing13@test.com', 
                             Alias='0test13', 
                             CommunityNickname='090test Approve13', 
                             Email='test13@hp.com',
                             TimeZoneSidKey='America/Chicago',
                             EmailEncodingKey='ISO-8859-1', 
                             LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US',
                             IsActive=True,
                             Email_Address__c='test13@hp.com',
                             EmployeeNumber='653486625',
                             Legacy_Employee_Ref__c='14875465',
                             UserRoleId =testRole.id,
                             Adoption_Role_Type__c = 'IT'
                            );
    insert testUser; 
    
    Account newAccount=null;
    Contact contact1=null;
    Recordtype recordId=null;
    Account newAccount1=null;
    
    List<Account> aList=new List<Account>();
    
       
    System.runAs(testUser){
    
     recordId=[Select Id,Name from recordtype where Name='Partner'];
          newAccount=new Account(Name='TestAccountForTestClass',RecordTypeId=recordId.Id,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
       insert newAccount;
       
    
       contact1 = new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccount.Id,Email = System.now().millisecond() + 'test@hp.com');
       insert contact1;
    }
   
       Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' Limit 1];
       User portalUser = new User(ProfileId = portalProfile.id,ContactId=contact1.Id,LastName = 'Test1', FirstName = 'Test1', Username = '0testing4567@Hp.com', Alias='9test1', CommunityNickname='0test Approve1', Email='test1@Hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1@HP.com',EmployeeNumber='65348661',Legacy_Employee_Ref__c='01487547');
       Insert portalUser ;
       
       System.runas(portalUser){
            
       
        ApexPages.StandardController controller;
        //Creating object for DealReg_CustomerSearchController class
        DealReg_CustomerSearchController dealRegCustSearchObj=new DealReg_CustomerSearchController(controller);
             Test.setMock(WebServiceMock.class, new DealReg_CustomerSearchControllerImpl());

        dealRegCustSearchObj.search();
        dealRegCustSearchObj.searchKey='test';
        dealRegCustSearchObj.searchCountry='India';
        dealRegCustSearchObj.searchCity='Bangalore';
        dealRegCustSearchObj.search();
        dealRegCustSearchObj.searchKey='*';
        dealRegCustSearchObj.searchCountry='India';
        dealRegCustSearchObj.searchCity='Bangalore';
        dealRegCustSearchObj.search();
        dealRegCustSearchObj.searchKey='t';
        dealRegCustSearchObj.searchCountry='India';
        dealRegCustSearchObj.searchCity='Bangalore';
        dealRegCustSearchObj.search();
        dealRegCustSearchObj.searchKey='test';
        dealRegCustSearchObj.searchCountry='India';
        dealRegCustSearchObj.searchCity='';
        dealRegCustSearchObj.search(); 
        dealRegCustSearchObj.searchKey='test';
        dealRegCustSearchObj.searchCountry='';
        dealRegCustSearchObj.searchCity='Bangalore';
        dealRegCustSearchObj.search();
        dealRegCustSearchObj.searchKey='';
        dealRegCustSearchObj.searchCountry='India';
        dealRegCustSearchObj.searchCity='Bangalore';
        dealRegCustSearchObj.search();  
        dealRegCustSearchObj.searchKey='test';
        dealRegCustSearchObj.searchCountry='';
        dealRegCustSearchObj.searchCity='';
        dealRegCustSearchObj.search(); 
        dealRegCustSearchObj.searchKey='';
        dealRegCustSearchObj.searchCountry='';
        dealRegCustSearchObj.searchCity='';
        dealRegCustSearchObj.search(); 
        dealRegCustSearchObj.searchKey='';
        dealRegCustSearchObj.searchCountry='India';
        dealRegCustSearchObj.searchCity='';
        dealRegCustSearchObj.search();
        dealRegCustSearchObj.searchKey='';
        dealRegCustSearchObj.searchCountry='';
        dealRegCustSearchObj.searchCity='Bangalore';
        dealRegCustSearchObj.search(); 
        
        dealRegCustSearchObj.isMdcpOrTibcoIsRunning='True';
        dealRegCustSearchObj.isSubscribedFlagCheck='ture';
        List<Account> results=null;
        
        dealRegCustSearchObj.getAccounts();
        dealRegCustSearchObj.searchResults =DealReg_AccountSearchUtil.runSearch('*','India','',results,100,100);
      
        dealRegCustSearchObj.searchKey='test';
        dealRegCustSearchObj.getAccounts();
             //Creating new account record for testing             
             dealRegCustSearchObj.name='TestAccount1234523';
             dealRegCustSearchObj.shippingStreet='TestStreet';
             dealRegCustSearchObj.shippingCity='TestCity';
             dealRegCustSearchObj.shippingState='TestState';
             dealRegCustSearchObj.shippingPostalCode='TestPostalCode';
             dealRegCustSearchObj.shippingCountry ='India' ; 
         
            // dealRegCustSearchObj.
        dealRegCustSearchObj.saveAccount();        
        //dealRegCustSearchObj.getFormTag();
        //dealRegCustSearchObj.getTextBox();
        dealRegCustSearchObj.name='';
        dealRegCustSearchObj.saveAccount();  
        
      
        dealRegCustSearchObj.mdcpId='123349';
       dealRegCustSearchObj.mdcpSiteId='1238';
        dealRegCustSearchObj.getSortDirection();
        dealRegCustSearchObj.setSortDirection('ASC');
       
        dealRegCustSearchObj.isMdcpOrTibcoIsRunning='True';

       // dealRegCustSearchObj.sortColumn();

         newAccount=new Account(Name='TestAccountForTestClass',RecordTypeId=recordId.Id,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity',MDCP_Organization_ID__c='123349',Mdcp_SiteId__c='1238');  
         newAccount1=new Account(Name='TestAccountForTestClass1',RecordTypeId=recordId.Id,ShippingCountry='India',ShippingPostalCode='23456451',ShippingState='Karnataka',ShippingStreet='Ecity1',MDCP_Organization_ID__c='12334',Mdcp_SiteId__c='123');
       
       
       aList.add(newAccount);
       aList.add(newAccount1);
       
     dealRegCustSearchObj.searchResults = aList;//DealReg_AccountSearchUtil.runSearch('*','India','',results,100,100);
        
      
       
      //  dealRegCustSearchObj.isSubscribedFlag(); 
              
        dealRegCustSearchObj.mdcpId='123349';
       dealRegCustSearchObj.mdcpSiteId='1238';
        dealRegCustSearchObj.isSubscribedFlagCheck='True';  
        dealRegCustSearchObj.isSubscribedFlag(); 
dealRegCustSearchObj.isSubscribedFlagCheck='False';
dealRegCustSearchObj.isSubscribedFlag();


          
        }  
    }
}