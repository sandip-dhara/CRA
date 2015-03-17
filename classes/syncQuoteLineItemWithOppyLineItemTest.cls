/***********************************************************
* Class Name: syncQuoteLineItemWithOpportunityLineItemTest
* Author: HP
* Date: 21-OCT-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for Whole syncQuoteLineItemWithOpportunityLineItemTest Functionality
***********************************************************/

@isTest(SeeAllData=true)
private class syncQuoteLineItemWithOppyLineItemTest{
    //Test Method 
    public static testMethod void CPQAllFunctionalityTest() {
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
            objAccount.ShippingCountry = 'Test Country';
            objAccount.ShippingPostalCode = 'Test Postal';
            insert objAccount;
            
           // Product2 objProduct = [select Name,id from Product2 limit 1];
            //PricebookEntry objPriceBookEntry = [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id =:objProduct.id and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='USD'  limit 1];
            PricebookEntry objPriceBookEntry = [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id in (select id from Product2) and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='USD'  limit 1];
            
            Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty',system.today()+30);
            objOpportunity.Route_To_Market__c = 'Direct';
            objOpportunity.CurrencyIsoCode = 'USD';
            objOpportunity.SAP_Feed__c = true;
            insert objOpportunity;
            
            List<OpportunityLineItem> listOpptyLineItem = new List<OpportunityLineItem>();
            OpportunityLineItem objOpptyLineItem = new OpportunityLineItem();
            objOpptyLineItem.PricebookEntryId=objPriceBookEntry.Id;
            objOpptyLineItem.OpportunityId = objOpportunity.Id;
            objOpptyLineItem.Quantity = 3;
            objOpptyLineItem.UnitPrice = 100.00;
            objOpptyLineItem.ServiceDate = system.today()+35;
            listOpptyLineItem.add(objOpptyLineItem);

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
            insert objSupportRequest;
            
            Support_Request__c objDeleteSupportRequest = new Support_Request__c();
            objDeleteSupportRequest = TestingSetupDataUtil.createSupportRequest(objOpportunity.id,'Request description');
            if(recordTypeId !=null){
                objDeleteSupportRequest.recordTypeId = recordTypeId;
                objDeleteSupportRequest.Request_Submitted_From__c = csRecord.View_VF_Page_Name__c;
            }
                
            insert objDeleteSupportRequest;
            
            //Create HP Quote
            HP_Quote__c objQuote = new HP_Quote__c(Quote_IDS_ID__c ='TestClass' ,Synced_To_Opportunity__c = true,Opportunity_Name__c = objOpportunity.Id,Name='testQuote',Support_Request__c=objSupportRequest.id,Hide_Record__c = false);
            objQuote.CurrencyIsoCode='EUR';
            insert objQuote;
            
            HP_Quote_Line_Item__c objLineItem = new HP_Quote_Line_Item__c(HP_Quote_Name__c =objQuote.id,Total_Sales_Price__c=1.00,Product_Name__c = objPriceBookEntry.product2Id );
            insert objLineItem;
            
            //Create Quote Sales Matric Code
            Quote_Sales_Metric_Code__c QSMC = new Quote_Sales_Metric_Code__c(HP_Quote__c=objQuote.Id,Total_Value__c=200.00);
            Insert QSMC;
           
            
            //ESSN Request Form
            objSupportRequest = [select BG__c,Routing_Region__c,name,CPQ_Routing_Country__c,CC_Email_Address__c,Opportunity__c,CPQ_Request_Type__c,Opportunity_ID_Formula__c,Forecast_Category__c,Requestor_Name__c,Requestor_email__c from support_request__c where id=:objSupportRequest.id];
            ApexPages.StandardController CPQRequestCon = new ApexPages.StandardController(objSupportRequest);
            CPQESSNRequestFormController CPQESSNCont = new CPQESSNRequestFormController(CPQRequestCon);
            CPQESSNCont.routingEmailAddress = 'mohit.bhatia@hp.com';
            
            //syncQuoteLineItemWithOpportunityLineItem
            syncQuoteLineItemWithOpportunityLineItem sync = new syncQuoteLineItemWithOpportunityLineItem();
            String syncOpty= syncQuoteLineItemWithOpportunityLineItem.syncQuoteLineItemWithOpptyLineItem(objOpportunity.Id,'True','USD','');
            
            //objOpportunity.CurrencyIsoCode = 'EUR';
            //update objOpportunity;
            
            //syncQuoteLineItemWithOpportunityLineItem sync1 = new syncQuoteLineItemWithOpportunityLineItem();
            ///String syncOpty1 = syncQuoteLineItemWithOpportunityLineItem.syncQuoteLineItemWithOpptyLineItem(objOpportunity.Id,'True','USD','');
        
        Test.stopTest();
}

}