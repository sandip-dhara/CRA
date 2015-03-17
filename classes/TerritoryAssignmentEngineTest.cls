/***********************************************************
* Class Name: TerritoryAssignmentEngineTest
* Author: Accenture
* Description: This class does the test coverage
*              for TerritoryAssignmentEngine class.
***********************************************************/
@isTest(seeAllData=true)

private class TerritoryAssignmentEngineTest {
    public static List<Sales_Territory_Definition__c> stds = new List<Sales_Territory_Definition__c>();

    /**
    * @description -  Method to create instance of Sales_Territory__c 
    * @return - Sales_Territory__c instance
    *TM:Sreenath:R3:8th Nov,2012:Added 2 more parameters Boolean evaluateterr, Boolean Addtoteam
    */   
    public static Sales_Territory__c createSalesTerritory(String name , Boolean isconfidential, Boolean evaluateterr, Boolean Addtoteam) {
        Sales_Territory__c st = new Sales_Territory__c();
        st.Name = name; 
        st.MyComp_Sales_Territory_Name__c='test';       
        st.IsActive__c = true;
        st.Account_Access__c = 'Read';
        st.Case_Access__c = 'Read';
        //st.GroupID__c = '444';
        st.IsConfidential__c = isconfidential;
        st.Opportunity_Access__c = 'Read';
        st.Account_Team_Changes__c = Addtoteam;
        st.EvaluateTerritory_for_Realignment__c = evaluateterr;
        
        return st;
    }
  
    /**
    * @description -  Method to create instance of Sales_Territory_Definition__c 
    * @return - Sales_Territory_Definition__c instance
    */     
    public static Sales_Territory_Definition__c createSalesTerritoryDefinition(String MDCPID, String amid, String SourceSystemID, String country,String State,
             String PostalCodeStart, String PostalCodeEnd,String GeographicHierarchy,  String NamedAccount, String rad, String IndustryVertical,
             String bgSalesCoverageSegment, String salesTerritory, Boolean excludeflag, String bgTargetSegment, String PartnerLocatorId,String BR) {    
                
        Sales_Territory_Definition__c std = new Sales_Territory_Definition__c();
        std.AMID__c = amid;
        std.BG_Sales_Coverage_Segment__c = bgSalesCoverageSegment;
        std.BA_Market_Segment__c = bgTargetSegment;
        std.Country__c = country;
        std.Geographic_Hierarchy__c = GeographicHierarchy;      
        std.Industry_Vertical__c = IndustryVertical;
        std.MDCP_ID__c = MDCPID;
        std.Named_Account__c = NamedAccount;
        std.Postal_Code_End__c = PostalCodeStart;
        std.Postal_Code_Start__c = PostalCodeEnd;
        std.RAD__c = rad;       
        std.Sales_Territory__c = salesTerritory;
        std.Source_System_ID__c = SourceSystemID;
        std.State_Province__c = State;
        std.Exclude__c = excludeflag;
        std.Partner_Locator_Id__c = PartnerLocatorId;
        std.Business_Relationship__c = BR;
        return std; 
    }   
 
