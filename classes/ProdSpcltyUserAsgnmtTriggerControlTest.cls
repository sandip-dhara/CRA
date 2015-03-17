/**
 * This class contains unit tests for validating the behavior of Apex class ProdSpcltyUserAsgnmtTriggerController.
 * and Triggers: 
 *      1) ProductSpecialtyUserAssignmentBeforeInsert.
 *      2) ProductSpecialtyUserAssignmentBeforeDelete.
 *      3) ProductSpecialtyUserAssignmentBeforeUpdate.
 *      4) ProductSpecialtyUserAssignmentAfterInsert.
 *      5) ProductSpecialtyUserAssignmentAfterUpdate.
 */
@isTest (seeAllData = true)
global class ProdSpcltyUserAsgnmtTriggerControlTest {
    
    private static Account acc;
    private static Opportunity opty;
    private static Pricebook2 price;
    private static Product2 prod;
    private static Product2 objProduct;
    private static PricebookEntry priceEntry;
    private static OpportunityLineItem OppLineItem;
    private static Sales_Territory__c salesTerr;
    private static Sales_Territory_User_Assignment__c salesTerrUser;
    private static Sales_Territory_Account_Assignment__c salesTerrAcc;
    private static Product_Specialty__c prodSpclty;
    private static Product_Specialty_Definition__c prodSpcltyDef;
    private static Product_Specialty_User_Assignment__c prodSpcltyUser;
    private static Product_Specialty_Oppty_Assignment__c prodSpcltyOpty;
    private static User usr;
    private static AccountTeamMember accTeamMem;
    //TM:Debmalya:Adding Test Coverage
    global static OpportunityLineItem OppLineItemglobal;
    
    /*
     * Method for creating test data.
     */
    global static void setUpData(){
        system.debug('Enter setUpData()');
        //Create a test account
        acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
        insert acc;
        //create a test opportunity
        opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        opty.Type = 'New Business';
        opty.Route_To_Market__c = 'Direct';
        insert opty;
        
        // create a test pricebook2
        price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        system.debug('***Deb***' + price ); 
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
        
        objProduct = [select Name,id from Product2 limit 1];
        objProduct.Business_Group__c = 'ESSN';
        objProduct.GBU__c = 'Technology Support';
        objProduct.Product_Line__c = 'Technology Support PL';
        objProduct.Sub_Product_Line__c = 'Technology Support Sub-PL';
        update objProduct;
        /*
        priceEntry= [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id =:objProduct.id and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='USD'  limit 1];
        if(!priceEntry.IsActive){
          priceEntry.IsActive = true;
          update priceEntry;
        }
        */
        // create a test Opportunity line item
        OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,opty.id,priceEntry.id,System.Today()+40);
        
        //TM:Debmalya:Adding Test Coverage
        OppLineItemglobal = OppLineItem;
        
        //create a test sales territroy record.
        salesTerr = new Sales_Territory__c(Name = 'testSalesTerritory', IsActive__c = true,MyComp_Sales_Territory_Name__c='test');
        insert salesTerr;
        
        
        //Create test User
        usr = TestingSetupDataUtil.createUser('test','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','abc123@hp.com','78678678',Userinfo.getProfileId());
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
        prodSpcltyDef = new Product_Specialty_Definition__c(Opportunity_Type__c = 'ALL', Route__c = 'ALL',  Product__c = objProduct.Id, Product_Specialty__c = prodSpclty.Id);
        insert prodSpcltyDef;
        
        //create a test record for Specialty User assignment
        prodSpcltyUser = new Product_Specialty_User_Assignment__c(Product_Specialty__c = prodSpclty.Id, User__c = usr.Id);
        insert prodSpcltyUser;
        system.debug('Exit setUpData()');
    }

    static testMethod void insertSpcltyUserPassTest() {
        
        Test.startTest();
        setUpData();
        //insert OppLineItem; 
        Test.stopTest();
        
        //insert OpportunityLineItem
        /*insert OppLineItem; 
        
        //Create test User
        usr = TestingSetupDataUtil.createUser('test1','abc1@testab.com','email2@testab.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','abc124@ca.com','78678679',Userinfo.getProfileId());
        insert usr;
        
        salesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, User__c = usr.Id);
        insert salesTerrUser;
        
        //Create record for AccountTeamMember
        accTeamMem = new AccountTeamMember(AccountId = acc.Id, UserId = usr.Id);
        insert accTeamMem;
        
        //create a test record for Specialty User assignment
        prodSpcltyUser = new Product_Specialty_User_Assignment__c(Product_Specialty__c = prodSpclty.Id, User__c = usr.Id);
        insert prodSpcltyUser;
        
        prodSpcltyOpty = [Select p.Product_Specialty_User_Assignment__c, p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p 
                                                                Where p.Opportunity__c =: opty.Id And p.Product_Specialty_User_Assignment__c =: prodSpcltyUser.Id];
                                                                
        system.assertEquals(opty.Id, prodSpcltyOpty.Opportunity__c);
        system.assertEquals(prodSpcltyUser.Id, prodSpcltyOpty.Product_Specialty_User_Assignment__c);*/
        
    }
    
    static testMethod void deleteSpcltyUserPassTest() {
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        //insert OpportunityLineItem
        insert OppLineItem; 
        
        //Create test User
        usr = TestingSetupDataUtil.createUser('test2','abc3@hp.com','email3@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','abc125@hp.com','78678689',Userinfo.getProfileId());
        insert usr;
        
        salesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, User__c = usr.Id);
        insert salesTerrUser;
        
        //Create record for AccountTeamMember
        accTeamMem = new AccountTeamMember(AccountId = acc.Id, UserId = usr.Id);
        insert accTeamMem;
        
        //create a test record for Specialty User assignment
        prodSpcltyUser = new Product_Specialty_User_Assignment__c(Product_Specialty__c = prodSpclty.Id, User__c = usr.Id);
        insert prodSpcltyUser;
        
        delete prodSpcltyUser;
        
        try{
            prodSpcltyOpty = [Select p.Product_Specialty_User_Assignment__c, p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p 
                                                                    Where p.Opportunity__c =: opty.Id And p.Product_Specialty_User_Assignment__c =: prodSpcltyUser.Id];
        }catch(Exception ex){
            system.debug('Exception While running deleteSpcltyOpptyAssignmentPassTest '+ex.getMessage());
            system.assert(ex.getMessage().contains('List has no rows for assignment to SObject'));
        }
        
    }
    
    static testMethod void updateSpcltyUserPassTest() {
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        //insert OpportunityLineItem
        insert OppLineItem; 
        
        //Create test User
        usr = TestingSetupDataUtil.createUser('test3','abc4@hp.com','email4@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','abc126@hp.com','78678654',Userinfo.getProfileId());
        insert usr;
        
        salesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, User__c = usr.Id);
        insert salesTerrUser;
        
        //Create record for AccountTeamMember
        accTeamMem = new AccountTeamMember(AccountId = acc.Id, UserId = usr.Id);
        insert accTeamMem;
        
        //update a test record for Specialty User assignment
        prodSpcltyUser = new Product_Specialty_User_Assignment__c(Id = prodSpcltyUser.Id, Product_Specialty__c = prodSpclty.Id, User__c = usr.Id);
        update prodSpcltyUser;
        
        //prodSpcltyOpty = [Select p.Product_Specialty_User_Assignment__c, p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p 
                                                               // Where p.Opportunity__c =: opty.Id And p.Product_Specialty_User_Assignment__c =: prodSpcltyUser.Id];
                                                                
        //system.assertEquals(opty.Id, prodSpcltyOpty.Opportunity__c);
        //system.assertEquals(prodSpcltyUser.Id, prodSpcltyOpty.Product_Specialty_User_Assignment__c);
        
        /*
         * Check for Specialty Change as well.
         */
        
        //Create test User
        usr = TestingSetupDataUtil.createUser('test4','abc5@hp.com','email7@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','abc567@hp.com','12356745',Userinfo.getProfileId());
        insert usr;
        
        salesTerrUser = new Sales_Territory_User_Assignment__c(Sales_Territory__c = salesTerr.Id, User__c = usr.Id);
        insert salesTerrUser;
        
        //Create record for AccountTeamMember
        accTeamMem = new AccountTeamMember(AccountId = acc.Id, UserId = usr.Id);
        insert accTeamMem;
        
        //insert a test record for Specialty User assignment
        //prodSpcltyUser = new Product_Specialty_User_Assignment__c(Product_Specialty__c = prodSpclty.Id, User__c = usr.Id);
        //insert prodSpcltyUser;
        
        // create a test Specialty
        prodSpclty = new Product_Specialty__c(Name = 'testSpecialty1');
        insert prodSpclty;
        
        prodSpcltyUser = new Product_Specialty_User_Assignment__c(Id = prodSpcltyUser.Id, Product_Specialty__c = prodSpclty.Id, User__c = usr.Id);
        update prodSpcltyUser;
        
        try{
            prodSpcltyOpty = [Select p.Product_Specialty_User_Assignment__c, p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p 
                                                                    Where p.Opportunity__c =: opty.Id And p.Product_Specialty_User_Assignment__c =: prodSpcltyUser.Id];
        }catch(Exception ex){
            system.debug('Exception While running deleteSpcltyOpptyAssignmentPassTest '+ex.getMessage());
            system.assert(ex.getMessage().contains('List has no rows for assignment to SObject'));
        }
        
    }
    
    static testMethod void updateSpcltyPassTest() {
        
        //Test.startTest();
        setUpData();
        //Test.stopTest();
        
        User fetchedUser1 = [Select u.Proudct_speciality__c, u.Id From User u Where u.Proudct_speciality__c =: 'testSpecialty' limit 1];
        
        //system.assertEquals(usr.Id, fetchedUser1.Id);
        
        //update the Specialty
        prodSpclty = new Product_Specialty__c(Id = prodSpclty.Id, Name = 'testSpecialty1');
        update prodSpclty;
        
        User fetchedUser2 = [Select u.Proudct_speciality__c, u.Id From User u Where u.Proudct_speciality__c =: 'testSpecialty1' limit 1];
        //system.assertEquals(usr.Id, fetchedUser2.Id);
                                                                
    }
    
    static testMethod void userUniqueSpecialtyTest(){
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        //update the Specialty
        prodSpclty = new Product_Specialty__c(Name = 'testSpecialty2');
        insert prodSpclty;
        
        //insert the same user to some other Specialty
        prodSpcltyUser = new Product_Specialty_User_Assignment__c(Product_Specialty__c = prodSpclty.Id, User__c = usr.Id);
        try{
            insert prodSpcltyUser;
        }catch(Exception ex){
            system.assert(ex.getMessage().contains('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Record can not be saved. User already associated to Specialty:'));
        }
        
    }
    
    static testMethod void specialtyDefUniquenessTest(){
        
        Test.startTest();
        setUpData();
        Test.stopTest();
        
        try{
            //create a test record for Specialty Definition for same Specialty with different OT and RTM with same Product.
            prodSpcltyDef = new Product_Specialty_Definition__c(Opportunity_Type__c = 'New Business', Route__c = 'Direct',  Product__c = objProduct.Id, Product_Specialty__c = prodSpclty.Id);
            insert prodSpcltyDef;
        }catch(Exception exp){
            system.assert(exp.getMessage().contains('Insert failed. First exception on row 0; first error: '
                                                    +'FIELD_CUSTOM_VALIDATION_EXCEPTION,'
                                                    +' Definition for this Product is already present with Opportunity Type as ALL and Route To Market as ALL:'));
        }
        
        
        // create a test Specialty1
        prodSpclty = new Product_Specialty__c(Name = 'testSpecialty1');
        insert prodSpclty;
        
        //create a test record for Specialty Definition
        prodSpcltyDef = new Product_Specialty_Definition__c(Opportunity_Type__c = 'ALL', Route__c = 'Direct',  Product__c = objProduct.Id, Product_Specialty__c = prodSpclty.Id);
        insert prodSpcltyDef;
        
        try{
            //create a test record for Specialty Definition with other OT but with same RTM and Product.
            prodSpcltyDef = new Product_Specialty_Definition__c(Opportunity_Type__c = 'New Business', Route__c = 'Direct',  Product__c = objProduct.Id, Product_Specialty__c = prodSpclty.Id);
            insert prodSpcltyDef;
        }catch(Exception exp){
            system.assert(exp.getMessage().contains('Insert failed. First exception on row 0; first error: '
                                                    +'FIELD_CUSTOM_VALIDATION_EXCEPTION,'
                                                    +' Definition for this Product is already present with Opportunity Type as ALL'));
        }
        
        
        // create a test Specialty2
        prodSpclty = new Product_Specialty__c(Name = 'testSpecialty2');
        insert prodSpclty;
        
        //create a test record for Specialty Definition
        prodSpcltyDef = new Product_Specialty_Definition__c(Opportunity_Type__c = 'New Business', Route__c = 'ALL',  Product__c = objProduct.Id, Product_Specialty__c = prodSpclty.Id);
        insert prodSpcltyDef;
        
        try{
            //create a test record for Specialty Definition with other RTM but with same OT and Product.
            prodSpcltyDef = new Product_Specialty_Definition__c(Opportunity_Type__c = 'New Business', Route__c = 'Direct',  Product__c = objProduct.Id, Product_Specialty__c = prodSpclty.Id);
            insert prodSpcltyDef;
        }catch(Exception exp){
            system.assert(exp.getMessage().contains('Insert failed. First exception on row 0; first error: '
                                                    +'FIELD_CUSTOM_VALIDATION_EXCEPTION,'
                                                    +' Definition for this Product is already present with Route To Market as ALL'));
        }
        
        
    }
}