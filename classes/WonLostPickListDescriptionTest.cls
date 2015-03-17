@isTest
private class WonLostPickListDescriptionTest {
static testMethod void WonlostDescriptionTest() {
test.startTest();
        /* Testing Constructor */
        
        Won_Lost_Analysis__c obj=new Won_Lost_Analysis__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        WonLostPickListDescription wonlostpick= new WonLostPickListDescription(stdController);
        //wonlostpick.returnlist();
        test.stopTest();
        } 

}