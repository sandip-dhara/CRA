/**********************************************************
* Class Name: suppportRequestAssignEngineTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage for suppportRequestAssignEngine class.
***********************************************************/
@isTest(SeeAllData=true)
private class suppportRequestAssignEngineTest{
    static PageReference pref;
    static Support_Request__c sRequest;
    static User userTest;
    static Support_Request__c sRequest2;
    
    private static void setupTestUser(){
        //generate Random String 
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        // Insert User
        userTest =TestingSetupDataUtil.createUser('AE'+randomstr.substring(0,4),randomstr+'AssignEng@hp.com',randomstr+'userTest@AssignEngTest.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','AssignEng@ae.com',randomstr.substring(0,6),Userinfo.getProfileId());
        insert userTest ;
    }
    private static void setupData() {
        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@hp.com','Customer');
        insert acc;
        
        //create a test opportunity
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        insert opty;

        Support_Request_FS_CS__c sRequestFieldRow = Support_Request_FS_CS__c.getValues('Event-Demo');
        
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Support_Request__c' and name=:sRequestFieldRow.RecordType_Name__c LIMIT 1];
        
        SupportRequest_Routing_Rules__c rule = new SupportRequest_Routing_Rules__c();
        rule.Form_Name_RecordType_Name__c = rt.Name;
        rule.NotificationToEmail__c ='testsupportNotification@hp.com';
        rule.AssignTo__c = userinfo.getuserid();
        rule.Business_Group__c = sRequestFieldRow.Eligible_BG__c.split(';')[0];
        rule.Region__c = 'Test Region';
        rule.Sub_Region__c = 'Test SubRegion';
        rule.Country__c = 'Test Country';
        rule.Workshop_Type__c = 'Test WorkShop';
        rule.Email_Template__c ='SupReq_Event_Demo_Email_Template';
        insert rule;
        
        sRequest = TestingSetupDataUtil.createSupportRequest(opty.id,'Request description');
        sRequest.recordTypeId = rt.Id;
        sRequest.BG__c = sRequestFieldRow.Eligible_BG__c.split(';')[0];
        sRequest.Routing_Region__c = 'Test Region';
        sRequest.Routing_Sub_Region__c = 'Test SubRegion';
        sRequest.Routing_Country__c = 'Test Country';
        insert sRequest;
        
    }
    
    private static void setupData2() {
        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@hp.com','Customer');
        insert acc;
        
        //create a test opportunity
        Opportunity opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
        insert opty;
        
        //generate Random String 
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        
        Group grp = new Group(Name='supRequestq'+randomstr,Type='Queue');
        insert grp;
        
        QueueSobject newtestQ = new QueueSobject(QueueId = grp.Id, SobjectType = 'Support_Request__c');
        insert newtestQ;

        Support_Request_FS_CS__c sRequestFieldRow = Support_Request_FS_CS__c.getValues('Event-Demo');
        
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Support_Request__c' and name=:sRequestFieldRow.RecordType_Name__c LIMIT 1];
        
        SupportRequest_Routing_Rules__c rule = new SupportRequest_Routing_Rules__c();
        rule.Form_Name_RecordType_Name__c = rt.Name;
        rule.NotificationToEmail__c ='test@test.com';
        rule.AssignToQueue__c = 'supRequestq'+randomstr;
        rule.Business_Group__c = sRequestFieldRow.Eligible_BG__c.split(';')[0];
        rule.Region__c = 'Test Region';
        rule.Sub_Region__c = 'Test SubRegion';
        rule.Country__c = 'Test Country';
        rule.Workshop_Type__c = 'Test WorkShop';
        insert rule;
        
        sRequest2 = TestingSetupDataUtil.createSupportRequest(opty.id,'Request description');
        sRequest2.recordTypeId = rt.Id;
        sRequest2.BG__c = sRequestFieldRow.Eligible_BG__c.split(';')[0];
        sRequest2.Routing_Region__c = 'Test Region';
        sRequest2.Routing_Sub_Region__c = 'Test SubRegion';
        sRequest2.Routing_Country__c = 'Test Country2';
        insert sRequest2;
        
    }
    
    private static testMethod void suppportRequestAssignPositiveTest() {
        
        Test.startTest();
        setupTestUser();
        System.runAs(userTest){
            setupData();

            suppportRequestAssignEngine controller = new suppportRequestAssignEngine();
            suppportRequestAssignEngine.StartEngine(sRequest.id);
        }
        Test.stopTest();
    }
    
    private static testMethod void suppportRequestAssignPositiveTest2() {
        
        Test.startTest();
        setupTestUser();
        System.runAs(userTest){
            setupData2();

            suppportRequestAssignEngine controller = new suppportRequestAssignEngine();
            suppportRequestAssignEngine.StartEngine(sRequest2.id);
        }
        Test.stopTest();
    }
    
}