/**
 * Name : TMPostLocationAssignmentTest
 * Desc : This test class covers the functions in TMPostLocationAssignment.
 *
 */
 
@isTest(seeAllData=true)
private class TMPostLocationAssignmentTest {

    static List<Account> listAccount = new List<Account>();
    static List<Location__c> locList = new List<Location__c>();
    static Set<Id> locIds = new Set<Id>();
    static List<Sales_Territory__c> stList = new List<Sales_Territory__c>();   
    static List<Sales_Territory_Definition__c> stdList = new List<Sales_Territory_Definition__c>();
    static Map<Id, List<Sales_Territory_Definition__c>> locIdSTDMap = new Map<Id, List<Sales_Territory_Definition__c>>();
    private static void setupData() {
        
        User currentUser = [select Id from user where Id =: UserInfo.getUserId()];
        
         
        //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Account11', 'tezt4@test.com','Customer');
        listAccount.add(account1);
        
        
        //Create Alliance Partner Account
        Account alliancePartnerAcc = TestingSetupDataUtil.createAccount('Partner Account2', 'tezt3alt@test.com', 'Partner');
        alliancePartnerAcc.Alliance_Partner_Flag__c = true;
        listAccount.add(alliancePartnerAcc);
        
        //Create Channel Partner Account
         Account channelPartnerAcc = TestingSetupDataUtil.createAccount('Partner Account2', 'tezt3cht@test.com', 'Partner');
        channelPartnerAcc.Channel_Partner_Flag__c = true;
        listAccount.add(channelPartnerAcc);
        
        insert listAccount;
        System.assertEquals(listAccount.size(), 3);
        
        /* Location insert*/ 
        
        for(Integer i=0;i<5;i++){
            Location__c loc  = new Location__c(Account__c=channelPartnerAcc.Id, Name = 'test'+ i, Location_Name__c = 'test'+ i, EvaluateTerritory__c = true);
            locList.add(loc);
        }
        insert locList;
        
        for(Integer i=0; i<5; i++){
            Sales_Territory__c st = new Sales_Territory__c (Name='test ST' + i, IsActive__c=true, IsConfidential__c=true, Account_Access__c = 'Read', Opportunity_Access__c = 'Read', Case_Access__c = 'Read', IsPartner__c = true,MyComp_Sales_Territory_Name__c = 'ST-TestTerrPL'+i);       
            stList.add(st);
        }
        insert stList;    
        System.assertEquals(stList.size(),5);
        
        Sales_Territory_User_Assignment__c stua = new Sales_Territory_User_Assignment__c(Sales_Territory__c = stList[0].Id, User__c = UserInfo.getUserId(), Add_To_Account_Team__c = false, Account_Team_Role__c = 'Account Manager');
        insert stua;
        Sales_Territory_Definition__c std1 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[0].Id, Partner_Locator_Id__c = 'Test0');
        stdList.add(std1);
        insert stdList;
        system.debug('the name of the definition'+ stdList[0]);
                
        Sales_Territory_Location_Assignment__c stAA = new Sales_Territory_Location_Assignment__c(Sales_Territory__c = stList[0].Id, Location__c = locList[0].Id, AssignmentType__c = 'Territory Engine');
        insert stAA;       
                
         //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account1.Id,'Oppty1',System.today().addMonths(1));
        insert opty;
        
        Channel_Partner__c channelPartner1=new Channel_Partner__c(Channel_Partner__c=channelPartnerAcc.Id,Location__c=locList[0].Id,Partner_Type__c='Channel Partner',Partner_Account_Role__c='Implementer',Opportunity__c=opty.Id);
        Insert channelPartner1;
        
        Channel_Partner__c channelPartner5=new Channel_Partner__c(Channel_Partner__c=channelPartnerAcc.Id,Location__c=locList[1].Id,Partner_Type__c='Channel Partner',Partner_Account_Role__c='Implementer',Opportunity__c=opty.Id);
        Insert channelPartner5;
        
        Channel_Partner__c channelPartner6=new Channel_Partner__c(Channel_Partner__c=channelPartnerAcc.Id,Location__c=locList[2].Id,Partner_Type__c='Channel Partner',Partner_Account_Role__c='Implementer',Opportunity__c=opty.Id);
        Insert channelPartner6; 
         //Test TM Post Assignment functionality...
        List<Sales_Territory_Definition__c> stdList1 = [Select Sales_Territory__r.GroupId__c from Sales_Territory_Definition__c where Sales_Territory__c =:stdList[0].Sales_Territory__c];
        stdList = stdList1;      
        locIdSTDMap.put(locList[0].Id, stdList);
        locIdSTDMap.put(locList[1].Id, stdList);
        /*TMPostLocationAssignment.postAssignmentforTM(locIdSTDMap);*/
        
        stList[1].EvaluateTerritory_for_Realignment__c = true;
        stList[2].EvaluateTerritory_for_Realignment__c = true;
        update stList;
        
        Sales_Territory_Location_Assignment__c stLA1 = new Sales_Territory_Location_Assignment__c(Sales_Territory__c = stList[1].Id, Location__c = locList[1].Id, AssignmentType__c = 'Territory Engine');
        insert stLA1;
        
        Sales_Territory_Location_Assignment__c stLA2 = new Sales_Territory_Location_Assignment__c(Sales_Territory__c = stList[2].Id, Location__c = locList[2].Id, AssignmentType__c = 'Territory Engine');
        insert stLA2;
        locIds.add(locList[1].Id);
        locIds.add(locList[2].Id);
        TerritoryDeltaChanges__c terrDeltaFlag = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
        terrDeltaFlag.Territory_Evaluation__c = true;  
        update terrDeltaFlag;
        TMPostLocationAssignment.processCleanUpLocation(locIds);
        terrDeltaFlag.Territory_Evaluation__c = false;  
        update terrDeltaFlag;
        TMPostLocationAssignment.processCleanUpLocation(locIds);
        
    }
    static testMethod void unitTest() { 
        
        test.startTest();
        setupData();
        TMProcessLocationCleanUpScheduler procCleanTest = new TMProcessLocationCleanUpScheduler();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM TMProcessLocationCleanUpScheduler Test :'+datetime.now(), schExp, procCleanTest);
        test.stopTest();
    }
}