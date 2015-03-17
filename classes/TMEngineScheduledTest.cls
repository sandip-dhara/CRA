/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=true)
private class TMEngineScheduledTest {

    static testMethod void engineScheduleTest() {
        
        test.startTest();
                
        /*TMEngineScheduledFlag__c obj = new TMEngineScheduledFlag__c();
            obj.SchedularFlag__c = false;
            obj.Name = 'SchedularFlagVal';
        insert obj;*/
        
        //TM:Debmalya:Insert World Region Data:Start
        /*World Region insert*/
        World_Region__c wrSReg1 = new World_Region__c(Name = 'North America', ParentName__c = 'Americas');
        insert wrSReg1;
        World_Region__c wrSReg2 = new World_Region__c(Name = 'United States Extended', ParentName__c = 'North America', ParentId__c = wrSReg1.Id);
        insert wrSReg2;
        World_Region__c wrSReg3 = new World_Region__c(Name = 'US', ParentName__c = 'United States Extended', ParentId__c = wrSReg2.Id, Country_Name__c = 'United States');
        insert wrSReg3;
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Americas';
        update Robj2;
        system.debug(Robj2.AccountRecordType__c);
        //TM:Debmalya:Insert World Region Data:End
        /* Account insert*/ 
        List<Account> accList = new List<Account>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        for(Integer i=0;i<20;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = true, ShippingPostalCode = '99999-9999', ShippingCountry = 'United States',
                                    MDCP_Organization_ID__c = '1234STR'+ i, Source_System_Account_ID__c = '54321STR'+ i, AMID_L2__c = 'A-12345');
            accList.add(acc) ;
        }
        insert accList;
        system.debug(accList[0].WorldRegion_Hierarchy__c);
        System.assertEquals(accList[0].Name,'testAccount0');
        
        //TM Schedular Test
        TMEngineSchelduled tm = new TMEngineSchelduled();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Schedular Test :'+datetime.now(), schExp, tm);
        
        test.stopTest();
    }
    
   static testMethod void industryRulesScheduledTest() {
        
        test.startTest();
        
        //TM:Debmalya:R3:Add Custom Settings Data:Start
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        //Wobj1.SchedularFlag__c = true;
        //TM:Sreenath:R4:modified Custom Settings Data:Start
          Wobj1.SchedularFlag__c = false;
        //TM:Sreenath:R4:Modified Custom Settings Data:End
        
        update Wobj1;
        //TM:Debmalya:R3:Add Custom Settings Data:End
        //TM:Sreenath:R4:Add Custom Settings Data:Start
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'None';
        update Robj2;
        //TM:Sreenath:R4:Add Custom Settings Data:End
        
        // Account insert
        List<Account> accList = new List<Account>();
        Set<Id> accSet = new Set<Id>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        for(Integer i=0;i<20;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = true,AccountProfileEvaluated__c=true, ShippingPostalCode = '99999-9999', ShippingCountry = 'US' , Industry_Vertical__c='CME');
            accList.add(acc) ;
        }
        insert accList;
        System.assertEquals(accList[0].Name,'testAccount0');
        
        for(Account aObj : accList){
            accSet.add(aObj.Id);
        }
       
        //TM Industry Rules Test       
        // Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Industry batch size').Batch_Size__c);
        
        //Id batchId = Database.executeBatch(new TMProcessIndustryRulesBatch(), batchSize);

        TMProcessIndustryRulesScheduled tm = new TMProcessIndustryRulesScheduled();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Industry Test :'+datetime.now(), schExp, tm);
        
        test.stopTest();
    }
    
    static testMethod void coverageRulesScheduleTest() {
        
        test.startTest();

        /* Account insert*/ 
        List<Account> accList = new List<Account>();
        Set<Id> accSet = new Set<Id>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        for(Integer i=0;i<20;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = true, AccountProfileEvaluated__c=true, Named_Account__c = 'IPG=N', ShippingPostalCode = '99999-9999', ShippingCountry = 'US');
            accList.add(acc) ;
        }
        insert accList;
        System.assertEquals(accList[0].Name,'testAccount0');
        
        for(Account aObj : accList){
            accSet.add(aObj.Id);
        }
        
        //TM Industry Rules Test
        TMProcessCoverageRulesSchedule tm = new TMProcessCoverageRulesSchedule();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Coverage Test :'+datetime.now(), schExp, tm);
        
        test.stopTest();
    }
    
   static testMethod void geoRulesScheduleTest() {
    
        test.startTest();
                
        /*TMEngineScheduledFlag__c obj = new TMEngineScheduledFlag__c();
            obj.SchedularFlag__c = true;
            obj.Name = 'SchedularFlagVal';
        insert obj;*/
        
        /* Account insert*/ 
        List<Account> accList = new List<Account>();
        Set<Id> accSet = new Set<Id>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        for(Integer i=0;i<20;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = true,AccountProfileEvaluated__c=true, ShippingPostalCode = '99999-9999', ShippingCountry = 'US');
            accList.add(acc) ;
        }
        insert accList;
        System.assertEquals(accList[0].Name,'testAccount0');
        
        for(Account aObj : accList){
            accSet.add(aObj.Id);
        }
        
        //TM Industry Rules Test
        TMProcessGeoRulesSchedule tm = new TMProcessGeoRulesSchedule();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Coverage Test :'+datetime.now(), schExp, tm);
        
        test.stopTest();
        
    }
    
