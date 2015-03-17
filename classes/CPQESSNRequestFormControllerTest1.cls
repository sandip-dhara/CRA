/***********************************************************
* Class Name: CPQESSNRequestFormControllerTest1
* Author: HP
* Date: 21-JAN-2013 
* Requirement # Request Id: 
* Description: This class does the test coverage for CPQ Controller Functionality
***********************************************************/
@isTest(SeeAllData=true)
private class CPQESSNRequestFormControllerTest1{
    //Test Method 
        public static testMethod void CPQCtrlFunctionalityTest() {
        Test.startTest();
        List<HPQuoteController.QuoteWrapperClass> quoteWrapper = new  List<HPQuoteController.QuoteWrapperClass>();
         User objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
            objUser.Business_Group__c = 'ESSN';
            objUser.Region__c = 'EMEA';
            objUser.Country = 'Germany';
            update objUser;
            
            Account objAccount = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1211@partnercollab.com','Customer');
            objAccount.ShippingStreet = 'Test Street';
            objAccount.ShippingState = 'Test State';
            objAccount.ShippingCity = 'Test City';
            objAccount.ShippingCountry = 'India';
            objAccount.ShippingPostalCode = 'Test Postal';
            insert objAccount;
            
            //Product2 objProduct = [select Name,id from Product2 limit 1];
            //PricebookEntry objPriceBookEntry = [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id =:objProduct.id and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='USD'  limit 1];
            PricebookEntry objPriceBookEntry = [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id in (select id from Product2) and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='USD'  limit 1];
            
            Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty',system.today()+30);
            //objOpportunity.Route_To_Market__c = 'Direct';
            objOpportunity.Customer_Engagement__c = 'End User Sales';
            objOpportunity.Fulfillment__c = 'HP Fulfilled';
            objOpportunity.CurrencyIsoCode = 'USD';
            HPUtils.BGSpecificWorkflows = true;
            HPUtils.partnerUser.IsportalEnabled = true;
            objOpportunity.HPFS_Needed__c=true;
            insert objOpportunity;
            
           /* List<OpportunityLineItem> listOpptyLineItem = new List<OpportunityLineItem>();
            OpportunityLineItem objOpptyLineItem = new OpportunityLineItem();
            objOpptyLineItem.PricebookEntryId=objPriceBookEntry.Id;
            objOpptyLineItem.OpportunityId = objOpportunity.Id;
            objOpptyLineItem.Quantity = 3;
            objOpptyLineItem.UnitPrice = 100.00;
            objOpptyLineItem.ServiceDate = system.today()+35;
            listOpptyLineItem.add(objOpptyLineItem);*/

            //create a test Support Request
            Support_Request__c objSupportRequest = new Support_Request__c();
            Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
            Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('Quote-to-Order-ESSN-CPQ');
            Id recordTypeId = null;
            if(csRecord!=null){
                recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
            }
            objSupportRequest = TestingSetupDataUtil.createSupportRequest(objOpportunity.id,'Request description');
            if(recordTypeId !=null){
                objSupportRequest.recordTypeId = recordTypeId;
                objSupportRequest.Request_Submitted_From__c = csRecord.View_VF_Page_Name__c;
            }
            objSupportRequest.CC_Email_Address__c = 'mohit.bhatia@hp.com';
            objSupportRequest.CPQ_Request_Type__c = 'Configuration only (with list price)';
            objSupportRequest.Routing_Region__c  = 'EMEA';   
            objSupportRequest.CPQ_Routing_Country__c = objUser.Country;  
            insert objSupportRequest;
        //ESSN Request Form
            objSupportRequest = [select BG__c,Routing_Region__c,name,CPQ_Routing_Country__c,CC_Email_Address__c,Opportunity__c,CPQ_Request_Type__c,Opportunity_ID_Formula__c,Forecast_Category__c,Requestor_Name__c,Requestor_email__c from support_request__c where id=:objSupportRequest.id];
            ApexPages.StandardController CPQRequestCon = new ApexPages.StandardController(objSupportRequest);
            CPQESSNRequestFormController CPQESSNCont = new CPQESSNRequestFormController(CPQRequestCon);
            CPQESSNCont.routingEmailAddress = 'mohit.bhatia@hp.com';
            CPQESSNCont.getshowAllAttachmentget();
            
            objSupportRequest.CPQ_Request_Type__c = 'Special Pricing Only';
            CPQESSNCont.visibilityOfFields();
            objSupportRequest.CPQ_Request_Type__c = 'Legal Quote';
            CPQESSNCont.visibilityOfFields();
            objSupportRequest.CPQ_Request_Type__c = 'B2B Portal Quote (Products/Configuration exist)';
            CPQESSNCont.visibilityOfFields();
            objSupportRequest.CPQ_Request_Type__c = 'Update Offering';
            CPQESSNCont.visibilityOfFields();
            objSupportRequest.CPQ_Request_Type__c = 'B2B Portal Set-Up (new)';
            CPQESSNCont.visibilityOfFields();
            
            CPQFieldMapping__c objCPQFieldMapping = new CPQFieldMapping__c(Required__c=True,Configuration_only__c=True);

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
            routingrule.Form_Name_RecordType_Name__c = 'ESSN-Quote-to-Order-Config-Price-Quote';
            insert routingrule;
            CPQESSNCont.saveRequest();           
            CPQESSNCont.getcountryWithISO();
            PageReference prefSubmit = CPQESSNCont.submitRequest();
            CPQESSNCont.createCPQFieldMap(objCPQFieldMapping);
            CPQESSNCont.visibilityOfSpecialRevisionFields();
            CPQESSNCont.deleteAcctachment();
            CPQESSNCont.cancelRequest();
            CPQESSNCont.sectionVisibility();
            prefSubmit.getParameters().put('pageMode','View');
            
            Test.setCurrentPage(prefSubmit);
           
            CPQESSNRequestFormController CPQESSNCont1 = new CPQESSNRequestFormController(CPQRequestCon);
            CPQESSNCont1.sendEmailFromWebservice();
            
            
            Test.stopTest();
          
    }
}