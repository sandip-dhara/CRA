@isTest
private class hpCommonTracker {
    private static Account objAccount;
    static testMethod void myUnitTest() 
    {
        hpcommon objhpcommon = new hpCommon ();
        
        
        objhpcommon.IsUserLoggedIn();
        
        hpcommon.IsPasswordValid('planman123');
        hpcommon.GetLoginPageUrl();
        hpcommon.IsNull(7);
        hpcommon.IsNull(7.5);
        hpcommon.IsNull(system.today());
        
        objAccount =  new Account();
        objAccount.Name = 'Test Account';
        // insert Account
        insert objAccount;
        
        hpcommon.IsNull(objAccount.id);
       
    }
}