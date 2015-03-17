@isTest(seeAllData = TRUE)

    private class manageContractsTest{
    
        private static testmethod void testManageContracts(){
        Account account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Customer');
        insert account ;
        
        Opportunity opp = TestingSetupDataUtil.createOpportunity(account.Id, 'Test Opp', Date.today());
        insert opp;
        
        List<Contract_Reference__c> conList = new List<Contract_Reference__c>();
        for(Integer i = 0; i<100; i++){
            Contract_Reference__c c = new Contract_Reference__c(Name = 'Test con');
            c.Original_Opportunity__c = opp.Id;
            conList.add(c);
            
        }
        insert conList;
        
        Test.startTest();
            Test.setCurrentPage(new PageReference('/apex/manageContracts?Id='+opp.Id));
            ApexPages.StandardController controller = new ApexPages.StandardController(opp);
            
            ManageContractsController mg = new ManageContractsController(controller);
            
            mg.next();
            mg.previous();
            mg.first();
            mg.last();
            Boolean b = mg.hasNext;
            b = mg.hasPrevious;
            
            mg.associateToNew();
            mg.associateToExisting();
            mg.Remove();
            mg.sortField = 'Name';
            mg.doSort();
            mg.doSort();
            mg.doSort();
            
            mg.contractWrapperList[0].choice = true;
            mg.contractWrapperList[1].choice = true;
            
            mg.associateToNew();
            mg.associateToExisting();
            mg.Remove();
            
            mg.stage = '06 - Won, Deploy & Expand';
            mg.associateToNew();
            mg.associateToExisting();
            mg.Remove();
        Test.stopTest();
    }

}