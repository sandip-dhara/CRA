/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData = true)
private class TMProcessIndustryRulesScheduledTest {

    static testMethod void myUnitTest() {
        
        test.startTest();
        
        /* Account inset*/ 
        List<Account> accList = new List<Account>();
        Set<Id> accSet = new Set<Id>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        for(Integer i=0;i<20;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD', EvaluateTerritory__c = false);
            accList.add(acc) ;
        }
        insert accList;
        System.assertEquals(accList[0].Name,'testAccount0');
        
        for(Account aObj : accList){
            accSet.add(aObj.Id);
        }
        
        //TM Industry Rules Test
        TMProcessIndustryRulesScheduled tm = new TMProcessIndustryRulesScheduled();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        //system.schedule('TM Industry Test :'+datetime.now(), schExp, tm);
        
        test.stopTest();
    }
}