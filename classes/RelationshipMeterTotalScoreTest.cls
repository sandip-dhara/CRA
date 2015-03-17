@isTest(SeeAllData=True)
public class RelationshipMeterTotalScoreTest{

static testMethod void relatioMeter(){

/* Account */
Account acc = TestingSetupDataUtil.createAccount('testRelation501','testHPFSprod5501@hp.com','Customer');
insert acc;
System.assertEquals(acc.Name,'testRelation501');

Opportunity opp = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'testRelationOppty', CloseDate = system.today(),CurrencyIsoCode='AUD');
insert opp;
system.assertEquals(opp.Name, 'testRelationOppty');

Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id);
insert opplan;

List<Relationship_Suite__c> listRelation = new List<Relationship_Suite__c>();

Relationship_Suite__c pick1 = new Relationship_Suite__c(Opportunity_Plan__c=opplan.id,PP_S1__c='1 - Disagree',PP_S2__c='2 - Somewhat Disagree',PP_S3__c='3 - Somewhat Agree',PP_S4__c='4 - Agree',PP_S5__c='1 - Disagree',PP_S6__c='2 - Somewhat Disagree',PP_S7__c='3 - Somewhat Agree',PP_S8__c='4 - Agree',PP_S9__c='1 - Disagree',PP_S10__c='2 - Somewhat Disagree',PP_S11__c='3 - Somewhat Agree',PP_S12__c='4 - Agree');
listRelation.add(pick1);

Relationship_Suite__c pick2 = new Relationship_Suite__c(Opportunity_Plan__c=opplan.id,RM_S1__c='1 - Disagree',RM_S2__c='2 - Somewhat Disagree',RM_S3__c='3 - Somewhat Agree',RM_S4__c='4 - Agree',RM_S5__c='1 - Disagree',RM_S6__c='2 - Somewhat Disagree',RM_S7__c='3 - Somewhat Agree',RM_S8__c='4 - Agree',RM_S9__c='1 - Disagree',RM_S10__c='2 - Somewhat Disagree');
listRelation.add(pick2);
insert listRelation;
update listRelation;

test.startTest();
RelationshipMeterTotalScore.RelationshipMeter(listRelation);
test.stopTest();

}
}