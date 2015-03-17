/***********************************************************
* Class Name: PartnerCollabACPUtilTest
* Author: Accenture
* Date: 26-JULY-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for PartnerCollabACPUtil class.
***********************************************************/

@isTest(SeeAllData=true)
private class PartnerCollabACPUtilTest {
    static Account accPart = new Account();
    static Account accPart2 = new Account();
    static Account accCust = new Account();
    static Sales_Territory__c partSalesTerr;
    static Sales_Territory__c partSalesTerr2;
    static Sales_Territory_Account_Assignment__c SalesTrrtyAccAsgn;
    static Product_Specialty_User_Assignment__c psua;
    static Product_Specialty_User_Assignment__c psua2;
    static Sales_Territory_User_Assignment__c stua;
    static Sales_Territory_User_Assignment__c stua2;
    static Sales_Territory_User_Assignment__c stua3;
    static Opportunity opptyTest;
    static Channel_Partner__c chhPart;
    static Channel_Partner__c chhPart2;
    private static Product2 objProduct;
    private static PricebookEntry priceEntry;
    private static Location__c newLoc1;
    private static User u;
    
    //setup your test data in this method
   private static void setupData() {
        Id RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Opportunity','Standard');
        String RecordTypeName = RecordTypeIdHelper.getRecordTypeName('Opportunity',RecordTypeId);
        
        accPart = TestingSetupDataUtil.createAccount('partAcc', 'partAcc@partnerTest.com', 'Partner');
        accPart2 = TestingSetupDataUtil.createAccount('partAcc1', 'partAcc@partnerTest.com', 'Partner');
        accCust = TestingSetupDataUtil.createAccount('custAcc', 'custAcc@custTest.com', 'Customer');
        
        insert accPart;
        insert accPart2;
        insert accCust;
        accPart.isPartner = true;
        accPart.Alliance_Partner_Flag__c = true;
        accPart.Alliance_Partner_Flag__c = true;
        update accPart;
        accPart2.isPartner = true;
        update accPart2;
        
        partSalesTerr = new Sales_Territory__c();
        partSalesTerr.isPartner__c = true;
        partSalesTerr.OwnerId = userInfo.getUserId();
        partSalesTerr.Opportunity_Access__c = 'Read';
        partSalesTerr.Name = accPart.Name;
        partSalesTerr.IsPartner__c = true;
        partSalesTerr.IsActive__c = true;
        partSalesTerr.Case_Access__c = 'Read';
        partSalesTerr.Account_Access__c = 'Read';
        partSalesTerr.MyComp_Sales_Territory_Name__c = 'ST-TerrTest';
        insert partSalesTerr;
        
        set<id> grpid = new set<id>();
        grpid.add(partSalesTerr.GroupID__c);
        SalesTrrtyAccAsgn = new Sales_Territory_Account_Assignment__c();
        SalesTrrtyAccAsgn.Account__c = accPart.ID;
        SalesTrrtyAccAsgn.Sales_Territory__c = partSalesTerr.Id;
        insert SalesTrrtyAccAsgn;
        
       
        
        
       //Nasir Test method
       
      
        u= new User(alias = 'standt',EmployeeNumber='21860097',Legacy_Employee_Ref__c='21860097', email='standarduser@hp.com',Email_Address__c='usrte@hp.com',emailencodingkey='UTF-8', lastname='lastname', languagelocalekey='en_US',
                             localesidkey='en_US',Proudct_speciality__c='test', profileid =Userinfo.getProfileId(),timezonesidkey='America/Los_Angeles', username='produs@hp.com',Adoption_Role_Type__c = 'Account Executive'); 
        Insert u;

        /*stua= new Sales_Territory_User_Assignment__c(Sales_Territory__c=partSalesTerr.id,
                                                                      User__c=u.id,IsActive__c=true);
        insert stua;*/   
        Pricebook2 prb1 = [select id from Pricebook2 where IsStandard = true];      
        Pricebook2 pb2= new Pricebook2(IsActive=true,Name='test');
        insert pb2;            
        
            objProduct=TestingSetupDataUtil.createProduct(true ,'testProduct3','USD',null);
            insert objProduct;
            objProduct.Product_Line__c='ProductLine';
            objProduct.Sub_Product_Line__c='SubProductLine';
            objProduct.Product_Level__c=2 ;
            objProduct.Business_Group__c='ES';
            objProduct.GBU__c='Application Services';
            objProduct.IsActive=true;
            update objProduct;
            
       /* objProduct = [select Name,Product_Line__c,Sub_Product_Line__c,id from Product2 limit 1];
        priceEntry= [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id =:objProduct.id and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='USD'  limit 1];
        system.debug('a1a'+priceEntry);
        if(!priceEntry.IsActive){
            priceEntry.IsActive = true;
            update priceEntry;
        }  */
            priceEntry=TestingSetupDataUtil.createPricebookEntry(objProduct.Id,true,prb1.Id,1000,'USD');        
           insert priceEntry;
        Product_Specialty__c s= new Product_Specialty__c(Name='test');
        insert s;
        
        Product_Specialty_Definition__c psd= new Product_Specialty_Definition__c(Route__c='ALL',Opportunity_Type__c='ALL',
                                                Product__c=objProduct.id,Product_Specialty__c=s.id);
        insert psd;
        psua= new Product_Specialty_User_Assignment__c(User__c=u.Id,
                                                Product_Specialty__c=s.id);
        insert psua;  

       
        
        opptyTest = TestingSetupDataUtil.createOpportunity(string.valueOf(accCust.id),'opptyTest', system.today()+ 30);
        opptyTest.Type='New Business';
        opptyTest.Route_To_Market__c='Direct';
        insert opptyTest;    
       
        newLoc1=new Location__c(Name='33586574',Account__c=accPart2.Id);
       Insert newLoc1;  
       
         
        
     }
     
