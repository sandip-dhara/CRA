/**********************************************************
* Class Name: CaseTriggerUtilTest
* Author: Accenture
* Date: 04-May-2012 
* Description: This class is used as Test Class for the  CaseTriggerUtil.  
***********************************************************/

@isTest
public class CaseTriggerUtilTest {
    static Account account;
    static Case caseObj;
    static String errorMessage;
    static User usr;
    static TurnValidationOff__c testsetting;
    
    /**
    * @description Prepare data & execute positive test for Controller Class
    *
    * @return Void
    */
    private static void setupData(){
                
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        usr = new User();
        usr = TestingSetupDataUtil.createUser('st'+randomstr.substring(0,4), randomstr+'standarduser@hp.com', randomstr+'standarduser@hp.com', 
                                                'UTF-8', 'U LastName', 'en_US', 'en_US', 'America/Los_Angeles', randomstr+'standarduser12@hp.com', 
                                                randomstr+'5', Userinfo.getProfileId()); 
        usr.Adoption_Role_Type__c ='Test';                                                                       
        insert usr;
        System.assertEquals('U LastName',usr.lastName);
     
        //Create test data for case obj 
        
        caseObj = new Case();
        caseObj = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New',  Userinfo.getUserId());
        insert caseObj;
     
        System.assertEquals('Other',caseObj.Reason);
        /*testsetting = new TurnValidationOff__c();
        testsetting = TestingSetupDataUtil.createTurnValidationOff('005K0000000ekak');
        insert testsetting;
        System.assertEquals(testsetting.Id != null, true);*/
        Admin_Profiles__c adminprof = new Admin_Profiles__c();
        adminprof = TestingSetupDataUtil.createAdminProfile('System Administrator', 'Account Team', Userinfo.getProfileId());
        insert adminprof;
        System.assertEquals(adminprof.Id != null, true);
    }

    
    /**
    * @description: to test validation from account trigger
    */
    static testMethod void testCaseTriggerControllerUtil() {
        
        Test.startTest();
        setupData();
        CaseTriggerUtil.insertCaseFlag = false;
        caseObj.OwnerId = usr.Id;
        /* Trying to update case to test the trigger validation */
        try {
            update caseObj;
        } catch(Exception ex) {
            errorMessage = ex.getMessage();
        }
        /* If errorMessage is not null, then test method will PASS */
        System.assertNotEquals('', errorMessage);
        
        /* RunAs testUser*/
        System.runAs(usr) {
            caseObj.Origin = 'Salesforce';
            /* Trying to update Case to test the trigger validation */
            try {
                update caseObj;
            } catch(Exception ex) {
                errorMessage = ex.getMessage();
            }
            /* If errorMessage is not null, then test method will PASS */
            System.assertNotEquals('', errorMessage);
        }
        
        CaseTriggerUtil.insertCaseFlag = true;
        System.runAs(usr) {
            caseObj.Origin = 'Salesforce';
            /* Trying to update Case to test the trigger validation */
            try {
                update caseObj;
            } catch(Exception ex) {
                errorMessage = ex.getMessage();
            }
            /* If errorMessage is not null, then test method will PASS */
            System.assertNotEquals('', errorMessage);
        }
        
        Test.stopTest();
   }
   
   /**
    * @description: Test Method to for CO Case Functionality:Debmalya:R5:28th May, 2013:Insert new Case:Start
    */
    static testMethod void testCaseTriggerControllerCOCase() {
        Test.startTest();
        caseObj = new Case();
        caseObj = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New',  Userinfo.getUserId());
        caseObj.RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Case','CO Case');
        caseObj.Case_Origin_is_Interface__c = false;
        caseObj.Rework_Revision__c = 'N/A';
        caseObj.Assign_to_Team__c = 'Standard Assignment';
        caseObj.Country__c = 'Japan';
        caseObj.Request_Type__c ='Customer Research';
        insert caseObj;
        Test.stopTest();
    }
    //CO Case Functionality:Debmalya:R5:28th May, 2013:Insert new Case:End
    
