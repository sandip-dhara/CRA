@isTest(SeeAllData=true)
private class CPQEmailWebServiceTest{
    //Test Method 
        public static testMethod void  EmailWebServiceTest() {
        Test.startTest();
        CPQEmailWebService.GenerateEmailBody('test');
        
        User objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
        objUser.Business_Group__c = 'PPS';
        objUser.Region__c = 'EMEA';
        objUser.Country = 'Germany';
        update objUser;
        
        // Create Account
        Account objAccount = TestingSetupDataUtil.createAccount('TestAccount', 'shaijan.thomas@hp.com','Customer');
        Insert objAccount;
        
        // Create Opportunity
        Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty1',system.today()+30);
        insert objOpportunity;
        
        //Create Support Request
        Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('Quote-to-Order-PSS-CPQ');
        Id recordTypeId = null;
        PPS_Field_And_Type_Mapping__c objPPSFieldMapping;
        support_request__c objSupportRequest = New support_request__c();
        
        //create a test Support Request
        if(csRecord!=null)
            recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
        objSupportRequest = TestingSetupDataUtil.createSupportRequest(objOpportunity.id,'Request description');
        if(recordTypeId !=null){
            objSupportRequest.recordTypeId = recordTypeId;
            objSupportRequest.Request_Submitted_From__c = csRecord.View_VF_Page_Name__c;
        }
        objSupportRequest.CC_Email_Address__c = 'shaijan.thomas@hp.com;aa@hp.com;1ac@hp.com;1fg@hp.com';
        objSupportRequest.Routing_Region__c  = 'EMEA';
        objSupportRequest.Special_Pricing__c = 'Revision';
        objSupportRequest.CPQ_Routing_Country__c = 'Germany';
        //objSupportRequest.CPQ_Routing_Territory__c = 'TestTerrirotry';
        //objSupportRequest.CPQ_Other_Routing_Criteria__c='Other';
        insert objSupportRequest;
        
        objSupportRequest = [select Name from Support_Request__c where id =:objSupportRequest.Id];
        CPQEmailWebService.GenerateEmailBody(objSupportRequest.Name);
        Test.stopTest();
    }
}