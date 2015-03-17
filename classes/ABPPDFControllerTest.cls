@isTest
private class ABPPDFControllerTest {
    static Account account;
    static ABPBean abpBean;
    static ABPPdfController abpPdf;
    static Account_Plan__c accountPlan;
    static Strategic_Initiative__c stategic;
    static Customer_Business_Priority__c customer;
    static Business_Unit_Plan__c business;
    static Competitive_Landscape__c competitive;
    static Customer_Relationship_Map__c crm;
    
    
    /**
    * @description: Setting Test Data
    */
    private static void setupData() {
     /* Account */
    account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Customer');
        insert account ;
        System.assertEquals(account.Name,'testAccount1');
         /* Account_Plan */
        accountPlan= ABPTestingUtil.createAbpPlan('testAccount1',account.id,'USD');
        insert accountPlan;
        System.assertEquals(accountPlan.Name,'testAccount1');
        /* Strategic Initiative */ 
        stategic= ABPTestingUtil.createStategic(accountPlan.id,'testAccount1','USD');
        insert stategic;
        System.assertEquals(stategic.Name,'testAccount1');
       /* CustomerBusinessProrities */
        customer= ABPTestingUtil.createCBP(accountPlan.id,'testOppty','USD');
        insert customer;
        System.assertEquals(customer.Name,'testOppty');
        /* BusinessUnitPlans */
        business= ABPTestingUtil.createBusines('testBusiness','USD',accountPlan.id );
        insert business;
        System.assertEquals(business.Name,'testBusiness' );
        /* Competitive Landscape*/
        competitive= ABPTestingUtil.createCompetitive('USD',accountPlan.id);
        insert competitive;
        System.assertEquals(competitive.Account_Plan__c,accountPlan.id);
        /* Customer Relation Map*/
        crm= ABPTestingUtil.createCrm('USD',accountPlan.id);
        insert crm;
        System.assertEquals(crm.Account_Plan__c, accountPlan.id);
        
    }
    
    static testMethod void abpPdfPositiveTest() {
        /* Initializing test data */
        setupData();
        
        test.startTest();
        /* Testing Constructor */
        ApexPages.StandardController stdController = new ApexPages.StandardController(accountPlan);
        abpPdf = new ABPPdfController(stdController);
         abpBean=new ABPBean();
        abpPdf.getpdfData();
        abpBean.getinfluencer();
        abpBean.getcompetitive();
        abpBean.getcustomPriority();
        abpBean.getstategic();
        abpBean.getoptyst();
       test.stopTest();
    }
    }