    /*
    * @description: Test Method to for CO Case Functionality:Debmalya:R5:28th May, 2013:Insert subCase:Start
    */
     static testMethod void testCaseTriggerControllerCOSubCase() {
        Test.startTest();
        //setupData();
        String cocaseId = RecordTypeIdHelper.getRecordTypeId('Case','CO Case');
        system.debug('rewcocasetest' + cocaseId);
        
        //Insert User Data
        OAE_DataSetup.setupEngineProperties();
        UserData__c userDatainfo = new UserData__c();
        userDatainfo.Available__c = true;
        userDatainfo.User__c = Userinfo.getUserId();
        insert userDatainfo;
        
        //Insert New case
        HPUtils.CaseAfterInsert = false;
        Case newCase = new Case();
        newCase = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New',  Userinfo.getUserId());
        newCase.RecordTypeId = Id.valueof(cocaseId);
        newCase.Case_Origin_is_Interface__c = false;
        newCase.Rework_Revision__c = 'N/A';
        newCase.Request_Type__c = 'Test-Request-Type';
        newCase.Sub_Case_Type__c = 'Test-Subcase-Type';
        newCase.Assign_to_Team__c = 'Standard Assignment';
        newCase.Country__c = 'Japan';
        newCase.Request_Type__c ='Customer Research';
        insert newCase;
        
        
        
        newCase.OwnerId  = Userinfo.getUserId();
        update newCase;
        
        HPUtils.CaseAfterInsert = false;
        Case rework_caseObj = new Case();
        rework_caseObj = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New',  Userinfo.getUserId());
        rework_caseObj.RecordTypeId = Id.valueof(cocaseId);
        rework_caseObj.Case_Origin_is_Interface__c = false;
        rework_caseObj.Rework_Revision__c = 'Rework';
        rework_caseObj.ParentId = newCase.Id;
        rework_caseObj.Rework_to__c = newCase.Id;
        rework_caseObj.BG__c = 'TS';
        rework_caseObj.Business_Type__c = 'Standard';
        rework_caseObj.Case_Classification__c = 'Medium';
        rework_caseObj.Request_Type__c = 'Test-Request-Type';
        rework_caseObj.Sub_Case_Type__c = 'Test-Subcase-Type';
        system.debug('rework-insert' + rework_caseObj);
        insert rework_caseObj;
        
        userDatainfo.Available__c = false;
        update userDatainfo;
        
        CaseExternalSystemMapper__c req_subcaseMap = new CaseExternalSystemMapper__c();
        req_subcaseMap.LevelofExpertise__c = '1';
        req_subcaseMap.Request_Type__c = 'Test-Request-Type';
        req_subcaseMap.SystemValue__c = 'Test-Subcase-Type';
        req_subcaseMap.Origin__c = 'Salesforce';
        req_subcaseMap.Classification__c = 'Request Type - Subcase Type mapper';
        insert req_subcaseMap;
        
        HPUtils.CaseAfterInsert = false;
        Case revision_caseObj = new Case();
        revision_caseObj = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New',  Userinfo.getUserId());
        revision_caseObj.RecordTypeId = Id.valueof(cocaseId);
        revision_caseObj.Case_Origin_is_Interface__c = false;
        revision_caseObj.Rework_Revision__c = 'Revision';
        revision_caseObj.ParentId = rework_caseObj.Id;
        revision_caseObj.Rework_to__c = newCase.Id;
        revision_caseObj.BG__c = 'PPS';
        revision_caseObj.Request_Type__c = 'Test-Request-Type';
        revision_caseObj.Sub_Case_Type__c = 'Test-Subcase-Type';
        insert revision_caseObj;
        
        String caseIdList = String.valueof(newCase.Id) + ';' + String.valueof(rework_caseObj.Id) + ';' + String.valueof(revision_caseObj.Id) + ';';
        //caseIdList = String.valueof(newCase.Id) + ';' + String.valueof(rework_caseObj.Id) + ';' + 'revision_caseObj.Id';
        system.debug('debtestclass01' + caseIdList);
        CaseTriggerController.caseAssignmentthroughOAEforList(caseIdList);
        
        Test.stopTest();
    }
    //CO Case Functionality:Debmalya:R5:28th May, 2013:Insert subCase:End
     
 }