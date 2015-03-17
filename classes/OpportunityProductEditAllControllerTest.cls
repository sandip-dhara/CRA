/**********************************************************
* Class Name: OpportunityProductEditAllControllerTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage for OpportunityProductEditAllController class.
***********************************************************/
@isTest
private class OpportunityProductEditAllControllerTest{
    static PageReference pref;
    static Opportunity opty;

    private static void setupData() {

        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
        //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        insert opty;
        
        // create a test pricebook2
        Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        // create a test Product2
        Product2 prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        insert prod;
       
        // create a test Product2
        PricebookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        insert priceEntry;
        
        // create a test Opportunity line item
        OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        insert OppLineItem;
    }
    
    private static testMethod void editAllProductPositiveTest() {
        Test.startTest();
        setupData();
        pref = Page.OpportunityProductEditAll;
        pref.getParameters().put('oppId',opty.id);
        pref.getParameters().put('retURL','/'+opty.id);
        pref.getParameters().put('oppName','Opty99ZZ');
        Test.setCurrentPage(pref);
        
        OpportunityProductEditAllController controller = new OpportunityProductEditAllController();
        controller.recalculateSubTotal();
        controller.getTotal();
        String nextPage = controller.save().getUrl();
        controller.Cancel();

        // Verify that the success page displays 
    
        System.assertEquals('/'+opty.id, nextPage);
        Test.stopTest();
    }
    
    static testMethod void editAllProductNegativeTest() {
    Test.startTest();
        setupData();
        pref = Page.OpportunityProductEditAll;
        pref.getParameters().put('oppId',opty.id);
        pref.getParameters().put('retURL','/'+opty.id);
        pref.getParameters().put('oppName','Opty99ZZ');
        Test.setCurrentPage(pref);
        
        OpportunityProductEditAllController controller = new OpportunityProductEditAllController();
        for(OpportunityProductEditAllController.OpportunityLineItemClass innerClassRecord :controller.lineItemMap.values()){
            innerClassRecord.lineItem.Quantity = 1.5;
        }
        pageReference pr = controller.save();
        
        // Verify that the error page displays 
        
        //System.assertEquals(null, pr);
        Test.stopTest();  
    }
}