static testMethod void accountTeamScheduleTest() {
    
        test.startTest();
                
        /*TMEngineScheduledFlag__c obj = new TMEngineScheduledFlag__c();
            obj.SchedularFlag__c = true;
            obj.Name = 'SchedularFlagVal';
        insert obj;*/
        
        //TM:Debmalya:R3:Add Custom Schedule Data to add Code Coverage:Start
        TMEngineAccountRecordType__c obj = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj.AccountRecordType__c = 'Customer';
        update obj;
        
        //TM:Debmalya:R3:Add Custom Schedule Data to add Code Coverage:End
        /* Account insert*/ 
        List<Account> accList = new List<Account>();
        Set<Id> accSet = new Set<Id>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        
        
        for(Integer i=0;i<5;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = true, ShippingPostalCode = '99999-9999', ShippingCountry = 'US');
            accList.add(acc) ;
        }
        insert accList;
        System.assertEquals(accList[0].Name,'testAccount0');
        
        List<Sales_Territory__c> stList = new List<Sales_Territory__c>();
        for(Integer i=0; i<5; i++){
            Sales_Territory__c st = new Sales_Territory__c (Name='test ST' + i, IsActive__c=true, IsConfidential__c=true, EvaluateTerritory_for_Realignment__c = true,MyComp_Sales_Territory_Name__c='test');       
            stList.add(st);
        }
        insert stList;
        
        Sales_Territory_Account_Assignment__c staa = new Sales_Territory_Account_Assignment__c(Account__c = accList[0].Id,
                            Sales_Territory__c = stList[0].Id, Account_To_Territory_Id__c = ('' + accList[0].Id + '-' + stList[0].Id),
                            Assignment_Type__c = 'Territory Engine',AddToAccountProcess__c = true,TrackAssociationToDelete__c = false);
        insert staa;
        List<user> getUser =[select Id, IsActive from user where IsActive=:true limit 1];
        Sales_Territory_User_Assignment__c stua = new Sales_Territory_User_Assignment__c(Sales_Territory__c = stList[0].Id, User__c = getUser[0].Id,IsActive__c=true, Add_To_Account_Team__c = true, Account_Team_Role__c = 'Account Manager');
        insert stua;
               
        //TM Industry Rules Test
        TMAddToAccountTeamScheduler tm = new TMAddToAccountTeamScheduler();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Add to Account Test :'+datetime.now(), schExp, tm);
        
        test.stopTest();
        
    }
    //TM:Debmalya:R3:Coverage for Finish method for AddToAccountTeam Batch:Start
    static testMethod void accountTeamfinishRegAPJTest() {
    
        test.startTest();
        
        //TM:Debmalya:R3:Add Custom Schedule Data to add Code Coverage:Start
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'None';
        update Robj2;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    
    
    static testMethod void accountTeamfinishRegEMEATest() {
    
        test.startTest();
        
        //TM:Debmalya:R3:Add Custom Schedule Data to add Code Coverage:Start
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Asia Pacific';
        update Robj2;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    
    static testMethod void accountTeamfinishRegAMSTest() {
    
        test.startTest();
        
        //TM:Debmalya:R3:Add Custom Schedule Data to add Code Coverage:Start
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'EMEA';
        update Robj2;
        
        
        String QueryString =  'select id,EvaluateTerritory_for_Realignment__c  from Sales_Territory__c where EvaluateTerritory_for_Realignment__c = true';
        String param = 'false';
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        //Id batchId1 = Database.executeBatch(new EvaluateTerrRealignBatch(QueryString,param), 150);
        
        
        test.stopTest();
        
    }
    
    static testMethod void accountTeamfinishRegNoneTest() {
    
        test.startTest();
        
        //TM:Debmalya:R3:Add Custom Schedule Data to add Code Coverage:Start
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Americas';
        update Robj2;
        
        Sales_Territory__c st = new Sales_Territory__c (Name='test ST', IsActive__c=true, IsConfidential__c=true,EvaluateTerritory_for_Realignment__c = true,MyComp_Sales_Territory_Name__c='test');
        insert st;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    static testMethod void accountTeamfinishRegNonepartnerTest() {
    
        test.startTest();
        
        //TM:Debmalya:R3:Add Custom Schedule Data to add Code Coverage:Start
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'None';
        update Robj2;
        
        Sales_Territory__c st = new Sales_Territory__c (Name='test ST', IsActive__c=true, IsConfidential__c=true,EvaluateTerritory_for_Realignment__c = true,MyComp_Sales_Territory_Name__c='test');
        insert st;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
     /*static testMethod void accountTeamfinishRegNonepartnerAPJTest() {
    
        test.startTest();
        
        //TM:Debmalya:R3:Add Custom Schedule Data to add Code Coverage:Start
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Asia Pacific';
        update Robj2;
        
        Sales_Territory__c st = new Sales_Territory__c (Name='test ST', IsActive__c=true, IsConfidential__c=true,EvaluateTerritory_for_Realignment__c = true,MyComp_Sales_Territory_Name__c='test');
        insert st;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }*/
    
    static testMethod void accountTeamfinishSubRegTest() {
    
        test.startTest();
        
        //TM:Debmalya:R3:Add Custom Schedule Data to add Code Coverage:Start
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;

        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'EMEA';
        update Robj2;
        
        TMEngineAccountRecordType__c objSR = TMEngineAccountRecordType__c.getValues('Realignment_SubRegion1');
        objSR.AccountRecordType__c = 'CEE';
        update objSR;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    //Raghv:TMAddToAccountTeamPartnerTest:Start
    static testMethod void accountTeamfinishRegAmericasCustTest() {
    
        test.startTest();
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Americas';
        update Robj2;
        TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues(Label.SchedularFlagVal);
        obj.SchedularFlag__c = true;
        update obj;
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    static testMethod void accountTeamfinishRegAPJCustTest() {
    
        test.startTest();
        
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Asia Pacific';
        update Robj2;
        
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    static testMethod void accountTeamfinishRegEMEACustTest() {
    
        test.startTest();
        
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'EMEA';
        update Robj2;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    
 static testMethod void accountTeamfinishRegAmericasPrtnrTest() {
    
        test.startTest();
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Americas';
        update Robj2;
        TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues(Label.SchedularFlagVal);
        obj.SchedularFlag__c = true;
        update obj;
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    /*static testMethod void accountTeamfinishRegAPJPrtnrTest() {
    
        test.startTest();
        
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Asia Pacific';
        update Robj2;
        
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }*/
    /*static testMethod void accountTeamfinishRegEMEAPrtnrTest() {
    
        test.startTest();
        
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'EMEA';
        update Robj2;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }*/
    
    static testMethod void accountTeamfinishRegAmericasPrtnrTest1() {
    
        test.startTest();
        
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Americas';
        update Robj2;
        TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues(Label.SchedularFlagVal);
        obj.SchedularFlag__c = true;
        update obj;
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    static testMethod void accountTeamfinishRegAPJPrtnrTest1() {
    
        test.startTest();
        
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Asia Pacific';
        update Robj2;        
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    static testMethod void accountTeamfinishRegEMEAPrtnrTest1() {
    
        test.startTest();
        
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'EMEA';
        update Robj2;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    static testMethod void accountTeamfinishRegNonePrtnrTest1() {
    
        test.startTest();
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = false;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'None';
        update Robj2;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    
    static testMethod void accountTeamfinishRegNonePrtnrTest2() {
    
        test.startTest();
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'None';
        update Robj2;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    
    static testMethod void accountTeamfinishRegAmericasCustTest2() {
    
        test.startTest();
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Americas';
        update Robj2;
        
        TM_Suspend_APJ_Realignment__c ApjSuspendPartner = TM_Suspend_APJ_Realignment__c.getValues('APJSuspensionPartner');
        ApjSuspendPartner.Suspendflag__c = true;
        update ApjSuspendPartner;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    
     static testMethod void accountTeamfinishRegAmericasPartnerTest2() {
    
        test.startTest();
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'EMEA';
        update Robj2;
        
        TM_Suspend_APJ_Realignment__c AmsSuspendpartner = TM_Suspend_APJ_Realignment__c.getValues('AMSSuspensionPartner');
        AmsSuspendpartner.Suspendflag__c = true;
        update AmsSuspendpartner;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();
        
    }
    
    static testMethod void accountTeamfinishRegEMEAPartnerTest2() {
    
        test.startTest();
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'Asia Pacific';
        update Robj2;
        
        TM_Suspend_APJ_Realignment__c EmeaSuspendPartner = TM_Suspend_APJ_Realignment__c.getValues('EMEASupsensionPartner');
        EmeaSuspendPartner.Suspendflag__c = true;
        update EmeaSuspendPartner;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();  
    }
    static testMethod void accountTeamfinishRegAPJPartnerTest2() {
    
        test.startTest();
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        Wobj1.SchedularFlag__c = true;
        update Wobj1;
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'None';
        update Robj2;
        
        TM_Suspend_APJ_Realignment__c ApjSuspendPartner = TM_Suspend_APJ_Realignment__c.getValues('APJSuspensionPartner');
        ApjSuspendPartner.Suspendflag__c = true;
        update ApjSuspendPartner;
        
        //Run batch for AddToAccountTeamBatch
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Team batch size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMAddToAccountTeamBatch(), batchSize);
        
        test.stopTest();  
    }
    
    
    
    //Raghv:TMAddToAccountTeamTest:End
    
     //TM:Debmalya:R3:Coverage for Finish method for AddToAccountTeam Batch:Start
    static testMethod void BAmarketsegment() {
    
        test.startTest();
          /* Account insert*/ 
        List<Account> accList = new List<Account>();
        Set<Id> accSet = new Set<Id>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        for(Integer i=0;i<20;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = true, AccountProfileEvaluated__c=true, Named_Account__c = 'IPG=N', ShippingPostalCode = '99999-9999', ShippingCountry = 'US');
            accList.add(acc) ;
        }
        insert accList;
        System.assertEquals(accList[0].Name,'testAccount0');
        
        for(Account aObj : accList){
            accSet.add(aObj.Id);
        }
        //TM Industry Rules Test
        TMProcessBAMarketRulesScheduler tm = new TMProcessBAMarketRulesScheduler();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Coverage Test :'+datetime.now(), schExp, tm);
       
        test.stopTest();
        
    }
    //TM:Debmalya:R3:Coverage for Finish method for AddToAccountTeam Batch:End
    
    //TM:Debmalya: Test method for OpptyOutsideTerrBatch class:Start
    static testMethod void OpptyOutsideTerrBatTest() {
    
        test.startTest();
        
        /* Account insert*/ 
        Set<Id> accSet = new Set<Id>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        
        
        Account acc  = new Account(Name = 'testAccount', Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                        CurrencyIsoCode='USD', EvaluateTerritory__c = true, ShippingPostalCode = '99999-9999', ShippingCountry = 'US',
                        MDCP_Organization_ID__c = '1234STR');
        
        insert acc;
        System.assertEquals(acc.Name,'testAccount');
        //get Current User Info
        Id userId = UserInfo.getUserId();
        system.debug('Debmalya' + userId);
        
        String RecordTypeId1 = RecordTypeIdHelper.getRecordTypeId('Opportunity','Standard');
        system.debug(RecordTypeId1);
        //Create Opportunity Record
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'tarunOppty1',System.today().addMonths(1));
        opty.RecordTypeId = RecordTypeId1;
        opty.Customer_Engagement__c = 'Alliance';
        opty.Fulfillment__c = 'HP Fulfilled';
        insert opty;
        system.debug('Debmalya' + opty.Opportunity_Outside_Owner_s_Terr__c);
        system.debug('Debmalya' + opty.Owner);
        
        Sales_Territory__c st = new Sales_Territory__c (Name='test ST', IsActive__c=true, IsConfidential__c=true,MyComp_Sales_Territory_Name__c='test');
        insert st;
        
        Sales_Territory_Account_Assignment__c staa = new Sales_Territory_Account_Assignment__c(Account__c = acc.Id,
                            Sales_Territory__c = st.Id, Account_To_Territory_Id__c = ('' + acc.Id + '-' + st.Id),
                            Assignment_Type__c = 'Territory Engine',AddToAccountProcess__c = true,TrackAssociationToDelete__c = false);
        insert staa;
        
        //Create Sales Terr User Assignment Record
        Sales_Territory_User_Assignment__c stua = new Sales_Territory_User_Assignment__c(User__c = userId, Sales_Territory__c = st.Id, IsActive__c=true);
        insert stua;
               
        //Run OpptyOutsideTerrBatch Batch
        Id batchOpptyOutsideTerr = Database.executeBatch(new OpptyOutsideTerrBatch());
        system.debug('Debmalya' + opty.Opportunity_Outside_Owner_s_Terr__c);
        
        test.stopTest();
        
    }
    
    
    //TM:Debmalya: Test method for TurnEvalTerrFlagTrueBatch class:Start
    static testMethod void WorldRegionTest() {
    
        test.startTest();
        
        /*World Region insert*/
        World_Region__c wrSReg1 = new World_Region__c(Name = 'North America', ParentName__c = 'Americas');
        insert wrSReg1;
        World_Region__c wrSReg2 = new World_Region__c(Name = 'United States Extended', ParentName__c = 'North America', ParentId__c = wrSReg1.Id);
        insert wrSReg2;
        World_Region__c wrSReg3 = new World_Region__c(Name = 'US', ParentName__c = 'United States Extended', ParentId__c = wrSReg2.Id, Country_Name__c = 'United States');
        insert wrSReg3;
        /* Account insert*/ 
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        
        
        Account acc  = new Account(Name = 'testAccount', Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                        CurrencyIsoCode='USD', ShippingPostalCode = '99999-9999', ShippingCountry = 'United States',
                        MDCP_Organization_ID__c = '1234STR', Source_System_Account_ID__c = '54321STR');
        
        insert acc;
        System.assertEquals(acc.Name,'testAccount');
        acc.EvaluateTerritory__c = false;
        update acc;
        system.debug('Debmalya' + acc.EvaluateTerritory__c);
        system.debug('Debmalya' + acc.WorldRegion_Hierarchy__c);
        
        World_Region__c wrSReg4 = new World_Region__c(Name = 'Northern America', ParentName__c = 'Americas');
        insert wrSReg4;
        
        List<World_Region__c> wrList = new List<World_Region__c>();
        wrSReg2.ParentId__c = wrSReg4.Id;
        wrList.add(wrSReg2);
        wrSReg3.ParentId__c = wrSReg4.Id;
        wrList.add(wrSReg3);
        update wrList;
        
        test.stopTest();
        
    }
    //TM:Debmalya:End
    
    //TM:Debmalya:Test Coverage for TMCreateRemoveAccountTeam:Start
    static testMethod void createRemoveAccountTeamTest() {
    
        test.startTest();
                
        List<Sales_Territory__c> stUpdateList = new List<Sales_Territory__c>();
        List<Sales_Territory_User_Assignment__c> stuaList = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> stuaUpdateList = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> stuaUpdateList2 = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> stuaUpdateList3 = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> stuaUpdateList4 = new List<Sales_Territory_User_Assignment__c>();
        
        List<Account> accList = new List<Account>();
        Set<Id> accSet = new Set<Id>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        for(Integer i=0;i<10;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = true,AccountProfileEvaluated__c=true, ShippingPostalCode = '99999-9999', ShippingState = 'Ohio', ShippingCountry = 'US');
            accList.add(acc) ;
        }
        insert accList;
        System.assertEquals(accList[0].Name,'testAccount0');
        
        for(Account aObj : accList){
            accSet.add(aObj.Id);
        }
        
        Sales_Territory__c st = new Sales_Territory__c (Name='test ST', IsActive__c=true, IsConfidential__c=false,IsPartner__c=false,MyComp_Sales_Territory_Name__c='test');       
        insert st;
        
        Sales_Territory__c st2 = new Sales_Territory__c (Name='test ST2', IsActive__c=true, IsConfidential__c=false,IsPartner__c=false,MyComp_Sales_Territory_Name__c='test');       
        insert st2;
        
        Sales_Territory_Definition__c stDef = new Sales_Territory_Definition__c (Sales_Territory__c = st.Id, Country__c = 'US');       
        insert stDef;
        
        Sales_Territory_Definition__c stDef2 = new Sales_Territory_Definition__c (Sales_Territory__c = st2.Id, Country__c = 'US',State_Province__c = 'Ohio');       
        insert stDef2;
        
        Map<Id, Account> accountsById = new Map<Id, Account>();
        
        for(Integer i=0; i < accList.size();i++){
            accountsById.put(accList[i].Id, accList[i]);
        }
        
        TerritoryAssignmentEngine.matchByGeoRules(accountsById);
        
        //system.debug([Select Id, Account__c, Sales_Territory__c from Sales_Territory_Account_Assignment__c where Sales_Territory__r.Account_Team_Changes__c = true and Sales_Territory__r.IsActive__c = true and Assignment_Type__c = 'Territory Engine']);
        //system.debug([Select Id from Sales_Territory_Account_Assignment__c where Sales_Territory__c = :st.Id]);

        List<User> uObjList = [Select Id from User where IsActive=true limit 5];
        
         //Create Sales Terr User Assignment Records
        for(Integer i=0;i<5;i++){
            Sales_Territory_User_Assignment__c stua = new Sales_Territory_User_Assignment__c(User__c = uObjList[i].Id, Sales_Territory__c = st.Id, IsActive__c=true, 
                                                                                             Add_to_Account_Team__c = true, Account_Team_Role__c = 'Alliance Sales');
            stuaList.add(stua);
        }
        insert stuaList;

        Integer j = 0; //capture number of one Sales Territory User assignment where Add_to_Account_Team__c = false.
        for(Integer k=0;k<stuaList.size();k++){
            If(math.mod(k,2)!=0){
                stuaList[k].Add_to_Account_Team__c = false;
                stuaList[k].Account_Team_Role__c = null;
                stuaUpdateList3.add(stuaList[k]);
                j=k;
            }
        }
        update stuaUpdateList3;
        
        Sales_Territory_User_Assignment__c stua2 = new Sales_Territory_User_Assignment__c(User__c = stuaList[j].User__c, Sales_Territory__c = st2.Id, IsActive__c=true, 
                                                                                          Add_to_Account_Team__c = true, Account_Team_Role__c = 'Alliance Sales');
        insert stua2;
        
        /*for(Sales_Territory_User_Assignment__c stuaObj : stuaList){
            stuaObj.Add_to_Account_Team__c = true;
            stuaObj.Account_Team_Role__c = 'Alliance Sales';
            stuaUpdateList4.add(stuaObj);
        }
        update stuaUpdateList4;*/
        TMCreateRemoveAcctScheduler accTeamSc = new TMCreateRemoveAcctScheduler();
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM-Create-Remove Account Team'+datetime.now(), schExp, accTeamSc);
        
        /*TM: Sreenath adding changes for coverage */
        
         TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
        if(specialtyFlag != null && !specialtyFlag.SchedularFlag__c){
            try{
                //Update to true
                specialtyFlag.SchedularFlag__c = true;
                update specialtyFlag;
            }catch(Exception exp){
                system.debug('Exception Occured while updating Specialty Flag to true '+exp.getMessage());
            }
            SpecialtyBatchScheduler specialtySc = new SpecialtyBatchScheduler();
        
            datetime currentDateTime1 = datetime.now();
            String mins = String.valueOf(math.mod((currentDateTime1.minute() + 2),60));
            
            String schExps = '0 '+mins+' * * * ? ';
            system.schedule(Label.Specialty_Batch_Job+datetime.now(), schExps, specialtySc);
        //TM:Sreenath removing this batches from hourly rules engine cycle & handling separated batches ends
        }

        test.stopTest();
    }
     static testMethod void createRemoveAccountTeamNegativeTest(){
        
        test.startTest();
        
        List<Sales_Territory_User_Assignment__c> stuaList = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> stuaUpdateList3 = new List<Sales_Territory_User_Assignment__c>();
        
        TMEngineScheduledFlag__c obj1 = TMEngineScheduledFlag__c.getValues('CreateRemAcctTeam');
        obj1.SchedularFlag__c = true;
        update obj1;
        
        TMCreateRemoveAcctScheduler accTeamSc = new TMCreateRemoveAcctScheduler();
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM-Create-Remove Account Team'+datetime.now(), schExp, accTeamSc);
        
        test.stopTest();
    }
    //TM:Debmalya:Test Coverage for TMCreateRemoveAccountTeam:End
    
    //TM:Debmalya:Test Coverage for ProductSpe:Start
    static testMethod void productSpecialtyUserTest() {
    
        test.startTest();
        
        ProdSpcltyUserAsgnmtTriggerControlTest.setUpData();
        
        insert ProdSpcltyUserAsgnmtTriggerControlTest.OppLineItemglobal;
        
        ProductSpecUserBatchScheduler accTeamSc = new ProductSpecUserBatchScheduler();
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM-Product Specialty User'+datetime.now(), schExp, accTeamSc);
        
        test.stopTest();
    }
    //TM:Debmalya:Test Coverage for ProductSpe:Stop
    
      //TM:Nasir:Test Coverage for TMAllianceChanlPrtnrTerrSchedular:Start
      //R6:TM:Commented the method as it is getting covered in TMAllianceChannelPartnerBatchTest
   /* static testMethod void TMAllianceChanlPrtnrTerrSchedularTest() {
        
        test.startTest();        
        TMAllianceChanlPrtnrTerrSchedular tm= new TMAllianceChanlPrtnrTerrSchedular();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute()),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Allaince Partner'+datetime.now(), schExp, tm);
        test.stopTest();
    }*/
     //TM:Nasir:Test Coverage for TMAllianceChanlPrtnrTerrSchedular:End
     
     //TM:Nasir:R5:Test Coverage for TMProcessProdLineItemSOMSchedular:Start
    static testMethod void TMProcessProdLineItemSOMSchedularTest() {
        
        test.startTest();        
        TMProcessProdLineItemSOMSchedular tm= new TMProcessProdLineItemSOMSchedular();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute()),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TMProcessProdLineItemSOMBatchCall'+datetime.now(), schExp, tm);
        test.stopTest();
    }
     //TM:Nasir:R5:Test Coverage for TMProcessProdLineItemSOMSchedular:End
    
     //TM:Nasir:R5:Test Coverage for ProdSpecialtyOpptyDelSchedularTest:Start
    static testMethod void ProdSpecialtyOpptyDelSchedularTest() {
        
        test.startTest();        
        ProdSpecialtyOpptyDelSchedular tm= new ProdSpecialtyOpptyDelSchedular();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute()),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('ProdSpecialtyOpptyDelSchedular'+datetime.now(), schExp, tm);
        test.stopTest();
    }
     //TM:Nasir:R5:Test Coverage for ProdSpecialtyOpptyDelSchedularTest:End
    
     //TM:Nasir:R5.EF CR-0979:Test Coverage for TMWonLostSOMDeleteBatchSchedular:Start
    static testMethod void TMWonLostSOMDeleteBatchSchedularTest() {
        
        test.startTest();        
        TMWonLostSOMDeleteBatchSchedular tm= new TMWonLostSOMDeleteBatchSchedular();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute()),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TMWonLostSOMDeleteBatchSchedular', schExp, tm);
        test.stopTest();
    }
     //TM:Nasir:R5.EF CR-0979:Test Coverage for TMWonLostSOMDeleteBatchSchedular:End
     
      //TM:Nasir:R5.EF CR-0979:Test Coverage for TMWonLostSOMDeleteBatchSchedular2:Start
    static testMethod void TMWonLostSOMDeleteBatchSchedularTest2() {
        
        test.startTest();        
        TMWonLostSOMDeleteBatchSchedular2 tm= new TMWonLostSOMDeleteBatchSchedular2();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute()),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TMWonLostSOMDeleteBatchSchedular2', schExp, tm);
        test.stopTest();
    }
     //TM:Nasir:R5.EF CR-0979:Test Coverage for TMWonLostSOMDeleteBatchSchedular2:End
    


}