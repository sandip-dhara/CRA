@isTest(seeAllData = true)
private class ContractOnCaseControllerTest{

    Static testMethod void testContractCase(){
    
    /*Intializing Test Data */
    /*Profile*/
    Profile p = [select id from Profile limit 1];
    
    /* User */
    User usr = new User(Lastname = 'tsng', Firstname= 'tsng', Username = 'testing0123@hp.com', Alias='tsng', CommunityNickname='hpfs010test', Email='test0123@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test0123@hp.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='487547', Business_Group__c='TS', ProfileId = p.id, Adoption_Role_Type__c='Executive');
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
    List<Contract_Reference__c> ContractList = new List<Contract_Reference__c>();
    Contract_Reference__c cref = new Contract_Reference__c(Name='Test_contract012',Original_Opportunity__c=opty.id, Accounts__c=acc.id);
    ContractList.add(cref);
    
    Contract_Reference__c cref1 = new Contract_Reference__c(Name='Test_contract034',Original_Opportunity__c=opty.id, Accounts__c=acc.id);
    ContractList.add(cref1);
    
    Contract_Reference__c cref2 = new Contract_Reference__c(Name='Test_contract056',Original_Opportunity__c=opty.id, Accounts__c=acc.id);
    ContractList.add(cref2);
    insert ContractList;
           
            
    /* Case */
    List<Case> CaseList = new List<Case>();
    Case cs = TestingSetupDataUtil.createCase('Question', 'Salesforce', 'New', usr.id);
    cs.Request_Type__c='Customer Research';
    cs.BG__c='TS';
    cs.Region__c='AMS';
    cs.Country__c='Canada';
    cs.Requestor_s_TimeZone__c='(GMT-04:00) Eastern Daylight Time (America/New_York)';
    cs.Subject='123TestConCase';
    cs.Work_Location__c='GBS - Back Office';
    cs.CurrencyIsoCode='USD';
    cs.Route_to_Market__c='Direct';
    cs.Business_Type__c='Standard';
    cs.SelectedContracts__c=cref.id;
    //cs.RecordType='CO Case';
    //cs.BusinessHours='United States-America/New_York';
    CaseList.add(cs);
    insert CaseList;     
    
    /* Related Contracts */
    List<Related_Contracts__c> relConList = new List<Related_Contracts__c>();
    for(Case Caserecord : CaseList){
        if(Caserecord.SelectedContracts__c !='' && Caserecord.SelectedContracts__c !=null){
            String [] contractrefrenceid=Caserecord.SelectedContracts__c.split(',');
            for(String contarctid: contractrefrenceid){    
                Related_Contracts__c relCon = new Related_Contracts__c ();
                relCon.Case__c=Caserecord.id;
                relCon.Contract_Reference__c=contarctid; 
                relConList.add(relCon); 
            }
        }    
    }
    insert relConList;
    
    test.startTest();
    ContractOnCaseController.ContractOnCase(CaseList);    
    test.stopTest();     
    //}
    }
}