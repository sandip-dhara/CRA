/***********************************************************
* Class Name: supportRequestViewIntermediateControllerTest
* Author: HP
* Date: 20-JAN-2013 
* Requirement # Request Id: 
* Description: This class does the test coverage for supportRequestViewIntermediateController Functionality
***********************************************************/


@isTest(SeeAllData=true)
private class SRViewIntermediateControllerTest{
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
            
            //Product2 objProduct = [select Name,id from Product2 where isActive=true limit 1];
            //PricebookEntry objPriceBookEntry = [select product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id =:objProduct.id and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='EUR'  limit 1];
            PricebookEntry objPriceBookEntry = [select CurrencyIsoCode,product2Id,UnitPrice,Pricebook2Id,IsActive from PricebookEntry where Product2Id in (select id from Product2 where isActive=true) and Pricebook2.Name=: Label.PriceBook_Name and CurrencyIsoCode ='USD' and isActive=true  limit 1];
            
            Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty',system.today()+30);
            objOpportunity.Route_To_Market__c = 'Direct';
            objOpportunity.CurrencyIsoCode = objPriceBookEntry.CurrencyIsoCode;
            insert objOpportunity;
            
            List<OpportunityLineItem> listOpptyLineItem = new List<OpportunityLineItem>();
            OpportunityLineItem objOpptyLineItem = new OpportunityLineItem();
            objOpptyLineItem.PricebookEntryId=objPriceBookEntry.Id;
            objOpptyLineItem.OpportunityId = objOpportunity.Id;
            objOpptyLineItem.Quantity = 3;
            objOpptyLineItem.UnitPrice = 100.00;
            objOpptyLineItem.ServiceDate = system.today()+35;
            objOpptyLineItem.Keep__c = true; 
            listOpptyLineItem.add(objOpptyLineItem);
            
            OpportunityLineItem objOpptyLineItem1 = new OpportunityLineItem();
            objOpptyLineItem1.PricebookEntryId=objPriceBookEntry.Id;
            objOpptyLineItem1.OpportunityId = objOpportunity.Id;
            objOpptyLineItem1.Quantity = 3;
            objOpptyLineItem1.UnitPrice = 100.00;
            objOpptyLineItem1.ServiceDate = system.today()+35;
            listOpptyLineItem.add(objOpptyLineItem1);
            
            insert listOpptyLineItem;

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
          
            ApexPages.StandardController SRViewInterCtrl1 = new ApexPages.StandardController(objSupportRequest);            
            supportRequestViewIntermediateController SRViewInterCtrl11 = new supportRequestViewIntermediateController(SRViewInterCtrl1);            
            PageReference prefSubmit1 = SRViewInterCtrl11.redirect();
            
            objSupportRequest.Request_Submitted_From__c = null;
            update objSupportRequest;
            ApexPages.StandardController SRViewInterCtrlA = new ApexPages.StandardController(objSupportRequest);            
            supportRequestViewIntermediateController SRViewInterCtrlB = new supportRequestViewIntermediateController(SRViewInterCtrlA);            
            PageReference prefSubmitA = SRViewInterCtrlB.redirect();
            
        Test.stopTest();
}

}