    /**
    * @description -  Method to setup data for test method. Create records for  Sales Territory and Sales Territory Definition
    */    
    static void setupData() {
        List<Sales_Territory__c> st = new List<Sales_Territory__c>();
        //List<Sales_Territory_Definition__c> stds = new List<Sales_Territory_Definition__c>();
        Sales_Territory_Definition__c std = new Sales_Territory_Definition__c();
        Sales_Territory__c newST = new Sales_Territory__c();
        
        
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_AMIDBGCoverageZip', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_AMIDIndVGeo', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_AMIDOnly', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_AMIDStCntry', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_BGCovSegOnly', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_BGCovSegStCntry', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_BGCovSegCntry', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_Cntry Only', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_CntryZip', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_IndustryOnly', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_IndVBGCoverage', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_IndVBGCovSegZip', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_IndVStCnrty', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_MDCP Only', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_NACntryZip', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_RADCntry', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_Region Only', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_SourceSysId Only', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_StCntry', false, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_NACntrySt', false, true, false);
        st.add(newST);        
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_BGCovSegStCntry', true, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_BGCovSegCntry', true, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_CntryZip', true, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_IndVStCnrty', true, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_NACntryZip', true, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_RADCntry', true, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_StCntry', true, true, true);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_NACntrySt', true, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_NACntry', true, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_Exclude', true, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('C_Exclude', false, true, false);
        st.add(newST);
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('NC_PartnerLocatorId', false, true, false);
        st.add(newST);   
        newST = TerritoryAssignmentEngineTest.createSalesTerritory('NC_MdcpBrCtry', false, true, false);
        st.add(newST);
        //try {
            insert st;
    /*  }
        catch(Exception e) {
            system.debug('Exception>>>>>'+e);
        }*/   
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,'AMIDXX126',null,'India1',null,'test4001','test5001',null,null,null,null,'testBGC1', st[0].Id,false,null,null,null);
        stds.add(std);
        std =TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,'AMIDXX126',null,null,null,null,null,'testEMEA2',null,null,'testCME1',null, st[1].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,'AMIDXX126',null,null,null,null,null,null,null,null,null,null, st[2].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,'AMIDXX126',null,'India1','testMH1',null,null,null,null,null,null,null, st[3].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,null,null,null,null,null,null,null,null,'testBGC1', st[4].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,null,'testBGC1', st[5].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,null,null,null,null,null,null,'testBGC1', st[6].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,null,null,null,null,null,null,null, st[7].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,'test4001','test5001',null,null,null,null,null, st[8].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,null,null,null,null,null,null,null,'testCME1',null, st[9].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,null,null,null,null,null,null,null,'testCME1','testBGC1', st[10].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,'test4001','test5001',null,null,null,'testCME1','testBGC1', st[11].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,'testCME1',null, st[12].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition('testMDCP102',null,null,null,null,null,null,null,null,null,null,null, st[13].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,'test4001','test5001',null,'testY1',null,null,null, st[14].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,null,null,null,null,'testR1',null,null, st[15].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,null,null,null,null,'testEMEA2',null,null,null,null, st[16].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,'sssid103',null,null,null,null,null,null,null,null,null, st[17].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,null,null, st[18].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,null,'testBGC1', st[22].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,null,'testBGC1', st[6].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,'testCME1',null, st[13].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,'testCME1',null, st[25].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,null,null,null,null,null,null,'testBGC1', st[7].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,null,null,null,null,null,null,'testBGC1', st[23].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,null,null, st[19].Id,false,null,null,null);
        stds.add(std);  
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,null,null, st[28].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,'testY1',null,null,null, st[20].Id,false,null,null,null);
        stds.add(std);        
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,null,null,null,'testY1',null,null,null, st[21].Id,false,null,null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,'AMIDXX126',null,null,null,null,null,null,null,null,null,null, st[30].Id,true,null,null,null);
        stds.add(std);  
         std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1','testMH1',null,null,null,null,null,null,'testBGC1', st[6].Id,false,'testBAMarket',null,null);
        stds.add(std);
         std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,'test4001','test5001',null,null,null,null,'testBGC1', st[7].Id,false,'testBAMarket',null,null);
        stds.add(std);
         std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,null,null,null,null,null,null,'testBGC1', st[8].Id,false,'testBAMarket',null,null);
        stds.add(std);
         std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,'India1',null,null,null,null,null,null,null,null, st[12].Id,false,'testBAMarket',null,null);
        stds.add(std);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition(null,null,null,null,null,null,null,null,null,null,null,null, st[31].Id,false,null,'1234',null);
        std = TerritoryAssignmentEngineTest.createSalesTerritoryDefinition('787',null,null,'India',null,null,null,null,null,null,null,null, st[32].Id,false,null,null,'Reseller');
       
        insert stds;    
        /*
String amid, String bgSalesCoverageSegment, String country, String GeographicHierarchy, 
            String MDCPID, String NamedAccount, String PostalCodeStart, String PostalCodeEnd, String rad, String salesTerritory, String SourceSystemID, 
            String State, String IndustryVertical       
        */
    }
 
    /**
    * @description -  Method for test coverage of TerritoryAssignmentEngine class
    */     
    static testMethod void testTerritoryAssignment() {
        TerritoryAssignmentEngineTest.setupData();
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Customer';
        TerritoryDeltaChanges__c deltaChanges = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
        deltaChanges.Territory_Evaluation__c = true;
        update deltaChanges;
        
        //TM:Debmalya:Insert World Region Data:Start
        /*World Region insert*/
        World_Region__c wrSReg1 = new World_Region__c(Name = 'North America', ParentName__c = 'Americas');
        insert wrSReg1;
        World_Region__c wrSReg2 = new World_Region__c(Name = 'United States Extended', ParentName__c = 'North America', ParentId__c = wrSReg1.Id);
        insert wrSReg2;
        World_Region__c wrSReg3 = new World_Region__c(Name = 'US', ParentName__c = 'United States Extended', ParentId__c = wrSReg2.Id, Country_Name__c = 'United States');
        insert wrSReg3;
        World_Region__c wrSReg4 = new World_Region__c(Name = 'AP without Japan', ParentName__c = 'Asia Pacific');
        insert wrSReg4;
        World_Region__c wrSReg5 = new World_Region__c(Name = 'IN', ParentName__c = 'AP without Japan', ParentId__c = wrSReg1.Id, Country_Name__c = 'India1');
        insert wrSReg5;
        system.debug('++++++++++' +wrSReg3.Id);
        system.debug('++++++++++' +wrSReg3.Geographic_Hierarchy__c);
        system.debug('++++++++++' +wrSReg3.Country_Name__c);
        system.debug('++++++++++' +wrSReg2.ParentId__c);
        system.debug('++++++++++' +wrSReg1.Id);
        //TM:Debmalya:Insert World Region Data:End
        
        
        //create Account 
        List<Account> accounts = new List<Account>();
        Account newAccount = TestingSetupDataUtil.createAccount('accountName', 'test@test.com','Customer');
        Set<Id> accountsId = new Set<Id>();
        
        // Insert non confidential account      
        newAccount.AMID_L2__c = 'AMIDXX123';
        newAccount.MDCP_Organization_ID__c = 'testMDCP102';
        newAccount.Source_System_Account_ID__c = 'sssid103';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        newAccount.World_Region1__c = wrSReg2.Id;
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1';
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = false;
        accounts.add(newAccount);
        newAccount = TestingSetupDataUtil.createAccount('accountName1', 'test@test.com','Customer');
        newAccount.AMID_L2__c = 'AMIDXX126';
        newAccount.MDCP_Organization_ID__c = 'testMDCP11012';
        newAccount.Source_System_Account_ID__c = 'sssid11103';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        //newAccount.World_Region__c = 'testEMEA2';
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1';
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = false;
        accounts.add(newAccount);    
        
         newAccount = TestingSetupDataUtil.createAccount('accountName1', 'test@test.com','Customer');
        newAccount.AMID_L2__c = 'AMIDXX126';
        newAccount.MDCP_Organization_ID__c = 'testMDCP1101';
        newAccount.Source_System_Account_ID__c = 'sssid1110';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        //newAccount.World_Region__c = 'testEMEA2';
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1';
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = true;
        accounts.add(newAccount);    

        newAccount = TestingSetupDataUtil.createAccount('accountName2', 'test@test.com','Customer');
        newAccount.AMID_L2__c = 'AMID112';
        newAccount.MDCP_Organization_ID__c = 'testMDCP112';
        newAccount.Source_System_Account_ID__c = 'sssid112';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        //newAccount.World_Region__c = 'testEMEA2';
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1';
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = false;
        accounts.add(newAccount);  
        
        newAccount = TestingSetupDataUtil.createAccount('accountName3', 'test@test.com','Customer');
        newAccount.AMID_L2__c = 'AMID113';
        newAccount.MDCP_Organization_ID__c = 'testMDCP113';
        newAccount.Source_System_Account_ID__c = 'sssid113';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        //newAccount.World_Region__c = 'testEMEA2';
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1';
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = false;
        accounts.add(newAccount);  
        
        newAccount = TestingSetupDataUtil.createAccount('accountName434', 'test@test.com','Customer');
        newAccount.AMID_L2__c = 'AMID114';
        newAccount.MDCP_Organization_ID__c = 'testMDC3434P114';
        newAccount.Source_System_Account_ID__c = 'sssid114';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        //newAccount.World_Region__c = 'testEMEA2';
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1'; 
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = false;
        accounts.add(newAccount);                                     
        //insert accounts;
        
         newAccount = TestingSetupDataUtil.createAccount('accountName434', 'test@test.com','Partner');
        newAccount.AMID_L2__c = 'AMID1114';
        newAccount.MDCP_Organization_ID__c = 'testMDC3434P1104';
        newAccount.Source_System_Account_ID__c = 'sssid1104';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        //newAccount.World_Region__c = 'testEMEA2';
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1'; 
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = false;
        accounts.add(newAccount); 
        
          // Insert confidential account     
        newAccount = TestingSetupDataUtil.createAccount('accountName44', 'test4@test.com','Customer');        
        newAccount.AMID_L2__c = 'AMIDXX124';
        newAccount.MDCP_Organization_ID__c = 'testMDCP103';
        newAccount.Source_System_Account_ID__c = 'sssid104';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        //newAccount.World_Region__c = 'testEMEA2';
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1';
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = true;
        accounts.add(newAccount);
        newAccount = TestingSetupDataUtil.createAccount('accountName13', 'test3@test.com','Customer');
        newAccount.AMID_L2__c = 'AMID1121';
        newAccount.MDCP_Organization_ID__c = 'testMDCP11112';
        newAccount.Source_System_Account_ID__c = 'sssid11113';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        //newAccount.World_Region__c = 'testEMEA2';
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1';
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = true;
        accounts.add(newAccount);    

        newAccount = TestingSetupDataUtil.createAccount('accountName12', 'test2@test.com','Partner');
        newAccount.AMID_L2__c = 'AMID1124';
        newAccount.MDCP_Organization_ID__c = 'testMDCP1132';
        newAccount.Source_System_Account_ID__c = 'sssid1122';
        newAccount.ShippingCountry = 'India1';
        newAccount.ShippingState = 'testMH1';
        newAccount.ShippingPostalCode = 'test4001';
        //newAccount.World_Region__c = 'testEMEA2';
        newAccount.Named_Account__c = 'testY1';
        newAccount.RAD__c = 'testR1';
        newAccount.Industry_Vertical__c = 'testCME1';
        newAccount.Coverage_Segmentation__c = 'testBGC1';
        newAccount.BG_Target_Segments__c = 'testBAMarket';
        newAccount.Confidential_Account__c = true;
        accounts.add(newAccount);  
        
        
                                                   
        insert accounts;
        system.debug('+++++++' +accounts[0].WorldRegion_Hierarchy__c);
         system.debug('+++++++' +accounts[0].World_Region1__c);
       
       List<Location__c> locations = new List<Location__c>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
        Account acc1 = new Account(Name='PrevLocTestAcc1',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true);
        insert acc1;
        Account acc2 = new Account(Name='PrevLocTestAcc2',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='787',MDCP_Organization_ID__c='787',Channel_Partner_Flag__c=true);
        insert acc2;
        Location__c loc1 = new Location__c(Name='1234',Location_Name__c='Blr',Account__c = acc1.id);
        locations.add(loc1) ;
        Location__c loc2 = new Location__c(Name='1600',Location_Name__c='Mys',Account__c = acc2.id,Country__c='India');
        locations.add(loc2) ;
        insert locations;
        Map<Id,Location__c> locationsById = new Map<Id,Location__c>();
        for(Integer i=0; i < locations.size();i++){
            locationsById.put(locations[i].Id,locations[i]);
        }
        
        
        Map<Id, Account> accountsById = new Map<Id, Account>();
        for(Integer i=0; i < accounts.size();i++){
            accountsById.put(accounts[i].Id, accounts[i]);
        }
        if (accounts != null && accounts.size() > 0) {
            //accountsById.put(accounts[0].Id, accounts[0]);
            TerritoryAssignmentEngine.matchByAccountProfileRules(accountsById);
            TerritoryAssignmentEngine.matchByCoverageRules(accountsById);
            TerritoryAssignmentEngine.matchByGeoRules(accountsById);
            TerritoryAssignmentEngine.matchByIndustryRules(accountsById);
            TerritoryAssignmentEngine.matchByBAMarketRules(accountsById);
        }
        Map<Id,List<Sales_Territory_Definition__c>> matchingRulesByLocIdTest = new Map<Id,List<Sales_Territory_Definition__c>>();
        matchingRulesByLocIdTest.put(loc1.Id, new List<Sales_Territory_Definition__c>());
        //Sales_Territory_Definition__c s1 = new Sales_Territory_Definition__c();
        integer s1 = stds.size();
        matchingRulesByLocIdTest.get(loc1.Id).add(stds[s1-1]);
        if(locations != null && locations.size() > 0){
        
            //TerritoryAssignmentEngine.matchByLocationRules(locationsById);
            if(matchingRulesByLocIdTest.size()>0)
            TerritoryAssignmentOperations.createTerritoryLocAssignment(matchingRulesByLocIdTest);
        }
        
    }
}