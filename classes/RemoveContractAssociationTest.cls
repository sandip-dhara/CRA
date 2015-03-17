@isTest(SeeAllData=true)
private class RemoveContractAssociationTest {
static Opportunity newOpp;
static contract_reference__c conref; 
static contract_reference__c conref1;        
    private static void setupData() 
    {
    /* Initializing test data */
    /* Account */ 
    account acc = TestingSetupDataUtil.createAccount('testAccount1','accountEmail@email.com','Customer');
    insert acc;
    System.assertEquals(acc.Name,'testAccount1');
    /* Opportunity */
    newOpp = TestingSetupDataUtil.createOpportunity(acc.id,'testOppty', system.today()+ 30);
    newOpp.type = 'Renewal';
    newopp.StageName = '01 - Understand Customer';
    newopp.ForecastCategoryName = 'Pipeline';
    newopp.ownerid=UserInfo.getUserId();
    newopp.Route_To_Market__c = 'Direct';
    newopp.Amount=10;
    insert newOpp;
    System.assertEquals(newOpp.Name,'testOppty');
    
    /* contractreference */
    conref = new contract_reference__c();
    {
        conref.name='Test_contract';
        conref.original_opportunity__c=newOpp.id;
        conref.accounts__c=acc.id;
    }
    insert conref;
    System.assertEquals(conref.Name,'Test_contract');
    conref1 = new contract_reference__c();
    {
        conref1.name='Test_contract';
        conref1.original_opportunity__c=newOpp.id;
        conref1.accounts__c=acc.id;
    }
    insert conref1;
    System.assertEquals(conref.Name,'Test_contract');
    // create a test pricebook2
    Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
    // create a test Product2
    Product2 prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
    prod.Business_Group__c = 'HP Software';
    insert prod;
    System.assertEquals(prod.Name,'abc');
    // create a test Product2
    PricebookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
    insert priceEntry;
    // create a test Opportunity line item
    OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,newopp.id,priceEntry.id,System.Today()+40);
    {
        opplineitem.contract__c = conref.id;
        //opplineitem.Business_Group__c = 'HP Software';
    }
    insert OppLineItem;
    OpportunityLineItem OppLineItem1 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,newopp.id,priceEntry.id,System.Today()+40);
    {
        opplineitem.contract__c = conref1.id;
        //opplineitem.Business_Group__c = 'HP Software';
    }
    insert OppLineItem1;
    }

    
    static testMethod void AssociationNegativeTest() 
    {
        test.startTest();
        setupData();
        COTestClassUtility.RemoveContractAssociationTestVar1 = true;
        RemoveContractAssociation.removeassociation(new List<Id>{conref1.Id});        
        
        test.stopTest();
    } 
}