    //Method for Positive test
    private static testMethod void PositiveTest() {
        Test.startTest();
        
        setupData();
        
        Location__c newLoc2=new Location__c(Name='33586574',Account__c=accPart.Id);
       Insert newLoc2; 
        
        chhPart = new Channel_Partner__c();
        chhPart.Channel_Partner__c = accPart.Id;
        chhPart.Opportunity__c = opptyTest.Id;
        chhPart.Location__c = newLoc2.Id;
        insert chhPart;
        //nasir start

          OpportunityLineItem oli= new OpportunityLineItem(OpportunityId=opptyTest.id,PricebookEntryId=priceEntry.id,
                                        UnitPrice=90.00,Quantity=21,ServiceDate=system.today().addDays(1) ); 
        insert oli; 
        system.debug('a1b'+oli);    
        
        Product_Specialty_Oppty_Assignment__c psoa= new Product_Specialty_Oppty_Assignment__c(Opportunity__c=opptyTest.id,
                                            Product_Specialty_User_Assignment__c=psua.id); 
        insert psoa;                                                          
        
        
        
        delete chhPart;       
        Test.stopTest();
    }

    //Method for Negative test
    private static testMethod void NegativeTest() {
        Test.startTest();
        setupData(); 
        //Nasir start 
       
        Sales_Territory_Location_Assignment__c stla= new Sales_Territory_Location_Assignment__c(Location__c=newLoc1.id,Sales_Territory__c=partSalesTerr.id);
        insert stla;
       
        Sales_Territory_Account_Assignment__c staa3= new Sales_Territory_Account_Assignment__c(Account__c=accPart2.Id,
                                                Sales_Territory__c=partSalesTerr.id);
        insert staa3;
        
        chhPart = new Channel_Partner__c();
        chhPart.Channel_Partner__c = accPart2.Id;
        chhPart.Opportunity__c = opptyTest.Id;
        chhPart.Location__c=newLoc1.Id;
        insert chhPart;
               
        OpportunityLineItem oli= new OpportunityLineItem(OpportunityId=opptyTest.id,PricebookEntryId=priceEntry.id,
                                        UnitPrice=90.00,Quantity=21,ServiceDate=system.today().addDays(1) ); 
        insert oli; 
        system.debug('a1c'+oli);
        Product_Specialty_Oppty_Assignment__c psoa= new Product_Specialty_Oppty_Assignment__c(Opportunity__c=opptyTest.id,
                                            Product_Specialty_User_Assignment__c=psua.id); 
        insert psoa;                                                          
        
               delete staa3;
        
        
        // Nasir End
        Test.stopTest();
        
    }
    //Raghvendra:test coverage for ACP add/remove:start
   private static testMethod void addRemoveACPTest(){  
        Test.startTest();
        setupData(); 
        Sales_Territory_Location_Assignment__c stla= new Sales_Territory_Location_Assignment__c(Location__c=newLoc1.id,Sales_Territory__c=partSalesTerr.id);
        insert stla;
        OpportunityLineItem oli= new OpportunityLineItem(OpportunityId=opptyTest.id,PricebookEntryId=priceEntry.id,
                                        UnitPrice=90.00,Quantity=21,ServiceDate=system.today().addDays(1) ); 
        insert oli;
        
        stua= new Sales_Territory_User_Assignment__c(Sales_Territory__c=partSalesTerr.id,
                                                                      User__c=u.id,IsActive__c=true);
        insert stua; 
        
        test.stopTest();
        Channel_Partner__c chhPartnr = new Channel_Partner__c();
        chhPartnr.Channel_Partner__c = accPart2.Id;
        chhPartnr.Opportunity__c = opptyTest.Id;
        chhPartnr.Location__c=newLoc1.Id;
        insert chhPartnr;
        
        Product_Specialty_Oppty_Assignment__c psoa= new Product_Specialty_Oppty_Assignment__c(Opportunity__c=opptyTest.id,
                                            Product_Specialty_User_Assignment__c=psua.id); 
        insert psoa; 
        Set<String> grpSet= new Set<String>();
        grpSet.add(partSalesTerr.GroupID__c);
        Map<id,Set<String>> opptyGroupIdSetMap = new Map<id,Set<String>>();
        opptyGroupIdSetMap.put(opptyTest.Id, grpSet);
        PartnerCollabACPUtil.removeOpptyShareToPartnersincremental(opptyGroupIdSetMap);
        PartnerCollabACPUtil.getExeFromBatchFlag();
        delete chhPartnr;
    }
    //private opty test 
    private static testMethod void addRemoveACPTest1(){  
        Test.startTest();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
        Account acc = new Account(Name='PrevLocTestAcc1',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true);
        insert acc;
        Location__c loc = new Location__c(Name='1500',Location_Name__c='Blr',Account__c = acc.id);
        insert loc;
        Group grp = new Group(Name='STerr-505799',Type='Regular');
        insert grp;
        Sales_Territory__c salesTerr = new Sales_Territory__c (Name='TestPreview1',Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit',IsConfidential__c=False,IsPartner__c=true,IsExternal__c = False,MyComp_Sales_Territory_Name__c = 'ST-TestTerrACP1',GroupID__c = grp.Id);
        insert salesTerr;
        Sales_Territory_Location_Assignment__c stla= new Sales_Territory_Location_Assignment__c(Location__c=loc.id,Sales_Territory__c=salesTerr.id);
        insert stla;
        //create customer account
        Account accCust1 = TestingSetupDataUtil.createAccount('custAcc', 'custAcc@custTest.com', 'Customer');
        Insert accCust1;
        
        Opportunity opptyTest2 = TestingSetupDataUtil.createOpportunity(accCust1.Id,'Opty99ZZ_952PM',System.Today()+30);        
        opptyTest2.Confidential__c = true;           
        insert opptyTest2; 
        
        Channel_Partner__c chhPartnr1 = new Channel_Partner__c();
        chhPartnr1.Channel_Partner__c = acc.Id;
        chhPartnr1.Opportunity__c = opptyTest2.Id;
        chhPartnr1.Location__c=loc.Id;
        insert chhPartnr1;
        test.stopTest();
    }

    //Raghvendra:test coverage for ACP add/remove:end
}