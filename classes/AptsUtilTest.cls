@isTest
public with sharing class AptsUtilTest {
    public static testmethod void testAptsUtil(){
        Test.startTest();
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Boolean val = AptsUtil.nullOrEmpty('Test');
        System.assert(!val);
        
        List<Object> obj = null;
        val = AptsUtil.nullOrEmpty(obj);
        System.assert(val);
        
        AptsUtil.createActivityLogEntry(acc.ID,'Test');
        
        System.assertNotEquals(AptsUtil.getCurrentUserProfile(),UserInfo.getProfileId());
        
        System.assertEquals(AptsUtil.parseUserName('avaru@apttus.com'),'avaru');
        
        //String str = 'ID = :'+UserInfo.getUserID();
        //\'IT Administrator\'
        AptsUtil.getActiveUserMap('Profile.Name = null');
        
        AptsUtil.getQueuesForUser(UserInfo.getUserID());
        
        Test.stopTest();
    }
}