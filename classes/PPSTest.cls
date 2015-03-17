/***********************************************************
* Class Name: PPSTest
* Author: HP
* Date: 21-OCT-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for Whole CPQ Functionality
***********************************************************/

@isTest(SeeAllData=true)
private class PPSTest{
    //Test Method 
    public static testMethod void CPQAllFunctionalityTest() {
        Test.startTest();
        User objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
        objUser.Business_Group__c = 'PPS';
        objUser.Region__c = 'EMEA';
        objUser.Country = 'Germany';
        update objUser;
        
        // Create Account
        Account objAccount = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1211@partnercollab.com','Customer');
        objAccount.ShippingStreet = 'Test Street';
        objAccount.ShippingState = 'Test State';
        objAccount.ShippingCity = 'Test City';
        objAccount.ShippingCountry = 'India';
        objAccount.ShippingPostalCode = 'Test Postal';
        insert objAccount;
        // Create Opportunity
        Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty',system.today()+30);
        objOpportunity.Route_To_Market__c = 'Direct';
        objOpportunity.Customer_Engagement__c = 'End User Sales';
        objOpportunity.Fulfillment__c = 'HP Fulfilled';
        objOpportunity.ForecastCategoryName = 'Pipeline';
        insert objOpportunity;
        //dsfa
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
        //objSupportRequest.CPQ_Routing_Country__c = 'Germany';
        objSupportRequest.CPQ_Routing_Country__c = objUser.Country; 
        objSupportRequest.Request_Description__c = 'TestDescription';
        //objSupportRequest.CPQ_Other_Routing_Criteria__c='Other';
        insert objSupportRequest;
        
        //Add Attachement to support Request
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objSupportRequest.id;
        insert attach;
         
        // create routing rule;
        SupportRequest_Routing_Rules__c routingrule = new SupportRequest_Routing_Rules__c();  
        routingrule.NotificationToEmail__c = 'shaijan.thomas@Hp.com';
        routingrule.Support__c = 'Quote-to-Order';
        routingrule.Support_Sub_Type__c='Config / Price / Quote';
        routingrule.BUSINESS_GROUP__C = objUser.BUSINESS_GROUP__C;
        routingrule.Region__c=objSupportRequest.Routing_Region__c;
        routingrule.Account__c=objOpportunity.Account.Name;
        routingrule.Country__c= objSupportRequest.CPQ_Routing_Country__c;
        routingrule.Territory__c = '';
        routingrule.Other_Criteria__c='';
        routingrule.Request_For__c='';
        routingrule.Form_Name_RecordType_Name__c = 'PPS-Quote-to-Order-Config-Price-Quote';
        insert routingrule;
        
        // Initalize controller
        objSupportRequest = [select Request_Description__c,BG__c,Routing_Region__c,name,CPQ_Routing_Country__c,CC_Email_Address__c,Opportunity__c,CPQ_Request_Type__c,Opportunity_ID_Formula__c,Forecast_Category__c,Requestor_Name__c,Requestor_email__c from support_request__c where id=:objSupportRequest.id];
        objSupportRequest.CPQ_Request_Type__c = 'Configuration only';
        objPPSFieldMapping = new PPS_Field_And_Type_Mapping__c (Required__c=True,Special_Pricing_only_New_OPG__c=True);
        ApexPages.StandardController CPQRequestCon = new ApexPages.StandardController(objSupportRequest);
        SUPPORTRequest_PPS_Form_Controller CPQESSNCont = new SUPPORTRequest_PPS_Form_Controller(CPQRequestCon);
        CPQESSNCont.routingEmailAddress = 'shaijan.thomas@hp.com';
        CPQESSNCont.getshowAllAttachmentget();
        CPQESSNCont.getcountryWithISO(); 
        CPQESSNCont.saveRequest();
        PageReference prefSubmit = CPQESSNCont.submitRequest();
        prefSubmit.getParameters().put('pageMode','View');
        
        Test.setCurrentPage(prefSubmit);
        SUPPORTRequest_PPS_Form_Controller CPQESSNCont1 = new SUPPORTRequest_PPS_Form_Controller(CPQRequestCon);
        CPQESSNCont1.sendEmailFromWebservice();
        CPQESSNCont.createPPSFieldMap(objPPSFieldMapping);
        CPQESSNCont.deleteAcctachment();
        CPQESSNCont.cancelRequest();
        PageReference pref3 = Page.PPSViewRequestForm;
        pref3.getParameters().put('pageMode','View');
        Test.setCurrentPage(pref3);
        CPQESSNCont1.sendEmailFromWebservice();
        prefSubmit.getParameters().put('pageMode','SpecialRevision');
        Test.setCurrentPage(prefSubmit);
        SUPPORTRequest_PPS_Form_Controller CPQESSNCont2 = new SUPPORTRequest_PPS_Form_Controller(CPQRequestCon);
        //CPQESSNCont2.sendEmailFromWebservice();

        objSupportRequest.CPQ_Request_Type__c = 'Manual Quote (for new/existing products)';
        CPQESSNCont.visibilityOfFields();
                
        objSupportRequest.CPQ_Request_Type__c = 'B2B Portal Quote (Products/Configuration exist/New)';
        CPQESSNCont.visibilityOfFields();

        objSupportRequest.CPQ_Request_Type__c = 'Update Offering';
        CPQESSNCont.visibilityOfFields();

        objSupportRequest.CPQ_Request_Type__c = 'B2B Portal Set-Up (new)';
        CPQESSNCont.visibilityOfFields();
        
        objSupportRequest.Special_Pricing__c = 'Revision';
        CPQESSNCont.visibilityOfSpecialRevisionFields();

        Test.stopTest();
    }
}