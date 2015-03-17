@isTest(seeAllData = false)
private class TMLocationTerritoryControllerTest{
    static testMethod void locatiobTerritoryControllerTest(){
    
    user testUser = new User(Profileid=userInfo.getProfileId(),Username='locTerrTestUser@gmail.com',
                                 LastName='locterr',email='locTerrTestUserTest@hp.com' ,Alias='LocTst', 
                                 CommunityNickname='testloc',emailencodingkey='UTF-8', 
                                 languagelocalekey='en_US', localesidkey='en_US',timezonesidkey='America/Los_Angeles',
                                 Partner_Collaboration_Participating_User__c=true, Email_Address__c='locTerrTestUser@gmail.com',EmployeeNumber='',
                                 Legacy_Employee_Ref__c='09876787',Adoption_Role_Type__c = 'Account Executive');
    insert testUser;
    
    Id recordTypeId = schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
    Account newTestAccount = new Account(Name='LocTerrListTestAcc',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,
    MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='799',MDCP_Organization_ID__c='801',
    Channel_Partner_Flag__c=true);
    insert newTestAccount;
    
    List<Location__c> locationList = new List<Location__c>();
    for(Integer i=0;i<400;i++){
        Location__c location = new Location__c(Name='loc'+i,Location_Name__c='11',Account__c = newTestAccount.id);
        locationList.add(location);
    }
    insert locationList;
    
    Sales_Territory__c salesTerr = new Sales_Territory__c(Name='LocTerrSalesTerrTest',Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit',IsConfidential__c=False,IsPartner__c=true,MyComp_Sales_Territory_Name__c = 'ST-TestTerrLocCtrlr');
    insert salesTerr;
    
    List<Sales_Territory_Location_Assignment__c> stlaList = new List<Sales_Territory_Location_Assignment__c>();
    
    for(Location__c loc:locationList){
        Sales_Territory_Location_Assignment__c stla = new Sales_Territory_Location_Assignment__c(Location__c = loc.id,Sales_Territory__c = salesTerr.id);
        stlaList.add(stla);
    }
    insert stlaList;
    
    Sales_Territory_User_Assignment__c stua = new Sales_Territory_User_Assignment__c(User__c = testUser.id,Sales_Territory__c = salesTerr.id);
    insert stua;
    
    TMLocationTerritoryController tmlocTerCtr= new TMLocationTerritoryController();
    
    System.runAs(testUser){
        tmlocTerCtr.getLocations();
        system.assert(tmlocTerCtr.pageNumber == 1);
        tmlocTerCtr.next();
        system.assert(tmlocTerCtr.hasNext == false);
        tmlocTerCtr.previous();
        system.assert(tmlocTerCtr.hasPrevious == false);
        tmlocTerCtr.first();
        tmlocTerCtr.last();
    }
    
    }
}