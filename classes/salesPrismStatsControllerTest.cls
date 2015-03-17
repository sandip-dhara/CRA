@isTest
private class salesPrismStatsControllerTest{
static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(LastName = 'test', Email = 'test@test.com',Title='abc');
        insert con;
        Contact con2 = new Contact(LastName = 'test2', Email = 'test2@test.com');
        insert con2;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acp);
        salesPrismStatsController ars = new salesPrismStatsController(sc);
        ars.getStatsList();
        ars.goToPrism();
        ars.getLinkToPrism();
        ars.getIsPrismAccount();      
    }
}