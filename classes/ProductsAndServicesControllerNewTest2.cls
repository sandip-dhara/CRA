@isTest(seeAllData = true)
public class ProductsAndServicesControllerNewTest2{

static Opportunity newOpp;
    
    static List<OpportunityLineItem> newOppLineItemList;
    static Pricebook2 prb;
    static List<PricebookEntry> newEntryList;
    private static void setupData() {
          prb=[select id from Pricebook2 where IsStandard = true];
          Account newAcc =TestingSetupDataUtil.createAccount('MultiBGTest','test_22@hp.com','Customer');
          insert newAcc;     
          newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOppty567', system.today()+ 30);
          insert newOpp; 
          Pricebook2 prb1 = [select id from Pricebook2 where IsStandard = true];
          List<Product2> prodList=new List<Product2>();
          Product2 newPro=TestingSetupDataUtil.createProduct(true ,'testProduct3','USD',null);          
          newPro.Product_Line__c='ProductLine';
          newPro.Sub_Product_Line__c='SubProductLine';
          newPro.Product_Level__c=2 ;
          newPro.Business_Group__c='SW';
          newPro.GBU__c='Application Services';
          newPro.IsActive=true;
          prodList.add(newPro);
          
          Product2 newPro1=TestingSetupDataUtil.createProduct(true ,'testProduct3','USD',null);          
          newPro1.Product_Line__c='ProductLine';
          newPro1.Sub_Product_Line__c='SubProductLine';
          newPro1.Product_Level__c=2 ;
          newPro1.Business_Group__c='SW';
          newPro1.GBU__c='Application Services';
          newPro1.IsActive=true;
          prodList.add(newPro1);
          insert prodList;
          
          newEntryList=new List<PricebookEntry>();
          PricebookEntry newEntry=TestingSetupDataUtil.createPricebookEntry(prodList[0].Id,true,prb.Id,100,'USD'); 
          newEntryList.add(newEntry);  
          PricebookEntry newEntry1=TestingSetupDataUtil.createPricebookEntry(prodList[1].Id,true,prb.Id,1000,'USD'); 
          newEntryList.add(newEntry1);   
          insert newEntryList; 
          newOppLineItemList=new List<OpportunityLineItem >();
          OpportunityLineItem newOppLineItem = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = newEntryList[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10); 
          newOppLineItemList.add(newOppLineItem );
          
          OpportunityLineItem newOppLineItem1 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = newEntryList[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10); 
          newOppLineItemList.add(newOppLineItem1 );
          
          insert  newOppLineItemList;     
             
    }
   
   private static testMethod void productsAndServicesControllernewPositiveTest() {
       setupData();
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('stTest1','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='';
        insert user1;
        
            PageReference pageRef = Page.ProductsAndServices;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('oppId',newOpp.Id);
            ApexPages.StandardController oli = new ApexPages.standardController(newOppLineItemList[0] );
            ProductsAndServicesControllerNew testConstructor=new ProductsAndServicesControllerNew();
            ProductsAndServicesControllerNew productsAndServicesControllerObj = new ProductsAndServicesControllerNew(oli);
            productsAndServicesControllerObj.opplineitem.pricebookEntryId=newEntryList[0].Id;
            productsAndServicesControllerObj.searchBusinessGroup='HP Software';
            productsAndServicesControllerObj.searchGlobalBusinessUnit='Application Services';
            productsAndServicesControllerObj.productlinename='TF - IM Storage Essentials';
            productsAndServicesControllerObj.subproductlinename='TF - Storage Essentials';
            productsAndServicesControllerObj.quantity=1;
            productsAndServicesControllerObj.opplineitem.UnitPrice=100;
            productsAndServicesControllerObj.opplineitem.ServiceDate=system.today()+ 36;
            productsAndServicesControllerObj.opplineitem.ICOEM__c=true;
            productsAndServicesControllerObj.SaveLinteItem();
            productsAndServicesControllerObj.getOpportunityLineItems();
            //for(integer i=0;i<productsAndServicesControllerObj.existingLineItemList.size() -1 ;i++){
                //if(productsAndServicesControllerObj.existingLineItemList[i].oli.id == newOppLineItemList[1].id){
                    productsAndServicesControllerObj.existingLineItemList[0].selected = true;
                    productsAndServicesControllerObj.existingLineItemList[0].isNew = true;
                    productsAndServicesControllerObj.existingLineItemList[0].oli.ICOEM__c= true;
                    productsAndServicesControllerObj.existingLineItemList[0].pricebookEntryId = newEntryList[1].Id;
                //}
            //}
             productsAndServicesControllerObj.existingLineItemList[1].selected = true;
            productsAndServicesControllerObj.existingLineItemList[1].isNew = false;
            productsAndServicesControllerObj.existingLineItemList[1].oli.ICOEM__c= true;
            productsAndServicesControllerObj.saveInline();
           
            //productsAndServicesControllerObj.existingLineItemList[1].pricebookEntryId = newEntryList[1].Id;
            
       
   }
  
}