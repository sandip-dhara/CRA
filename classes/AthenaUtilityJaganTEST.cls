@isTest
Public Class AthenaUtilityJaganTEST
{
    static testMethod void runathenatest(){
        Application_Setting__c asg = new Application_Setting__c();
        asg.name__c = 'testname';
        asg.value__c='testvalue.jpg';
        insert asg;
        // tag data
        // 
       list<Tag__c> tags = new list<Tag__c>();
       Tag__c tag1 = new Tag__c();
       Tag__c tag2 = new Tag__c();
       tag1.value__c = 'test1';
       tags.add(tag1);
       tag2.value__c = 'test2';
       tags.add(tag2);
       
            insert tags;
            
        // public List<Tag__c> getTags(){
    //List<Tag__c> tags=[SELECT Value__c FROM Tag__c];
    //return tags
        AthenaUtility au = new AthenaUtility();
        
        string s = au.ApplicationSettingValue(asg.name__c);
        list<tag__c> tagsout = au.getTags();
        
        system.assertEquals(asg.Value__c, s);
        system.assertEquals(tags,tagsout);
    }
}