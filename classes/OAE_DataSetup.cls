public class OAE_DataSetup {

public static void setupFirstDataForDogAndPony() {
    ID dQID = OAE_DataSetup.initialQueueLoad('Lead');   
}
public static void setupSecondDataForDogAndPony() {
    Group dq = [select id, name from Group where name = 'Lead Default Triage Queue' limit 1];
    OAE_DataSetup.setUpParams('lead','Lead', dq.ID);
    OAE_DataSetup.setupEngineProperties();
    OAE_DataSetup.setUpData('Lead');
    OAE_DataSetup.createLeads();
}

public static void installTests() {
    //get a user or create one
    User sysU = getOrCreateUser();
    List<Group> lg = [select id, name from Group where name = 'Lead Default Triage Queue'];
    System.runAs(sysU) {
        ID dQID;
        if (lg.size() == 0)
            dQID = OAE_DataSetup.initialQueueLoad('Lead');
        else
            dQID = lg.get(0).id;
            
        if (InUseRoster__c.getInstance('lead') == null)
            OAE_DataSetup.setUpParams('lead','Lead', dQID);
    }
    
    if (EngineProperties__c.getInstance('NextUserSet') == null)
        OAE_DataSetup.setupEngineProperties();

    List<RuleScenario__c> lrs = [select id, Name from RuleScenario__c where Name= 'Web Leads'];
    if (lrs.size() == 0)
        OAE_DataSetup.setUpData('Lead');

    List<Lead> ll = [select id, company from Lead where company = 'zoom 4'];
    if (ll.size() == 0)
        OAE_DataSetup.createLeads();
}

/*
//TODO: Phase 2
        //time field on lead (date+72hrs)
        //lead workload field on UD

        //formula field on lead: Lead Region (Northwest, Southwest, Midwest, Northeast, The South)
        //increment field on lead:  Lead Increment Value  (<10k = 1, <40k = 2, <100k = 3, <250k = 4, 5)


    public final String custLeadFieldName = 'SizeBand__c';
    public final String custLeadFieldName = 'Region__c';
    public final String custLeadFieldLabel = 'Region';
    public final String leadIncrementFieldName = 'WorkloadIncrement__c';
    public final String leadIncrementFieldLabel = 'Lead Increment Value';
    public final String leadWorkloadFieldName = 'Lead_Workload__c';
    public final String leadWorkloadFieldLabel = 'Lead Workload';
*/
    public static User getOrCreateUser() {
        Profile sysProfile = [Select id, name from Profile where name = 'System Administrator'];
        //create a user
        List<User> sysUsers = [select id, profileID, isActive from User where ProfileId =:sysProfile.id  and isActive=true limit 1];
        
        if (sysUsers.size() > 0) return (sysUsers.get(0));
        
        User userMgr = new user(FirstName='Manager',LastName='Man',username='mgr1@oaev2.org',email='mgr1@oaev2.org',
            alias='mgr1',CommunityNickname='mgr1', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
            ProfileId=sysProfile.id, LanguageLocaleKey='en_US', Adoption_Role_Type__c='Test');
        insert userMgr;
        return userMgr;
    }

    public static ID initialQueueLoad(String objectLabel) {
        ID dqID;
        Group leadDefQueue = new Group(name=objectLabel + ' Default Triage Queue', type='Queue');
        insert leadDefQueue;
        QueueSobject lq = new QueueSobject(sobjecttype=objectLabel, queueid = leadDefQueue.id);
        insert lq;
            
        dqID = leadDefQueue.id;
        return dqID;
    }
    public static void setupEngineProperties() {
        EngineProperties__c nxtUSet = new EngineProperties__c(name='NextUserSet',DoubleValue__c=0);
        insert nxtUSet;
    }

    public static void setUpParams(String objectName, String objectLabel, ID defQID) {
        //1.  in use roster, reflecting the 3 rules and the fields needed for testing
        InUseRoster__c iur = new InUseRoster__c(Name = objectName, Bitz__c=7, UD_WorkloadField__c = 'LeadPoints__c',
                WorkloadIncrementField__c = 'WorkloadIncrement__c', DefaultQueue__c = defQID);
        insert iur;
    
        //2. adding 3 fields to rules (Industry, LeadSource, custom Size Band)
        List<EngineFields__c> lEF = new List<EngineFields__c>(); 
        lEF.add(new EngineFields__c(name=objectName+'1',label__c='Industry',type__c='Picklist',path__c='Industry',order__c=1,object__c=objectName));
        lEF.add(new EngineFields__c(name=objectName+'2',label__c='LeadSource',type__c='Picklist',path__c='LeadSource',order__c=2,object__c=objectName));
        lEF.add(new EngineFields__c(name=objectName+'3',label__c='Size Band',type__c='Custom',path__c='SizeBand__c',order__c=3,object__c=objectName));
        insert lEF;
    
        //3.  setting up the ruleBitz for the new rule, where at first the rules cover all
        List<RuleBitz__c> lRB = new List<RuleBitz__c>();
        lRB.add(new RuleBitz__c(objectType__c=objectName,parameter__c=1,value__c = '__all__',ruleBitArray__c=0));
        lRB.add(new RuleBitz__c(objectType__c=objectName,parameter__c=2,value__c = '__all__',ruleBitArray__c=0));
        lRB.add(new RuleBitz__c(objectType__c=objectName,parameter__c=3,value__c = '__all__',ruleBitArray__c=0));
        insert lRB;

        //4. adding custom fields, one to rule, one to the user skills below
        List<EnginePicklists__c> epks = new List<EnginePicklists__c>();
        epks.add(new EnginePicklists__c(name='R'+objectName+'3',objectName__c=objectName, field__c='SizeBand__c',
                        PickValues1__c='Very Small;Small;Medium;Extra Medium;Large;Oh My Goodness',PickValues2__c=''));
        epks.add(new EnginePicklists__c(name='M'+objectName+'3',objectName__c=objectName, field__c='SizeBand__c',
                        PickValues1__c='Very Small;Small;Medium;Extra Medium;Large;Oh My Goodness',PickValues2__c=''));
        insert epks;
    
    
        //5. adding roster for user fields, reflecting three in use
        InUseRoster__c userRoster = new InUseRoster__c(name='M'+objectName, Bitz__c=7);
        insert userRoster;

        //5. adding roster for user fields, reflecting three in use
        List<UserMatchFields__c> lUMF = new List<UserMatchFields__c>();
        lUMF.add(new UserMatchFields__c(name=objectName+'1',label__c='Industry',type__c='Picklist',path__c='Industry',order__c=1,base__c=objectName));
        lUMF.add(new UserMatchFields__c(name=objectName+'2',label__c='Do Not Call',type__c='Checkbox',path__c='DoNotCall',order__c=2,base__c=objectName));
        lUMF.add(new UserMatchFields__c(name=objectName+'3',label__c='Size Band',type__c='Custom',path__c='SizeBand__c',order__c=3,base__c=objectName));
        insert lUMF;
    }

    public static void setUpData(String objectLabel) {
        List<sObject> insertCollection = new List<sObject>();

        //1.  find two active users
        List<User> activeUsers = [select id, isActive, userType from User where isActive = true and userType = 'Standard' LIMIT 2];

        User u1 = activeUsers.get(0);
        User u2 = activeUsers.get(1);
        if (u2 == null) u2 = u1;

        //2.  create user data
        UserData__c ud1 = new UserData__c(user__c=u1.id,LeadPoints__c=0);
        UserData__c ud2 = new UserData__c(user__c=u2.id,LeadPoints__c=0);

        //3.  create first rule scenario - web leads, skill match on industry
        RuleScenario__c rs1 = new RuleScenario__c(name='Web Leads',ruleobject__c=objectLabel);
        //4.  create second rule scenario - email leads, match state, equitable disty
        RuleScenario__c rs2 = new RuleScenario__c(name='Email Leads',ruleobject__c=objectLabel);

        insertCollection.add(ud1);
        insertCollection.add(ud2);
        insertCollection.add(rs1);
        insertCollection.add(rs2);
        insert insertCollection;

        insertCollection.clear();
        rs1.x2__c='Web';
        rs2.x2__c='Email';
        insertCollection.add(rs1);
        insertCollection.add(rs2);
        update insertCollection;
        insertCollection.clear();

        UserSkill__c us1a = new UserSkill__c(userdata__c=ud1.id,baseObject__c='lead',parameter__c='Industry',paramNumber__c=1,value__c='aaaaaa');
        UserSkill__c us1b = new UserSkill__c(userdata__c=ud1.id,baseObject__c='lead',parameter__c='Industry',paramNumber__c=1,value__c='bbbbbb');
        UserSkill__c us1c = new UserSkill__c(userdata__c=ud1.id,baseObject__c='lead',parameter__c='DoNotCall',paramNumber__c=2,value__c='true');
        UserSkill__c us2a = new UserSkill__c(userdata__c=ud2.id,baseObject__c='lead',parameter__c='Industry',paramNumber__c=1,value__c='cccccc');
        UserSkill__c us2b = new UserSkill__c(userdata__c=ud2.id,baseObject__c='lead',parameter__c='Industry',paramNumber__c=1,value__c='dddddd');
        UserSkill__c us2c = new UserSkill__c(userdata__c=ud2.id,baseObject__c='lead',parameter__c='DoNotCall',paramNumber__c=2,value__c='true');

        Requirement__c rq1a = new Requirement__c(RuleScenario__c=rs1.id, parameter__c='Industry', value__c='$Lead.Industry', paramNumber__c=1, isOnShiftNow__c=false, isMinutesOnShift__c=false);
        
        Requirement__c rq2a = new Requirement__c(RuleScenario__c=rs2.id, parameter__c='Do Not Call', value__c='$Lead.DoNotCall', paramNumber__c=2, isOnShiftNow__c=false, isMinutesOnShift__c=false);
        Scoring__c sc2a = new Scoring__c(RuleScenario__c=rs2.id, parameter__c='Do Not Call', value__c='$Lead.DoNotCall', points__c=1000, paramNumber__c=2, isOnShiftNow__c=false, isMinutesOnShift__c=false);
        Scoring__c sc2b = new Scoring__c(RuleScenario__c=rs2.id, parameter__c='Workload', value__c='', points__c=-10, isOnShiftNow__c=false, isMinutesOnShift__c=false);

        insertCollection.add(us1a);
        insertCollection.add(us1b);
        insertCollection.add(us1c);
        insertCollection.add(us2a);
        insertCollection.add(us2b);
        insertCollection.add(us2c);
        insertCollection.add(rq1a);
        insertCollection.add(rq2a);
        insertCollection.add(sc2a);
        insertCollection.add(sc2b);

        insert insertCollection;
    }

    public static void createLeads() {
        Lead assign1 = new Lead(FirstName='Amelia',LastName='zzTester',Company='zoom 1',LeadSource='Web',Industry='aaaaaa', State='OR', AnnualRevenue=20000, email='test1@hp.com');
        Lead assign2 = new Lead(FirstName='Ava',LastName='zzTester',Company='zoom 2',LeadSource='Web',Industry='dddddd', State='OR', AnnualRevenue=80000, email='test2@hp.com');
        Lead assign3 = new Lead(FirstName='Avery',LastName='zzTester',Company='zoom 3',LeadSource='Email',Industry='aaaaaa', State='OR', AnnualRevenue=110000, email='test3@hp.com');
        Lead assign4 = new Lead(FirstName='Alissa',LastName='zzTester',Company='zoom 4',LeadSource='Email',Industry='cccccc', State='CA', AnnualRevenue=8000000, email='test4@hp.com');
        List<Lead> putTheseIn = new List<Lead>();
        putTheseIn.add(assign1);
        putTheseIn.add(assign2);
        putTheseIn.add(assign3);
        putTheseIn.add(assign4);
        insert putTheseIn;
    }
}