/************************************************************************
Purpose     : Test Class for CSPCompetitorAddExtension
Parameters  : None
Returns     : None
***********************************************************************/
@isTest(SeeAllData=true) 
public class CSPCompetitorAddExtensionTest
    {  
        static testmethod void testCSPCompetitorAddExtension(){
        
        Account acc=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
        insert acc;
        Opportunity opp = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD');
        insert opp;
        Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id);
        insert opplan;

        
        ApexPages.StandardController controller= new ApexPages.StandardController(new Competitive_Sales_Plan__c());
        system.currentPageReference().getParameters().put('OppPlanId',opplan.id);
        system.currentPageReference().getParameters().put('retURL','/apex/');
        
        CSPCompetitorAddExtension cspextention=new CSPCompetitorAddExtension(controller);
        cspextention.getCSP();
        cspextention.initialize();
        cspextention.Save();
        cspextention.cancel();
        
        }
     }