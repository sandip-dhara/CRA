/**
 *@author: rahul.kunal (Accenture)
 * This class contains unit tests for validating the behavior of Apex class OppLineItemTriggerController,ProductSpecialtyOpptyAsgnMnt,OppAccntTerrUser.
 * and Triggers: 
 *      1) OpportunityAfterUpdate
 *      2) OpportunityBeforeDelete
 *      3) OpportunityLineItemAfterDelete
 *      4) OpportunityLineItemAfterInsert
 *      5) OpportunityLineItemAfterUpdate    ::  Author HP
 */
@isTest (seeAllData = true)
private class OppLineItemTriggerControllerTest {
    
    private static Account acc;
    private static Opportunity opty;
    private static Pricebook2 price;
    private static Product2 prod;
    
    private static PricebookEntry priceEntry;
    
    private static OpportunityLineItem OppLineItem;
    private static OpportunityLineItem OppLineItem1;
    private static OpportunityLineItem OppLineItem2;
    private static OpportunityLineItem OppLineItem3;
    private static OpportunityLineItem OppLineItem4;
    private static OpportunityLineItem OppLineItem5;
    private static OpportunityLineItem OppLineItem6;
    private static OpportunityLineItem OppLineItem7;
    private static Sales_Territory__c salesTerr;
    private static Sales_Territory_User_Assignment__c salesTerrUser;
    private static Sales_Territory_Account_Assignment__c salesTerrAcc;
    private static Product_Specialty__c prodSpclty;
    private static Product_Specialty_Definition__c prodSpcltyDef;
    private static Product_Specialty_User_Assignment__c prodSpcltyUser;
    private static Product_Specialty_Oppty_Assignment__c prodSpcltyOpty;
    private static User usr;
    private static Profile prof;
    private static AccountTeamMember accTeamMem;
    static contract_reference__c conref;
    static contract_reference__c conref1;
    static contract_reference__c conref2;
    static contract_reference__c conref3;
    static contract_reference__c conref4;
    static contract_reference__c conref5;
    static contract_reference__c conref6;
    static contract_reference__c conref7;
    
    /*
     * Method for creating test data.
     */
    private static void setUpData(){
        system.debug('Enter setUpData()');
        //Create a test account
        acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@hp.com','Customer');
        insert acc;
        //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        opty.Type = 'New Business';
        opty.Route_To_Market__c = 'Direct';
        insert opty;
        //create Contract Reference for ContractValueSumup Method Author HP
        conref = new contract_reference__c();{
        conref.name='Test_contract';
        conref.original_opportunity__c=opty.id;
        conref.accounts__c=acc.id;
        }
        insert conref;
                
        // create a test pricebook2
        price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        // create a test Product2
        prod = TestingSetupDataUtil.createProduct(true ,'abc','USD','1234');
        prod.Business_Group__c = 'ESSN';
        prod.GBU__c = 'Technology Support';
        prod.Product_Line__c = 'Technology Support PL';
        prod.Sub_Product_Line__c = 'Technology Support Sub-PL';
        insert prod;
        
        // create a test Product2
        priceEntry = TestingSetupDataUtil.createPricebookEntry(prod.Id,true,price.Id,100,'USD');
        insert priceEntry;
        
        // create a test Opportunity line item
        OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        //Assigning contract reference id in line item. Author HP
        OppLineItem.contract__c = conref.id;
                                        
        //create a test sales territroy record.
        salesTerr = new Sales_Territory__c(Name = 'testSalesTerritory', IsActive__c = true,MyComp_Sales_Territory_Name__c='Test');
        insert salesTerr;
        
        //Create test User
        usr = TestingSetupDataUtil.createUser('sabaTest','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','78678676',Userinfo.getProfileId());
        insert usr;
        
        //create user in sales terr
        salesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, User__c = usr.Id);
        insert salesTerrUser;
        
        //create a Sales Territory Account record
        salesTerrAcc = new Sales_Territory_Account_Assignment__c(Account__c = acc.Id, Sales_Territory__c = salesTerr.Id);
        insert salesTerrAcc;
        
