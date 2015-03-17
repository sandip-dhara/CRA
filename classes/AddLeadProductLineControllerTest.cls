/**********************************************************
* Class Name: AddLeadProductLineControllerTest
* Author: Accenture
* Date: 13-JUL-2012 
* Description: This class does the test coverage
*              for AddLeadProductLineController class. 
***********************************************************/
@isTest
private class AddLeadProductLineControllerTest {
    
    public static List<Lead> newLeads;
    static List<Product2> listProduct1;
    public static Product_Interest__c newproductInterest;
    public static List<Product_Interest__c> newproductInterests;
    static Product_Interest__c newproductInterest1;
    static Product_Interest__c newproductInterest2;
    static Product_Interest__c newproductInterest3;
    public static User user;
    
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
        
        /* Inserting User */
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        user = new User();
        user = TestingSetupDataUtil.createUser('st'+randomstr.substring(0,4), randomstr+'standarduser@hp.com', randomstr+'standarduser@testorg.com', 
                                                'UTF-8', 'U LastName', 'en_US', 'en_US', 'America/Los_Angeles', randomstr+'standarduser12@hp.com', 
                                                randomstr+'5', Userinfo.getProfileId());                                 
        try {
            insert user;
            } catch (Exception e){ 
        }
        system.assertEquals(user.Id != null, true);         
    }
    
    private static testMethod void testAddLeadProductLineController() {
        
        /* Initializing test data */
        setupData();      
        Test.startTest();
        
        // create an instance of the AddLeadProductLineController controller
        PageReference pageRef = Page.AddLeadProductLine;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLeads[0].Id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(newproductInterest1);
        AddLeadProductLineController productInterestObj = new AddLeadProductLineController(sc1);
        productInterestObj.leadId = newLeads[0].Id;
        newLeads[0].OwnerId = user.Id;
        productInterestObj.save();
        productInterestObj.saveAndNew();
        
        PageReference pageRef1 = Page.AddLeadProductLine;
        Test.setCurrentPageReference(pageRef1);
        ApexPages.currentPage().getParameters().put('leadId',newLeads[1].Id);
        ApexPages.StandardController sc2 = new ApexPages.standardController(newproductInterest2);
        AddLeadProductLineController productInterestObj1 = new AddLeadProductLineController(sc2);
        productInterestObj1.leadId = newLeads[1].Id;
        productInterestObj1.cancel();
        
        Test.stopTest();       
    }
    
    private static testMethod void addLeadProductLineControllerNegativeTest() {
        
        /* Initializing test data */
        setupData();
        Test.startTest();
        
        PageReference pageRef2 = Page.AddLeadProductLine;
        Test.setCurrentPageReference(pageRef2);
        ApexPages.currentPage().getParameters().put('leadId',newLeads[0].Id);
        ApexPages.StandardController sc3 = new ApexPages.standardController(newproductInterest1);
        AddLeadProductLineController productInterestObj2 = new AddLeadProductLineController(sc3);
        newproductInterest3 = new Product_Interest__c(Lead__c = newLeads[0].Id, Quantity__c = -1, Unit_Price__c = 11, Book_Ship_Date__c = system.today()+ 5);        
        productInterestObj2.leadproduct = newproductInterest3;
        productInterestObj2.save();
    }
}