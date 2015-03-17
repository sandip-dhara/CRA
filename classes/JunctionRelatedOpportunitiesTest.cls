/**
    @author Accenture
    @date 2-May-2012
    @description This class is test class for the controller JunctionRelatedOpportunitiesController.
*/

@isTest(SEEALLDATA=True)
private class JunctionRelatedOpportunitiesTest {
    public static Related_Opportunities__c relOp;
    public static Account acc;
    public static Opportunity master,related; 
    


    public static void setupData() {
        acc = new Account();
        acc = TestingSetupDataUtil.createAccount('Test Account', 'account@accenture.com', 'Customer');
        insert acc;
        System.assertEquals(acc.Id != null, true);
        master = new Opportunity();
        related = new Opportunity();
        master = TestingSetupDataUtil.createOpportunity(acc.Id, 'Test Master', System.today().addDays(30));
        related = TestingSetupDataUtil.createOpportunity(acc.Id, 'Test Related', System.today().addDays(30));
        List<Opportunity> lstOpp = new List<Opportunity>();
        lstOpp.add(master);
        lstOpp.add(related);
        insert lstOpp;
        System.assertEquals(lstOpp.size(), 2);
        System.assertEquals(master.Name == 'Test Master', true);
        System.assertEquals(related.Name == 'Test Related', true);
        
        relOp = new Related_Opportunities__c();       
        relOp = TestingSetupDataUtil.createRelatedOpportunities(master.Id, related.Id);
        insert relOp;
        System.assertEquals(relOp.Id != null, true);
    }

    private static testMethod void testJunction() {     
        Test.startTest();
        setupData();
        ApexPages.StandardController stdController = new ApexPages.StandardController(relOp);
        JunctionRelatedOpportunitiesController ext = new JunctionRelatedOpportunitiesController(stdController);
        
        String keyPrefix = Related_Opportunities__c.sObjectType.getDescribe().getKeyPrefix();

       
        PageReference pg = new PageReference('/' + keyPrefix + '/e?retURL=/' + relOp.Opportunity__c);
        Test.setCurrentPage(pg);
        
        PageReference retPg = new PageReference('/' + relOp.Opportunity__c);
        
        System.assertEquals(ext.Save().getUrl(),retPg.getUrl());
        System.assertEquals(ext.Cancel().getUrl(),retPg.getUrl());
        
        relOp.Related_Opportunity__c = null;
        update relOp;

        System.assertEquals(ext.Save(),null);        
        System.assertEquals(ext.Cancel().getUrl(),retPg.getUrl());

        Test.stopTest();
    }

}