@isTest(seealldata=true)
/***********************************************************
* Class Name: ProductsquickaddlookupcontrollerTest
* Author: Pradeep Kumar L.G
* Description: This class does the test coverage
* for Productsquickaddlookupcontroller class.
***********************************************************/

private class ProductsquickaddlookupcontrollerTest{
static OpportunityLineItem newOppLineItem1;
    static Opportunity newOpp;
    static List<PricebookEntry> listPrbEntry;
    static List<OpportunityLineItem> listOpptyProduct;
    static List<Product2> listProduct2;
    
    private static void setupData() {
        listPrbEntry = new List<PricebookEntry>();
        listOpptyProduct = new List<OpportunityLineItem>(); 
        listProduct2 = new List<Product2>();
        
        /*To fetch the Id of standard pricebook*/
        Pricebook2 prb = [select id from Pricebook2 where IsStandard = true];
        
        /*Inserting Products*/
        Product2 newPro1=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
        listProduct2.add(newPro1);
       
        Product2 newPro2=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
        listProduct2.add(newPro2);
        insert listProduct2;
        for(Product2 Pro : listProduct2){
        Pro.Business_Group__c = 'EB';
        Pro.GBU__c= 'IM';
        Pro.Product_Line__c= 'TF - TestPL';
        Pro.Sub_Product_Line__c = 'TF - TestSPL';
        Pro.Product_Level__c = 4;
        }
        update listProduct2;
        
        /*Inserting Pricebook*/
        Pricebook2 newBook=TestingSetupDataUtil.createPriceBook('Test Pricebook',true);
        insert newBook;
        
        /*Inserting Pricebook Entries*/
        PricebookEntry newEntry1=TestingSetupDataUtil.createPricebookEntry(newPro1.Id,true,prb.Id,100,'USD');               
        listPrbEntry.add(newEntry1);    
       
        PricebookEntry newEntry2=TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,prb.Id,100,'USD');                
        listPrbEntry.add(newEntry2);    
       
        /*PricebookEntry newEntry3=TestingSetupDataUtil.createPricebookEntry(newPro1.Id,true,newBook.Id,1000,'USD');        
        listPrbEntry.add(newEntry3);

        PricebookEntry newEntry4=TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,newBook.Id,1000,'USD');                
        listPrbEntry.add(newEntry4); */   
        insert listPrbEntry;
    }
/* This class Used to cover Positive scenarios of Productsquickaddlookupcontroller class*/

    private static testMethod void productsAndServicesLookupPositiveTest() {
        
        setupData();
        Test.startTest();
        
        /* Setting PageReference as relevant Page */
        PageReference pageRef = Page.Productsquickaddlookup;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('bg','EB');
        ApexPages.currentPage().getParameters().put('gbu','IM');
        ApexPages.currentPage().getParameters().put('pl','TF - TestPL');
        ApexPages.currentPage().getParameters().put('spl','TF - TestSPL');
        ApexPages.currentPage().getParameters().put('level','4');
        ApexPages.currentPage().getParameters().put('curr','USD');
        Productsquickaddlookupcontroller productsAndServicesLookupObj = new Productsquickaddlookupcontroller();
        
        /*Get Picklist Values*/
        //productsAndServicesLookupObj.getBGPicklist();
        //productsAndServicesLookupObj.getGBUPicklist();
        
        /*All Business Group not equals blank search Criteria*/
        productsAndServicesLookupObj.filters='contains';
        productsAndServicesLookupObj.searchSubProductLine = '';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchProductLine = '';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchGlobalBusinessUnit = '';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchSubProductLine = 'TF - TestSPL';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchProductLine = 'TF - TestPL';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchSubProductLine = '';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchGlobalBusinessUnit = 'IM';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchProductLine = '';
        productsAndServicesLookupObj.filters=null;
        productsAndServicesLookupObj.searchSubProductLine = 'TF - TestSPL';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchBusinessGroup = '';
        productsAndServicesLookupObj.searchSubProductLine = '';
        productsAndServicesLookupObj.searchGlobalBusinessUnit = '';
        productsAndServicesLookupObj.searchProduct();
        System.assertEquals(productsAndServicesLookupObj.lstPricebookEntries.size() == 0, false);
        
        /*All GBU not equals blank search Criteria*/
        productsAndServicesLookupObj.searchGlobalBusinessUnit = 'IM';
        productsAndServicesLookupObj.searchProduct();
        System.assertEquals(productsAndServicesLookupObj.lstPricebookEntries.size() == 0, false);
        productsAndServicesLookupObj.searchProductLine = 'TF - TestPL';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchSubProductLine = 'TF - TestSPL';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchProductLine = '';
        productsAndServicesLookupObj.searchProduct();
        
        /*All ProductLine not equals blank search Criteria*/
        productsAndServicesLookupObj.searchProductLine = 'TF - TestPL';
        productsAndServicesLookupObj.searchGlobalBusinessUnit = '';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchSubProductLine = '';
        productsAndServicesLookupObj.searchProduct();
        
        /*All Sub ProductLine not equals blank search Criteria*/
        productsAndServicesLookupObj.searchProductLine = '';
        productsAndServicesLookupObj.searchSubProductLine = 'TF - TestSPL';
        productsAndServicesLookupObj.searchProduct();
        productsAndServicesLookupObj.searchSubProductLine = '';
        productsAndServicesLookupObj.searchProduct();
        System.assertEquals(productsAndServicesLookupObj.lstPricebookEntries.size() == 0, false);
        
        /*Get Form Tag and Text Box*/
        productsAndServicesLookupObj.getFormTag();
        productsAndServicesLookupObj.getTextBox();
        Test.stopTest();
    }
    
    /* This class Used to cover Negative scenarios of Productsquickaddlookupcontroller class*/
    private static testMethod void productsAndServicesLookupNegativeTest() {
        
        setupData();
        Test.startTest();
        
        /* Setting PageReference as relevant Page */
        PageReference pageRef = Page.Productsquickaddlookup;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('bg','EB');
        ApexPages.currentPage().getParameters().put('gbu','IM');
        ApexPages.currentPage().getParameters().put('pl','TF - TestPL');
        ApexPages.currentPage().getParameters().put('spl','TF - TestSPL');
        ApexPages.currentPage().getParameters().put('level','1');
        ApexPages.currentPage().getParameters().put('curr','USD');
        
        /*No Product found*/
        Productsquickaddlookupcontroller productsAndServicesLookupObj = new Productsquickaddlookupcontroller();
        System.assertEquals(productsAndServicesLookupObj.lstPricebookEntries.size() == 0, true);
        productsAndServicesLookupObj.OnchangeofBG();
        productsAndServicesLookupObj.OnchangeOfGBU();
        productsAndServicesLookupObj.OnchangeOfBGmock();
        productsAndServicesLookupObj.GBUFilter();
        
        Test.stopTest();
   }     
}