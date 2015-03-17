/************************************************************************
Purpose     : Test Class for CSPAddCompetitor
Parameters  : None
Returns     : None
***********************************************************************/
@isTest(SeeAllData=true) 
public class CSPAddCompetitorTest
    {  
        static testmethod void testCSPAddCompetitor(){
        Account acc=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
        insert acc;
        Opportunity opp = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD');
        insert opp;
        Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id);
        insert opplan;
        Competitors__c competator=new Competitors__c(Opportunity__c=opp.id,Primary__c=true);
        insert competator;
        
        ApexPages.StandardController controller= new ApexPages.StandardController(new Competitive_Sales_Plan__c());
        system.currentPageReference().getParameters().put('oppPlanId',opplan.id);
        system.currentPageReference().getParameters().put('oppId',opp.id);
        
        CSPAddCompetitor cspcomptetior=new CSPAddCompetitor(controller);
        cspcomptetior.getCompetitors();
        cspcomptetior.addCompetitor();
        cspcomptetior.goBack();
        }
    }