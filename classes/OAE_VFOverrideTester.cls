@isTest
public with sharing class OAE_VFOverrideTester {

public static testmethod void TestPageControllers() {
    RuleScenario__c rs1 = RuleScenarioControllers();
    RequirementControllers(rs1);
    ScoringControllers(rs1);
    UserSkillControllers();
}
static void UserSkillControllers() {
    Profile sysProfile = [Select id, name from Profile where name = 'System Administrator'];
    User userMgr = new user(FirstName='Manager',LastName='Man',username='mgr2@hp.com',email='mgr2@hp.com',
        alias='mgr2',CommunityNickname='mgr2', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        ProfileId=sysProfile.id, LanguageLocaleKey='en_US', Email_Address__c='mgr2@hp.com', Legacy_Employee_Ref__c='01234562', Adoption_Role_Type__c='Test');
    insert userMgr;
    
    UserData__c ud1 = new UserData__c(user__c=userMgr.id,available__c=true,workloadPoints__c=0);
    insert ud1;
    UserSkill__c us1 = new UserSkill__c(userData__c=ud1.id);
    Test.setCurrentPage(Page.OAE_US_Edit);
    ApexPages.StandardController stdConUS = new ApexPages.StandardController(us1);
    OAE_US_EditExt usEditExt = new OAE_US_EditExt(stdConUS);
    usEditExt.getParamItems();
    us1.Parameter__c = 'Severity';
    usEditExt.getValueItems();
    usEditExt.refreshValues();
    us1.Parameter__c = 'Problem Category';
    usEditExt.getLevelItems();  
}
static void ScoringControllers(RuleScenario__c parentRS) {
    Scoring__c sc = new Scoring__c(RuleScenario__c = parentRS.ID);
    Test.setCurrentPage(Page.OAE_SC_Edit);
    ApexPages.StandardController stdConSC = new ApexPages.StandardController(sc);
    OAE_SC_EditExt scEditExt = new OAE_SC_EditExt(stdConSC);
    scEditExt.getParamItems();
    sc.Parameter__c = 'Severity';
    scEditExt.getValueItems();
    scEditExt.refreshValues();
    sc.Parameter__c = 'Problem Category';
    scEditExt.getLevelItems();  
}
static void RequirementControllers(RuleScenario__c parentRS) {
    Requirement__c rq = new Requirement__c(RuleScenario__c = parentRS.ID);
    Test.setCurrentPage(Page.OAE_RQ_Edit);
    ApexPages.StandardController stdConRQ = new ApexPages.StandardController(rq);
    OAE_RQ_EditExt rqEditExt = new OAE_RQ_EditExt(stdConRQ);
    rqEditExt.getParamItems();
    rq.Parameter__c = 'Severity';
    rqEditExt.getValueItems();
    rqEditExt.getShowNumbers();
    rqEditExt.refreshValues();
    rq.Parameter__c = 'Problem Category';
    rqEditExt.getLevelItems();
}
static RuleScenario__c RuleScenarioControllers() {
    //RSEdit
//  RuleScenario__c rs1 = new RuleScenario__c(name='VF Test', ruleObject__c='Lead');
    RuleScenario__c rs1 = new RuleScenario__c(name='VF Test', ruleObject__c='Lead', ruleObjectInternal__c='lead');
    insert rs1;
    Test.setCurrentPage(Page.OAE_RS_Edit);
    ApexPages.StandardController stdConRSE = new ApexPages.StandardController(rs1);
    OAE_RS_EditExt rsEditExt = new OAE_RS_EditExt(stdConRSE);
    rsEditExt.numberShown = 1.0;
    //rsEditExt.openSelectBox();
    rsEditExt.cancelOut();
    //rsEditExt.openSelectBox();
    rsEditExt.pickSelected = new List<String>{'1','3'};
    //rsEditExt.modifyPick();
    rsEditExt.getChecks();
    //rsEditExt.getPickItems();
    rsEditExt.getRSGrid();
    
    //RSView
    Test.setCurrentPage(Page.OAE_RS_View);
    ApexPages.StandardController stdConRSV = new ApexPages.StandardController(rs1);
    OAE_RS_ViewExt rsViewExt = new OAE_RS_ViewExt(stdConRSV);
    rsViewExt.getList1();
    rsViewExt.getList2();
    rsViewExt.getList3();
    rsViewExt.getList4();
    rsViewExt.getList5();
    rsViewExt.getList6();
    rsViewExt.getList7();
    rsViewExt.getList8();
    rsViewExt.getList9();
    rsViewExt.getList10();
    rsViewExt.getShow1();
    rsViewExt.getShow2();
    rsViewExt.getShow3();
    rsViewExt.getShow4();
    rsViewExt.getShow5();
    rsViewExt.getShow6();
    rsViewExt.getShow7();
    rsViewExt.getShow8();
    rsViewExt.getShow9();
    rsViewExt.getShow10();
    
    return rs1;
}
}