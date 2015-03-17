@isTest(SeeAllData=true)
private class ContractassociateControllerTest{

static Opportunity opty;
static opportunity opty1;
static contract_reference__c conref;
static contract_reference__c conref1;
static PageReference pref;
static List<contract_reference__c> contract = new contract_reference__c []{};
static List<OpportunityLineItem> NewOppLineItemList = new OpportunityLineItem[]{};
static String ContrId = null;
static String retUrl = null;

        
         private static void setupData() {
   
         /* Initializing test data */
        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
         //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        {
        opty.type = 'Renewal';
        opty.StageName = '01 - Understand Customer';
        opty.Route_To_Market__c = 'Direct';
        opty.Amount=10;
        }
        insert opty;
        System.assertEquals(opty.Name,'Opty99ZZ_952PM');
        retUrl = opty.Id;
        
         opty1 = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_953PM',System.Today()+30);   
        {
        opty1.type = 'Renewal';
        opty1.StageName = '01 - Understand Customer';
        opty1.Route_To_Market__c = 'Direct';
        opty1.Amount=10;
        }
        insert opty1;
        System.assertEquals(opty1.Name,'Opty99ZZ_953PM');
        
       
       // create test contractreference 
        conref1 = new contract_reference__c();
        conref = new contract_reference__c();
        {
        conref.name='Test_contract';
        conref.original_opportunity__c=opty.id;
        conref.accounts__c=acc.id;
        }
        insert conref;
        System.assertEquals(conref.Name,'Test_contract');
      
        ContrId =conref.Id; 
         // create a test pricebook2
        Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        // create a test Product2
        Product2 prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'HP Software';
        insert prod;
       
        // create a test Product2
        PricebookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        insert priceEntry;
                
        // create a test Opportunity line item
        OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        {
        opplineitem.contract__c = conref.id;
        //opplineitem.Business_Group__c = 'HP Software';
        }
        insert OppLineItem;
        pref = Page.AssociateToExistingRenewal;
        pref.getParameters().put('oppId',opty1.id);
        pref.getParameters().put('selectedcontractid',conref.id);
        Test.setCurrentPage(pref);
       
        }
        static testMethod void AssociationPositiveTest() {
        
        test.startTest();
        setupData();

                         
        // Testing Constructor 
        
        ApexPages.StandardController std_controller = new ApexPages.StandardController(conref); 
        ContractAssociateController controller = new ContractAssociateController(std_controller);   
        controller.ContID = ContrId;
        controller.retURL = retURL;
        
        Test.setCurrentPage(pref);
        List<contract_reference__c> getcontracts = controller.getContractList();
        //system.assert(getcontracts.size() > 0, 'contract list was empty');        
        //testing getoppty method    
        controller.getLineItems();  
        controller.getoppty();
       
        //Testing Associate method
        controller.Associate();
        
        controller.Cancel();
        test.stopTest();
        }
        
    static testMethod void AssociationNegativeTest2() {
        
        test.startTest();
        setupData();

                         
        // Testing Constructor 
        
        ApexPages.StandardController std_controller = new ApexPages.StandardController(conref); 
        ContractAssociateController controller = new ContractAssociateController(std_controller);   
        controller.ContID = ContrId;
        controller.retURL = retURL;
        
        Test.setCurrentPage(pref);
        List<contract_reference__c> getcontracts = controller.getContractList();
        //system.assert(getcontracts.size() > 0, 'contract list was empty');        
        //testing getoppty method    
        controller.getLineItems();  
        controller.getoppty();
       
        //Testing Associate method
        
        COTestClassUtility.ContractAssociateControllerTestVar1 = false;
        COTestClassUtility.ContractAssociateControllerTestVar2 = false;
        COTestClassUtility.ContractAssociateControllerTestVar3 = true;
        controller.Associate();
        
        test.stopTest();
        }
        
    static testMethod void AssociationNegativeTest3() {
        
        test.startTest();
        setupData();

                         
        // Testing Constructor 
        
        ApexPages.StandardController std_controller = new ApexPages.StandardController(conref); 
        ContractAssociateController controller = new ContractAssociateController(std_controller);   
        controller.ContID = ContrId;
        controller.retURL = retURL;
        
        Test.setCurrentPage(pref);
        List<contract_reference__c> getcontracts = controller.getContractList();
        //system.assert(getcontracts.size() > 0, 'contract list was empty');        
        //testing getoppty method    
        controller.getLineItems();  
        controller.getoppty();
       
        //Testing Associate method
        
        COTestClassUtility.ContractAssociateControllerTestVar1 = false;
        COTestClassUtility.ContractAssociateControllerTestVar2 = true;
        COTestClassUtility.ContractAssociateControllerTestVar3 = false;
        controller.Associate();

        test.stopTest();
        }
        
    static testMethod void AssociationNegativeTest4() {
        
        test.startTest();
        setupData();

                         
        // Testing Constructor 
        
        ApexPages.StandardController std_controller = new ApexPages.StandardController(conref); 
        ContractAssociateController controller = new ContractAssociateController(std_controller);   
        controller.ContID = ContrId;
        controller.retURL = retURL;
        
        Test.setCurrentPage(pref);
        List<contract_reference__c> getcontracts = controller.getContractList();
        //system.assert(getcontracts.size() > 0, 'contract list was empty');        
        //testing getoppty method    
        controller.getLineItems();  
        controller.getoppty();
       
        //Testing Associate method
        
        COTestClassUtility.ContractAssociateControllerTestVar1 = true;
        COTestClassUtility.ContractAssociateControllerTestVar2 = false;
        COTestClassUtility.ContractAssociateControllerTestVar3 = false;
        controller.Associate();

        test.stopTest();
        }
        
   static testMethod void AssociationNegativeTest() {
        
        test.startTest();
        setupData();

                         
        // Testing Constructor 
        
        ApexPages.StandardController std_controller = new ApexPages.StandardController(conref1); 
        ContractAssociateController controller = new ContractAssociateController(std_controller);   
        controller.ContID = ContrId;
        controller.retURL = retURL;
        
        Test.setCurrentPage(pref);
        List<contract_reference__c> getcontracts = controller.getContractList();
        //system.assert(getcontracts.size() > 0, 'contract list was empty');        
        //testing getoppty method    
        controller.getLineItems();  
        controller.getoppty();
       
        //Testing Associate method
        try{
        controller.Associate();
        }
        catch(Exception e)
        {
        
        }        
        
        controller.Cancel();
        test.stopTest();
        }
        
   }