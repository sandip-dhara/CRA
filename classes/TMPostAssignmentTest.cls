/**
 * Name : TMPostAssignmentTest
 * Desc : This test class covers the functions in TerritoryManagementPostAssignment.
 *
 */
 
@isTest(seeAllData=true)
private class TMPostAssignmentTest {

    static testMethod void myUnitTest() {
        
        test.startTest();
        
        /* Account inset*/ 
        List<Account> accList = new List<Account>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        for(Integer i=0;i<5;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = false);
            accList.add(acc) ;
        }
        insert accList;
        System.assertEquals(accList[0].Name,'testAccount0');
                
        List<Sales_Territory__c> stList = new List<Sales_Territory__c>();
        List<Sales_Territory_Definition__c> stdList = new List<Sales_Territory_Definition__c>();
        
        for(Integer i=0; i<10; i++){
            Sales_Territory__c st = new Sales_Territory__c (Name='test ST' + i, MyComp_Sales_Territory_Name__c='test ST' + i, IsActive__c=true, IsConfidential__c=true, Account_Access__c = 'Read', Opportunity_Access__c = 'Read', Case_Access__c = 'Read');       
            stList.add(st);
        }
        insert stList;
        system.debug('the name of the group '+ stList[0].groupId__c);
        system.assertEquals(stList[0].Name, 'test ST0');
        
        //Account Profile Type
        Sales_Territory_Definition__c std1 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[0].Id, AMID__c = 'Test1');
            stdList.add(std1);
        Sales_Territory_Definition__c std2 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[0].Id, MDCP_ID__c = 'Test2');
            stdList.add(std2);
        Sales_Territory_Definition__c std3 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[1].Id, Source_System_Id__c = 'Test3');
            stdList.add(std3);
        //Industry Type
        Sales_Territory_Definition__c std4 = new Sales_Territory_Definition__c(Sales_Territory__c = stList[1].Id, Industry_Vertical__c = 'Test4');
            stdList.add(std4);
        insert stdList;
        
        Map<Id, List<Sales_Territory_Definition__c>> accIdSTDMap = new Map<Id, List<Sales_Territory_Definition__c>>();
        accIdSTDMap.put(accList[0].Id, stdList);
        accIdSTDMap.put(accList[1].Id, stdList);
        
        Sales_Territory_User_Assignment__c stua = new Sales_Territory_User_Assignment__c(Sales_Territory__c = stList[0].Id, User__c = UserInfo.getUserId(), Add_To_Account_Team__c = true, Account_Team_Role__c = 'Account Manager');
        insert stua;
        
        Sales_Territory_Account_Assignment__c stAA = new Sales_Territory_Account_Assignment__c(Sales_Territory__c = stList[0].Id, Account__c = accList[0].Id, Assignment_Type__c = 'Manual');
        insert stAA;
        Sales_Territory_Account_Assignment__c stAA2 = new Sales_Territory_Account_Assignment__c(Sales_Territory__c = stList[0].Id, Account__c = accList[0].Id, Assignment_Type__c = 'Territory Engine');
        insert stAA2;
        Sales_Territory_Account_Assignment__c stAA3 = new Sales_Territory_Account_Assignment__c(Sales_Territory__c = stList[1].Id, Account__c = accList[1].Id, Assignment_Type__c = 'Territory Engine');
        insert stAA3;
        
        //Test TM Post Assignment functionality...
        TerritoryManagementPostAssignment.postAssignmentforTM(accIdSTDMap);
        TerritoryManagementPostAssignment.addToAccountTeamforTM(accIdSTDMap);
        
        Set<Id> accountId = new Set<Id>();
        accountId.add(accList[0].Id);
        accountId.add(accList[1].Id);
        
        //Test TM Engine Clean Up call...
        TerritoryManagementPostAssignment.processCleanUp(accountId);
        //MDCP+BR:Start
        string RecordTypeId1 = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
        Account accMDCPBR  = new Account(Name = 'testMDCPBRAcc', Account_E_mail__c = 'accountTestEmail@email.com',RecordTypeId = RecordTypeId1,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = false);
        insert accMDCPBR;
        
        Location__c loc  = new Location__c(Account__c=accMDCPBR.id, Name = 'testLocation', Location_Name__c = '12345', EvaluateTerritory__c = false);
        insert loc;
        
        Opportunity opp = new Opportunity(AccountId = accList[0].id, StageName = '01 - Understand Customer', Name = 'Opty1', CloseDate = system.today(),CurrencyIsoCode='AUD');
        insert opp;

        //Test Alliance and Channel Partner Insertion
        Channel_Partner__c newalliance=new Channel_Partner__c(Channel_Partner__c=accMDCPBR.Id,Location__c=loc.Id,Partner_Type__c='Alliance Partner',Partner_Account_Role__c='Implementer',Opportunity__c=opp.Id);
        Insert newalliance;
        //MDCP+BR:END
        
        //MDCP+BR   
        List<Sales_Territory_Definition__c> stdList1 = new List<Sales_Territory_Definition__c>();
        Sales_Territory_Definition__c stdmdcpbr = new Sales_Territory_Definition__c(Sales_Territory__c = stList[2].Id, MDCP_ID__c = 'MDCPTest1', Business_Relationship__c ='BRTest1');
            stdList1.add(stdmdcpbr);
        insert stdList1;
        //MDCP+BR
        Sales_Territory_Account_Assignment__c stAA4 = new Sales_Territory_Account_Assignment__c(Sales_Territory__c = stList[2].Id, Account__c = accMDCPBR.Id, Assignment_Type__c = 'Territory Engine');
        insert stAA4;
        Map<Id, List<Sales_Territory_Definition__c>> accIdSTDMapMDCPBR = new Map<Id, List<Sales_Territory_Definition__c>>();
        accIdSTDMapMDCPBR.put(accMDCPBR.Id, stdList1);
        
        //Test TM Post Assignment functionality...
        TerritoryManagementPostAssignment.postAssignmentforTM(accIdSTDMapMDCPBR);
        TerritoryManagementPostAssignment.addToAccountTeamforTM(accIdSTDMapMDCPBR);
        
        Set<Id> accountId1 = new Set<Id>();
        accountId1.add(accMDCPBR.Id);
        
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        obj1.AccountRecordType__c = 'Partner';
        update obj1;
        //Test TM Engine Clean Up call...
        TerritoryManagementPostAssignment.processCleanUp(accountId1);
        
        //TM:Debmalya:Coverage for Process Clean Up Batch: Start
        TMProcessCleanUpScheduler procCleanTest = new TMProcessCleanUpScheduler();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Coverage Test :'+datetime.now(), schExp, procCleanTest);
        //TM:Debmalya:Coverage for Process Clean Up Batch: End
        
        
        
        //Test deletion of Manually Added Account to Territory.
        delete stAA;
        
        test.stopTest();
    }
}