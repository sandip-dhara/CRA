@isTest
public class OAE_AllTests {

public static testmethod void All_OAE_Tests() {

    OAE_DataSetup.installTests();
    OAE_AllTests.TestEngine();
    OAE_TriggerTester.TestTriggers();
    OAE_VFOverrideTester.TestPageControllers();
    OAE_SetupPagesTester.TestSetupPageControllers();
}
    public static void TestEngine() {
//      List<ID> leadIDs = new List<ID>{'00Q5000000TzdRd','00Q5000000TzdRU','00Q5000000TzdRp','00Q5000000TzdRi','00Q5000000TzdRX'};
        List<Lead> testLeads = [select ID from Lead where LastName = 'zzTester'];
        List<ID> leadIDs = new List<ID>();
        for (Lead l : testLeads) leadIDs.add(l.id);
        OAE_ObjectAssign oaClass = new OAE_ObjectAssign();
        Map<ID,scoreObj[]> leadResults = oaClass.objectAssign(leadIDs,5);
        for (ID thisID : leadResults.keySet()) {
            system.debug(thisID);
            system.debug(leadResults.get(thisID));
        } 
        oaClass.objectAssign(leadIDs,-1);
    }
}