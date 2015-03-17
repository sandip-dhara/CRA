@isTest(seeAllData=true)
public Class DGApprovalOpptyBusinessReviewTest
{

    public static Approval__c approval1,approval2,approval3;
    public static opportunity newOpp;
    public static Id rcdType1;
    public static OBR_Solution_Mix_Mapper__c solCustomSetting;
    public static List<Approval_Product_Classification__c> apcList;
    public static void setupData(){
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
        /*Insert Account and Opportunity*/
        Account newAcc=TestingSetupDataUtil.createAccount('ApprovalTestAccount','ApprovalfuncTest1@hp.com','Customer');
        newAcc.World_Region1__c=wr.id;
        insert newAcc;
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('Approut1','ApprovalfuncTest1@hp.com','ApprovalfuncTest2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','ApprovalfuncTest3@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='SW';
        user1.Adoption_Role_Type__c='Account Executive';
        insert user1;
        newOpp = new Opportunity();
        newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'OpptyApprovalfuncTest1', system.today()+ 30);
        newOpp.owner__c=user1.id; 
        newOpp.stageName=  '01 - Understand Customer';
        insert newOpp; 
         // create a test pricebook2
        Pricebook2 price = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        List<Product2> productList=new List<Product2>();
        // create a test Product2
        Product2 prod = TestingSetupDataUtil.createProduct(true ,'33-Technology Support PL','USD','1234');
        prod.Business_Group__c = 'HP Software';
        prod.GBU__c = 'IM';
        prod.Product_Line__c = '33-Technology Support PL';
        productList.add(prod);
        
        Product2 prod1 = TestingSetupDataUtil.createProduct(true ,'8A-Technology Support PL','USD','1234');
        prod1.Business_Group__c ='HP Software';
        prod1.GBU__c = 'IM';
        prod1.Product_Line__c = '8A-Technology Support PL';
        productList.add(prod1);
        
        Product2 prod2 = TestingSetupDataUtil.createProduct(true ,'T2-Technology Support PL','USD','1234');
        prod2.Business_Group__c = 'HP Software';
        prod2.GBU__c = 'IM';
        prod2.Product_Line__c = 'T2-Technology Support PL';
        prod2.Product_level__c = 3;
        productList.add(prod2);
        
        Product2 prod3 = TestingSetupDataUtil.createProduct(true ,'ST-Technology Support PL','USD','1234');
        prod3.Business_Group__c = 'HP Software';
        prod3.GBU__c = 'IM';
        prod3.Product_Line__c = 'ST-Technology Support PL';
        prod3.sub_Product_Line__c = 'ST-Technology Support PL';
        prod3.Product_level__c = 4;
        productList.add(prod3);
        
        Product2 prod4 = TestingSetupDataUtil.createProduct(true ,'2E-Technology Support PL','USD','1234');
        prod4.Business_Group__c = 'HP Software';
        prod4.GBU__c = 'IM';
        prod4.Product_Line__c = '2E-Technology Support PL';
        prod4.sub_Product_Line__c = '2E-Technology Support PL';
        prod4.Product_level__c = 4;
        productList.add(prod4);
        
        
        insert productList;
        
        List<PriceBookEntry> pbeList=new List<PriceBookEntry>();
        PriceBookEntry priceEntry = TestingSetupDataUtil.createPricebookEntry(productList[0].Id,true,price.Id,100,'USD');
        pbeList.add(priceEntry);
        PriceBookEntry priceEntry1 = TestingSetupDataUtil.createPricebookEntry(productList[1].Id,true,price.Id,100,'USD');
        pbeList.add(priceEntry1);
        PriceBookEntry priceEntry2 = TestingSetupDataUtil.createPricebookEntry(productList[2].Id,true,price.Id,100,'USD');
        pbeList.add(priceEntry2);
        PriceBookEntry priceEntry3 = TestingSetupDataUtil.createPricebookEntry(productList[3].Id,true,price.Id,100,'USD');
        pbeList.add(priceEntry3);
        PriceBookEntry priceEntry4 = TestingSetupDataUtil.createPricebookEntry(productList[4].Id,true,price.Id,100,'USD');
        pbeList.add(priceEntry4);
        insert pbeList;
        // create a test Opportunity line item
        List<opportunityLineItem> opLitemList=new List<opportunityLineItem>();
        opportunityLineItem OppLineItem = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,newOpp.id,pbeList[0].id,System.Today()+40);
        opLitemList.add(OppLineItem);
        opportunityLineItem OppLineItem1 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,newOpp.id,pbeList[1].id,System.Today()+40);
        opLitemList.add(OppLineItem1);
        opportunityLineItem OppLineItem2 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,newOpp.id,pbeList[2].id,System.Today()+40);
        opLitemList.add(OppLineItem2);
        opportunityLineItem OppLineItem3 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,newOpp.id,pbeList[3].id,System.Today()+40);
        opLitemList.add(OppLineItem3);
        opportunityLineItem OppLineItem4 = TestingSetupDataUtil.createOpportunityLineItem(10.00,1,1000,newOpp.id,pbeList[4].id,System.Today()+40);
        opLitemList.add(OppLineItem4);
        insert opLitemList;
        /* Approval Product Classification data  */
        apcList=new List<Approval_Product_Classification__c>();
        Approval_Product_Classification__c apc1=new Approval_Product_Classification__c();
        apc1.BG_Name__c='SW';
        apc1.Prod_Level__c='GBU';
        apcList.add(apc1);
        
        Approval_Product_Classification__c apc2=new Approval_Product_Classification__c();
        apc2.BG_Name__c='SW';
        apc2.Prod_Level__c='Product Line';
        apcList.add(apc2);
        
        Approval_Product_Classification__c apc3=new Approval_Product_Classification__c();
        apc3.BG_Name__c='SW';
        apc3.Prod_Level__c='Sub Product Line';
        apcList.add(apc3);
        insert apcList;
        
        /* creating Approval Product Classification item records  */
        List<Approval_Product_Classification_Item__c> apcItemList=new List<Approval_Product_Classification_Item__c>();
        Approval_Product_Classification_Item__c apci1=new Approval_Product_Classification_Item__c();
        apci1.Approval_Product_Classification__c=apcList[0].id;
        apci1.Solution_Mix__c='Product';
        apci1.Value__c='IM';
        apcItemList.add(apci1);
       
        
        Approval_Product_Classification_Item__c apci2=new Approval_Product_Classification_Item__c();
        apci2.Approval_Product_Classification__c=apcList[1].id;
        apci2.Solution_Mix__c='Product';
        apci2.Value__c='T2-Technology Support PL';
        apcItemList.add(apci2);
        
        Approval_Product_Classification_Item__c apci3=new Approval_Product_Classification_Item__c();
        apci3.Approval_Product_Classification__c=apcList[2].id;
        apci3.Solution_Mix__c='Product';
        apci3.Value__c='ST-Technology Support PL';
        apcItemList.add(apci3);
        insert apcItemList;
        
        /* inserting approval */
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Approval__c') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        List<Approval__c> listApproval = new List<Approval__c>();

        rcdType1= RecordTypeInfo.get('Opportunity Business Review').getRecordTypeId();
        approval1=new Approval__c();
        approval1.opportunity__c=newOpp.id;
        approval1.RecordTypeID=rcdType1;
        approval1.status__c='Open';
        approval1.solution_mix__c='None';
        listApproval.add(approval1);

        Id rcdType2= RecordTypeInfo.get('Opportunity Review').getRecordTypeId();
        approval2=new Approval__c();
        approval2.opportunity__c=newOpp.id;
        approval2.RecordTypeID=rcdType2;
        listApproval.add(approval2);
        insert listApproval;
        solCustomSetting=[select Solution_Mix_Level__c from OBR_Solution_Mix_Mapper__c  limit 1];

    }
    public Static testMethod void routingtest(){

        Test.startTest();
        setupData();
        PageReference pageNew=Page.DGApprovalBusinessReview;
        ApexPages.currentPage().getParameters().put('RecordType',rcdType1);
        ApexPages.currentPage().getParameters().put('id',newOpp.id);
        //ApexPages.currentPage().getParameters().put('AppId',approval1.id);
        DGApprovalBusinessReview dgappnew = new DGApprovalBusinessReview();
        dgappnew.initialize();
        dgappnew.customSave();
        dgappnew.fieldReadonly();
        dgappnew.SWSpecificSection();
        dgappnew.SoftwareSelection();
        dgappnew.ELAStructure();
        dgappnew.Cancel();
        
        dgappnew.solutionMix();
        Approval_Product_Classification_Item__c apci2=new Approval_Product_Classification_Item__c();
        apci2.Approval_Product_Classification__c=apcList[1].id;
        apci2.Solution_Mix__c='Service';
        apci2.Value__c='T2-Technology Support PL';
        insert apci2;
        dgappnew.solutionMix();
        
        solCustomSetting.Solution_Mix_Level__c='GBU';
        update solCustomSetting;
        dgappnew.solutionMix();
        Approval_Product_Classification_Item__c apci1=new Approval_Product_Classification_Item__c();
        apci1.Approval_Product_Classification__c=apcList[0].id;
        apci1.Solution_Mix__c='Service';
        apci1.Value__c='IM';
        insert apci1;
        
        dgappnew.solutionMix();
        solCustomSetting.Solution_Mix_Level__c='Sub Product Line';
        update solCustomSetting;
        dgappnew.solutionMix();
        Approval_Product_Classification_Item__c apci3=new Approval_Product_Classification_Item__c();
        apci3.Approval_Product_Classification__c=apcList[2].id;
        apci3.Solution_Mix__c='Service';
        apci3.Value__c='ST-Technology Support PL';
        insert apci3;
        dgappnew.solutionMix();
        
        ApexPages.currentPage().getParameters().put('AppId',approval1.id);
        DGApprovalBusinessReview dgappnew1 = new DGApprovalBusinessReview();
        dgappnew1.cancel();
        PageReference prefedit = Page.DGApprovalBusinessReviewEdit;
        test.setCurrentPage(prefedit); 
        //ApexPages.StandardController sc2 = new ApexPages.StandardController(approval1);
        //ApexPages.currentPage().getParameters().put('id',approval1.id);
        DGApprovalBusinessReviewEdit dgappedit = new DGApprovalBusinessReviewEdit();
        dgappedit.testclass();
        DGApprovalBusinessReviewNew dgappbusedit=new DGApprovalBusinessReviewNew();
        dgappbusedit.testclass();
        //dgappedit.customCancel();
       // dgappedit.onSave();
        
          
        
        ApexPages.StandardController sc3 = new ApexPages.StandardController(newOpp);
        ApexPages.currentPage().getParameters().put('RecordType',rcdType1);
        ApexPages.currentPage().getParameters().put('id',newOpp.id);
        DGApprovalOpptyReviewControllerNew dgappoppty = new DGApprovalOpptyReviewControllerNew(sc3);

        List<Opportunity_Pursuit_Resource_Requirement__c > listpurres = new List<Opportunity_Pursuit_Resource_Requirement__c >();
        Opportunity_Pursuit_Resource_Requirement__c opppurres =new Opportunity_Pursuit_Resource_Requirement__c(Pursuit_Team_Name_Role__c='Specialist',Approval__c=approval2.id);
        listpurres.add(opppurres);
        insert listpurres;
        DGApprovalOpptyReviewControllerNew.PersuitResourceWrapperClass prw = new DGApprovalOpptyReviewControllerNew.PersuitResourceWrapperClass(opppurres); 
        dgappoppty.PersuitResourceWrapper.add(prw);
        
        dgappoppty.addRow();
        dgappoppty.getPersuitResourceWrapper(); 
        PageReference pref = Page.DGApprovalOpportunityReviewNew;
        pref.getParameters().put('delrowindex', '1'); 
        test.setCurrentPage(pref);
        dgappoppty.removeOffRow();
        dgappoppty.customSave();
        
        ApexPages.StandardController sc4 = new ApexPages.StandardController(approval2); 
        ApexPages.currentPage().getParameters().put('id',approval2.id);         
        DGApprovalOpptyReviewControllerDtlEdit dgappopptyedit = new DGApprovalOpptyReviewControllerDtlEdit(sc4);
        PageReference pref1 = Page.DGApprovalOpportunityReviewDetail;
        test.setCurrentPage(pref1); 
        dgappopptyedit.customEditOR();
        PageReference pref2 = Page.DGApprovalOpportunityReviewDetail;
        pref2.getParameters().put('delrowindex', '1'); 
        test.setCurrentPage(pref2); 
        dgappopptyedit.addRow();
        dgappopptyedit.getPersuitResourceWrapper();     
        dgappopptyedit.removeOffRow();
        dgappopptyedit.customSave();      
        dgappopptyedit.customCancel();
        Attachment att=new Attachment ();
        boolean isChecked=True;
        Decimal versionNumber=1.00;
        String checkedOutBy='Test@hp.com';
        DGApprovalOpptyReviewControllerDtlEdit.AttachWrapper dgattwra=new DGApprovalOpptyReviewControllerDtlEdit.AttachWrapper(att,isChecked,checkedOutBy,versionNumber);
       
        
        
        PageReference pref3 = Page.UploadAttachment;
        Apexpages.currentpage().getParameters().put('Approvalid', approval1.id); 
        Apexpages.currentpage().getParameters().put('page','DGApprovalOpportunityReviewDetail');
        AttachmentController attcon= new AttachmentController(); 
        
        /*test.setCurrentPage(pref3); 
        Attachment att=new Attachment(parentId =approval1.id,description='descriptiontrest',body=blob.valueOf('Test'),name='Test');
        attcon.allFileList.add(att);
        attcon.Cancel();
        attcon.SaveAttachments(); */
        Test.stopTest();
    }
}