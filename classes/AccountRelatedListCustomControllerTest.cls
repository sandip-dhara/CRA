/**********************************************************
* Class Name: AccountRelatedListCustomControllerTest
* Author: Debmalya, HP
* Date: 06-Aug-2013   
* Description: Test Class for AccountRelatedListCustomControllerPOC controller
***********************************************************/

@isTest
private class AccountRelatedListCustomControllerTest{
    
    static testMethod void testAccountRelatedLists(){
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
        
        PageReference pageRef = Page.Account_Child_Objects_Sales_Console_POC;
        Test.setCurrentPageReference(pageRef);
        
        AccountRelatedListCustomControllerPOC controllerForVf = new AccountRelatedListCustomControllerPOC();
        
        Test.stopTest();
    }
}