        //Create record for AccountTeamMember
        accTeamMem = new AccountTeamMember(AccountId = acc.Id, UserId = usr.Id);
        insert accTeamMem;
        
        // create a test Specialty
        prodSpclty = new Product_Specialty__c(Name = 'testSpecialty');
        insert prodSpclty;
        
        //create a test record for Specialty Definition
        prodSpcltyDef = new Product_Specialty_Definition__c(Opportunity_Type__c = 'New Business', Route__c = 'Direct',  Product__c = prod.Id, Product_Specialty__c = prodSpclty.Id);
        insert prodSpcltyDef;
        
        //create a test record for Specialty User assignment
        prodSpcltyUser = new Product_Specialty_User_Assignment__c(Product_Specialty__c = prodSpclty.Id, User__c = usr.Id);
        insert prodSpcltyUser;        
        system.debug('Exit setUpData()');
    }

    static testMethod void insertSpcltyOpptyAssignmentPassTest() {
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        system.debug('Inside insertOLIPassTest');
        insert OppLineItem; 
                
        system.debug('>>>>>>OppLineItem '+OppLineItem);
        
        Product_Specialty_Oppty_Assignment__c psoa= new Product_Specialty_Oppty_Assignment__c(Opportunity__c=opty.id,
                                           Product_Specialty_User_Assignment__c=prodSpcltyUser.id); 
        insert psoa;  
        
        prodSpcltyOpty = [Select p.Product_Specialty_User_Assignment__c, p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p 
                                                               Where p.Opportunity__c =: opty.Id And p.Product_Specialty_User_Assignment__c =: prodSpcltyUser.Id];
        system.debug('>>>>>>som'+prodSpcltyOpty );                                                        
        system.assertEquals(opty.Id, prodSpcltyOpty.Opportunity__c);
        system.assertEquals(prodSpcltyUser.Id, prodSpcltyOpty.Product_Specialty_User_Assignment__c);
        
        /*OppLineItem = new OpportunityLineItem(Id = OppLineItem.Id,UnitPrice=1001);
        update OppLineItem;*/                                                               
    }
    
    static testMethod void deleteSpcltyOpptyAssignmentPassTest(){
        
        Test.startTest();
        setUpData();
        Test.stopTest();
            
        insert OppLineItem;
        
        delete OppLineItem;
        
        try{
            prodSpcltyOpty = [Select p.Product_Specialty_User_Assignment__c, p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p 
                                                                    Where p.Opportunity__c =: opty.Id And p.Product_Specialty_User_Assignment__c =: prodSpcltyUser.Id];
        }catch(Exception ex){
            system.debug('Exception While running deleteSpcltyOpptyAssignmentPassTest '+ex.getMessage());
            system.assert(ex.getMessage().contains('List has no rows for assignment to SObject'));
        }
    }
    
    static testMethod void updateOppRTMOTPassTest(){
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        insert OppLineItem;
        
        //create another user
        usr = TestingSetupDataUtil.createUser('rerdf','abc@hp.com','email2@salesforce.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest1@hp.com','78678678',Userinfo.getProfileId());
        insert usr;
        
        //Create record for AccountTeamMember
        accTeamMem = new AccountTeamMember(AccountId = acc.Id, UserId = usr.Id);
        insert accTeamMem;
        
        // create a test Specialty
        prodSpclty = new Product_Specialty__c(Name = 'testSpecialty1');
        insert prodSpclty;
        
        //create a test record for Specialty Definition
        prodSpcltyDef = new Product_Specialty_Definition__c(Opportunity_Type__c = 'Up Sell', Route__c = 'Indirect', Product__c = prod.Id, Product_Specialty__c = prodSpclty.Id);
        insert prodSpcltyDef;
        
        
        //create a test record for Specialty User assignment
        prodSpcltyUser = new Product_Specialty_User_Assignment__c(Product_Specialty__c = prodSpclty.Id, User__c = usr.Id);
        insert prodSpcltyUser;
        
        opty = new Opportunity(Id = opty.Id, Type = 'Up Sell', Route_To_Market__c = 'Indirect');
        update opty;
        
        prodSpcltyOpty = new Product_Specialty_Oppty_Assignment__c(Product_Specialty_User_Assignment__c =prodSpcltyUser.Id,Opportunity__c = opty.Id );
        insert prodSpcltyOpty;       
       
                                                                
        system.assertEquals(opty.Id, prodSpcltyOpty.Opportunity__c);
        system.assertEquals(prodSpcltyUser.Id, prodSpcltyOpty.Product_Specialty_User_Assignment__c);
    }
    
    static testMethod void deleteOpportunityPassTest(){
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        insert OppLineItem;
        
        delete opty;
        
        try{
            prodSpcltyOpty = [Select p.Product_Specialty_User_Assignment__c, p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p 
                                                                    Where p.Opportunity__c =: opty.Id And p.Product_Specialty_User_Assignment__c =: prodSpcltyUser.Id];
        }catch(Exception ex){
            system.debug('Exception While running deleteSpcltyOpptyAssignmentPassTest '+ex.getMessage());
            system.assert(ex.getMessage().contains('List has no rows for assignment to SObject'));
        }
    }
    
    /* Method to Test OpportunityLineItemAfterUpdate Trigger
       Author HP
    */   
    static testMethod void UpdateOpportunityPassTest(){
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
                
        conref1 = new contract_reference__c();{
        conref1.name='Test_contract';
        conref1.original_opportunity__c=opty.id;
        conref1.accounts__c=acc.id;
        conref1.Contract_Start_Date__c = date.newinstance(2013, 4, 17);
        conref1.Contract_End_date__c = date.newinstance(2013, 8, 20);
        }
        insert conref1;
        // create a second test Opportunity line item for Contract Value Sum Up Author HP.
        OppLineItem1 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,500,opty.id,priceEntry.id,System.Today()+40);
        //Assigning contract reference id in line item. Author HP
        {
        OppLineItem1.contract__c = conref1.id;
        }
        OppLineItem1.RTS_Component__c =null;
        Insert OppLineItem1;
        OppLineItem1.UnitPrice =500;
        
        Update OppLineItem1;
        
        
        Map<Id, OpportunitylineItem> mapopplineitem = new Map<Id, OpportunityLineItem>();
        mapopplineitem.put(OppLineItem1.Id,OppLineItem1);
        OppLineItemTriggerController.logOpptyIdfromOLIDel(mapopplineitem);
        
        conref1.Contract_Start_Date__c = date.newinstance(2013, 4, 17);
        conref1.Contract_End_date__c = date.newinstance(2013, 4, 20);
        Update OppLineItem1;
        
    }
    /*
    *    Method for creating data for Revenue Recognition calculations
    */
    private static void setUpSWContractSpecificData(){
        
        //create account for oppty
        acc = TestingSetupDataUtil.createAccount('testAccount_SWContract', 'testAccount_SWC@hp.com','Customer');
        insert acc;
        //create oppty
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty12345_Test',System.Today()+30);   
        opty.Type = 'Renewal';
        opty.Route_To_Market__c = 'Direct';
        insert opty;   
        
        List<contract_reference__c>  conList = new List<contract_reference__c>();
             
        
        //set up contracts
        // make contract for 6 months 12 months, 3 months, 9 months
        conref2 = new contract_reference__c();{
        conref2.name='Test_contract1';
        conref2.CurrencyIsoCode = 'USD';
        conref2.original_opportunity__c=opty.id;
        conref2.accounts__c=acc.id;
        conref2.Contract_Start_Date__c= System.Today();
        conref2.Contract_End_Date__c= System.Today().addMonths(2);
        }
        conList.add(conref2);
        //insert conref2;
        
        conref3 = new contract_reference__c();{
        conref3.name='Test_contract2';
        conref3.CurrencyIsoCode = 'USD';
        conref3.original_opportunity__c=opty.id;
        conref3.accounts__c=acc.id;
        conref3.Contract_Start_Date__c= System.Today();
        conref3.Contract_End_Date__c= System.Today().addMonths(3);
        }
        conList.add(conref3);
        //insert conref3;
        
        conref4 = new contract_reference__c();{
        conref4.name='Test_contract1';
        conref4.CurrencyIsoCode = 'USD';
        conref4.original_opportunity__c=opty.id;
        conref4.accounts__c=acc.id;
        conref4.Contract_Start_Date__c= System.Today().addDays(1);
        conref4.Contract_End_Date__c= System.Today().addDays(2);
        }
        conList.add(conref4);
        //insert conref4;
        
        conref5 = new contract_reference__c();{
        conref5.name='Test_contract1';
        conref5.CurrencyIsoCode = 'USD';
        conref5.original_opportunity__c=opty.id;
        conref5.accounts__c=acc.id;
        conref5.Contract_Start_Date__c= System.Today();
        conref5.Contract_End_Date__c= System.Today().addMonths(1);
        }
        conList.add(conref5);
        //insert conref5;
        
        conref6 = new contract_reference__c();{
        conref6.name='Test_contract1';
        conref6.CurrencyIsoCode = 'USD';
        conref6.original_opportunity__c=opty.id;
        conref6.accounts__c=acc.id;
        conref6.Contract_Start_Date__c= System.Today();
        conref6.Contract_End_Date__c= System.Today().addMonths(5);
        }
        conList.add(conref6);
        //insert conref6;
        
        conref7 = new contract_reference__c();{
        conref7.name='Test_contract1';
        conref7.CurrencyIsoCode = 'USD';
        conref7.original_opportunity__c=opty.id;
        conref7.accounts__c=acc.id;
        conref7.Contract_Start_Date__c= System.Today();
        conref7.Contract_End_Date__c= System.Today().addMonths(6);
        }
        conList.add(conref7);
        //insert conref7;
        insert conList;
        
        List<OpportunityLineItem> opplineList = new List<OpportunityLineItem>();
        
        // create a test Opportunity line item
        OppLineItem2 = TestingSetupDataUtil.createOpportunityLineItem(0,1,1400,opty.id,priceEntry.id,System.Today()+40);
        //Assigning contract reference id in line item.
        OppLineItem2.Contract__c = conref2.id;
        opplineList.add(OppLineItem2);
        //insert OppLineItem2;
        
        OppLineItem3 = TestingSetupDataUtil.createOpportunityLineItem(0,1,4430,opty.id,priceEntry.id,System.Today()+40);
        //Assigning contract reference id in line item. 
        OppLineItem3.Contract__c = conref3.id;
        opplineList.add(OppLineItem3);
        //insert OppLineItem3;
        
        OppLineItem4 = TestingSetupDataUtil.createOpportunityLineItem(0,1,1400,opty.id,priceEntry.id,System.Today()+40);
        //Assigning contract reference id in line item.
        OppLineItem4.Contract__c = conref4.id;
        opplineList.add(OppLineItem4);
        //insert OppLineItem4;
        
        OppLineItem5 = TestingSetupDataUtil.createOpportunityLineItem(0,1,1400,opty.id,priceEntry.id,System.Today()+40);
        //Assigning contract reference id in line item.
        OppLineItem5.Contract__c = conref5.id;
        opplineList.add(OppLineItem5);
        //insert OppLineItem5;
        
        OppLineItem6 = TestingSetupDataUtil.createOpportunityLineItem(0,1,1400,opty.id,priceEntry.id,System.Today()+40);
        //Assigning contract reference id in line item.
        OppLineItem6.Contract__c = conref6.id;
        opplineList.add(OppLineItem6);
        //insert OppLineItem6;
        
        OppLineItem7 = TestingSetupDataUtil.createOpportunityLineItem(0,1,1400,opty.id,priceEntry.id,System.Today()+40);
        //Assigning contract reference id in line item.
        OppLineItem7.Contract__c = conref7.id;
        opplineList.add(OppLineItem7);
        //insert OppLineItem7;
        
        insert opplineList;
        
        //OppLineItem2.Contract__c = conref8.id;
        //Update OppLineItem2;
       
    }
    
    static testMethod void updateCalculateMonthlyRevenueTest(){
        
        Test.startTest();
        setUpData();
        setUpSWContractSpecificData();      
        Test.stopTest();


        
    }
}