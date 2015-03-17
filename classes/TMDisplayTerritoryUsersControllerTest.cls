@isTest(seeAllData=true)
private class TMDisplayTerritoryUsersControllerTest{
      // Test Coverage for Display Territory User for Location
    static testMethod void DisplayTerritoryUsersLocationTest() {
        
        test.startTest();
            TMDisplayTerritoryUsersController displayLocUser;
            
            Sales_Territory__c st = new Sales_Territory__c (Name='test ST', MyComp_Sales_Territory_Name__c='test ST',IsPartner__c=true, IsActive__c=true, IsConfidential__c=true);       
            insert st;
            Account account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Partner');
            insert account ;
            Location__c loc  = new Location__c(Account__c=account.id, Name = 'testLocation', Location_Name__c = '12345',Sell_Into_Market__c='TestMarkt', EvaluateTerritory__c = false);
            insert loc;
            Sales_Territory_Location_Assignment__c stla = new Sales_Territory_Location_Assignment__c(Location__c = loc.Id, Sales_Territory__c = st.Id);
             insert stla;
            
            //Create Sales Terr User Assignment Records
            User currentUser = [select Id from user where Id =: UserInfo.getUserId()];
                 Sales_Territory_User_Assignment__c stua = new Sales_Territory_User_Assignment__c(User__c = currentUser.Id, Sales_Territory__c = st.Id, IsActive__c=true, Add_to_Account_Team__c = false);
             insert stua;                                                                                           
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(loc);
            displayLocUser = new TMDisplayTerritoryUsersController(stdController);
            displayLocUser.getSortDirection();
            displayLocUser.setSortDirection('DESC');
            displayLocUser.getsalesTerritoryLocAssign();
            displayLocUser.ViewData();
            displayLocUser.sortExpression='User__r.Name';
            displayLocUser.sortExpression='DESC';
            displayLocUser.sortExpression='';
            displayLocUser.getSortDirection();
            displayLocUser.backPage();
            displayLocUser.next();
            displayLocUser.beginning();
            displayLocUser.End();
            displayLocUser.previous();
            displayLocUser.getDisablePrevious();
            displayLocUser.getDisableNext();
            displayLocUser.getTotalPages();
            displayLocUser.getTotal_size();
            displayLocUser.getPageNumber();
            displayLocUser.getListSize();
            displayLocUser.getDisableExportToXLS();
            displayLocUser.exportToExcel();
    
         test.stopTest();
        
    }
    // Test Coverage for Display Territory User for Account
    
     static testMethod void DisplayTerritoryUsersAccountTest() {
        
        test.startTest();
            TMDisplayTerritoryUsersControllerAccts displayAccUser;
            
            Sales_Territory__c st = new Sales_Territory__c (Name='test ST', MyComp_Sales_Territory_Name__c='test ST',IsPartner__c=true, IsActive__c=true, IsConfidential__c=true);       
            insert st;
            Account account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Partner');
            insert account ;
           
            Sales_Territory_Account_Assignment__c staa = new Sales_Territory_Account_Assignment__c(Account__c = Account.Id, Sales_Territory__c = st.Id);
             insert staa;
            
            //Create Sales Terr User Assignment Records
            User currentUser = [select Id from user where Id =: UserInfo.getUserId()];
                 Sales_Territory_User_Assignment__c stua = new Sales_Territory_User_Assignment__c(User__c = currentUser.Id, Sales_Territory__c = st.Id, IsActive__c=true, Add_to_Account_Team__c = false);
             insert stua;                                                                                           
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(account);
            displayAccUser = new TMDisplayTerritoryUsersControllerAccts(stdController);
            displayAccUser.getSortDirection();
            displayAccUser.setSortDirection('DESC');
            displayAccUser.getsalesTerritoryLocAssign();
            displayAccUser.ViewData();
            displayAccUser.sortExpression='User__r.Name';
            displayAccUser.sortExpression='DESC';
            displayAccUser.sortExpression='';
            displayAccUser.getSortDirection();
            displayAccUser.backPage();
            displayAccUser.next();
            displayAccUser.beginning();
            displayAccUser.End();
            displayAccUser.previous();
            displayAccUser.getDisablePrevious();
            displayAccUser.getDisableNext();
            displayAccUser.getTotalPages();
            displayAccUser.getTotal_size();
            displayAccUser.getPageNumber();
            displayAccUser.getListSize();
            displayAccUser.getDisableExportToXLS();
            displayAccUser.exportToExcel();
    
         test.stopTest();
        
    }
    
   
}