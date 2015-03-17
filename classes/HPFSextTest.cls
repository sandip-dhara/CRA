@isTest(SeeAllData=true)
private class HPFSextTest{

/* Test Method to verify the HPFS engagement for product PL=55 & PL<>55 and Business Group<>ES */
Static testMethod void testHPFSprod55(){

/*Intializing Test Data */
/*Profile*/
Profile p = [select id from Profile limit 1];

/* User */
List<User> userList = new List<User>();
User usr = new User(Lastname = 'tsng', Firstname= 'tsng', Username = 'testing0123@hp.com', Alias='tsng', CommunityNickname='hpfs010test', Email='test0123@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0123@hp.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='487547', ProfileId = p.id, Adoption_Role_Type__c='Executive');
userList.add(usr);

User usr1 = new User(Lastname = 'tsbg', Firstname= 'tsbg', Username = 'testing0456@hp.com', Alias='tsbg', CommunityNickname='hpfs011test', Email='test0789@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0789@hp.com',EmployeeNumber='6534787',Legacy_Employee_Ref__c='4875123', ProfileId = p.id, Business_Group__c = 'ES', Region__c = 'EMEA', Adoption_Role_Type__c='Executive');
userList.add(usr1);

User usr2 = new User(Proudct_speciality__c = 'HPFS OAM', Lastname = 'tsng1', Firstname= 'tsng1', Username = 'testing0125@hp.com', Alias='tsng1', CommunityNickname='hpfs012test', Email='test0125@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0125@hp.com',EmployeeNumber='6534823',Legacy_Employee_Ref__c='487523', ProfileId = p.id,Business_Group__c = 'HPFS', Region__c = 'EMEA', Adoption_Role_Type__c='Executive');
userList.add(usr2);

User usr3= new User(Proudct_speciality__c = 'HPFS T-SAM', Lastname = 'tsng2', Firstname= 'tsng2', Username = 'testing0126@hp.com', Alias='tsng2', CommunityNickname='hpfs013test', Email='test0126@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0126@hp.com',EmployeeNumber='6534824',Legacy_Employee_Ref__c='487524', ProfileId = p.id,Business_Group__c = 'HPFS', Region__c = 'EMEA', Adoption_Role_Type__c='Executive');
userList.add(usr3);

User usr4 = new User(Proudct_speciality__c = 'HPFS FAM', Lastname = 'tsng3', Firstname= 'tsng3', Username = 'testing0127@hp.com', Alias='tsng3', CommunityNickname='hpfs014test', Email='test0127@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0127@hp.com',EmployeeNumber='6534825',Legacy_Employee_Ref__c='487525', ProfileId = p.id,Business_Group__c = 'HPFS', Region__c = 'EMEA', Adoption_Role_Type__c='Executive');
userList.add(usr4);

User usr5 = new User(Proudct_speciality__c = 'HPFS SDM', Lastname = 'tsng4', Firstname= 'tsng4', Username = 'testing0128@hp.com', Alias='tsng4', CommunityNickname='hpfs015test', Email='test0128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0128@hp.com',EmployeeNumber='6534826',Legacy_Employee_Ref__c='487526', ProfileId = p.id,Business_Group__c = 'HPFS', Region__c = 'EMEA', Adoption_Role_Type__c='Executive');
userList.add(usr5);

User usr6 = new User(Lastname = 'tsng5', Firstname= 'tsng5', Username = 'testing0130@hp.com', Alias='tsng5', CommunityNickname='hpfs016test', Email='test0130@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0130@hp.com',EmployeeNumber='6534859',Legacy_Employee_Ref__c='587526', ProfileId = p.id,Business_Group__c = 'HPFS', Region__c = '', Adoption_Role_Type__c='Executive');
userList.add(usr6);
insert userList;

/* Account */
List<Account> accList = new List<Account>();
Account acc = TestingSetupDataUtil.createAccount('TestHPFSProd5501','testHPFSprod5501@hp.com','Customer');
accList.add(acc);
Account acc1 = TestingSetupDataUtil.createAccount('TestHPFSProd5502','testHPFSprod5502@hp.com','Customer');
accList.add(acc1);
insert accList;
      
/* Account Team */
List<AccountTeamMember> accteamList = new List<AccountTeamMember>();
AccountTeamMember listAccTeamMembers = TestingSetupDataUtil.createAccTeamMembers(usr.id,'Specialist',Acc.Id);
accteamList.add(listAccTeamMembers);
AccountTeamMember listAccTeamMembers1 = TestingSetupDataUtil.createAccTeamMembers(usr1.id,'Specialist',Acc.Id);
accteamList.add(listAccTeamMembers1);
AccountTeamMember listAccTeamMembers2 = TestingSetupDataUtil.createAccTeamMembers(usr2.id,'Specialist',Acc.Id);
accteamList.add(listAccTeamMembers2);
AccountTeamMember listAccTeamMembers3 = TestingSetupDataUtil.createAccTeamMembers(usr3.id,'Specialist',Acc.Id);
accteamList.add(listAccTeamMembers3);
AccountTeamMember listAccTeamMembers4 = TestingSetupDataUtil.createAccTeamMembers(usr4.id,'Specialist',Acc.Id);
accteamList.add(listAccTeamMembers4);
AccountTeamMember listAccTeamMembers5 = TestingSetupDataUtil.createAccTeamMembers(usr5.id,'Specialist',Acc.Id);
accteamList.add(listAccTeamMembers5);
AccountTeamMember listAccTeamMembers6 = TestingSetupDataUtil.createAccTeamMembers(usr6.id,'Specialist',Acc.Id);
accteamList.add(listAccTeamMembers6);
insert accteamList;

/* Pricebook */
Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
system.debug('***Opptyprice***' + price );

List<Opportunity>opptyList = new List<Opportunity>(); 
/* Opportunity with HPFS Engage flag already checked */
Opportunity newOpty1 = TestingSetupDataUtil.createOpportunity(acc.id,'testOppty', system.today()+ 30);
newOpty1.StageName = '01 - Understand Customer';
newOpty1.ForecastCategoryName = 'Pipeline';
newOpty1.Amount= 100;
newOpty1.ownerid=usr.id;
newOpty1.HPFS_Needed__c = True;
opptyList.add(newOpty1) ;
System.assertEquals(newOpty1.Name,'testOppty');

/* Opportunity with HPFS Engage flag & Confidential flag unchecked and assigned with OpportunityLineItem 55*/
Opportunity newOpty2 = new Opportunity(AccountId=acc.id, Name='test_newOppty001', CloseDate=system.today()+ 60);
newOpty2.StageName = '01 - Understand Customer';
newOpty2.ForecastCategoryName = 'Pipeline';
newOpty2.CurrencyIsoCode= 'USD';
newOpty2.Amount= 100;
//newOpty2.Pricebook2Id = price.id;
newOpty2.HPFS_Needed__c = False;
newOpty2.Confidential__c = False;
opptyList.add(newOpty2) ;
System.assertEquals(newOpty2.Name,'test_newOppty001');

/* Opportunity with HPFS Engage flag & Confidential flag unchecked with OpportunityLineItem other than 55*/
Opportunity newOpty3 = TestingSetupDataUtil.createOpportunity(acc.id,'testOppty455', system.today()+ 30);
newOpty3.StageName = '01 - Understand Customer';
newOpty3.ForecastCategoryName = 'Pipeline';
newOpty3.Amount= 100;
newOpty3.ownerid=usr.id;
newOpty3.HPFS_Needed__c = False;
newOpty3.Confidential__c = False;
opptyList.add(newOpty3) ;
System.assertEquals(newOpty3.Name,'testOppty455');

/* Opportunity  with HPFS Engage flag unchecked and product other than 55 */
Opportunity newOpty4 = TestingSetupDataUtil.createOpportunity(acc.id,'testOppty01', system.today()+ 30);
newOpty4.StageName = '01 - Understand Customer';
newOpty4.ForecastCategoryName = 'Pipeline';
newOpty4.Amount= 100;
newOpty4.ownerid=usr1.id;
newOpty4.HPFS_Needed__c = False;
opptyList.add(newOpty4) ;
System.assertEquals(newOpty4.Name,'testOppty01');

/* Opportunity  with Confidential flag checked */
Opportunity newOpty5 = new Opportunity(AccountId=acc.id, Name='test_newOppty002', CloseDate=system.today()+ 60);
newOpty5.StageName = '01 - Understand Customer';
newOpty5.ForecastCategoryName = 'Pipeline';
newOpty5.Amount= 100;
newOpty5.CurrencyIsoCode= 'USD';
//newOpty5.Pricebook2Id = price.id;
newOpty5.HPFS_Needed__c = False;
newOpty5.Confidential__c = True;
opptyList.add(newOpty5) ;
System.assertEquals(newOpty5.Name,'test_newOppty002');

/* Renewal Opportunity */
Opportunity newOpty6 = new Opportunity(AccountId=acc.id, Name='t01_renewalOppty', CloseDate=system.today()+ 60);
newOpty6.StageName = '01 - Understand Customer';
newOpty6.ForecastCategoryName = 'Pipeline';
newOpty6.Amount= 100;
newOpty6.CurrencyIsoCode= 'USD';
newOpty6.Type='Renewal';
newOpty6.Route_To_Market__c='Direct';
opptyList.add(newOpty6) ;
System.assertEquals(newOpty6.Name,'t01_renewalOppty');

Opportunity newOpty7 = new Opportunity(AccountId=acc1.id, Name='t02_exceptOppty', CloseDate=system.today()+ 40);
newOpty7.StageName = '01 - Understand Customer';
newOpty7.ForecastCategoryName = 'Pipeline';
newOpty7.Amount= 100;
newOpty7.ownerid=usr.id;
newOpty7.CurrencyIsoCode= 'USD';
opptyList.add(newOpty7) ;
insert opptyList;
update opptyList;

/* Product */
List<Product2> prodlist = new List<Product2>();
Product2 prod2 = TestingSetupDataUtil.createProduct(true ,'55 - HP TVS Service','USD','3771834');
prod2.CanUseQuantitySchedule=True;
prod2.CanUseRevenueSchedule=True;
prodlist.add(prod2);
system.assertEquals(prod2.name, '55 - HP TVS Service');

Product2 prod4 = TestingSetupDataUtil.createProduct(true ,'55 - HP TVS Service','USD','3771834');
prod4.CanUseQuantitySchedule=True;
prod4.CanUseRevenueSchedule=True;
prodlist.add(prod4);
insert prodlist;

/* PriceBookEntry */
List<PricebookEntry> priceEntryList = new List<PricebookEntry>();
PricebookEntry priceEntry2 = TestingSetupDataUtil.createPricebookEntry(prod2.Id,true,price.Id,100,'USD');
priceEntryList.add(priceEntry2);
PricebookEntry priceEntry4 = TestingSetupDataUtil.createPricebookEntry(prod4.Id,true,price.Id,1000,'USD');
priceEntryList.add(priceEntry4);
insert priceEntryList;

/* OpportunityLineItem */
List<OpportunityLineItem> opplineList = new List<OpportunityLineItem>();
OpportunityLineItem OpptylineItem2 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,newOpty2.id,priceEntry2.id,System.Today()+40);
opplineList.add(OpptylineItem2);
OpportunityLineItem OpptylineItem4 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,newOpty5.id,priceEntry4.id,System.Today()+40);
opplineList.add(OpptylineItem4);
insert opplineList;

/* OpportunityLineItemSchedule */
List<OpportunityLineItemSchedule> oppscheduleList = new List<OpportunityLineItemSchedule>();
OpportunityLineItemSchedule schedule=new OpportunityLineItemSchedule(Quantity=5,ScheduleDate=system.Today()+1,OpportunityLineItemId=OpptylineItem2.Id,Type='Both',Revenue=100 );
oppscheduleList.add(schedule);
OpportunityLineItemSchedule schedule1=new OpportunityLineItemSchedule(Quantity=5,ScheduleDate=system.Today()+1,OpportunityLineItemId=OpptylineItem4.Id,Type='Both',Revenue=100 );
oppscheduleList.add(schedule1);
Insert oppscheduleList;

/* Creating Sales Territory and adding account to territory */
Sales_Territory__c salesTerr = new Sales_Territory__c(Name = 'testSalesTerritory', IsActive__c = true, MyComp_Sales_Territory_Name__c='test001Sales');
insert salesTerr;

Sales_Territory_Account_Assignment__c salesTerrAcc = new Sales_Territory_Account_Assignment__c(Account__c = Acc.Id, Sales_Territory__c = salesTerr.Id);
insert salesTerrAcc;

Sales_Territory_User_Assignment__c terrUser = new Sales_Territory_User_Assignment__c (Sales_Territory__c = salesTerr.Id, IsActive__c = true);
insert terrUser;

test.startTest();
HPFSext hpfsEngageTest = new HPFSext();
HPFSext.sendMessage(opptyList[0].id); 
HPFSext.sendMessage(opptyList[1].id);
HPFSext.sendMessage(opptyList[2].id); 
HPFSext.sendMessage(opptyList[3].id); 
HPFSext.sendMessage(opptyList[4].id);
HPFSext.sendMessage(opptyList[5].id); 
//HPFSext.sendMessage(opptyList[6].id); 
HPFSext.getRandomNumber(2);
test.stopTest();
}

}