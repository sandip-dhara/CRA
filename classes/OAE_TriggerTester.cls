@istest
public with sharing class OAE_TriggerTester {
public static void TestTriggers() {

    Profile sysProfile = [Select id, name from Profile where name = 'System Administrator'];
    User userMgr = new user(FirstName='Manager',LastName='Man',username='mgr1@hp.com',email='mgr1@hp.com',
        alias='mgr1',CommunityNickname='mgr1', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        ProfileId=sysProfile.id, LanguageLocaleKey='en_US',Email_Address__c='mgr1@hp.com',Legacy_Employee_Ref__c='1023456',Adoption_Role_Type__c='Test');
    insert userMgr;

    RuleScenario__c rs1 = new RuleScenario__c(name='first',ruleobject__c='Case');
    insert rs1;
    rs1.x1__c='1;2';
    update rs1;
    rs1.x1__c = '1;3;sucka!';
    update rs1;
    Requirement__c rq1 = new Requirement__c(RuleScenario__c=rs1.id, parameter__c='Severity', value__c='1', paramNumber__c=2, isOnShiftNow__c=false, isMinutesOnShift__c=false);
    insert rq1;
    Scoring__c sc1 = new Scoring__c(RuleScenario__c=rs1.id, parameter__c='Severity', value__c='1', points__c=200, paramNumber__c=2, isOnShiftNow__c=false, isMinutesOnShift__c=false);
    insert sc1;
    
    UserData__c ud1 = new UserData__c(User__c=userMgr.id,workloadpoints__c=0,available__c=false);
    insert ud1;
    ud1.Available__c = true;
    update ud1;
    
    UserSkill__c us1 = new UserSkill__c(UserData__c=ud1.id, parameter__c='Problem Category', value__c='Networking',baseObject__c='case',paramNumber__c=1);
    insert us1;
    us1.level__c = 'Expert';
    update us1;
    us1.level__c = null;
    update us1;
    UserSkill__c us2 = new UserSkill__c(UserData__c=ud1.id, parameter__c='Problem Category', value__c='Networking',level__c='Diablo',baseObject__c='case',paramNumber__c=1);
    insert us2;

    delete us1;
    delete ud1;
    delete rs1; 
}
}