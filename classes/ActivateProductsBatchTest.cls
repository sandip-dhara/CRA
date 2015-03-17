/**********************************************************
* Class Name: ActivateProductsBatchTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage
*              for ActivateProductsBatch class. 
***********************************************************/
@isTest
private class ActivateProductsBatchTest {

    static testMethod void testActivateProductsBatch() {
        List<Product2> prodList = new List<Product2>();
        Product2 prd;

        for(Integer index = 0; index < 5; index++) {
            prd = new Product2();
            prd.Name = 'Test Product ' + index;
            prd.Sub_Product_Line__c = 'Test Product ' + index;
            prodList.add(prd);
        }
        insert prodList;
        system.debug('--->prodList : ' + prodList);
        system.assert(prodList[0].Name=='Test Product 0',true); 
        Test.startTest();
        ActivateProductsBatch batch = new ActivateProductsBatch();
        ID batchprocessid = Database.executeBatch(batch, 10);
        Test.stopTest();
    }
}