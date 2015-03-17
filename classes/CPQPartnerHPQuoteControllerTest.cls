@isTest(SeeAllData=true)
private class CPQPartnerHPQuoteControllerTest{
    ///Test Method 
        public static testMethod void CPQPartnerHPCTest() {
        Test.startTest();
        /*
        // Create WorldRegion
        World_Region__c objWR1 = new World_Region__c(Name = 'US',Country_Name__c='United States');
        Insert objWR1;
        objWR1 = [select Region__c from World_Region__c where ID =: objWR1.Id];
        
         World_Region__c objWR = new World_Region__c(Name = 'US',Country_Name__c='United States', ParentId__c=objWR1.id);
        Insert objWR;
        objWR = [select Region__c from World_Region__c where ID =: objWR.Id];
        system.debug('*******objWR*****'+objWR);
         system.debug('*******objWR.Region__c*****'+objWR.Region__c);*/
        
        //Create Location
        //Location__c ObjLOC = new Location__c(Name='Test', World_Region1__c=objWR.Id);
        Location__c ObjLOC = new Location__c(Name='Test', Source_System_Account_ID__c='Test',Country__c='India');
        Insert ObjLOC;
        
        // Create Account
        Account objAccount = TestingSetupDataUtil.createAccount('TestAccount', 'shaijan.thomas@hp.com','Customer');
        objAccount.MDCP_Organization_ID__c = '12345';
        objAccount.Mdcp_SiteId__c ='1234';
        objAccount.MDCP_Site_Instance_Id__c='1234';
        Insert objAccount;
        
        // Create Opportunity
        Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty1',system.today()+30);
        objOpportunity.Deal_Id__c = '123456';
        insert objOpportunity;
        
        // Search for login user for Self enabled 
        user objUser = [select Id, Partner_Self_Service_Enabled__c from user where id =:Userinfo.getUserId()];
        objUser.Portal_Tab_Access__c = 'Deal Reg';
        objUser.Location_Record_Id__c = ObjLOC.Id;
        objUser.HPPID__c = '123';
        update objUser;
        
        //Query to get the Opportunity_ID__c, auto number Field
       Opportunity objOpportunity1 = [select Account.Mdcp_SiteId__c,Account.MDCP_Site_Instance_Id__c,CurrencyIsoCode,Account.MDCP_Organization_ID__c,Deal_Id__c,Opportunity_ID__c  from Opportunity where id=:objOpportunity.Id];
        objUser.Partner_Self_Service_Enabled__c=false;
        update objUser;
         
        ApexPages.StandardController PartnerQuote = new ApexPages.StandardController(objOpportunity1);
        CPQPartnerHPQuoteController PartnerQu = new CPQPartnerHPQuoteController(PartnerQuote);
        PartnerQu.Wait();
        PartnerQu.createQuote();
        PartnerQu.editQuote(); 
        
        objUser.Partner_Self_Service_Enabled__c=true;
        update objUser;
        ApexPages.StandardController PartnerQuote1 = new ApexPages.StandardController(objOpportunity1);
        CPQPartnerHPQuoteController PartnerQu1 = new CPQPartnerHPQuoteController(PartnerQuote1);
        PartnerQu1.createQuote();
        PartnerQu1.editQuote();
        
        Test.stopTest();
    }
}