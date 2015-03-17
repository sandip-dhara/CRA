@isTest(SeeAllData=true)
private class ContractExtensionControllerTest {
static Opportunity opty;
static PageReference pref;
static List<contract_reference__c> contract = new contract_reference__c []{};
static List<OpportunityLineItem> NewOppLineItemList = new OpportunityLineItem[]{};
static String ContrId = null;
static String retUrl = null;
static contract_Reference__c conref;
        
        public static void setupdata(){
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'test',System.Today()+30);   
        {
        opty.type = 'Renewal';
        opty.StageName = '01 - Understand Customer';
        opty.Route_To_Market__c='Direct';
        opty.Amount=10;
        
        }
        insert opty;
        
        retUrl = opty.Id;
       
        conref = new contract_reference__c(Name='Test_contract',Original_Opportunity__c=opty.id, Accounts__c=acc.id);
        
        insert conref;
      
        ContrId =conref.Id; 
        Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        Product2 prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'HP Software';
        insert prod;
       
        PricebookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        insert priceEntry;
                
        OpportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        {
        opplineitem.contract__c = conref.id;
        //opplineitem.Business_Group__c = 'HP Software';
        }
        insert OppLineItem;
        
        }
        
        
        static testMethod void AssociationPositiveTest() {
        
        setupdata();
         
        pref = Page.AssociateToNewRenewalOpty;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('selectedcontractid',conref.Id);
        ApexPages.currentPage().getParameters().put('oppId',opty.Id);
        test.startTest();
        
        Opportunity oppp = new Opportunity();
        oppp.Name='Test';
        ApexPages.StandardController std_controller = new ApexPages.StandardController(oppp); 
        ContractExtensionController controller = new ContractExtensionController(std_controller);  
        controller.ContID = ContrId;
        controller.retURL = retURL;
        controller.getoppty();
        controller.initialize();
        controller.mySave();
        controller.Cancel();
        
        test.stopTest();
        }
    
    static testMethod void AssociationNegativeTest2() {
        
        setupdata();
         
        pref = Page.AssociateToNewRenewalOpty;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('selectedcontractid',conref.Id);
        ApexPages.currentPage().getParameters().put('oppId',opty.Id);
        test.startTest();
        
        Opportunity oppp = new Opportunity();
        oppp.Name='Test';
        ApexPages.StandardController std_controller = new ApexPages.StandardController(oppp); 
        ContractExtensionController controller = new ContractExtensionController(std_controller);  
        controller.ContID = ContrId;
        controller.retURL = retURL;
        controller.getoppty();
        controller.initialize();
        COTestClassUtility.ContractExtensionControllerTestVar1 = true;
        controller.mySave();
        controller.Cancel();
        
        test.stopTest();
        }
      
    static testMethod void AssociationNegativeTest3() {
        
        setupdata();
         
        pref = Page.AssociateToNewRenewalOpty;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('selectedcontractid',conref.Id);
        ApexPages.currentPage().getParameters().put('oppId',opty.Id);
        test.startTest();
        
        Opportunity oppp = new Opportunity();
        oppp.Name='Test';
        ApexPages.StandardController std_controller = new ApexPages.StandardController(oppp); 
        ContractExtensionController controller = new ContractExtensionController(std_controller);  
        controller.ContID = ContrId;
        controller.retURL = retURL;
        controller.getoppty();
        controller.initialize();
        COTestClassUtility.ContractExtensionControllerTestVar1 = false;
        COTestClassUtility.ContractExtensionControllerTestVar2 = true;
        controller.mySave();
        controller.Cancel();
        
        test.stopTest();
        }
        
    static testMethod void AssociationNegativeTest4() {
        
        setupdata();
         
        pref = Page.AssociateToNewRenewalOpty;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('selectedcontractid',conref.Id);
        ApexPages.currentPage().getParameters().put('oppId',opty.Id);
        test.startTest();
        
        Opportunity oppp = new Opportunity();
        oppp.Name='Test';
        ApexPages.StandardController std_controller = new ApexPages.StandardController(oppp); 
        ContractExtensionController controller = new ContractExtensionController(std_controller);  
        controller.ContID = ContrId;
        controller.retURL = retURL;
        controller.getoppty();
        controller.initialize();
        COTestClassUtility.ContractExtensionControllerTestVar1 = false;
        COTestClassUtility.ContractExtensionControllerTestVar2 = false;
        COTestClassUtility.ContractExtensionControllerTestVar3 = true;
        controller.mySave();
        controller.Cancel();
        
        test.stopTest();
        }
        
    static testMethod void AssociationNegativeTest5() {
        
        setupdata();
         
        pref = Page.AssociateToNewRenewalOpty;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('selectedcontractid',conref.Id);
        ApexPages.currentPage().getParameters().put('oppId',opty.Id);
        test.startTest();
        
        Opportunity oppp = new Opportunity();
        oppp.Name='Test';
        ApexPages.StandardController std_controller = new ApexPages.StandardController(oppp); 
        ContractExtensionController controller = new ContractExtensionController(std_controller);  
        controller.ContID = ContrId;
        controller.retURL = retURL;
        controller.getoppty();
        controller.initialize();
        COTestClassUtility.ContractExtensionControllerTestVar1 = false;
        COTestClassUtility.ContractExtensionControllerTestVar2 = false;
        COTestClassUtility.ContractExtensionControllerTestVar3 = false;
        COTestClassUtility.ContractExtensionControllerTestVar4 = true;
        controller.mySave();
        controller.Cancel();
        
        test.stopTest();
        }
      static testMethod void AssociationNegativeTest() {
      
      setupdata();
      
       pref = Page.AssociateToNewRenewalOpty;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('selectedcontractid',conref.Id);
        ApexPages.currentPage().getParameters().put('oppId',opty.Id);
       Opportunity oppp = new Opportunity();
      oppp.Name='Test';
      ApexPages.StandardController std_controller = new ApexPages.StandardController(oppp); 
      ContractExtensionController controller = new ContractExtensionController(std_controller); 
        controller.ContID = ContrId; 
        controller.Oppty.name=null;
        controller.mySave();
      }
       
}