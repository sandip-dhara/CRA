/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=true)
private class SalesTerrUserAssignmentTest {

    static testMethod void userAssignmentTest() {
        
        test.startTest();
        
        List<Sales_Territory__c> stUpdateList = new List<Sales_Territory__c>();
        List<Sales_Territory_User_Assignment__c> stuaList = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> stuaUpdateList = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> stuaUpdateList2 = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> stuaUpdateList3 = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> stuaUpdateList4 = new List<Sales_Territory_User_Assignment__c>();
        
        Set<Id> gmToDelete = new Set<Id>();
        
        Sales_Territory__c st = new Sales_Territory__c (Name='test ST', MyComp_Sales_Territory_Name__c='test ST', IsActive__c=true, IsConfidential__c=true);       
        insert st;
        
        List<User> uObjList = [Select Id from User where IsActive=true limit 5];
        
        //Create Sales Terr User Assignment Records
        for(Integer i=0;i<5;i++){
            Sales_Territory_User_Assignment__c stua = new Sales_Territory_User_Assignment__c(User__c = uObjList[i].Id, Sales_Territory__c = st.Id, IsActive__c=true, 
                                                                                             Add_to_Account_Team__c = true, Account_Team_Role__c = 'Alliance Sales');
            stuaList.add(stua);
        }
        insert stuaList;
        
        for(Sales_Territory_User_Assignment__c stuaObj : stuaList){
            stuaObj.IsActive__c = false;
            stuaObj.Add_to_Account_Team__c = false;
            stuaObj.Account_Team_Role__c = null;
            stuaUpdateList.add(stuaObj);
        }
        update stuaUpdateList;
            
        for(Sales_Territory_User_Assignment__c stuaObj : stuaUpdateList){
            stuaObj.IsActive__c = true;
            stuaObj.Add_to_Account_Team__c = true;
            stuaObj.Account_Team_Role__c = 'Alliance Sales';
            stuaUpdateList2.add(stuaObj);
        }
        update stuaUpdateList2;
        
        //TM:Debmalya:R3:Add add to account team update conditions:Start
        for(Sales_Territory_User_Assignment__c stuaObj : stuaList){
            stuaObj.Add_to_Account_Team__c = false;
            stuaObj.Account_Team_Role__c = null;
            stuaUpdateList3.add(stuaObj);
        }
        update stuaUpdateList3;
        
        for(Sales_Territory_User_Assignment__c stuaObj : stuaList){
            stuaObj.Add_to_Account_Team__c = true;
            stuaObj.Account_Team_Role__c = 'Alliance Sales';
            stuaUpdateList4.add(stuaObj);
        }
        update stuaUpdateList4;
        
        //TM:Debmalya:R3:Add add to account team update conditions:End
        
        delete stuaUpdateList2;
        
        //TM:Debmalya:R3:Test coverage for making Sales Territory Inactive
        st.IsActive__c=false;
        update st;
    
        test.stopTest();
        
    }
    static testMethod void userAssignmentPartnerTest() {
            
            test.startTest();
              //TM:Raghvendra:R6:Test coverage for partner teriotory user active/incactive/removed:start
            List<Sales_Territory__c> stUpdateList = new List<Sales_Territory__c>();
            List<Sales_Territory_User_Assignment__c> stuaList = new List<Sales_Territory_User_Assignment__c>();
            List<Sales_Territory_User_Assignment__c> stuaUpdateList = new List<Sales_Territory_User_Assignment__c>();
            Group grp = new Group(Name='STerr-505799',Type='Regular');
            insert grp;
            Sales_Territory__c st1 = new Sales_Territory__c(Name ='Sterr-test',MyComp_Sales_Territory_Name__c='Sterr-test', Account_Access__c='Read',Case_Access__c='Read',Opportunity_Access__c='Read',
                                                                IsPartner__c = true,GroupID__c = grp.Id);        
            insert st1;
            Account account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Partner');
            insert account ;
            Location__c loc  = new Location__c(Account__c=account.id, Name = 'testLocation', Location_Name__c = '12345',Sell_Into_Market__c='TestMarkt', EvaluateTerritory__c = false);
            insert loc;
            User currentUser = [select Id from user where Id =: UserInfo.getUserId()];
            Account account2 = TestingSetupDataUtil.createAccount('testAccount3', 'accountEmail23@email.com','Partner');
            insert account2 ;
            Contact con = new Contact(AccountId = account.id, LastName = 'abc', Email = 'test@hp.com', Phone__c = '123456789');
            insert con;
            UserLicense usr =[Select id from UserLicense where name='Gold Partner'];
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' and UserLicenseId=:usr.Id ];
            user user1 = new User(alias = 'test1', email='test@hp.com', Email_Address__c='test@hp.com', emailencodingkey='UTF-8', lastname='Tertlan1',
                         languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles', username='userTest@SclassTest.com',
                         EmployeeNumber = '55235615', Legacy_Employee_Ref__c = '55235615', ProfileId = portalProfile.Id, ContactId= con.Id, IsActive = true,Adoption_Role_Type__c='Account Executive');
            insert user1;   
            user1.isPortalEnabled = true;
            user1.IsActive = true;
            System.runAs (currentUser){
                    update user1;
            }
            Account account11 = TestingSetupDataUtil.createAccount('testAccount2', 'accountEmail2@email.com','Customer');
            insert account11 ;
            Opportunity opp = new Opportunity(AccountId = account11.id, Owner__c=user1.Id, StageName = '01 - Understand Customer', Name = 'Opty1', CloseDate = system.today()+1,CurrencyIsoCode='AUD');
            insert opp;
            
            //Create Sales Terr User Assignment Records
            List<User> uObjList1 = [Select Id from User where IsActive=true limit 5];
            for(Integer i=0;i<5;i++){
                Sales_Territory_User_Assignment__c stua1 = new Sales_Territory_User_Assignment__c(User__c = uObjList1[i].Id, Sales_Territory__c = st1.Id, IsActive__c=true, 
                                                                                                 Add_to_Account_Team__c = false);
                stuaList.add(stua1);
            }
            insert stuaList;
            //Test Alliance and Channel Partner Insertion
            Channel_Partner__c newalliance=new Channel_Partner__c(Channel_Partner__c=account.Id,Location__c=loc.Id,Partner_Type__c='Alliance Partner',Partner_Account_Role__c='Implementer',Opportunity__c=opp.Id);
            Insert newalliance;
            
            for(Sales_Territory_User_Assignment__c stuaObj : stuaList){
                stuaObj.IsActive__c = false;
                stuaUpdateList.add(stuaObj);
            }
            update stuaUpdateList;
            Sales_Territory_User_Assignment__c getSTUA =[select Id from Sales_Territory_User_Assignment__c where Sales_Territory__r.IsPartner__c=true and IsActive__c=true limit 1];
            delete getSTUA;
            //TM:Raghvendra:R6:Test coverage for partner teriotory user active/incactive/removed:End
             test.stopTest();
            
        }
   
}