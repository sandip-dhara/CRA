/**********************************************************
* Class Name: LeadProductLookupControllerTest
* Author: Accenture
* Date: 25-JUL-2012 
* Description: This class does the test coverage
*              for LeadProductLookupController class. 
***********************************************************/
@isTest
private class LeadProductLookupControllerTest {
    
    public static List<Lead> newLeads;
    static List<Product2> listProduct1;
    public static Product_Interest__c newproductInterest;
    public static List<Product_Interest__c> newproductInterests;
    static Product_Interest__c newproductInterest1;
    static Product_Interest__c newproductInterest2;
    static Product_Interest__c newproductInterest3;
    
    /**
    * Insert a Product Interest record
    * @param - Date bookShipdate,String leadId, String productId, String quantity, String unitPrice
    * @returns - Product Interest 
    */
    public static Product_Interest__c createProductInterest(ID leadId, ID productId, Decimal quantity, Decimal unitPrice, Date bookShipdate) {
        Product_Interest__c objproductInterest = new Product_Interest__c();         
        objproductInterest.Lead__c = leadId;
        objproductInterest.Product__c = productId;
        objproductInterest.Quantity__c = quantity;
        objproductInterest.Unit_Price__c = unitPrice;
        objproductInterest.Book_Ship_Date__c = bookShipdate;
        return objproductInterest;          
    }   

    static void setupData() {
        
        listProduct1 = new List<Product2>();
                
        /* Inserting Leads */
        newLeads = new List<Lead>();       
        Lead newLead1 = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Qualified', 'Assigned', '123', 'test@test.com');
        newLeads.add(newLead1);     
        Lead newLead2 = TestingSetupDataUtil.createLead('TestLead3', '123', 'Qualified', 'Assigned', '123', '');
        newLeads.add(newLead2); 
        try {
                insert newLeads ;
            } catch (Exception e){          
        }
        
        /*Inserting Products*/
        Product2 newPro1=TestingSetupDataUtil.createProduct(true ,'testProduct1','USD',null);
        listProduct1.add(newPro1);  
        
        Product2 newPro2=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
        listProduct1.add(newPro2);
        insert listProduct1;
        for(Product2 Pro : listProduct1){
            Pro.Business_Group__c = 'EB';
            Pro.GBU__c= 'IM';
            Pro.Product_Line__c= 'TF - IM Storage Essentials';
            Pro.Sub_Product_Line__c = 'TF - Storage Essentials';
            Pro.Product_level__c = 4;
        }
        update listProduct1;
        
        /* Inserting Product Interest */
        newproductInterest = new Product_Interest__c();
        newproductInterests = new List<Product_Interest__c>();
        newproductInterest1 = new Product_Interest__c(Lead__c = newLeads[0].Id, Product__c = newPro1.Id, Quantity__c = 11, Unit_Price__c = 10, Book_Ship_Date__c = system.today()+ 15);
        insert newproductInterest1; 
        newproductInterests.add(newproductInterest1);  
        newproductInterest2 = new Product_Interest__c(Lead__c = newLeads[1].Id, Product__c = newpro2.Id, Quantity__c = 12, Unit_Price__c = 11, Book_Ship_Date__c = system.today()+ 5);
        insert newproductInterest2; 
        newproductInterests.add(newproductInterest2);           
    }
    
    private static testMethod void testLeadProductLookupController() {
        
        /* Initializing test data */
        setupData();      
        Test.startTest();
        
        // create an instance of the LeadProductLookupController controller
        PageReference pageRef = Page.AddLeadProductLine;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('lksrch',listProduct1[0].Name);
        ApexPages.StandardController sc1 = new ApexPages.standardController(newproductInterest1);
        LeadProductLookupController productLevel = new LeadProductLookupController(sc1);
        productLevel.initialize();
        System.assertEquals(productLevel.products.size() == 0, false); 
        productLevel.getFormTag();
        productLevel.getTextBox(); 
        ApexPages.currentPage().getParameters().put('lksrch',''); 
        productLevel.initialize(); 
        productLevel.getGBUs();
        productLevel.getBGs();
        productLevel.getSortDirection();
        productLevel.getProducts();
        productLevel.ViewData();
        productLevel.setSortDirection('A');
        
        productLevel.subprdLine = 'AN - Mobile Computing Prod';
        productLevel.prdLine  = 'AN - AP - HP ProBook 6460b Notebook PC';
        productLevel.GBU = 'Commercial Notebooks';
        productLevel.BG = 'Commercial Notebooks';
        productLevel.searchProducts();
        
        Test.stopTest();       
    }   
}