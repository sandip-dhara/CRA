@isTest(seeAllData = true)
private class CaseContractAssociationControllerTest{

    Static testMethod void CaseContractAssociate(){
    
    /*Intializing Test Data */
   
    /*Profile*/
    Profile p = [select id from Profile limit 1];
    
    /* User */
    User usr = new User(Lastname = 'tsng', Firstname= 'tsng', Username = 'testing0123@hp.com', Alias='tsng', CommunityNickname='hpfs010test', Email='test0123@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0123@hp.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='487547', ProfileId = p.id, Adoption_Role_Type__c='Executive');
    insert usr;
    
    //System.runAs(usr){
        /* Account */
        Account acc = TestingSetupDataUtil.createAccount('TestCaseCon5501','testCaseContract@hp.com','Customer');
        insert acc;
                
        /* Opportunity */
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'testOpp123',System.Today()+30);   
        {
        opty.type = 'Renewal';
        opty.StageName = '01 - Understand Customer';
        opty.Route_To_Market__c='Direct';
        opty.Amount=10;    
        }
        insert opty;    
        
        /* Contract Reference */
        List<Contract_Reference__c> conList = new List<Contract_Reference__c>();
        for(Integer i = 0; i<100; i++){
            Contract_Reference__c c = new Contract_Reference__c(Name = 'TestCaseCon',Functional_Location__c='abc0123',SAID__c='135790864',AMP_ID__c='Test0123',Group_Contract_Nbr__c='09876543',Sales_Doc_Nbr__c='21314151',Sales_Organization__c='abc',Accounts__c=acc.Id,Contract_Admin_Name__c=usr.id);
            conList.add(c);        
        }
        insert conList;
        
        Test.startTest();
        ApexPages.StandardSetController Controller = new ApexPages.StandardSetController (new List<Contract_Reference__c>(conList));    
        CaseContractAssociationController CaseCon = new CaseContractAssociationController(Controller);
        
        CaseCon.getConPickList();
        
        /* New Case */
        CaseCon.searchCountry = 'United States';
        CaseCon.goSearch();
        CaseCon.next();
        CaseCon.contacteferencewrapperlist[0].choice=true;
        CaseCon.contacteferencewrapperlist[1].choice=true;
        CaseCon.contacteferencewrapperlist[2].choice=true;
        CaseCon.CreateCase();
        
        CaseCon.ClearSearch(); 
        CaseCon.previous();
        CaseCon.first();
        CaseCon.last();
        Boolean b = CaseCon.hasNext;
        b = CaseCon.hasPrevious;
        
        
        /* Search Criteria */
        CaseCon.searchCountry = 'Algeria';
        CaseCon.goSearch();
        CaseCon.searchExistingSAID ='135790864';
        CaseCon.goSearch();
        CaseCon.searchExistingAMPID = 'Test0123';
        CaseCon.goSearch();
        CaseCon.searchExistingGrpConNbr = '09876543';
        CaseCon.goSearch();
        CaseCon.searchExistingSalsDocNbr = '21314151';
        CaseCon.goSearch();
        CaseCon.searchExistingSalesOrg = 'abc';
        CaseCon.goSearch();
        CaseCon.searchExistingAcc = acc.id;
        CaseCon.goSearch();
        CaseCon.searchConAdmin = usr.id;
        CaseCon.goSearch(); 
        CaseCon.searchExistingRenewMonYr = '';
        CaseCon.goSearch();
        CaseCon.searchExistingLLFL='abc0123';           
        CaseCon.goSearch();              
        CaseCon.CreateCase(); 
                           
        Test.stopTest();
        //}
    }
}