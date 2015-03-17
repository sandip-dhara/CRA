/***********************************************************
* Class Name: OpportunityLineItemTriggerControllerTest 
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* * Description: This class does the test coverage
*              for OpportunityLineItemTriggerController class.
***********************************************************/
@isTest
private class OpportunityLineItemTriggerControllerTest {
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
       
       
        Product2 newPro2=TestingSetupDataUtil.createProduct(true ,'testProduct3','USD',null);
        listProduct2.add(newPro2);
        insert listProduct2;
        
        /*Inserting Pricebook*/
        
        Pricebook2 newBook=TestingSetupDataUtil.createPriceBook('Test Pricebook',true);
        insert newBook;
        
        /*Inserting Pricebook Entries*/
       
         PricebookEntry newEntry1=TestingSetupDataUtil.createPricebookEntry(newPro1.Id,true,prb.Id,100,'USD');               
        listPrbEntry.add(newEntry1);    
       
           PricebookEntry newEntry2=TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,prb.Id,100,'USD');                
        listPrbEntry.add(newEntry2);    
       
         //PricebookEntry newEntry3=TestingSetupDataUtil.createPricebookEntry(newPro1.Id,true,newBook.Id,1000,'USD');        
        //listPrbEntry.add(newEntry3);

          //PricebookEntry newEntry4=TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,newBook.Id,1000,'USD');                
        //listPrbEntry.add(newEntry4);    
        insert listPrbEntry;
        
        /*Insert Account and Opportunity*/
        Account newAcc =TestingSetupDataUtil.createAccount('MultiBGTest','test_22@test.com','Customer');
        insert newAcc;
        
        newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOppty567', system.today()+ 30);
        insert newOpp;                                     
            
    }
/* This class Used to  test coverage  for OpportunityLineItemTriggerController class*/

    private static testMethod void opportunityLineItemTriggerControllerTest() {
        
        setupData();
        Test.startTest();
        /*Insert two Opportunity Line Items with Different Business Groups*/
        OpportunityLineItem newOppLineItem1 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[0].Id,
                                                     ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
        insert newOppLineItem1;
        OpportunityLineItem newOppLineItem2 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[1].Id,
                                                     ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
        insert newOppLineItem2;
        
        /*Check the value of Opportunity field 'has_Multi_BG_Products__c'*/
        newOpp = [SELECT has_Multi_BG_Products__c FROM Opportunity WHERE Id =:newOpp.id]; 
        System.assertEquals(newOpp.has_Multi_BG_Products__c, false);
        
        /*To cover the before update & after delete methods*/
        newOppLineItem2.Quantity = 10;
        update newOppLineItem2;
        delete newOppLineItem2;
        /*Check the value of Opportunity field 'has_Multi_BG_Products__c'*/
        newOpp = [SELECT has_Multi_BG_Products__c FROM Opportunity WHERE Id =:newOpp.id]; 
        System.assertEquals(newOpp.has_Multi_BG_Products__c, false);
        
        /*Insert List of Line Items with Different BG*/
        OpportunityLineItem newOppLineItem3 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[0].Id,
                                                     ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
        listOpptyProduct.add(newOppLineItem3);                                           
        OpportunityLineItem newOppLineItem4 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[1].Id,
                                                     ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);                                           
        listOpptyProduct.add(newOppLineItem4);
        insert listOpptyProduct;
        
        /*Check the value of Opportunity field 'has_Multi_BG_Products__c'*/
        newOpp = [SELECT has_Multi_BG_Products__c FROM Opportunity WHERE Id =:newOpp.id]; 
        System.assertEquals(newOpp.has_Multi_BG_Products__c, false);
        
        Test.stopTest();
    }
    
    public static String findRecordTypeId(String objectName, String recordTypeName) {
        String recordTypeId;
        if (objectName != null && objectName != '' && recordTypeName != null && recordTypeName != '') {
            
            list<RecordType> recordTypes = [Select SobjectType, Name, Id 
                                            From RecordType 
                                            where SobjectType = :objectName and Name = :recordTypeName];
            if (recordTypes.size() > 0) {
                recordTypeId = recordTypes[0].Id;
            }
        }
        return recordTypeId;
    }
}