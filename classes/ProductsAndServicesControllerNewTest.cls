@isTest(seeAllData = true)
public class ProductsAndServicesControllerNewTest{

static Opportunity newOpp;
    static User portalUser;
    static List<PricebookEntry> listPrbEntry;                                                                                                    
    static List<OpportunityLineItem> listOpptyProduct;
    static List<OpportunityLineItem> listOpptyProduct1=new List<OpportunityLineItem>();
    static List<Product2> listProduct2;
    static set<Id> setOpptyProduct1= new set<Id>();
    static OpportunityLineItem newOppLineItem11;
    static List<PricebookEntry> listPrbEntry1;
    static Pricebook2 prb;
    
    private static void setupData() {
        listPrbEntry = new List<PricebookEntry>();
        listOpptyProduct = new List<OpportunityLineItem>(); 
        listOpptyProduct1 = new List<OpportunityLineItem>();
        listProduct2 = new List<Product2>();       
        Profile internalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%IT Administrator%' Limit 1];   
        UserRole testRole=[SELECT id from UserRole where portalrole =null  limit 1];
        User testUser = new User(ProfileId = internalProfile.id,
                LastName = 'Test13', 
                FirstName = 'Test13', 
                Username = '0testing13@hp.com', 
                Alias='test13', 
                CommunityNickname='test Approve13', 
                Email='test13@Hp.com',
                TimeZoneSidKey='America/Chicago',
                EmailEncodingKey='ISO-8859-1', 
                LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',
                IsActive=True,
                Email_Address__c='test13@hp.com',
                EmployeeNumber='653486625',
                Legacy_Employee_Ref__c='14875465',
                UserRoleId =testRole.id
                
        );
        testUser.Adoption_Role_Type__c='Account Executive';
        insert testUser; 
        //testUser.isportalEnabled=true;
        //update testUser;
        Contact contact1=null;
        Account newAccount=null;
        Campaign camp=null;
        Location__c newLocation=null;
        System.runAs(testUser){
            //Recordtype recordId=[Select Id,Name from recordtype where Name='Partner'];
            Id recordId=RecordTypeIdHelper.getRecordTypeId('Account','Partner');
            newAccount=new Account(Name='TestAccountForTestClass',RecordTypeId=recordId,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
            insert newAccount;
            newAccount.IsPartner=true;
            update newAccount;
            contact1 = new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccount.Id,Email = System.now().millisecond() + 'test@hp.com');
            insert contact1;
            UserLicense usr =[Select id from UserLicense where name='Gold Partner'];
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' and UserLicenseId=:usr.Id and UserType='PowerPartner' Limit 1];
             newLocation = new Location__c(Name='Testlocationname',Location_Name__c = 'Testlocationid');
            insert newLocation;
            portalUser = new User(ProfileId = portalProfile.id,ContactId=contact1.Id,LastName = 'Test1', FirstName = 'Test1', Username = '0testing4567@hp.com', Alias='test1', CommunityNickname='0test Approve1', Email='test1@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1@hp.com',EmployeeNumber='65348661',Legacy_Employee_Ref__c='10487547',Location_Record_Id__c=newLocation.id);
            portalUser.Adoption_Role_Type__c='Account Executive';
            //portalUser.isportalEnabled=true;
            Insert portalUser;
            portalUser.isportalEnabled=true;
            Update portalUser;
        }
        Profile prof = [select id from Profile where name='IT Administrator' limit 1];   
        User managerUser = new User(ProfileId = prof.id,LastName = 'TestManager',Manager__c='MGR',FirstName = 'TestManager', Username = '0testing456manager@hp.com', Alias='testm', CommunityNickname='test Approve manager', Email='testmanager@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=false,Email_Address__c='testmanager@hp.com',EmployeeNumber='65348661',Legacy_Employee_Ref__c='4875471');
        managerUser.Adoption_Role_Type__c='Account Executive'; 
        Insert managerUser ;
        User approverUser = new User(ProfileId = prof.id,LastName = 'Test',Manager__c='MGR',ManagerId=managerUser.id, FirstName = 'Test', Username = '0testing456@hp.com', Alias='test', CommunityNickname='test Approve', Email='test@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=false,Email_Address__c='test@hp.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='487547');
        approverUser.Adoption_Role_Type__c='Account Executive';
        Insert approverUser ;
        Id record=RecordTypeIdHelper.getRecordTypeId('Campaign','Partner Program');
        System.runAs(testUser){
            camp = new Campaign (Name='Partner for Growth Testing1',StartDate=system.today(),RecordTypeId=record,Level_1_Approver_1__c=approverUser.ID,Level_1_Approver_2__c=approverUser.ID,Level_1_Approver_3__c=approverUser.ID,Level_1_Approver_4__c=approverUser.ID,IsActive=True,All_Products_Eligible__c='No');
            insert camp ;
            
            prb=[select id from Pricebook2 where IsStandard = true];

            /*Inserting Products*/
            Product2 newPro1=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
            newPro1.Product_Line__c='Storage Essentials';
            newPro1.Sub_Product_Line__c='Storage Essentials';
            newPro1.Product_Level__c=2 ;
            newPro1.Business_Group__c='SW';
            newPro1.GBU__c='Application Services';
            newPro1.IsActive= true;
            listProduct2.add(newPro1);
            Product2 newPro2=TestingSetupDataUtil.createProduct(true ,'testProduct2','USD',null);
            listProduct2.add(newPro2);
            insert listProduct2;
            for(Product2 Pro : listProduct2){
                Pro.Business_Group__c = 'HP Software';
                Pro.GBU__c= 'Application Services';
                Pro.Product_Line__c= 'TF - IM Storage Essentials';
                Pro.Sub_Product_Line__c = 'TF - Storage Essentials';
                Pro.Service__c= true;
            }
            update listProduct2;
            Set<String> productList=new Set<String>();
            productList.add('TF - IM Storage Essentials');

            /*Inserting Pricebook*/
            Pricebook2 newBook=TestingSetupDataUtil.createPriceBook('Test Pricebook',true);
            insert newBook;

            /*Inserting Pricebook Entries*/
            PricebookEntry newEntry1=TestingSetupDataUtil.createPricebookEntry(newPro1.Id,true,prb.Id,100,'USD');               
            listPrbEntry.add(newEntry1);    

            PricebookEntry newEntry2=TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,prb.Id,100,'USD');                
            listPrbEntry.add(newEntry2);    

           // PricebookEntry newEntry3=TestingSetupDataUtil.createPricebookEntry(newPro1.Id,true,prb.Id,1000,'USD');        
            //listPrbEntry.add(newEntry3);

           // PricebookEntry newEntry4=TestingSetupDataUtil.createPricebookEntry(newPro2.Id,true,prb.Id,1000,'USD');                
            //listPrbEntry.add(newEntry4);  
            insert listPrbEntry;
        }
        System.runAs(portalUser){
            /*Insert Account and Opportunity*/
            Account newAcc =TestingSetupDataUtil.createAccount('MultiBGTest','test_22@hp.com','Customer');
            insert newAcc;
            Pricebook2 prb1 = [select id from Pricebook2 where IsStandard = true];
            Product2 newPro3=TestingSetupDataUtil.createProduct(true ,'testProduct3','USD',null);
            insert newPro3;
            newPro3.Product_Line__c='ProductLine';
            newPro3.Sub_Product_Line__c='SubProductLine';
            newPro3.Product_Level__c=2 ;
            newPro3.Business_Group__c='SW';
            newPro3.GBU__c='Application Services';
            newPro3.IsActive=true;
            update newPro3;
            Pricebook2 newprb2 = TestingSetupDataUtil.createPriceBook('Test Pricebook2',true);
            insert newprb2;
            
            listPrbEntry1 = new List<PricebookEntry>();
            PricebookEntry newEntry5=TestingSetupDataUtil.createPricebookEntry(newPro3.Id,true,prb1.Id,1000,'USD');        
            listPrbEntry1.add(newEntry5);
            //PricebookEntry newEntry6=TestingSetupDataUtil.createPricebookEntry(newPro3.Id,true,prb1.Id,1000,'USD');                
            //listPrbEntry1.add(newEntry6);  
            insert listPrbEntry1;

            //Opportunity newOpp1 = new Opportunity();
            newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOppty567', system.today()+ 30);
            insert newOpp;    
            //newOpp.pricebook2id = prb1.Id;
            //update newOpp;
            

            /*Insert two Opportunity Line Items*/
            newOppLineItem11 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry1[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
            //newOppLineItem11.icoem__c=true;
            //insert newOppLineItem11;
            listOpptyProduct1.add(newOppLineItem11);
            insert listOpptyProduct1; 
            //newOppLineItem11.PricebookEntryId=listPrbEntry1[0].Id;
            //update newOppLineItem11;
            //System.debug('++++'+ newOppLineItem11.Product_Line__C);
            setOpptyProduct1.add(listOpptyProduct1[0].Id);                                 
        }
        System.runAs(testUser){
            Program_Partner_Association__c  test4 = new Program_Partner_Association__c(Partner__c=newAccount.id,Program__c=camp.id);
            insert test4;

            //Product2 testing=[select Id from product2 where Product_Line__C=:'TF - IM Storage Essentials' Limit 1];
            product2 prodnew = new product2();
            prodnew.Name='TestProduct2';
            prodnew.Product_Line__c='ProductLine2';
            insert prodnew;
            //Campaign testCamp=[select id from Campaign where name=:'Partner for Growth Testing1' Limit 1];
            Program_Product_Association__c progProd = new Program_Product_Association__c();
            progProd.Product__c=prodnew.Id;
            progProd.Program__c=camp.id;
            insert progProd ;
            Campaign camp3 = new Campaign (Name='Partner for Growth TestCampaign',StartDate=system.today(),RecordTypeId=record,Level_1_Approver_1__c=approverUser.ID,IsActive=True,All_Products_Eligible__c='Yes');
            insert camp3 ;
            Program_Partner_Association__c  test3 = new Program_Partner_Association__c(Partner__c=newAccount.id,Program__c=camp3.id);
            insert test3;
            Program_Location_Association__c test5 = new Program_Location_Association__c(Program__c=camp3.id,Location__c=newLocation.id);
            insert test5;
        }
    }
   
   private static testMethod void productsAndServicesControllernewPositiveTest() {
           setupData();
        Test.startTest();
        /* Setting PageReference as relevant Page */
        PageReference pageRef = Page.ProductsAndServices;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('oppId',newOpp.Id);
        ApexPages.StandardController oli = new ApexPages.standardController(ListOpptyProduct1[0]);
        ProductsAndServicesControllerNew testConstructor=new ProductsAndServicesControllerNew();
        ProductsAndServicesControllerNew productsAndServicesControllerObj = new ProductsAndServicesControllerNew(oli);
        ProductsAndServicesControllerNew.wrapperLineItem wrapper=new ProductsAndServicesControllerNew.wrapperLineItem(newOppLineItem11,newOppLineItem11.PricebookEntry.Product2.Name,newOppLineItem11.PricebookEntry.Product2.Business_Group__c,newOppLineItem11.PricebookEntry.Product2.GBU__c,newOppLineItem11.PricebookEntry.Product2.Product_Line__c,newOppLineItem11.PricebookEntry.Product2.Sub_Product_Line__c,newOppLineItem11.PricebookEntry.Product2.Service__c,null,null,null);
        productsAndServicesControllerObj.newlyaddedlineitem=wrapper;
        productsAndServicesControllerObj.SearchGlobalBusinessUnit='IM';
        /* Calling Getter Methods */
        productsAndServicesControllerObj.BGPicklistvalues();
        productsAndServicesControllerObj.GBUPicklistvalues();
        productsAndServicesControllerObj.getBGPicklist1();
        productsAndServicesControllerObj.getGBUPicklist1();
        //productsAndServicesControllerObj.ProductLineIsEmpty();
        productsAndServicesControllerObj.productlinename=null;
        productsAndServicesControllerObj.SaveLinteItem();
        productsAndServicesControllerObj.opplineitem.pricebookEntryId=listPrbEntry[1].Id;
        productsAndServicesControllerObj.searchBusinessGroup='HP Software';
        productsAndServicesControllerObj.searchGlobalBusinessUnit='Application Services';
        productsAndServicesControllerObj.productlinename='TF - IM Storage Essentials';
        productsAndServicesControllerObj.subproductlinename='TF - Storage Essentials';
        productsAndServicesControllerObj.quantity=1;
        productsAndServicesControllerObj.opplineitem.UnitPrice=100;
        productsAndServicesControllerObj.opplineitem.ServiceDate=system.today()+ 36;
        productsAndServicesControllerObj.opplineitem.ICOEM__c=true;
        productsAndServicesControllerObj.SaveLinteItem();
        productsAndServicesControllerObj.getBGPicklistExist();
        productsAndServicesControllerObj.getGBUPicklistExist();
        productsAndServicesControllerObj.newOpptyStatistics();
        productsAndServicesControllerObj.getOpportunityLineItems();
        productsAndServicesControllerObj.displayRTSInfo();
        productsAndServicesControllerObj.setSortDirection('DESC');
        productsAndServicesControllerObj.getsearchExistingGlobalBusinessUnit();
        productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('test');  
        System.runAs(portalUser){
            productsAndServicesControllerObj.applyPrograms();
            productsAndServicesControllerObj.applyProgramVisibility();
            productsAndServicesControllerObj.ApplyProgramvisiblityForSave(setOpptyProduct1);
            productsAndServicesControllerObj.getProgram();
            List<ProductsAndServicesControllerNew.ProgramWrapper> testing=productsAndServicesControllerObj.programList;
            for(ProductsAndServicesControllerNew.ProgramWrapper test1:testing){
                test1.isSelected=True;
                test1.programComments='Testing';
            }
            try{
                productsAndServicesControllerObj.doSubmitBusinessUnit();
            }catch(Exception e){}
        }
       productsAndServicesControllerObj.applyPromotions();
        productsAndServicesControllerObj.doCancel();
        //productsAndServicesControllerObj.opptyAccess();
        productsAndServicesControllerObj.viewData();
        productsAndServicesControllerObj.getSortDirection();
        System.runAs(portalUser){
            productsAndServicesControllerObj.displayEsInfo();
            productsAndServicesControllerObj.clearAllSearch();
            productsAndServicesControllerObj.addRow();
            
            /* Covering All Search Criterias*/
            productsAndServicesControllerObj.searchExistingBusinessGroup = 'EB';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('IM');
            //productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.searchExistingProductLine = 'TF - IM Storage Essentials';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.searchExistingSubProductLine = 'TF - Storage Essentials';
            productsAndServicesControllerObj.getOpportunityLineItems();
            System.assertEquals(productsAndServicesControllerObj.existingLineItemList.size() == 0, false);
            productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('');
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('IM');
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.searchExistingProductLine = '';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('');
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.searchExistingBusinessGroup = '';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('IM');
            productsAndServicesControllerObj.searchExistingProductLine = 'TF - IM Storage Essentials';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.searchExistingProductLine = '';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('');
            productsAndServicesControllerObj.searchExistingProductLine = 'TF - IM Storage Essentials';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.searchExistingSubProductLine = '';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('IM');
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('');
            productsAndServicesControllerObj.searchExistingBusinessGroup = 'EB';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('IM');
            productsAndServicesControllerObj.searchExistingBusinessGroup = '';
            productsAndServicesControllerObj.searchExistingProductLine = '';
            productsAndServicesControllerObj.searchGlobalBusinessUnit='';
            productsAndServicesControllerObj.getOpportunityLineItems();
            productsAndServicesControllerObj.displayEsInfo();
            productsAndServicesControllerObj.EsSpecificFlag = true;
            productsAndServicesControllerObj.displayEsInfo();

            /* Covering the Clear All Methods*/
            productsAndServicesControllerObj.clearAllSearch();
            System.assertEquals(productsAndServicesControllerObj.isOrphanFlag, false);
            productsAndServicesControllerObj.clearAllFlags();
            System.assertEquals(productsAndServicesControllerObj.isOrphanFlag, false);
            productsAndServicesControllerObj.cancelUpdate();
            System.assertEquals(productsAndServicesControllerObj.isOrphanFlag, false);

            /* Covering All Sorting Methods*/
            productsAndServicesControllerObj.viewData();
            productsAndServicesControllerObj.setSortDirection('ASC');
            productsAndServicesControllerObj.getSortDirection();
            productsAndServicesControllerObj.setSortDirection('DESC');
            productsAndServicesControllerObj.getSortDirection();
            productsAndServicesControllerObj.sortExpression='';
            /*Covering Opportunity Access Related Methods*/
            productsAndServicesControllerObj.opptyAccess();

            /* Covering the AddRow Method*/
            productsAndServicesControllerObj.addRow();
            System.assertEquals(productsAndServicesControllerObj.newLineItemList.size() == 1, true);

            /* Covering the Delete Method*/
            productsAndServicesControllerObj.existingLineItemList[0].selected = true;
            //productsAndServicesControllerObj.deleteSelected();
            /* Covering the SaveInline Method for multiple scenarions*/      
            //productsAndServicesControllerObj.saveInline();      
            integer i;
            for(i=0;i<productsAndServicesControllerObj.existingLineItemList.size() -1 ;i++){
                productsAndServicesControllerObj.existingLineItemList[i].selected = true;
                productsAndServicesControllerObj.existingLineItemList[i].isNew = true;
                productsAndServicesControllerObj.existingLineItemList[i].oli.ICOEM__c= true;
                productsAndServicesControllerObj.existingLineItemList[i].pricebookEntryId = listPrbEntry[1].Id;
            }
            productsAndServicesControllerObj.saveInline();
            productsAndServicesControllerObj.deleteSelected();
            
            integer j;
            for(j=0;j<productsAndServicesControllerObj.existingLineItemList.size() -1 ;j++){
                productsAndServicesControllerObj.existingLineItemList[j].selected = true;
                productsAndServicesControllerObj.existingLineItemList[j].isNew = true;
                productsAndServicesControllerObj.existingLineItemList[j].pricebookEntryId = Null;
            }
             productsAndServicesControllerObj.saveInline();
            
           
            /* Successfully Saving New Line Item*/
            OpportunityLineItem newOppLineItem5 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
            productsAndServicesControllerObj.newLineItems.add(newOppLineItem5);                                           
            productsAndServicesControllerObj.saveNewProducts();
            //System.assertEquals(productsAndServicesControllerObj.isInsertedFlag, true);
            OpportunityLineItem newOppLineItem8 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
            productsAndServicesControllerObj.insertLineItems.add(newOppLineItem8); 
             productsAndServicesControllerObj.deleteAndAssociate();
            //System.assertEquals(productsAndServicesControllerObj.isInsertAfterDeleteFlag, true);
           /* productsAndServicesControllerObj.insertLineItems.clear();
            productsAndServicesControllerObj.deleteAndInsertLineItems.clear();
            OpportunityLineItem newOppLineItem9 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[0].Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
            productsAndServicesControllerObj.insertLineItems.add(newOppLineItem9); 
            if(productsAndServicesControllerObj.existingLineItemList[0].oli.id!=null){
                productsAndServicesControllerObj.deleteAndInsertLineItems.add(productsAndServicesControllerObj.existingLineItemList[0].oli);
            }
            productsAndServicesControllerObj.associateAndDelete();
            productsAndServicesControllerObj.closeAllSearch();
            productsAndServicesControllerObj.Cancelsinglerow();
            productsAndServicesControllerObj.OnchangeofBG();
            productsAndServicesControllerObj.OnchangeOfGBU();
            productsAndServicesControllerObj.Clearquickaddsection();
            productsAndServicesControllerObj.changeGBUValues();
            productsAndServicesControllerObj.clearquickaddrecord();*/
            
            
           }
            Test.stopTest();
   }
   /*private static testMethod void productsAndServicesControllerNegativeTest() {
        setupData();
        Test.startTest(); 
        /* Setting PageReference as relevant Page
        PageReference pageRef = Page.ProductsAndServices;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('oppId',newOpp.Id);
        ApexPages.StandardController oli = new ApexPages.standardController(listOpptyProduct1[0]);
        ProductsAndServicesControllerNew productsAndServicesControllerObj = new ProductsAndServicesControllerNew(oli);
        //ProductsAndServicesControllerNew.wrapperLineItem wrapper=new ProductsAndServicesControllerNew.wrapperLineItem(Null,null,newOppLineItem11.PricebookEntry.Product2.Business_Group__c,newOppLineItem11.PricebookEntry.Product2.GBU__c,newOppLineItem11.PricebookEntry.Product2.Product_Line__c,newOppLineItem11.PricebookEntry.Product2.Sub_Product_Line__c,newOppLineItem11.PricebookEntry.Product2.Service__c,null,null,null);
        //productsAndServicesControllerObj.newlyaddedlineitem=wrapper;
        productsAndServicesControllerObj.getOpportunityLineItems();
        productsAndServicesControllerObj.setSortDirection('ASC');
        productsAndServicesControllerObj.setsearchExistingGlobalBusinessUnit('IM');

        //productsAndServicesControllerObj.partnerUser=newOpp.owner;
        //productsAndServicesControllerObj.portalUser=newOpp.owner;
        /* Scenario if any method is called without selecting any Line Item 
        System.runAs(portalUser){
        productsAndServicesControllerObj.quantity=1;
        productsAndServicesControllerObj.productlinename='test';
        productsAndServicesControllerObj.opplineitem.OpportunityId=newOpp.id;
        productsAndServicesControllerObj.opplineitem.Quantity=1;
        productsAndServicesControllerObj.opplineitem.UnitPrice=1;
        productsAndServicesControllerObj.opplineitem.ServiceDate=system.today()+ 31;
        productsAndServicesControllerObj.opplineitem.pricebookEntryId=listPrbEntry1[0].Id;
        productsAndServicesControllerObj.searchBusinessGroup='test';
        productsAndServicesControllerObj.searchGlobalBusinessUnit ='test';
        productsAndServicesControllerObj.SaveLinteItem();
       }
        productsAndServicesControllerObj.saveInline();
        System.assertEquals(productsAndServicesControllerObj.isOrphanFlag, true);
        productsAndServicesControllerObj.deleteSelected();
        System.assertEquals(productsAndServicesControllerObj.isOrphanFlag, true);

        productsAndServicesControllerObj.searchExistingBusinessGroup = 'test';        
        productsAndServicesControllerObj.searchExistingProductLine= 'test';
        productsAndServicesControllerObj.searchExistingSubProductLine= 'test';
        productsAndServicesControllerObj.sortFullExp= '';        
        productsAndServicesControllerObj.getOpportunityLineItems();
        
        productsAndServicesControllerObj.searchExistingBusinessGroup = 'test';        
        productsAndServicesControllerObj.searchExistingProductLine= 'test';
        productsAndServicesControllerObj.searchExistingSubProductLine=null;
        productsAndServicesControllerObj.sortFullExp= '';        
        productsAndServicesControllerObj.getOpportunityLineItems();
        
        productsAndServicesControllerObj.searchExistingBusinessGroup = 'test';        
        productsAndServicesControllerObj.searchExistingProductLine=null;
        productsAndServicesControllerObj.searchExistingSubProductLine='test';
        productsAndServicesControllerObj.sortFullExp= '';        
        productsAndServicesControllerObj.getOpportunityLineItems();

        /*Covering failure of New Line Item to be inserted
        OpportunityLineItem newOppLineItem6 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[0].Id,
                Quantity = 11, UnitPrice = 10);
        productsAndServicesControllerObj.newLineItems.add(newOppLineItem6);                                              
        productsAndServicesControllerObj.saveNewProducts();
        // System.assertEquals(productsAndServicesControllerObj.isInsertFailureFlag, true);
        integer i;
        for(i=0;i<productsAndServicesControllerObj.existingLineItemList.size() -1 ;i++){
            productsAndServicesControllerObj.existingLineItemList[i].selected = true;
            productsAndServicesControllerObj.existingLineItemList[i].isNew = true;
            productsAndServicesControllerObj.existingLineItemList[i].pricebookEntryId = listPrbEntry[1].Id;
        }
        productsAndServicesControllerObj.saveInline();

        /*Covering failure of Association of New Line Item Failures
        OpportunityLineItem newOppLineItem7 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[0].Id,
                Quantity = 11, UnitPrice = 10);
        productsAndServicesControllerObj.insertLineItems.add(newOppLineItem7);
        // productsAndServicesControllerObj.deleteAndAssociate();
        System.assertEquals(productsAndServicesControllerObj.isInsertAfterDeleteFailureFlag, false);
        OpportunityLineItem newOppLineItem10 = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = listPrbEntry[0].Id,
                Quantity = 11, UnitPrice = 10);
        productsAndServicesControllerObj.insertLineItems.clear();
        productsAndServicesControllerObj.insertLineItems.add(newOppLineItem10);
        productsAndServicesControllerObj.associateAndDelete();
        System.assertEquals(productsAndServicesControllerObj.isInsertAfterDeleteFailureFlag, true);
    } */
}