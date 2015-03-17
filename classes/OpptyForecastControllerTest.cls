/**********************************************************
* Class Name: OpptyForecastControllerTest
* Author: Debmalya, HP
* Date: 06-Aug-2013   
* Description: Test Class for OpptyForecastVSLineItem controller
***********************************************************/

@isTest(SeeAllData=True)
private class OpptyForecastControllerTest{
    
    static testMethod void testOpptyForecastVSLineItem(){
        Test.startTest();
        
        Account objAccount = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1211@partnercollab.com','Customer');
        objAccount.ShippingStreet = 'Test Street';
        objAccount.ShippingState = 'Test State';
        objAccount.ShippingCity = 'Test City';
        objAccount.ShippingCountry = 'Test Country';
        objAccount.ShippingPostalCode = 'Test Postal';
        insert objAccount;
        
        Product2 objProduct = TestingSetupDataUtil.createProduct(True, 'HPFS', 'USD', null);
        objProduct.CanUseRevenueSchedule = true;
        objProduct.CanUseQuantitySchedule = true;
        insert objProduct;
        
        Pricebook2 HPPricebook = [select id from Pricebook2 where IsStandard = true limit 1];
        
        PricebookEntry objPricebookEntry = TestingSetupDataUtil.createPricebookEntry(objProduct.Id,true,HPPricebook.Id,1000,'USD');
        insert objPricebookEntry;
        
        Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty',system.today()+30);
        objOpportunity.Route_To_Market__c = 'Direct';
        objOpportunity.CurrencyIsoCode = 'USD';
        try{
        insert objOpportunity;
        }catch(Exception e){}
        
        List<OpportunityLineItem> listOpptyLineItem = new List<OpportunityLineItem>();
        OpportunityLineItem objOpptyLineItem = new OpportunityLineItem();
        objOpptyLineItem.PricebookEntryId=objPricebookEntry.Id;
        objOpptyLineItem.OpportunityId = objOpportunity.Id;
        objOpptyLineItem.Quantity = 3;
        objOpptyLineItem.UnitPrice = 100.00;
        objOpptyLineItem.ServiceDate = system.today()+35;
        objOpptyLineItem.Keep__c = true; 
        listOpptyLineItem.add(objOpptyLineItem);
        
        OpportunityLineItem objOpptyLineItem1 = new OpportunityLineItem();
        objOpptyLineItem1.PricebookEntryId=objPricebookEntry.Id;
        objOpptyLineItem1.OpportunityId = objOpportunity.Id;
        objOpptyLineItem1.Quantity = 3;
        objOpptyLineItem1.UnitPrice = 100.00;
        objOpptyLineItem1.ServiceDate = system.today()+35;
        listOpptyLineItem.add(objOpptyLineItem1);
        
        insert objOpptyLineItem1;
        
        OpportunityLineItemSchedule objOpportunityLineItemSchedule = new OpportunityLineItemSchedule();
        objOpportunityLineItemSchedule.opportunityLineItemid=listOpptyLineItem[1].Id;
        objOpportunityLineItemSchedule.Revenue = 100;
        objOpportunityLineItemSchedule.ScheduleDate = system.today().addMonths(3);
        objOpportunityLineItemSchedule.type = 'Revenue';
        insert objOpportunityLineItemSchedule;
        
        PageReference pageRef = Page.VFPageforReport;
        Test.setCurrentPageReference(pageRef);
        
        OpptyForecastVSLineItem controllerForVf = new OpptyForecastVSLineItem();
        
        PageReference pageRef2 = Page.VFPageforTeamReport;
        Test.setCurrentPageReference(pageRef2);
        
        OpptyForecastVSLineItem controllerForVf2 = new OpptyForecastVSLineItem();
        
        Test.stopTest();
    }
}